.. title: UFW and Samba-which ports to enable?
.. slug: ufw-and-samba-which-ports-to-enable
.. date: 2014-11-18 19:46:02 UTC+01:00
.. tags: samba, smb, ufw, ports, firewall
.. link:
.. description: How to open the ports needed by samba for an specific address range in ufw.
.. type: text

After setting up a iptables firewall using `ufw <https://wiki.archlinux.org/index.php/Uncomplicated_Firewall>`_ on every of my linux machines, I forgot to enable the ports that were used by samba. The first question that came to my mind was, what are the ports that my samba server uses and which of them should be opened? A quick google search revealed this `samba port usage <https://wiki.samba.org/index.php/Samba_port_usage>`_ guide from the official documentation. The solution to get the used ports is netstat with its famous `-tulpn` switch and `egrep`:

.. code:: sh

    netstat -tulpn | egrep "samba|smbd|nmbd|winbind"

This should show you that ``smbd`` is listening on TCP ports **445** and **139** and ``nmbd`` (NetBIOS nameserver daemnon) that listens on the UDP ports **137** and **138**. I've only opened the TCP ports, which is enough to access the samba server from my laptop that is running Arch. But if you are running a windows machine it could be possible that you also have to activate the UDP ports from the NetBIOS daemon. To make sure that the ports are only openend for machines inside my local network I have to use the from directive [1]_:

.. code:: sh

    ufw allow proto tcp from 10.10.10.0/24 to any port 139
    ufw allow proto tcp from 10.10.10.0/24 to any port 445

That's all, samba should be working!

----

.. [#] If your router doesn't forward these ports it's also possible to allow them for any machine. But that's where the tin foil hat comes into play 😁.