# DNSMAN ![](https://sajadkamali.ir/public_images/DNS-A.png)
[![Operating System](https://img.shields.io/badge/OS-GNU%20Linux-red)](https://www.gnu.org/home.en.html/) [![Language](https://img.shields.io/badge/Language-Bash%20Script-green)](https://www.gnu.org/software/bash/) [![Licenese](https://img.shields.io/badge/Licenese-GPL%20V3-blue)](https://www.gnu.org/licenses/gpl-3.0.en.html)


**DNSMAN** is an open source bash script project that helps you find public and fast nameservers, based on
your Internet connection speed or your preference. DNSMAN can only be installed on Linux systems.

![Screenshot](https://sajadkamali.ir/public_images/DNSMANN.png)

DNSMAN requires host and dig command to be installed on the computer, which is installed by default on
most of Linux based distros. But in case if you don't have it:

Debian based distros (Ubuntu, Mint and etc..):

    sudo apt install dnsutils -y

RedHat based distros (Fedora, CentOS and etc..):

    sudo yum install bind-utils
    
**Installation:**

To install DNSMAN, firstly you should clone it from [Git](https://github.com/sqlmapproject/sqlmap) repository:

    git clone https://github.com/sajadkamali-ir/dnsman.git


Then run the following commands:

    cd dnsman
    chmod a+x dnsman.sh install.sh uninstall.sh


Now you are ready to install the script:

    sudo ./install.sh
 
 
You are **DONE**! The usage of dnsman is self explanatory.

To run it type sudo dnsman anywhere in you terminal:

        sudo dnsman

In case if you want to uninstall it:

    sudo ./uninstall.sh
 
Enjoy using DNSMAN
