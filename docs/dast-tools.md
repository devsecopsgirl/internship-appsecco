# Dynamic Analysis

## Objective

This section aims to identify suitable tools for SuiteCRM to perform DAST and generate a report to provide a solution to the 8th point of the [problem statement](https://intern-appsecco.netlify.app/problem-statement/) under Task 1.

## DAST

DAST or Dynamic Application Security Testing is a black-box testing technique in which the DAST tool interacts with the application being tested in its **running state** to imitate an attacker. Unlike static analysis, DAST allows for sophisticated scans on the client-side and server-side without needing the source code or the framework the application is built on. They usually require minimal user interactions once configured. In dynamic analysis, tools are used to automate attacks on the application. DAST tools are especially helpful for detecting:

* input/output validation: (e.g. cross-site scripting and SQL injections);
* server configuration mistakes;
* authentication issues; other problems which manifest in real-time or become visible only when a known user logs in.

## OWASP ZAP

Zed Attack Proxy is an open-source tool used to perform dynamic application security testing designed specifically for web applications. ZAP has a desktop interface, APIs for it to be used in an automated fashion, and also a CLI. It imitates an actual user where it interacts with the application to perform various attacks. At its core, ZAP is what is known as a “man-in-the-middle proxy.” It stands between the tester’s browser and the web application so that it can intercept and inspect messages sent between a browser and web application, modify the contents if needed, and then forward those packets on to the destination. It can be used as a stand-alone application, and as a daemon process. ZAP comes with a large number of options to use, for which further details can be found [here](https://www.zaproxy.org/getting-started/). ZAP also comes as a [Docker image](https://hub.docker.com/r/owasp/zap2docker-stable/) which is more convenient to use especially if one is using the CLI interface.


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

To understand how zap works I first manually perform the steps in the jenkins pipeline and then integrate with jenkins pipeline in the next section.
For using OWASP ZAP with docker, I have to pull the ZAP image from [docker hub](https://hub.docker.com/)]. I went through this [documentation](https://blog.mozilla.org/fxtesteng/2016/05/11/docker-owasp-zap-part-one/) as a lot of errors are been resolved along with solutions. So firstly I ran ZAP on my Jenkins VM to figure out how it works and test the target URL. Ans also many flags have been used which can be found here in the official documentation of [zap](https://www.zaproxy.org/docs/docker/baseline-scan/)

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

* I ran a quick scan to have a look at how ZAP inputs information. ZAP is running inside a docker container. So I used the IP assigned to docker which can be found by ifconfig command. 
```
docker run -e LC_ALL=C.UTF-8 -e LANG=C.UTF-8 -i owasp/zap2docker-stable zap-cli quick-scan --start-options '-config api.disablekey=true' --self-contained --spider -l Low http://172.17.0.1:9090
```
**--start-options '-config api.disablekey=true'** ZAP also has an API that can be used to interact with it programmatically. Otherwise, ZAP tried (and failed) to connect to the proxy as the API key was not specified.

**-l** Specifies the severity level at which ZAP should log a vulnerability to console or to a report.

* I ran an active scan 
```
docker run --rm -e LC_ALL=C.UTF-8 -e LANG=C.UTF-8 --name zap -u zap -p 8090:8080 -d owasp/zap2docker-stable zap.sh -daemon -port 8080 -host 0.0.0.0 -config api.disablekey=true
```
**--rm** flag to delete the container, automatically to stop it once done.

**--name** for providing the name of the container created.

```
docker exec <CONTAINER NAME/ID> zap-cli open-url <TARGET URL>
```
**open-url** For starting the daemon for zap to be accessed by the CLI,` open-url` adds the target URL to the configuration in ZAP-CLI (without this, active-scan option will not start a scan on the target) and then run the scan against SuiteCRM.
```
docker exec <CONTAINER NAME/ID> zap-cli active-scan <TARGET URL>
```
**active-scan** run's the scan against SuiteCRM.

* ZAP baseline scan with the docker image

```
docker run -i owasp/zap2docker-stable zap-baseline.py -t "http://172.17.0.1:9090" -l INFO
```
**-t** target URL including the protocol, eg https://www.example.com

**-l** l is for level; minimum level to show: PASS, IGNORE, INFO, WARN or FAIL, use with -s to hide example URLs

* For saving the report on the Jenkins machine, I needed to mount a volume with Docker. I used the -v flag to mount the present working directory of the host to the /zap/wrk directory of the container 
```
docker run -v $(pwd):/zap/wrk/ -i owasp/zap2docker-stable zap-baseline.py -t "http://192.168.1.2/suitecrmnew" -r baseline-report.html -l PASS
```
**-r**  file to write the full ZAP HTML report, saves scan output to Jenkins machine.

### Jenkins Integration 

Now I will integrate baseline-scan as part of SuiteCRM in the Jenkins-pipeline. I created a separate pipeline for DAST tools as the scan might become too long after combining both SAST and DAST scans. So in this pipeline, we have to follow the steps of fetching the code, building the pipeline, deploying the pipeline, and then at last DAST scan tools.

* Starting with the first stage that is fetching the code of SuiteCRM from the GitHub repository.
```
stages {
        stage('git') {
            steps {
                git url: 'https://github.com/Priyam5/SuiteCRM.git/'
            }
        }
```
* The second stage is for building SuiteCRM, similar to that of SAST pipeline
```
stage ('Build') {
            steps {
                sh 'composer install'
            }
        }
```
* The third stage is for deploying the SuiteCRM application
```
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
```
* The fourth stage is of OWASP ZAP scan. In this, we will first pull the zap image after that makes a container named `zap2`  and mention a port to run and the mentioned port should not be used by any other application or it will throw error failed to access the provided URL. Then print the report `zap_baseline_report2.html`.

```
stage ('OWASP ZAP') {
           steps {
                sh 'docker pull owasp/zap2docker-stable'
                sh 'docker rm -f zap2 ; docker run --rm -e LC_ALL=C.UTF-8 -e LANG=C.UTF-8 --name zap2 -u zap -p 8090:8080 -d owasp/zap2docker-stable zap.sh -daemon -port 8080 -host 0.0.0.0 -config api.disablekey=true'
                sh 'docker run -v $(pwd)/zap-report:/zap/wrk/:rw --rm -i owasp/zap2docker-stable zap-baseline.py -t "http://192.168.1.4/suitecrm" -I -r zap_baseline_report2.html -l PASS'
           }
        }
```
* I got the error `jenkins-infra@192.168.1.2: Permission denied (public key, password)`
For this, I ran the command 
```
sudo usermod -aG docker jenkins
```
Because Jenkins would require to use `sudo` when it will run docker commands as it is not part of `docker` user group on the Jenkins VM. I ran the above command for it, to be able to operate without using sudo.

* In printing the report I was getting an error as shown below:
```
Permission denied
Traceback (most recent call last):
  File "/zap/zap-baseline.py", line 398, in main
    write_report(base_dir + report_html, zap.core.htmlreport())
  File "/zap/zap_common.py", line 499, in write_report
    with open(file_path, mode='wb') as f:
IOError: [Errno 13] Permission denied: '/zap/wrk/zap_baseline_report2.html'
```
For this in the Jenkins VM run this command to switch to zap
```
docker run -it owasp/zap2docker-stable
```
Then cat the /etc/passwd to check the permissions they have. It showed this to me `zap:x:1000:1000::/home/zap:/bin/bash`. After this make a directory `zap-report` in the workspace of jenkins. Run the below command to give the permissions the directory made:
```
sudo chown -R 1000:1000 /var/lib/jenkins/workspace/dast-jenkins-pipeline/zap-report/
```
* So the full pipeline looks like this for DAST pipeline which was successfull.

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
                sh 'docker run  -v $(pwd)/zap-report:/zap/wrk/:rw --rm -i owasp/zap2docker-stable zap-baseline.py -t "http://192.168.1.4/suitecrm" -I -r zap_baseline_report2.html -l PASS'
           }
        }
    }
}   

```

The zap-report that was generated can be found [here](https://github.com/Priyam5/internship-appsecco/blob/master/Reports/zap_baseline_report2.html)