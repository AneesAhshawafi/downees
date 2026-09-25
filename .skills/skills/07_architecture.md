# 🏗️ SKILL-07: Software Architecture

> **Domain:** System Design, Architecture Patterns, Scalability, Resilience  
> **Level:** Expert / Principal  
> **Scope:** Architecture design, patterns selection, technology decisions, scalability, performance, cost optimization

---

## 1. PHILOSOPHY

Architecture is the **art of making trade-offs** under uncertainty.
- There is no perfect architecture — only appropriate architecture for context
- Every decision is a trade-off: performance vs. cost, consistency vs. availability, complexity vs. maintainability
- Architecture emerges — it is both planned and evolved
- The best architecture is the one that enables the team to deliver value quickly and sustainably

---

## 2. ARCHITECTURE DESIGN PROCESS

### 2.1 Architecture Decision Record (ADR)
```
TEMPLATE:
# ADR-XXX: [Short Title]

## Status
Proposed / Accepted / Deprecated / Superseded by ADR-YYY

## Context
[What is the issue we're deciding? Business and technical drivers.]

## Decision
[What we decided — clear, specific.]

## Consequences
### Positive
- [Benefit 1]
- [Benefit 2]

### Negative
- [Trade-off 1]
- [Trade-off 2]

### Risks
- [Risk and mitigation]

## Alternatives Considered
### Alternative 1: [Name]
- Pros: ...
- Cons: ...
- Why rejected: ...

## Compliance
[How we verify this decision is followed]

## Notes
[References, discussions, links]
```

### 2.2 Architecture Design Steps
```
1. UNDERSTAND
   ├── Business context and goals
   ├── Constraints (budget, time, team, compliance)
   ├── Quality attributes (performance, security, scalability)
   ├── Stakeholder concerns
   └── Risk tolerance

2. EXPLORE
   ├── Research existing solutions
   ├── Identify patterns and anti-patterns
   ├── Evaluate technology options
   └── Consider future evolution

3. MODEL
   ├── Create conceptual architecture
   ├── Define components and responsibilities
   ├── Identify interfaces and contracts
   ├── Map data flows
   └── Establish trust boundaries

4. EVALUATE
   ├── Apply quality attribute scenarios
   ├── Perform trade-off analysis (ATAM)
   ├── Identify risks and mitigations
   ├── Estimate costs (development, operational)
   └── Validate with stakeholders

5. DOCUMENT
   ├── Architecture overview
   ├── Component diagrams
   ├── Sequence diagrams
   ├── Data models
   ├── Deployment architecture
   ├── ADRs
   └── Runbooks

6. VALIDATE
   ├── Prototype critical paths
   ├── Load test assumptions
   ├── Security review
   ├── Team review and feedback
   └── Iterate based on learnings
```

---

## 3. ARCHITECTURAL PATTERNS

### 3.1 Monolithic vs. Microservices vs. Modular Monolith

```
MONOLITH:
Pros:
├── Simple development and deployment
├── Easy testing (single codebase)
├── Strong consistency
├── Lower operational complexity
├── Better performance (in-process calls)
└── Simpler debugging

Cons:
├── Technology lock-in
├── Scaled as whole (inefficient)
├── Large codebase (cognitive load)
├── Risky deployments (all or nothing)
├── Team coordination challenges
└── Long build times

Best for: Small teams, early-stage products, simple domains

MICROSERVICES:
Pros:
├── Independent deployment
├── Technology diversity per service
├── Scaled independently
├── Team autonomy
├── Fault isolation
└── Easier refactoring of single service

Cons:
├── Distributed system complexity
├── Network latency and failures
├── Data consistency challenges
├── Operational overhead (monitoring, logging, tracing)
├── Testing complexity (integration)
├── Requires DevOps maturity
└── Initial development slower

Best for: Large teams, complex domains, need for independent scaling

MODULAR MONOLITH:
Pros:
├── Clear module boundaries (future extraction)
├── Single deployment (simplicity)
├── In-process performance
├── Easier refactoring than classic monolith
└── Gradual migration path to microservices

Cons:
├── Discipline required to maintain boundaries
├── Still single deployment unit
└── Technology homogeneity

Best for: Medium teams, preparing for scale, domain complexity growing
```

### 3.2 Common Architectural Patterns

#### Layered Architecture (N-Tier)
```
Presentation Layer
    ↓
Business Logic Layer
    ↓
Data Access Layer
    ↓
Database Layer

Rules:
├── Lower layers don't know about upper layers
├── Each layer has specific responsibility
├── Changes in one layer shouldn't cascade
└── Use DTOs between layers
```

#### Clean Architecture / Hexagonal Architecture (Ports & Adapters)
```
                    External Interfaces
                           │
        ┌──────────────────┼──────────────────┐
        │    Adapters      │    Adapters      │
        │  (Controllers,   │  (Repositories,  │
        │   Presenters)    │   External Svcs) │
        └────────┬─────────┴────────┬─────────┘
                 │                  │
        ┌────────┴──────────────────┴────────┐
        │     Application Services (Use Cases)│
        └────────┬──────────────────┬─────────┘
                 │                  │
        ┌────────┴──────────────────┴────────┐
        │         Domain Entities & Logic      │
        │    (No dependencies on frameworks)   │
        └──────────────────────────────────────┘

Dependency Rule: Dependencies point inward (Domain is center)
```

#### Event-Driven Architecture
```
PUBLISHER → Event Bus → SUBSCRIBER(s)

Patterns:
├── Event Notification: Lightweight, subscriber queries for details
├── Event-Carried State Transfer: Event contains full state
├── Event Sourcing: State derived from event log
└── CQRS: Separate read and write models

Benefits:
├── Loose coupling
├── Scalability
├── Extensibility (new subscribers without changes)
└── Audit trail (with event sourcing)

Challenges:
├── Eventual consistency
├── Event schema evolution
├── Debugging complexity
├── Ordering and delivery guarantees
└── Message duplication handling
```

#### CQRS (Command Query Responsibility Segregation)
```
WRITE SIDE                    READ SIDE
Command → Aggregate → Event Store → Projection → Query → Read Model
                ↓
         Event Bus → Materialized Views (optimized for queries)

When to use:
├── Read/write load asymmetry
├── Different data models for reads and writes
├── Event sourcing paired with CQRS
├── Complex query requirements
└── Multiple read models needed

When NOT to use:
├── Simple CRUD applications
├── Strong consistency required for reads
├── Small team without distributed systems experience
└── No clear performance bottleneck
```

#### Saga Pattern (Distributed Transactions)
```
ORCHESTRATION:
Orchestrator → Command → Service A → Event → Orchestrator
                                    → Command → Service B → Event → Orchestrator

CHOREOGRAPHY:
Service A → Event → Service B → Event → Service C → Event → ...

Compensating Transactions:
If step N fails, execute compensating actions for steps 1..N-1

Example (Order → Payment → Shipping):
├── Order created
├── Payment processed
├── Shipping failed → Compensate: refund payment, cancel order
```

#### Circuit Breaker
```
CLOSED: Normal operation, requests pass through
  │
  ├── Failure threshold exceeded
  ↓
OPEN: Requests fail fast, no call to service
  │
  ├── Timeout period passes
  ↓
HALF-OPEN: Test request allowed
  │
  ├── Success → CLOSED
  └── Failure → OPEN

Benefits:
├── Prevents cascade failures
├── Allows failing service to recover
├── Fast failure (better UX than timeout)
└── Monitoring and alerting integration
```

#### Bulkhead
```
Isolate failures by partitioning resources:
├── Thread pools per service/client
├── Connection pools per dependency
├── Separate process pools
└── Resource quotas

Example:
Service A gets 100 threads
Service B gets 100 threads
If Service A exhausts threads, Service B unaffected
```

#### Strangler Fig Pattern
```
Migrate from monolith to microservices incrementally:

[Client] → [Router/Facade]
              ├──→ [New Service A]
              ├──→ [New Service B]
              └──→ [Legacy Monolith] (remaining functionality)

Gradually:
1. Route new features to new services
2. Extract existing features one by one
3. Legacy monolith shrinks
4. Eventually, monolith is "strangled" and removed
```

---

## 4. SCALABILITY PATTERNS

### 4.1 Horizontal vs. Vertical Scaling
```
VERTICAL (Scale Up):
├── Bigger machine (more CPU, RAM)
├── Simple (no architecture changes)
├── Limited (hardware ceiling)
├── Single point of failure
└── Expensive at high end

HORIZONTAL (Scale Out):
├── More machines
├── Complex (load balancing, statelessness)
├── Near-unlimited
├── Fault tolerant
└── Cost-effective at scale

PREFERENCE: Horizontal for web/apps, Vertical for databases (then shard)
```

### 4.2 Database Scaling
```
READ SCALING:
├── Primary-Replica (1 write, N read replicas)
├── Read replicas for analytics
├── Connection pooling
└── Query optimization

WRITE SCALING:
├── Sharding (partition data across servers)
├── Consistent hashing for shard distribution
├── Shard rebalancing
└── Cross-shard queries (avoid if possible)

CACHING:
├── Application cache (Redis, Memcached)
├── CDN for static content
├── Database query cache
├── ORM second-level cache
└── Cache invalidation strategies (TTL, event-based)

ASYNC PROCESSING:
├── Message queues for write-heavy operations
├── Background job processing
├── Event-driven updates
└── CQRS for read/write separation
```

### 4.3 Caching Strategies
```
CACHE-ASIDE (Lazy Loading):
├── App checks cache first
├── If miss, load from DB and populate cache
├── Pros: Simple, cache only what's needed
└── Cons: Initial miss penalty, stale data

READ-THROUGH:
├── App always reads from cache
├── Cache loads from DB on miss
├── Pros: Transparent to app
└── Cons: Cache provider dependency

WRITE-THROUGH:
├── App writes to cache
├── Cache synchronously writes to DB
├── Pros: Strong consistency
└── Cons: Write latency

WRITE-BEHIND (Write-Back):
├── App writes to cache
├── Cache asynchronously writes to DB
├── Pros: Fast writes, batch DB updates
└── Cons: Data loss risk if cache fails

INVALIDATION:
├── TTL (Time To Live)
├── Explicit invalidation on update
├── Event-driven invalidation
└── Cache warming (pre-populate)
```

---

## 5. RESILIENCE PATTERNS

### 5.1 Retry with Exponential Backoff
```
Attempt 1: Immediate
Attempt 2: Wait 1s
Attempt 3: Wait 2s
Attempt 4: Wait 4s
Attempt 5: Wait 8s
Max wait: Cap at e.g., 60s
Max attempts: e.g., 5

JITTER: Add randomness to prevent thundering herd
  Wait = min(cap, base * 2^attempt) + random(0, jitter)
```

### 5.2 Timeout Patterns
```
├── Connection timeout (e.g., 5s)
├── Request timeout (e.g., 30s)
├── Circuit breaker timeout (e.g., 60s)
└── Global timeout (e.g., 120s for user request)

DEADLINE PROPAGATION:
├── Client sets deadline (e.g., 5s total)
├── Each service deducts elapsed time
├── Service fails fast if insufficient time remains
└── Prevents wasted work
```

### 5.3 Graceful Degradation
```
FULL FUNCTIONALITY → DEGRADED → MINIMAL → FAILSAFE

Examples:
├── E-commerce: Show cached prices if pricing service down
├── Social feed: Show static content if real-time fails
├── Search: Show popular items if search engine unavailable
├── Recommendations: Show trending if personalization fails
└── Maps: Show cached tiles if live tiles fail
```

### 5.4 Health Checks
```
LIVENESS: Is the process running?
  ├── Simple: HTTP 200 on /health/live
  └── Kubernetes: kubelet restarts if failing

READINESS: Is the service ready to accept traffic?
  ├── DB connection available
  ├── Required services reachable
  ├── Warm-up complete
  └── Kubernetes: removes from load balancer if failing

STARTUP: Has the service finished starting?
  ├── For slow-starting services
  └── Prevents premature liveness/readiness checks
```

---

## 6. DATA ARCHITECTURE

### 6.1 Database Selection Guide
```
RELATIONAL (PostgreSQL, MySQL, SQL Server):
├── ACID transactions
├── Complex queries and joins
├── Strong consistency
├── Mature tooling
└── Best for: Financial, inventory, structured data

DOCUMENT (MongoDB, Couchbase, DynamoDB):
├── Flexible schema
├── Horizontal scaling
├── JSON-like documents
├── Rapid development
└── Best for: Content management, catalogs, user profiles

KEY-VALUE (Redis, DynamoDB, Riak):
├── Ultra-fast lookups
├── Simple operations
├── Caching layer
└── Best for: Sessions, caching, real-time features

WIDE-COLUMN (Cassandra, HBase, Bigtable):
├── Massive scale
├── High write throughput
├── Time-series data
└── Best for: IoT, logging, metrics

GRAPH (Neo4j, Amazon Neptune):
├── Relationship-heavy data
├── Complex traversals
├── Pattern matching
└── Best for: Social networks, fraud detection, recommendations

SEARCH (Elasticsearch, Solr, OpenSearch):
├── Full-text search
├── Faceted search
├── Aggregations
└── Best for: Product search, log analysis, analytics

TIME-SERIES (InfluxDB, TimescaleDB, Prometheus):
├── Optimized for time-stamped data
├── High ingestion rates
├── Efficient aggregation
└── Best for: Metrics, monitoring, IoT sensors
```

### 6.2 CAP Theorem
```
Consistency: All nodes see same data at same time
Availability: Every request gets a response
Partition Tolerance: System continues despite network failures

THEOREM: In a distributed system, you can only guarantee 2 of 3.

CHOICES:
├── CP (Consistency + Partition Tolerance): MongoDB, HBase, Redis Cluster
├── AP (Availability + Partition Tolerance): Cassandra, DynamoDB, Couchbase
└── CA (Consistency + Availability): Single-node RDBMS (not distributed)

PRACTICAL APPROACH:
├── Default to CP for critical data (financial, inventory)
├── Use AP for scalable reads (social feeds, analytics)
├── Design for partition tolerance (it's not optional in distributed systems)
└── Use BASE (Basically Available, Soft state, Eventually consistent) when appropriate
```

---

## 7. API DESIGN

### 7.1 RESTful API Best Practices
```
RESOURCES:
├── Use nouns, not verbs: /users, not /getUsers
├── Hierarchical: /users/{id}/orders
├── Plural nouns: /orders, not /order
└── Lowercase with hyphens: /order-items

HTTP METHODS:
├── GET: Read (idempotent, safe)
├── POST: Create
├── PUT: Full update (idempotent)
├── PATCH: Partial update
├── DELETE: Remove (idempotent)
└── HEAD, OPTIONS: Metadata

STATUS CODES:
├── 2xx: Success (200 OK, 201 Created, 204 No Content)
├── 3xx: Redirection (301 Moved, 304 Not Modified)
├── 4xx: Client Error (400 Bad Request, 401 Unauthorized, 403 Forbidden, 404 Not Found, 409 Conflict, 422 Unprocessable)
└── 5xx: Server Error (500 Internal, 502 Bad Gateway, 503 Service Unavailable, 504 Gateway Timeout)

VERSIONING:
├── URL: /v1/users, /v2/users
├── Header: Accept: application/vnd.api.v2+json
├── Parameter: ?version=2
└── NEVER break existing clients

PAGINATION:
├── Offset-based: ?page=2&limit=20
├── Cursor-based: ?cursor=abc123&limit=20 (better for large datasets)
├── Include: total count, current page, next/prev links
└── Max limit enforcement (e.g., 100)

FILTERING/SORTING:
├── ?status=active&role=admin
├── ?sort=-created_at (minus for descending)
├── ?fields=id,name,email (sparse fieldsets)
└── ?include=orders,profile (relationship expansion)
```

### 7.2 GraphQL Considerations
```
PROS:
├── Client-specified queries
├── Single endpoint
├── Strong typing
├── Reduced over-fetching
└── Introspection

CONS:
├── Query complexity attacks (depth limiting, cost analysis)
├── Caching challenges
├── File upload complexity
├── N+1 query risk (DataLoader pattern)
└── Learning curve

SECURITY:
├── Query depth limiting (max 10 levels)
├── Query complexity scoring (reject expensive queries)
├── Timeout limits
├── Rate limiting per query complexity
└── Persisted queries for production
```

---

## 8. TECHNOLOGY DECISION FRAMEWORK

### 8.1 Technology Evaluation Matrix
```
CRITERIA (weight by project):
├── Maturity (community, enterprise adoption)
├── Team expertise (learning curve)
├── Performance (latency, throughput)
├── Scalability (horizontal, vertical)
├── Security (track record, CVEs)
├── Ecosystem (libraries, tools, integrations)
├── Cost (licensing, infrastructure, staffing)
├── Vendor lock-in (migration path)
├── Documentation quality
├── Support (community, commercial)
└── Future roadmap (active development)

SCORING:
Each criterion: 1-5 (poor to excellent)
Weighted average = Σ(score × weight) / Σ(weights)
```

---

**[END OF SKILL-07]**
