# Setting Up VM

## Objective

This section aims to set up the required infrastructure to perform the task and solve the 1st point of the [problem statement](https://intern-appsecco.netlify.app/problem-statement/) under Task 1.

In this section, I will be setting up two VMs:

1. For Jenkins deployment.
2. For the application(SuiteCRM) server.

## Steps for creating VM

1. I clicked on the `NEW` icon to create a new machine.
2. `Create Virtual Machine` window opened, as shown in the picture.
   
   ![](Images/2020-08-17_23-35.png)

**Configuration**

* The `Name` Jenkins-infra.
* The `Type` to Linux.
* `Version` to Ubuntu (64-bit).
* Allocated memory size(RAM).

Clicked on `Create`.

3. `Create Virtual Hard Disk` will open.
   
   ![](Images/2020-08-17_23-38.png)

* Allocated the storage. 
* Set the default disk type to `VDI(VirtualBox Disk Image)`
* Selected storage on physical hard disk `Dynamically allocated`.
* Clicked on `Create`.

VM is ready for Ubuntu 18.04 server installation.

To download the server image 18.04 on VirtualBox as it is an LTS (Long Term Support) version which is a desirable feature for a CI pipeline. I followed the official link [link](https://releases.ubuntu.com/18.04/).

![](Images/2020-08-18_17-18.png)

**What is LTS?**

1. It is a product life cycle management policy in which a stable release of computer software is maintained for a longer period than the standard edition.
2. The term is typically reserved for open-source software.
3. Ubuntu 18.04 server has 5 years of support.

## Installation steps for Ubuntu Server 18.04

I decided to install the Ubuntu Server 18.04 because my system was not able to support the Desktop Image of Ubuntu 18.04 server.

In the VM box, I selected the VM < Jenkins-infra > to install the server and click on `Start`.

![](Images/jenkins-infra-vm-start.png)

Then the `Select start-up disk` window opened and I clicked on the folder which gave a new screen `Optical Disk Selector`. I selected the server image and clicked on `Choose`.

![](Images/2020-08-18_22-08.png)

Server image is now selected and I clicked on `Start`.

![](Images/2020-08-18_22-09.png)

After clicking on `Start` Jenkins VM starts running.

![](Images/2020-08-18_22-10.png)

The installer is designed to be easy to use and have sensible defaults so for a first install I have mostly just accepted the defaults for the most straightforward installation. Beginning with installation:

**Language selection**

![](Images/2020-08-18_22-12.png)

This screen selects the language. The default language for the installed system is selected as English as I did not want to make changes so pressed `Enter` button.

**Keyboard configuration**

![](Images/2020-08-18_22-13.png)

By default, the English (US) layout and variant keyboard is selected as here also I do not want to make changes, pressed `Enter` button.

**Network**

![](Images/2020-08-18_22-14.png)

 Configuration of the network is done from here and I left it as default because I did not want to do any changes. Selected `Done` and pressed `Enter`.

 **Configure proxy**

![](Images/2020-08-18_22-15.png)

The proxy configured on this screen is used for accessing the package repository and the snap store both in the installer environment and in the installed system. I did not provide any `Proxy address`, kept it default and selected `Done`

**Mirror**

![](Images/2020-08-18_22-15_1.png)

The installer will attempt to use GeoIP to lookup an appropriate default package mirror for your
location. I kept this too as default and selected `Done`  

**Guided Storage Configuration**

![](Images/2020-08-18_22-16.png)

I do not have to make any changes to the storage configuration. So I selected `Done` and 
pressed the `Enter` button.

**Storage Configuration**

![](Images/2020-08-18_22-16_1.png)

Selected `Done` and I did not make any changes.

![](Images/2020-08-18_22-19.png)

Selected `continue` and pressed `Enter` to begin the installation.

**Profile Setup**

![](Images/2020-08-18_22-27.png)

I filled the required details. Selected `Done` and pressed the `Enter` button.

**SSH**

![](Images/2020-08-18_22-27_1.png)

I Selected the option `Install OpenSSH server` because by default Ubuntu does not have an SSH server installed. It has only an SSH client installed. It is very common practice for administrators to SSH into the Ubuntu server so later on, I will also have to SSH to connect the two VMs. It is better to install the OpenSSH server here only with one click of a button.
Selected `Done` and pressed the `Enter` button.

**Snaps**

![](Images/2020-08-18_22-28.png)

If a network connection is enabled, a selection of snaps that are useful in a server environment is presented and can be selected for installation.

After this, selected `Done` and pressed `Enter`.

**Installation logs**

![](Images/2020-08-18_22-29.png)

Once the installation is complete, I selected `Reboot` pressed `Enter` button. Similarly, the second VM can be installed. Here, I finished with the installation of `Ubuntu 18.04(LTS)` server.