# Set up GitHub Actions Workflow for DAST

##  Objective 

This section aims to perform a DAST scan on [angular-realworld-example-app](https://github.com/gothinkster/angular-realworld-example-app) and generate a report to provide a solution to the 4th point of the [problem statement](https://cloud-native.netlify.app/problem-statement/) under Task 1.

## Setting Up the application manually

Firstly, I installed the application manually and ran it on my browser to know how it works. So I cloned the application in my terminal
```
git clone https://github.com/gothinkster/angular-realworld-example-app.git
```
* Install npm

```
sudo apt update
sudo apt install nodejs
sudo apt install npm
nodejs -v
```

* Install Yarn (https://classic.yarnpkg.com/en/docs/install/#debian-stable)
```
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update && sudo apt install yarn
export PATH="$PATH:`yarn global bin`"
yarn install
yarn -version
```
* Install Angular CLI(https://angular.io/cli)
```
npm install -g @angular/cli
```
* Got an error as on running `ng serve` opens editor instead of loading local URL. This is the terminal editor on the 'ng' alias. I uninstalled it with:
```
sudo apt purge ng-common ng-latin
```
Now again I ran `ng serve` and in the browser I typed `localhost:4200` (4200 is the default port). The application was successfully installed and window that opened is shown below:
![](Images/angular%20app.png)

## Setting Up the application through Docker

I firstly cloned the application and in the cloned folder made a file `Dockerfile`. In this, I used a node [image](https://hub.docker.com/_/node)
```
nano Dockerfile
```
I wrote this code in Dockerfile
```
#getting base image
FROM node

MAINTAINER Priyam Singh <2020priyamsingh@gmail.com>

RUN apt-get update
COPY . /src
WORKDIR /src

#Installing Angular CLI
RUN npm install
RUN npm install -y -g @angular-devkit/build-angular
RUN npm install -y -g @angular/cli

EXPOSE 4200
CMD ["ng", "serve", "--host", "0.0.0.0"]
```
* My application was not running on browser but it was getting compiled because I made a mistake that I was not writing "--host", "0.0.0.0" (--host 0.0.0.0 to listen to all the interfaces from the container).
* I was facing many errors such as packages getting failed so I removed my code of Yarn and only installed with Angular CLI

After this, I build the image
```
docker build -t angular5:latest .
```

Then ran the container
```
docker run --rm --name docker5 -p 1234:4200 angular5:latest
```
On the browser I opened `localhost:1234` it worked and the below window got opened.
![](Images/application%20docker%20running.png)


## Setting Up application through AWS

### Installing AWS CLI in terminal
I followed this official link for the installation of [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html#cliv2-linux-install) and ran the below commands:

```
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws --version
```
I got the version output as shown below. It means AWS CLI is successfully installed.
```
aws-cli/2.0.56 Python/3.7.3 Linux/5.3.0-64-generic exe/x86_64.ubuntu.19
```

### Setting up AWS profile

For setting up AWS profile I followed this official[ documentation](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html). I ran the command `aws configure` to set up AWS CLI installation. It will ask for some information which we have to enter:
```
AWS Access Key ID [****************4529]: <Enter the ID>
AWS Secret Access Key [None]: <Enter the Access Key>
Default region name [None]: us-east-2
Default output format [None]: json
```
Then run the below command:
```
aws sts get-caller-identity
```
We will get the below output and our profile has been successfully configured:
```
"UserId": <"AWS Access Key ID ">,
    "Account": <"ACCOUNT NO.">,
    "Arn": "******"
```
### ECR 

Amazon Elastic Container Registry (ECR) is a fully-managed Docker container registry that makes it easy for developers to store, manage, and deploy Docker container images. Amazon ECR eliminates the need to operate our container repositories or worry about scaling the underlying infrastructure. Amazon ECR hosts our images in a highly available and scalable architecture, allowing us to reliably deploy containers for our applications. 

#### Creating an ECR Repository

To Create the ECR Repository I followed the below steps:

* I opened the Amazon ECR console
* In the navigation pane, choose `Repositories`
* On the Repositories page, choose `Create repository`
* In `Repository name`, enter a unique name for repository
* For `Tag immutability`, I choose the tag mutability setting for the repository. Repositories configured with immutable tags will prevent image tags from being overwritten
* For `Scan on push`, I choose the image scanning setting for the repository. Repositories configured to scan on push will start an image scan whenever an image is pushed, otherwise, image scans need to be started manually
* For `KMS encryption`, I choose to enable encryption of the images in the repository using AWS Key Management Service

#### Deleting an ECR repository

To delete an ECR repository I followed the below steps:

* I opened the Amazon ECR console

* In the navigation pane, I choose `Repositories`

* On the Repositories page, I selected the repository to delete and choose `Delete`

* In the Delete repository_name window, I verified that the selected repositories to be deleted and choose `Delete` option.

#### Pushing an ECR Repository

When we create a repository it shows commands for pushing. So we have to follow these commands and we can easily push the image to our ECR Repository.
```
```

### Adding an image to ECR Repository through GitHub Actions

* I created a new file `image.yml` in the `.github/workflows`. 
* I stored my credentials in the secrets section of my application repository.
* I used this [plugin](https://github.com/marketplace/actions/configure-aws-credentials-action-for-github-actions) `"Configure AWS Credentials" Action For GitHub Actions` for AWS configuration.

* Below is the YML file:
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

    
```
After this, the image got successfully pushed to ECR.
