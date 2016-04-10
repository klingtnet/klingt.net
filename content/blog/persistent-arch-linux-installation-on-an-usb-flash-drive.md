{
    "date": "2015-03-09",
    "description": "How to do a persistent Arch Linux installation on a USB flash drive.",
    "slug": "persistent-arch-linux-installation-on-an-usb-flash-drive",
    "tags": "Arch, Linux, pendrive, USB, flashs",
    "title": "Persistent Arch Linux installation on an USB flash drive (BIOS)"
}

*Update*: This tutorial was written for BIOS machines. For UEFI
computers (most laptops/desktops since 2013), please refer to the [Arch
Linux UEFI
Guide](https://wiki.archlinux.org/index.php/Unified_Extensible_Firmware_Interface)
to make the USB drive bootable.

Last friday my new USB drive that I ordered from amazon.com, an 64GB USB
3.0 [ADATA
AUV131-64G-RGY](http://www.adata.com/index.php?action=product_feature&cid=1&piid=300),
finally arrived after two weeks of shipping. Those flash drives are much
cheaper than on the german amazon website. I paid about 30€ for this
thing including shipping (there were no additional taxes for orders less
than 40€).

I decided to use around 8GiB from the 59.6 GiB (or 64GB, if you like
powers of ten) for an persistent Arch installation. Almost any USB 2.0
flash drive that I owned in the past was to slow for an usable pendrive
linux, but with USB 3.0 this has changed. Of course, it's much slower
than an SSD but it's fast enough to work with. The main reason for me to
use a pendrive linux was, to make drive images (using
[dd\_rescue](http://www.garloff.de/kurt/linux/ddrescue/)) from my SSD
drives. Those drives have to be unmounted before you can make a reliable
drive image, therefore you have to have an alternative system to boot
from.

If you have an existing Arch installation you can install the
`arch-install-scripts` to get `pacstrap` and `arch-chroot` or you can
boot from the [Arch iso](https://www.archlinux.org/download/) to do the
next steps.

prepare the USB drive
=====================

If the USB drive is already mounted, unmount it first. You can use
`lsblk` to identify the device file and mount point of your flash drive.
Make sure that you use the **correct device file**, in my case it was
`/dev/sdc`, otherwise you will have a very bad day.

partitioning
------------

You can make a persistent installation on the thumb drive with a single
partition, but when you like to use it with Windows machines I recommend
to have at least two partitions. One for the linux root and another data
partition with NTFS or FAT32. I will use three partitions because I like
to have the `/boot` seperate. There are a lots of partitioning tools,
but to make a simple MBR partition table `fdisk` is more than good
enough. Run `fdisk /dev/sdX` (replace `X`) and create a new
`DOS partition table` with three primary partitions. I used 256M for the
first, 8G for the second and the remaining space for partition number
three. Write the parition table on disk and exit `fdisk`.

formatting
----------

A partition is nothing without a file system, I'm using ext4 for the
linux partitions, but the [Flash-Friendly File System
(F2FS)](http://en.wikipedia.org/wiki/F2FS) would might be better suited
for the job. With the `-L` switch you can set disk labels.

``` {.sourceCode .sh}
mkfs.ext4 -L usbboot    /dev/sdX1
mkfs.ext4 -L usbroot    /dev/sdX2
```

You can format the third partition with whatever file system you like,
g.e. `FAT32` if you want to use it in a car stereo.

mount the drive
---------------

Create a directory where you can mount the root partition of the drive,
e.g. `mkdir /mnt/archusbdrive` and mount the root and boot partitions:

``` {.sourceCode .sh}
mount /dev/sdX2 /mnt/archusbdrive
mkdir /mnt/archusbdrive/boot
mount /dev/sdX1 /mnt/archusbdrive/boot
```

installation
============

If you don't need a fancy desktop environment you can stop after the
**base system** section. The installation does not deviate much from the
[official installation
guide](https://wiki.archlinux.org/index.php/Installation_guide).

base system
-----------

-   make sure that you have a working internet connection
-   install the base system on the flash drive root:
    `pacstrap /mnt/archusbdrive base`.
-   generate a filesystem table (using UUIDs `-U`):
    `genfstab -U -p /mnt/archusbdrive >> /mnt/archusbdrive/etc/fstab`
-   move the `block` hook in `/mnt/archusbdrive/etc/mkinitcpio.conf`
    directly behind the `udev` hook: `HOOKS="base udev block ..."`, so
    the initial ramdisk environment can boot your kernel from the flash
    drive
-   change root to `/mnt/archusbdrive`: `arch-chroot /mnt/archusbdrive`
-   set the desired hostname: `echo archusb > /etc/hostname`
-   set your timezone, g.e.
    `ln -s /usr/share/zoneinfo/Europe/Berlin /etc/localtime`
-   uncomment your locales in `/etc/locale.gen` and run `locale-gen`
    afterwards
-   set your preferred locale, g.e.:
    `echo LANG=en_US.UTF-8 > /etc/locale.conf`
-   create the initial ramdisk `mkinitcpio -p linux`
-   set your root password: `passwd`
-   install a bootloader, for GRUB:

``` {.sourceCode .sh}
pacman -S grub
grub-install --target=i386-pc --recheck /dev/sdX
grub-mkconfig -o /boot/grub/grub.cfg
```

-   exit the `chroot`, unmount the partitions `umount /dev/sdX...` and
    reboot your system
-   if you don't need a desktop environment you're done, anyone else can
    continue reading

a desktop environment and more
------------------------------

-   after your machine rebooted and *hopefully* started from from the
    USB drive, login as root
-   check if your internet connection works, if not run `dhcpd`
    -   if you need wifi connectivity consult the [wireless network
        configuration
        guide](https://wiki.archlinux.org/index.php/Wireless_network_configuration)
-   one of the first things to do, is to deactivate the pc speaker (why
    is this activated in the first place?)
-   simply blacklist the kernel module:
    `echo "blacklist pcspkr" > /etc/modprobe.d/nobeep.conf`
-   in the next steps we will add a user, add him to the `wheel`
    group (sudoers) and install `lightdm` as well as `xfce4`

### desktop environment

-   at first we install all the packages we need:
    -   depending on your video card you can only install
        `xf86-video-MANUFACTURER`, g.e. `xf86-video-intel` or the meta
        package `xorg-drivers` (this will also include the input device
        drivers from the next step)
    -   I also had to install `xf86-input-synaptics` to get my touchpad
        to work
    -   xfce is available in the meta package `xfce4` and a collection
        of panel extensions in the `xfce4-goodies` package (which I
        recommend to install, because it includes
        [whiskermenu](http://gottcode.org/xfce4-whiskermenu-plugin/)
        amongst others)
    -   I've chosen to install `lightdm` as display manager, with
        `lightdm-gtk-greeter` for the login screen and `xscreensaver` or
        `light-locker` (the last one won't work w/o a small modification
        of `xflocker4`) to get a lock screen in xfce
    -   to synchronize your clock with an `ntp` server you will need the
        same-titled package
-   in summary:
    `pacman -S xorg-drivers xfce4 xfce4-goodies lightdm lighdm-gtk-greeter xscreensaver ntp vim`
    (everybody needs vim, or emacs if you will)
-   now we have to activate some services on startup:
    `systemctl enable lightdm ntpd`

### your user account

-   add a user: `useradd --create-home YOURNAME`
-   enter your new password: `passwd YOURNAME`
-   add yourself to the `wheel` group:
    `usermod --append --groups wheel YOURNAME`
-   to get sudo access with your `wheel` user, run `visudo` and
    uncomment the following line: `%wheel ALL=(ALL) ALL` (line 76 on
    my machine)
-   reboot your machine a last time and the login screen should appear

Have fun with your pendrive Arch system!
