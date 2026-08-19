## Week 4: Infrastructure as Code with OpenTofu

**Sprint 2 Async | Due before Sprint 2 Review**

### Overview

In this lab, you manage your Kubernetes infrastructure declaratively using OpenTofu, the open-source Linux Foundation-governed fork of Terraform. OpenTofu uses HCL, the same configuration language, same workflow, and the same provider ecosystem. You will write OpenTofu configuration that targets your k3d cluster through the Kubernetes provider, use a local backend to store state inside the team container, and verify that your infrastructure is idempotent and self-consistent. You will also extend the Ansible playbook with OpenTofu installation. After completing this lab, you will have your Kubernetes infrastructure defined as HCL code managed declaratively through OpenTofu.

> **OpenTofu rules enforced throughout this lab:**
> - Always say "OpenTofu" -- never "Terraform"
> - The command is `tofu`, not `terraform`
> - Link only to opentofu.org for documentation and downloads
> - Use a local backend explicitly in every configuration file

### Learning Objectives

- Install OpenTofu from opentofu.org and initialize a local backend configuration
- Write HCL resources using the Kubernetes provider to manage Deployments and Services
- Run `tofu plan` to preview changes before applying them
- Verify that `tofu apply` is idempotent (applying twice produces no additional changes)
- Extend the Ansible playbook with OpenTofu installation

### Prerequisites

- Week 3 complete: k3d cluster running with application manifests deployed
- `kubectl` is configured and cluster is reachable

---

### Part 1: Install OpenTofu and Initialize

> **Background:** OpenTofu is an open-source infrastructure-as-code tool governed by the Linux Foundation. It uses HCL (HashiCorp Configuration Language) to describe infrastructure declaratively. OpenTofu maintains full compatibility with the Terraform provider ecosystem. The command-line tool is `tofu`. Documentation and downloads are at opentofu.org.

**Step 1.** Install OpenTofu inside your team container.

```bash
curl -Lo /tmp/tofu.tar.gz \
  https://github.com/opentofu/opentofu/releases/download/v1.8.0/tofu_1.8.0_linux_amd64.tar.gz
tar -xzf /tmp/tofu.tar.gz -C /tmp
mv /tmp/tofu /usr/local/bin/tofu
chmod +x /usr/local/bin/tofu
rm /tmp/tofu.tar.gz
```

Verify:

```bash
tofu version
```

Expected: output beginning with `OpenTofu v1.x.x`.

**Step 2.** Create the OpenTofu directory in your repository.

```bash
mkdir -p infrastructure
```

**Step 3.** Create `infrastructure/main.tf`. This file defines the required providers and the backend. The local backend stores the state file on disk. This must be explicit.

```hcl
terraform {
  required_version = ">= 1.0"

  backend "local" {
    path = "terraform.tfstate"
  }

  required_providers {
    kubernetes = {
      source  = "opentofu/kubernetes"
      version = "~> 2.0"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}
```

> **Note on the `terraform {}` block name:** OpenTofu uses `terraform {}` as the settings block name for backwards compatibility with the provider ecosystem. The tool, command, and project are OpenTofu. The block name is a technical compatibility detail, not a vendor reference.

**Step 4.** Initialize the OpenTofu working directory.

```bash
cd infrastructure
tofu init
```

Expected: output ending with `OpenTofu has been successfully initialized!`

**Step 5.** Add `infrastructure/terraform.tfstate` to `.gitignore`. State files can contain resource metadata that should not be in version control, even when they contain no credentials. In production, state lives in a remote backend with access controls.

```bash
echo "infrastructure/terraform.tfstate" >> .gitignore
echo "infrastructure/terraform.tfstate.backup" >> .gitignore
git add .gitignore
git commit -m "chore: ignore OpenTofu state files"
git push
```

**Discussion (add to Google Doc):** What is a provider in OpenTofu? How does the Kubernetes provider differ from, for example, an AWS provider? What does "provider" mean in the context of infrastructure as code?

---

### Part 2: Define Kubernetes Resources with OpenTofu

**Step 6.** Create `infrastructure/flask.tf`. This file defines a Kubernetes Deployment and Service for the Flask application.

```hcl
resource "kubernetes_deployment" "flask" {
  metadata {
    name      = "flask"
    namespace = "default"
    labels = {
      app = "flask"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "flask"
      }
    }

    strategy {
      type = "RollingUpdate"

      rolling_update {
        max_surge       = "1"
        max_unavailable = "0"
      }
    }

    template {
      metadata {
        labels = {
          app = "flask"
        }
      }

      spec {
        container {
          name  = "flask"
          image = "ghcr.io/<your-org>/flask-app:latest"

          env_from {
            secret_ref {
              name = "flask-credentials"
            }
          }

          port {
            container_port = 5000
          }

          resources {
            limits = {
              cpu    = "500m"
              memory = "256Mi"
            }
            requests = {
              cpu    = "100m"
              memory = "128Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "flask" {
  metadata {
    name      = "flask"
    namespace = "default"
  }

  spec {
    selector = {
      app = "flask"
    }

    port {
      port        = 80
      target_port = 5000
    }
  }
}
```

Replace `<your-org>` with your team's GitHub organization or username.

**Step 7.** Run `tofu plan` to preview what would be created or modified.

```bash
tofu plan
```

Read the output carefully. It shows additions (`+`), modifications (`~`), and deletions (`-`). **Take a screenshot of the plan output and add it to your team's Google Doc.**

**Discussion (add to Google Doc):** `tofu plan` showed you what WOULD change before you changed it. How does this differ from running `kubectl apply`? What is the advantage of seeing a plan in a team environment before applying changes?

**Step 8.** Apply the configuration.

```bash
tofu apply
```

Type `yes` when prompted. Watch the output as resources are created or updated.

**Step 9.** Verify the Deployment is healthy.

```bash
kubectl get deployment flask
```

Expected: `flask` deployment with `2/2` READY.

---

### Part 3: Make a Change and Verify Idempotency

**Step 10.** Change the Flask Deployment replica count from 2 to 3 in `infrastructure/flask.tf`.

**Step 11.** Preview the change.

```bash
tofu plan
```

You should see a modification (`~`) to the Flask Deployment affecting `replicas` only.

**Step 12.** Apply the change.

```bash
tofu apply
```

**Step 13.** Verify the replica count updated.

```bash
kubectl get deployment flask
```

Expected: `3/3` READY.

**Step 14.** Run `tofu apply` again without making any changes.

```bash
tofu apply
```

Expected output ends with: `Apply complete! Resources: 0 added, 0 changed, 0 destroyed.`

This confirms the configuration is idempotent.

> **Enterprise Pattern:** Idempotency means that applying the same configuration multiple times produces the same result. This is a fundamental requirement for infrastructure-as-code tooling used in automated pipelines: if running the same configuration twice causes changes, the tool cannot be safely automated.

**Discussion (add to Google Doc):** `tofu apply` ran a second time and made no changes. What does this tell you about how OpenTofu tracks state? Where is that state stored, and what happens if the state file is lost or corrupted?

---

### Part 4: k3s Resilience Validation

**Step 15.** Get the name of one of the Flask pods.

```bash
kubectl get pods -l app=flask
```

Copy one pod name from the output.

**Step 16.** Delete that pod manually.

```bash
kubectl delete pod <pod-name>
```

**Step 17.** Watch what happens.

```bash
kubectl get pods -l app=flask --watch
```

You should see the deleted pod enter `Terminating` and a new pod appear in `ContainerCreating` almost immediately. Within 30-60 seconds, all three pods should be running again. **Take a screenshot showing the pod cycling.**

**Step 18.** Run `tofu plan` after the pod recovery.

```bash
tofu plan
```

Expected: `No changes. Your infrastructure matches the configuration.`

**Discussion (add to Google Doc):** Kubernetes automatically replaced the deleted pod. What is the boundary of what Kubernetes can recover from automatically? Give one example of a failure that Kubernetes cannot recover from without human intervention.

---

### Part 5: Ansible Update

**Step 19.** Create the opentofu-setup role.

```bash
mkdir -p ansible/roles/opentofu-setup/tasks
```

**Step 20.** Create `ansible/roles/opentofu-setup/tasks/main.yml`.

```yaml
---
- name: Check if OpenTofu is installed
  command: which tofu
  register: tofu_check
  failed_when: false
  changed_when: false

- name: Download and install OpenTofu
  block:
    - name: Download OpenTofu tarball
      get_url:
        url: https://github.com/opentofu/opentofu/releases/download/v1.8.0/tofu_1.8.0_linux_amd64.tar.gz
        dest: /tmp/tofu.tar.gz
        mode: '0644'

    - name: Extract OpenTofu binary
      unarchive:
        src: /tmp/tofu.tar.gz
        dest: /usr/local/bin
        remote_src: yes
        extra_opts: ['--wildcards', 'tofu']

    - name: Ensure tofu is executable
      file:
        path: /usr/local/bin/tofu
        mode: '0755'

    - name: Remove tarball
      file:
        path: /tmp/tofu.tar.gz
        state: absent
  when: tofu_check.rc != 0

- name: Initialize OpenTofu working directory
  command: tofu init
  args:
    chdir: "{{ playbook_dir }}/../infrastructure"
  changed_when: false
```

**Step 21.** Add the opentofu-setup role to `ansible/site.yml`.

```yaml
- name: Install and initialize OpenTofu
  hosts: localhost
  connection: local
  become: yes

  roles:
    - opentofu-setup
```

**Step 22.** Run the playbook and confirm it passes.

```bash
ansible-playbook -i ansible/inventory ansible/site.yml
```

**Step 23.** Commit everything.

```bash
git add infrastructure/ ansible/
git commit -m "feat: add OpenTofu configuration for k8s resources; add opentofu-setup Ansible role"
git push origin main
```

---

### Storage Check

```bash
df -h
docker system df
```

> **Note:** The state file (`infrastructure/terraform.tfstate`) contains the current state of all managed resources and is intentionally excluded from version control. In production, state lives in a remote backend with state locking to prevent two operators from applying simultaneously. If two team members run `tofu apply` simultaneously against the same cluster, the second will read stale state. If this happens, run `tofu refresh` to re-read actual cluster state before running `tofu plan` again.

---

### Validation Checks

#### Validation Check: OpenTofu Applies Without Error

```bash
tofu plan
```

Expected: `No changes. Your infrastructure matches the configuration.`

#### Validation Check: Flask Deployment Has 3 Replicas

```bash
kubectl get deployment flask -o jsonpath='{.spec.replicas}'
```

Expected output: `3`

#### Validation Check: infrastructure/main.tf Has Local Backend

```bash
grep -A3 "backend" infrastructure/main.tf
```

Expected: output showing `backend "local" { path = "terraform.tfstate" }`.

#### Validation Check: Check Script Passes

```bash
./scripts/check-week4.sh
```

---

### Deliverables

- `infrastructure/main.tf` committed (with explicit local backend and Kubernetes provider)
- `infrastructure/flask.tf` committed (Deployment and Service)
- `.gitignore` updated to exclude state files
- Screenshot of `tofu plan` output showing planned changes from Part 3
- `ansible/site.yml` updated with opentofu-setup play
- `ansible/roles/opentofu-setup/tasks/main.yml` committed
- `./scripts/check-week4.sh` runs clean

**Screenshot requirements:**

- **Screenshot 1:** `tofu plan` output from Part 2
- **Screenshot 2:** pod cycling during resilience test
- **Screenshot 3:** `tofu plan` showing `No changes` after second apply
- **Screenshot 4:** `./scripts/check-week4.sh` passing

---

### Reflection Questions (Answer in Google Doc)

1. You wrote HCL configuration that describes what your Kubernetes cluster should look like. If you deleted the cluster and re-ran `tofu apply`, would it recreate everything? What would NOT be recreated automatically?
2. Your state file lives in `infrastructure/terraform.tfstate`. If two team members both run `tofu apply` simultaneously against the same cluster, what happens? How do production teams solve this?
3. You managed Kubernetes resources with OpenTofu instead of `kubectl`. What is the tradeoff? When would a team choose `kubectl` directly over an IaC tool?
4. The Kubernetes provider for OpenTofu reads your kubeconfig, which points at a local k3d cluster. What would you need to change if you wanted to target a cloud-hosted Kubernetes cluster instead?
5. (Extend) Your local backend stores state on disk in the team container. What happens to your state file if the container is wiped? What would need to change about your OpenTofu setup to survive a container wipe?

---

