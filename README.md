# Week 4: Infrastructure as Code with OpenTofu

**Sprint 2 Async | Due before Sprint 2 Review**

## IMPORTANT: Architecture Assumption Notice

This lab depends on the university's container platform permitting `--privileged` mode for Docker containers. This assumption has **not been confirmed** by the professor. If privileged mode is unavailable, the nested Docker and k3d model described in this course fails entirely, and the course falls back to individual student VMs. Do not treat this environment as decided until the professor confirms it.

---

## Overview

In this lab, you will manage your Kubernetes infrastructure declaratively using OpenTofu, the open-source Linux Foundation-governed fork of Terraform. OpenTofu uses HCL, the same configuration language and workflow as Terraform, and maintains full compatibility with the Terraform provider ecosystem. You will write OpenTofu configuration that targets your k3d cluster through the Kubernetes provider, use a local backend to store state inside the team container, and verify that your infrastructure is idempotent and self-consistent. You will also extend the Ansible playbook with OpenTofu installation. After completing this lab, you will have your Kubernetes infrastructure defined as HCL code managed declaratively through OpenTofu.

## Learning Objectives

- Install OpenTofu from opentofu.org and initialize a local backend configuration
- Write HCL resources using the Kubernetes provider to manage Deployments and Services
- Run `tofu plan` to preview changes before applying them
- Verify that `tofu apply` is idempotent (applying twice produces no additional changes)
- Extend the Ansible playbook with OpenTofu installation

## Prerequisites

- Week 3 complete: k3d cluster running with application manifests deployed
- `kubectl` is configured and cluster is reachable

## Pulling This Week's Starter Content Into Your Team Repo

This repo (`inet4031-week04`) is instructor-provided starter/reference content for
Week 4, not something you clone standalone. Pull the pieces you need into your
team's single repo:

```bash
git remote add week4 https://github.com/INET4031-Labs/inet4031-week04.git
git fetch week4
git checkout week4/main -- scripts docs
git remote remove week4
```

**`infrastructure/main.tf`, `infrastructure/flask.tf`, and the `opentofu-setup`
Ansible role are not shipped as files in this repo.** You write them yourself this
week, following the wiki step by step. Writing the OpenTofu configuration and adding
the new Ansible play (below Week 1's and Week 3's existing plays, never replacing them)
is the actual exercise for this lab.

## OpenTofu Rules

Throughout this lab, apply these rules:
- Always say "OpenTofu" -- never "Terraform"
- The command is `tofu`, not `terraform`
- Link only to opentofu.org for documentation and downloads
- Use a local backend explicitly in every configuration file

## Repository Structure

- `infrastructure/main.tf` - OpenTofu settings and provider configuration
- `infrastructure/flask.tf` - Kubernetes Deployment and Service resources
- `ansible/site.yml` - Updated with opentofu-setup play
- `ansible/roles/opentofu-setup/tasks/main.yml` - Ansible role for OpenTofu installation
- `scripts/check-week4.sh` - Validation checks
- `docs/` - Role-specific documentation artifacts (sprint retrospective, QA report)

## Role-Specific Responsibilities

This lab is structured so that all four team roles contribute:

- **Scrum Master:** Manages sprint board and team communication; writes sprint retrospective
- **System Admin:** Verifies environment health; documents infrastructure decisions in environment log
- **QA:** Validates deliverables, confirms `tofu plan` is idempotent, and runs check script
- **Developer(s):** Implements OpenTofu configuration and Ansible playbook updates

## Key Validation Points

Before submitting:
1. `tofu plan` returns no changes (configuration is idempotent)
2. Flask Deployment has 3 replicas
3. `infrastructure/main.tf` includes explicit local backend
4. `./scripts/check-week4.sh` passes cleanly

---

## TODO Markers

Throughout the scaffolded files, look for `# TODO:` comments indicating where student work is required or decisions need to be made.

---

## Deliverables Summary

- `infrastructure/main.tf` with explicit local backend and Kubernetes provider
- `infrastructure/flask.tf` with Deployment and Service resources
- `.gitignore` updated to exclude state files
- Screenshots of `tofu plan` and pod cycling behavior
- `ansible/site.yml` updated with opentofu-setup play
- `ansible/roles/opentofu-setup/tasks/main.yml` committed
- `./scripts/check-week4.sh` passing
