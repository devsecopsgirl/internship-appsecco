# Code Quality Analysis 

## Objective

This section aims to perform a linting check on the source code of SuiteCRM and generate a report to provide a solution to the 10th point of the [problem statement](https://jenkins-report.netlify.app/problem_statement/) under Task 1.

## Code Linting

Linting is the automated checking of source code for programmatic and stylistic errors. This is done by using a linting tool. A lint tool is a basic static code analyzer. Linting is important to reduce errors and improve the overall quality of code. Using lint tools can help accelerate development and reduce costs by finding errors earlier. Linting tools are language-specific and thus, the tool that can be used depends on the application being tested. Nowadays, we have different linters, which provide many types of checks like syntax errors, code standards adherence, potential problems, security checks. 

## Linting tools for SuiteCRM

Code Quality Analysis tools are language-specific. So for SuiteCRM which are meant for PHP applications. The tool I used is PHP Code Sniffer (PHPCS) there are many other tools available.

## PHP Code Sniffer

PHP_CodeSniffer is a set of two PHP scripts; the main phpcs script that helps to detect violations of pre-defined coding standards and a second phpcbf script that can automatically correct those violations.
PHP_CodeSniffer is an essential development tool that ensures code remains clean and consistent. I followed [this](https://github.com/squizlabs/PHP_CodeSniffer#about) GitHub documentation. And I will only go with phpcs I was only concerned with identifying the linting issues therefore skipped the second script.

### Code Sniffer for SuiteCRM

In the Jenkins VM firstly I installed PHPCS for Code Quality Analysis, I downloaded only the `phpcs.phar` files for the scanner with the command mentioned below. I also tried to git clone and download the PHP_CodeSniffer source but in this phpcs and phpcbf files were not present separately.
```
curl -OL https://squizlabs.github.io/PHP_CodeSniffer/phpcs.phar
```
I made it executable with `chmod` and moved it to `/usr/local/bin` for it to be accessible by all system users. 
```
chmod +x phpcs.phar
mv phpcs.phar /usr/local/bin/phpcs
```
After this I ran `phpcs` on the SuiteCRM project directory
```
phpcs /var/lib/jenkins/workspace/suitecrm-pipeline
```
Note: The cursor was getting stuck and there was no output so I ran a single PHP file with the above command. It generated the output table. It was getting stuck due to the issue of memory run out of free memory since PHPCS was not able to scan the whole project directory at once. I generated a python script `python3_phpcs.py` to identify all PHP files present in the SuiteCRM project directory and ran PHPCS on the files individually.

```
#!/usr/bin/python3

import os
import sys

print('[+] Starting scan with PHP Code Sniffer...')

try:
    BASE_PATH = sys.argv[1]

except IndexError:
    print('[-] Path not supplied...')
    sys.exit(1)

paths = [BASE_PATH]
php_files = []

print('[+] Scanning directory for PHP files...')
while paths != []:
    base_path = paths.pop()

    try:
        with os.scandir(base_path) as entries:
            for entry in entries:
                if entry.is_file():
                    if entry.name.endswith('.php'):
                        php_files.append(os.path.join(base_path, entry.name))
                else:
                    paths.append(os.path.join(base_path, entry.name))

    except PermissionError:
        print(f'[-] Could not open {base_path} due to insufficient permission...')

print('[+] Scan completed...')

print('[+] Running PHPCS on PHP files...')
try:
    for php_file in php_files:
        print(f'[+] Scanning {php_file}')
        os.system(f'phpcs {php_file} >> /var/lib/jenkins/workspace/reports/phpcs-report-suitecrm')
    print(f'[+] {len(php_files)} PHP files scanned...')
    print('[+] Code Quality Report generated...')

except KeyboardInterrupt:
    print('[-] Exiting...')

```
### Jenkins Integration

At last, I added a stage in the pipeline to execute the Python script by supplying it with the path of the project directory to scan.
```
stage ('Code Snnifer for linting'){
            steps {
                sh 'python3 python3_phpcs.py /var/lib/jenkins/workspace/suitecrm-pipeline'
            }
        }
```

I got an error after the build of pipeline `permission denied` for not able to access the reports directory so I ran the below command
```
sudo chown -R jenkins:jenkins reports/
```

The report that was generated of Code Sniffer for SuiteCRM after the pipeline build successfully is [here](https://github.com/Priyam5/internship-appsecco/tree/master/Reports/phpcs-report-suitecrm).