#!/bin/bash

set -e

AWS_ACCOUNT_ID=$(aws sts get-caller-identity --output text --query Account)
ECR_REGISTRY="$AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com"
IMAGE="$ECR_REGISTRY/$INPUT_ECR_REPOSITORY:$IMAGE_VERSION"

credentials=$(aws sts assume-role --role-arn arn:aws:iam::108141096600:role/ops-github-runner --role-session-name ops-s3)

export AWS_PAGER=""
aws configure set aws_access_key_id "$(echo "$credentials" | jq -r '.Credentials.AccessKeyId')" --profile ops
aws configure set aws_secret_access_key "$(echo "$credentials" | jq -r '.Credentials.SecretAccessKey')" --profile ops
aws configure set aws_session_token "$(echo "$credentials" | jq -r '.Credentials.SessionToken')" --profile ops

S3_BUCKET_NAME=trivy-ops
PATH_TO_FOLDER=$GITHUB_REPOSITORY
echo "Print repo name: $GITHUB_REPOSITORY"
echo "Download root trivy file from s3"
eval "aws --profile ops s3 cp s3://${S3_BUCKET_NAME}/.trivyignore ."

mkdir trivy
echo "Checking for repo trivy file in s3"

exit_status=0
cd trivy && aws --profile ops s3 cp s3://"${S3_BUCKET_NAME}"/"${PATH_TO_FOLDER}"/.trivyignore . || exit_status=$?
echo "$exit_status"
if [ "$exit_status" -ne 0 ]; then
    echo "No repo files found, exit status: $exit_status"
else
    echo "Repo file found"
    cd "$GITHUB_WORKSPACE" && cat trivy/.trivyignore >>.trivyignore
fi

echo "Printing trivy ignore file"
cd "$GITHUB_WORKSPACE" && cat .trivyignore

echo "Checking for low level vulnerablities"
eval "trivy --exit-code 0 --severity=HIGH,MEDIUM,LOW,UNKNOWN $IMAGE"

echo "Checking for critical risk vulnerablities"
eval "trivy --exit-code 1 --severity CRITICAL $IMAGE"
