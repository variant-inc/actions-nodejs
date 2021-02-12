#!/bin/sh -l

set -e

export OUTPUTDIR="coverage"
mkdir -p "$OUTPUTDIR"

SONAR_ORGANIZATION="$SONAR_ORG"

sonar_logout() {
  set +eu
  dotnet-sonarscanner end /d:sonar.login="$SONAR_TOKEN"
}

sonar_args="/o:$SONAR_ORGANIZATION \
    /k:$SONAR_PROJECT_KEY \
    /d:sonar.host.url=https://sonarcloud.io \
    /d:sonar.login=$SONAR_TOKEN \
    /d:sonar.cs.opencover.reportsPaths=**/$OUTPUTDIR/**/coverage.opencover.xml \
    /d:sonar.exclusions=**/*Migrations/**/* \
    /d:sonar.scm.disabled=true \
    /d:sonar.scm.revision=$GITHUB_SHA"

if [ "$PULL_REQUEST_KEY" = null ]; then
  eval "dotnet-sonarscanner $sonar_args /d:sonar.branch.name=$BRANCH_NAME"
else
  eval "dotnet-sonarscanner $sonar_args /d:sonar.pullrequest.key=$PULL_REQUEST_KEY"
fi

trap "sonar_logout" EXIT
