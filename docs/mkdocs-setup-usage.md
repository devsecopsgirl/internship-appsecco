# Setting Up MkDocs for Report

## Objective

This section aims to create documentation in Markdown and use MkDocs to deploy the documentation generated as a static site and solve the 3rd point of the [problem statement](https://intern-appsecco.netlify.app/problem-statement/) under Task 1.

**MkDocs** is a fast, simple, and static site generator that is geared towards building project documentation. Documentation source files are written in Markdown, and configured with a single YAML configuration file.

## Installing MkDocs

MkDocs can be installed from this official site [link](https://www.mkdocs.org/). I only referred to the 'Installing MkDocs' section under 'Manual Installation'. 

## Selecting a Theme

MkDocs allows users to use various themes to customize the style and look of the site. I saw the various themes provided from [here](https://github.com/mkdocs/mkdocs/wiki/MkDocs-Themes).  I selected the 'Material' theme because I liked the style of the displayed content. To use this theme with MkDocs, it is required to be installed with pip so, I installed Material theme using the command `pip install mkdocs-material`' as mentioned in the official documentation.

## Getting started with Configuration

In the terminal:

```
mkdocs new my-project
```

```
cd my-project
```

The initial project that has been created in the VS Code:

* A single configuration file named `mkdocs.yml`, and a folder named `docs` that will contain documentation source files.
* The docs folder just contains a single documentation page, named `index.md`.
* MkDocs comes with a built-in dev-server to preview the documentation as we work on it.
* Start the server in the same directory as the `mkdocs.yml` configuration file, by running the `mkdocs serve` command:

I opened `http://127.0.0.1:8000/` in the browser, and saw the default home page.

**YAML file**

`mkdocs.yml`, is present in the root directory of the project that configures the site structure, site title, pages, themes, etc. It is used to define properties for the site.

Now change the configuration file to alter how the documentation is displayed by changing the theme. Edit the `mkdocs.yml` file. My `mkdocs.yml` is as shown:

        site_name: <DevSecOps>
        nav:
            - Introduction: 'index.md'
            - Contents: 'contents.md'
            - Problem Statement: 'problem-statement.md'
            - Setup of VMs: 'Ubuntu-server-VM-setup.md'
            - Setup of Jenkins: 'Jenkins-installation.md'
            - MkDocs setup for report: 'mkdocs-setup-usage.md'

        theme: material

* `site_name`: Title of the site
* `nav`:  To add some information about the order, title, and nesting of each page in the navigation header by adding a nav setting.
* `theme`: The theme we are using.

## Pushing Code to GitHub

I made a repository on GitHub `internship-appsecco` and also checked the option's `Initialize this repository with a README` and `private repository` and after that select the option `Create repository`.

Now in the terminal, I ran:

```
git init
mkdocs build
git add .
git commit -m "Initial Commit"
git push -u origin master
```

I can see that the MkDocs files are pushed into GitHub.

## Building the MkDocs Site

To serve the documentation files as a website, I have to build the site. Building the site will convert the documentation in Markdown format as a site with HTML and CSS and store it in a folder named `site` in the same directory as `mkdocs.yml` file.

I ran the below command to build the site from the parent directory (same as `mkdocs.yml`),
```
mkdocs build --clean
```

## Deploying on Netlify from Github

I deployed the site on Github because every time I make the changes, I just have to push it to GitHub and from there the report will be live on a website.

* Selected the option `Add new site` on [Netlify](https://www.netlify.com/).
* Clicked on `Add A New Project`
* A screen will open, select the option `1.Connect to Git provider` under `Create a new site` and select `GitHub` under `Continuous Deployment`
* After this Authorize Netlify.
* It will start showing all repositories. 
* I Selected the `appsecco-internship` repository and then in **Publish directory** column type `site/`
* Click on `deploy site`.
* The site will be deployed now and the link will be available on the screen which is used to view our [report](https://intern-appsecco.netlify.app/).