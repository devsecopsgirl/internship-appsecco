# Code Quality Analysis

## Objective

This section aims to perform a linting check on the source code of [angular-realworld-example-app](https://github.com/gothinkster/angular-realworld-example-app) and generate a report to provide a solution to the 2nd point of the [problem statement](https://cloud-native.netlify.app/problem-statement/) under Task 1.

## Code Linting

Linting is the automated checking of source code for programmatic and stylistic errors. This is done by using a linting tool. A lint tool is a basic static code analyzer. Linting is important to reduce errors and improve the overall quality of code. Using lint tools can help accelerate development and reduce costs by finding errors earlier. Linting tools are language-specific and thus, the tool that can be used depends on the application being tested. Nowadays, we have different linters, which provide many types of checks like syntax errors, code standards adherence, potential problems, security checks. 

### Linting tools for angular-realworld-example-app

[Angular-realworld-example-app](https://github.com/gothinkster/angular-realworld-example-app) is a JavaScript application and hence, I used jshint as the linter. I primarily chose jshint as it is available as a command-line utility and hence, I used this [documentation](https://blog.sideci.com/automatically-check-javascript-code-using-jshint-c9c1ca1ce2d1) for using jshint.

### Writing YAML file in GitHub Action

* I created a new file `linting-tool.yml` in the .github/workflows.

* The YAML file is this:

```
  
name: "linting-tool-scan"

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

    - name: Installing JSHint
      run: |
       sudo npm install -g jshint
          
    - name: Run scan with JSHint
      run: |
       sudo jshint --exclude="node_modules/" --reporter=unix .
```

* `node_modules` It excludes the `node_modules/` directory and also exclude any files which do not have a .js or .ejs extension.
* `--reporter` By using this option, I can change the output format. I selected `unix`, as it will become easier to count the rows and words. There are other options like `checkstyle`, the output will be in an `xml` format.