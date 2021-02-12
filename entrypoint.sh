#!/bin/bash

echo "Start: Setting Prerequisites"
cd "$GITHUB_WORKSPACE"
echo "Current directory: $(pwd)"


export BRANCH_NAME="$GITVERSION_BRANCHNAME"
echo "Print Branch name: $BRANCH_NAME"

export GITHUB_USER="$GITHUB_REPOSITORY_OWNER"

echo "End: Setting Prerequisites"

echo "Start: npm install and build."
      npm install
      npm run build --if-present
echo "End: npm install and build."