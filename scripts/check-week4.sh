#!/bin/bash

# Week 4 Validation Script
# This script runs all acceptance checks for Week 4 deliverables
# Run from the repository root: ./scripts/check-week4.sh

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
REPO_ROOT="$( dirname "$SCRIPT_DIR" )"

# tofu/kubectl are typically installed to /usr/local/bin; make sure it's on
# PATH regardless of how this script is invoked (e.g. under sudo, where
# root's PATH may not include it).
export PATH="/usr/local/bin:$PATH"

# k3d writes its kubeconfig under the home directory of whichever user ran
# `k3d cluster create` (your normal user, not root). If this script is run
# with sudo, point kubectl back at that config instead of root's.
REAL_USER="${SUDO_USER:-$USER}"
REAL_HOME="$(getent passwd "$REAL_USER" | cut -d: -f6)"
if [ -f "$REAL_HOME/.kube/config" ]; then
    export KUBECONFIG="$REAL_HOME/.kube/config"
fi

# Color codes for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Track pass/fail status
PASS_COUNT=0
FAIL_COUNT=0

# Helper function to print results
check_pass() {
    echo -e "${GREEN}[PASS]${NC} $1"
    PASS_COUNT=$((PASS_COUNT + 1))
}

check_fail() {
    echo -e "${RED}[FAIL]${NC} $1"
    FAIL_COUNT=$((FAIL_COUNT + 1))
}

check_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

echo "========================================="
echo "Week 4 Validation Checks"
echo "========================================="
echo ""

# =========================================
# Check 1: OpenTofu Applies Without Error
# =========================================
echo "Check 1: OpenTofu Applies Without Error"
echo "-----------------------------------------"

if command -v tofu &> /dev/null; then
    check_pass "tofu is installed"
else
    check_fail "tofu is not installed"
fi

if (cd "$REPO_ROOT/infrastructure" && tofu plan 2>&1 | grep -q "No changes"); then
    check_pass "OpenTofu applies idempotently (tofu plan shows no changes)"
else
    check_fail "tofu plan shows pending changes - infrastructure has drifted from HCL"
fi

# =========================================
# Check 2: Flask Deployment Has 3 Replicas
# =========================================
echo ""
echo "Check 2: Flask Deployment Has 3 Replicas"
echo "-------------------------------------------"

FLASK_REPLICAS=$(kubectl get deployment flask -o jsonpath='{.spec.replicas}' 2>/dev/null || echo "0")
if [ "$FLASK_REPLICAS" = "3" ]; then
    check_pass "Flask Deployment has 3 replicas"
else
    check_fail "Flask Deployment does not have 3 replicas (found: $FLASK_REPLICAS)"
fi

# =========================================
# Check 3: infrastructure/main.tf Has Local Backend
# =========================================
echo ""
echo "Check 3: infrastructure/main.tf Has Local Backend"
echo "-----------------------------------------------------"

if grep -q 'backend "local"' "$REPO_ROOT/infrastructure/main.tf" 2>/dev/null && \
   grep -A2 'backend "local"' "$REPO_ROOT/infrastructure/main.tf" | grep -q 'terraform.tfstate'; then
    check_pass "infrastructure/main.tf has a local backend with the correct path"
else
    check_fail "infrastructure/main.tf is missing a local backend with path = terraform.tfstate"
fi

# =========================================
# Check 4: Required Files Exist
# =========================================
echo ""
echo "Check 4: Required Files Exist"
echo "--------------------------------"

REQUIRED_FILES=(
    "infrastructure/main.tf"
    "infrastructure/flask.tf"
    "ansible/site.yml"
    "ansible/roles/opentofu-setup/tasks/main.yml"
)

for file in "${REQUIRED_FILES[@]}"; do
    if [ -f "$REPO_ROOT/$file" ]; then
        check_pass "File exists: $file"
    else
        check_fail "File missing: $file"
    fi
done

# =========================================
# Check 5: State Files Are Gitignored
# =========================================
echo ""
echo "Check 5: State Files Are Gitignored"
echo "--------------------------------------"

if (cd "$REPO_ROOT" && git check-ignore -q infrastructure/terraform.tfstate); then
    check_pass "infrastructure/terraform.tfstate is gitignored"
else
    check_fail "infrastructure/terraform.tfstate is not gitignored"
fi

if (cd "$REPO_ROOT" && git check-ignore -q infrastructure/terraform.tfstate.backup); then
    check_pass "infrastructure/terraform.tfstate.backup is gitignored"
else
    check_fail "infrastructure/terraform.tfstate.backup is not gitignored"
fi

# =========================================
# Check 6: Ansible opentofu-setup Role
# =========================================
echo ""
echo "Check 6: Ansible opentofu-setup Role"
echo "----------------------------------------"

if grep -q "opentofu-setup" "$REPO_ROOT/ansible/site.yml" 2>/dev/null; then
    check_pass "ansible/site.yml includes opentofu-setup role"
else
    check_fail "ansible/site.yml does not include opentofu-setup role"
fi

if grep -q "PATH:" "$REPO_ROOT/ansible/site.yml" 2>/dev/null; then
    check_pass "ansible/site.yml sets PATH environment for tofu under become"
else
    check_warn "ansible/site.yml may be missing the PATH override for tofu under become"
fi

# =========================================
# Summary
# =========================================
echo ""
echo "========================================="
echo "Validation Summary"
echo "========================================="
echo -e "Passed: ${GREEN}$PASS_COUNT${NC}"
echo -e "Failed: ${RED}$FAIL_COUNT${NC}"
echo ""

if [ "$FAIL_COUNT" -eq 0 ]; then
    echo -e "${GREEN}Status: ALL CHECKS PASSED${NC}"
    exit 0
else
    echo -e "${RED}Status: SOME CHECKS FAILED - Review errors above${NC}"
    exit 1
fi
