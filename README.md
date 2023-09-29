# Actions Nodejs

Action for CI workflow for nodejs applications

<!-- action-docs-description -->
## Description

Github Action to perform build, test , scan and generate Image for Nodejs

## Permissions

Add the following permissions to the job

```yaml
permissions:
  id-token: write
  contents: write
```

## Usage

### For DX Deployment & Container Push

```yaml
    - name: Actions Nodejs
      uses: variant-inc/actions-nodejs@v2
      with:
        ecr_repository: 'demo/example'
        nodejs-version: 18
        npm_test_script_name: test:ci
```

### For Package Create & Publish

```yaml
    - name: Actions Nodejs
      uses: variant-inc/actions-nodejs@v2
      with:
        npm_package_publish: 'true'
        nodejs-version: 18
        npm_test_script_name: test:ci
```

## Using a Package from Azure DevOps

To use a package from Azure DevOps that was published by this action,
create .npmrc with the following information and add it to the root directory
of your repository.

```yaml
registry=https://pkgs.dev.azure.com/USXpress-Inc/CloudOps/_packaging/packages/npm/registry/
always-auth=true
; begin auth token
//pkgs.dev.azure.com/USXpress-Inc/CloudOps/_packaging/packages/npm/registry/:username=USXpress-Inc
//pkgs.dev.azure.com/USXpress-Inc/CloudOps/_packaging/packages/npm/registry/:_password=${AZ_DEVOPS_BASE64_PAT}
//pkgs.dev.azure.com/USXpress-Inc/CloudOps/_packaging/packages/npm/registry/:email=devops@usxpress.com
//pkgs.dev.azure.com/USXpress-Inc/CloudOps/_packaging/packages/npm/:username=USXpress-Inc
//pkgs.dev.azure.com/USXpress-Inc/CloudOps/_packaging/packages/npm/:_password=${AZ_DEVOPS_BASE64_PAT}
//pkgs.dev.azure.com/USXpress-Inc/CloudOps/_packaging/packages/npm/:email=devops@usxpress.com
; end auth token
```
<!-- action-docs-description -->

<!-- action-docs-inputs -->
## Inputs

| parameter | description | required | default |
| --- | --- | --- | --- |
| cloud_region | Region where the image will be created. | `false` | us-east-2 |
| dockerfile_dir_path | Directory path to the dockerfile | `false` | . |
| ecr_repository | ECR repository name. This is needed when container build & push is needed.  | `false` |  |
| nodejs-version | The nodejs-version input is optional. The default version of Nodejs in PATH varies between runners and can be changed unexpectedly so we recommend always setting Nodejs version explicitly using the nodejs-version input.  | `false` |  |
| npm_package_publish | Enabled npm Package Publish to AzureDevops. | `false` | false |
| npm_test_script_name | npm test script name | `false` | test |
<!-- action-docs-inputs -->

<!-- action-docs-outputs -->

<!-- action-docs-outputs -->

<!-- action-docs-runs -->
## Runs

This action is a `composite` action.
<!-- action-docs-runs -->
