# Debian-Titus

Debian customizations by Chris Titus Tech for an enhanced Debian experience.

## Overview

This repository contains a set of customizations and scripts to transform Debian into a powerful, developer-friendly environment. These customizations are based on Debian SID (Unstable) Branch.

## Prerequisites

- A fresh Debian installation using the **Debian Testing netinstall** image.
- Internet access to download required packages and firmware.

### Download Debian Testing netinstall

Download the appropriate Debian ISO from the following link: 
<https://cdimage.debian.org/cdimage/weekly-builds/amd64/iso-cd/>

**Note**: Do NOT download the mac/EDU version, as it includes non-free firmware.

## Installation

To install Debian-Titus customizations, open a terminal and run the following commands:

```
git clone https://github.com/ChrisTitusTech/debian-titus
cd debian-titus
sudo ./install.sh
```

This will clone the repository, navigate to the project directory, and execute the `install.sh` script with administrative privileges. The script will apply the customizations and install additional packages.

## Post-Installation

After the installation is complete, restart your system for the changes to take effect. You can now enjoy an enhanced Debian experience, tailored by Chris Titus Tech.

For more information or support, visit the [Chris Titus Tech Github repository.](https://github.com/ChrisTitusTech/debian-titus)
