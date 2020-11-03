
# Set up GitHub Actions Workflow for Deployment

## Objective

This section aims to generate a Software Bill of Materials for [angular-realworld-example-app](https://github.com/gothinkster/angular-realworld-example-app) and generate a report to provide a solution to the 5rd point of the [problem statement](https://cloud-native.netlify.app/problem-statement/) under Task 1.

## Running GitHub Actions Sequentially

I set up the sequential workflows by using a `repository_dispatch` action in the following four steps and followed the documentation(https://stevenmortimer.com/running-github-actions-sequentially/) :

* Step1: Creating a Personal Access Token (PAT)

    I followed the GitHub’s instructions [here](https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token) for creating PAT and in `Select scopes` I checked `repo` as the repository is a private repository and if it is a public repo `public_repo` option is checked.

* Step 2 - Adding the PAT as an actions secret in the repository

    In the second step I added the token to secrets and named it as `REPO_TRIGGER_PAT`.

* Step 3 - Adding the `repository_dispatch` event to Workflow 1 that is workflow I made for ZAP scan

    `Workflow 1` is the workflow, and the jobs contained within it, is the one which I want to exacute first. `Workflow 2` is the workflow I want to execute after `WOrkflow 1`. Given below is the last step of my `Workflow 1`:

```

    - name: Trigger next workflow
      if: success()
      uses: peter-evans/repository-dispatch@v1
      with:
        token: ${{ secrets.REPO_TRIGGER_PAT }}
        repository: ${{ github.repository }}
        event-type: trigger-deployment-workflow
        client-payload: '{"ref": "${{ github.ref }}", "sha": "${{ github.sha }}"}'
```
In this `if: success()` means only if all the prior steps in the `Workflow 1` are successful, then only run the steps that triggers `Workflow 2`.

```
client-payload: '{"ref": "${{ github.ref }}", "sha": "${{ github.sha }}"}'
```
The above command is used to pass the data from `Workflow 1` to `Workflow 2`. It tells `Workflow2` the branch and commit hash to checkout and use so that `Workflows 1` and `Workflow 2` are using the same exact code. 

* Step 4 - Adding the repository_dispatch event as trigger in Workflow 2 YAML

Firstly, in `Workflow 2` I added `event name` as the `types` of repository dispatch that should trigger `Workflow 2`. This name matches exactly as the one specified in the `event-type` and in the `types` also same name is used.
```
name: "deployment workflow"

on:
  repository_dispatch:
    types: [trigger-deployment-workflow]
```
Second, I used the client payload data from the event to checkout the same code. I modified the checkout step, the first step in job.
```
    steps:
    
    - uses: actions/checkout@v2
      with:
        ref: ${{ github.event.client_payload.sha }}
```
After this we can add all other steps in `Workflow 2` for deployment of application.

## YAML file for deployment: 

The YAML file for deployment of application is as follows:

```
name: "deployment workflow"

on:
  repository_dispatch:
    types: [trigger-deployment-workflow]

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
    
    - uses: actions/checkout@v2
      with:
        ref: ${{ github.event.client_payload.sha }}
    
    - name: Install docker
      run: |
        sudo apt update
        sudo apt install apt-transport-https ca-certificates curl software-properties-common
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
        sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable" && sudo apt update
        apt-cache policy docker-ce
        sudo apt install docker-ce
        
    - name: Build Docker image
      run: |
        docker build -t angular5 .
    
    - name: Installing AWS CLI
      run: |
        curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
        unzip awscliv2.zip
        sudo ./aws/install
        
    - name: Configure AWS Credentials
      uses: aws-actions/configure-aws-credentials@v1
      with:
        aws-access-key-id: ${{ secrets.DEMO_ID }}
        aws-secret-access-key: ${{ secrets.DEMO_K }}
        aws-region: us-east-2
        
    - name: Pushing image to AWS
      run: |
        aws ecr get-login-password --region us-east-2 | docker login --username AWS --password-stdin ${{ secrets.AWS_LOG }}.dkr.ecr.us-east-2.amazonaws.com  
        docker tag angular5:latest ${{ secrets.AWS_LOG }}.dkr.ecr.us-east-2.amazonaws.com/angular-app-repo:latest        
        docker push ${{ secrets.AWS_LOG }}.dkr.ecr.us-east-2.amazonaws.com/angular-app-repo:latest
        
    - name: redeploy the latest image
      run: |
        aws ecs update-service --cluster angular-app --service angular-service --force-new-deployment
```
 