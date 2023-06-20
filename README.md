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

```yaml
    - name: Actions Nodejs
      uses: variant-inc/actions-nodejs@v2
      with:
        ecr_repository: 'demo/example'
        nodejs-version: 18
```
<!-- action-docs-description -->

<!-- action-docs-inputs -->
## Inputs

| parameter | description | required | default |
| --- | --- | --- | --- |
| aws_region | Region where the image will be created. | `false` | us-east-2 |
| dockerfile_dir_path | Directory path to the dockerfile | `false` | . |
| ecr_repository | Ecr repository name | `false` |  |
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
