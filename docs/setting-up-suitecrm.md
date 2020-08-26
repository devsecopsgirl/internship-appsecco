
# Setting up SuiteCRM

## Objective

SuiteCRM should get deployed in a server that is the second VM, to perform the task and solve the 5th point of the [problem statement](https://intern-appsecco.netlify.app/problem-statement/) under Task 1.

## SuiteCRM

The application that I chose is [SuiteCRM](https://suitecrm.com/). It is a Customer Relationship Management tool which is the open-source forked version of [SugarCRM](https://www.sugarcrm.com/). SuiteCRM adds a few additional features to its fork and is free to use. 
I chose the application because it is easy to download and deployed faster and it is also an application that is used in the real-world and is not just a dummy application.

I checked out the requirements for installing SuiteCRM and made a workflow on how to carry on further tasks.
Since SuiteCRM is written in PHP, I had to install a few things on the production VM manually.

### Install PHP on Ubuntu 18.04

Ubuntu 18.04 has PHP 7.2 in its repositories. I Installed it by running the commands below in terminal:

```
sudo apt-get -y install wget php php-{pear,cgi,common,curl,mbstring,gd,mysql,gettext,bcmath,imap,json,xml,fpm}
```
Install the required software stack for SuiteCRM. This includes the LAMP stack and some additional PHP modules.

```
sudo apt-get install apache2 apache2-utils libapache2-mod-php php php-common php-curl php-xml php-json php-
```

To confirm that the PHP version is installed.

```
php -v
```

### Installing MySQL
```
sudo apt install mysql-server

sudo mysql_secure_installation
```

Building a database:

```
create database suitecrm;
grant all on suitecrm.* to suitecrm@localhost IDENTIFIED by "StrongPassword";
flush privileges;
quit
```
### Installing Apache Web Server

For installing Apache server I followed this [documentation](https://www.digitalocean.com/community/tutorials/how-to-install-the-apache-web-server-on-ubuntu-18-04). The way documentation is written is easy to understand.

Step 1 — Installing Apache

```
sudo apt update
sudo apt install apache2
```
List the ufw application profiles by typing:
```
sudo ufw app list
```
A list of the application profiles:

```
Available applications:
  Apache
  Apache Full
  Apache Secure
  OpenSSH
```
There are three profiles available for Apache:

* **Apache:** This profile opens only port 80 (normal, unencrypted web traffic)
* **Apache Full:** This profile opens both port 80 (normal, unencrypted web traffic) and port 443 (TLS/SSL encrypted traffic)
* **Apache Secure:** This profile opens only port 443 (TLS/SSL encrypted traffic)

Now to check the open ports
```
sudo ufw status

Status: active

To                         Action      From
--                         ------      ----
OpenSSH                    ALLOW       Anywhere                  
8080                       ALLOW       Anywhere                  
OpenSSH (v6)               ALLOW       Anywhere (v6)             
8080 (v6)                  ALLOW       Anywhere (v6)     

```  
To allow the Apache port.
```   
sudo ufw allow 'Apache'
```
Again check the status to see the open ports.
```
sudo ufw status
```
I can see the following ports open now including Apache.
```
Status: active

To                         Action      From
--                         ------      ----
OpenSSH                    ALLOW       Anywhere                  
8080                       ALLOW       Anywhere                  
Apache                     ALLOW       Anywhere                  
OpenSSH (v6)               ALLOW       Anywhere (v6)             
8080 (v6)                  ALLOW       Anywhere (v6)             
Apache (v6)                ALLOW       Anywhere (v6)    
```
Check with the systemd init system to make sure the service is running by typing:
```
sudo systemctl status apache2
```
Once check that the Apache is `active` after that run on the browser.
`http://IP of production VM`. I saw the default Ubuntu 18.04 Apache web page on a web browser which indicates it's working properly.

### Cloning  SuiteCRM

To clone SuiteCRM from GitHub firstly I [fork](https://github.com/salesagility/SuiteCRM) the SuiteCRM and after that cloned it to my production system.
```
git clone https://github.com/Priyam5/SuiteCRM.git
```

### Installing Composer 

SuiteCRM packages are not built. This is due to I  cloned the repository instead of using the zip archive. Hence, I had to install Composer, the package manager for PHP. I followed the official [documentation](https://getcomposer.org/doc/00-intro.md) and performed required steps to install Composer globally. After a successful installation, I ran `composer install` in the project's root directory to build the dependencies for SuiteCRM.

```
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"

php -r "if (hash_file('sha384', 'composer-setup.php') === '8a6138e2a05a8c28539c9f0fb361159823655d7ad2deecb371b04a83966c61223adc522b0189079e3e9e277cd72b8897') { echo 'Installer verified'; }

php composer-setup.php

php -r "unlink('composer-setup.php');"
```

To check composer is installed:
```
php composer.phar
```
## Access SuiteCRM Web Interface

I copied the files of SuiteCRM directory to the location /var/www/html/index.html using the below command
```

```

Now the configuration page of SuiteCRM opened.