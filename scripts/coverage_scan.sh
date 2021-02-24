#!/bin/bash

set -euo

pull_number=$(jq --raw-output .pull_request.number "$GITHUB_EVENT_PATH")
export PULL_REQUEST_KEY=$pull_number

echo "running lazy sonar tests."
/scripts/sonarscan.sh
