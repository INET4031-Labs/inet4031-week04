# Build Log: Week 4 Student Repository Scaffold

**Date Created:** 2026-08-14  
**Week:** Week 4  
**Sprint:** Sprint 2 (Async week, covering Weeks 3-4)  
**Source Document:** INET 4031 Lab Directions - Full Curriculum (Proposed)

---

## Purpose

This log documents all assumptions made and ambiguities encountered while building the Week 4 student repository scaffold. Any decisions that could affect student work or future weeks are recorded here.

---

## Assumptions Made

### 1. Sprint and Role Artifacts

**Assumption:** Week 4 belongs to Sprint 2 (Weeks 3-4), per the lab directions header "Sprint 2 Async".

**Basis:** Lab directions explicitly state "Sprint 2 Async | Due before Sprint 2 Review" at the top of Week 4 section.

**Impact:** Created sprint-2 role artifact files:
- `docs/sprint-2-retrospective.md` (owned by Scrum Master)
- `docs/environment-log.md` (owned by System Admin)
- `docs/acceptance-criteria.md` (written by QA before implementation)
- `docs/qa-report-2.md` (written by QA after implementation)

All four files are blank templates for students to fill in during Sprint 2.

---

### 2. Ansible Playbook Continuity

**Assumption:** The `ansible/site.yml` file exists from prior weeks (Weeks 1 and 3) and Week 4 must ADD to it, not rewrite it.

**Basis:** 
- Lab directions state "Add the opentofu-setup role to `ansible/site.yml`" (not "create")
- Cross-week structural rule states "Weeks 1-4 each visibly add that week's tool to `ansible/site.yml` — a strict superset week over week, not a rewrite"

**Impact:** Created `ansible/site.yml` as a scaffold showing only the Week 4 addition (the opentofu-setup play). Included a TODO comment instructing students to preserve prior plays and add this play to the existing file.

**Risk:** Students may overwrite site.yml instead of adding to it. Mitigation: The TODO comment and acceptance criteria explicitly address this.

---

### 3. OpenTofu Check Script Creation

**Assumption:** The `./scripts/check-week4.sh` script is not provided in the lab directions and must be created based on the "Validation Checks" section.

**Basis:** 
- Lab directions reference running `./scripts/check-week4.sh` in the Validation Checks section
- The script is not included in the provided code snippets
- QA responsibilities include running the check script (per Sprint Structure Layout)

**Impact:** Created a bash script that validates:
1. OpenTofu applies without changes (idempotency check)
2. Flask deployment has exactly 3 replicas
3. infrastructure/main.tf contains explicit local backend
4. All required files exist
5. State files are in .gitignore

**Limitation:** This script is a starting template and students should expand it based on their team's specific acceptance criteria. Included a TODO in the script itself noting this.

---

### 4. Flask Deployment Initial Replica Count

**Assumption:** The flask.tf Deployment should start with 2 replicas.

**Basis:** 
- Lab directions Part 1, Step 6: "This file defines a Kubernetes Deployment... replicas = 2"
- Lab directions Part 3, Step 10: "Change the Flask Deployment replica count from 2 to 3"

**Impact:** The scaffolded flask.tf file includes `replicas = 2` as provided in the lab directions. Part 3 instructs students to modify this to 3.

---

### 5. State File Storage Location

**Assumption:** OpenTofu state file (`terraform.tfstate`) is stored locally on disk in `infrastructure/terraform.tfstate` within the team container.

**Basis:** 
- Lab directions Part 1, Step 3: explicit `backend "local" { path = "terraform.tfstate" }`
- Lab directions Step 5: students add to .gitignore: `infrastructure/terraform.tfstate` and `infrastructure/terraform.tfstate.backup`
- Lab directions Storage Check note: "The state file... is intentionally excluded from version control. In production, state lives in a remote backend..."

**Impact:** 
- Created main.tf with explicit local backend
- Created .gitignore entries for state files
- Documented in acceptance criteria that state files must not be versioned

**Risk:** If the team container is wiped, state is lost. Mitigation: This is noted as a reflection question in the lab (Question 5 in the lab directions), so students are expected to recognize this limitation.

---

### 6. Kubeconfig Location

**Assumption:** Students have a valid `~/.kube/config` file pointing to the k3d cluster from Week 3.

**Basis:** 
- Lab directions prerequisites: "Week 3 complete: k3d cluster running with application manifests deployed; kubectl is configured and cluster is reachable"
- Lab directions Part 1, Step 3 in main.tf: `config_path = "~/.kube/config"`

**Impact:** The kubernetes provider in main.tf references `~/.kube/config` directly. No alternative paths are provided.

**Risk:** If k3d setup from Week 3 failed, students will not be able to proceed. Mitigation: System Admin should verify cluster health before async week begins (per Sprint Structure Layout).

---

### 7. Flask Credentials Secret

**Assumption:** A Kubernetes secret named `flask-credentials` already exists (created in Week 3 or before).

**Basis:** Lab directions Part 2, Step 6 in flask.tf shows `env_from { secret_ref { name = "flask-credentials" } }`.

**Impact:** The flask.tf Deployment references a secret that must exist for the pod to run successfully.

**Risk:** If the secret does not exist, pods will fail at startup. Mitigation: System Admin should verify secret exists before async week (acceptance criteria includes this verification).

---

### 8. GitHub Container Registry Access

**Assumption:** Teams have access to GitHub Container Registry (ghcr.io) and can push their flask-app image there (or have done so in Week 3).

**Basis:** Lab directions Part 2, Step 6: image reference is `ghcr.io/<your-org>/flask-app:latest`.

**Impact:** Flask.tf scaffolding includes a TODO comment instructing students to replace `<your-org>` with their GitHub organization or username.

**Risk:** If image is not accessible from within the k3d cluster, pod creation will fail. Mitigation: This is part of pre-flight checks (System Admin's responsibility).

---

### 9. Reflection Questions and Screenshots

**Assumption:** Screenshots and reflection question answers are NOT committed to the repository.

**Basis:** 
- Lab directions state screenshots "add to your team's Google Doc"
- Lab directions reflection questions say "(Answer in Google Doc)"
- Sprint Structure Layout shows Google Doc is the permanent team reflection artifact for the entire semester

**Impact:** 
- Screenshots are documented in the README and acceptance criteria but not stored in the repo
- Acceptance criteria template includes a field for screenshot verification but they live elsewhere
- Reflection questions are part of the lab's learning objectives but are answered externally

**Risk:** Students may incorrectly commit screenshots to the repo or assume Google Doc is optional. Mitigation: Emphasized in acceptance criteria that these go to Google Doc, not the repository.

---

### 10. Acceptance Criteria Writing Timing

**Assumption:** QA must write acceptance criteria BEFORE Developers begin implementation.

**Basis:** Sprint Structure Layout states: "QA owns the 'before': Writing acceptance criteria before Developers implement is the substantive QA work."

**Impact:** Created acceptance-criteria.md as a blank template with instructions that it should be filled in on Day 1 of the async week, before coding begins.

**Risk:** If QA writes criteria after implementation, it may not catch all requirements. Mitigation: The acceptance-criteria.md template explicitly states "This document is written BEFORE Developers begin implementation."

---

### 11. Idempotency Verification

**Assumption:** Running `tofu apply` twice with no configuration changes should result in "Resources: 0 added, 0 changed, 0 destroyed."

**Basis:** Lab directions Part 3, Step 14: "Expected output ends with: `Apply complete! Resources: 0 added, 0 changed, 0 destroyed.`"

**Impact:** The check script and acceptance criteria verify idempotency.

**Note:** This assumes that Kubernetes resource state is accurately tracked by OpenTofu's state file. If cluster state diverges from state file without `tofu` making the change, idempotency may fail. Mitigation: Part 4 tests this by manually deleting a pod and verifying that `tofu plan` still shows no changes (pods are managed by Deployment, not tracked individually).

---

### 12. Self-Healing Pod Recreation

**Assumption:** Kubernetes will automatically recreate a deleted pod within 60 seconds.

**Basis:** Lab directions Part 4, Step 17: "Within 30-60 seconds, all three pods should be running again."

**Impact:** Acceptance criteria requires observation of pod cycling behavior.

**Note:** This is a known Kubernetes behavior when Deployments are in place and is being used to demonstrate Kubernetes' resilience separate from OpenTofu's infrastructure-as-code concerns.

---

### 13. Privileged Container Mode

**Assumption:** The team container is running in privileged mode, allowing nested Docker and k3d operations.

**Basis:** Course Structure Overview states: "Every week from Week 3 onward depends on the university's container platform permitting `--privileged` mode for Docker containers."

**Impact:** All file headers include a notice that this architecture has NOT been approved by the professor.

**Risk:** If privileged mode is unavailable, the entire nested Docker model fails. Mitigation: Included a prominent warning in README.md.

---

### 14. Ansible Playbook Idempotency

**Assumption:** The opentofu-setup Ansible role is idempotent and can be run multiple times safely.

**Basis:** Lab directions Part 5, Step 22: "Run the playbook and confirm it passes." Implied to run during initial setup and again during Demo Day (Week 14).

**Impact:** Created opentofu-setup/tasks/main.yml with:
- Check if tofu is installed before downloading (avoids re-downloading)
- `changed_when: false` on tofu init (prevents false positives)
- All tasks use Ansible idempotent modules (get_url, unarchive, file)

---

## Ambiguities Encountered

### Ambiguity 1: Kubernetes Namespace for Flask App

**Issue:** Lab directions show `namespace = "default"` in flask.tf, but it's not clear if this is required or just a convention.

**Resolution:** Kept as "default" per the lab directions. Students should not change this without understanding the implications.

**Logged:** Noted in flask.tf file itself.

---

### Ambiguity 2: RollingUpdate vs. Other Deployment Strategies

**Issue:** Lab directions specify RollingUpdate strategy, but don't explain why or discuss alternatives.

**Resolution:** Provided the exact strategy from lab directions. Acceptance criteria requires this specific strategy.

**Logged:** Included in acceptance criteria for students to verify.

---

### Ambiguity 3: Ansible Inventory File

**Issue:** Lab directions show `ansible-playbook -i ansible/inventory ansible/site.yml` but don't provide the inventory file.

**Basis:** This is assumed to exist from Week 1.

**Impact:** Included this assumption in the build log. Inventory file is NOT part of Week 4 scaffold.

**Risk:** Students who did not complete Week 1 may not have the inventory file. Mitigation: Prerequisites state "Week 1 complete" implicitly.

---

### Ambiguity 4: OpenTofu vs. Terraform Naming in HCL

**Issue:** Lab directions use `terraform {}` block name for backwards compatibility, but emphasize calling the tool "OpenTofu" and the command "tofu".

**Resolution:** 
- main.tf includes explanatory comment: "OpenTofu uses `terraform {}` as the settings block name for backwards compatibility with the provider ecosystem. The tool, command, and project are OpenTofu. The block name is a technical compatibility detail, not a vendor reference."
- Followed the lab directions exactly.

**Logged:** Commented in main.tf file itself.

---

### Ambiguity 5: Check Script Scope

**Issue:** Lab directions reference "check-week4.sh" passing but don't specify what it should check beyond the four validation checks.

**Resolution:** Created a script that validates the four explicit checks plus file existence and .gitignore entries. Included a TODO in the script allowing students to expand it.

**Impact:** Script is a starting point, not the final definition of "passing."

---

### Ambiguity 6: State File Behavior After Pod Deletion

**Issue:** Part 4 deletes a pod manually but expects `tofu plan` to show no changes. This works because OpenTofu tracks Deployments, not individual pods. But the lab doesn't explain this.

**Resolution:** Documented this in acceptance criteria and in the lab directions reference in the README.

---

## Known Cross-Week Dependencies

### Dependency: Week 3 Completion

**Status:** Week 4 explicitly depends on Week 3 completion.

**Week 3 Assumptions:**
- k3d cluster is running
- kubectl is configured
- Application manifests are deployed
- flask-credentials secret exists
- Flask application image is accessible from the cluster

**Mitigation:** System Admin's first action in Sprint 2 (per Sprint Structure Layout) is to verify these prerequisites are met.

---

### Dependency: Demo Day (Week 14)

**Context:** The course intro explains that `ansible-playbook site.yml` will rebuild the entire toolchain on Demo Day.

**Impact:** Week 4's opentofu-setup role must be idempotent and not conflict with other roles.

**Assumption:** By Week 4, site.yml will accumulate plays for docker-setup, k3d-setup, and opentofu-setup in that order.

---

## Scaffolding Decisions

### Decision 1: Role Artifact Templates

Created four blank templates for role-specific artifacts rather than filling them in. This allows:
- Scrum Master to document their reflection in sprint-2-retrospective.md
- System Admin to document environment decisions in environment-log.md
- QA to define acceptance criteria in acceptance-criteria.md BEFORE implementation
- QA to document results in qa-report-2.md AFTER implementation

All templates are structured with section headers and examples to guide students.

---

### Decision 2: Scaffolding vs. Complete Code

For infrastructure files (main.tf, flask.tf), provided the complete template from lab directions rather than partial scaffolding.

**Rationale:** 
- Lab directions provide complete, tested code
- The only customization required is replacing `<your-org>` placeholder
- Providing templates as-is prevents transcription errors

**Note:** Included a TODO comment at the top of flask.tf to highlight the required customization.

---

### Decision 3: Ansible Site.yml Partial

Rather than providing a complete site.yml, created a partial that shows only Week 4's addition.

**Rationale:** 
- Week 4 site.yml is a strict superset of Week 3's site.yml
- Full file would assume/require knowledge of prior weeks
- Partial file with clear TODOs allows teams to integrate without overwriting prior work

**Risk Mitigation:** Acceptance criteria explicitly checks that site.yml is updated correctly.

---

### Decision 4: Check Script as Bash

Created check-week4.sh as a bash script rather than Python or other language.

**Rationale:** 
- Consistent with typical infrastructure automation
- No additional dependencies required
- kubectl is already available

---

## Files Created

```
Student Repositories/week-04/
├── README.md
│   └── Overview, architecture assumption notice, deliverables summary
├── .gitignore
│   └── OpenTofu state and cache directories
├── docs/
│   ├── sprint-2-retrospective.md (blank template)
│   ├── environment-log.md (blank template)
│   ├── acceptance-criteria.md (blank template)
│   └── qa-report-2.md (blank template)
├── infrastructure/
│   ├── main.tf
│   │   └── Terraform settings block with local backend and Kubernetes provider
│   └── flask.tf
│       └── Kubernetes Deployment and Service resources with <your-org> placeholder
├── ansible/
│   ├── site.yml
│   │   └── Partial file showing Week 4 addition (opentofu-setup play)
│   └── roles/
│       └── opentofu-setup/
│           └── tasks/
│               └── main.yml
│                   └── Ansible role for installing and initializing OpenTofu
└── scripts/
    └── check-week4.sh
        └── Bash script validating the four validation checks plus file existence

_orchestration/
└── build-log-week-04.md (this file)
```

---

## Summary

The Week 4 scaffold is built as a complete, independent structure that:
1. Includes all four role-artifact files as blank templates
2. Provides infrastructure-as-code scaffolding (main.tf, flask.tf) from lab directions
3. Shows how Ansible playbook accumulates (site.yml with TODO for prior weeks)
4. Includes a validation check script based on lab directions requirements
5. Provides comprehensive acceptance criteria for QA role
6. Documents the --privileged mode assumption prominently
7. Lists all assumptions and ambiguities encountered during building

Students should build on this scaffold following the week 4 lab directions, with role-specific responsibilities as defined in Sprint Structure Layout.

---

## Version Info

- **Build Date:** 2026-08-14
- **Source Lab Directions:** INET 4031 Lab Directions - Full Curriculum (Proposed)
- **Sprint Structure Reference:** Documents/Sprint_Structure_Layout.md
- **Course Rules:** inet4031-course-rules skill
