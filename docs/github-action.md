# SAST through Github Action

## Objective

This section aims to perform SAST for `angular-realworld-example-app` and generate a report to provide a solution to the 1st point of the problem statement under Task 1.


## Github Action

GitHub Actions make it easy to automate all software workflows. Github Actions let us build, test, and deploy our code right from GitHub. We can also assign code reviews, manage branches, and triage issues the way we want with actions. GitHub Actions are designed to help in building robust and dynamic automation's.

Whether we want to build a container, deploy a web service, or automate welcoming a new user to our open-source project — there’s an automated action for that.

### Creating Workflow 

I followed this official link for [creating the first workflow](https://docs.github.com/en/free-pro-team@latest/actions/quickstart#next-steps).


1. On GitHub, I forked ``angular-realworld-example-app`` and I created a new file in the `.github/workflows`.

2. I made the following YAML contents into the `sast-scan.yml` file. For knowing the syntax of Github action I followed [this](https://docs.github.com/en/free-pro-team@latest/actions/reference/workflow-syntax-for-github-actions#jobs) official link.
```
name: "sast-scan"

on:
  push:
    branches: [master]

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
    
    - uses: actions/checkout@v2
      
    - name: install dependencies
      run: | 
       sudo apt install npm
       sudo npm install --package-lock
       npm audit fix
          first 
     
    - name: OWASP Dependency Check
      run: |
       wget https://github.com/jeremylong/DependencyCheck/releases/download/v6.0.2/dependency-check-6.0.2-release.zip
       unzip dependency-check-6.0.2-release.zip
  
    - name: Run scan with ODC
      run: |
        dependency-check/bin/dependency-check.sh --project "angular-realworld-example-app" --scan .
```

3. To run workflow, I scrolled to the bottom of the page and select Commit directly to the `main` branch. Then, to create a pull request, click `Propose new file`. Committing the workflow file in repository triggers the push event and runs workflow.

### Viewing workflow results

1. Under repository name, click `Actions`. 
2. In the left sidebar, click the `workflow` to see. 
3. From the list of workflow runs, click the name of the run to see. 
4. In the left sidebar, click the Lint code base job. 
5. Expand the Run `sast-scan` step to view the results. 
