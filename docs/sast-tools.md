# SAST - Dependency-Check

## Objective

This section aims to identify suitable tools for SuiteCRM to perform SAST and generate a report to provide a solution to the 7th point of the [problem statement](https://intern-appsecco.netlify.app/problem-statement/) under Task 1.

## SAST

SAST or Static Application Security Testing is a process that analyses a project's source code, dependencies, and related files for known security vulnerabilities. SAST could also help identify segments of the project's logic which might lead to a security vulnerability.

### OWASP dependency check

As mentioned on OWASP Dependency Check's official [site](https://plugins.jenkins.io/dependency-check-jenkins-plugin/), Dependency-Check is a utility that identifies project dependencies and checks if there are any known, publicly disclosed, vulnerabilities.

#### Install the ODC plugin

* Go to `Manage Jenkins` then `Manage Plugins` and under `Available` section search for '`OWASP dependency-check`' and install the plugin.
* After this go to the Global Tool Configuration and under Dependency-Check installations add the Name `OWASP Dependency-Check Plugin`.

#### Jenkins Integration 

In jenkinsfile add a stage before the build stage:
```
stage ('Dependency-Check Analysis'){
            steps {
                dependencyCheck additionalArguments: '', odcInstallation: 'OWASP Dependency-Check Plugin'
            }    
        }
```
After this, I got the report in the `Console Output` after the pipeline is successfully build. Now to get a copy of the report add one more step to jenkinsfile under the `Dependency-Check Analysis` stage, and I also moved the report to the `reports` directory where I will be storing all other reports.

```
dependencyCheckPublisher pattern: 'dependency-check-report.xml' 
sh 'mv dependency-check-report.xml /var/lib/jenkins/workspace/reports' 
```
This will create a `dependency-check-report.xml` report file in the workspace and I can also see in Jenkins the `Dependency-Check Trend` that is a graphical representation of vulnerabilities found in the SuiteCRM application and they are in which category that is critical, high, medium, low or unassigned. Here is the [report](https://github.com/Priyam5/internship-appsecco/blob/master/Reports/dependency-check-report.xml) which generated after OWASP Dependency-Check.

**Note:** I was getting this error `[DependencyCheck] Unable to find Dependency-Check reports to parse` because I was using the latest version 5 of OWASP Dependency-Check Plugin but writing the code according to the v4. The default path for report search was"**/dependency-check-report.xml" in v4 and has changed to "dependency-check-report.xml" in v5.

### Snyk

Snyk is an open-source security platform for finding out vulnerabilities in the source code of an application. A platform that helps monitor (open source) projects present on GitHub, Bitbucket, etc. or locally to identify dependencies with known vulnerabilities. It is available as a CLI and as a docker image. I followed the official [documentation](https://support.snyk.io/hc/en-us/articles/360004032217-Jenkins-integration-overview) snyk because all the steps are explained well. 

#### Install the Snyk plugin
Configure Jenkins settings to install the Snyk Security Scanner plugin: 

* Go to `Manage Jenkins` > `Manage Plugins` > `Available` and search for `Snyk Security`. Install the plugin.
* Go to `Manage Jenkins` > `Global Tool Configuration` and add a `Snyk Installation` to have the Snyk CLI available during Jenkins builds.
* From the Snyk app, retrieve Snyk API token:

    1. From Snyk account, navigate to `Settings` >` General`.

    2. Copy the key
   
* Go to `Manage Jenkins` > `Manage Credentials` > `System` and add a Snyk API Token to allow the Snyk Security Scanner to identify with Snyk. Specify a credential ID value in the ID field (i.e. `snyk-api-token`).
* Use these values:

    *Kind* - Snyk API token

    *Scope* - Global

    *Token* - Snyk API token(key) as retrieved from Snyk account

    *ID* - Enter a name for the token

    *Description* - optional free text
#### Jenkins integration

* From within Jenkins, generate a Snyk Security pipe:

    1. Navigate to the pipeline project and click Pipeline Syntax.
    2. From the Sample Step dropdown, select snykSecurity: Invoke Snyk Security task.
    3. Configure the security task as follows when issues are found select `Let the build continue` display vulnerabilities and details, but allow the build to continue and provide the snyk token.
    4. Click Generate Pipeline Script. The pipe syntax is generated and displayed
  
* In the pipeline add the step under the `Snyk Security` stage before build stage and I also moved the report to the `reports` directory where I will be storing all other reports:
```
stage ('Snyk Security'){
            steps {
                snykSecurity failOnIssues: false, snykInstallation: 'Snyk Security Plugin', snykTokenId: 'snyk-api-token'
                sh 'mv snyk_monitor_report.json /var/lib/jenkins/workspace/reports'
            }    
        }
```
Build the pipeline and the [report](https://github.com/Priyam5/internship-appsecco/blob/master/Reports/snyk_monitor_report.json) is generated. 
