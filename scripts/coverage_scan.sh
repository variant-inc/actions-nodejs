#!/bin/sh -l

set -euo

pull_number=$(jq --raw-output .pull_request.number "$GITHUB_EVENT_PATH")
export PULL_REQUEST_KEY=$pull_number

if [ "$INPUT_SONAR_SCAN_IN_DOCKER" = "true" ]; then
  /scripts/docker_sonarscan.sh
else
  echo "running lazy sonar tests."
  /scripts/sonarscan.sh
fi