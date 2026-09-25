# 🤖 SKILL-12: Testing Automation

> **Domain:** Automated Testing, CI/CD Quality Gates, AI-Driven Testing  
> **Level:** Expert / Principal  
> **Scope:** Comprehensive automation across all test levels, AI-powered testing, test plans, test cases, coverage strategies

---

## 1. PHILOSOPHY

Automation is not about replacing testers — it is about **amplifying their impact**.
- Automate the repetitive, explore the unknown
- A test that runs once is manual; a test that runs 1000 times is automated
- Automation without strategy is just fast chaos
- The best automated tests are the ones that find bugs, not the ones that pass
- AI doesn't replace test design — it augments test execution and analysis

---

## 2. AUTOMATION STRATEGY FRAMEWORK

### 2.1 Test Automation Pyramid (Revisited)
```
         /\
        /  \
       / E2E  \        ~5-10%  (Slow, flaky, high confidence)
      /──────────\
     / Integration  \   ~20-30%  (Medium speed, medium cost)
    /──────────────────\
   /    Unit Tests       \  ~60-70%  (Fast, cheap, isolated)
  /──────────────────────────\

RULE: For every 1 E2E test, have 10 integration tests and 100 unit tests.
```

### 2.2 What to Automate vs. Manual
```
AUTOMATE:
├── Regression tests (run on every build)
├── Smoke tests (verify critical paths)
├── API tests (fast, reliable, deterministic)
├── Unit tests (developer responsibility)
├── Performance baseline tests
├── Security scans (SAST, SCA, DAST)
├── Accessibility checks (axe-core, Pa11y)
├── Data validation tests
├── Cross-browser compatibility (via grid)
├── Load and stress tests
└── Build and deployment verification

MANUAL (or AI-ASSISTED):
├── Exploratory testing
├── Usability testing
├── Ad-hoc testing
├── User acceptance testing (UAT)
├── First-time feature testing
├── Complex business scenario validation
├── Visual testing (subjective elements)
└── Edge case discovery
```

### 2.3 Automation ROI Framework
```
ROI = (Manual Effort Saved - Automation Effort) / Automation Effort

FACTORS:
├── Execution frequency (daily builds = high ROI)
├── Test stability (flaky tests = negative ROI)
├── Maintenance cost (fragile selectors = high cost)
├── Setup cost (initial investment)
├── Execution time (faster feedback = higher value)
└── Defect detection value (critical path = high value)

DECISION MATRIX:
High Frequency + Stable + High Value = AUTOMATE NOW
High Frequency + Unstable = STABILIZE THEN AUTOMATE
Low Frequency + High Value = AUTOMATE IF STABLE
Low Frequency + Low Value = MANUAL OR SKIP
```

---

## 3. UNIT TEST AUTOMATION

### 3.1 Test-Driven Development (TDD)
```
CYCLE:
1. RED: Write a failing test
   ├── Define expected behavior
   ├── Run test → confirm it fails
   └── Focus: What should this code do?

2. GREEN: Write minimum code to pass
   ├── Simplest implementation
   ├── Don't optimize yet
   └── Focus: Make the test pass

3. REFACTOR: Improve design
   ├── Clean code
   ├── Remove duplication
   ├── Improve naming
   └── Focus: Make it right

BENEFITS:
├── Testable design (forces decoupling)
├── Comprehensive test coverage
├── Living documentation
├── Confidence to refactor
└── Faster debugging (test isolates issue)

ANTI-PATTERNS:
├── Testing implementation, not behavior
├── Tests too tightly coupled to code
├── Slow tests (database, network)
├── Brittle tests (break on every refactor)
└── Testing getters/setters
```

### 3.2 Unit Test Patterns
```
AAA PATTERN:
// Arrange: Set up test data and mocks
User user = new User("test@example.com", "password123");
MockEmailService emailService = mock(MockEmailService.class);
UserService service = new UserService(emailService);

// Act: Execute the method under test
boolean result = service.registerUser(user);

// Assert: Verify outcomes
assertTrue(result);
verify(emailService).sendWelcomeEmail(user);

PARAMETERIZED TESTS:
@ParameterizedTest
@CsvSource({
    "user@example.com, true",
    "invalid-email, false",
    "@example.com, false",
    "user@, false",
    "user@example, false"
})
void testEmailValidation(String email, boolean expected) {
    assertEquals(expected, validator.isValid(email));
}

MOCKING BEST PRACTICES:
├── Mock external dependencies (DB, API, file system)
├── Don't mock what you don't own (test real integration)
├── Verify interactions, not just state
├── Use lenient mocking (don't over-specify)
└── Reset mocks between tests
```

### 3.3 Coverage Targets by Criticality
```
CRITICAL PATHS (100% coverage):
├── Authentication and authorization
├── Payment processing
├── Data encryption
├── Core business logic
└── Compliance-related code

HIGH VALUE (80-90% coverage):
├── API endpoints
├── Service layer
├── Domain logic
├── Error handling
└── Validation rules

STANDARD (60-80% coverage):
├── Utility functions
├── Data transformation
├── Configuration parsing
└── Logging

LOW PRIORITY (<60% acceptable):
├── UI components (tested via E2E)
├── Boilerplate code
├── Generated code
├── Third-party integrations (tested via contract tests)
└── Debug/logging code
```

---

## 4. INTEGRATION TEST AUTOMATION

### 4.1 API Test Automation
```
REST API TESTING (with REST Assured / Supertest / Requests):

// Example: REST Assured (Java)
given()
    .contentType(ContentType.JSON)
    .body("{"email":"test@example.com","password":"secret"}")
.when()
    .post("/api/auth/login")
.then()
    .statusCode(200)
    .body("token", notNullValue())
    .body("user.email", equalTo("test@example.com"))
    .header("X-RateLimit-Remaining", greaterThan(0));

TEST SCENARIOS:
├── Happy path (valid request → expected response)
├── Authentication (valid, invalid, missing, expired token)
├── Authorization (insufficient permissions)
├── Input validation (missing fields, invalid types, boundary values)
├── Error handling (4xx, 5xx responses)
├── Rate limiting (exceed quota)
├── Content negotiation (JSON, XML, accept headers)
├── Pagination (first page, last page, empty, invalid page)
├── Filtering and sorting
├── Concurrent requests (race conditions)
└── Idempotency (same request twice)

CONTRACT TESTING (Pact):
// Consumer test
@Pact(consumer = "order-service", provider = "payment-service")
public RequestResponsePact paymentPact(PactDslWithProvider builder) {
    return builder
        .given("payment exists")
        .uponReceiving("request for payment status")
        .path("/payments/123")
        .method("GET")
        .willRespondWith()
        .status(200)
        .body("{"status": "completed", "amount": 100.00}")
        .toPact();
}
```

### 4.2 Database Integration Testing
```
TESTCONTAINERS APPROACH:
├── Spin up real database in Docker container
├── Run migrations
├── Execute tests
├── Tear down container
├── Isolated per test class or suite

STRATEGIES:
├── @BeforeEach: Clean state (truncate tables, reset sequences)
├── @AfterEach: Verify no data leakage
├── Use transactions with rollback
├── Test data builders (fluent API for test data)
└── Seed reference data once per suite

EXAMPLE:
@Testcontainers
class OrderRepositoryTest {
    @Container
    static PostgreSQLContainer<?> postgres = 
        new PostgreSQLContainer<>("postgres:15");

    @Test
    void shouldSaveOrder() {
        Order order = new OrderBuilder()
            .withCustomer("customer-123")
            .withItems(List.of(new Item("product-1", 2)))
            .build();

        Order saved = repository.save(order);

        assertThat(saved.getId()).isNotNull();
        assertThat(repository.findById(saved.getId()))
            .isPresent()
            .hasValueSatisfying(o -> 
                assertThat(o.getItems()).hasSize(1));
    }
}
```

### 4.3 Message Queue Testing
```
KAFKA TESTING:
├── Embedded Kafka (for unit/integration tests)
├── Testcontainers Kafka
├── Producer tests: Verify message published
├── Consumer tests: Verify message processed
├── Dead letter queue tests
└── Ordering and partition tests

EXAMPLE:
@Test
void shouldProcessOrderEvent() {
    // Produce test event
    kafkaTemplate.send("orders", new OrderEvent("123", "CREATED"));

    // Wait and verify
    await().atMost(5, SECONDS).untilAsserted(() -> {
        Order order = orderRepository.findById("123");
        assertThat(order.getStatus()).isEqualTo("CREATED");
    });
}
```

---

## 5. E2E TEST AUTOMATION

### 5.1 E2E Test Architecture
```
PAGE OBJECT MODEL (POM):
├── Page class represents UI page
├── Methods represent user actions
├── Selectors centralized in page class
├── Tests use page objects, not raw selectors
└── Maintenance: Update selector in one place

EXAMPLE:
class LoginPage {
    private final WebDriver driver;

    @FindBy(id = "username")
    private WebElement usernameField;

    @FindBy(id = "password")
    private WebElement passwordField;

    @FindBy(css = "button[type='submit']")
    private WebElement submitButton;

    public LoginPage(WebDriver driver) {
        this.driver = driver;
        PageFactory.initElements(driver, this);
    }

    public LoginPage enterUsername(String username) {
        usernameField.sendKeys(username);
        return this;
    }

    public DashboardPage submit() {
        submitButton.click();
        return new DashboardPage(driver);
    }
}

TEST:
@Test
void shouldLoginSuccessfully() {
    DashboardPage dashboard = new LoginPage(driver)
        .enterUsername("validuser")
        .enterPassword("validpass")
        .submit();

    assertThat(dashboard.isLoggedIn()).isTrue();
}
```

### 5.2 Modern E2E Tools Comparison
```
TOOL          │ Speed │ Reliability │ Cross-Browser │ Mobile │ API Testing │ Best For
──────────────┼───────┼─────────────┼───────────────┼────────┼─────────────┼──────────────────
Selenium      │ Slow  │ Medium      │ Excellent     │ Yes    │ No          │ Legacy, complex
Playwright    │ Fast  │ High        │ Excellent     │ Yes    │ Yes         │ Modern web, speed
Cypress       │ Fast  │ High        │ Good          │ No     │ Yes         │ Developer-friendly
WebdriverIO   │ Medium│ High        │ Excellent     │ Yes    │ Yes         │ Flexibility
Puppeteer     │ Fast  │ High        │ Chrome only   │ No     │ Yes         │ Chrome automation
Appium        │ Medium│ Medium      │ N/A           │ Yes    │ No          │ Native mobile
Detox         │ Fast  │ High        │ N/A           │ Yes    │ No          │ React Native
Maestro       │ Fast  │ High        │ N/A           │ Yes    │ No          │ Mobile simplicity
```

### 5.3 E2E Best Practices
```
SELECTOR STRATEGY:
├── Prefer: data-testid attributes (stable, semantic)
├── Acceptable: CSS classes (if stable)
├── Avoid: XPath (brittle), text content (i18n issues)
├── Never: Auto-generated IDs, absolute positions
└── Example: <button data-testid="submit-order">Submit</button>

WAIT STRATEGIES:
├── Implicit waits: Global timeout (avoid)
├── Explicit waits: Wait for specific condition
├── Fluent waits: Polling with timeout
├── Custom conditions: Wait for API response, animation
└── NEVER: Thread.sleep()

TEST ISOLATION:
├── Each test starts with clean state
├── Use API to set up test data (faster than UI)
├── Reset database/state between tests
├── Parallel execution requires isolation
└── Independent tests (no order dependency)

FLAKINESS PREVENTION:
├── Stable selectors (data-testid)
├── Wait for elements, not fixed delays
├── Handle async operations properly
├── Retry mechanism for transient failures
├── Mock external dependencies (time, random, third-party)
├── Stable test data
└── Headless execution in CI (consistent environment)
```

---

## 6. PERFORMANCE TEST AUTOMATION

### 6.1 Load Testing
```
TOOLS: JMeter, k6, Gatling, Locust, Artillery

K6 EXAMPLE:
import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
    stages: [
        { duration: '2m', target: 100 },   // Ramp up
        { duration: '5m', target: 100 },   // Steady state
        { duration: '2m', target: 200 },   // Ramp up
        { duration: '5m', target: 200 },   // Steady state
        { duration: '2m', target: 0 },     // Ramp down
    ],
    thresholds: {
        http_req_duration: ['p(95)<500'], // 95% under 500ms
        http_req_failed: ['rate<0.01'],   // Error rate < 1%
    },
};

export default function () {
    const res = http.get('https://api.example.com/orders');
    check(res, {
        'status is 200': (r) => r.status === 200,
        'response time < 500ms': (r) => r.timings.duration < 500,
    });
    sleep(1);
}

METRICS TO TRACK:
├── Response time: min, max, mean, p50, p95, p99
├── Throughput: requests per second
├── Error rate: failed requests / total requests
├── Concurrent users: active virtual users
├── Resource utilization: CPU, memory, network, disk
└── Apdex score: user satisfaction index
```

### 6.2 Stress & Spike Testing
```
STRESS TEST:
├── Gradually increase load beyond expected maximum
├── Find breaking point
├── Observe graceful degradation
└── Identify recovery behavior

SPIKE TEST:
├── Sudden massive increase in load
├── Test auto-scaling response
├── Test circuit breaker behavior
└── Identify cold start issues

SOAK TEST:
├── Sustained load for extended period (hours/days)
├── Detect memory leaks
├── Detect resource exhaustion
├── Verify stability over time
└── Identify gradual performance degradation
```

---

## 7. SECURITY TEST AUTOMATION

### 7.1 SAST (Static Application Security Testing)
```
TOOLS: SonarQube, Checkmarx, Semgrep, Bandit, ESLint Security

INTEGRATION:
├── Run on every pull request
├── Block merge on critical/high findings
├── Trend analysis (new vs. existing issues)
├── False positive management
└── Custom rule development

EXAMPLE (Semgrep):
rules:
  - id: sql-injection
    pattern: |
      $QUERY = "..." + $X + "..."
      ...
      $DB.execute($QUERY)
    message: "Potential SQL injection. Use parameterized queries."
    severity: ERROR
```

### 7.2 DAST (Dynamic Application Security Testing)
```
TOOLS: OWASP ZAP, Burp Suite Enterprise, Netsparker

INTEGRATION:
├── Run against staging environment
├── Authenticated scanning (test with user sessions)
├── API scanning (OpenAPI spec import)
├── Spider/crawl to discover endpoints
├── Schedule: Weekly or per release
└── Remediation tracking
```

### 7.3 SCA (Software Composition Analysis)
```
TOOLS: Snyk, OWASP Dependency-Check, GitHub Dependabot, Mend

INTEGRATION:
├── Scan dependencies on every build
├── Block builds with critical vulnerabilities
├── License compliance check
├── SBOM generation
├── Automatic PR creation for updates
└── Vulnerability database monitoring
```

### 7.4 Secret Scanning
```
TOOLS: GitLeaks, TruffleHog, GitHub Secret Scanning, AWS CodeGuru

INTEGRATION:
├── Pre-commit hooks (prevent secrets in repo)
├── CI/CD pipeline scanning
├── Historical scan (find existing secrets)
├── Automatic secret rotation
└── Integration with secret management (Vault, AWS Secrets Manager)
```

---

## 8. AI-DRIVEN TESTING

### 8.1 AI Test Generation
```
AUTOMATED TEST CASE GENERATION:
├── From requirements (NLP parsing → test cases)
├── From user stories (acceptance criteria extraction)
├── From API specs (OpenAPI → contract tests)
├── From code (symbolic execution → edge cases)
└── From production traffic (replay as tests)

TOOLS:
├── Diffblue Cover (Java unit test generation)
├── Ponicode (test generation from code)
├── Testim, Mabl (AI-powered E2E test generation)
├── Sealights (test impact analysis)
└── Launchable (predictive test selection)

EXAMPLE (Requirements → Tests):
Input: "User must be able to reset password via email"
AI Output:
├── TC1: Valid email → reset link sent
├── TC2: Invalid email format → error message
├── TC3: Non-existent email → generic response (security)
├── TC4: Expired reset token → error
├── TC5: Reused reset token → error
└── TC6: Password policy validation
```

### 8.2 Visual Regression Testing
```
TOOLS: Percy, Chromatic, Applitools, BackstopJS

APPROACH:
├── Capture baseline screenshots
├── Capture current screenshots
├── AI-powered pixel comparison (ignores anti-aliasing)
├── Highlight visual differences
├── Approve or reject changes
└── Integrate with CI/CD

USE CASES:
├── CSS changes (unintended side effects)
├── Responsive design (breakpoints)
├── Cross-browser rendering
├── Component library changes
└── Marketing page updates
```

### 8.3 Self-Healing Tests
```
PROBLEM: UI changes break E2E tests constantly

SOLUTION:
├── AI analyzes DOM structure, not just selectors
├── Multiple locator strategies (fallback chain)
├── Visual recognition (find element by appearance)
├── Relationship-based (element near X, inside Y)
├── Automatic selector updates
└── Human review for significant changes

TOOLS: Testim, Mabl, Functionize, Sauce Labs Self-Healing
```

### 8.4 Predictive Test Selection
```
PROBLEM: Full test suite takes hours; need faster feedback

SOLUTION:
├── ML model predicts which tests are likely to fail
├── Based on: code changes, historical failure patterns, dependencies
├── Run high-risk tests first
├── Skip low-risk tests in fast feedback loop
├── Run full suite overnight
└── Tools: Launchable, Sealights, Appsurify

BENEFITS:
├── 10x faster feedback on average
├── Catch failures earlier
├── Reduce CI/CD pipeline time
└── Maintain confidence with statistical validation
```

### 8.5 AI-Powered Test Analysis
```
FAILURE CLASSIFICATION:
├── AI categorizes test failures:
│   ├── Flaky test (environmental, timing)
│   ├── Product bug (real issue)
│   ├── Test bug (automation issue)
│   ├── Infrastructure issue (CI/CD, network)
│   └── Data issue (test data problem)
├── Automatic triage and routing
└── Trend analysis (which tests fail most)

ROOT CAUSE ANALYSIS:
├── Correlate test failures with:
│   ├── Code changes (which commit broke it?)
│   ├── Environment changes
│   ├── Dependency updates
│   └── Time patterns (nightly failures?)
├── Suggest probable cause
└── Recommend fix
```

---

## 9. CI/CD INTEGRATION

### 9.1 Quality Gates in Pipeline
```
PRE-COMMIT:
├── Linting (ESLint, Pylint, SpotBugs)
├── Unit tests (fast, < 2 minutes)
├── Prettier/code formatting
└── Secret scanning

PULL REQUEST:
├── Build
├── Unit tests (with coverage)
├── Integration tests
├── Static analysis (SonarQube quality gate)
├── Security scans (SAST, SCA)
├── Dependency audit
├── Code review (human + AI)
└── Coverage gate (e.g., ≥ 80%)

MERGE TO MAIN:
├── Full test suite
├── E2E tests (smoke)
├── Performance regression tests
├── Security scans (DAST)
├── Accessibility checks
├── Build artifacts
└── Deploy to staging

STAGING:
├── Full E2E suite
├── Performance tests
├── Security penetration test (light)
├── UAT (human validation)
└── Monitoring validation

PRODUCTION:
├── Smoke tests
├── Synthetic monitoring
├── Real user monitoring (RUM)
├── Error tracking
└── Rollback readiness
```

### 9.2 Test Environments
```
ENVIRONMENT STRATEGY:
├── Local: Developer machine (unit tests, integration with Docker)
├── CI: Automated pipeline (all automated tests)
├── Staging: Production-like (E2E, performance, UAT)
├── Canary: 1-5% production traffic (smoke tests, monitoring)
├── Production: Live (synthetic tests, RUM, error tracking)
└── Ephemeral: Per-PR environments (isolated testing)

ENVIRONMENT PARITY:
├── Same OS and versions
├── Same database version and schema
├── Same middleware and services
├── Same configuration (different values)
├── Same network topology (where possible)
├── Infrastructure as Code (IaC) for consistency
└── Containerization (Docker) for reproducibility
```

---

## 10. TEST DATA MANAGEMENT

### 10.1 Test Data Strategies
```
SYNTHETIC DATA:
├── Generated programmatically
├── Deterministic (same seed = same data)
├── Fast to create
├── No privacy concerns
└── Tools: Faker, Factory Boy, JavaFaker

FIXTURES:
├── Pre-defined test data
├── Version controlled
├── Shared across tests
├── Maintenance overhead
└── Risk of stale data

PRODUCTION SUBSET:
├── Anonymized production data
├── Realistic distributions
├── Privacy compliance (GDPR, HIPAA)
├── Data masking and tokenization
└── Refresh strategy

SNAPSHOT TESTING:
├── Capture system state
├── Compare against baseline
├── Useful for: API responses, database state
├── Review and approve changes
└── Tools: Jest snapshots, Approval Tests
```

### 10.2 Test Data Builders
```
FLUENT BUILDER PATTERN:
Order order = new OrderBuilder()
    .withCustomer("customer-123")
    .withItems(
        new ItemBuilder().withProduct("prod-1").withQuantity(2).build(),
        new ItemBuilder().withProduct("prod-2").withQuantity(1).build()
    )
    .withShippingAddress(new AddressBuilder().withCity("NYC").build())
    .withStatus(OrderStatus.PENDING)
    .build();

BENEFITS:
├── Readable test setup
├── Default values (only override what's relevant)
├── Type safety
├── Reusable across tests
└── Easy maintenance
```

---

## 11. TEST REPORTING & METRICS

### 11.1 Test Dashboard
```
EXECUTIVE VIEW:
├── Test Pass Rate (trend)
├── Coverage Trend (lines, branches, functions)
├── Defect Escape Rate
├── Mean Time To Detect (MTTD)
├── Automation Coverage (% of tests automated)
└── Cost Per Defect Found

TEAM VIEW:
├── Build Status (pass/fail)
├── Test Execution Time (trend)
├── Flaky Test Count
├── New vs. Fixed Tests
├── Test Debt (skipped, pending, obsolete)
└── Environment Health

DETAIL VIEW:
├── Failed Tests (with logs, screenshots, videos)
├── Coverage by Module
├── Slow Tests (top 10)
├── Flaky Tests (top 10)
├── Test History (per test)
└── Defect Correlation (which tests found which bugs)
```

### 11.2 Test Metrics
```
EFFECTIVENESS:
├── Defect Detection Percentage: Defects found by testing / Total defects
├── Test Effectiveness: Defects found / Test cases executed
├── Escape Rate: Production defects / Total defects
└── Mean Time To Detect (MTTD)

EFFICIENCY:
├── Test Execution Time
├── Test Maintenance Time
├── Automation ROI
├── False Positive Rate
└── Flaky Test Rate

COVERAGE:
├── Code Coverage (line, branch, function)
├── Requirements Coverage
├── Risk Coverage
├── API Coverage
└── UI Flow Coverage
```

---

**[END OF SKILL-12]**
