# Dynamic Analysis

## Objective

This section aims to identify suitable tools for SuiteCRM to perform DAST and generate a report to provide a solution to the 8th point of the [problem statement](https://intern-appsecco.netlify.app/problem-statement/) under Task 1.

## DAST

DAST or Dynamic Application Security Testing is a black-box testing technique in which the DAST tool interacts with the application being tested in its **running state** to imitate an attacker. Unlike static analysis, DAST allow for sophisticated scans on the client-side and server-side without needing the source code or the framework the application is built on. They usually require minimal user interactions once configured. In dynamic analysis, tools are used to automate attacks on the application. DAST tools are especially helpful for detecting:

* input/output validation: (e.g. cross-site scripting and SQL injections);
* server configuration mistakes;
* authentication issues; other problems which manifest in real time or become visible only when a known user logs in.

## OWASP ZAP

Zed Attack Proxy is an open-source tool used to perform dynamic application security testing designed specifically for web applications. ZAP has a desktop interface, APIs for it to be used in an automated fashion, and also a CLI. It imitates an actual user where it interacts with the application to perform various attacks. At its core, ZAP is what is known as a “man-in-the-middle proxy.” It stands between the tester’s browser and the web application so that it can intercept and inspect messages sent between a browser and web application, modify the contents if needed, and then forward those packets on to the destination. It can be used as a stand-alone application, and as a daemon process. ZAP comes with a plethora of options to use, for which further details can be found [here](https://www.zaproxy.org/getting-started/). ZAP also comes as a [Docker image](https://hub.docker.com/r/owasp/zap2docker-stable/) which is more convenient to use especially if one is using the CLI interface.


### Installation of docker

We will start by first updating the existing list of packages.
```
sudo apt update
```
Installation of prerequisite packages so that apt can use packages over HTTPS.
```
sudo apt install apt-transport-https ca-certificates curl software-properties-common
```
Adding GPG key for the official Docker repository
```
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
```
Add the Docker repository to APT sources
```
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable" && sudo apt update
```
To check Docker repository version table and installation candidate, use the below command.
```
apt-cache policy docker-ce
```
Finally, install Docker
```
sudo apt install docker-ce
```
To check the running status of Docker
```
sudo service docker status
```

### Configure OWASP ZAP with Docker

For using OWASP ZAP with docker, I have to pull the ZAP image from docker hub. I went through this [documentation](https://blog.mozilla.org/fxtesteng/2016/05/11/docker-owasp-zap-part-one/) as a lot of errors are been resolved along with solutions. So firstly I ran ZAP on my Jenkins VM to figure out how it works and test the target URL.

* Firstly, I pulled the docker image to be tested.
```
docker pull owasp/zap2docker-stable
```
* To run ZAP with CLI interface.
```
docker run -e LC_ALL=C.UTF-8 -e LANG=C.UTF-8 -i owasp/zap2docker-stable zap-cli --help
```
**-e** flag for Docker to inject the environment variables in the container.

**LC_ALL=C.UTF-8** the environment variable that overrides all the other localization settings (except $LANGUAGE

* After this I ran a quick scan to have a look at how ZAP inputs information. ZAP is running inside a docker container. So I used the IP assigned to docker which can be found by ifconfig command. 
```
docker run -e LC_ALL=C.UTF-8 -e LANG=C.UTF-8 -i owasp/zap2docker-stable zap-cli quick-scan --start-options '-config api.disablekey=true' --self-contained --spider -l Low http://172.17.0.1:9090
```
**--start-options '-config api.disablekey=true'** ZAP also has an API that can be used to interact with it programmatically. Otherwise, ZAP tried (and failed) to connect to the proxy as the API key was not specified.

**-l** Specifies the severity level at which ZAP should log a vulnerability to console or to a report.

### Jenkins Integration 

I created a separate pipeline for DAST tools as the scan might become too long. So the full pipeline looks like this for DAST pipeline.

```
pipeline {
    agent any

    stages {
        stage('git') {
            steps {
                git url: 'https://github.com/Priyam5/SuiteCRM.git/'
            }
        }
        
        stage ('Build') {
            steps {
                sh 'composer install'
            }
        }
        
        stage ('Deploying App to production server'){
            steps {
                sh 'echo "Deploying App to production Server"'
                sh 'ssh -o StrictHostKeyChecking=no production@192.168.1.4 "rm -rf suitecrm && mkdir suitecrm"'
                sh 'scp -r * production@192.168.1.4:~/suitecrm'
                sh 'ssh -o StrictHostKeyChecking=no production@192.168.1.4 "cd suitecrm && sudo cp -r * /home/production/html/suitecrm"'
                sh 'ssh -o StrictHostKeyChecking=no production@192.168.1.4 "sudo cp -r /home/production/config.php /home/production/html/suitecrm"'     
                sh 'ssh -o StrictHostKeyChecking=no production@192.168.1.4 "cd /home/production/html/suitecrm && sudo chmod -R 755 * && sudo chown -R www-data:www-data *"'
                
           }
        }
        
        stage ('OWASP ZAP') {
           steps {
                sh 'docker pull owasp/zap2docker-stable'
                sh 'docker rm -f zap2 ; docker run --rm -e LC_ALL=C.UTF-8 -e LANG=C.UTF-8 --name zap2 -u zap -p 8090:8080 -d owasp/zap2docker-stable zap.sh -daemon -port 8080 -host 0.0.0.0 -config api.disablekey=true'
                sh 'docker run  -v $(pwd):/zap/wrk/ --rm -i owasp/zap2docker-stable zap-baseline.py -t "http://192.168.1.4/suitecrm" -I -r zap_baseline_report2.html -l PASS'
           }
        }
    }
}   

```


