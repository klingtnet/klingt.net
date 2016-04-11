{
    "date": "2014-11-04",
    "description": "A quick guide how I tried to fill some potential security holes on my laptop to prepare it for the 31st Chaos Communication Congress.",
    "slug": "31c3-preparations",
    "tags": "31c3, chaos congress, ccc, preparations, security, firewall, ports, tips",
    "title": "31c3 preparations"
}

I am going to attend at this years [Chaos Communication
Congress](https://events.ccc.de/) for the first time. Because there will
be a lot of <span class="strike">hackers</span> security engineers with
too much spare time and less respect for other peoples data. So I can
recommend, if you also take part at this years congress, to check your
system for potential security leaks. It is also good possibility to
think about encrypting (parts of) your data and setting up or renewing
your passwords.

I am not a security expert, so use the following commands on your own
risk. The sole purpose of this post is to serve as documentation for the
next time I have to check my Arch Linux system for potential security
holes.

open ports
==========

The first thing to do is to *backup your data*, then to scan for open
ports on your machine:

```bash
sudo nmap -sS -sU -sY localhost
```

This scans for open TCP/UDP and SCTP ports. The output should look
something like this:

    Starting Nmap 6.47 ( http://nmap.org ) at 2014-11-04 19:14 CET
    Nmap scan report for localhost (127.0.0.1)
    Host is up (0.000014s latency).
    Other addresses for localhost (not scanned): 127.0.0.1
    rDNS record for 127.0.0.1: localhost.localdomain
    Not shown: 1994 closed ports, 52 filtered ports
    PORT     STATE         SERVICE
    5500/tcp open          hotline
    8000/tcp open          http-alt
    8080/tcp open          http-proxy
    68/udp   open|filtered dhcpc
    123/udp  open          ntp
    5353/udp open|filtered zeroconf

Now we want to know which process belongs to which port, for this task
we need `ps` and `fuser`. Take e.g. port 8000:

```bash
ps -p $(fuser -n tcp 8000)
```

Because I've got a local python httpserver on port 8000 running—to
preview this blog while writing posts—the output doesn't surprise me:

    8000/tcp:
    PID TTY          TIME CMD
    14488 pts/1    00:00:00 python3

You should ask yourself what services from that list are really
essential as well as secure and stop everything that is not. It would be
a bad idea to run a self written web service with root rights on port
80, even if it has a password secured login.

setup a firewall
================

There is an excellent guide how to setup [UFW (Uncomplicated Firewall)
at
digitalocean](https://www.digitalocean.com/community/tutorials/how-to-setup-a-firewall-with-ufw-on-an-ubuntu-and-debian-cloud-server).
UFW is a front-end for iptables and makes the configuration dead easy.

network shares
==============

Now its time to check for open
[samba](http://www.wikiwand.com/en/Samba_%28software%29) or
[NFS](http://www.wikiwand.com/en/Network_File_System).

To look for open samba share use `smbtree -N`, where `-N` surpresses the
password prompt. To disable them, edit your `/etc/samba/smb.conf` or
disable your samba service.

To disable an NFS share, remove or comment out the corresponding line.

quick tips
==========

Raise the bar for thefts a little bit an use a BIOS password for your
laptop, to prevent thieves from bypassing your user password and
accessing your data using a simple boot disk/usb-stick running e.g.
[Knoppix](http://www.knopper.net/knoppix/index-en.html). When you are
once in the BIOS, disable booting from external devices as well.

If you haven't done it already then set a password for your ssh-keys!
Maybe someone steals your machine and has access to your them. I can't
even imagine ...

```bash
ssh-keygen -p -f keyfile
```

You don't have to encrypt your whole harddrive, but at least encrypt
your personal information. I am using
[encfs](https://wiki.archlinux.org/index.php/EncFS) for this, it's a
userspace filesystem and really easy to setup.

Buy/Setup a VPN and enable the automatic VPN connection on your LAN and
wireless interfaces with NetworkManager.

![image](/imgs/network_manager_LAN_vpn.png)

Did I said before that you should *backup your data*? I am using
[ddrescue](http://en.wikipedia.org/wiki/Ddrescue) for this purpose.
