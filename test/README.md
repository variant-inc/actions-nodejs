# Actions Test Nodejs

Action for CI workflow for nodejs applications

<!-- action-docs-description -->
## Description

Github Action to Build & Test Nodejs

RequiredEnv:
  AZ_DEVOP_PAT
  GITHUB_TOKEN
  SONAR_TOKEN
<!-- action-docs-description -->

<!-- action-docs-inputs -->
## Inputs

| parameter | description | required | default |
| --- | --- | --- | --- |
| nodejs-version | The nodejs-version input is optional. The default version of Nodejs in PATH varies between runners and can be changed unexpectedly so we recommend always setting Nodejs version explicitly using the nodejs-version input.  | `false` |  |
| npm_package_publish | Enabled npm Package Publish to AzureDevops. | `false` | false |
| npm_test_script_name | npm test script name | `false` | test |
| sonar_wait_flag | Says if Sonar has to wait for analysis | `false` |  |
<!-- action-docs-inputs -->

<!-- action-docs-outputs -->

<!-- action-docs-outputs -->

<!-- action-docs-runs -->
## Runs

This action is a `composite` action.
<!-- action-docs-runs -->
