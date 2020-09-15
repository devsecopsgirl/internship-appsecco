# Software Bill of Materials

## Objective

This section aims to generate a Software Bill of Materials for SuiteCRM and generate a report to provide a solution to the 9th point of the [problem statement](https://intern-appsecco.netlify.app/problem-statement/) under Task 1.

## Software Bill of Materials

A software bill of materials is a list of all the open-source and third-party components which are present in a codebase. A software BOM also lists the licenses that govern those components, the versions of the components used in the codebase, and their patch status. In this [documentation](https://www.synopsys.com/blogs/software-security/software-bill-of-materials-bom/) Software Bill of Materials is very well described.

## CycloneDX

CycloneDX is a tool of lightweight software bill of materials (SBOM) specification designed for use in application security contexts and supply chain component analysis. SuiteCRM, like most other applications, is built with various dependencies. So I used CycloneDX to generate the SBOM for SuiteCRM, According to its [documentation](https://github.com/CycloneDX/cyclonedx-php-composer), it is a tool that creates the SBOM which contains the aggregate of all the dependencies for the application.

CycloneDX is available to use a PHP package that can generate SBOMs for PHP applications but also comes in a variety of implementations that can be found [here](https://cyclonedx.org/tool-center/) to serve projects which use different stacks such as Auditjs, Python, Maven, .NET, PHP, etc. For my application, I went with the PHP package as SuiteCRM utilizes PHP Composer.

## Generating SBOM for SuiteCRM

For generating SBOM I started with installing CycloneDX plugin for php-composer by following the official [documentation](https://github.com/CycloneDX/cyclonedx-php-composer). I used the below command for installation in my Jenkins VM.
```
composer require --dev cyclonedx/cyclonedx-php-composer
```
Then I ran CycloneDX, with the command mentioned below, to check the output and figure out the structure of the SBOM generated as an XML file:
```
composer make-bom
```

## Jenkins integration of SBOM

I added a stage in the Jenkins Pipeline where I commented out SAST analysis steps just to avoid the pipeline do not take much time and added a stage for `Generating SBOM`.

```
stage ('Generating SBOM'){
            steps {
                sh 'composer require --dev cyclonedx/cyclonedx-php-composer'
                sh 'composer make-bom'
            }
        }
```

## SBOM for SuiteSRM

CycloneDX generated an XML format comprehensive report for SuiteCRM. In this report, it mentioned the components type, group, name, version, description, licenses, Persistent URL(PURL). The report which got generated is [here](https://github.com/Priyam5/internship-appsecco/blob/master/Reports/bom.xml).