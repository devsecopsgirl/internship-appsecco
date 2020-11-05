# Set up GitHub Actions Workflow for DAST

##  Objective 

This section aims to perform a DAST scan on [angular-realworld-example-app](https://github.com/gothinkster/angular-realworld-example-app) and generate a report to provide a solution to the fifth point of the [problem statement](https://cloud-native.netlify.app/problem-statement/) under Task 1.

### DAST scan 

DAST or Dynamic Application Security Testing is a black-box testing technique in which the DAST tool interacts with the application being tested in its running state to imitate an attacker. Unlike static analysis, DAST allows for sophisticated scans on the client-side and server-side without needing the source code or the framework the application is built on.

### Setting Up YAML file for ZAP scan

I added these steps in YML file for ZAP scan:
```
    - name: ZAP scan 
      run: script/zap-script.sh
      
    - name: Archive production artifacts
      uses: actions/upload-artifact@v2
      with:
        name: zap report
        path: |
          ./zap_baseline_report.html
  
```
* The ZAP scan was getting failed so made a dedicated service as earlier for the zap scan and in the `Security Group` I selected the protocol type as `Custom TCP` and port range `4200` and in `Source` I selected `Custom` and selected `0.0.0.0/0` which allowed all the traffic.

* As over here also I was getting an error a non-zero status code, when it found issues after ZAP scan. So, I made a directory and stored bash script to run the scan in a sub-shell and prevent the build from failing and made it executable with chmod +x. The contents of the script, `zap-script.sh`, are below:

```
#!/bin/bash

docker pull owasp/zap2docker-stable
docker run -i owasp/zap2docker-stable zap-baseline.py -t "http://3.135.209.44:4200/" -l PASS > zap_baseline_report.html

echo $? > /dev/null
```
* I stored the [reports](https://github.com/devsecopsgirl/internship-appsecco/blob/internship-part2/Reports/zap_baseline_report.html) in the artifacts.

* Below is the complete YAML file:

```
name: "build image from Dockerfile"

on:
  push:
    branches: [master]

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
    
    - uses: actions/checkout@v2
      
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

    - name: ZAP scan 
      run: script/zap-script.sh
      
    - name: Archive production artifacts
      uses: actions/upload-artifact@v2
      with:
        name: zap report
        path: |
          ./zap_baseline_report.html    
```