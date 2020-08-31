
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
                sh 'ssh -o StrictHostKeyChecking=no production@192.168.1.4 "cd suitecrm && bpm stop apache2"'
                sh 'ssh -o StrictHostKeyChecking=no production@192.168.1.4 "rm -rf suitecrm/ && mkdir suitecrm"'
                sh 'scp -r * production@192.168.1.4:~/suitecrm'
                sh 'ssh -o StrictHostKeyChecking=no production@192.168.1.4 "source ./env.sh && ./env.sh && cd suitecrm && bpm start apache2"'
            }
        }
    }
}
```
### The stages of pipeline

* **git :** 
In this stage git repository of SuiteCRM is cloned. 

* **Build :**
In the build stage, application is built and dependencies are installed using  `composer install` in the build stage on the Jenkins VM. This loads all the dependencies that the app (SuiteCRM) requires.

* **Deploying App to production server:** 
In this stage, the files are deployed from Jenkins to production VM and also removed the files of suitecrm from production server as it might cause conflict in between the files.
