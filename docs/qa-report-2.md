# Sprint 2 QA Report

**QA Lead:** [Name]  
**Sprint:** Sprint 2 (Weeks 3-4)  
**Date:** [Completion Date]  
**Check Script Version:** check-week4.sh

---

## Executive Summary

[One paragraph: overall readiness for submission, any critical issues, general quality assessment]

---

## Validation Check Results

### Check 1: OpenTofu Applies Without Error

**Command:**
```bash
tofu plan
```

**Expected Result:** `No changes. Your infrastructure matches the configuration.`

**Actual Result:**
```
[Paste actual output here]
```

**Status:** PASS / FAIL / PARTIAL

**Notes:**
[Any details about this check]

---

### Check 2: Flask Deployment Has 3 Replicas

**Command:**
```bash
kubectl get deployment flask -o jsonpath='{.spec.replicas}'
```

**Expected Result:** `3`

**Actual Result:**
```
[Paste actual output here]
```

**Status:** PASS / FAIL / PARTIAL

**Notes:**
[Any details about this check]

---

### Check 3: infrastructure/main.tf Has Local Backend

**Command:**
```bash
grep -A3 "backend" infrastructure/main.tf
```

**Expected Result:** Output showing `backend "local" { path = "terraform.tfstate" }`

**Actual Result:**
```
[Paste actual output here]
```

**Status:** PASS / FAIL / PARTIAL

**Notes:**
[Any details about this check]

---

### Check 4: Check Script Passes

**Command:**
```bash
./scripts/check-week4.sh
```

**Exit Status:** [0 = success, other = failure]

**Output:**
```
[Paste full output here]
```

**Status:** PASS / FAIL / PARTIAL

**Notes:**
[Any details about this check]

---

## Acceptance Criteria Coverage

| Criterion | Status | Notes |
|-----------|--------|-------|
| OpenTofu Installation | PASS / FAIL | |
| Local Backend Configured | PASS / FAIL | |
| Deployment Configuration | PASS / FAIL | |
| Service Configuration | PASS / FAIL | |
| Resources Deployable and Idempotent | PASS / FAIL | |
| Deployment Replicas Update | PASS / FAIL | |
| Kubernetes Self-Healing | PASS / FAIL | |
| Ansible Playbook Integration | PASS / FAIL | |
| Ansible extends site.yml | PASS / FAIL | |
| Screenshots Captured | PASS / FAIL | |
| Reflection Questions Answered | PASS / FAIL | |

---

## Rework Summary

### Issues Found

[List any issues that required rework]

1. **Issue:** [Description]
   - **Resolution:** [How it was fixed]
   - **Commit:** [Git commit hash if rework was committed]

2. **Issue:** [Description]
   - **Resolution:** [How it was fixed]
   - **Commit:** [Git commit hash if rework was committed]

### Rework Iterations

[Document any cycles of: find issue -> fix -> re-test]

---

## Sign-Off

**Ready for Submission:** YES / NO

**Signature:** [QA Lead Name and Date]

---

## Notes for Next Sprint

[Any environment or code state notes for incoming QA lead]
