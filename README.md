# Week 4: Infrastructure as Code with OpenTofu

**Sprint 2 | Due before Sprint 2 Review**

## Overview

In this lab, you define your Kubernetes infrastructure declaratively using OpenTofu, the open-source Linux Foundation-governed fork of Terraform. You will write OpenTofu configuration that targets your k3d cluster through the Kubernetes provider, configure a local backend to store state on your team's VM, and predict how OpenTofu will behave when that configuration is planned and applied, including whether it is idempotent. You will also extend the Ansible playbook with an OpenTofu setup role.

**How this lab works:** This week you write OpenTofu and Ansible code, but you do not run `tofu init`, `tofu plan`, `tofu apply`, or `ansible-playbook`. OpenTofu is already installed on your team's VM by the instructor. For each step marked **[PREDICT ONLY]**, you record what you expect the command to do in the Prediction Log in your team's Google Doc. The Actual column stays blank until your team rebuilds the full stack on an empty VM for the live demo. The one exception is Part 4, where QA deletes a Flask pod on your live Week 3 cluster and observes the recovery.

## Learning Objectives

- Write an OpenTofu configuration with an explicit local backend
- Write HCL resources using the Kubernetes provider to manage Deployments and Services
- Predict the output of `tofu plan` before changes are applied
- Predict whether `tofu apply` is idempotent
- Extend the Ansible playbook with an OpenTofu setup role

## Prerequisites

- Week 3 complete: k3d cluster running with application manifests deployed
- `kubectl` is configured and cluster is reachable
- OpenTofu is installed on your team's VM by the instructor (you will not run it this week)

## OpenTofu Rules

- The command is `tofu`, not `terraform`
- Link only to opentofu.org for documentation
- Use a local backend explicitly in every configuration file
- Do not run `tofu init`, `tofu plan`, `tofu apply`, or `ansible-playbook` this week

## Role Distribution

Use the same Sprint 2 role assignments your team recorded in Week 3. No single team member should complete the entire lab.

- **Scrum Master:** creates the Prediction Log table in the team Google Doc, manages the sprint board and team communication, writes the sprint retrospective, opens the Week 5 tickets, and pairs with the Developers on Part 3
- **System Admin:** pulls the starter content, leads Part 1 (OpenTofu configuration) and Part 5 (Ansible role and play), and runs the Storage Check
- **QA:** leads Part 4 (resilience validation), runs all validation checks and the check script, and is the final approver before deliverables are marked Done
- **Developer(s):** lead Part 2 (`flask.tf` and removing the Week 3 Flask manifests) and Part 3 (replica change and idempotency predictions). With five team members, split the Developer steps between two people

The role that leads a part writes the Prediction Log entries and Google Doc discussion answers for that part, and the whole team reviews them before the part is marked Done.

## Deliverables

- `infrastructure/main.tf` with explicit local backend and Kubernetes provider
- `infrastructure/flask.tf` with Deployment and Service resources, replicas set to 3
- Week 3 Flask Deployment and Service manifests removed from `manifests/`
- `.gitignore` updated to exclude state files and `infrastructure/.terraform/`
- `ansible/site.yml` updated with opentofu-setup play
- `ansible/roles/opentofu-setup/tasks/main.yml` committed
- Prediction Log (P1 to P10) completed in your team's Google Doc, with the Actual column filled in for P8 only
- Screenshot of the Flask pod cycling back to Running (Part 4)
- `./scripts/check-week4.sh` passing

## Full Instructions

The complete step-by-step lab, including exact HCL and validation commands, is in this repo's Wiki tab. This README is a reference, not a substitute.
