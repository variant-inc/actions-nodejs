#!/bin/bash

set -eo
echo "Start: Setting Prerequisites"
cd "$GITHUB_WORKSPACE"
echo "Current directory: $(pwd)"

export AWS_WEB_IDENTITY_TOKEN_FILE="/token"
echo "$AWS_WEB_IDENTITY_TOKEN" >> "$AWS_WEB_IDENTITY_TOKEN_FILE"

export AWS_DEFAULT_REGION="${AWS_DEFAULT_REGION:=us-east-1}"

export BRANCH_NAME="$GITVERSION_BRANCHNAME"
echo "Print Branch name: $BRANCH_NAME"

export GITHUB_USER="$GITHUB_REPOSITORY_OWNER"

echo "End: Setting Prerequisites"

echo "Start: npm install and build."
      npm install
      npm run build --if-present
echo "End: npm install and build."

echo "Start: test"
      npm run test
echo "End: npm test."

echo "Start: Sonar Scan"
sh -c "/scripts/coverage_scan.sh"
echo "End: Sonar Scan"