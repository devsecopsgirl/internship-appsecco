##  

1. apt-get fails: The method driver /usr/lib/apt/methods/https could not be found

apt-get install apt-transport-https ca-certificates

link : https://unix.stackexchange.com/questions/263801/apt-get-fails-the-method-driver-usr-lib-apt-methods-https-could-not-be-found

2. FOR INSTALLING ANGULAR CLI
https://angular.io/cli

3. for installing yarn official site
https://classic.yarnpkg.com/en/docs/install#debian-stable


____________________________________________________________________________________________________

[AWS Fargate: Running a serverless Node.js app on AWS ECS](https://levelup.gitconnected.com/aws-fargate-running-a-serverless-node-js-app-on-aws-ecs-c5d8dea0a85a).

error: tag invalid: The image tag 'latest' already exists in the 'angular-app-repo' repository and cannot be overwritten because the repository is immutable.
Error: Process completed with exit code 1.
```
aws ecs update-service --cluster <cluster name> --service <service name> --force-new-deployment
```
## VPC

A VPC is an isolated portion of the AWS cloud populated by AWS objects, such as Amazon EC2 instances. Use the Classless Inter-Domain Routing(CIDR) block format to specify your VPC's contiguous IP address range, for example, 10.0.0.0/16 and we cannot create VPC larger than /16

- name: Pushing image to AWS
      run: |
        aws ecr get-login-password --region us-east-2 | docker login --username AWS --password-stdin 394310921697.dkr.ecr.us-east-2.amazonaws.com     
        docker tag angular5:latest 394310921697.dkr.ecr.us-east-2.amazonaws.com/angular-app-repo:latest
        docker push 394310921697.dkr.ecr.us-east-2.amazonaws.com/angular-app-repo:latest

aws ecr get-login-password --region us-east-2 | docker login --username AWS --password-stdin 394310921697.dkr.ecr.us-east-2.amazonaws.com 

docker tag <image name:tag> 394310921697.dkr.ecr.us-east-2.amazonaws.com/angular-app-repo:latest

docker push 394310921697.dkr.ecr.us-east-2.amazonaws.com/angular-app-repo:latest


_________________________________________

Github action ZAP scan
1. env: |
     INTERNET_PROTOCOL: "curl -4 ifconfig.co"

ERROR: The workflow is not valid. .github/workflows/image.yml (Line: 55, Col: 12): Unexpected value 'INTERNET_PROTOCOL:`curl -4 ifconfig.co`
',.github/workflows/image.yml (Line: 57, Col: 12): Unrecognized named-value: 'INTERNET_PROTOCOL'. Located at position 1 within expression: INTERNET_PROTOCOL

2. env: |
     INTERNET_PROTOCOL: `curl -4 ifconfig.co`

3. echo ::set-env name=IP::$(curl -4 ifconfig.co)

ERROR: The workflow is not valid. .github/workflows/image.yml (Line: 55, Col: 12): Unrecognized named-value: 'INTERNETPROTOCOL'. Located at position 1 within expression: INTERNETPROTOCOL

4. 
ERROR: The workflow is not valid. .github/workflows/image.yml (Line: 54, Col: 12): Unrecognized named-value: 'export'. Located at position 1 within expression: export URL

________________

5. VPC security group updation commands used:

aws ec2 authorize-security-group-ingress --group-id sg-12345678 --ip-permissions '[{"IpProtocol": "tcp", "FromPort": 22, "ToPort": 22, "IpRanges": [{"CidrIp": "${{env.export_URL}}/32"}]}]

refer: https://github.com/aws/aws-cli/issues/3463

* aws ec2 authorize-security-group-ingress --group-id sg-aaaa1111 --protocol tcp --port 80 --source-group sg-bbbb2222

refer: https://docs.amazonaws.cn/en_us/vpc/latest/peering/vpc-peering-security-groups.html

* vpc security-group update-security-group-rule-descriptions-ingress [-h]
                                                                   [-f {adaptive_table,json,shell,table,value,yaml}]
                                                                   [-c COLUMN]
                                                                   [--max-width <integer>]
                                                                   [--noindent]
                                                                   [--prefix PREFIX]
                                                                   [-m [NAME=VALUE [NAME=VALUE ...]]]
                                                                   [--ip-permissions IP_PERMISSIONS]
                                                                   group_id
refer: https://www.stratoscale.com/knowledge/tools-and-sdks/stratoscale-cli-tools/symphony-cli-reference/vpc-commands/vpc-security-group-update-security-group-rule-descriptions-ingress/

* aws ec2 describe-vpcs --vpc-ids vpc-dfbc4ab4 --group-id ${{ secrets.GROUP_ID }} --protocol tcp --port 4200 --source ${{env.export_URL}}/32 

**hint**

* authorize-security-group-ingress --group-id ${{ secrets.GROUP_ID }} --protocol tcp --port 4200 --cidr ${{env.export_URL}}/32

error: authorize-security-group-ingress command not found

* aws ec2 authorize-security-group-ingress --group-id ${{ secrets.GROUP_ID }} --protocol tcp --port 4200 --cidr ${{env.export_URL}}/32

An error occurred (InvalidParameterValue) when calling the AuthorizeSecurityGroupIngress operation: CIDR block /32 is malformed
Error: Process completed with exit code 254.

* aws ec2 authorize-security-group-ingress --group-id ${{ secrets.GROUP_ID }} --protocol tcp --port 4200 --cidr ${env.export_URL}/32
/home/runner/work/_temp/e7710386-d2e8-405b-9348-254821bd2300.sh: line 3: ${env.export_URL}/32: bad substitution

* aws ec2 authorize-security-group-ingress --group-id ${{ secrets.GROUP_ID }} --protocol tcp --port 4200 --cidr ${env.export_URL}\32
/home/runner/work/_temp/e7710386-d2e8-405b-9348-254821bd2300.sh: line 3: ${env.export_URL}\32: bad substitution

1. So I have got a list of IPs from the meta link of github - https://api.github.com/meta but how to find which one to use. and also I downloaded the Azure IP Ranges (https://www.microsoft.com/en-us/download/details.aspx?id=56519). So do I have to find the GitHub link from here or somewhere else.

2. Is there need to allow the port 4200 by any means.

3. Why we are not allowing all IP ranges.

4. And I was searching for downloading the reports of the scans but I got the results that artifacts can be downloaded the one uploaded. https://docs.github.com/en/free-pro-team@latest/actions/guides/storing-workflow-data-as-artifacts

