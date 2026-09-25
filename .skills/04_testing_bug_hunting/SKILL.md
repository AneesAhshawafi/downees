---
name: SKILL-04
version: 1.0.0
description: Software Testing & Bug Hunting
classification: HIGH
domain: Software Testing, Quality Validation, Defect Management
level: Expert / Principal
---

# 🐛 SKILL-04: Software Testing & Bug Hunting

> **Domain:** Software Testing, Quality Validation, Defect Management  
> **Level:** Expert / Principal  
> **Scope:** Manual testing, exploratory testing, test design, bug triage, root cause analysis, test planning across all test levels

---

## 1. PHILOSOPHY

Testing is not about finding bugs — it is about **providing information about quality** to enable informed decisions.
- A test that doesn't reveal a bug is not a waste — it provides confidence
- The best tester thinks like a user, a hacker, and a developer simultaneously
- Bug hunting is a mindset: "How can I break this?"
- Quality is everyone's responsibility, but testers are the quality conscience

---

## 2. TESTING LEVELS & TYPES

### 2.1 Test Pyramid (Ideal Distribution)
```
         /\
        /  \
       / E2E  \        ~10%  (Slow, expensive, high confidence)
      /──────────\
     / Integration  \   ~30%  (Medium speed, medium cost)
    /──────────────────\
   /    Unit Tests       \  ~60%  (Fast, cheap, isolated)
  /──────────────────────────\

Base = More tests, faster feedback, lower cost
Top = Fewer tests, slower feedback, higher cost
```

### 2.2 Testing Levels Deep Dive

#### UNIT TESTING
```
Scope: Individual functions, methods, classes
Who: Developers (primarily)
When: During development, before code commit
Tools: Jest, JUnit, pytest, NUnit, xUnit

Characteristics:
├── Isolated (no DB, no network, no file system)
├── Fast (< 10ms per test)
├── Deterministic (same input = same output)
├── Repeatable (any order, any environment)
└── Self-verifying (pass/fail without manual inspection)

Best Practices:
├── AAA Pattern: Arrange → Act → Assert
├── One logical assertion per test (ideally)
├── Descriptive names: Should_ExpectedBehavior_When_StateUnderTest
├── Test both happy path and edge cases
├── Use parameterized tests for multiple inputs
├── Mock external dependencies
└── Coverage target: 80%+ for critical paths, 100% for core logic
```

#### INTEGRATION TESTING
```
Scope: Interactions between components/modules
Who: Developers + QA
When: After unit tests pass, before system testing
Tools: Postman, REST Assured, TestContainers, Docker Compose

Types:
├── API Integration: Request/response validation
├── Database Integration: Query correctness, transaction handling
├── Service Integration: Microservice communication
├── Message Queue Integration: Pub/sub patterns
└── Third-party Integration: External API behavior

Best Practices:
├── Test contract, not implementation
├── Use real (test) instances of dependencies
├── Test error handling and timeout scenarios
├── Verify data consistency across systems
├── Test idempotency where required
└── Coverage target: All integration points, critical paths
```

#### SYSTEM TESTING
```
Scope: Complete, integrated system
Who: QA Team
When: After integration testing, before UAT
Environment: Production-like staging

Types:
├── Functional System Testing: End-to-end workflows
├── Non-Functional System Testing: Performance, security, usability
├── Regression System Testing: Ensure existing features work
└── Recovery Testing: Disaster recovery, failover

Best Practices:
├── Test realistic user scenarios
├── Use production-like data (anonymized)
├── Test cross-browser and cross-device
├── Include negative and boundary scenarios
├── Document expected vs. actual behavior
└── Coverage target: All user journeys, critical business flows
```

#### ACCEPTANCE TESTING (UAT)
```
Scope: Business requirements validation
Who: End users, business stakeholders, product owner
When: Before production release
Environment: Pre-production / UAT environment

Types:
├── Alpha Testing: Internal users, controlled environment
├── Beta Testing: External users, real environment
├── Operational Acceptance: Backup, restore, monitoring
├── Contract Acceptance: SLA verification
└── Regulation Acceptance: Compliance verification

Best Practices:
├── Test against acceptance criteria (not intuition)
├── Use real business scenarios and data
├── Include edge cases from production
├── Document sign-off process
├── Escalation path for blocking issues
└── Coverage target: All acceptance criteria, 100% traceability
```

### 2.3 Testing Types Matrix

| Type | Focus | When | Who | Tools |
|------|-------|------|-----|-------|
| **Functional** | Features work as specified | Every build | Dev + QA | Unit tests, Selenium, Postman |
| **Non-Functional** | Performance, security, usability | Staging | QA + Specialists | JMeter, OWASP ZAP, Lighthouse |
| **Regression** | Existing features still work | Every change | QA | Automated suites, smoke tests |
| **Smoke** | Critical paths work | Every deployment | DevOps | CI/CD pipelines |
| **Sanity** | Specific bug fix works | After bug fix | QA | Targeted tests |
| **Exploratory** | Unscripted discovery | Any time | Experienced QA | Mind maps, charters |
| **Ad-hoc** | Random testing | Any time | Anyone | Manual |
| **Usability** | User experience | Design phase | UX + QA | User testing, heatmaps |
| **Accessibility** | WCAG compliance | Development | QA + Tools | axe, WAVE, screen readers |
| **Compatibility** | Cross-browser/device | Staging | QA | BrowserStack, Sauce Labs |
| **Security** | Vulnerability detection | Development + Staging | Security + QA | Burp Suite, OWASP ZAP |
| **Performance** | Speed, scalability | Staging | Performance Eng | JMeter, k6, Gatling |
| **Load** | Behavior under expected load | Staging | Performance Eng | JMeter, Locust |
| **Stress** | Behavior beyond expected load | Staging | Performance Eng | JMeter, k6 |
| **Spike** | Sudden load increase | Staging | Performance Eng | Custom scripts |
| **Endurance** | Long-duration stability | Staging | Performance Eng | JMeter, k6 |
| **Volume** | Large data handling | Staging | Performance Eng | DB seeding tools |
| **Failover** | Disaster recovery | Staging | DevOps | Chaos engineering |
| **Migration** | Data/system migration | Pre-migration | QA + Dev | Migration scripts |

---

## 3. TEST DESIGN TECHNIQUES

### 3.1 Black Box Techniques
```
EQUIVALENCE PARTITIONING:
Divide input domain into classes that behave similarly.
Test one value from each class.

Example (Age input: 0-120):
├── Invalid: -1, 121, "abc", null
├── Valid child: 0-12 → test 5
├── Valid teen: 13-19 → test 15
├── Valid adult: 20-64 → test 30
└── Valid senior: 65-120 → test 70

BOUNDARY VALUE ANALYSIS:
Test at boundaries and just inside/outside.

Example (Age: 0-120):
├── Lower boundary: -1, 0, 1
├── Upper boundary: 119, 120, 121
└── Internal boundaries: 12, 13, 19, 20, 64, 65

DECISION TABLE TESTING:
Capture complex business rules in tabular form.

Example (Loan approval):
Conditions: Credit Score | Income | Existing Debt
Actions:    Approve | Reject | Review

State Transition Testing:
Test all valid and invalid state transitions.

Error Guessing:
Use experience to predict where bugs hide.
```

### 3.2 White Box Techniques
```
STATEMENT COVERAGE:
Every statement executed at least once.
Target: 100% for critical code

BRANCH COVERAGE:
Every decision branch (true/false) taken.
Target: 100% for critical code

PATH COVERAGE:
Every possible path through code executed.
Target: All independent paths (cyclomatic complexity)

CONDITION COVERAGE:
Every boolean sub-expression evaluated to true and false.

MC/DC (Modified Condition/Decision Coverage):
Each condition independently affects the decision outcome.
Required for safety-critical systems (DO-178C)

CYCLOMATIC COMPLEXITY:
M = E - N + 2P
Where E = edges, N = nodes, P = connected components
Target: M ≤ 10 per function
```

### 3.3 Test Case Template
```
TEST CASE ID: TC-[Module]-[Number]
TEST CASE NAME: [Descriptive name]
PRIORITY: [Critical / High / Medium / Low]
TYPE: [Functional / Non-Functional / Regression / etc.]

PRECONDITIONS:
- [List setup requirements]

TEST DATA:
- [Specific inputs needed]

STEPS:
1. [Action]
2. [Action]
3. [Action]

EXPECTED RESULT:
- [Specific, measurable outcome]

POSTCONDITIONS:
- [System state after test]

NOTES:
- [Special considerations, dependencies]
```

---

## 4. BUG HUNTING MASTERY

### 4.1 Bug Hunter Mindset
```
THINK LIKE:
├── A USER: "What would confuse me? What would I click by mistake?"
├── A HACKER: "How can I abuse this input? What happens with unexpected data?"
├── A DEVELOPER: "What edge cases did they forget? What shortcuts did they take?"
├── A BUSINESS ANALYST: "What requirements are ambiguous or missing?"
└── A SYSTEM ADMIN: "What happens under load? What if a dependency fails?"
```

### 4.2 Exploratory Testing Charter
```
CHARTER TEMPLATE:
Explore [area/feature] using [resources/tools]
To discover [information about quality]

Example:
"Explore the checkout process using mobile Safari
with slow network (3G) to discover usability
and performance issues under degraded conditions."

Time-Boxed Session: 90 minutes
Notes: [Observations, questions, anomalies]
Bugs Found: [List with severity]
Risks Identified: [Potential issues]
```

### 4.3 Common Bug Patterns
```
INPUT HANDLING:
├── Empty/null inputs
├── Very long inputs (buffer overflow potential)
├── Special characters (SQL injection, XSS)
├── Unicode and emojis
├── Boundary values (max/min)
├── Concurrent inputs (race conditions)
└── Malformed data (corrupted JSON, invalid XML)

STATE MANAGEMENT:
├── Back button behavior
├── Refresh behavior
├── Session timeout handling
├── Multi-tab interactions
├── Browser history manipulation
└── State after error recovery

INTEGRATION:
├── API timeout handling
├── Network interruption
├── Service unavailability
├── Data synchronization conflicts
├── Version mismatches
└── Third-party service changes

UI/UX:
├── Responsive design breakpoints
├── Touch vs. mouse interactions
├── Keyboard navigation
├── Screen reader compatibility
├── Color contrast
├── Focus management
└── Loading state handling
```

### 4.4 Bug Reporting Excellence
```
BUG REPORT TEMPLATE:

ID: BUG-[Project]-[Number]
TITLE: [Action] + [Expected] + [Actual] (concise)
SEVERITY: [Blocker / Critical / Major / Minor / Trivial]
PRIORITY: [P0 / P1 / P2 / P3 / P4]
ENVIRONMENT: [OS, Browser, Version, Device]

DESCRIPTION:
[Clear, objective description of the issue]

STEPS TO REPRODUCE:
1. [Exact step]
2. [Exact step]
3. [Exact step]

EXPECTED RESULT:
[What should happen]

ACTUAL RESULT:
[What actually happens]

EVIDENCE:
├── Screenshot: [annotated]
├── Video: [screen recording]
├── Logs: [relevant excerpts]
├── Network: [HAR file if applicable]
└── Console: [error messages]

IMPACT:
[Business impact, user impact, frequency]

WORKAROUND:
[If any temporary solution exists]

REGRESSION:
[When did this last work? What changed?]
```

### 4.5 Bug Triage Process
```
TRIAGE CRITERIA:

SEVERITY:
├── Blocker: System unusable, data loss, security breach
├── Critical: Major feature broken, no workaround
├── Major: Feature impaired, workaround exists
├── Minor: Cosmetic, non-essential feature issue
└── Trivial: Typo, alignment, color mismatch

PRIORITY:
├── P0: Fix immediately (production incident)
├── P1: Fix in current sprint
├── P2: Fix in next sprint
├── P3: Fix in future release
└── P4: Nice to have / backlog

TRIAGE MEETING AGENDA:
1. Review new bugs (last 24h)
2. Re-evaluate existing bug priorities
3. Assign owners
4. Identify duplicates
5. Update bug trends
6. Escalate blockers
```

---

## 5. TEST PLANNING

### 5.1 Master Test Plan Template
```
MASTER TEST PLAN
├── 1. Introduction
│   ├── Purpose and scope
│   ├── Definitions and acronyms
│   └── References (requirements, design docs)
├── 2. Test Strategy
│   ├── Testing levels (unit, integration, system, UAT)
│   ├── Testing types (functional, performance, security, etc.)
│   ├── Entry and exit criteria per level
│   ├── Test environment requirements
│   └── Test data strategy
├── 3. Test Schedule
│   ├── Timeline with milestones
│   ├── Dependencies on development deliverables
│   └── Resource allocation
├── 4. Roles and Responsibilities
│   ├── Test manager
│   ├── Test leads
│   ├── Test engineers
│   ├── Automation engineers
│   └── Environment administrators
├── 5. Test Deliverables
│   ├── Test plans and strategies
│   ├── Test cases and scripts
│   ├── Test data
│   ├── Defect reports
│   ├── Test execution reports
│   └── Test summary report
├── 6. Risk Management
│   ├── Test-specific risks
│   ├── Mitigation strategies
│   └── Contingency plans
├── 7. Metrics and Reporting
│   ├── Test coverage metrics
│   ├── Defect metrics
│   ├── Progress metrics
│   └── Quality gates
└── 8. Approvals
    ├── Test plan approval
    ├── Test completion sign-off
    └── Release recommendation
```

### 5.2 Test Estimation
```
Factors affecting test effort:
├── Application size and complexity
├── Number of requirements/features
├── Technology stack maturity
├── Team experience
├── Test automation coverage
├── Environment stability
├── Data availability
└── Regulatory requirements

Estimation Techniques:
├── Expert judgment (analogous to past projects)
├── Work breakdown (test cases × execution time)
├── Percentage of development effort (25-40%)
├── Use case points (complexity-based)
└── Historical data (team velocity)
```

---

## 6. TEST METRICS & QUALITY GATES

### 6.1 Essential Test Metrics
```
COVERAGE:
├── Requirements coverage: % requirements with test cases
├── Code coverage: % code executed by tests
├── Risk coverage: % high-risk areas tested
└── Feature coverage: % features with automated tests

DEFECT METRICS:
├── Defect density: Defects per KLOC or function point
├── Defect escape rate: Bugs found in production / total bugs
├── Defect removal efficiency: Bugs found pre-release / total bugs
├── Mean time to detect (MTTD)
├── Mean time to resolve (MTTR)
└── Defect trend: Open vs. closed over time

EXECUTION METRICS:
├── Test case pass rate
├── Test case execution rate
├── Automated vs. manual test ratio
├── Test execution time
└── Environment downtime

QUALITY GATES:
├── Unit test coverage ≥ 80%
├── Integration test pass rate = 100%
├── No critical or high-severity open defects
├── Performance benchmarks met
├── Security scan clean (no critical/high)
├── Accessibility audit passed
└── UAT sign-off obtained
```

---

## 7. SPECIALIZED TESTING

### 7.1 Accessibility Testing (WCAG 2.1)
```
FOUR PRINCIPLES (POUR):
├── Perceivable: Information must be presentable
├── Operable: Interface components must be operable
├── Understandable: Information and UI must be understandable
└── Robust: Content must work with assistive technologies

CHECKLIST:
├── All images have alt text
├── Color is not sole means of conveying info
├── Text contrast ratio ≥ 4.5:1 (normal), 3:1 (large)
├── Keyboard navigation works for all functions
├── Focus indicators are visible
├── Form labels are associated with inputs
├── Headings are hierarchical (h1 → h2 → h3)
├── ARIA labels used appropriately
├── Screen reader testing completed
└── Zoom up to 200% without loss of function

Tools: axe, WAVE, Lighthouse, NVDA, JAWS, VoiceOver
```

### 7.2 Internationalization (i18n) Testing
```
CHECKLIST:
├── Text expansion (30-50% for some languages)
├── Right-to-left (RTL) layout support
├── Date, time, number, currency formatting
├── Character encoding (UTF-8)
├── Sorting and collation rules
├── Input method editors (IME)
├── Time zone handling
├── Locale-specific content
├── Translation completeness
└── Cultural appropriateness of icons/images
```

### 7.3 Mobile Testing
```
DEVICE MATRIX:
├── OS: iOS (latest, latest-1), Android (latest, latest-1, latest-2)
├── Screen sizes: Small (< 4"), Medium (4-6"), Large (> 6"), Tablet
├── Orientations: Portrait, Landscape
├── Network: WiFi, 4G, 3G, offline
├── Interruptions: Calls, notifications, low battery, airplane mode
└── Gestures: Tap, swipe, pinch, long press, force touch
```

---

**[END OF SKILL-04]**
