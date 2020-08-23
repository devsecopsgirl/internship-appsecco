# Setting up VM

## Objective

The aim of this section is to set up the required infrastructure to perform the task and solve the 1st point of the problem statement under Task 1.

In this section I will be setting up two VMs:
1. For jenkins deployment.
2. For production Server to deploy the application (Odoo) on the server

## Steps for creating VM:

1. Click on the `NEW` icon to create a new machine.
2. `Create Virtual Machine` window will open as shown in the picture.
   
   ![](Images/2020-08-17_23-35.png)

Configure 
* The `Name` Jenkins-infra.
* The `Type` to Linux.
* `Version` to Ubuntu (64-bit).
* Allocate memory size.

Click on Create.

3. `Create Virtual Hard Disk` will open.
   
   ![](Images/2020-08-17_23-38.png)

* Allocate the memory. 
* We will be setting the disk type to `VDI`
* Select storage on physical hard disk `Dynamically allocated`.
* Click create.

And that’s it! Your VM is ready for Ubuntu 18.04 server installation.

TO download the server image 18.04 on VirtualBox as it is an LTS (Long Term Support) version which is a desirable feature for a CI pipeline. Follow the [link](https://releases.ubuntu.com/18.04/)

![](Images/2020-08-18_17-18.png)

**What is LTS?**

1. It is a product lifecycle management policy in which a stable release of computer software is maintained for a longer period of time than the standard edition.
2. The term is typically reserved for open-source software.

## Installation steps for Ubuntu Server 18.04.5

I decided to install the Ubuntu Server 18.04.5 because my system was not able to support the Desktop Image.

In the VM box I selected the VM <Jenkins-infra> to insatll the server.
click on `Start`

![](Images/2020-08-18_22-06.png)

When the window `Select start-up disk` window opens click on the folder.

A new window opens `Optical Disk Selector`. Select the server image and click `Choose`

![](Images/2020-08-18_22-08.png)

Server image is now selected and click on `Start`

![](Images/2020-08-18_22-09.png)

Click on `Start` Jenkins VM start's running.

![](Images/2020-08-18_22-10.png)

The installer is designed to be easy to use and have sensible defaults so for a first install you can mostly just accept the defaults for the most straightforward install.

Begining with installation:

**Language selection**

![](Images/2020-08-18_22-12.png)

This screen selects the language and the default language for the installed system.

Press the `Enter` button.

**Keyboard configuration**

![](Images/2020-08-18_22-13.png)

By default the English (US) layout and variant keyboard is selected.

Press the `Enter` button.

**Network**

![](Images/2020-08-18_22-14.png)

 Configuration of the network is done from here and leave it default if no changes.

 Select `Done` and press `Enter`.

 **Configure proxy**

![](Images/2020-08-18_22-15.png)

The proxy configured on this screen is used for accessing the package repository and the snap store both in the installer environment and in the installed system.

**Mirror**

![](Images/2020-08-18_22-15_1.png)

The installer will attempt to use geoip to look up an appropriate default package mirror for
location. 

**Guided Storage Configuration**

![](Images/2020-08-18_22-16.png)

I kept the storage default and selected `Done`.
Press Enter button.

**Storage Configuration**

![](Images/2020-08-18_22-16_1.png)

Confirm storage configuration.

![](Images/2020-08-18_22-19.png)

Select continue. Press `Enter` to begin the installation.

**Profile Setup**

![](Images/2020-08-18_22-27.png)

Fill the required details. Select `Done` and press the `Enter` button.

**SSH**

![](Images/2020-08-18_22-27_1.png)

Select the option `Install OpenSSH server` because by default Ubuntu does not have SSH server installed. It has only SSH client installed. It is very common practice for administrators to SSH into the Ubuntu server so it's better to install the OpenSSH server here only with one click of a button.

Select `Done` and press the `Enter` button.

**Snaps**

![](Images/2020-08-18_22-28.png)

If a network connection is enabled, a selection of snaps that are useful in a server environment are presented and can be selected for installation.

After that, select `Done` and press `Enter`.

**Installation logs**

![](Images/2020-08-18_22-29.png)

Once the installation is complete, select `Reboot`. Press `Enter`.

Similarly the second VM can be installed.

Here I finished with the installation of `Ubuntu 18.04.05(LTS)` server.
