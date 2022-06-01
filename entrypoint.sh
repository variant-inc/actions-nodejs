#!/bin/bash

function finish {
  set -x
  sudo chown -R 1000:1000 "$GITHUB_WORKSPACE"/*
  sudo git clean -fdx
  set +x
}
trap finish EXIT

setfacl -d -Rm u:1000:rwx "$GITHUB_WORKSPACE"

set -eo

echo "Start: Setting Prerequisites"
cd "$GITHUB_WORKSPACE"
echo "Current directory: $(pwd)"

echo "Cloning into actions-collection..."
git clone -b v1 https://github.com/variant-inc/actions-collection.git ./actions-collection

echo "---Start: Pretest script"
chmod +x ./actions-collection/scripts/pre_test.sh
./actions-collection/scripts/pre_test.sh

export AWS_WEB_IDENTITY_TOKEN_FILE="/token"
echo "$AWS_WEB_IDENTITY_TOKEN" >> "$AWS_WEB_IDENTITY_TOKEN_FILE"

export AWS_DEFAULT_REGION="${AWS_DEFAULT_REGION:=us-east-1}"

export BRANCH_NAME="$GITVERSION_BRANCHNAME"
echo "Print Branch name: $BRANCH_NAME"

export GITHUB_USER="$GITHUB_REPOSITORY_OWNER"

echo "End: Setting Prerequisites"

echo "Start: yarn install"
yarn install
sudo chown -R 1000:1000 "$GITHUB_WORKSPACE"/*
echo "End: yarn install"

echo "Start: Enable sonar"
pwsh ./actions-collection/scripts/enable_sonar.ps1
echo "End: Enable sonar"

echo "Start: yarn test"
yarn run "$INPUT_NPM_TEST_SCRIPT_NAME"
echo "End: yarn test"

echo "Start: Check sonar run"
skip_sonar_run=$(pwsh ./actions-collection/scripts/skip_sonar_run.ps1)
echo "Skip sonar run: $skip_sonar_run"
echo "End: Check sonar run"

if [ "$skip_sonar_run" != 'True' ]; then
  echo "Start: Sonar Scan"
  sh -c "/scripts/coverage_scan.sh"
  echo "End: Sonar Scan"
else
  echo "End: Skipping sonar run"
fi

echo "Container Push: $INPUT_CONTAINER_PUSH_ENABLED"
if [ "$INPUT_CONTAINER_PUSH_ENABLED" = 'true' ]; then
  echo "Start: Checking ECR Repo"
  ./actions-collection/scripts/ecr_create.sh "$INPUT_ECR_REPOSITORY"
  echo "End: Checking ECR Repo"
  echo "Start: Publish Image to ECR"
  ./actions-collection/scripts/publish.sh
  echo "End: Publish Image to ECR"
fi

echo "Start: Clean up"
sudo git clean -fdx
echo "End: Clean up"