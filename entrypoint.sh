#!/bin/bash

function finish {
  set -x
  sudo chown -R 1000:1000 "$GITHUB_WORKSPACE"/*
  sudo git clean -fdx
  set +x
}
trap finish EXIT

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

echo "Start: yarn install"
yarn install
echo "End: yarn install"

echo "Start: yarn test"
yarn run "$INPUT_NPM_TEST_SCRIPT_NAME"
echo "End: yarn test"

echo "Start: Sonar Scan"
sh -c "/scripts/coverage_scan.sh"
echo "End: Sonar Scan"

echo "Container Push: $INPUT_CONTAINER_PUSH_ENABLED"
if [ "$INPUT_CONTAINER_PUSH_ENABLED" = 'true' ]; then
  echo "Start: Publish Image to ECR"
  /scripts/publish.sh
  echo "End: Publish Image to ECR"
fi

echo "Start: Clean up"
sudo git clean -fdx
echo "End: Clean up"