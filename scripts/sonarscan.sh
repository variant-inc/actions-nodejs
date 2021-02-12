#!/bin/sh -l

set -e

export OUTPUTDIR="coverage"
mkdir -p "$OUTPUTDIR"

SONAR_ORGANIZATION="$SONAR_ORG"

sonar_args="-Dsonar.organization=$SONAR_ORGANIZATION \
    -Dsonar.projectKey=$SONAR_PROJECT_KEY \
    -Dsonar.host.url="https://sonarcloud.io" \
    -Dsonar.login=$SONAR_TOKEN \
    -Dsonar.scm.disabled=true \
    -Dsonar.scm.revision=$GITHUB_SHA"

if [ "$PULL_REQUEST_KEY" = null ]; then
  eval "sonar-scanner $sonar_args -Dsonar.branch.name=$BRANCH_NAME"
else
  eval "sonar-scanner $sonar_args -Dsonar.pullrequest.key=$PULL_REQUEST_KEY"
fi

