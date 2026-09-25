---
name: SKILL-10
version: 1.0.0
description: Agile Methodologies
classification: MEDIUM
domain: Agile Development, Scrum, XP, Kanban, Hybrid Approaches
level: Expert / Principal
---

# 🏃 SKILL-10: Agile Methodologies

> **Domain:** Agile Development, Scrum, XP, Kanban, Hybrid Approaches  
> **Level:** Expert / Principal  
> **Scope:** All agile frameworks, ceremonies, scaling, metrics, team dynamics, continuous improvement

---

## 1. PHILOSOPHY

Agile is not a methodology — it is a **mindset**.
- Responding to change is more valuable than following a plan
- Working software is the primary measure of progress
- Collaboration over contract negotiation
- Individuals and interactions over processes and tools
- Sustainable pace — no heroics, no burnout
- Technical excellence enables agility; shortcuts destroy it

---

## 2. AGILE MANIFESTO & PRINCIPLES

### 2.1 The Four Values
```
Individuals and interactions    over    Processes and tools
Working software                over    Comprehensive documentation
Customer collaboration          over    Contract negotiation
Responding to change            over    Following a plan

"That is, while there is value in the items on the right,
we value the items on the left more."
```

### 2.2 The Twelve Principles
```
1. Highest priority: satisfy customer through early and continuous delivery
2. Welcome changing requirements, even late in development
3. Deliver working software frequently (weeks > months)
4. Business people and developers work together daily
5. Build projects around motivated individuals; give them environment and support
6. Face-to-face conversation is the most efficient method
7. Working software is the primary measure of progress
8. Agile processes promote sustainable development (constant pace indefinitely)
9. Continuous attention to technical excellence and good design enhances agility
10. Simplicity — the art of maximizing work NOT done — is essential
11. Best architectures, requirements, and designs emerge from self-organizing teams
12. Regular reflection on how to become more effective, then tune and adjust
```

---

## 3. SCRUM FRAMEWORK

### 3.1 Scrum Roles
```
PRODUCT OWNER:
├── Maximizes product value
├── Manages Product Backlog (ordering, clarity, transparency)
├── Represents stakeholders and users
├── Makes prioritization decisions
├── Accepts or rejects work results
├── Defines "Done"
└── NOT a project manager, NOT a team lead

SCRUM MASTER:
├── Servant leader to the team
├── Removes impediments
├── Facilitates Scrum events
├── Coaches team on Scrum theory and practice
├── Protects team from external interruptions
├── Promotes self-organization
└── NOT a manager, NOT a task assigner

DEVELOPMENT TEAM:
├── Cross-functional (all skills needed to deliver)
├── Self-organizing (who does what, how)
├── 3-9 members (optimal: 5-7)
├── No sub-teams
├── Collective accountability for Sprint Goal
└── Estimates work together
```

### 3.2 Scrum Artifacts
```
PRODUCT BACKLOG:
├── Ordered list of everything needed in the product
├── Single source of requirements
├── Never complete (living document)
├── Items: User Stories, Bugs, Technical Debt, Spikes
├── Refined continuously
└── DEEP: Detailed, Estimated, Emergent, Prioritized

SPRINT BACKLOG:
├── Subset of Product Backlog selected for Sprint
├── Plus plan for delivering Increment
├── Owned by Development Team
├── Updated daily during Sprint
└── Visible to all (transparency)

PRODUCT INCREMENT:
├── Sum of all Product Backlog items completed during Sprint
├── PLUS all previous Increments
├── Must be "Done" (potentially releasable)
├── Demonstrated at Sprint Review
└── May or may not be released
```

### 3.3 Scrum Events (Ceremonies)

#### Sprint (Time-Box: 1-4 weeks, typically 2)
```
├── Container for all other events
├── Fixed duration (never extended)
├── New Sprint starts immediately after previous ends
├── Sprint Goal provides direction
├── Scope can be renegotiated between PO and Team
└── NO changes that endanger Sprint Goal
```

#### Sprint Planning (Time-Box: 2-4 hours for 2-week Sprint)
```
TOPIC 1: WHAT can be done this Sprint?
├── PO presents highest priority Product Backlog items
├── Team asks clarifying questions
├── Team forecasts what they can accomplish
├── Sprint Goal is crafted collaboratively
└── Output: Sprint Backlog (selected items)

TOPIC 2: HOW will the chosen work get done?
├── Team designs the work
├── Tasks created (if needed)
├── Dependencies identified
├── Capacity considered (vacation, meetings)
└── Output: Sprint Plan

CAPACITY PLANNING:
Sprint Capacity = (Team Members × Available Hours × Focus Factor) - Overhead
Focus Factor: 0.6 (new team) to 0.8 (experienced team)
```

#### Daily Scrum (Time-Box: 15 minutes, same time/place)
```
PURPOSE: Inspect progress toward Sprint Goal, adapt plan

STRUCTURE (suggested):
├── What did I do yesterday that helped the team meet Sprint Goal?
├── What will I do today to help the team meet Sprint Goal?
└── Do I see any impediments that prevent me or the team?

RULES:
├── Team-only (others can observe, not participate)
├── Not a status report to SM or PO
├── Detailed discussions happen after (parking lot)
├── Stand up (literally) to keep it short
├── Start on time, end on time
└── Use board/visualization
```

#### Sprint Review (Time-Box: 1-2 hours for 2-week Sprint)
```
PURPOSE: Inspect Increment, adapt Product Backlog

PARTICIPANTS: Scrum Team + Stakeholders

AGENDA:
├── PO reviews Sprint Goal and what was accomplished
├── Team demonstrates working software (live demo)
├── Stakeholders ask questions, provide feedback
├── PO discusses Product Backlog current state
├── Collaborate on what to do next
├── Review timeline, budget, capabilities
└── Adapt Product Backlog based on feedback

NOT:
├── Not a sign-off meeting
├── Not a presentation to management
├── Not a demo only (it's a working session)
└── Not limited to "completed" items (show progress too)
```

#### Sprint Retrospective (Time-Box: 1-1.5 hours for 2-week Sprint)
```
PURPOSE: Inspect people, relationships, process, tools; create improvement plan

STRUCTURE:
├── Set the stage (5 min): Safety check, focus
├── Gather data (10 min): What happened? Facts.
├── Generate insights (15 min): Why did things happen? Patterns.
├── Decide actions (15 min): What will we improve? (1-3 actions max)
├── Close (5 min): Summary, appreciation

FORMATS:
├── Start/Stop/Continue
├── 4Ls: Liked, Learned, Lacked, Longed For
├── Sailboat: Wind (helped), Anchors (held back), Rocks (risks), Island (goal)
├── Mad/Sad/Glad
├── Timeline (events over Sprint)
└── Metrics-based (velocity, bugs, cycle time)

RULES:
├── Safe environment (no blame, no judgment)
├── Focus on system, not individuals
├── Actionable improvements (specific, measurable, assigned)
├── Track action items from previous retrospectives
├── SM facilitates, team owns improvements
└── Happens after every Sprint (non-negotiable)
```

### 3.4 Definition of Ready (DoR)
```
BEFORE entering Sprint:
├── Clear description
├── Acceptance criteria defined
├── Dependencies identified and available
├── Sized by team
├── No unresolved questions
├── Testable (can verify completion)
├── UI/UX designs ready (if applicable)
└── Technical approach discussed
```

### 3.5 Definition of Done (DoD)
```
BEFORE considered complete:
├── Code written and reviewed
├── Unit tests written and passing
├── Integration tests passing
├── Code follows style guide
├── Documentation updated
├── Acceptance criteria met
├── No critical/high defects
├── Performance acceptable
├── Security scan clean
├── Accessibility checked
├── Deployed to staging
├── Product Owner accepts
└── (Team-specific items)
```

---

## 4. EXTREME PROGRAMMING (XP)

### 4.1 XP Practices
```
CORE PRACTICES:
├── Pair Programming: Two developers, one workstation
│   ├── Driver writes code
│   ├── Navigator reviews, thinks strategically
│   ├── Rotate every 15-30 minutes
│   ├── Knowledge sharing
│   └── Higher quality, slightly slower individual speed

├── Test-Driven Development (TDD):
│   ├── Red: Write failing test
│   ├── Green: Write minimum code to pass
│   ├── Refactor: Improve design while tests pass
│   └── Repeat

├── Continuous Integration:
│   ├── Integrate code multiple times per day
│   ├── Automated build and test on every commit
│   ├── Fix broken builds immediately
│   └── Trunk-based development preferred

├── Refactoring:
│   ├── Improve code without changing behavior
│   ├── Continuous improvement
│   ├── Supported by comprehensive tests
│   └── Boy Scout Rule: Leave code cleaner than you found it

├── Simple Design:
│   ├── Runs all tests
│   ├── Expresses intent clearly
│   ├── No duplication (DRY)
│   └── Minimal elements (YAGNI)

├── Collective Code Ownership:
│   ├── Anyone can change any code
│   ├── No "my code" / "your code"
│   ├── Requires coding standards
│   └── Knowledge distributed across team

├── Sustainable Pace:
│   ├── 40-hour work week
│   ├── No overtime for more than one week
│   ├── Burnout prevention
│   └── Consistent velocity over time

├── On-Site Customer:
│   ├── Real user available to team
│   ├── Immediate clarification
│   ├── Acceptance testing
│   └── Domain knowledge transfer

├── Planning Game:
│   ├── Business decides scope and priority
│   ├── Technical decides estimates and feasibility
│   ├── Collaborative negotiation
│   └── Regular replanning

├── Small Releases:
│   ├── Frequent production deployments
│   ├── Rapid feedback
│   ├── Reduced risk per release
│   └── Easier rollback

├── Metaphor:
│   ├── Shared conceptual framework
│   ├── Guides architecture and naming
│   └── Aligns team understanding

├── Coding Standards:
│   ├── Consistent style across team
│   ├── Automated enforcement
│   ├── Enables collective ownership
│   └── Reduces cognitive load
```

---

## 5. KANBAN

### 5.1 Kanban Principles
```
CORE PRINCIPLES:
├── Start with what you do now (no big bang change)
├── Agree to pursue incremental, evolutionary change
├── Respect current process, roles, responsibilities
├── Encourage acts of leadership at all levels

CORE PRACTICES:
├── Visualize the workflow (Kanban board)
├── Limit Work In Progress (WIP)
├── Manage flow (smooth, predictable)
├── Make process policies explicit
├── Implement feedback loops
├── Improve collaboratively, evolve experimentally
```

### 5.2 Kanban Board Design
```
TYPICAL COLUMNS:
Backlog → Ready → In Progress → Code Review → Testing → Done

WIP LIMITS:
├── Set per column (e.g., In Progress: 3)
├── Formula: WIP = Team Size × 1.5 (starting point)
├── Adjust based on flow metrics
├── Never exceed WIP limit without explicit discussion
└── Purpose: Reduce multitasking, improve focus, expose bottlenecks

CLASSES OF SERVICE:
├── Standard: Normal work items
├── Expedite: Urgent, interrupt current work (limit: 1 at a time)
├── Fixed Date: Time-sensitive deadlines
├── Intangible: Technical debt, refactoring
└── Each has different policies and WIP limits
```

### 5.3 Kanban Metrics
```
LEAD TIME: Total time from request to delivery
CYCLE TIME: Time from start of work to delivery
THROUGHPUT: Number of items completed per time period
WORK IN PROGRESS: Number of items currently being worked on
FLOW EFFICIENCY: Active work time / Total lead time

CUMULATIVE FLOW DIAGRAM (CFD):
├── X-axis: Time
├── Y-axis: Number of items
├── Areas: Backlog, In Progress, Done
├── Shows bottlenecks (widening bands)
└── Shows WIP trends

CONTROL CHART:
├── X-axis: Time
├── Y-axis: Cycle time per item
├── Shows variation and trends
├── Identify outliers (investigate)
└── Target: Reduce mean and variation
```

---

## 6. OTHER AGILE APPROACHES

### 6.1 Incremental Development
```
APPROACH: Build system in increments, each adding functionality

CHARACTERISTICS:
├── Each increment is a usable subset
├── Requirements prioritized by value
├── Highest value delivered first
├── Feedback from each increment informs next
├── Architecture evolves with increments
└── Integration testing per increment

VS. ITERATIVE:
├── Incremental: Build by adding pieces (breadth-first)
├── Iterative: Build by refining whole (depth-first)
├── Often combined: Iterative within increments
```

### 6.2 Waterfall (When Appropriate)
```
WHEN WATERFALL IS BETTER:
├── Fixed scope with clear, stable requirements
├── Regulatory/compliance requirements (medical, aerospace)
├── Contract-based with fixed price
├── Safety-critical systems
├── Limited stakeholder availability
└── Well-understood domain with low uncertainty

WATERFALL PHASES:
Requirements → Design → Implementation → Testing → Deployment → Maintenance

RISK: Late feedback, change is expensive
MITIGATION: Prototypes, proof of concepts, early validation
```

### 6.3 Hybrid Approaches
```
AGILE-WATERFALL HYBRID:
├── Requirements: Waterfall (fixed baseline)
├── Design: Iterative (prototypes, reviews)
├── Development: Agile (sprints, iterative)
├── Testing: Continuous (shift-left)
├── Deployment: Agile (CI/CD)
└── Documentation: Waterfall (compliance needs)

SAFe (Scaled Agile Framework):
├── Portfolio → Large Solution → Program → Team
├── PI Planning (Program Increment): 8-12 weeks
├── Agile Release Train (ART): 50-125 people
├── Roles: RTE, Product Management, System Architect
├── Ceremonies: PI Planning, System Demos, Inspect & Adapt
└── Best for: Large enterprises, multiple teams, dependencies

LeSS (Large-Scale Scrum):
├── 2-8 teams, one Product Owner
├── One Product Backlog, one Definition of Done
├── One Sprint for all teams
├── Shared Sprint Review and Retrospective
├── Coordination: Communities, scouts, open spaces
└── Best for: Multiple teams, one product, Scrum purists

Disciplined Agile (DA):
├── Goal-driven, context-sensitive
├── Choose your way of working (WoW)
├── Hybrid of agile, lean, traditional
├── Role-based guidance
└── Best for: Organizations needing flexibility, not prescription
```

---

## 7. AGILE METRICS

### 7.1 Flow Metrics (Kanban/Scrum)
```
LEAD TIME:
├── Total time: Request created → Delivered to customer
├── Includes waiting time
├── Target: Reduce and stabilize
└── Customer-facing metric

CYCLE TIME:
├── Active time: Work started → Work completed
├── Excludes waiting time
├── Target: Reduce and stabilize
└── Team efficiency metric

THROUGHPUT:
├── Items completed per Sprint/week
├── Trend over time
├── Target: Stable or increasing
└── Capacity planning metric

WORK IN PROGRESS (WIP):
├── Items currently in progress
├── Target: Stable, within WIP limits
├── High WIP = multitasking = slower delivery
└── Little's Law: Cycle Time = WIP / Throughput

VELOCITY (Scrum):
├── Story points completed per Sprint
├── Trend over 3-5 Sprints (not single Sprint)
├── Target: Stable (not increasing)
├── Used for capacity planning, NOT performance measurement
└── Never compare velocity between teams
```

### 7.2 Quality Metrics
```
ESCAPE RATE:
├── Defects found in production / Total defects
├── Target: < 5%
└── Indicator of testing effectiveness

TECHNICAL DEBT RATIO:
├── Estimated cost to fix debt / Cost to rebuild
├── Target: < 10%
└── Monitor trend, not absolute

CODE CHURN:
├── Lines changed per file per Sprint
├── High churn = instability
└── Target: Decreasing over time

CYCLE TIME FOR BUGS:
├── Time from report to fix deployed
├── Target: SLA-based (Critical: 24h, High: 72h, etc.)
└── Customer satisfaction indicator
```

### 7.3 Team Health Metrics
```
HAPPINESS INDEX:
├── Team mood survey (1-5 scale)
├── Anonymous, weekly
├── Trend over time
└── Early warning for burnout

RETROSPECTIVE ACTION COMPLETION:
├── Actions identified vs. Actions completed
├── Target: > 80% completion rate
└── Indicator of continuous improvement

CROSS-FUNCTIONAL COVERAGE:
├── % of team members who can work on different areas
├── Target: No single point of failure
└── Bus factor improvement
```

---

## 8. AGILE ANTI-PATTERNS

```
FAKE AGILE:
├── "We do Scrum but..." (no retrospectives, no Sprint Goal)
├── Command-and-control Scrum Master
├── PO as proxy for business (no real authority)
├── Fixed scope, fixed date, fixed budget (iron triangle)
├── Velocity as performance metric
├── No time for technical excellence
└── Sprints as mini-waterfalls

SCOPE CREEP:
├── Adding work mid-Sprint without removing equivalent work
├── PO bypasses Sprint Backlog
├── Stakeholders pressure team directly
└── Mitigation: Sprint Goal protection, change control

LACK OF AUTOMATION:
├── Manual testing bottleneck
├── Manual deployment
├── Manual environment setup
└── Mitigation: Invest in CI/CD, test automation

TECHNICAL DEBT NEGLECT:
├── No refactoring time
├── "We'll fix it later" (never happens)
├── Architecture degrades
└── Mitigation: Allocate 20% capacity to technical debt

SILOED TEAMS:
├── "Not my job" mentality
├── Handoffs between teams
├── Blame culture
└── Mitigation: Cross-training, collective ownership

PLANNING OVER PLANNING:
├── Excessive upfront planning
├── Detailed plans for distant future
├── Resistance to change
└── Mitigation: Rolling wave planning, just-in-time refinement
```

---

## 9. SCALING AGILE

### 9.1 When to Scale
```
SIGNALS YOU NEED TO SCALE:
├── Multiple teams working on same product
├── Dependencies between teams causing delays
├── Coordination overhead exceeding value
├── Inconsistent practices across teams
├── Integration failures between team outputs
└── Business needs faster delivery than single team can provide

ANTI-SIGNALS (Don't scale yet):
├── Single team can handle the work
├── Teams are not yet proficient at basic agile
├── Organizational culture resists agile
├── Leadership not committed to agile values
└── Trying to scale to fix team-level problems
```

### 9.2 Scaling Principles
```
├── Minimize dependencies (architecture, team structure)
├── Align teams to value streams, not components
├── Decentralize decision-making
├── Standardize "just enough" (Definition of Done, engineering practices)
├── Visualize cross-team work
├── Regular cross-team synchronization
├── Measure end-to-end flow, not team velocity
└── Invest in platform teams (enablement)
```

---

**[END OF SKILL-10]**
