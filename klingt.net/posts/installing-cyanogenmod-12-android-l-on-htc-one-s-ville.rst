.. title: Installing Cyanogenmod 12 (Android L) on HTC One S - Ville
.. slug: installing-cyanogenmod-12-android-l-on-htc-one-s-ville
.. date: 2015-01-07 12:16:11 UTC+01:00
.. tags: cm12, cyanogenmod, android, lollipop, htc, ville, easter-egg, installation, guide
.. link:
.. description: How to install Cyanogenmod 12 (Android L) on HTC One S ville.
.. type: text

My old `HTC One S <http://en.wikipedia.org/wiki/HTC_One_S>`_ (ville) is surprisingly one of the first supported devices for Cyanogenmods new version 12 which is great, because I always like to try out new software versions. This guide should make it as easy as possible for anyone else owning an One S to install CM12. Remember that I can't give any guarantees that this will work with your android device and that it's not a useless brick after some of the described installation steps. If you try it, you do this on **your own risk**!

Instructions
------------

The first step should always be to backup your data! Luckily I've never had to restore the data from my backups so I can't say for sure that restoring them will work without problems. There is no vital data on my phone so I don't really care but if you do, use something like `Titanium Backup <https://play.google.com/store/apps/details?id=com.keramidas.TitaniumBackupPro&hl=de>`_.

Preparations
~~~~~~~~~~~~

To install Cyanogenmod you have to unlock your device and install a custom recovery image like `ClockworkMod <http://clockworkmod.com/rommanager>`_ or `TeamWin Recocvery Project (TWRP) <http://teamw.in/project/twrp2>`_. I am using TWRP on my htc. But before you can flash a recovery image you have to unlock your One S by getting an `unlock token for the bootloader from htc-dev <http://htcdev.com/bootloader/>`_. I don't want to explain all the steps, if you haven't unlocked your device already take a look on `this guide <http://wiki.cyanogenmod.org/w/Install_CM_for_ville#Installing_CyanogenMod_from_recovery>`_ from the Cyanogenmod website.


Backup via adb
~~~~~~~~~~~~~~

My method of choice is to backup via `Android Debub Bridge (adb) <http://developer.android.com/tools/help/adb.html>`_ which is part of the `Android SDK <http://developer.android.com/sdk/index.html>`_. The following backup instructions are based on `this xda-developers guide <http://forum.xda-developers.com/galaxy-nexus/general/guide-phone-backup-unlock-root-t1420351>`_.

.. code:: sh

    adb backup -f ./htc_one_s_CM10_2.ab -apk -shared -all

I will explain the backup switches in detail:

- ``-f`` path to the backupfile
- ``-apk`` enable backup of the .apks themselves in the archive
- ``-shared`` enable backup of the device's shared storage / SD card contents;
- ``-all`` means to back up all installed applications

You have to unlock this operation on your device and you will also be asked if you want to set password to encrypt your backup if you like. Note that *not everything* (e.g. pictures, music) on your SD card will be backed up and your SMS, if someone still uses this stone-age technology, will be lost. In addition I had to uninstall `ebookdroid <https://play.google.com/store/apps/details?id=org.ebookdroid&hl=en>`_ first, otherwise the backup will be stuck. In my case the backup process took about 15 minutes until finished but it could take a lot longer depending on the amount of apps and data you've saved on your mobile device.

To restore the backup you have to boot into your android devices bootloader and run ``adb restore /path/to/your/backup.ab`` from your computer.

Install CM12
~~~~~~~~~~~~

At first download the latest  CM12 release from `official cyanogenmod downloads <http://download.cyanogenmod.org/?device=ville>`_ and also a `gapps <http://forum.xda-developers.com/paranoid-android/general/gapps-official-to-date-pa-google-apps-t2943900>`_ bundle. When the download is finished transfer the cyanogenmod and gapps zip-files to the sdcard of your android device. If you forgot to do this you can still copy the zip-files via ``adb push`` to your device or flash them using ``adb sideload``, but this is not part of this guide.

Now it's time to boot into recovery mode, you can do this via ``adb reboot bootloader`` or by pressing and holding the *Volume Down* and *Power* button on reboot.

Make a full system wipe by choosing the *Wipe* Menu in TWRP and *Swipe to Factory Reset*. Now open the *Install* menu and install the Cyanogenmod zip from your sdcard. If this succeeds go back to the *Install* menu and install the gapps zip-file. Don't choose Reboot System, instead go back to *Home*, select *Reboot* and choose *Bootloader*. In the bootloader menu check that you can see a line with red background that shows ``FASTBOOT USB``. Now extract the ``boot.img`` from your cyanogenmod zip-file and flash it via `fastboot <wiki.cyanogenmod.org/w/Doc:_fastboot_intro>`_ onto your device:

.. code:: sh

    ./fastboot flash boot boot.img

If fastboot can't find your device you have to run it using ``sudo``. Select *Reboot* in the bootloader and wait until CM12 finishes the first boot. Be patient it took *about 10 min.* on my device to finish the initial boot!

Some notes about Cyanogenmod 12
-------------------------------

My first impression was that it feels more responsive and fluid than the previous Cyanogenmod versions. Beforehand I was sceptical about the new `material design <https://developer.android.com/design/material/index.html>`_, mainly because every control element looks very uniform on screenshots. The main strength of the new design are the animations, seeing it in action has let disappear my skepticism.

.. image:: /imgs/cm12-desktop.png

Like in previous versions, there is an **easter-egg** when you touch the *Android Version* multiple times in *Settings → About Phone/Tablet* menu.

.. image:: /imgs/cm12-about_phone.png

This time you can play a Flappybird like game when you touch the swipe over the lollipop.

.. image:: /imgs/cm12-easter-egg_1.png

.. image:: /imgs/cm12-easter-egg_2.png

You can enable the *Developer Menu* like usual by touching 7 times on the *Build Number* in the *About Phone/Tablet* menu.

.. image:: /imgs/cm12-developer_menu.png
