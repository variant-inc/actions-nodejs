#!/bin/sh -l

set -e

cleanup() {
  set +ex
  docker image rm sonarscan
}

trap "cleanup" EXIT
eval "docker build --target $INPUT_SONAR_SCAN_IN_DOCKER_TARGET -t sonarscan env | cut -f1 -d= | sed 's/^/--build-arg /' ."
args="-e SONAR_TOKEN sonarscan -d testresults -o $SONAR_ORG -k $SONAR_PROJECT_KEY -r $GITHUB_SHA"
if [ -z "$PULL_REQUEST_KEY" ]; then
  docker run --rm "$args" -b "$BRANCH_NAME"
else
  docker run --rm "$args" -p "$PULL_REQUEST_KEY"
fi