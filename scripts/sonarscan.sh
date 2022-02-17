#!/bin/bash

set -e

SONAR_ORGANIZATION="$SONAR_ORG"

sonar_logout() {
  exit_code=$?
  echo "Exit code is $exit_code"
  if [ "$exit_code" -eq 0 ]; then
    echo -e "\e[1;32m ________________________________________________________________\e[0m"
    echo -e "\e[1;32m Quality Gate Passed.\e[0m"
    echo -e "\e[1;32m ________________________________________________________________\e[0m"
  elif [ "$exit_code" -gt 0 ]; then
    set -e
    echo -e "\e[1;31m ________________________________________________________________\e[0m"
    echo -e "\e[1;31m ________________________________________________________________\e[0m"
    echo ""
    echo ""
    echo -e "\e[1;31m Sonar Quality Gate failed in $SONAR_PROJECT_KEY.\e[0m"
    echo ""
    echo ""
    echo -e "\e[1;31m ________________________________________________________________\e[0m"
    echo -e "\e[1;31m ________________________________________________________________\e[0m"
    exit 1 
  fi
}

trap "sonar_logout" EXIT

if [ -n "$INPUT_SONAR_PROJECT_KEY" ]; then
  echo "Changing project key to $INPUT_SONAR_PROJECT_KEY"
  SONAR_PROJECT_KEY="$INPUT_SONAR_PROJECT_KEY"
fi

wait_flag="false"
if [ "$BRANCH_NAME" == "master" ] || [ "$BRANCH_NAME" == "main" ]; then
  wait_flag="true"
fi

sonar_args="-Dsonar.organization=$SONAR_ORGANIZATION \
            -Dsonar.projectKey=$SONAR_PROJECT_KEY \
            -Dsonar.projectBaseDir=$INPUT_SONAR_PROJECT_BASE_DIR \
            -Dsonar.host.url=https://sonarcloud.io \
            -Dsonar.login=$SONAR_TOKEN \
            -Dsonar.scm.disabled=true \
            -Dsonar.scm.revision=$GITHUB_SHA \
            -Dsonar.javascript.lcov.reportPaths=$INPUT_SONAR_PROJECT_BASE_DIR/coverage/lcov.info \
            -Dsonar.qualitygate.wait=$wait_flag"


if [ "$PULL_REQUEST_KEY" = null ]; then
  echo "Sonar run when pull request key is null."
  eval "sonar-scanner $sonar_args -Dsonar.branch.name=$BRANCH_NAME"

else
  echo "Sonar run when pull request key is not null."
  eval "sonar-scanner $sonar_args -Dsonar.pullrequest.key=$PULL_REQUEST_KEY"
fi
