# 🔄 SKILL-02: Software Development Life Cycle (SDLC)

> **Domain:** Software Development Process  
> **Level:** Expert / Principal  
> **Scope:** Full lifecycle governance, phase management, deliverables, transitions, quality at every stage

---

## 1. PHILOSOPHY

The SDLC is not a linear conveyor belt — it is a **risk-reduction engine**.
- Each phase exists to eliminate a class of risk
- Skipping phases does not save time — it accumulates technical debt
- Quality is built in, not inspected in
- Feedback loops between phases are more valuable than perfect phase execution

---

## 2. UNIFIED SDLC MODEL

This skill supports ALL lifecycle models: Waterfall, V-Model, Iterative, Incremental, Spiral, Agile (Scrum, XP, Kanban), DevOps, and hybrid approaches.

### 2.1 Core Phases (Universal)

```
┌─────────────────────────────────────────────────────────────────┐
│                    SOFTWARE DEVELOPMENT LIFE CYCLE               │
├─────────┬─────────┬─────────┬─────────┬─────────┬─────────────┤
│  PLAN   │ REQUIRE │  DESIGN │  BUILD  │  TEST   │  DEPLOY     │
│         │         │         │         │         │  & OPERATE  │
├─────────┼─────────┼─────────┼─────────┼─────────┼─────────────┤
│ • Scope │ • Elicit│ • Arch  │ • Code  │ • Unit  │ • Release   │
│ • Est.  │ • Analyze│ • Detail│ • Review│ • Int.  │ • Monitor   │
│ • Risk  │ • Spec  │ • UI/UX │ • Build │ • System│ • Support   │
│ • Team  │ • Validate│ • Data │ • Doc   │ • UAT   │ • Optimize  │
│ • Comm. │ • Trace │ • API   │ • Commit│ • Perf. │ • Retire    │
│         │         │ • Sec.  │         │ • Sec.  │             │
└─────────┴─────────┴─────────┴─────────┴─────────┴─────────────┘
         ↑_________________________________________↓
                    FEEDBACK & ITERATION
```

### 2.2 Phase Definitions & Deliverables

#### PHASE 1: PLANNING
**Purpose:** Establish feasibility, scope, and approach
**Key Activities:**
- Feasibility study (technical, economic, operational, legal, schedule)
- Project charter creation
- Team assembly and skills assessment
- Tool and environment selection
- SDLC model selection (based on project characteristics)

**Deliverables:**
- Project Charter
- Feasibility Report
- SDLC Selection Rationale
- Team Structure & RACI
- Communication Plan
- Initial Risk Register

**Quality Gates:**
- [ ] Business case approved
- [ ] Budget allocated
- [ ] Team identified and available
- [ ] High-level risks documented
- [ ] Success criteria defined

---

#### PHASE 2: REQUIREMENTS ENGINEERING
**Purpose:** Define WHAT the system must do (and not do)
**Key Activities:**
- Stakeholder identification and analysis
- Requirements elicitation (interviews, workshops, observation, prototyping)
- Requirements analysis and classification
- Requirements specification (SRS, user stories, use cases)
- Requirements validation and verification
- Requirements traceability matrix creation

**Deliverables:**
- Software Requirements Specification (SRS)
- User Stories (with acceptance criteria)
- Use Case Diagrams & Specifications
- Requirements Traceability Matrix (RTM)
- Prototypes / Wireframes
- Data Dictionary

**Quality Gates:**
- [ ] All stakeholders reviewed and approved
- [ ] Requirements are SMART
- [ ] No unresolved ambiguities
- [ ] Traceability matrix complete
- [ ] Acceptance criteria defined for each requirement

---

#### PHASE 3: DESIGN
**Purpose:** Define HOW the system will satisfy requirements
**Key Activities:**
- Architectural design (high-level)
- Detailed design (low-level)
- Database design
- API design
- UI/UX design
- Security design (threat modeling)
- Integration design
- Deployment architecture

**Deliverables:**
- System Architecture Document (SAD)
- Database Schema & ERD
- API Specification (OpenAPI/Swagger)
- UI/UX Design System & Mockups
- Security Design Document (with threat model)
- Deployment Architecture Diagram
- Technology Stack Justification

**Quality Gates:**
- [ ] Architecture review passed (peer + senior)
- [ ] Threat model created and mitigations defined
- [ ] Design patterns justified
- [ ] Scalability and performance addressed
- [ ] All requirements traceable to design elements

---

#### PHASE 4: DEVELOPMENT / BUILD
**Purpose:** Construct the software according to design
**Key Activities:**
- Environment setup (dev, staging, prod parity)
- Coding standards enforcement
- Version control (Git flow, trunk-based, etc.)
- Code reviews (mandatory, not optional)
- Continuous Integration (CI)
- Documentation (inline, API docs, README)
- Build automation

**Deliverables:**
- Source Code (in repository)
- Build Scripts / CI/CD Pipelines
- Code Review Records
- Developer Documentation
- Unit Test Suite
- Static Analysis Reports

**Quality Gates:**
- [ ] All code reviewed and approved
- [ ] Unit tests pass (≥80% coverage)
- [ ] Static analysis clean (no critical/high issues)
- [ ] Code follows team standards
- [ ] No secrets in code (scan completed)
- [ ] Build is reproducible

---

#### PHASE 5: TESTING
**Purpose:** Verify and validate the software
**Key Activities:**
- Test planning and strategy
- Test case design and review
- Test environment setup
- Test execution (manual + automated)
- Defect management and triage
- Regression testing
- Performance and security testing
- User Acceptance Testing (UAT)

**Deliverables:**
- Test Plan & Strategy
- Test Cases & Scripts
- Test Execution Reports
- Defect Reports & Metrics
- Performance Test Results
- Security Test Results
- UAT Sign-off

**Quality Gates:**
- [ ] All critical/high defects resolved
- [ ] Test coverage meets targets
- [ ] Performance benchmarks met
- [ ] Security vulnerabilities remediated
- [ ] UAT passed with sign-off
- [ ] Regression suite passes

---

#### PHASE 6: DEPLOYMENT & OPERATIONS
**Purpose:** Release to production and maintain
**Key Activities:**
- Release planning and scheduling
- Deployment automation
- Blue/Green or Canary deployment
- Monitoring and alerting setup
- Rollback procedure testing
- User training and documentation
- Post-deployment verification
- Incident response preparation

**Deliverables:**
- Release Notes
- Deployment Runbook
- Monitoring Dashboards
- Alerting Rules
- Rollback Procedures
- User Documentation
- Support Runbook
- Post-Deployment Review

**Quality Gates:**
- [ ] Deployment tested in staging
- [ ] Rollback tested and documented
- [ ] Monitoring confirms system health
- [ ] No critical alerts in first 24h
- [ ] Users can access and use system
- [ ] Support team trained and ready

---

## 3. SDLC MODEL SELECTION GUIDE

### 3.1 Model Comparison Matrix

| Model | Best For | Risk Level | Flexibility | Documentation | Team Size |
|-------|----------|------------|-------------|---------------|-----------|
| **Waterfall** | Fixed scope, clear requirements, regulated industries | Low | Low | Heavy | Any |
| **V-Model** | Safety-critical, compliance-heavy (medical, aerospace) | Low | Low | Very Heavy | Medium+ |
| **Iterative** | Complex systems, evolving understanding | Medium | Medium | Medium | Medium |
| **Incremental** | Large systems, phased delivery | Medium | Medium | Medium | Large |
| **Spiral** | High-risk, R&D, unprecedented projects | High | High | Medium | Small-Medium |
| **Scrum** | Product development, changing requirements | Medium | High | Light | Small (3-9) |
| **Kanban** | Maintenance, support, continuous flow | Low | Very High | Light | Any |
| **XP** | Small teams, high quality, rapid feedback | Medium | High | Light | Very Small (2-8) |
| **DevOps** | Cloud-native, CI/CD, SRE practices | Medium | High | Medium | Any |
| **Hybrid** | Enterprise, mixed requirements | Variable | Variable | Variable | Large |

### 3.2 Selection Decision Tree
```
START
├── Requirements stable and well-understood?
│   ├── YES → Fixed scope?
│   │   ├── YES → Regulatory compliance required?
│   │   │   ├── YES → V-Model or Waterfall
│   │   │   └── NO → Waterfall
│   │   └── NO → Iterative or Incremental
│   └── NO → Changing requirements expected?
│       ├── YES → Small team, co-located?
│       │   ├── YES → XP or Scrum
│       │   └── NO → Scrum or Kanban
│       └── NO → Complex, high risk?
│           ├── YES → Spiral
│           └── NO → Hybrid / Custom
```

---

## 4. PHASE TRANSITION CRITERIA

### 4.1 Waterfall/V-Model Gates
```
Gate 1→2: Requirements Baseline Approved
Gate 2→3: Architecture Review Passed
Gate 3→4: Design Review Passed
Gate 4→5: Code Complete + Unit Tests Pass
Gate 5→6: All Tests Pass + UAT Sign-off
Gate 6→7: Deployment Verified + Monitoring Active
```

### 4.2 Agile Transition Criteria (Sprint Level)
```
Sprint Planning → Development:
  ├── Sprint goal defined
  ├── Stories estimated and prioritized
  ├── Team capacity confirmed
  └── Definition of Ready met for all stories

Development → Testing:
  ├── Code complete and reviewed
  ├── Unit tests pass
  ├── Integration tests pass
  └── No critical bugs

Testing → Review:
  ├── All acceptance criteria met
  ├── Regression tests pass
  ├── Performance acceptable
  └── Demo ready

Review → Retrospective:
  ├── Sprint reviewed with stakeholders
  ├── Feedback captured
  └── Metrics collected
```

---

## 5. QUALITY AT EVERY PHASE

### 5.1 Shift-Left Quality
```
Traditional:        [Requirements] → [Design] → [Code] → [TEST] → [Deploy]
Shift-Left:   [TEST] → [Requirements] → [TEST] → [Design] → [TEST] → [Code] → [TEST] → [Deploy]

Quality activities in each phase:
├── Requirements: Reviews, prototypes, acceptance criteria definition
├── Design: Architecture review, threat modeling, design patterns review
├── Code: Static analysis, peer review, TDD, pair programming
├── Test: Automated suites, exploratory testing, performance testing
├── Deploy: Smoke tests, canary validation, monitoring alerts
```

### 5.2 Definition of Ready (DoR) — Before Development
- [ ] Story has clear acceptance criteria
- [ ] Story is estimated by the team
- [ ] Dependencies identified and available
- [ ] UI/UX designs ready (if applicable)
- [ ] Technical approach discussed
- [ ] No unresolved questions

### 5.3 Definition of Done (DoD) — After Development
- [ ] Code implemented and reviewed
- [ ] Unit tests written and passing
- [ ] Integration tests passing
- [ ] Documentation updated
- [ ] Acceptance criteria met
- [ ] No critical or high defects
- [ ] Performance benchmarks met
- [ ] Security scan clean
- [ ] Deployed to staging
- [ ] Product Owner accepts

---

## 6. ARTIFACT LIFECYCLE MANAGEMENT

### 6.1 Artifact Traceability
```
Business Need → Epic → Feature → User Story → Task → Code → Test Case → Defect → Release
     ↑_________________________________________________________________________________↓
```

### 6.2 Configuration Management
- **Identification:** Name, version, baseline all artifacts
- **Control:** Change request process, approval workflow
- **Status Accounting:** Track changes, versions, history
- **Audit:** Verify consistency between artifacts
- **Release Management:** Package, validate, distribute

---

## 7. METRICS & KPIs BY PHASE

| Phase | Key Metrics |
|-------|-------------|
| Planning | Schedule variance, budget variance, risk exposure |
| Requirements | Requirements volatility, traceability %, review defect density |
| Design | Design review defects, architecture compliance, tech debt index |
| Development | Code coverage, review defect density, build success rate, lead time |
| Testing | Defect density, defect escape rate, test coverage, MTTR |
| Deployment | Deployment frequency, change failure rate, MTTR, availability |

---

## 8. COMMON ANTI-PATTERNS & REMEDIES

| Anti-Pattern | Symptom | Remedy |
|-------------|---------|--------|
| **Big Bang Integration** | Everything integrated at end, massive failures | Integrate daily, CI/CD |
| **Code Freeze Hell** | Long freeze periods before release | Feature flags, trunk-based dev |
| **Documentation After** | Docs written post-delivery, always outdated | Docs as code, living documentation |
| **Testing as Phase** | Testing team waits for "complete" code | TDD, continuous testing |
| **Hero Culture** | Same person fixes everything | Knowledge sharing, pair programming |
| **Scope Creep** | Uncontrolled requirement additions | Change control, impact analysis |
| **Analysis Paralysis** | Endless planning, no delivery | Time-boxing, MVP approach |

---

**[END OF SKILL-02]**
