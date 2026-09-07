# Week 4: Infrastructure as Code with OpenTofu

**Sprint 2 | Due before Sprint 2 Review**

Same team-container privileged-mode assumption as Week 3 applies here (your k3d cluster access depends on it). See Week 3's README if you haven't confirmed it yet.

## Overview

In this lab, you manage your Kubernetes infrastructure declaratively using OpenTofu, the open-source Linux Foundation-governed fork of Terraform. You will write OpenTofu configuration that targets your k3d cluster through the Kubernetes provider, use a local backend to store state inside the team container, and verify that your infrastructure is idempotent. You will also extend the Ansible playbook with OpenTofu installation.

## Learning Objectives

- Install OpenTofu from opentofu.org and initialize a local backend configuration
- Write HCL resources using the Kubernetes provider to manage Deployments and Services
- Run `tofu plan` to preview changes before applying them
- Verify that `tofu apply` is idempotent
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
week, following the wiki. Add the new Ansible play below Week 1's and Week 3's
existing plays, never replacing them.

## OpenTofu Rules

- The command is `tofu`, not `terraform`
- Link only to opentofu.org for documentation and downloads
- Use a local backend explicitly in every configuration file

## Role Distribution

- **Scrum Master:** manages sprint board and team communication, writes sprint retrospective
- **System Admin:** verifies environment health, documents infrastructure decisions
- **QA:** validates deliverables, confirms `tofu plan` is idempotent, runs check script
- **Developer(s):** implements OpenTofu configuration and Ansible playbook updates

## Deliverables

- `infrastructure/main.tf` with explicit local backend and Kubernetes provider
- `infrastructure/flask.tf` with Deployment and Service resources
- `.gitignore` updated to exclude state files
- `ansible/site.yml` updated with opentofu-setup play
- `ansible/roles/opentofu-setup/tasks/main.yml` committed
- `./scripts/check-week4.sh` passing

## Full Instructions

The complete step-by-step lab, including exact HCL and validation commands, is in this repo's Wiki tab. This README is a reference, not a substitute.
