# Sprint 2 Acceptance Criteria

**QA Lead:** [Name]  
**Sprint:** Sprint 2 (Weeks 3-4)  
**Date Written:** [Date before implementation begins]

> This document is written BEFORE Developers begin implementation. It defines what "done" means for Sprint 2, independent of the automated check script.

---

## OpenTofu Installation and Configuration

**Criterion 1:** OpenTofu binary is installed and executable

- `tofu version` command runs successfully
- Output begins with `OpenTofu v1.x.x`
- Binary location: `/usr/local/bin/tofu`

**Criterion 2:** Local backend is explicitly configured

- `infrastructure/main.tf` contains a `backend "local"` block
- Backend path is set to `"terraform.tfstate"`
- `.gitignore` excludes both `infrastructure/terraform.tfstate` and `infrastructure/terraform.tfstate.backup`

---

## Kubernetes Resource Management

**Criterion 3:** Deployment configuration is correct

- `infrastructure/flask.tf` contains a `kubernetes_deployment` resource named `flask`
- Deployment is in the `default` namespace
- Deployment has exactly 2 replicas (after Part 2 completion)
- Deployment uses `RollingUpdate` strategy with max_surge=1 and max_unavailable=0
- Container image uses format `ghcr.io/<team-org>/flask-app:latest` where `<team-org>` is replaced with actual team identifier

**Criterion 4:** Service configuration is correct

- `infrastructure/flask.tf` contains a `kubernetes_service` resource named `flask`
- Service routes port 80 to container port 5000
- Service uses `app=flask` label selector

**Criterion 5:** Resources are deployable and idempotent

- `tofu init` completes without errors
- `tofu plan` shows planned changes are correct
- `tofu apply` successfully creates/updates resources
- Running `tofu apply` a second time with no configuration changes returns `Apply complete! Resources: 0 added, 0 changed, 0 destroyed.`

---

## Kubernetes Behavior Validation

**Criterion 6:** Deployment replicas update correctly

- After modification from 2 to 3 replicas, `kubectl get deployment flask` shows `3/3 READY`
- Modification is applied via `tofu apply`

**Criterion 7:** Kubernetes self-healing works

- Manually deleting a Flask pod triggers automatic pod recreation
- All pods return to running state within 60 seconds
- `tofu plan` shows no changes after pod recovery (state file tracks deployment, not individual pod instances)

---

## Ansible Playbook Integration

**Criterion 8:** Ansible automation is idempotent

- `ansible/roles/opentofu-setup/tasks/main.yml` follows Ansible best practices
- Playbook can run multiple times without errors
- `ansible-playbook -i ansible/inventory ansible/site.yml` completes successfully
- `ansible/site.yml` includes the new opentofu-setup play

**Criterion 9:** Ansible extends site.yml correctly

- `ansible/site.yml` contains a play that includes the opentofu-setup role
- Play targets `localhost` with `connection: local`
- Play sets `become: yes` for privilege escalation

---

## Verification and Documentation

**Criterion 10:** All required screenshots are captured

- Screenshot 1: `tofu plan` output from Part 2 showing planned resource creation
- Screenshot 2: Pod cycling output during resilience test (showing pod transitions)
- Screenshot 3: `tofu plan` showing `No changes` after second `tofu apply`
- Screenshot 4: `./scripts/check-week4.sh` passing with all checks passing
- Screenshots are added to the team's Google Doc

**Criterion 11:** Reflection questions are answered in Google Doc

- All five reflection questions are answered by team members
- Answers demonstrate understanding of state management, idempotency, and infrastructure as code

---

## Definition of Done

All deliverables are met when:
1. All files are committed to the `main` branch of the team repository
2. All acceptance criteria above are satisfied
3. `./scripts/check-week4.sh` exits with status 0
4. Screenshots are documented in the team Google Doc
5. Reflection questions are answered in the team Google Doc

---

## Notes

[QA notes on any special considerations, potential risks, or areas requiring extra validation]
