# Palmetto Clean Technology — XORCISM Action Plan
**Date:** 2026-07-16  
**Prepared by:** XORCISM Security Platform  
**Scope:** GCP (`palmetto-solar-d6a95`) + AWS (`us-east-2`) — 19 assets

---

## Current Posture Snapshot

| Metric | Value |
|--------|-------|
| Assets monitored | 19 (15 GCP · 4 AWS) |
| Unique CVEs linked | 306 |
| Critical (CVSS ≥ 9.0) | 51 |
| High (CVSS 7–9) | 124 |
| Known Exploited (KEV) | **0** ✅ |
| SSVC Act / Attend | **0** ✅ |
| Insurance readiness | D (51/100) |
| Threat feeds | 33/33 active · 278 reports |

No emergency response required. No active exploitation detected against Palmetto's assets.

---

## Immediate Actions (This Week)

### 1. Assign owners to critical CVE findings
**Why:** 901 CVE-asset links are unassigned. XORCISM's SLA compliance and MTTR metrics are meaningless until ownership is set.  
**How:** In XORCISM → Vulnerability Management → assign the Node.js critical cluster (CVE-2026-43997, CVE-2026-44005, CVE-2026-44006, CVE-2026-47208 and related vm2 CVEs) to the App Engine owner with a 30-day remediation target.  
**Impact:** Activates overdue tracking, MTTR, and board-report remediation pipeline.

### 2. Run Software Composition Analysis on App Engine
**Why:** Current CVE matching used broad Node.js product tags. SCA against the actual `package.json` / `package-lock.json` gives precise, per-package CVE links with far fewer false positives.  
**How:** XORCISM → SCA → upload `package-lock.json` from the App Engine project.  
**Impact:** Replaces ~300 broad matches with accurate dependency-level findings.

### 3. Rotate all IAM service account keys
**Why:** 5 active keys found for `firebase-adminsdk`; at least some are likely stale. High-privilege keys with no expiry are a common lateral movement vector.  
**How:** GCP Console → IAM → Service Accounts → audit key ages, delete unused, rotate active keys. Log new key fingerprints in XORCISM → Identities.  
**Impact:** Closes a high-privilege credential exposure risk immediately.

---

## Short-Term Actions (Next 30 Days)

### 4. Complete Business Impact Analysis for High-criticality assets
**Why:** All 19 assets currently have flat risk scores because no business process or financial value is attached. BIA data feeds XORCISM's CROC engine and makes board risk scores meaningful.  
**Assets to prioritise:** Palmetto Solar (Firebase), App Engine, Firestore DB, firebase-adminsdk SA, App Engine SA, AWS Security Group.  
**How:** XORCISM → BIA → map each asset to its business process, revenue impact, and RTO/RPO.

### 5. Complete the cyber insurance readiness questionnaire
**Why:** Current grade is D (51/100). The primary gap is absence of a documented, tested 3-2-1 backup strategy. Closing this gap can directly improve renewal terms.  
**How:** XORCISM → Insurance → complete questionnaire. Implement offsite/immutable backup for Firestore and GCS, then re-score.  
**Target:** Raise to grade B (≥ 75/100).

### 6. Run compliance gap assessment — NIST CSF 2.0 + CIS Controls v8
**Why:** Both frameworks are seeded in XORCISM with 0 controls assessed. For a 750-person cloud-first org, NIST CSF 2.0 maps directly to GCP/AWS security tooling; CIS v8 is the most cited framework in cyber insurance underwriting.  
**How:** XORCISM → Compliance → select framework → complete control self-assessment or import evidence.

### 7. Review BigQuery access controls
**Why:** Three CVEs target Google BigQuery authorization (CVE-2026-12879, CVE-2026-14934, CVE-2026-8934). The `analytics_168177260` dataset contains customer PII.  
**How:** Audit BigQuery dataset IAM bindings; enable audit logging via GCP → Cloud Audit Logs; confirm no `allUsers` or over-permissioned bindings; patch Apigee/BigQuery DAO to version ≥ 2026-06-12.

---

## Medium-Term Actions (30–90 Days)

### 8. Expand AWS asset inventory
**Why:** The current AWS export shows only default VPC plumbing (9 resources). Any EC2 instances, RDS databases, Lambda functions, or ECS services are invisible to the risk model.  
**How:** Re-run AWS Tag Editor with all regions selected. Tag all resources. Re-import into XORCISM. Expected outcome: significantly larger asset inventory with mapped CVEs.

### 9. External Attack Surface Management (EASM) scan
**Why:** Confirms what is actually reachable from the internet — exposed ports, misconfigured storage buckets, TLS issues, subdomain takeover risk.  
**Scope:** `palmetto-solar-d6a95.appspot.com`, Firebase hosting URLs, any public-facing APIs.  
**How:** XORCISM → EASM → add target domains → run scan.

### 10. Identity governance audit
**Why:** 3 service accounts, 5 IAM keys, 4 API keys (Maps, iOS, Android, Server, Browser) are registered but unowned and not covered by any access review cycle.  
**How:** XORCISM → Identity Governance → import GCP IAM snapshot → assign owners → set review cadence (quarterly recommended).

### 11. Formalise the Risk Register
**Why:** Findings from this report exist only in XORCISM's vulnerability module. A formal risk register documents likelihood, impact, owner, and treatment decision — required for most compliance frameworks and board reporting.  
**Risks to register immediately:**
- Node.js ecosystem CVE exposure (likelihood: Medium · impact: High)
- IAM key sprawl / stale credentials (likelihood: Medium · impact: Critical)
- BigQuery data exfiltration via authorization flaws (likelihood: Low · impact: High)
- AWS inventory gap (likelihood: Low · impact: Unknown)
- Cyber insurance gap — missing tested backup strategy (likelihood: Medium · impact: High)

---

## Longer-Term Program Maturity (90+ Days)

| Initiative | XORCISM Module | Value |
|-----------|---------------|-------|
| Cyber Risk Quantification | `crq` | Translate CVE exposure into financial loss ranges for board and insurance |
| Continuous Threat Exposure Mgmt | `ctem` | Structured scope → discover → prioritise → validate cycle |
| Cloud Security Posture | `cloudsec` | Misconfigured bucket detection, public storage, over-permissioned IAM |
| OT/ICS Security | `otsecurity` | If solar inverters or monitoring hardware have network connectivity |
| Third-Party Risk Management | `tprm` | Register Google, AWS, and key SaaS vendors; track their security posture |
| Security Awareness | `awareness` | Track training completion across 750 employees |
| SIEM Integration | `siem` | Correlate GCP/AWS log events with XORCISM threat intelligence |

---

## Priority Summary

| # | Action | Effort | Impact | Timeline |
|---|--------|--------|--------|----------|
| 1 | Assign CVE owners + SLA dates | Low | High | This week |
| 2 | SCA scan — App Engine package.json | Low | High | This week |
| 3 | Rotate IAM service account keys | Low | Critical | This week |
| 4 | Business Impact Analysis (6 assets) | Medium | High | 30 days |
| 5 | Insurance questionnaire + backups | Medium | High | 30 days |
| 6 | NIST CSF 2.0 + CIS v8 gap assessment | Medium | Medium | 30 days |
| 7 | BigQuery access control review | Low | High | 30 days |
| 8 | Expand AWS inventory | Low | Medium | 30 days |
| 9 | EASM scan | Low | Medium | 60 days |
| 10 | Identity governance audit | Medium | High | 60 days |
| 11 | Formalise risk register | Medium | Medium | 60 days |

---

*Report generated by XORCISM · NVD data current to 2026-07-16 · CISA KEV catalogue v2026.07.16*
