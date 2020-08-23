# MkDocs setup for Report

## Objective

The aim of this section is to create documentation in Markdown and use MkDocs to deploy the documentation generated as a static site in reference to the 3rd point of the problem statement under Task 1.

**MkDocs** is a fast, simple and downright gorgeous static site generator that's geared towards building project documentation. Documentation source files are written in Markdown, and configured with a single YAML configuration file.

## Installing MkDocs:

MkDocs can be installed from this [link](https://www.mkdocs.org/) as it is the official site.  I only referred to the 'Installing MkDocs' section under 'Manual Installation' 

## Selecting a Theme

MkDocs allows users to use various themes to customize the style and look of the site. I saw the various themes provided from [here](https://github.com/mkdocs/mkdocs/wiki/MkDocs-Themes).  I selected the 'Material' theme because I liked the style the way content is displayed. To use this theme with MkDocs, it is required to be installed with pip so, I installed Material theme using the command `pip install mkdocs-material`' as mentioned in the official documentation.

## Getting started with Configuration

In the terminal:

`mkdocs new my-project`

`cd my-project`

Take a moment to review the initial project that has been created in the VScode.

* A single configuration file named mkdocs.yml, and a folder named docs that will contain documentation source files.
* The docs folder just contains a single documentation page, named index.md.
* MkDocs comes with a built-in dev-server to preview the documentation as we work on it.
* Start the server in the same directory as the mkdocs.yml configuration file, by running the mkdocs serve command:

I opened http://127.0.0.1:8000/ in browser, and saw the default home page being displayed:

![](Images/localhost.png)

**YAML file**

```mkdocs.yml```, be present in the root directory of the project that configures the site structure, site title, pages, themes, etc. It is used to define properties for the site.
  1. Theming our documentation
Now change the configuration file to alter how the documentation is displayed by changing the theme. Edit the mkdocs.yml file. My :

        site_name: <DevSecOps>
        nav:
            - Introduction: 'index.md'
            - Contents: 'contents.md'
            - Problem Statement: 'problem-statement.md'
            - Setup of VMs: 'Ubuntu-server-VM-setup.md'
            - Setup of Jenkins: 'Jenkins-installation.md'
            - MkDocs setup for report: 'mkdocs-setup-usage.md'

        theme: material

* site_name: title of the site
* nav:  To add some information about the order, title, and nesting of each page in the navigation header by adding a nav setting.
* theme: The theme we are using.

## Deploying the site on github

Made a repository on Gitup *internship-appsecco* and also check the option *Initialize this repository with a README* and private repository and select *Create repository*

Now in the terminal run:

```git init```

```git add .```

```git commit -m "demo1"```

```git pull origin master --allow-unrelated-histories```

```git commit -m "merged unrelated hitories"```

```git push -u origin master```

I can see that the file is pushed on github

To build site folder we will run 
`mkdocs build --clean`

Similarly add all the changes made in local system in vscode to git and also every time run `mkdocs build` command before adding the repository.

## Deploying on Netlify from Github:

I deployed the site on github because everytime I make the changes I just have to push it to github and from there the report will be live.

* Select the option *Add new site*.
* Next select option Git it will start showing all repositories. 
* Select the appsecco-internship repository and then in **Publish directory** column type `site/`
* Click on deploy site.
* The site will be deployed now and the link will be available on the screen.