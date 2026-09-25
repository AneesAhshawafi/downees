# ⚠️ SKILL-09: Risk Analysis & Management

> **Domain:** Risk Management, Threat Assessment, Contingency Planning  
> **Level:** Expert / Principal  
> **Scope:** Risk identification, assessment, mitigation, monitoring across all SDLC phases, project, technical, and business risks

---

## 1. PHILOSOPHY

Risk management is not about eliminating risk — it is about **making informed decisions under uncertainty**.
- Every project has risks; the question is whether they are known and managed
- The cost of preventing a risk is usually less than the cost of recovering from it
- Risk tolerance varies by organization, project, and phase
- The best risk management is proactive, not reactive
- Unknown risks are more dangerous than known risks

---

## 2. RISK MANAGEMENT FRAMEWORK

### 2.1 Risk Management Process (ISO 31000)
```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│  COMMUNICATE│←───│   MONITOR   │←───│    TREAT    │←───│   ASSESS    │←───│  IDENTIFY   │
│   & CONSULT │    │    & REVIEW │    │             │    │             │    │             │
└─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘
         ↑___________________________________________________________________________↓
                                    ESTABLISH CONTEXT
```

### 2.2 Risk Register Template
```
RISK REGISTER
├── Risk ID: RISK-[PROJECT]-[NUMBER]
├── Risk Name: [Short descriptive name]
├── Category: [Technical / Schedule / Budget / Resource / Business / Security / Legal / External]
├── Description: [What could go wrong and why]
├── Root Cause: [Underlying reason]
├── Probability: [1-5 scale or percentage]
├── Impact: [1-5 scale]
├── Risk Score: [Probability × Impact]
├── Risk Level: [Critical / High / Medium / Low]
├── Risk Owner: [Person accountable for mitigation]
├── Detection Method: [How will we know if this risk occurs]
├── Mitigation Strategy: [How to reduce probability or impact]
├── Contingency Plan: [What to do if risk occurs]
├── Trigger: [Early warning signs]
├── Status: [Active / Mitigated / Occurred / Closed]
├── Last Reviewed: [Date]
└── Notes: [Additional context]
```

### 2.3 Risk Assessment Matrix
```
                    IMPACT
              Low    Medium    High    Critical
         ┌────────┬─────────┬────────┬──────────┐
    High │ Medium │  High   │Critical│ Critical │
         ├────────┼─────────┼────────┼──────────┤
PROBABILITY Medium │  Low   │ Medium  │  High   │ Critical │
         ├────────┼─────────┼────────┼──────────┤
    Low  │  Low   │  Low    │ Medium │  High    │
         ├────────┼─────────┼────────┼──────────┤
   Very  │  Low   │  Low    │  Low   │ Medium   │
   Low   └────────┴─────────┴────────┴──────────┘

SCORING:
Probability:
├── 5 - Very High: >80% likelihood
├── 4 - High: 60-80% likelihood
├── 3 - Medium: 40-60% likelihood
├── 2 - Low: 20-40% likelihood
└── 1 - Very Low: <20% likelihood

Impact:
├── 5 - Critical: Project failure, legal liability, safety issue
├── 4 - High: Major delay (>20%), budget overrun (>20%), significant quality issue
├── 3 - Medium: Moderate delay (10-20%), budget overrun (10-20%), noticeable quality issue
├── 2 - Low: Minor delay (<10%), minor budget impact, cosmetic issue
└── 1 - Very Low: Negligible impact, easily recoverable

RISK LEVEL:
├── 20-25: Critical — Immediate executive attention required
├── 12-16: High — Active management, regular monitoring
├── 6-9: Medium — Monitor, plan mitigation
└── 1-4: Low — Accept and monitor
```

---

## 3. RISK IDENTIFICATION

### 3.1 Risk Categories for Software Projects

#### TECHNICAL RISKS
```
├── Technology Maturity
│   ├── New/unproven technology
│   ├── Deprecated technology
│   ├── Vendor lock-in
│   └── Integration complexity
├── Architecture
│   ├── Scalability limitations
│   ├── Performance bottlenecks
│   ├── Single points of failure
│   └── Technical debt accumulation
├── Security
│   ├── Data breaches
│   ├── Vulnerability exploitation
│   ├── Compliance violations
│   └── Insider threats
├── Quality
│   ├── Defect escape to production
│   ├── Test coverage gaps
│   ├── Environment parity issues
│   └── Regression failures
└── Infrastructure
    ├── Cloud provider outages
    ├── Network failures
    ├── Capacity constraints
    └── Disaster recovery gaps
```

#### PROJECT RISKS
```
├── Schedule
│   ├── Unrealistic timelines
│   ├── Scope creep
│   ├── Dependency delays
│   └── Resource unavailability
├── Budget
│   ├── Cost underestimation
│   ├── Scope expansion
│   ├── Currency fluctuation (global teams)
│   └── Tool/licensing cost increases
├── Resources
│   ├── Key person dependency (bus factor = 1)
│   ├── Skills gap
│   ├── Team turnover
│   └── Competing priorities
└── Stakeholder
    ├── Changing requirements
    ├── Sponsor withdrawal
    ├── Conflicting stakeholder priorities
    └── Communication breakdown
```

#### BUSINESS RISKS
```
├── Market
│   ├── Competitor launch
│   ├── Market shift
│   ├── Economic downturn
│   └── Regulatory changes
├── Product
│   ├── Poor product-market fit
│   ├── User adoption failure
│   ├── Feature misalignment
│   └── Pricing model failure
├── Partnership
│   ├── Third-party API changes
│   ├── Vendor bankruptcy
│   ├── Integration partner delays
│   └── License termination
└── Legal
    ├── Intellectual property disputes
    ├── Contract breaches
    ├── Data privacy violations
    └── Export control restrictions
```

#### EXTERNAL RISKS
```
├── Natural disasters
├── Pandemics / health crises
├── Geopolitical instability
├── Cyber attacks (nation-state, criminal)
├── Supply chain disruptions
└── Infrastructure failures (power, internet)
```

### 3.2 Risk Identification Techniques

```
BRAINSTORMING:
├── Cross-functional team session
├── Structured prompts per category
├── No judgment during ideation
└── Document everything

CHECKLISTS:
├── Historical project risk lists
├── Industry-specific risk catalogs
├── Regulatory requirement checklists
└── Security vulnerability databases

ASSUMPTION ANALYSIS:
├── List all project assumptions
├── "What if this assumption is wrong?"
├── Validate assumptions with stakeholders
└── Document validated vs. unvalidated assumptions

SWOT ANALYSIS:
├── Strengths (internal positive)
├── Weaknesses (internal negative → risks)
├── Opportunities (external positive)
└── Threats (external negative → risks)

EXPERT JUDGMENT:
├── Interview senior engineers
├── Consult domain experts
├── Review post-mortems from similar projects
└── External audits and assessments

ROOT CAUSE ANALYSIS:
├── "5 Whys" on past failures
├── Fishbone diagram (Ishikawa)
├── Fault tree analysis
└── Failure mode analysis
```

---

## 4. RISK ANALYSIS

### 4.1 Qualitative Risk Analysis
```
RISK RATING WORKSHOP:
1. List all identified risks
2. For each risk, assess:
   ├── Probability (1-5)
   ├── Impact (1-5)
   ├── Urgency (time until potential occurrence)
   └── Detectability (how early can we spot it)
3. Calculate risk score: Probability × Impact
4. Prioritize: Highest scores first
5. Assign owners

RISK BUBBLE CHART:
├── X-axis: Probability
├── Y-axis: Impact
├── Bubble size: Cost of mitigation
├── Color: Risk category
└── Quadrants: Accept / Mitigate / Transfer / Avoid
```

### 4.2 Quantitative Risk Analysis
```
EXPECTED MONETARY VALUE (EMV):
EMV = Probability × Impact ($)

Example:
Risk: Database corruption during migration
Probability: 10% (0.1)
Impact: $500,000 (revenue loss + recovery cost)
EMV = 0.1 × $500,000 = $50,000

Decision: If mitigation costs <$50,000, it's worth it.

MONTE CARLO SIMULATION:
├── Define probability distributions for each risk
├── Run thousands of simulations
├── Output: Probability distribution of total project cost/duration
├── Identify: P50, P80, P90 confidence levels
└── Tools: @Risk, Crystal Ball, Python (numpy, scipy)

SENSITIVITY ANALYSIS:
├── Tornado diagram: Which risks have biggest impact on outcome
├── One-at-a-time variation
├── Identify critical risks for focused management
└── Guide resource allocation
```

### 4.3 Risk Breakdown Structure (RBS)
```
PROJECT RISKS
├── Technical Risks
│   ├── Architecture
│   │   ├── Scalability failure
│   │   ├── Performance degradation
│   │   └── Integration failure
│   ├── Technology
│   │   ├── Learning curve
│   │   ├── Maturity gaps
│   │   └── Deprecation
│   └── Security
│       ├── Vulnerability exploitation
│       ├── Data breach
│       └── Compliance violation
├── Project Risks
│   ├── Schedule
│   │   ├── Scope creep
│   │   ├── Resource unavailability
│   │   └── Dependency delays
│   ├── Budget
│   │   ├── Cost overrun
│   │   └── Currency fluctuation
│   └── Quality
│       ├── Defect density
│       └── Test coverage gaps
├── Business Risks
│   ├── Market
│   │   ├── Competition
│   │   └── Demand shift
│   └── Legal
│       ├── IP disputes
│       └── Regulatory changes
└── External Risks
    ├── Natural disasters
    ├── Cyber attacks
    └── Supply chain
```

---

## 5. RISK RESPONSE STRATEGIES

### 5.1 Threat Response Strategies
```
AVOID:
├── Change project plan to eliminate risk
├── Use proven technology instead of experimental
├── Reduce scope to remove complex features
├── Change approach to avoid dependency
└── Example: Don't build custom auth, use established provider

MITIGATE (REDUCE):
├── Reduce probability:
│   ├── Training and skill development
│   ├── Prototyping and proof of concept
│   ├── Code reviews and static analysis
│   ├── Redundancy and failover
│   └── Regular security audits
├── Reduce impact:
│   ├── Backup and recovery procedures
│   ├── Insurance
│   ├── Graceful degradation
│   ├── Feature flags (disable broken features)
│   └── Data replication
└── Example: Implement CI/CD with automated testing to catch defects early

TRANSFER:
├── Insurance (cyber liability, errors & omissions)
├── Outsourcing (transfer operational risk)
├── Contracts (SLAs with vendors)
├── Warranties and guarantees
└── Example: Use cloud provider for infrastructure (transfer hardware failure risk)

ACCEPT:
├── Active acceptance: Create contingency reserve (budget, time, resources)
├── Passive acceptance: Acknowledge and monitor
├── For low-probability, low-impact risks
└── Example: Accept minor UI inconsistencies in MVP

ESCALATE:
├── Risk beyond project team's authority
├── Requires sponsor/executive decision
├── Document and communicate upward
└── Example: Regulatory change requiring business strategy shift
```

### 5.2 Opportunity Response Strategies
```
EXPLOIT:
├── Ensure opportunity is realized
├── Allocate best resources
├── Fast-track or crash schedule
└── Example: Early market entry for competitive advantage

ENHANCE:
├── Increase probability of opportunity
├── Add resources or capabilities
├── Improve conditions
└── Example: Invest in AI research to enhance product differentiation

SHARE:
├── Partner to capture opportunity
├── Joint ventures, alliances
├── Shared investment, shared reward
└── Example: Partner with AI vendor for exclusive integration

ACCEPT:
├── Acknowledge opportunity
├── Take no special action
├── Benefit if it occurs
└── Example: Monitor emerging technology for future adoption
```

### 5.3 Contingency Planning
```
CONTINGENCY PLAN TEMPLATE:
├── Trigger Condition: [What signals this risk is occurring]
├── Response Actions: [Step-by-step response]
├── Resources Needed: [People, budget, tools]
├── Timeline: [How quickly must we respond]
├── Decision Authority: [Who approves the response]
├── Communication Plan: [Who to notify and when]
├── Escalation Path: [If initial response fails]
└── Post-Event Review: [Learning capture]

CONTINGENCY RESERVES:
├── Schedule Reserve: Buffer time (e.g., 15-20% of critical path)
├── Budget Reserve: Contingency fund (e.g., 10-15% of budget)
├── Resource Reserve: Backup personnel or cross-trained team members
└── Technical Reserve: Spike time for unknown technical challenges
```

---

## 6. RISK MONITORING & CONTROL

### 6.1 Risk Monitoring Process
```
WEEKLY RISK REVIEW:
1. Review all active risks
2. Update probability and impact based on new information
3. Check trigger conditions
4. Verify mitigation actions are on track
5. Identify new risks
6. Close risks that are no longer relevant
7. Escalate risks that have increased in severity
8. Update risk register
9. Communicate to stakeholders

RISK DASHBOARD:
├── Open risks by severity (Critical/High/Medium/Low)
├── Risk trend over time (increasing/decreasing)
├── Mitigation action status
├── Near-misses (risks that almost occurred)
├── Risk burn-down (risks closed vs. opened)
└── Top 5 risks requiring attention
```

### 6.2 Risk Metrics
```
LEADING INDICATORS (Predict future problems):
├── Requirements volatility (% changed per sprint)
├── Code churn (lines changed per file)
├── Test coverage trend
├── Build failure rate
├── Security scan findings trend
├── Team velocity variance
└── Stakeholder satisfaction score

LAGGING INDICATORS (Confirm past problems):
├── Defect density
├── Schedule variance
├── Budget variance
├── Production incidents
├── Customer complaints
└── Post-mortem action item closure rate
```

### 6.3 Risk Reporting
```
RISK REPORT TEMPLATE:
├── Executive Summary
│   ├── Total open risks
│   ├── New risks this period
│   ├── Closed risks this period
│   └── Risks escalated
├── Risk Trend Analysis
│   ├── Risk exposure trend (sum of all risk scores)
│   ├── Critical risks requiring attention
│   └── Emerging risk patterns
├── Top Risks (Top 5)
│   ├── Description and impact
│   ├── Mitigation status
│   └── Next actions
├── Mitigation Progress
│   ├── Actions completed
│   ├── Actions in progress
│   ├── Actions overdue
│   └── Resource needs
└── Recommendations
    ├── Risk acceptance decisions needed
    ├── Resource reallocation suggestions
    └── Process improvements
```

---

## 7. PHASE-SPECIFIC RISK MANAGEMENT

### 7.1 Requirements Phase Risks
```
RISKS:
├── Incomplete requirements
├── Ambiguous requirements
├── Conflicting stakeholder priorities
├── Scope creep
└── Changing market needs

MITIGATIONS:
├── Requirements workshops with all stakeholders
├── Prototyping and user validation
├── Prioritization framework (MoSCoW, RICE)
├── Change control process
├── Regular stakeholder reviews
└── Traceability matrix
```

### 7.2 Design Phase Risks
```
RISKS:
├── Over-engineering
├── Under-engineering
├── Technology mismatch
├── Scalability blind spots
└── Security design flaws

MITIGATIONS:
├── Architecture review board
├── Proof of concepts for critical decisions
├── Threat modeling
├── Performance modeling
├── Prototype load testing
└── Peer reviews
```

### 7.3 Development Phase Risks
```
RISKS:
├── Technical debt accumulation
├── Key person dependency
├── Integration failures
├── Code quality degradation
└── Security vulnerabilities

MITIGATIONS:
├── Code review mandates
├── Static analysis in CI/CD
├── Pair programming
├── Knowledge sharing sessions
├── Continuous integration
├── Security scanning (SAST, SCA)
└── Regular refactoring sprints
```

### 7.4 Testing Phase Risks
```
RISKS:
├── Inadequate test coverage
├── Environment parity gaps
├── Test data limitations
├── Defect clustering
└── Schedule compression

MITIGATIONS:
├── Test-driven development
├── Automated test suites
├── Production-like test environments
├── Synthetic test data generation
├── Risk-based testing prioritization
└── Parallel test execution
```

### 7.5 Deployment Phase Risks
```
RISKS:
├── Deployment failures
├── Rollback inability
├── Data migration errors
├── Downtime exceeding SLA
└── Configuration errors

MITIGATIONS:
├── Blue/green deployment
├── Canary releases
├── Automated rollback procedures
├── Database migration testing
├── Configuration management (IaC)
├── Monitoring and alerting
└── War room procedures
```

---

## 8. SPECIALIZED RISK AREAS

### 8.1 Security Risk Management
```
RISK ASSESSMENT:
├── Asset inventory (data, systems, infrastructure)
├── Threat modeling (STRIDE)
├── Vulnerability assessment
├── Impact analysis (confidentiality, integrity, availability)
└── Risk scoring (CVSS for vulnerabilities)

MITIGATION:
├── Defense in depth
├── Regular penetration testing
├── Security awareness training
├── Incident response plan
├── Backup and recovery
├── Encryption (at rest, in transit)
└── Access control (least privilege)
```

### 8.2 AI/ML Risk Management
```
RISKS:
├── Model bias and fairness
├── Model drift
├── Data quality issues
├── Adversarial attacks
├── Explainability gaps
├── Regulatory compliance (AI Act, etc.)
└── Over-reliance on AI decisions

MITIGATIONS:
├── Bias testing and monitoring
├── Human-in-the-loop for high-stakes decisions
├── Model explainability tools (SHAP, LIME)
├── Regular model retraining
├── Adversarial robustness testing
├── AI governance framework
└── Fallback to non-AI methods
```

### 8.3 Third-Party Risk Management
```
RISKS:
├── Vendor bankruptcy
├── Service discontinuation
├── Data breach at vendor
├── Compliance violations by vendor
├── Integration breaking changes
└── Vendor lock-in

MITIGATIONS:
├── Vendor due diligence
├── Contractual SLAs and penalties
├── Exit strategy and data portability
├── Multi-vendor strategy (where feasible)
├── Regular vendor security assessments
├── Monitoring vendor financial health
└── Abstraction layers to reduce coupling
```

---

## 9. RISK CULTURE

### 9.1 Building a Risk-Aware Team
```
PRACTICES:
├── Psychological safety (report risks without blame)
├── Regular risk discussions in standups/retrospectives
├── Risk champions in each team
├── Post-mortems without punishment (focus on learning)
├── Risk training for all team members
├── Celebrate risk prevention (not just heroics)
└── Transparent risk communication

ANTI-PATTERNS:
├── "It won't happen to us" optimism bias
├── Risk suppression (fear of reporting)
├── Last-minute risk identification
├── Risk transfer without vendor management
├── Mitigation without verification
└── Risk register as a static document
```

---

**[END OF SKILL-09]**
