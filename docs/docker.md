# Performing DAST of SuiteCRM through Docker

## Objective

This section aims to implement the application SuiteCRM through Docker and deploy it through a pipeline and it's just improvisation of previous section `Dynamic Analysis of SuiteCRM`(https://intern-appsecco.netlify.app/dast-tools/) as here I will perform DAST of SuiteCRM through container. Solution to the first and second point of the [problem statement](https://intern-appsecco.netlify.app/problem-statement/) under Task 2.

## Docker

An open-source project that automates the deployment of software applications inside containers by providing an additional layer of abstraction and automation of OS-level virtualization on Linux. In simple, Docker is a tool that allows developers, sys-admins, etc. to deploy applications in a sandbox (which in docker world we call it containers) to run over the host operating system. For Docker commands follow this [link](https://github.com/wsargent/docker-cheat-sheet#dockerfile). Before installation, let's talk about a little bit about container, image, and Dockerfile as we will come across these terms further:

* Container - A container is a running instance of an image.
* Image - An image is a unit that contains everything ( the code, libraries, environments variables, and configuration files) that our service requires to run.
* Dockerfile - Just assume it as a blueprint for creating Docker images, it can inherit from other containers, define what software to install and what commands to run.

## Dockerfile

Docker can build images automatically by reading the instructions from a Dockerfile. A Dockerfile is a text document that contains all the commands a user could call on the command line to assemble an image. Using `docker build` users can create an automated build that executes several command-line instructions in succession. For more details on Dockerfile, I refer this official link of [docker](https://docs.docker.com/engine/reference/builder/)

I started with building a dockerfile in which I implemented a PHP image because SuiteCRM is a PHP based application. I copied the image from dockerhub of [php](https://hub.docker.com/_/php)

### Apache Installation

I begin with building the Dockerfile firstly with apache installation. 

Note: got an error `unable to prepare context: unable to evaluate symlinks in Dockerfile path: lstat /home/jenkins-infra/docker-files/Dockerfile: no such file or directory`. So I renamed the Docker file name as `Dockerfile`.

NOTE: I got an error my apache server was not getting served. I will explain in a little detail:

* I stopped my container `docker stop f9af4fb06f4c` and ran again
```
docker run -d --rm --name dockercon -p 1234:80 4c0437bfcded`
```
After the container was build I checked If the port `1234` was open or not by `netstat -ntap` But there was no such network port `1234` open.
* Then I checked the `docker logs dockercon` It showed `Error: No such container: dockercon` then I checked `docker ps -a` which showed the container exited in a minute.
* After this I ran the above command of building container without the `-d flag` which is detached mode means running container in background then it gave the error `/bin/sh: 1: Syntax error: Unterminated quoted string`. From here I got to know I have missed a quote in my dockerfile in a command which I fixed.

Dockerfile which finally worked is 
```
# getting base image PHP

FROM php:7.4-cli

MAINTAINER Priyam Singh <2020priyamsingh@gmail.com>

# Executed during the building of the image
# Apache installation
RUN apt-get update
RUN apt-get install -y apache2

# Executed when container created out of image
CMD ["apache2ctl","-D","FOREGROUND"]
EXPOSE 80
```
### SuiteCRM installation through a container
* Apache started running, but then I decided to use the image `php:7.4-apache` which have apache built-in and not to separately install it. 
* This is the Dockerfile I am using for now
 
```
#getting base image PHP

FROM php:7.4-apache

MAINTAINER Priyam Singh <2020priyamsingh@gmail.com>

# Executed during the building of the image
RUN apt-get update
RUN apt-get install -y libzip-dev zip unzip zlib1g-dev
RUN docker-php-ext-install mysqli zip

# Copying the SUiteCRM repositories
COPY dast-jenkins-pipeline /var/www/html/suitecrm
RUN chown -R www-data:www-data /var/www/html/suitecrm

# Executed when container created out of image
CMD ["apache2ctl","-D","FOREGROUND"]
EXPOSE 80
```
* I build the image by the command below:
```
docker build -t <name>:latest .
```
* I ran the container:
```
docker run -d --rm --name <name of container> -p 1234:80 <docker image name>
```
**-d** : Detached mode means running container in background.
**--rm** : It removes the container when the base system restart or shutdown.
**--name** : For giving name to container.
**-p** : To define ports.

* I got the below error on the SuiteCRM `install.php` page when I went to the URL http://192.168.1.2:1234/suitecrm
```
Warning: require_once(modules/DynamicFields/DynamicField.php): failed to open stream: Permission denied in /var/www/html/suitecrm/data/SugarBean.php on line 45

Fatal error: require_once(): Failed opening required 'modules/DynamicFields/DynamicField.php' (include_path='.:/usr/local/lib/php') in /var/www/html/suitecrm/data/SugarBean.php on line 45
```
So I changed the permission of SuiteCRM directory within the running container
```
docker exec -it <container name> /bin/bash
chown -R www-data:www-data suitecrm
```
Changing permissions took too long so I mounted the directory of SuiteCRM.

* I installed zip because I got error Zip module was not present in docker I added this command in Dockerfile
```
RUN apt-get install -y libzip-dev zip unzip zlib1g-dev
RUN docker-php-ext-install mysqli zip
```
* My database was not working so I firstly in `/etc/mysql/mysql.conf.d/mysqld.cnf` file binded the port 0.0.0.0 to allow all ports. I also allowed the port 3306 the mysql port. Then I ran the below command to change the `suitecrm@localhost` to `suitecrm@%` so that user is able to login from anywhere.
```   
sudo mysql -u root -p
UPDATE mysql.user SET Host='%' WHERE Host='localhost' AND User='suitecrm';
UPDATE mysql.db SET Host='%' WHERE Host='localhost' AND User='suitecrm';
FLUSH PRIVILEGES;
```
* I copied the config.php file after the installation of SuiteCRM is complete. To use scp to copy files to the remote server from your computer or copy files from the remote server to your computer, you must have the scp program available in both places (computer and remote server). This documentation will be [helpful](https://linuxhint.com/linux_scp_command/)

`scp -r config.php jenkins-infra@192.168.1.2:/home/jenkins-infra/docker-files`

but it gave error `bash: scp: command not found` bec. openssh not installed in container 
`apt install -y openssh-client openssh-server` also install on client means we're saving the file the host/client `apt install -y openssh-client`

## DAST scan 

On VM, run the DAST scan similar to earlier as in the section [DevSecOps Dynamic Analysis of SuiteCRM](https://intern-appsecco.netlify.app/dast-tools/). Just do the changes in the command of URL same to where suitecrm is running inside the docker container
```
docker run -i owasp/zap2docker-stable zap-baseline.py -t "http://192.168.1.2:1234/suitecrm" -l INFO
```

* An error I was facing of no space on the device so remove the images and stopped containers by using the below commands
```
docker rmi <image image name/ image id>
docker rm <docker name/docker id>
```

## Integrating into Pipeline

For integrating on pipeline I followed these steps:

* Push the Dockerfile to the GitHub SuiteCRM repository which I forked `https://github.com/Priyam5/SuiteCRM.git/` in my GitHub. The Dockerfile is:
```
    FROM php:7.4-apache

    MAINTAINER Priyam Singh <2020priyamsingh@gmail.com>

    RUN apt-get update
    RUN apt-get install -y libzip-dev zip unzip zlib1g-dev
    RUN docker-php-ext-install mysqli zip

    EXPOSE 80
    ENTRYPOINT ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
```

*  In the pipeline add the step of `docker deployment` and in this stage, we will make an image from the Dockerfile and then container and also mount the directory. The stage is shown below
```
    stage ('docker deployment') {
                steps {
                    sh 'docker build -t dockerimage:latest .'
                    sh 'cp /var/lib/jenkins/workspace/config.php $(pwd)'
                    sh 'docker run -v $(pwd):/var/www/html/suitecrm -d --rm --name dockerzap3 -p 1233:80 dockerimage:latest'
                } 
            }    
```

* I was getting an apache error: `apache2: Syntax error on line 80 of /etc/apache2/apache2.conf: DefaultRuntimeDir must be a valid directory, absolute or relative to ServerRoot`. So in Dockerfile I added entrypoint as below:
```
    ENTRYPOINT ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
```
* When I opened the URL `http://192.168.1.2:1233/suitecrm/`. SuiteCRM was not getting deployed and I was getting warnings 
```
    Warning: sugar_file_put_contents_atomic() : fatal rename failure '/tmp/tempPRdtfq' -> 'cache/modules/Employees/Employeevardefs.php' in /var/www/html/suitecrm/include/utils/sugar_file_utils.php on line 204

    Warning: sugar_file_put_contents_atomic() : fatal rename failure '/tmp/tempZ0yMaj' -> 'cache/modules/Users/Uservardefs.php' in /var/www/html/suitecrm/include/utils/sugar_file_utils.php on line 204

    Warning: sugar_file_put_contents_atomic() : fatal rename failure '/tmp/tempsEJ08b' -> 'cache/modules/UserPreferences/UserPreferencevardefs.php' in /var/www/html/suitecrm/include/utils/sugar_file_utils.php on line 204

    Warning: sugar_file_put_contents_atomic() : fatal rename failure '/tmp/tempaF8Pd5' -> 'cache/modules/Administration/Administrationvardefs.php' in /var/www/html/suitecrm/include/utils/sugar_file_utils.php on line 204

    Warning: session_start(): Cannot start session when headers already sent in /var/www/html/suitecrm/include/MVC/SugarApplication.php on line 619

    Warning: Cannot modify header information - headers already sent by (output started at /var/www/html/suitecrm/include/utils/sugar_file_utils.php:204) in /var/www/html/suitecrm/include/utils.php on line 3124

    Warning: session_destroy(): Trying to destroy uninitialized session in /var/www/html/suitecrm/include/MVC/SugarApplication.php on line 132
```
So it was coming because some directories of SuiteCRM were not having the appropriate permissions. For that I just ran this command and it started working:
```
    sudo chmod -R 755 .

    sudo chmod -R 775 cache custom modules upload
```

* Now we will do the zap scan to the container made:
```
    stage ('OWASP ZAP') {
            steps {
                sh 'docker pull owasp/zap2docker-stable'
                sh 'docker run --network=host -v $(pwd)/zap-report:/zap/wrk/ -i owasp/zap2docker-stable zap-baseline.py -t http://192.168.1.2:1233/suitecrm/ -I -r zap_baseline_report.html -l PASS'
                sh 'docker rm -f dockerzap3'

```
* I got error `I/O error(5): ZAP failed to access: http://192.168.1.2:1233/suitecrm/` because zap container was not able to scan the provided URL due to which I added the flag `--network=host` and it worked because normally we have to forward ports from the host machine into a container, but when the containers share the host's network, any network activity happens directly on the host machine - just as it would if the program was running locally on the host instead of inside a container.

* I also got the error SuiteCRM was not able to print the report `/zap/wrk/zap_baseline_report.html`. So I gave to the directory zap-report permissions:
```
    sudo chown -R jenkins:jenkins zap-report
    sudo chmod 777 zap-report 
```
* Here is the report which got generated after the [zap scan](https://github.com/Priyam5/internship-appsecco/blob/master/Reports/docker_zap_baseline_report.html) worked successfully.