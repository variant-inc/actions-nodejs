#!/bin/bash

set -e

SONAR_ORGANIZATION="$SONAR_ORG"

if [ -n "$INPUT_SONAR_PROJECT_KEY" ]; then
  echo "Changing project key to $INPUT_SONAR_PROJECT_KEY"
  SONAR_PROJECT_KEY="$INPUT_SONAR_PROJECT_KEY"
fi

sonar_args="-Dsonar.organization=$SONAR_ORGANIZATION \
            -Dsonar.projectKey=$SONAR_PROJECT_KEY \
            -Dsonar.projectBaseDir=$INPUT_SONAR_PROJECT_BASE_DIR \
            -Dsonar.host.url=https://sonarcloud.io \
            -Dsonar.login=$SONAR_TOKEN \
            -Dsonar.scm.disabled=true \
            -Dsonar.scm.revision=$GITHUB_SHA \
            -Dsonar.javascript.lcov.reportPaths=$INPUT_SONAR_PROJECT_BASE_DIR/coverage/lcov.info"

if [ "$PULL_REQUEST_KEY" = null ]; then
  echo "Sonar run when pull request key is null."
  eval "sonar-scanner $sonar_args -Dsonar.branch.name=$BRANCH_NAME"

else
  echo "Sonar run when pull request key is not null."
  eval "sonar-scanner $sonar_args -Dsonar.pullrequest.key=$PULL_REQUEST_KEY"
fi

