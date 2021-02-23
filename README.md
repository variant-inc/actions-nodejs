# lazy-action-nodejs

Lazy action to setup CI workflow for nodejs applications

- [lazy-action-nodejs](#lazy-action-nodejs)
  - [Prerequisites](#prerequisites)
    - [1. Setup github action workflow](#1-setup-github-action-workflow)
    - [2. Add lazy action setup](#2-add-lazy-action-setup)
    - [3. Add the nodejs action](#3-add-the-nodejs-action)
    - [4. Add octopus action](#4-add-octopus-action)
  - [Using Lazy NodeJS Action](#using-lazy-nodejs-action)
    - [Adding lazy nodejs action to workflow](#adding-lazy-nodejs-action-to-workflow)
    - [Input Parameters](#input-parameters)

  - [Using Lazy NodeJS Action](#using-lazy-nodejs-action)
    - [Adding lazy nodejs action to workflow](#adding-lazy-nodejs-action-to-workflow)
  - [parameters](#parameters)
    - [Input Parameters](#input-parameters)

## Prerequisites

### 1. Setup github action workflow

1. On GitHub, navigate to the main page of the repository.
2. Under your repository name, click Actions.
3. Find the template that matches the language and tooling you want to use, then click Set up this workflow. Either start with blank workflow or choose any integration workflows.

### 2. Add lazy action setup

1. Add a code checkout step this will be needed to add code to the github workspace.

```yaml
    - uses: actions/checkout@v2
      with:
        fetch-depth: 0
```

1. This is to add some global environment variables that are used as part of the lazy dotnet action. It will output `image_version`.

```yaml
    - name: Setup
      uses: variant-inc/lazy-action-setup@v0.1.0
```

Refer [lazy action setup](https://github.com/variant-inc/lazy-action-setup/blob/master/README.md) for documentation.

### 3. Add the nodejs action

1. This step is to invoke lazy nodejs action with release version by passing environment variables and input parameters. Input parameters section provides more insight of optional and required parameters.

```yaml

    - name: Lazy action steps
      id: lazy-action
      uses: variant-inc/lazy-action-nodejs@v0.1.0
      env:
        AWS_DEFAULT_REGION: us-east-1
        GITHUB_USER: variant-inc
      with:
        dockerfile_dir_path: '.'
        ecr_repository: naveen-demo-app/demo-repo
        github_token: ${{ secrets.GITHUB_TOKEN }}

```

### 4. Add octopus action

1. Adding octopus action will add ability to setup continuos delivery to octopus. This action can be invoked by action name and release version.

```yaml

    - name: Lazy Action Octopus
      uses: variant-inc/lazy-action-octopus@v0.1.0
      with:
        default_branch: ${{ env.MASTER_BRANCH }}
        deploy_scripts_path: deploy
        project_name: ${{ env.PROJECT_NAME }}
        version: ${{ steps.lazy-setup.outputs.image-version }}
        space_name: ${{ env.OCTOPUS_SPACE_NAME }}

```

Refer [octopus action](https://github.com/variant-inc/lazy-action-octopus/blob/master/README.md) for documentation.

## Using Lazy NodeJS Action

You can set up continuous integration for your project using a lazy workflow action.
After you set up CI, you can customize the workflow to meet your needs. By passing the right input parameters with the lazy nodejs action.

### Adding lazy nodejs action to workflow

Sample snippet to add lazy action to your workflow code.
See [action.yml](action.yml) for the full documentation for this action's inputs and outputs.

```yaml
jobs:
  build_test_scan:
    runs-on: eks
    name: CI Pipeline
    steps:
    - uses: actions/checkout@v2
      with:
        fetch-depth: 0

    - name: Setup
      uses: variant-inc/lazy-action-setup@v1

    - name: Lazy action steps
      id: lazy-action
      uses: variant-inc/lazy-action-nodejs@v0.1.0
      env:
        AWS_DEFAULT_REGION: us-east-1
        GITHUB_USER: variant-inc
        AWS_REGION: us-east-1
      with:
        dockerfile_dir_path: '.'
        ecr_repository: naveen-demo-app/demo-repo
        github_token: ${{ secrets.GITHUB_TOKEN }}

    - name: Lazy Action Octopus
      uses: variant-inc/lazy-action-octopus@v1
      with:
        default_branch: ${{ env.MASTER_BRANCH }}
        deploy_scripts_path: deploy
        project_name: ${{ env.PROJECT_NAME }}
        version: ${{ steps.lazy-setup.outputs.image-version }}
        space_name: ${{ env.OCTOPUS_SPACE_NAME }}

```

### Input Parameters

| Parameter                     | Default         | Description                                                                                                                  | Required |
| ----------------------------- | --------------- | ---------------------------------------------------------------------------------------------------------------------------- | -------- |
| `dockerfile_dir_path`         | `.`             | Directory path to the dockerfile                                                                                             | true     |
| `npm_test_script_name`        | `test`          | npm test script name                                                                                                     | true     |
| `ecr_repository`              |                 | ECR Repository name                                                                                                          | true     |
| `github_token`                |                 | Github Token                                                                                                                 | true     |
| `container_push_enabled`      |                 | Enable build and push container image                                                                                        | true     |
