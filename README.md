# Actions Nodejs

Action for CI workflow for nodejs applications

<!-- action-docs-description -->
## Description

Github Action to perform build, test , scan and generate Image for Python

## Permissions

Add the following permissions to the job

```yaml
permissions:
  id-token: write
  contents: read
```

## Usage

```yaml
    - name: Actions Nodejs
      uses: variant-inc/actions-nodejs@v2
      with:
        ecr_repository: 'demo/example'
        nodejs-version: v20.1.0
```
<!-- action-docs-description -->

<!-- action-docs-inputs -->
## Inputs

| parameter | description | required | default |
| --- | --- | --- | --- |
| dockerfile_dir_path | Directory path to the dockerfile | `false` | . |
| npm_test_script_name | npm test script name | `false` | test |
| container_push_enabled | Enable Build and Push Container Image | `false` | true |
| ecr_repository | Ecr repository name | `true` |  |
| aws_region | Region where the image will be created.  | `false` | us-east-2 |
| nodejs-version | The nodejs-version input is optional. If not supplied, the action will try to resolve the version from the default `.nodejs-version` file. If the `.nodejs-version` file doesn't exist Nodejs version from the PATH will be used. The default version of Nodejs in PATH varies between runners and can be changed unexpectedly so we recommend always setting Nodejs version explicitly using the nodejs-version or nodejs-version-file inputs.  | `false` |  |
<!-- action-docs-inputs -->

<!-- action-docs-outputs -->

<!-- action-docs-outputs -->

<!-- action-docs-runs -->
## Runs

This action is a `composite` action.
<!-- action-docs-runs -->
