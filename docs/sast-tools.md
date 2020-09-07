# SAST - Dependency Check

## Objective

This section aims to identify suitable tools for SuiteCRM to perform SAST and generate a report to provide a solution to the 7th points of the [problem statement](https://intern-appsecco.netlify.app/problem-statement/) under Task 1.

### SAST

SAST or Static Application Security Testing is a process that analyses a project's source code, dependencies and related files for known security vulnerabilities. SAST could also help identify segments of the project's logic which might lead to a security vulnerability.


## OWASP dependency check

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
After this you will get a report in the Console Output. Now to get the copy of report too add one more step to jenkinsfile.

