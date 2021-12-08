# Download and installation

## Hardware Requirements

- Computer with x86_64 CPU
- Memory: min 2GB, recommended 4GB+
- Recommended storage: 15GB+ hard drive or SSD (operating system and programs), 10-∞GB (user data)
- 2GB+ USB drive or DVD-R for the installation media


## Download

**[![](download.png) Download](https://github.com/nodiscc/debian-live-config/releases/download/3.0.0/dlc-3.0.0-debian-bullseye-amd64.hybrid.iso)** the latest ISO image

(Recommended) verify file integrity and authenticity with GPG:

```bash
# download the iso, signing key, checksums and signature
wget https://github.com/nodiscc/debian-live-config/releases/download/3.0.0/dlc-3.0.0-debian-bullseye-amd64.hybrid.iso
wget https://github.com/nodiscc/debian-live-config/releases/download/3.0.0/dlc-release.key
wget https://github.com/nodiscc/debian-live-config/releases/download/3.0.0/SHA512SUMS
wget https://github.com/nodiscc/debian-live-config/releases/download/3.0.0/SHA512SUMS.sign
# import the release signing key
# the key used to sign releases has key ID EE73FC8FD71E3CC83606FDF361B23168A539DBBD
gpg --import dlc-release.key
# verify that checksums are authentic
gpg --verify SHA512SUMS.sign
# verify integrity of the ISO image
sha512sum -c SHA512SUMS
```


## Write the bootable media

#### To USB - From Linux

  * Insert a 2GB+ USB drive
  * Right-click the ISO image file, and click `Open with ... > Disk image writer` (requires [gnome-disks](https://packages.debian.org/bullseye/gnome-disk-utility)) **Caution, all data on the USB drive will be erased**
  * Or, using the command line: Identify your USB drive device name (eg. `/dev/sdc`) using the `lsblk` command; Write the ISO image to the drive using `sudo dd /path/to/live-image.iso /dev/sdXXX`.

![](https://i.imgur.com/1fYOBty.png)


#### To USB - From Windows

  * Insert a blank 2GB+ USB drive
  * Download [win32diskimager](http://sourceforge.net/projects/win32diskimager/files/latest/download), extract it in a directory, then run the program.
  * `Image file`: select your ISO image.
  * `Device`: Select your USB drive's drive letter.
  * Press `Write`. **Caution, all data on the USB drive will be erased**

![](https://a.fsdn.com/con/app/proj/win32diskimager/screenshots/Win32DiskImager-1.0.png/max/max/1)


#### To DVD

  * Select "burn a disk image" in your disk burning utility (Windows: [InfraRecorder](http://infrarecorder.org/?page_id=5))


#### Virtualization

You can also run the system in a virtual machine on top of your existing system. In that case writing a bootable drive is not needed and you can simply load the `.iso` file in the virtual machine's CD drive. Free and open-source virtualization software includes [virt-manager](https://stdout.root.sx/docs/virt-manager.md) (Linux) or [VirtualBox](https://www.virtualbox.org) (Linux/MacOS/Windows).

<!-- TODO virtualbox/virt-manager screencast -->


## Boot the ISO

- Turn your computer off. Insert the bootable USB/DVD, and turn it back on.
- The boot menu will be displayed, allowing you to install the operating system or run it in Live mode.

💥 If your computer does not boot to the DVD/USB, check that [BIOS/EFI boot configuration](http://www.makeuseof.com/tag/enter-bios-computer/) utility is configured to boot from CD/DVD or USB.

💥 On some computers you need to [disable secure boot](https://neosmart.net/wiki/disabling-secure-boot/) before installing a Linux distribution.

<!-- TODO boot menu screenshot -->


## Run the live system

A live system runs entirely in memory and allows you to use the operating system without installing it to your machine.

No changes to the Live filesystem are kept after reboot, (eg. files in user directories), the system will reset to it's original state when the computer is powered off/rebooted. Changes to files/directory on other drives (external/USB drive, existing fixed disk...) attached to the computer _will_ be kept - save your work there if you need to keep your changes.

The screen will lock after 5 minutes of inactivity during the live session. The passord to unlock it is `live`.

See **[Usage](usage.md)**

<!-- TODO screencast -->


## Install the system to disk

Select `Graphical install` from the boot menu to install a permanent copy a of the system to your hard drive. Follow instructions from the installer.

💥 The default drive partitioning configuration overwrites any previously installed operating system/data on the selected installation disk. To preserve your data, use manual partitioning in the installer, install to an empty disk, or backup your data to an external drive if needed.

<!-- TODO screencast -->

