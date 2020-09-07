
# Deployment of SuiteCRM

## Objective
 
This section aims to set up a basic pipeline in Jenkins to provide a solution to the 1st, 2nd, 5th and 6th points of the problem statement under Task 1.

## Jenkins pipeline project created

I set up Jenkins as mentioned in the Setup of Jenkins section. For building a pipeline for Maven project. I clicked on New Item from the main dashboard which leads me to a different page. I gave `suitecrm-pipeline` as the project's name and chose `Pipeline` as the project type amongst all the options present.

Next came the project configurations page. Here:

* Under General section:
    * I gave a brief description of the application being deployed and the purpose of this pipeline.
    * I also checked the GitHub Project option and provided the GitHub URL for the project's repository. This option allowed Jenkins to know where to fetch the project from.

* Under Build Triggers section:
    * I checked the `GitHub hook trigger for GITScm Polling` option to allow automated builds based on webhook triggers on GitHub for selected events.

* Under `Pipeline` section:
    * For Definition, I chose `Pipeline Script` option and written the pipeline code in the `script` section.

Then, I clicked on save to save the configurations made.

### Jenkinsfile

I have explained about Jenkinsfile in [Setting Up Pipeline](https://intern-appsecco.netlify.app/setting-up-pipeline/) section.

The following are the contents of the Jenkinsfile which executes the pipeline:

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
        
        // stage ('Dependency-Check Analysis'){
        //     steps {
        //         sh 'Dependency-Check'
        //     }    
        // }
        
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
    }
}   
```
* `StrictHostKeyChecking=no`  In host key checking, ssh automatically maintains and checks a database containing identification for all hosts it has ever been used with. If this property is set to yes, ssh will never automatically add host keys to the $HOME/.ssh/known_hosts file, and refuses to connect to hosts whose host key has changed. This property forces the user to manually add all new hosts. If this property is set to no, ssh will automatically add new host keys to the user known hosts files.

### The stages of pipeline

* **git :** 
In this stage git repository of SuiteCRM is cloned. 

* **Build :**
In the build stage, application is built and dependencies are installed using  `composer` in the build stage on the Jenkins VM. This loads all the dependencies that the app (SuiteCRM) requires.

* **Deploying App to production server:** 
In this stage, the files are deployed from Jenkins to production VM and also removed the files of suitecrm from production server as it might cause conflict in between the files.

### Build Stage - Permission denied 

In the build stage, I was getting an error for permission denied for the folder was not getting deleted and permission denied for regular files not being created.

So to solve this I followed this [documentation](https://www.digitalocean.com/community/tutorials/how-to-move-an-apache-web-root-to-a-new-location-on-ubuntu-16-04)

* I changed root directory to home directory as the document root was set to /var/www/html. It was configured in the following file: 
  
```
/etc/apache2/sites-enabled/000-default.conf
```
So I run this command to make the changes in the nano file. 
```
sudo nano /etc/apache2/sites-enabled/000-default.conf
```
I changed it to /home/production/html/suitecrm

Created file suitecrm under /home/production/html

Made changes in the last path in Jenkinsfile to /home/production/html/suitecrm

Click On Save and then build it was successfully build this time.

### SuiteCRM Web Page

When I opened the webpage  `http://192.168.1.4/suitecrm/install.php` there it showed to set the `session.save_path`. So I changed it from this `session.save_path = "var/www/html/suitecrm/"` to `session.save_path = "tmp/"` by going in the file:

```
sudo nano /etc/php/7.2/apache2/php.ini
```
This was displayed when I opened the webpage again:

```
Component Status
Writeable Custom Directory The Custom Directory exists but is not writeable. You may have to change permissions on it (chmod 766) or right click on it and uncheck the read only option, depending on your Operating System. Please take the needed steps to make the file writeable.
Writable Cache Sub-Directories The files or directories listed below are not writeable or are missing and cannot be created. Depending on your Operating System, correcting this may require you to change permissions on the files or parent directory (chmod 755), or to right click on the parent directory and uncheck the ‘read only’ option and apply it to all subfolders.
Please fix the following files or directories before proceeding:
/home/bro303/public_html/crm/cache/images
/home/bro303/public_html/crm/cache/layout
/home/bro303/public_html/crm/cache/pdf
/home/bro303/public_html/crm/cache/xml
/home/bro303/public_html/crm/cache/include/javascript
```
I ran these commands to set the following recommended permissions on SuiteCRM instance:
```
sudo chown -R , <user name >:< user name > .

sudo chmod -R 755 .

sudo chmod -R 775 cache custom modules themes data upload config_override.php
```
After this the web page opened for making the configurations of database and Site.


**Note:**

* I was getting an error of `database not connected` because every time I build the pipeline, it deletes the older files and creates a new one. So `config.php` file is missing. So copy the file when SuiteCRM installed manually to another place and also in suitecrm instance. and in the pipeline pass the step to copy the config.php file. After it's successfully done the application will be directly deployed by the pipeline.

* To open the config page multiple times in config.php file make the change `installer_locked = True` to `false`.
