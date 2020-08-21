# MkDocs: setup and usage

**MkDocs** is a fast, simple and downright gorgeous static site generator that's geared towards building project documentation. Documentation source files are written in Markdown, and configured with a single YAML configuration file.

#### Prerequisite

* Install Git from [here](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
* GitHub Account
* Netlify Account
* MkDocs can be installed from this [link](https://www.mkdocs.org/) as it is official site.
  
#### STEPS 

I made a directory for the report where all images and .md file will be present.

`mkdir mkdocs`

Goto *mkdocs* directory and create a new MkDocs project.

`mkdocs new DevSecOps`

When I did *ls* there were 2 files - *docs*, *mkdocs.yml*

Now to see content of *mkdocs.yml* file 

`cat mkdocs.yml` 

There the *site_name: My Docs* present

I also installed python as the latest version was not present in my system

`pip3 install mkdocs-material`

Now to run the builtin development server

`mkdocs serve`

**I got this error: [Errno 98] Address already in use**

Run `ps -a` to see all the running processes.
Then kill the process by
`kill -9 13897`

(13897 id the process ID)

Again run the `mkdocs serve` command now it was working perfectly fine.

### Depoying the site on github

Made a repository on Gitup *internship-appsecco* and also check the option *Initialize this repository with a README* and private repository and select *Create repository*

Now in the terminal run:

`git init`

`git add .`

`git commit -m "demo1"`

`git pull origin master --allow-unrelated-histories`

`git commit -m "merged unrelated hitories"`

`git push -u origin master`

I can see that the file is pushed on github

When we do `ls` we did not see site folder
docs  mkdocs.yml  README.md

To build site folder we will run 
`mkdocs build --clean`

On doing `ls` we will also see site folder.

Similarly add all the changes made in local system in vscode to git and also every time run `mkdocs build` command before adding the repository.

### Deploying on Netlify:

* Select the option *Add new site*.
* Next select option Git it will start showing all repositories. 
* Select the appsecco-internship repository and then in **Publish directory** column type `site/` and 
* Click on deploy site.
* The site will be deployed now and the link will be available on the screen.