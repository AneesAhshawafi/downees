# ✅ SKILL-05: Software Quality Assurance (QA)

> **Domain:** Quality Management, Process Improvement, Compliance  
> **Level:** Expert / Principal  
> **Scope:** QA strategy, process definition, metrics, audits, continuous improvement, standards compliance

---

## 1. PHILOSOPHY

Quality Assurance is not testing — it is **building confidence that the process will produce quality**.
- QA prevents defects; QC (Testing) detects defects
- Quality is a process attribute, not just a product attribute
- You cannot test quality into a product — you must build it in
- Standards exist to reduce variation, not to create bureaucracy

---

## 2. QA STRATEGY FRAMEWORK

### 2.1 Quality Management System (QMS)
```
QMS COMPONENTS:
├── Quality Policy (organization's quality commitment)
├── Quality Objectives (measurable targets)
├── Quality Manual (high-level procedures)
├── Standard Operating Procedures (SOPs)
├── Work Instructions (detailed how-to)
├── Forms and Templates
├── Metrics and KPIs
├── Audit Program
└── Continuous Improvement Process
```

### 2.2 QA Strategy Document Template
```
QUALITY ASSURANCE STRATEGY
├── 1. Executive Summary
├── 2. Quality Objectives
│   ├── Defect density targets
│   ├── Test coverage targets
│   ├── Customer satisfaction targets
│   └── Process compliance targets
├── 3. Quality Standards
│   ├── ISO 9001 (Quality Management)
│   ├── ISO 25010 (Software Quality)
│   ├── IEEE 730 (Software QA Plans)
│   └── Industry-specific (ISO 13485, ISO 27001, etc.)
├── 4. QA Processes
│   ├── Requirements review process
│   ├── Design review process
│   ├── Code review process
│   ├── Testing process
│   ├── Release process
│   └── Post-release monitoring
├── 5. Roles and Responsibilities
│   ├── QA Manager
│   ├── QA Engineers
│   ├── Process Engineers
│   └── Quality Champions (in each team)
├── 6. Metrics and Reporting
│   ├── Quality dashboards
│   ├── Trend analysis
│   └── Management reviews
├── 7. Tools and Infrastructure
│   ├── Test management (TestRail, Xray, Zephyr)
│   ├── Defect tracking (Jira, Azure DevOps)
│   ├── Static analysis (SonarQube, Coverity)
│   └── Metrics dashboards (Grafana, Power BI)
├── 8. Training and Competency
│   ├── QA onboarding
│   ├── Specialized training (security, performance)
│   └── Certification programs
├── 9. Audit and Compliance
│   ├── Internal audit schedule
│   ├── External audit preparation
│   └── Non-conformance management
└── 10. Continuous Improvement
    ├── Retrospectives
    ├── Root cause analysis
    ├── Process experiments
    └── Benchmarking
```

---

## 3. QUALITY ATTRIBUTES (ISO 25010)

### 3.1 Product Quality Model
```
FUNCTIONAL SUITABILITY:
├── Functional Completeness: All specified functions implemented
├── Functional Correctness: Functions produce correct results
└── Functional Appropriateness: Functions facilitate task completion

PERFORMANCE EFFICIENCY:
├── Time Behavior: Response and processing times
├── Resource Utilization: CPU, memory, disk, network
└── Capacity: Maximum limits

COMPATIBILITY:
├── Co-existence: Works alongside other products
└── Interoperability: Exchanges information with other systems

USABILITY:
├── Appropriateness Recognizability: Users recognize suitability
├── Learnability: Easy to learn
├── Operability: Easy to operate and control
├── User Error Protection: Protects against user errors
├── User Interface Aesthetics: Pleasing UI
└── Accessibility: Usable by people with disabilities

RELIABILITY:
├── Maturity: Frequency of failure
├── Availability: Operational when needed
├── Fault Tolerance: Graceful degradation
└── Recoverability: Recovery from failure

SECURITY:
├── Confidentiality: Data accessible only to authorized
├── Integrity: Protection from unauthorized modification
├── Non-repudiation: Actions traced to entity
├── Accountability: Actions traceable to responsible entity
└── Authenticity: Proof of identity

MAINTAINABILITY:
├── Modularity: Component changes minimize impact
├── Reusability: Assets usable in other systems
├── Analyzability: Easy to diagnose deficiencies
├── Modifiability: Easy to change
├── Testability: Easy to validate modifications
└── Compliance: Adheres to standards

PORTABILITY:
├── Adaptability: Adaptable to different environments
├── Installability: Easy to install/uninstall
├── Replaceability: Replaceable with other software
└── Compliance: Adheres to portability standards
```

### 3.2 Quality Attribute Scenarios
```
TEMPLATE:
Source: [Internal/External entity]
Stimulus: [Event/condition]
Environment: [Runtime, development, testing, etc.]
Artifact: [System, module, component]
Response: [Observable behavior]
Response Measure: [Quantifiable metric]

Example (Performance):
Source: User
Stimulus: Initiates search with 10 filters
Environment: Normal operations, 1000 concurrent users
Artifact: Search service
Response: Results displayed
Response Measure: ≤ 2 seconds for 95th percentile

Example (Security):
Source: External attacker
Stimulus: Attempts SQL injection
Environment: Production, public internet
Artifact: Login API
Response: Request rejected, logged, alert triggered
Response Measure: 0 successful injections, detection < 1 minute
```

---

## 4. QA PROCESSES BY PHASE

### 4.1 Requirements QA
```
ACTIVITIES:
├── Requirements review (formal inspection)
├── Ambiguity analysis
├── Testability assessment
├── Consistency check
├── Completeness verification
├── Traceability establishment
└── Acceptance criteria validation

CHECKLIST:
- [ ] Each requirement is unique and atomic
- [ ] Each requirement is unambiguous
- [ ] Each requirement is testable (has acceptance criteria)
- [ ] No contradictions between requirements
- [ ] All stakeholder needs are covered
- [ ] Requirements are prioritized
- [ ] Traceability to business objectives exists
- [ ] No gold plating (unnecessary features)
```

### 4.2 Design QA
```
ACTIVITIES:
├── Architecture review (ATAM - Architecture Tradeoff Analysis)
├── Design pattern compliance
├── Security design review (threat modeling)
├── Performance design review
├── Maintainability assessment
├── Scalability review
└── Technology stack validation

CHECKLIST:
- [ ] Design satisfies all requirements
- [ ] Design patterns are appropriate and justified
- [ ] Security by design principles applied
- [ ] Single points of failure identified and mitigated
- [ ] Scalability strategy defined
- [ ] Error handling strategy comprehensive
- [ ] Logging and monitoring designed in
- [ ] Data flow diagram reviewed
```

### 4.3 Code QA
```
ACTIVITIES:
├── Code review (mandatory, not optional)
├── Static analysis (SonarQube, ESLint, Pylint)
├── Complexity analysis (cyclomatic, cognitive)
├── Duplicate code detection
├── Security scanning (SAST - Static Application Security Testing)
├── Dependency vulnerability scanning (SCA)
├── Coding standards compliance
└── Documentation completeness

CODE REVIEW CHECKLIST:
- [ ] Functionality correct and complete
- [ ] Error handling comprehensive
- [ ] Input validation present
- [ ] No hardcoded secrets or credentials
- [ ] No SQL injection vulnerabilities
- [ ] No XSS vulnerabilities
- [ ] Performance considerations addressed
- [ ] Logging appropriate (no sensitive data)
- [ ] Unit tests present and passing
- [ ] Code follows style guide
- [ ] Comments explain "why", not "what"
- [ ] No TODO/FIXME without ticket reference
```

### 4.4 Release QA
```
ACTIVITIES:
├── Release criteria verification
├── Regression test review
├── Performance baseline comparison
├── Security scan review
├── Documentation completeness check
├── Rollback procedure validation
├── Monitoring and alerting verification
└── Go/No-Go decision facilitation

RELEASE CHECKLIST:
- [ ] All P0/P1 defects resolved
- [ ] Test coverage meets minimum threshold
- [ ] Performance benchmarks met or improved
- [ ] Security scan clean (no new critical/high)
- [ ] Accessibility audit passed
- [ ] Documentation updated and reviewed
- [ ] Rollback tested in staging
- [ ] Monitoring dashboards verified
- [ ] On-call runbook updated
- [ ] Stakeholder communication sent
- [ ] Feature flags configured
- [ ] Analytics events validated
```

---

## 5. METRICS & DASHBOARDS

### 5.1 Quality Metrics Framework
```
PROCESS METRICS:
├── Review effectiveness: Defects found in review / total defects
├── Review efficiency: Defects per hour of review
├── Test effectiveness: Defects found by testing / total defects
├── Test efficiency: Defects per test case
├── Defect removal efficiency: Pre-release defects / total defects
└── Escape rate: Production defects / total defects

PRODUCT METRICS:
├── Defect density: Defects per KLOC or function point
├── Code coverage: % of code covered by tests
├── Complexity: Average cyclomatic complexity
├── Duplication: % duplicated code
├── Technical debt: Estimated remediation cost
└── Documentation coverage: % of APIs documented

PROJECT METRICS:
├── Schedule variance: Actual vs. planned timeline
├── Cost variance: Actual vs. planned budget
├── Requirement stability: % requirements changed
├── Test execution rate: % tests executed on schedule
└── Defect resolution time: Average time to fix
```

### 5.2 Quality Dashboard
```
EXECUTIVE DASHBOARD (Weekly):
├── Overall Quality Score (0-100)
├── Open Defects by Severity (trend)
├── Test Coverage Trend
├── Production Incidents (last 30 days)
├── Customer Satisfaction (NPS)
└── Release Readiness (Go/No-Go)

TEAM DASHBOARD (Daily):
├── Build Status (pass/fail)
├── Code Coverage (by module)
├── Static Analysis Issues (new/resolved)
├── Open Pull Requests (age distribution)
├── Review Turnaround Time
└── Sprint Burndown
```

---

## 6. AUDIT & COMPLIANCE

### 6.1 Internal Audit Process
```
PLAN:
├── Define audit scope and objectives
├── Select audit criteria (standards, procedures)
├── Schedule audit (avoid crunch times)
└── Notify auditees

PREPARE:
├── Review previous audit results
├── Gather evidence (docs, metrics, records)
├── Prepare checklists
└── Brief audit team

CONDUCT:
├── Opening meeting
├── Evidence gathering (interviews, observation, documents)
├── Daily debriefs
├── Findings documentation
└── Closing meeting

REPORT:
├── Draft audit report
├── Classification of findings (Major/Minor/Observation)
├── Root cause analysis
├── Corrective action recommendations
└── Management response

FOLLOW-UP:
├── Corrective action plan approval
├── Implementation tracking
├── Verification of effectiveness
└── Close findings
```

### 6.2 Common Standards
```
ISO 9001: Quality Management Systems
├── Customer focus
├── Leadership
├── Engagement of people
├── Process approach
├── Improvement
├── Evidence-based decisions
└── Relationship management

ISO 25010: Systems and Software Quality
├── (See Section 3.1 above)

ISO 27001: Information Security Management
├── (See SKILL-06)

CMMI (Capability Maturity Model Integration):
├── Level 1: Initial (ad hoc)
├── Level 2: Managed (project-level processes)
├── Level 3: Defined (organization-level processes)
├── Level 4: Quantitatively Managed (measured)
└── Level 5: Optimizing (continuous improvement)

IEEE 730: Software Quality Assurance Plans
├── (See Section 2.2 above)
```

---

## 7. CONTINUOUS IMPROVEMENT

### 7.1 PDCA Cycle
```
PLAN:
├── Identify improvement opportunity
├── Analyze current state
├── Set improvement target
└── Develop action plan

DO:
├── Implement changes (small, controlled experiments)
├── Collect data
└── Document observations

CHECK:
├── Measure results against target
├── Analyze root causes of gaps
└── Validate hypothesis

ACT:
├── Standardize successful changes
├── Update procedures and training
├── Communicate results
└── Plan next improvement
```

### 7.2 Root Cause Analysis Techniques
```
5 WHYS:
Problem: System crashed during peak load
Why 1: Database connection pool exhausted
Why 2: Connections not being released
Why 3: Exception handling bypasses close()
Why 4: Developer didn't use try-with-resources
Why 5: Code review didn't catch resource leak pattern
Root Cause: Gap in code review checklist for resource management

FISHBONE (ISHIKAWA) DIAGRAM:
Categories: People, Process, Tools, Environment, Materials, Methods

FAULT TREE ANALYSIS:
Top event → Intermediate events → Basic events (Boolean logic)
```

---

**[END OF SKILL-05]**
