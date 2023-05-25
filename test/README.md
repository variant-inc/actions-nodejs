# Actions Test Nodejs

Action for CI workflow for nodejs applications

<!-- action-docs-description -->
## Description

Github Action to Build & Test Nodejs

RequiredEnv:
  GITHUB_TOKEN
  SONAR_TOKEN
<!-- action-docs-description -->

<!-- action-docs-inputs -->
## Inputs

| parameter | description | required | default |
| --- | --- | --- | --- |
| npm_test_script_name | npm test script name | `false` | test |
| nodejs-version | The nodejs-version input is optional. The default version of Nodejs in PATH varies between runners and can be changed unexpectedly so we recommend always setting Nodejs version explicitly using the nodejs-version input.  | `false` |  |
<!-- action-docs-inputs -->

<!-- action-docs-outputs -->

<!-- action-docs-outputs -->

<!-- action-docs-runs -->
## Runs

This action is a `composite` action.
<!-- action-docs-runs -->
