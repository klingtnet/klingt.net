{
    "date": "2014-11-18",
    "description": "How to open the ports needed by samba for an specific address range in ufw.",
    "slug": "ufw-and-samba-which-ports-to-enable",
    "tags": "samba, smb, ufw, ports, firewall",
    "title": "UFW and Samba - which ports to enable?"
}

After setting up a iptables firewall using
[ufw](https://wiki.archlinux.org/index.php/Uncomplicated_Firewall) on
every of my linux machines, I forgot to enable the ports that were used
by samba. The first question that came to my mind was, what are the
ports that my samba server uses and which of them should be opened? A
quick google search revealed this [samba port
usage](https://wiki.samba.org/index.php/Samba_port_usage) guide from the
official documentation. The solution to get the used ports is netstat
with its famous `-tulpn` switch and `egrep`:

```bash
netstat -tulpn | egrep "samba|smbd|nmbd|winbind"
```

This should show you that `smbd` is listening on TCP ports **445** and
**139** and `nmbd` (NetBIOS nameserver daemon) listens on the UDP ports
**137** and **138**. I've only opened the TCP ports, which seems to be
enough to access the samba server from my laptop that is running Arch
Linux. <span
class="strike">But if you are running a windows machine it could be possible that you also have to activate the UDP ports from the NetBIOS daemon</span>.
To make sure that the ports are only openend for machines inside my
local network I have to use the `from` directive \[1\]\_:

```bash
ufw allow proto tcp from 10.10.10.0/24 to any port 139
ufw allow proto tcp from 10.10.10.0/24 to any port 445
```

That's all, samba should be working!

Updates
=======

-   *2014-11-22* It works on my Windows machine as well, even without
    the UDP ports that `nmbd` uses.

