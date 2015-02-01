.. title: Restore GRUB after UEFI upgrade
.. slug: restore-grub-after-uefi-upgrade
.. date: 2015-02-01 13:10:03 UTC+01:00
.. tags: UEFI, BIOS, Arch, Asrock, rEFInd
.. category:
.. link:
.. description: How to restore a broken GRUB installation after UEFI upgrade.
.. type: text

Today was a beautiful sunday morning, so I decided to update the UEFI firmware of my home server. UEFI/BIOS updates are always a bad idea if everything runs smoothly, but that did not stop me from updating the firmware anyway. My home server is based on a `Asrock FM2A85X-ITX <http://www.asrock.com/mb/AMD/FM2A85X-ITX/>`_ motherboard, which is quite nice despite the bad reputation that Asrock boards had in recent years. The UEFI upgrade process was simple, save the binary on a FAT32 formatted USB drive, reboot the system, enter the UEFI menu and you are ready to go. For the utterly brave people, there is an automatic firmware updater in the UEFI menu of this board, that downloads and flashes a new firmware image if an active network connection is available.

After the update process was finished I rebooted the system and got a little heart attack when I saw those horrible words on my screen: ``DISK BOOT FAILURE, INSERT SYSTEM DISK AND PRESS ENTER ...``. The fix was easy if you know what to do, like it always is. At first get the USB flash drive image of `rEFInd <http://www.rodsbooks.com/refind/getting.html>`_ and ``dd`` it on a flash drive:

.. code:: sh

    # check which device is your flash drive
    lsblk -l
    unzip refind-flashdrive-x.x.x.zip
    # check if your usb drive is automounted
    # sdX is the device number of your flash drive
    mount | grep /dev/sdX
    # if it is mounted, unmount it
    sudo umount /dev/sdX
    # x.x.x is the version number of rEFInd
    # don't get the device number wrong or you will be f*cked!
    sudo dd if=./refind-flashdrive-x.x.x/refind-flashdrive-x.x.x.img of=/dev/sdX

Reboot your system and boot from the usb drive which contains the rEFInd image. You should now be able to boot your existing Arch installation (or whatever distro you are using). Boot into your system and check your UEFI boot entries with ``efibootmgr -v``, this should print something like this:

.. code:: sh

    BootCurrent: 0000
    Timeout: 10 seconds
    BootOrder: 0000,0001,0005,0006,0004
    Boot0001* Hard Drive    BIOS(2,0,00)AMGOAMNO........m.K.I.N.G.S.T.O.N. ...
    Boot0004* UEFI: Built-in EFI Shell  Vendor(5023b95c-dcba-429b-a648-abcdefghijkl,)AMBO
    Boot0005* USB   BIOS(5,0,00)AMGOAMNO........k. .P.a.t.r.i.o.t. .M.e.m.o.r.y. .P.M.A.P....................A.......................>..Gd-.;.A..MQ..L. .P.a.t.r.i.o.t. .M.e.m.o.r.y. .P.M.A.P......AMBO
    Boot0006* UEFI:  Patriot Memory PMAP    ACPI(a0341d0,0)PCI(10,0)USB(3,0)HD(1,800,241f,20460472-dcba-411e-baa0-abcdefghijkl)AMBO

In my case ``Boot0000*`` was missing, which was the UEFI boot entry for GRUB. To restore it run:

.. code:: sh

    sudo grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=arch_grub

Because only the entry was missing and my GRUB installation probably works, I've used the existing *bootloader id*. Your bootloader id is the name of the subdirectory in ``/boot/EFI/``, in my case ``arch_grub``. Running ``efibootmgr -v`` again showed me that my missing entry was restored:

.. code:: sh

    Boot0000* arch_grub HD(1,800,1ff801,08a220bf-ac71-462c-bac9-abcdefghijkl)File(\EFI\arch_grub\grubx64.efi)

I hope this helps somebody.
