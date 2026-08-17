#!/bin/bash

# Week 4 Validation Check Script
# This script validates that Week 4 deliverables meet the requirements.
# Run from the root of your repository: ./scripts/check-week4.sh

set -e  # Exit on first error

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'  # No Color

CHECKS_PASSED=0
CHECKS_FAILED=0

# Helper function to print test results
print_check() {
  local name="$1"
  local status="$2"

  if [ "$status" = "PASS" ]; then
    echo -e "${GREEN}[PASS]${NC} $name"
    ((CHECKS_PASSED++))
  else
    echo -e "${RED}[FAIL]${NC} $name"
    ((CHECKS_FAILED++))
  fi
}

# TODO: Update this script with your team's specific requirements.
# This is a starting template; add additional checks as needed.

echo "=== Week 4 Validation Checks ==="
echo ""

# Check 1: OpenTofu Applies Without Error
echo "Check 1: OpenTofu applies without changes"
if cd "$REPO_ROOT/infrastructure" && tofu plan 2>&1 | grep -q "No changes"; then
  print_check "OpenTofu applies idempotently" "PASS"
else
  print_check "OpenTofu applies idempotently" "FAIL"
fi
cd "$REPO_ROOT"

# Check 2: Flask Deployment Has 3 Replicas
echo ""
echo "Check 2: Flask Deployment has 3 replicas"
FLASK_REPLICAS=$(kubectl get deployment flask -o jsonpath='{.spec.replicas}' 2>/dev/null || echo "0")
if [ "$FLASK_REPLICAS" = "3" ]; then
  print_check "Flask deployment has 3 replicas" "PASS"
else
  print_check "Flask deployment has 3 replicas (got $FLASK_REPLICAS)" "FAIL"
fi

# Check 3: infrastructure/main.tf Has Local Backend
echo ""
echo "Check 3: infrastructure/main.tf has local backend"
if grep -q 'backend "local"' "$REPO_ROOT/infrastructure/main.tf" && \
   grep -A2 'backend "local"' "$REPO_ROOT/infrastructure/main.tf" | grep -q 'terraform.tfstate'; then
  print_check "infrastructure/main.tf has local backend with correct path" "PASS"
else
  print_check "infrastructure/main.tf has local backend with correct path" "FAIL"
fi

# Check 4: Verify required files exist
echo ""
echo "Check 4: Required files exist"
FILES_OK=true
for file in \
  "infrastructure/main.tf" \
  "infrastructure/flask.tf" \
  "ansible/site.yml" \
  "ansible/roles/opentofu-setup/tasks/main.yml"; do
  if [ ! -f "$REPO_ROOT/$file" ]; then
    echo -e "${RED}[FAIL]${NC} Missing required file: $file"
    FILES_OK=false
    ((CHECKS_FAILED++))
  fi
done

if [ "$FILES_OK" = true ]; then
  print_check "All required files exist" "PASS"
fi

# Check 5: Verify state files are gitignored
echo ""
echo "Check 5: State files are in .gitignore"
if grep -q "infrastructure/terraform.tfstate" "$REPO_ROOT/.gitignore" 2>/dev/null; then
  print_check "State files in .gitignore" "PASS"
else
  print_check "State files in .gitignore" "FAIL"
fi

# Summary
echo ""
echo "=== Summary ==="
echo -e "${GREEN}Passed: $CHECKS_PASSED${NC}"
echo -e "${RED}Failed: $CHECKS_FAILED${NC}"
echo ""

if [ $CHECKS_FAILED -gt 0 ]; then
  echo -e "${RED}Some checks failed. Please review the output above.${NC}"
  exit 1
else
  echo -e "${GREEN}All checks passed!${NC}"
  exit 0
fi
