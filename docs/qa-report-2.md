# QA Report: Sprint 2 Week 4

QA is responsible for running all validation checks and signing off before deliverables are submitted. This report documents the validation process.

**QA Team Member:** [Name]
**Date Completed:** [Date]

---

## Validation Checks

### Check 1: OpenTofu Applies Without Error

**Test:** Run `tofu plan` from the `infrastructure/` directory

**Expected:** `No changes. Your infrastructure matches the configuration.`

**Actual Result:**
```
TODO: Paste the actual output of tofu plan
```

**Status:** TODO: [ ] Pass [ ] Fail

**Notes:** If changes are shown, which resource/attribute is drifting from the HCL?

---

### Check 2: Flask Deployment Has 3 Replicas

**Test:** Run `kubectl get deployment flask -o jsonpath='{.spec.replicas}'`

**Expected:** `3`

**Actual Result:** TODO: Record the reported replica count

**Status:** TODO: [ ] Pass [ ] Fail

**Notes:** Confirms the Part 3 replica change (Steps 10-13) was applied and is still in effect.

---

### Check 3: infrastructure/main.tf Has Local Backend

**Test:** Run `grep -A3 "backend" infrastructure/main.tf`

**Expected:** Output showing `backend "local" { path = "terraform.tfstate" }`

**Actual Result:**
```
TODO: Paste the actual output
```

**Status:** TODO: [ ] Pass [ ] Fail

**Notes:** Confirms state is stored locally inside the team container, not a remote backend.

---

### Check 4: Check Script Passes

**Test:** Run `./scripts/check-week4.sh`

**Expected:** All checks pass with exit code 0

**Actual Result:**
```
TODO: Paste the full output of the check script
```

**Status:** TODO: [ ] Pass [ ] Fail

**Notes:** If any checks failed, what did the script report?

---

## Acceptance Criteria Verification

Review the criteria below for each part of this week's deliverables. For each criterion, record whether it was met:

### Part 1: Install OpenTofu and Initialize

TODO: [ ] OpenTofu installed; `tofu version` reports `OpenTofu v1.x.x`
TODO: [ ] `infrastructure/main.tf` defines the Kubernetes provider and an explicit local backend
TODO: [ ] `tofu init` completes with `OpenTofu has been successfully initialized!`
TODO: [ ] `infrastructure/terraform.tfstate` and `terraform.tfstate.backup` are excluded via `.gitignore`

### Part 2: Define Kubernetes Resources with OpenTofu

TODO: [ ] `infrastructure/flask.tf` defines both a Deployment and a Service for `flask`
TODO: [ ] Container image is `week-2-flask:latest` (not the `ghcr.io` placeholder), with `image_pull_policy = "IfNotPresent"`
TODO: [ ] Week 3's `kubectl`-managed `flask` Deployment/Service were deleted before the first `tofu apply` (Step 6a)
TODO: [ ] `tofu apply` completed without "already exists" errors
TODO: [ ] `kubectl get deployment flask` showed `2/2` READY after the initial apply

### Part 3: Make a Change and Verify Idempotency

TODO: [ ] Replica count changed from 2 to 3 in `flask.tf`
TODO: [ ] `tofu plan` showed only a `~` modification to `replicas`
TODO: [ ] `kubectl get deployment flask` showed `3/3` READY after applying
TODO: [ ] A second `tofu apply` reported `0 added, 0 changed, 0 destroyed`

### Part 4: k3s Resilience Validation

TODO: [ ] Manually deleted Flask pod was automatically recreated by Kubernetes within ~30-60 seconds
TODO: [ ] `tofu plan` after pod recovery reported `No changes`

### Part 5: Ansible Update

TODO: [ ] `ansible/roles/opentofu-setup/tasks/main.yml` exists, nested correctly under `tasks/`
TODO: [ ] `opentofu-setup` role only installs OpenTofu when not already present (idempotent `which tofu` check)
TODO: [ ] `opentofu-setup` play appended to `ansible/site.yml` below the Week 1 and Week 3 plays, with `environment: PATH` set so `tofu` resolves under `become`
TODO: [ ] `ansible-playbook -i ansible/inventory ansible/site.yml -K` completes with `failed=0`

---

## Deliverables Verification

### Required Files

TODO: [ ] `infrastructure/main.tf` is committed (explicit local backend and Kubernetes provider)
TODO: [ ] `infrastructure/flask.tf` is committed (Deployment and Service)
TODO: [ ] `.gitignore` excludes `infrastructure/terraform.tfstate` and `terraform.tfstate.backup`
TODO: [ ] `ansible/site.yml` includes the `opentofu-setup` play
TODO: [ ] `ansible/roles/opentofu-setup/tasks/main.yml` is committed
TODO: [ ] `scripts/check-week4.sh` is present and runs clean

### GitHub Repository

TODO: [ ] All changes are pushed to the main branch
TODO: [ ] GitHub Project board shows all tasks completed
TODO: [ ] Commit messages describe the OpenTofu and Ansible changes

### Google Doc

TODO: [ ] Screenshot of `tofu plan` output from Part 3 (previewing the replica change) is attached
TODO: [ ] Screenshot of `tofu apply` showing `No changes` on the second run is attached
TODO: [ ] Screenshot showing the deleted pod cycling back to Running is attached
TODO: [ ] Screenshot of `./scripts/check-week4.sh` passing is attached
TODO: [ ] Discussion answers recorded for Parts 1-4 (providers, plan vs. apply, state storage, k3s recovery boundaries)

---

## Summary

**Overall Status:** [ ] ALL CHECKS PASS [ ] SOME CHECKS FAIL

**Blockers:** [List any blockers that prevent submission]

**Corrective Actions Taken:** [List any fixes applied during QA]

**QA Sign-Off:**

By signing below, QA certifies that all required validation checks have been executed and all deliverables meet the acceptance criteria.

**QA Signature:** _________________    **Date:** __________

---

## Notes for Sprint 3

[Any observations or recommendations for the next sprint]
