# Software Bill of Materials

## Objective

This section aims to generate a Software Bill of Materials for [angular-realworld-example-app](https://github.com/gothinkster/angular-realworld-example-app) and generate a report to provide a solution to the 3rd point of the [problem statement](https://cloud-native.netlify.app/problem-statement/) under Task 1.

## Software Bill of Materials

A software bill of materials is a list of all the open source and third-party components present in a codebase. A software BOM also lists the licenses that govern those components, the versions of the components used in the codebase, and their patch status. With a software bill of materials, we can respond quickly to the security, license, and operational risks that come with open source use.

## CycloneDX

CycloneDX is a tool of lightweight software bill of materials (SBOM) specification designed for use in application security contexts and supply chain component analysis. Angular-realworld-example-app, like most other applications, is built with various dependencies. So I used CycloneDX to generate the SBOM for Angular-realworld-example-app.

CycloneDX is available to use a node.js package that can generate SBOMs but also comes in a variety of implementations that can be found here to serve projects which use different stacks such as Auditjs, Python, Maven, .NET, PHP, etc. 

## Generating SBOM through YAML file in GitHub Action

* I created a new file sbom.yml in the .github/workflows
* I used this plugin [CycloneDX Node.js Generate SBOM](https://github.com/marketplace/actions/cyclonedx-node-js-generate-sbom)
* I also stored the report in artifacts by using the action `actions/upload-artifact@v2`
* The YAML file is this for generating the SBOM is:
```
name: "sbom-scan"

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
       
    - name: Installing SBOM
      run: |
       sudo npm install -g @cyclonedx/bom
          
    - name: CycloneDX Node.js Generate SBOM
      uses: CycloneDX/gh-node-module-generatebom@v1.0.0

    - name: Archive production artifacts
      uses: actions/upload-artifact@v2
      with:
        name: sbom report
        path: |
          ./bom.xml
```
* The report which got generated is [here](https://github.com/devsecopsgirl/internship-appsecco/blob/internship-part2/Reports/bom.xml).


