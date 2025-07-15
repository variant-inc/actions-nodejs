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
""" >>.npmrc

if [[ -n $(npm view --json | jq -r '.versions[] | select(.=="'"$IMAGE_VERSION"'")') ]]; then
	echo "$IMAGE_VERSION already exists" >>"$GITHUB_STEP_SUMMARY"
else
	npm version "$IMAGE_VERSION" --no-git-tag-version
	npm publish
	echo "## npm Package Created" >>"$GITHUB_STEP_SUMMARY"
	echo "$IMAGE_VERSION" >>"$GITHUB_STEP_SUMMARY"
fi
