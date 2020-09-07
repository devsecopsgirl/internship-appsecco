# SAST - Dependency-Check

## Objective

This section aims to identify suitable tools for SuiteCRM to perform SAST and generate a report to provide a solution to the 7th point of the [problem statement](https://intern-appsecco.netlify.app/problem-statement/) under Task 1.

## SAST

SAST or Static Application Security Testing is a process that analyses a project's source code, dependencies, and related files for known security vulnerabilities. SAST could also help identify segments of the project's logic which might lead to a security vulnerability.

### OWASP dependency check

As mentioned on OWASP Dependency Check's official [site](https://plugins.jenkins.io/dependency-check-jenkins-plugin/), Dependency-Check is a utility that identifies project dependencies and checks if there are any known, publicly disclosed, vulnerabilities.

I installed the plugin:

* Go to `Manage Jenkins` then `Manage Plugins` and under `Available` section search for '`OWASP dependency-check`' and install the plugin.
* After this go to the Global Tool Configuration and under Dependency-Check installations add the Name `OWASP Dependency-Check Plugin`.

In jenkinsfile add a stage before the build stage:
```
stage ('Dependency-Check Analysis'){
            steps {
                dependencyCheck additionalArguments: '', odcInstallation: 'OWASP Dependency-Check Plugin'
            }    
        }
```
After this, I got the report in the `Console Output` after the pipeline is successfully build. Now to get a copy of the report add one more step to jenkinsfile under the `Dependency-Check Analysis` stage.

```
dependencyCheckPublisher pattern: 'dependency-check-report.xml'  
```
This will create a `dependency-check-report.xml` report file in the workspace and I can also see in Jenkins the `Dependency-Check Trend` that is a graphical representation of vulnerabilities found in the SuiteCRM application and they are in which category that is critical, high, medium, low or unassigned.

**Note:** I was getting this error `[DependencyCheck] Unable to find Dependency-Check reports to parse` because I was using the latest version 5 of OWASP Dependency-Check Plugin but writing the code according to the v4. The default path for report search was"**/dependency-check-report.xml" in v4 and has changed to "dependency-check-report.xml" in v5.

### Snyk

Snyk is an open-source security platform for finding out vulnerabilities in the source code of an application. A platform that helps monitor (open source) projects present on GitHub, Bitbucket, etc. or locally to identify dependencies with known vulnerabilities. It is available as a CLI and as a docker image.

#### Global Configuration
Configure your Jenkins settings to install the Snyk Security Scanner plugin: 

* Go to Manage Jenkins > Manage Plugins > Available and search for Snyk Security. Install the plugin.