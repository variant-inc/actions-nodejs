#!/bin/bash

set -e

npm install
REGISTRY=//pkgs.dev.azure.com/USXpress-Inc/CloudOps/_packaging/packages/npm
echo """
registry=https:$REGISTRY/registry/
always-auth=true
; begin auth token
$REGISTRY/registry/:username=USXpress-Inc
$REGISTRY/registry/:_password=${AZ_DEVOPS_BASE64_PAT}
$REGISTRY/registry/:email=devops@usxpress.com
$REGISTRY/:username=USXpress-Inc
$REGISTRY/:_password=${AZ_DEVOPS_BASE64_PAT}
$REGISTRY/:email=devops@usxpress.com
; end auth token
""" >> .npmrc
npm version "$IMAGE_VERSION" --no-git-tag-version
versions=$(npm view --json | jq '.versions[]')
found=false

for version in $versions; do
    if [[ $version = "$IMAGE_VERSION" ]]; then
        echo "$IMAGE_VERSION"
        found=true
    fi
done

if [ "$found" = true ]; then
    echo "$IMAGE_VERSION already exists" >> "$GITHUB_STEP_SUMMARY"
else
    npm publish
    echo "## npm Package Created" >> "$GITHUB_STEP_SUMMARY"
    echo "$IMAGE_VERSION" >> "$GITHUB_STEP_SUMMARY"
fi
