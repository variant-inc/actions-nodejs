#!/bin/bash

set -e

AWS_ACCOUNT_ID=$(aws sts get-caller-identity --output text --query Account)
ECR_REGISTRY="$AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com"
IMAGE="$ECR_REGISTRY/$INPUT_ECR_REPOSITORY:$IMAGE_VERSION"

cleanup() {
  set +e
  rm -rf publish
  docker logout "$ECR_REGISTRY"
  docker image rm "$IMAGE"
}

trap "cleanup" EXIT

echo "Connecting to AWS account."

docker login -u AWS -p "$(aws ecr get-login-password)" "$ECR_REGISTRY"

DOCKERFILE_PATH="$INPUT_DOCKERFILE_DIR_PATH"

mkdir -p /publish

if [ -z "$DOCKERFILE_PATH" ]; then
  echo "Running lazy publish image"
  DOCKERFILE_PATH=/docker/
  dotnet publish -c Release -o publish
fi

eval "docker build $(echo $(env | cut -f1 -d= | sed 's/^/--build-arg /')) -t $IMAGE $DOCKERFILE_PATH"
docker push "$IMAGE"