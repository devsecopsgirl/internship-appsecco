# Implementing SuiteCRM through Docker

## Objective

This section aims to implement the application SuiteCRM through Docker and deploy it through pipeline. Solution to the first point of the [problem statement](https://intern-appsecco.netlify.app/problem-statement/) under Task 2.

## Docker

An open-source project that automates the deployment of software applications inside containers by providing an additional layer of abstraction and automation of OS-level virtualization on Linux. In simple, Docker is a tool that allows developers, sys-admins etc. to deploy applications in a sandbox (which in docker world we call it containers) to run over the host operating system. For Docker commands follow this [link](https://github.com/wsargent/docker-cheat-sheet#dockerfile). Before installation, lets talk about little bit about container, image and Dockerfile as we will come across these terms further:

* Container - A container is a running instance of an image.
* Image - An image is a unit that contains everything ( the code, libraries, environments variables and configuration files) that our service requires to run.
* Dockerfile - Just assume it as a blueprint for creating a Docker images, it can inherit from other containers, define what software to install and what commands to run.

## Dockerfile

Docker can build images automatically by reading the instructions from a Dockerfile. A Dockerfile is a text document that contains all the commands a user could call on the command line to assemble an image. Using `docker build` users can create an automated build that executes several command-line instructions in succession.For more details on Dockerfile I refer this official link of docker(https://docs.docker.com/engine/reference/builder/)

I started with building a dockerfile in which I implemented a php image because SuiteCRM is PHP based application. I copied the image from dockerhub of [php](https://hub.docker.com/_/php)

### Apache Installation

I begin with building the Dockerfile firstly with apache installation. 

Note: got an error `unable to prepare context: unable to evaluate symlinks in Dockerfile path: lstat /home/jenkins-infra/docker-files/Dockerfile: no such file or directory`

Be careful while naming the Docker file name as `Dockerfile` other names don't work.

NOTE: I got an error my apache server was not getting served. I will explain in a little detail: 
* I stopped my container `docker stop f9af4fb06f4c` and ran again `docker run -d --rm --name ubuntu2 -p 1234:80 4c0437bfcded`. After the container was build I checked If the port 1234 was open or not by `netstat -ntap` But there was no such network port 1234 open.
* Then I checked the `docker logs ubuntu2` It showed `Error: No such container: ubuntu2` then I checked `docker ps -a` which showed the exited in a min.
* After this I ran the above command of building container without the `-d flag` which is detached mode means running container in background then it gave the error `/bin/sh: 1: Syntax error: Unterminated quoted string`. From here I got to know I have missed a quote in my dockerfile in a command which I fixed.

My Dockerfile which finally worked is 
```
# getting base image PHP

FROM php:7.4-cli

MAINTAINER priyam singh <2020priyamsingh@gmail.com>

# Executed during the building of the image
# Apache installation
RUN apt-get update
RUN apt-get install -y apache2

# Executed when container created out of image
CMD ["apache2ctl","-D","FOREGROUND"]
EXPOSE 80
```