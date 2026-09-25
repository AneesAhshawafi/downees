# 📋 SKILL-14: Requirements Engineering

> **Domain:** Requirements Elicitation, Analysis, Specification, Traceability, Validation  
> **Level:** Expert / Principal  
> **Scope:** All requirement types — FR, NFR, user, system, feature, quality, security, integration, stability, business requirements & rules

---

## 1. PHILOSOPHY

Requirements are not documents — they are **shared understanding**.
- The hardest part of software is not coding — it is figuring out what to build
- A requirement that cannot be tested is not a requirement
- Ambiguity in requirements becomes conflict in code
- Requirements change — the question is whether we manage change or fight it
- Every requirement is a promise; every promise needs a way to verify it

---

## 2. REQUIREMENTS CLASSIFICATION

### 2.1 Requirement Types Hierarchy
```
REQUIREMENTS
├── Business Requirements (WHY)
│   ├── Business Objectives
│   ├── Business Rules
│   ├── Constraints (budget, time, regulatory)
│   └── Success Criteria
│
├── User Requirements (WHO & WHAT for users)
│   ├── User Stories
│   ├── Use Cases
│   ├── User Scenarios
│   └── User Personas
│
├── Functional Requirements (WHAT the system does)
│   ├── Feature Requirements
│   ├── System Functions
│   ├── Data Requirements
│   └── Interface Requirements
│
├── Non-Functional Requirements (HOW WELL)
│   ├── Quality Attribute Requirements
│   │   ├── Performance
│   │   ├── Security
│   │   ├── Reliability
│   │   ├── Usability
│   │   ├── Maintainability
│   │   ├── Scalability
│   │   └── Portability
│   ├── Constraints
│   │   ├── Technical constraints
│   │   ├── Business constraints
│   │   └── Regulatory constraints
│   └── Compliance Requirements
│
├── System Requirements (HOW the system works)
│   ├── Hardware Requirements
│   ├── Software Requirements
│   ├── Network Requirements
│   └── Integration Requirements
│
└── Transition Requirements (HOW to get there)
    ├── Data Migration
    ├── Training
    ├── Cutover Strategy
    └── Rollback Plan
```

---

## 3. REQUIREMENTS ELICITATION

### 3.1 Elicitation Techniques
```
INTERVIEWS:
├── Structured: Predefined questions
├── Unstructured: Open conversation
├── Focused: Specific topic deep-dive
├── Stakeholder: One-on-one with decision makers
├── User: Understanding real needs
└── Expert: Domain knowledge transfer

WORKSHOPS:
├── Joint Application Design (JAD)
├── Requirements workshop
├── Brainstorming session
├── Story mapping
├── Design thinking sprint
└── Prototype review

OBSERVATION:
├── Shadowing users in their environment
├── Contextual inquiry
├── Ethnographic study
├── Process observation
└── Task analysis

DOCUMENT ANALYSIS:
├── Existing system documentation
├── Business process documentation
├── Regulatory documents
├── Market research
├── Competitor analysis
└── Industry standards

PROTOTYPING:
├── Low-fidelity (paper sketches, wireframes)
├── Medium-fidelity (clickable mockups)
├── High-fidelity (interactive prototypes)
├── Proof of concept (technical feasibility)
└── Throwaway vs. evolutionary

SURVEYS & QUESTIONNAIRES:
├── Large sample size
├── Quantitative data
├── User satisfaction
├── Feature prioritization
└── Market validation
```

### 3.2 Stakeholder Analysis
```
STAKEHOLDER REGISTER:
├── Name and Role
├── Influence (Power): High / Medium / Low
├── Interest: High / Medium / Low
├── Attitude: Supportive / Neutral / Resistant
├── Communication Needs
├── Key Concerns
└── Requirements Priority

STAKEHOLDER CATEGORIES:
├── Primary Users: Direct system users
├── Secondary Users: Occasional or indirect users
├── Beneficiaries: Those who gain value
├── Decision Makers: Approve budget and scope
├── Influencers: Technical experts, advisors
├── Regulators: Compliance and legal
├── Operations: Support and maintenance
└── Development Team: Those who build it
```

---

## 4. FUNCTIONAL REQUIREMENTS (FR)

### 4.1 User Story Format
```
TEMPLATE:
As a [type of user],
I want [some goal],
So that [some reason/benefit].

ACCEPTANCE CRITERIA (Given-When-Then):
Given [context/precondition],
When [action/event],
Then [expected outcome].

EXAMPLE:
As a registered customer,
I want to reset my password via email,
So that I can regain access if I forget it.

Acceptance Criteria:
1. Given a valid email address, when user requests password reset,
   then a reset link is sent within 60 seconds.
2. Given an invalid email format, when user submits,
   then an error message is displayed without revealing if email exists.
3. Given a valid reset token, when user sets new password,
   then password is updated and user is logged in automatically.
4. Given an expired reset token (>24h), when user attempts reset,
   then an error is shown and user must request new link.
```

### 4.2 Use Case Specification
```
USE CASE: [Name]
ACTOR: [Primary actor]
PRECONDITIONS: [What must be true before]
POSTCONDITIONS: [What is true after]

MAIN FLOW:
1. [Step 1]
2. [Step 2]
3. [Step 3]
   ...

ALTERNATIVE FLOWS:
3a. [Alternative at step 3]
   3a.1. [Sub-step]
   3a.2. [Sub-step]

EXCEPTION FLOWS:
3e. [Error at step 3]
   3e.1. [Error handling]
   3e.2. [Recovery]

BUSINESS RULES:
├── [Rule 1]
└── [Rule 2]
```

### 4.3 Feature Requirements Template
```
FEATURE: [Feature Name]
FEATURE ID: FEAT-[PROJECT]-[NUMBER]
PRIORITY: [Must Have / Should Have / Could Have / Won't Have]
EFFORT: [Story Points / Person-Days]

DESCRIPTION:
[Clear, concise description of what the feature does]

USER VALUE:
[Why this feature matters to users and business]

FUNCTIONAL REQUIREMENTS:
├── FR-1: [Specific function]
├── FR-2: [Specific function]
└── FR-3: [Specific function]

NON-FUNCTIONAL REQUIREMENTS:
├── NFR-1: [Performance/security/usability requirement]
└── NFR-2: [Performance/security/usability requirement]

DEPENDENCIES:
├── [Other features or systems required]

ACCEPTANCE CRITERIA:
├── [Testable criteria 1]
├── [Testable criteria 2]
└── [Testable criteria 3]

UI/UX NOTES:
├── [Design references, mockups, interactions]

DATA REQUIREMENTS:
├── [Data models, fields, validations]

INTEGRATION POINTS:
├── [APIs, services, third-party systems]

OUT OF SCOPE:
├── [Explicitly what is NOT included]
```

---

## 5. NON-FUNCTIONAL REQUIREMENTS (NFR)

### 5.1 Performance Requirements
```
RESPONSE TIME:
├── Page load: < 2 seconds (p95)
├── API response: < 500ms (p95)
├── Database query: < 100ms (p99)
├── Search results: < 1 second
└── File upload: < 5 seconds per 10MB

THROUGHPUT:
├── Concurrent users: 10,000
├── Requests per second: 1,000
├── Transactions per second: 500
└── Data ingestion: 10,000 events/second

SCALABILITY:
├── Horizontal scaling: Add nodes to handle 10x load
├── Auto-scaling: Trigger at 70% CPU
├── Database: Support 100M records without performance degradation
└── Storage: 10TB with 20% annual growth

AVAILABILITY:
├── Uptime: 99.9% (8.76 hours downtime/year)
├── Recovery Time Objective (RTO): < 15 minutes
├── Recovery Point Objective (RPO): < 5 minutes
└── Maintenance windows: < 4 hours/month, scheduled
```

### 5.2 Security Requirements
```
AUTHENTICATION:
├── Multi-factor authentication (MFA) for admin accounts
├── Password policy: min 12 chars, complexity, rotation 90 days
├── Session timeout: 30 minutes idle, 8 hours absolute
├── Account lockout: 5 failed attempts, 30-minute lockout
└── Password reset: Token-based, single-use, 24-hour expiry

AUTHORIZATION:
├── Role-Based Access Control (RBAC)
├── Principle of least privilege
├── Resource-level permissions
├── API rate limiting: 100 requests/minute per user
└── Admin actions require re-authentication

DATA PROTECTION:
├── Encryption at rest: AES-256
├── Encryption in transit: TLS 1.2+
├── PII masking in logs
├── Data retention: 7 years for transactions, 1 year for logs
├── Secure deletion: NIST 800-88 compliant
└── Backup encryption

AUDIT:
├── Log all authentication events
├── Log all authorization decisions
├── Log all data modifications
├── Log retention: 1 year minimum
├── Tamper-proof log storage
└── Real-time alerting for security events

COMPLIANCE:
├── GDPR: Data subject rights, consent, breach notification
├── SOC 2: Security, availability, confidentiality
├── PCI DSS: If handling payment data
├── HIPAA: If handling health data
└── Industry-specific requirements
```

### 5.3 Usability Requirements
```
ACCESSIBILITY:
├── WCAG 2.1 Level AA compliance
├── Screen reader compatible
├── Keyboard navigation for all functions
├── Color contrast: 4.5:1 minimum
├── Text resizing: 200% without loss of function
└── Closed captions for all video content

LEARNABILITY:
├── New user onboarding: < 5 minutes to first success
├── Contextual help available on every screen
├── Tooltips for all icons and abbreviations
├── Progressive disclosure (advanced features hidden)
└── Consistent navigation across all modules

EFFICIENCY:
├── Expert user task completion: < 30 seconds for common tasks
├── Keyboard shortcuts for all frequent actions
├── Bulk operations for repetitive tasks
├── Auto-save every 30 seconds
└── Smart defaults based on user history

SATISFACTION:
├── System Usability Scale (SUS) score > 80
├── Net Promoter Score (NPS) > 50
├── Customer Effort Score (CES) < 2 (on 1-7 scale)
└── Error rate: < 2% for common tasks
```

### 5.4 Reliability & Stability Requirements
```
FAULT TOLERANCE:
├── Graceful degradation: Core features work if non-critical services fail
├── Circuit breaker: Open after 5 consecutive failures
├── Retry logic: 3 attempts with exponential backoff
├── Timeout: All external calls timeout within 10 seconds
└── Fallback: Cached data served if real-time unavailable

RECOVERY:
├── Automated failover: < 30 seconds
├── Database failover: < 60 seconds
├── Data replication: Real-time across availability zones
├── Backup frequency: Hourly incremental, daily full
├── Backup retention: 30 days
└── Disaster recovery test: Quarterly

STABILITY:
├── Mean Time Between Failures (MTBF): > 720 hours
├── Mean Time To Recovery (MTTR): < 15 minutes
├── Zero-downtime deployments
├── Database migrations: Backward compatible
├── API versioning: Support previous version for 6 months
└── Feature flags: Enable/disable without deployment
```

### 5.5 Integration Requirements
```
API REQUIREMENTS:
├── RESTful API with OpenAPI 3.0 specification
├── JSON request/response format
├── Authentication: OAuth 2.0 + JWT
├── Rate limiting: 1000 requests/hour per API key
├── Pagination: Cursor-based for large datasets
├── Versioning: URL-based (/v1/, /v2/)
├── Error format: RFC 7807 (Problem Details)
└── Webhook support for async notifications

DATA INTEGRATION:
├── Real-time sync: < 5 seconds latency
├── Batch sync: Daily at 2 AM UTC
├── Data format: JSON, CSV, XML (configurable)
├── Conflict resolution: Last-write-wins with audit log
├── Schema evolution: Backward compatible changes
└── Error handling: Dead letter queue for failed records

THIRD-PARTY INTEGRATIONS:
├── Payment gateway: Stripe, PayPal
├── Email service: SendGrid, AWS SES
├── SMS service: Twilio
├── Analytics: Google Analytics, Mixpanel
├── CRM: Salesforce, HubSpot
└── SLA: 99.9% uptime for critical integrations
```

---

## 6. BUSINESS REQUIREMENTS

### 6.1 Business Requirements Document (BRD)
```
EXECUTIVE SUMMARY:
├── Problem statement
├── Proposed solution
├── Expected benefits
└── Investment required

BUSINESS OBJECTIVES:
├── Objective 1: [SMART objective]
│   ├── Metric: [How measured]
│   ├── Target: [Specific number]
│   └── Timeline: [By when]
├── Objective 2: [SMART objective]
└── ...

BUSINESS RULES:
├── Rule ID: BR-001
├── Rule Name: [Descriptive name]
├── Description: [Clear statement]
├── Source: [Policy, regulation, business decision]
├── Enforcement: [System / Manual / Both]
└── Example: "Orders over $10,000 require manager approval"

CONSTRAINTS:
├── Budget: $[Amount]
├── Timeline: [Start] to [End]
├── Regulatory: [Applicable regulations]
├── Technical: [Existing systems, standards]
└── Resource: [Team size, skills required]

SUCCESS CRITERIA:
├── Business KPI 1: [Metric, target, measurement method]
├── Business KPI 2: [Metric, target, measurement method]
└── ...

RISKS:
├── Risk 1: [Description, probability, impact, mitigation]
└── ...
```

### 6.2 Business Rules Catalog
```
RULE TEMPLATE:
Rule ID: BR-[CATEGORY]-[NUMBER]
Category: [Validation / Calculation / Authorization / Workflow / Data]
Name: [Short name]
Description: [Full description]
Trigger: [When does this rule apply]
Condition: [Under what conditions]
Action: [What happens]
Exception: [Any exceptions]
Owner: [Business owner]
System: [Which system enforces]
Priority: [Critical / High / Medium / Low]
Status: [Active / Draft / Deprecated]

EXAMPLES:
BR-VAL-001: Email Format Validation
├── Trigger: User submits registration form
├── Condition: Email field is not empty
├── Action: Validate format using RFC 5322 regex
├── Exception: None
└── System: Registration Service

BR-CAL-001: Discount Calculation
├── Trigger: Order total calculated
├── Condition: Customer has VIP status AND order > $500
├── Action: Apply 15% discount
├── Exception: Discount not applicable to gift cards
└── System: Pricing Engine

BR-AUTH-001: Approval Workflow
├── Trigger: Purchase order submitted
├── Condition: Order value > $10,000
├── Action: Route to department manager for approval
├── Exception: Pre-approved vendors bypass approval
└── System: Workflow Engine
```

---

## 7. REQUIREMENTS SPECIFICATION

### 7.1 Software Requirements Specification (SRS)
```
DOCUMENT STRUCTURE (IEEE 830):
1. Introduction
   ├── Purpose
   ├── Scope
   ├── Definitions and Acronyms
   ├── References
   └── Overview

2. Overall Description
   ├── Product Perspective
   ├── Product Functions
   ├── User Characteristics
   ├── Constraints
   ├── Assumptions and Dependencies
   └── Apportioning of Requirements

3. Specific Requirements
   ├── External Interface Requirements
   │   ├── User Interfaces
   │   ├── Hardware Interfaces
   │   ├── Software Interfaces
   │   └── Communication Interfaces
   ├── Functional Requirements
   ├── Performance Requirements
   ├── Design Constraints
   ├── Software System Attributes
   │   ├── Reliability
   │   ├── Availability
   │   ├── Security
   │   ├── Maintainability
   │   └── Portability
   └── Other Requirements

4. Appendices
   ├── Data Dictionary
   ├── Analysis Models
   ├── Traceability Matrix
   └── Issues List
```

### 7.2 Requirements Quality Checklist
```
CORRECT:
├── Accurately represents stakeholder needs
├── Free of errors
└── Technically feasible

UNAMBIGUOUS:
├── One interpretation only
├── Defined terms used consistently
└── No vague words ("user-friendly", "fast", "many")

COMPLETE:
├── All necessary requirements included
├── Responses to all inputs defined
├── TBD items identified with resolution dates
└── No missing sections

CONSISTENT:
├── No contradictions between requirements
├── Terminology consistent throughout
├── No conflicts with other requirements
└── No conflicts with external documents

RANKED FOR IMPORTANCE:
├── Each requirement has priority
├── Prioritization method documented
└── Stakeholder agreement on priorities

VERIFIABLE:
├── Each requirement is testable
├── Acceptance criteria defined
├── Measurement method specified
└── No untestable requirements

MODIFIABLE:
├── Organized structure
├── Unique identifiers
├── Cross-references managed
└── Change history maintained

TRACEABLE:
├── Each requirement has unique ID
├── Backward traceability to source
├── Forward traceability to design, code, tests
└── Traceability matrix maintained
```

---

## 8. REQUIREMENTS TRACEABILITY

### 8.1 Traceability Matrix
```
                    Requirements    Design    Code    Tests    Release
REQ-001: Login      │      ✓      │   ✓    │   ✓   │    ✓   │    ✓
REQ-002: Search     │      ✓      │   ✓    │   ✓   │    ✓   │    ✓
REQ-003: Payment    │      ✓      │   ✓    │   ✓   │    ✓   │    ✓
REQ-004: Report     │      ✓      │   ✓    │   ✓   │    ✓   │    ✗

TYPES OF TRACEABILITY:
├── Forward: Requirement → Design → Code → Test
├── Backward: Test → Code → Design → Requirement
├── Bidirectional: Both directions
└── Cross-functional: Requirement → Business Rule → Compliance

BENEFITS:
├── Impact analysis (what's affected by a change?)
├── Coverage analysis (are all requirements tested?)
├── Audit compliance
├── Regression scope identification
└── Release readiness assessment
```

### 8.2 Traceability Tools
```
SPREADSHEET (Simple):
├── Excel/Google Sheets
├── Manual updates
├── Suitable for small projects
└── Risk of becoming stale

ALM TOOLS (Enterprise):
├── Jira + Xray/TestRail
├── Azure DevOps
├── IBM Engineering Requirements Management DOORS
├── Jama Connect
└── Automated traceability

CUSTOM SOLUTIONS:
├── Database-driven traceability
├── Git-based (requirements as code)
├── Markdown with cross-references
└── CI/CD integrated validation
```

---

## 9. REQUIREMENTS VALIDATION

### 9.1 Validation Techniques
```
REQUIREMENTS REVIEWS:
├── Informal review: Peer walkthrough
├── Formal inspection: Structured process with roles
├── Stakeholder review: Business validation
├── Technical review: Feasibility assessment
└── Checklist-based review

PROTOTYPING:
├── Low-fidelity: Paper sketches
├── Medium-fidelity: Clickable wireframes
├── High-fidelity: Interactive mockups
├── Proof of concept: Technical feasibility
└── User testing with prototypes

MODEL VALIDATION:
├── Data flow diagrams
├── State machine diagrams
├── Sequence diagrams
├── Entity-relationship diagrams
└── Prototype models

TEST CASE GENERATION:
├── Generate tests from requirements
├── Identify missing requirements (no tests = gap?)
├── Boundary value analysis
├── Equivalence partitioning
└── State transition testing
```

### 9.2 Validation Checklist
```
FUNCTIONAL VALIDATION:
├── Are all user needs addressed?
├── Are use cases complete?
├── Are all inputs and outputs defined?
├── Are error conditions specified?
├── Are business rules documented?
└── Are calculations/formulas correct?

NON-FUNCTIONAL VALIDATION:
├── Are performance targets realistic?
├── Are security requirements adequate?
├── Are accessibility standards specified?
├── Are compliance requirements complete?
├── Are scalability needs quantified?
└── Are reliability targets achievable?

QUALITY VALIDATION:
├── Are requirements unambiguous?
├── Are requirements testable?
├── Are priorities clear?
├── Are dependencies identified?
├── Are constraints documented?
└── Is scope clearly defined?
```

---

## 10. REQUIREMENTS CHANGE MANAGEMENT

### 10.1 Change Control Process
```
1. IDENTIFY
   ├── Change request submitted
   ├── Source: Stakeholder, team, market, regulation
   └── Document: What, why, who, when

2. ANALYZE
   ├── Impact on scope, schedule, budget
   ├── Impact on other requirements
   ├── Technical feasibility
   ├── Risk assessment
   └── Alternatives considered

3. DECIDE
   ├── Approve: Accept change, update baseline
   ├── Defer: Move to future release
   ├── Reject: Document reason
   └── Escalate: Beyond project authority

4. IMPLEMENT
   ├── Update requirements document
   ├── Update traceability matrix
   ├── Communicate to team
   ├── Update design and code
   └── Update tests

5. VERIFY
   ├── Validate updated requirements
   ├── Test changes
   ├── Review with stakeholders
   └── Update documentation
```

### 10.2 Change Request Form
```
CHANGE REQUEST
├── CR ID: CR-[PROJECT]-[NUMBER]
├── Date Submitted: [Date]
├── Requested By: [Name/Role]
├── Priority: [Critical / High / Medium / Low]
├── Type: [Addition / Modification / Deletion]

CURRENT REQUIREMENT:
[Reference to existing requirement]

PROPOSED CHANGE:
[Detailed description of change]

JUSTIFICATION:
[Business reason for change]

IMPACT ANALYSIS:
├── Scope Impact: [Description]
├── Schedule Impact: [Days added/removed]
├── Budget Impact: [Cost added/removed]
├── Technical Impact: [Architecture, design changes]
├── Risk Impact: [New or changed risks]
├── Quality Impact: [Testing, performance]
└── Stakeholder Impact: [Who is affected]

APPROVAL:
├── Reviewed By: [Name, Date]
├── Approved By: [Name, Date]
├── Decision: [Approved / Rejected / Deferred]
└── Notes: [Additional comments]
```

---

## 11. REQUIREMENTS METRICS

### 11.1 Requirements Quality Metrics
```
COMPLETENESS:
├── Requirements identified / Requirements expected
├── TBD items count
└── Target: 100% identified, 0 TBD at baseline

CONSISTENCY:
├── Conflicts identified and resolved
├── Terminology consistency score
└── Target: 0 conflicts

STABILITY:
├── Changes per week
├── Requirements churn rate
└── Target: < 5% churn after baseline

TESTABILITY:
├── Requirements with acceptance criteria / Total requirements
├── Requirements with test cases / Total requirements
└── Target: 100%

TRACEABILITY:
├── Requirements traced to design / Total requirements
├── Requirements traced to tests / Total requirements
└── Target: 100%

CLARITY:
├── Ambiguous requirements count
├── Average words per requirement
└── Target: 0 ambiguous, 20-50 words per requirement
```

### 11.2 Requirements Status Tracking
```
STATUS CATEGORIES:
├── Proposed: Submitted, not yet reviewed
├── Approved: Accepted into baseline
├── Implemented: Coded and unit tested
├── Verified: Tested and passed
├── Deferred: Postponed to future release
├── Rejected: Not accepted
├── Obsolete: No longer relevant
└── Duplicate: Redundant with another requirement

BURNDOWN:
├── Track requirements by status over time
├── Visualize progress toward completion
├── Identify bottlenecks
└── Forecast completion date
```

---

**[END OF SKILL-14]**
