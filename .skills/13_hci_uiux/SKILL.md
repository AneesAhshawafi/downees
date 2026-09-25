---
name: SKILL-13
version: 1.0.0
description: HCI & UI/UX
classification: MEDIUM
domain: Human-Computer Interaction, User Experience, Accessibility, Cross-Cultural Design
level: Expert / Principal
---

# 🎨 SKILL-13: HCI & UI/UX

> **Domain:** Human-Computer Interaction, User Experience, Accessibility, Cross-Cultural Design  
> **Level:** Expert / Principal  
> **Scope:** Design systems, accessibility (WCAG), cross-device design, cross-cultural UX, usability metrics, interaction patterns

---

## 1. PHILOSOPHY

The interface is not a skin on top of functionality — it is **the product**.
- Users don't care about your architecture; they care about their experience
- Accessibility is not a feature — it is a human right
- Design for the edge case, and the average case improves
- Cultural context shapes perception; one design does not fit all
- Good UX is invisible; bad UX is unforgettable

---

## 2. DESIGN SYSTEMS

### 2.1 Design System Architecture
```
DESIGN SYSTEM COMPONENTS:
├── Design Tokens
│   ├── Colors (primary, secondary, semantic, neutral)
│   ├── Typography (font families, sizes, weights, line heights)
│   ├── Spacing (scale: 4px, 8px, 16px, 24px, 32px, 48px, 64px)
│   ├── Shadows (elevation levels)
│   ├── Borders (radius, width, style)
│   ├── Breakpoints (mobile, tablet, desktop, wide)
│   ├── Z-index scale
│   └── Motion (duration, easing curves)
├── Components
│   ├── Atoms: Button, Input, Label, Icon, Badge
│   ├── Molecules: Search Bar, Form Field, Card Header
│   ├── Organisms: Navigation, Hero Section, Data Table
│   ├── Templates: Page Layouts, Dashboard Layouts
│   └── Pages: Complete Screens
├── Patterns
│   ├── Navigation patterns
│   ├── Form patterns
│   ├── Feedback patterns
│   ├── Data display patterns
│   └── Empty states
├── Guidelines
│   ├── Voice and tone
│   ├── Writing style
│   ├── Imagery guidelines
│   └── Iconography rules
└── Documentation
    ├── Usage examples
    ├── Do's and Don'ts
    ├── Accessibility notes
    └── Code snippets
```

### 2.2 Atomic Design Methodology
```
ATOMS: Basic building blocks
├── HTML tags: label, input, button
├── Abstract: color palettes, fonts, animations
└── Cannot be broken down further

MOLECULES: Groups of atoms
├── Search form: label + input + button
├── Form field: label + input + error message
└── Simple, portable, reusable

ORGANISMS: Complex components
├── Header: logo + navigation + search + user menu
├── Product card: image + title + price + rating + button
└── Distinct sections of interface

TEMPLATES: Page-level layouts
├── Wireframes with placeholder content
├── Structure without real data
└── Focus on layout and composition

PAGES: Real content in templates
├── Actual user data
├── Variations and edge cases
└── Test the design system with reality
```

---

## 3. USABILITY PRINCIPLES

### 3.1 Nielsen's 10 Usability Heuristics
```
1. VISIBILITY OF SYSTEM STATUS
   ├── Keep users informed (loading states, progress bars)
   ├── Appropriate feedback within reasonable time
   └── Example: "Saving..." → "Saved" with timestamp

2. MATCH BETWEEN SYSTEM AND REAL WORLD
   ├── Use familiar language (not system jargon)
   ├── Follow real-world conventions
   └── Example: Shopping cart icon, not "transaction buffer"

3. USER CONTROL AND FREEDOM
   ├── Undo and redo
   ├── Clear exit points
   ├── Escape hatches
   └── Example: "Cancel" button, back navigation

4. CONSISTENCY AND STANDARDS
   ├── Platform conventions (iOS Human Interface, Material Design)
   ├── Internal consistency (same action = same result)
   └── Example: Same button style for primary actions everywhere

5. ERROR PREVENTION
   ├── Design to prevent problems
   ├── Confirmation for destructive actions
   └── Example: "Are you sure?" for delete, inline validation

6. RECOGNITION RATHER THAN RECALL
   ├── Make options visible
   ├── Reduce memory load
   └── Example: Dropdown menus vs. typing commands

7. FLEXIBILITY AND EFFICIENCY OF USE
   ├── Accelerators for experts (keyboard shortcuts)
   ├── Defaults for novices
   └── Example: Cmd+K command palette, default values

8. AESTHETIC AND MINIMALIST DESIGN
   ├── No irrelevant information
   ├── Every element serves a purpose
   └── Example: Clean dashboard, focused on key metrics

9. HELP USERS RECOGNIZE, DIAGNOSE, AND RECOVER FROM ERRORS
   ├── Plain language error messages
   ├── Constructive suggestions
   └── Example: "Password must be at least 8 characters" not "Error 402"

10. HELP AND DOCUMENTATION
    ├── Easy to search
    ├── Task-focused
    ├── Step-by-step instructions
    └── Example: Contextual help, tooltips, onboarding
```

### 3.2 Fitts's Law
```
TIME TO REACH TARGET = a + b × log₂(D/W + 1)

Where:
├── D = Distance to target
├── W = Width of target
└── a, b = constants

IMPLICATIONS:
├── Larger targets are easier to hit (buttons, touch targets)
├── Closer targets are faster to reach
├── Corner and edge targets are "infinite" in one dimension
├── Important actions: Large, nearby, prominent
└── Minimum touch target: 44×44pt (iOS), 48×48dp (Android)
```

### 3.3 Hick's Law
```
DECISION TIME = a + b × log₂(n)

Where n = number of choices

IMPLICATIONS:
├── Minimize choices for faster decisions
├── Group options into categories
├── Progressive disclosure (show options on demand)
├── Default selections reduce cognitive load
└── Search beats browsing for large sets
```

### 3.4 Gestalt Principles
```
PROXIMITY: Elements close together are perceived as related
├── Group related controls
├── Separate unrelated content
└── Example: Form labels close to inputs

SIMILARITY: Similar elements are perceived as related
├── Same color = same category
├── Same shape = same function
└── Example: All primary actions same color

CONTINUITY: Eyes follow smooth paths
├── Align elements along lines
├── Use visual flow
└── Example: Step indicators in a line

CLOSURE: Mind fills in missing information
├── Use negative space
├── Simplify complex shapes
└── Example: Logo design, iconography

FIGURE-GROUND: Perception separates foreground from background
├── Clear visual hierarchy
├── Contrast defines elements
└── Example: Modal overlays, cards on background

COMMON REGION: Elements in same container are related
├── Use borders, backgrounds, cards
├── Group related functionality
└── Example: Settings panels, dashboard widgets
```

---

## 4. ACCESSIBILITY (WCAG 2.1)

### 4.1 WCAG Principles (POUR)
```
PERCEIVABLE: Information must be presentable
├── Text alternatives for images (alt text)
├── Captions/transcripts for media
├── Color not sole means of conveying info
├── Text resizable up to 200%
├── Content doesn't lose meaning when zoomed
└── Sufficient contrast (see below)

OPERABLE: Interface components must be operable
├── All functionality available from keyboard
├── No time limits (or adjustable)
├── No seizures (no flashing >3Hz)
├── Navigable (skip links, page titles, focus order)
├── Input modalities (touch, voice, switch)
└── Target size minimum 44×44 CSS pixels

UNDERSTANDABLE: Information and UI must be understandable
├── Readable text (language identification)
├── Predictable navigation
├── Input assistance (error prevention, suggestions)
├── Consistent identification
└── Error messages in plain language

ROBUST: Content works with assistive technologies
├── Valid HTML/markup
├── Name, role, value for custom components
├── Status messages announced
└── Compatible with current and future tools
```

### 4.2 Contrast Requirements
```
LEVEL AA (Minimum):
├── Normal text (< 18pt or < 14pt bold): 4.5:1
├── Large text (≥ 18pt or ≥ 14pt bold): 3:1
├── UI components and graphical objects: 3:1

LEVEL AAA (Enhanced):
├── Normal text: 7:1
├── Large text: 4.5:1

TOOLS:
├── WebAIM Contrast Checker
├── Stark (Figma plugin)
├── axe DevTools
├── Lighthouse
└── Color contrast analyzers
```

### 4.3 Keyboard Navigation
```
REQUIREMENTS:
├── All interactive elements focusable
├── Visible focus indicator (don't remove outline!)
├── Logical tab order (matches visual order)
├── Skip links (bypass blocks)
├── No keyboard traps
├── Escape closes modals/dropdowns
├── Enter/Space activates buttons
├── Arrow keys navigate within components
└── Home/End for list navigation

FOCUS MANAGEMENT:
├── Focus visible: 2px solid outline (minimum)
├── Focus trap in modals (Tab cycles within modal)
├── Return focus after modal closes
├── Focus moved to new content (SPA routing)
└── No focus on disabled elements
```

### 4.4 Screen Reader Support
```
LANDMARKS:
├── <header> or role="banner"
├── <nav> or role="navigation"
├── <main> or role="main"
├── <aside> or role="complementary"
├── <footer> or role="contentinfo"
└── <section> with aria-label or aria-labelledby

HEADINGS:
├── Hierarchical: h1 → h2 → h3 (don't skip)
├── One h1 per page
├── Descriptive text (not "Section 1")
└── Used for navigation (screen reader users skim headings)

ARIA ATTRIBUTES:
├── aria-label: Accessible name for element
├── aria-labelledby: References another element for name
├── aria-describedby: Additional description
├── aria-expanded: State of expandable content
├── aria-hidden: Hide decorative elements
├── aria-live: Announce dynamic content (polite, assertive)
├── aria-pressed: Toggle button state
├── aria-current: Current page/step
└── role: Semantic role (when HTML element insufficient)

FORMS:
├── <label> associated with <input> (for attribute)
├── aria-required for required fields
├── aria-invalid for validation errors
├── aria-describedby for error messages
├── Fieldset + legend for grouped fields
└── Error summary at top of form
```

### 4.5 Accessibility Testing Checklist
```
AUTOMATED (Tools):
├── axe-core (browser extension, CI integration)
├── Lighthouse accessibility audit
├── WAVE (Web Accessibility Evaluation Tool)
├── Pa11y (command-line accessibility testing)
└── Screen reader testing (NVDA, JAWS, VoiceOver)

MANUAL CHECKS:
├── Keyboard-only navigation (Tab, Enter, Escape, Arrows)
├── Screen reader navigation (headings, landmarks, forms)
├── Zoom to 200% (no horizontal scroll, content readable)
├── Color contrast verification
├── Focus indicator visibility
├── Motion/prefers-reduced-motion
├── Touch target sizes (mobile)
└── Cognitive accessibility (plain language, consistency)
```

---

## 5. CROSS-DEVICE DESIGN

### 5.1 Responsive Design Strategy
```
MOBILE-FIRST:
├── Design for smallest screen first
├── Progressive enhancement for larger screens
├── Forces focus on essential content
├── Better performance on mobile
└── CSS: @media (min-width: 768px) { ... }

BREAKPOINTS:
├── Mobile: < 576px
├── Tablet: 576px - 991px
├── Desktop: 992px - 1199px
├── Large Desktop: ≥ 1200px
└── Use content-based breakpoints, not device-based

FLUID GRID:
├── Percentage-based widths
├── CSS Grid / Flexbox
├── Max-width containers
└── Gutter spacing scales with viewport

IMAGES:
├── Responsive images (srcset, sizes)
├── Lazy loading (loading="lazy")
├── WebP format with JPEG fallback
├── Proper sizing (don't download 2000px image for 300px display)
└── Art direction (<picture> element for different crops)

TOUCH TARGETS:
├── Minimum: 44×44pt (iOS), 48×48dp (Android)
├── Spacing between targets: 8px minimum
├── Hover states don't exist on touch
├── Swipe gestures need visual affordances
└── Thumb zone optimization (bottom center for one-handed use)
```

### 5.2 Device-Specific Considerations
```
MOBILE:
├── Thumb-friendly navigation (bottom tabs)
├── Reduced data usage
├── Offline capability
├── Biometric authentication
├── Push notifications
├── Deep linking
├── App store guidelines (iOS HIG, Material Design)
└── Performance: < 3s first contentful paint

TABLET:
├── Split view / multi-pane layouts
├── Landscape and portrait optimization
├── Stylus support
├── Larger touch targets than mobile
├── Different use context (lean-back vs. lean-forward)
└── iPad-specific: Slide Over, Split View, Drag and Drop

DESKTOP:
├── Hover states and tooltips
├── Right-click context menus
├── Keyboard shortcuts
├── Multi-window support
├── Drag and drop
├── Higher information density
└── Precision input (mouse)

WEARABLES:
├── Glanceable information
├── Minimal interaction
├── Voice input
├── Haptic feedback
├── Battery optimization
└── Context-aware (location, activity)

TV / BIG SCREEN:
├── 10-foot UI (large text, high contrast)
├── D-pad / remote navigation
├── No hover, minimal typing
├── Focus states highly visible
├── Dark mode preferred
└── Performance: 60fps animations
```

---

## 6. CROSS-CULTURAL DESIGN

### 6.1 Internationalization (i18n) & Localization (l10n)
```
TEXT:
├── Never hardcode strings
├── Use ICU MessageFormat for pluralization, gender, ordinals
├── Text expansion: Allow 30-50% more space for translations
├── Right-to-left (RTL) layout support (Arabic, Hebrew)
├── Vertical text (Japanese, Chinese traditional)
├── Avoid text in images
└── Fonts that support all target languages

DATES & TIMES:
├── Format varies by locale (MM/DD/YYYY vs. DD/MM/YYYY)
├── 12-hour vs. 24-hour clock
├── Time zone handling (store UTC, display local)
├── Calendar systems (Gregorian, Islamic, Buddhist, etc.)
└── First day of week (Sunday vs. Monday)

NUMBERS & CURRENCIES:
├── Decimal separator (. vs. ,)
├── Thousands separator (, vs. space vs. .)
├── Currency symbol position ($100 vs. 100$)
├── Negative number format
└── Rounding rules

NAMES:
├── Not all cultures use first name + last name
├── Name order varies (family name first in East Asia)
├── Middle names not universal
├── Titles and honorifics vary
└── Don't assume name structure

COLORS & SYMBOLS:
├── Red: Danger (West) vs. Luck (China) vs. Mourning (South Africa)
├── Hand gestures: Thumbs up is offensive in some cultures
├── Animals: Owl = wisdom (West) vs. bad omen (India)
├── Religious symbols: Research before use
└── Localize imagery (models, settings, scenarios)

LAYOUT:
├── Reading direction (LTR vs. RTL)
├── UI mirroring for RTL (navigation, buttons, forms)
├── Cultural preferences for information density
├── Color psychology differences
└── Formality levels in tone
```

### 6.2 Cultural Dimensions (Hofstede)
```
POWER DISTANCE:
├── High: Hierarchical, formal language, clear authority
├── Low: Flat, informal, collaborative tone
├── Design: High PD = clear status indicators, formal labels

INDIVIDUALISM vs. COLLECTIVISM:
├── Individualist: Personal achievement, unique profiles
├── Collectivist: Group harmony, community features, shared experiences
├── Design: Collectivist = group features, shared content

UNCERTAINTY AVOIDANCE:
├── High: Detailed instructions, clear paths, error prevention
├── Low: Exploration encouraged, flexible paths
├── Design: High UA = comprehensive help, confirmations

LONG-TERM ORIENTATION:
├── High: Future-focused, sustainability, investment
├── Low: Short-term results, immediate gratification
├── Design: High LTO = progress tracking, long-term goals
```

---

## 7. INTERACTION DESIGN PATTERNS

### 7.1 Form Design
```
BEST PRACTICES:
├── Group related fields (address together, payment together)
├── Single column layout (faster scanning)
├── Top-aligned labels (fastest completion)
├── Inline validation (on blur, not on every keystroke)
├── Clear error messages (what went wrong + how to fix)
├── Progress indicators for multi-step forms
├── Auto-fill support (autocomplete attributes)
├── Smart defaults (pre-fill based on context)
├── Show/hide password toggle
├── Input masks for formatted data (phone, credit card)
└── Don't disable submit button — show errors on attempt

ERROR HANDLING:
├── Inline: Show error next to field
├── Summary: List all errors at top
├── Color + icon + text (not color alone)
├── Preserve user input
├── Suggest corrections ("Did you mean...?")
└── Real-time validation for format, on-submit for business rules
```

### 7.2 Navigation Patterns
```
HAMBURGER MENU:
├── Pros: Saves space, familiar pattern
├── Cons: Hidden navigation = less discovery
├── Best for: Secondary navigation, mobile
└── Alternative: Tab bar (mobile), visible nav (desktop)

BREADCRUMBS:
├── Show path from home to current page
├── Clickable for easy backtracking
├── Best for: Deep hierarchies, e-commerce
└── Schema.org markup for SEO

MEGA MENU:
├── Large dropdown with categorized links
├── Visual hierarchy with icons/images
├── Best for: E-commerce, content-heavy sites
└── Hover intent delay (don't trigger on accidental hover)

SEARCH:
├── Prominent placement (top center or top right)
├── Auto-suggestions
├── Recent searches
├── Search results with filters
├── No results page with suggestions
└── Voice search support

PAGINATION vs. INFINITE SCROLL:
├── Pagination: Better for SEO, goal-oriented, footer accessible
├── Infinite scroll: Better for discovery, mobile, engagement
├── Hybrid: Load more button (best of both)
└── Consider: Back button behavior, deep linking
```

### 7.3 Feedback Patterns
```
TOAST NOTIFICATIONS:
├── Non-blocking, auto-dismiss
├── Success, error, warning, info variants
├── Stacking behavior (max 3-5)
├── Actionable (undo, view details)
└── Accessible (aria-live, focus management)

MODAL DIALOGS:
├── Block interaction with background
├── Clear close mechanism (X, Escape, overlay click)
├── Focus trap inside modal
├── Return focus on close
├── Use sparingly (interruptive)
└── Best for: Critical confirmations, forms, detail views

LOADING STATES:
├── Skeleton screens (better than spinners for content)
├── Progress bars (for known duration)
├── Spinners (for unknown duration, < 10s)
├── Progressive loading (show content as available)
├── Optimistic UI (show result before confirmation)
└── Never leave user wondering if action worked

EMPTY STATES:
├── First-time use: Onboarding guidance
├── No results: Suggestions, alternative actions
├── No data: Explanation + CTA to add data
├── Error state: Friendly message + recovery action
└── Illustration + clear headline + descriptive text + CTA
```

---

## 8. UX RESEARCH METHODS

### 8.1 Research Methods Matrix
```
                    Behavioral          Attitudinal
                    (What they do)      (What they say)
    Qualitative     │ Usability Testing │ Interviews
    (Why)           │ Field Studies     │ Focus Groups
                    │ Eye Tracking      │ Card Sorting
                    │ A/B Testing       │ Surveys
    ────────────────┼───────────────────┼─────────────────
    Quantitative    │ Analytics         │ Surveys
    (How many)      │ Heatmaps          │ NPS
                    │ Click Tracking    │ Sentiment Analysis
                    │ Session Replay    │ Preference Testing
```

### 8.2 Usability Testing
```
MODERATED:
├── Facilitator guides participant through tasks
├── Think-aloud protocol (verbalize thoughts)
├── Probes and follow-up questions
├── Best for: Complex tasks, early designs, deep insights
└── 5-8 participants per round (Jakob Nielsen's law)

UNMODERATED:
├── Participant completes tasks independently
├── Recorded screen + audio
├── Task-based with success metrics
├── Best for: Large sample, remote, quick turnaround
└── Tools: UserTesting, Maze, Lookback, Optimal Workshop

METRICS:
├── Task Success Rate: % participants completing task
├── Time on Task: Duration to complete
├── Error Rate: Mistakes per task
├── Satisfaction: Post-task questionnaire (SEQ - Single Ease Question)
└── System Usability Scale (SUS): 10-item questionnaire, score 0-100

SUS SCORING:
├── < 50: Not acceptable
├── 50-70: Marginal
├── 70-85: Good
├── > 85: Excellent
└── Industry average: ~68
```

### 8.3 Analytics & Metrics
```
HEART FRAMEWORK (Google):
├── Happiness: Satisfaction, NPS, sentiment
├── Engagement: Frequency, intensity, depth of use
├── Adoption: New users, feature adoption
├── Retention: Return rate, churn
└── Task Success: Completion rate, error rate

GOALS-SIGNALS-METRICS:
├── Goal: What do we want to achieve?
├── Signal: How will we know if we're succeeding?
└── Metric: Specific measurable indicator

EXAMPLE:
Goal: Users can find products easily
Signal: Search success rate, time to find product
Metric: 90% of users find product within 30 seconds

KEY METRICS:
├── Conversion Rate: Desired action / Total visitors
├── Bounce Rate: Single page visit / Total visits
├── Session Duration: Time spent per visit
├── Pages per Session: Depth of engagement
├── Task Completion Rate: Successful task / Total attempts
├── Error Rate: Errors / Total interactions
├── Customer Satisfaction Score (CSAT): 1-5 rating
├── Net Promoter Score (NPS): 0-10 "Would you recommend?"
└── Customer Effort Score (CES): Ease of interaction
```

---

## 9. MOTION & ANIMATION

### 9.1 Animation Principles
```
PURPOSE:
├── Orientation: Show where elements came from/went
├── Feedback: Confirm user action
├── Demonstration: Teach how something works
├── Delight: Create emotional connection
└── NEVER: Decoration without purpose

TIMING:
├── Micro-interactions: 150-300ms
├── Transitions: 300-500ms
├── Page transitions: 500-700ms
├── Complex animations: 700-1000ms
└── Easing: Ease-out for entering, ease-in for exiting

PERFORMANCE:
├── Animate only transform and opacity (GPU-accelerated)
├── Avoid animating layout properties (width, height, top, left)
├── Use will-change sparingly
├── Respect prefers-reduced-motion
└── 60fps target (16ms per frame)

ACCESSIBILITY:
├── @media (prefers-reduced-motion: reduce) { ... }
├── Disable non-essential animations
├── Keep essential animations subtle
└── Never use flashing (>3Hz can trigger seizures)
```

---

## 10. VOICE & CONVERSATIONAL UI

### 10.1 Voice Interface Design
```
PRINCIPLES:
├── Conversational: Natural language, not commands
├── Contextual: Remember previous interactions
├── Concise: Short responses, one idea at a time
├── Confirmations: For high-stakes actions
├── Error recovery: Graceful handling of misunderstandings
└── Personality: Consistent tone and character

PATTERNS:
├── One-breath test: Response should fit in one breath
├── Progressive clarification: Narrow down ambiguous requests
├── Offer choices: "Would you like A or B?"
├── Barge-in: Allow user to interrupt
├── Visual confirmation: Show on screen what was understood
└── Wake word: Clear activation phrase
```

---

**[END OF SKILL-13]**
