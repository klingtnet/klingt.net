{
    "lastmod": "2016-04-10",
    "date": "2016-03-05",
    "description": "The setup of my netcup vServer that runs Arch Linux, Docker and Caddy.",
    "slug": "my-netcup-server-with-arch-linux-docker-and-caddy",
    "tags": "netcup, caddy, arch, linux, server, docker, systemd",
    "title": "My netcup server setup with Arch Linux, Docker and Caddy"
}

- login into the [vservercontrolpanel (vcp)](vservercontrolpanel.de)
- select your vServer
- open the `Image` tab
- select `Arch Linux` image and follow the instructions
- wait for the confirmation email
- ssh into the server with the given password `root@IP`
- update pacman-keys:
    - intialize pacman-keys: `pacman-key --init`
    - initialize dirmngr: `dirmngr < /dev/null`
    - update pacman-keys: `pacman-keys --refresh`
- update the system: `pacman -Syu`
- install vim: `pacman -S vim ncurses` (or install emacs, or whatever you're up to)
- **IMPORTANT** re-allow rootlogin after the system update (we disable it later):
    - add `PermitRootLogin yes` to your `/etc/ssh/sshd_config`
    - restart the sshd service: `systemctl restart sshd`
- [set the locale](https://wiki.archlinux.org/index.php/locale) to ~~english~~ the desired language:
    - uncomment your language in `/etc/locale.gen`
    - run `locale-gen`
    - set the value of `LANG` in `/etc/locale.conf`
    - relogin or reboot
- **NOTE** don't logout from your root session until you've setup your user and checked if `sudo`ing works
- add a user with sudo capabilities `useradd -m -g users -G wheel -s /bin/bash NAME`
- **IMPORTANT** allow sudo for wheel-group users:
    - run `visudo`
    - uncomment: `%wheel ALL=(ALL) ALL`
    - quit `:wq`
- set a password for your user: `passwd NAME`
- generate an SSH keypair if you don't have one: `ssh-keygen -b 4096`
    - enter a passphrase
    - *NOTE*: you can omit the `~/.ssh/keyname` if you want to use the default `~/.ssh/id_rsa`
    - you can change key name if you want: `vim ~/.ssh/keyname` and replace the `user@host`
- copy the key to your server: `ssh-copy-id -i ~/.ssh/keyname  NAME@SERVER`
- try to login: `ssh NAME@SERVER` and check if sudo works: `sudo echo foo`
- if everything works fine disable the root login for SSH:
    - change `PermitRootLogin yes` to `no`
- disable password based login:

```ini
PasswordAuthentication no
ChallengeResponseAuthentication no
# UsePAM no
# You don't have to disable PAM but it can't do much useful w/o
# password based login.
# Details: http://mail-index.netbsd.org/tech-security/2009/01/04/msg000153.html
```

- I personally also change the SSH daemon port to something different than 22
- update your `~/.ssh/config` with a section for your server:

```
Host SHORTNAME
  Hostname IP_OR_DOMAIN
  Port 22 # or the port you've set
  User NAME
  IdentityFile ~/.ssh/keyname
  Compression yes
```

- check out if the `Host` setting works: `ssh SHORTNAME`
- restart sshd `systemctl restart sshd`
- **NOTE** now you can logout from your session and use your user account
- set your hostname: `hostnamectl set-hostname myhostname`
- if you want to look like a *Le4d h4x0R* setup a `motd`:
	- the `motd` content will be shown everytime you login via ssh for an interactive session
	- here is an example for `/etc/profile.d/motd.sh`:

```sh
#!/bin/sh

# if you have an ASCII art logo, insert it below
#cat /etc/profile.d/logo
cat <<HEREDOC

HOSTNAME.... $(hostname)
SYSTEM...... $(uname --operating-system --kernel-name --machine --kernel-release)
UPTIME...... $(uptime --pretty)

$(df --local --exclude-type=tmpfs --exclude-type=devtmpfs --human-readable --total)

HEREDOC
```

- the intial partition layout of your server should look like this:

```
sr0     11:0    1 1024M  0 rom  
vda    254:0    0  117G  0 disk 
├─vda1 254:1    0  1.4G  0 part 
├─vda2 254:2    0 18.6G  0 part /
└─vda3 254:3    0   97G  0 part 
```

- like you can easily see, the largest partition `vda3` is not mounted
    - ~~I don't really know what the purpose of `vda1` is, clearly it's not mounted as `/boot`.~~ Well, I don't wan't to mess with it right now ...
    - Ok, `lsblk --fs` solved the mystery, it's a swap partition
- `vda3` is not formatted with a filesystem, I am going to format it with `ext4`
    - you can choose whatever filesystem you like (`btrfs`, anyone?) but `ext4` is rock stable. I never had any problems with `ext4` partitions, even after power failures.
    - `sudo mkfs.ext4 -L home /dev/vda3`
- get the UUID of vda3: `lsblk -o UUID /dev/sda3`
- edit your `/etc/fstab`:
    - **NOTE**: `rw,relatime,data=ordered` options are equal to `defaults`

```
UUID=uuid-of-vda2  /       ext4    defaults   0 2
UUID=uuid-of-vda3  /home   ext4    defaults   0 2
UUID=uuid-of-vda1  none    swap    defaults   0 0
```

- **IMPORTANT** we don't want to lose the content of `/home`, therefore we have to copy its contents to the temporary mount location of vda3
- `TMPDIR=$(mktemp -d) && sudo mount --uuid 6f0201b8-ba47-4e0d-814f-ec8075a0736c $TMPDIR && echo $TMPDIR`
- `sudo cp -vpr /home/* $TMPDIR`
- check if everything was copied and the permissions were preserved
- unmount the partition: `sudo umount $TMPDIR`
- reboot: `sudo reboot 0`
- install an AUR helper, I recommend `pacaur`:
    - check if the packages to build AUR stuff are installed: `pacman -S --needed base-devel`
    - download the latest snapshot of cower/pacaur and install them:

```sh
curl --Ls 'https://aur.archlinux.org/cgit/aur.git/snapshot/cower.tar.    ¬gz' | tar -C /tmp -xvzf -
cd cower
makepkg -sri
# if a key is missing, install it with `gpg --search-keys KEYID`
cd ..
rm -r cower
curl --Ls 'https://aur.archlinux.org/cgit/aur.git/snapshot/pacaur.tar.gz' | tar -C /tmp -xvzf -
cd pacaur
makepkg -sri
cd ..
rm -r pacaur
```

- check if `pacaur` works: `pacaur -Syu`

## Install Caddy Webserver

- luckily there is an AUR package: `pacaur -S caddy`
- add yourself to the http group: `sudo usermod -a -G http $USER`
    - **NOTE**: the change is only visible after your next login
- check if you're in the `http` group: `groups | grep http`
- setup the folder for your Caddyfile: `mkdir ~/.caddy && chmod o-x ~/.caddy && sudo ln -s ~/.caddy /etc/caddy`
- create a directory for your website content: `mkdir -p ~/sites/some.domain && chmod -R o-x ~/sites` 
- edit your Caddyfile: `vim ~/.caddy/caddy.con` (you can also manage it with git if like):

```ini
some.domain {
    root /home/USER/sites/some.domain
    markdown
}
```

- add a index file to server: `echo '#Hi!' > ~/sites/some.domain/index.md`
- set `vim` (or something else) as default editor:
    - `sudo echo 'EDITOR=vim' >> /etc/environment`
- edit the service file of caddy: `sudo systemctl edit caddy`
- add the following lines (this overwrites the default setting):

```ini
[Service]
User=
User=NAME
ExecStart=
ExecStart=/usr/bin/caddy -conf="/etc/caddy/caddy.conf" -agree=true -email="admin@some.domain"
```

- reload the systemctl daemon: `sudo systemctl daemon-reload`
- start caddy via `systemctl`: `sudo systemctl start caddy`
- check if caddy serves your domain, if not, view the logs: `journalctl -xfu caddy`
- enable caddy to start automatically: `sudo systemctl enable caddy`

## Setup syncthing

- install it: `pacman -S syncthing`
- configure a password for the syncthing GUI:
	- use ssh port-forwarding to forward the remote syncthing port to your local machine: `ssh -L 9999:localhost:8384 some.domain` 
	- start syncthing: `systemctl start syncthing@$USER`
	- open `localhost:9999` in your local browser and setup the password
	- you can also disable `Open Browser` and `Enable UPnP`
- add a proxy directive for syncthing to your some.domain configuration in `caddy.conf`:

```ini
some.domain {
	# ...

	# you could also use configure a subdomain
	# (by adding a CNAME Record in your DNS config)
	#like sync.some.domain and add the proxy directive there
	proxy /syncthing/ localhost:8384 {
			without /syncthing
			proxy_header Host {host}
			proxy_header X-Real-IP {remote}
			proxy_header X-Forwarded-Proto {scheme}
	}
}
```

- restart caddy `systemctl restart caddy` or send `USR1` signal: `pkill --signal USR1 caddy` to cause a config reload

## Run gogs git server with ~~rkt~~ docker

- at first install [rkt](https://github.com/coreos/rkt): `pacaur -S rkt` (could take a minute, grab a ~~bear~~ beer or read [this](https://coreos.com/rkt/docs/latest/rkt-vs-other-projects.html#rkt-vs-docker))
- to check if rkt works, we will run a shell in an alpine linux container:
	- trust quay.io (this is the equivalent of the *docker hub* from coreos): `sudo rkt trust --prefix quay.io`
	- run the alpine linux container: `sudo rkt run quay.io/coreos/alpine-sh --exec echo -- hello`
	- this should print something like this: `[ 6093.399497] echo[4]: hello`
- fetch the official (docker) gogs image: `sudo rkt fetch --insecure-options=image docker://gogs/gogs`
- print the container manifest: `sudo rkt image cat-manifest --pretty-print sha512-<GOGS_CONTAINER_HASH>`
    - the container hash is printed by `rkt fetch`
- run the gogs container and ~~expose port 3000 (http)~~: `sudo rkt run --insecure-options=image docker://gogs/gogs &> /dev/null &`
- `rkt list` shows you the ip of the rkt `pod` (that's a single/group of container[s] in rkt terminology)
- the gogs installation screen should be shown if you open `POD_IP:3000` in your browser
- In case you're wondering why you can't stop the container with `Ctrl+C`, you simply can't. The way to go is to use SystemD's `machinectl` to stop running containers. Run `machinectl` to get a list of running containers and `machinectl kill rkt-CONTAINER_HASH` to stop the container.
- my use-case, exposing ports on localhost, is tedious to be done with rkt, therefore I will switch back to docker (for now)
- installing docker is easy as pie: `sudo pacman -S docker && sudo systemctl start docker`
- I don't want to run every docker command as root, so I will add my user to the `docker` group: `sudo gpasswd -a $USER docker`
    - as always, you have to login/out to let changes to user/group settings become active
- get the container: `docker pull klingtdotnet/gogs`
- create a [data container](https://docs.docker.com/engine/userguide/containers/dockervolumes/) that stores the persistent data (repositories, settings etc.):

```sh
docker create --name gogs-data\
--volume /home/gogs\
--volume /etc/ssh\
--volume /opt/gogs/custom\
--volume /opt/gogs/log\
klingtdotnet/gogs
```
- run it the first time: `docker run --name gogs -p 10022:22 -p 10080:3000 --volues-from gogs-data klingtdotnet/gogs`
    - **IMPORTANT** make sure that the http port is not accessible from outside, because gogs will show the installation screen on first start
- If everything works, then create a SystemD service to autostart gogs at system startup (the redirect must be run as root):
	- **BASH MAGIC** quoting the `HEREDOC` delimiter word (`EOL`) prevents parameter expansion. Very intuitive.

```sh
cat << 'EOL' > /etc/systemd/system/gogs.service
[Unit]
Description=gogs - go git service
After=docker.service
Requires=docker.service

[Service]
TimeoutStartSec=0
Environment="GOGS_IP=127.0.0.1" "GOGS_HTTP=10080" "GOGS_SSH_IP=127.0.0.1" "GOGS_SSH=10022"
ExecStartPre=-/usr/bin/docker rm -f gogs
ExecStart=/usr/bin/docker run --name gogs \
    -p ${GOGS_IP}:${GOGS_HTTP}:3000 \
    -p ${GOGS_SSH_IP}:${GOGS_SSH}:22 \
    --volumes-from gogs-data klingtdotnet/gogs
ExecStop=/usr/bin/docker stop gogs

[Install]
WantedBy=multi-user.target
EOL
```
- to let the service automatically start on boot you've to enable it by calling `sudo systemctl enable gogs`
- if you want to get email notifications when the service fails add an `OnFailure` option and call `sendmail` ([example](https://wiki.archlinux.org/index.php/Systemd/Timers#MAILTO))
- we need to add a reverse proxy directive to out caddy config because the container only listens on `localhost`:

```ini
git.klingt.net {
	proxy / localhost:10080 {
			proxy_header Host {host}
			proxy_header X-Real-IP {remote}
			proxy_header X-Forwarded-Proto {scheme}
	}
}
```

- I think this is enough for now, maybe I will write a follow up post that describes my full caddy setup in more detail or how I do backups. If you want to know something particular, please let me know!
