# 🎯 SKILL-01: Project Management & Planning

> **Domain:** Project Management  
> **Level:** Expert / Principal  
> **Scope:** Planning, estimation, tracking, stakeholder management, resource allocation, delivery assurance

---

## 1. PHILOSOPHY

Project management is not about Gantt charts — it is about **predictable delivery of value**.
- Plan for uncertainty, not perfection
- Communicate early and often
- Measure progress by outcomes, not activity
- Adapt the process to the project, not the project to the process

---

## 2. PROJECT INITIATION FRAMEWORK

### 2.1 Project Charter Template
```
PROJECT CHARTER
├── Project Name & Code
├── Executive Summary (1 paragraph)
├── Business Case (why this, why now, ROI)
├── Objectives (SMART: Specific, Measurable, Achievable, Relevant, Time-bound)
├── Scope
│   ├── In-Scope (explicit)
│   ├── Out-of-Scope (explicit)
│   └── Constraints (budget, time, resources, technology)
├── Stakeholders
│   ├── Sponsor (decision maker, budget owner)
│   ├── Product Owner (vision, priorities)
│   ├── Technical Lead (architecture, feasibility)
│   ├── Users (primary, secondary, personas)
│   └── Regulators (compliance, legal)
├── Success Criteria
│   ├── Business KPIs
│   ├── Technical KPIs
│   ├── User Satisfaction Metrics
│   └── Quality Gates
├── High-Level Risks
├── Budget & Timeline (rough)
├── Approval & Sign-off
└── Communication Plan
```

### 2.2 Stakeholder Analysis Matrix
```
           High Interest
                │
    Keep        │    Manage
    Satisfied   │    Closely
    ────────────┼────────────
    Monitor     │    Keep
    (Minimum)   │    Informed
                │
           Low Interest
         Low Power    High Power
```

### 2.3 RACI Matrix (for every deliverable)
- **R**esponsible: Does the work
- **A**ccountable: Ultimately answerable (only ONE per task)
- **C**onsulted: Provides input (two-way communication)
- **I**nformed: Kept updated (one-way communication)

---

## 3. ESTIMATION FRAMEWORK

### 3.1 Estimation Techniques

| Technique | When to Use | Accuracy | Effort |
|-----------|-------------|----------|--------|
| Expert Judgment | Novel projects, limited data | Medium | Low |
| Analogous | Similar past projects exist | Medium | Low |
| Parametric | Statistical relationships known | High | Medium |
| Three-Point (PERT) | Uncertainty is high | High | Medium |
| Planning Poker | Agile teams, relative sizing | Medium | Low |
| Function Point Analysis | Formal environments, contracts | High | High |
| Story Points | Agile, relative complexity | Medium | Low |
| T-Shirt Sizing | Early phase, rough estimates | Low | Very Low |

### 3.2 Three-Point Estimation Formula
```
Expected = (Optimistic + 4×Most Likely + Pessimistic) / 6
Standard Deviation = (Pessimistic - Optimistic) / 6
Variance = [(Pessimistic - Optimistic) / 6]²
```

### 3.3 Cone of Uncertainty
```
Initiation:  ±100% uncertainty
Requirements: ±50% uncertainty
Design:       ±25% uncertainty
Development:  ±10% uncertainty
Testing:      ±5% uncertainty
```
> **Rule:** Never commit to fixed estimates at initiation. Use ranges and refine.

### 3.4 Buffer Strategies
- **Feature Buffer:** 10-20% of scope is "nice to have" — can be dropped
- **Schedule Buffer:** Critical Chain Project Management (CCPM) — buffer at end of chain
- **Budget Buffer:** 15-20% contingency for unknown unknowns
- **Technical Buffer:** Spike stories for research and prototyping

---

## 4. PLANNING FRAMEWORKS

### 4.1 Work Breakdown Structure (WBS)
```
Level 1: Project
├── Level 2: Major Deliverable / Phase
│   ├── Level 3: Feature / Component
│   │   ├── Level 4: Task / User Story
│   │   │   ├── Level 5: Sub-task / Technical Task
```
> **Rule:** 100% Rule — WBS must include 100% of work defined by project scope.

### 4.2 Dependency Types
- **Finish-to-Start (FS):** A must finish before B starts (most common)
- **Start-to-Start (SS):** A and B start together
- **Finish-to-Finish (FF):** A and B finish together
- **Start-to-Finish (SF):** A must start before B finishes (rare)

### 4.3 Critical Path Method (CPM)
1. List all activities with durations
2. Identify dependencies
3. Draw network diagram
4. Calculate Early Start (ES), Early Finish (EF)
5. Calculate Late Start (LS), Late Finish (LF)
6. Identify Critical Path (zero slack)
7. Optimize: crash (add resources) or fast-track (parallel)

### 4.4 Milestone Planning
```
Milestone Characteristics:
├── Zero duration (a point in time)
├── Binary state (achieved or not)
├── External visibility (stakeholder-facing)
├── Quality gate (must pass criteria)
└── Trigger for next phase / payment

Example Milestones:
├── M1: Project Kick-off (Week 1)
├── M2: Requirements Baseline (Week 3)
├── M3: Architecture Approved (Week 5)
├── M4: MVP Feature Complete (Week 10)
├── M5: Security Audit Passed (Week 12)
├── M6: UAT Complete (Week 14)
├── M7: Production Deployment (Week 15)
└── M8: Post-Launch Review (Week 17)
```

---

## 5. TRACKING & CONTROL

### 5.1 Earned Value Management (EVM)
```
PV (Planned Value): Budgeted cost of work scheduled
EV (Earned Value): Budgeted cost of work performed
AC (Actual Cost): Actual cost of work performed

SPI = EV / PV  (Schedule Performance Index)
   > 1: Ahead of schedule
   = 1: On schedule
   < 1: Behind schedule

CPI = EV / AC  (Cost Performance Index)
   > 1: Under budget
   = 1: On budget
   < 1: Over budget

EAC = BAC / CPI  (Estimate at Completion)
ETC = EAC - AC   (Estimate to Complete)
VAC = BAC - EAC  (Variance at Completion)
```

### 5.2 Burndown / Burnup Charts
- **Sprint Burndown:** Work remaining vs. time (ideal downward slope)
- **Release Burnup:** Work completed + scope changes vs. time
- **Velocity Chart:** Story points completed per sprint (trending)

### 5.3 Status Reporting Template
```
WEEKLY STATUS REPORT
├── Executive Summary (3 bullets)
├── Milestones Status
│   ├── Achieved this week
│   ├── At risk
│   └── Upcoming
├── Scope Changes
│   ├── Added (with business justification)
│   ├── Removed (with stakeholder approval)
│   └── Impact analysis
├── Budget Status
│   ├── Spent vs. Planned
│   ├── Forecast (EAC)
│   └── Variance explanation
├── Risk Update
│   ├── New risks
│   ├── Mitigated risks
│   └── Escalated risks
├── Issues & Blockers
│   ├── Description
│   ├── Owner
│   ├── Target Resolution
│   └── Impact
├── Quality Metrics
│   ├── Defect density
│   ├── Test coverage
│   └── Performance benchmarks
├── Team Health
│   ├── Capacity (vacation, training)
│   ├── Morale indicators
│   └── Skills gaps
└── Next Week Priorities
```

### 5.4 Traffic Light System
- 🟢 **Green:** On track, no action needed
- 🟡 **Yellow:** At risk, mitigation in progress, watch closely
- 🔴 **Red:** Off track, escalation required, immediate action

---

## 6. STAKEHOLDER COMMUNICATION

### 6.1 Communication Matrix
```
Stakeholder    │ Frequency │ Method      │ Content              │ Owner
───────────────┼───────────┼─────────────┼──────────────────────┼─────────
Executive      │ Weekly    │ Dashboard   │ Budget, milestones   │ PM
Sponsor        │ Bi-weekly │ Meeting     │ Strategic decisions  │ PM
Product Owner  │ Daily     │ Standup     │ Priorities, blockers │ PO
Dev Team       │ Daily     │ Standup     │ Tasks, dependencies  │ Tech Lead
QA Team        │ Daily     │ Standup     │ Test status, bugs    │ QA Lead
Users          │ Sprint    │ Demo        │ Features, feedback   │ PO
Regulators     │ Monthly   │ Report      │ Compliance status    │ Compliance
```

### 6.2 Escalation Protocol
```
Level 1: Team internal (within 24h)
Level 2: Tech Lead / PO (within 48h)
Level 3: PM / Sponsor (within 72h)
Level 4: Executive / Steering Committee (immediate)
```

---

## 7. RESOURCE MANAGEMENT

### 7.1 Team Capacity Planning
```
Sprint Capacity = 
  (Team Members × Available Hours × Focus Factor) 
  - Vacation - Training - Meetings - Buffer

Focus Factors:
├── New team: 0.6
├── Established team: 0.7
├── High-performing team: 0.8
└── Sustained high performance: 0.75 (avoid burnout)
```

### 7.2 Skills Matrix
```
            │ Frontend │ Backend │ DevOps │ Security │ AI/ML │ UX │ Level
────────────┼──────────┼─────────┼────────┼──────────┼───────┼────┼─────
Alice       │    ★★★   │   ★★☆   │  ★☆☆   │   ★★☆    │  ★☆☆  │ ★★☆│ Sr
Bob         │    ★☆☆   │   ★★★   │  ★★☆   │   ★☆☆    │  ★★☆  │ ★☆☆│ Sr
Charlie     │    ★★☆   │   ★★☆   │  ★★★   │   ★★☆    │  ★☆☆  │ ★☆☆│ Mid
```

### 7.3 Resource Leveling
- Avoid over-allocation (>80% sustained)
- Balance critical vs. non-critical tasks
- Account for context switching cost (20-40% productivity loss)
- Plan for knowledge transfer and bus factor

---

## 8. QUALITY GATES IN PROJECT MANAGEMENT

### 8.1 Phase Gates (Stage-Gate Model)
```
Gate 0: Idea Screening      → Business case viability
Gate 1: Scoping             → Requirements clarity
Gate 2: Business Case       → Financial justification
Gate 3: Development         → Technical feasibility
Gate 4: Testing             → Quality assurance
Gate 5: Launch              → Go/No-Go decision
Gate 6: Post-Launch         → Lessons learned, optimization
```

### 8.2 Go/No-Go Criteria
```
MUST PASS ALL:
├── Requirements traceability ≥ 95%
├── Architecture review passed
├── Security threat model approved
├── Test coverage ≥ 80% (unit) + 100% (critical paths)
├── Performance benchmarks met
├── Accessibility audit passed
├── Documentation complete
├── Training plan ready
├── Rollback plan tested
└── Stakeholder sign-off obtained
```

---

## 9. PROJECT CLOSURE

### 9.1 Closure Checklist
- [ ] All deliverables accepted and signed off
- [ ] Final budget reconciliation
- [ ] Lessons learned document (what went well, what didn't, why)
- [ ] Knowledge transfer completed
- [ ] Documentation archived
- [ ] Contracts closed
- [ ] Team recognition and release
- [ ] Post-implementation review scheduled (30/60/90 days)

### 9.2 Lessons Learned Template
```
LESSONS LEARNED REGISTER
├── Category: [Technical / Process / People / Tools]
├── Phase: [Planning / Execution / Testing / Deployment]
├── What Happened:
├── Root Cause:
├── Impact:
├── What We Did:
├── What We Should Have Done:
├── Action for Next Time:
├── Owner:
└── Status: [Open / Closed / In Progress]
```

---

## 10. TOOLS & TEMPLATES

### Recommended Tools
- **Planning:** Jira, Azure DevOps, Monday.com, ClickUp
- **Visualization:** Miro, Lucidchart, Draw.io
- **Tracking:** Jira, Linear, Asana, Trello
- **Reporting:** Power BI, Tableau, Google Data Studio
- **Documentation:** Confluence, Notion, Wiki
- **Communication:** Slack, Teams, Discord

### Key Templates
- Project Charter
- WBS Dictionary
- Risk Register
- Issue Log
- Change Request Form
- Status Report
- Meeting Minutes
- Decision Log
- Lessons Learned
- Project Closure Report

---

**[END OF SKILL-01]**
