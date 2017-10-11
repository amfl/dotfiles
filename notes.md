This notes file is very rarely updated.

Misc Notes
-------------------------------

## Gnome+i3 hybrid

My typical setup right now is i3 on Ubuntu Desktop, which needs a little massaging to work correctly.

http://blog.hugochinchilla.net/2013/03/using-gnome-3-with-i3-window-manager/


### To stop the desktop window popping up every time nautilus starts:

    sudo gsettings set org.gnome.desktop.background show-desktop-icons false


### To remove gnome bottom bar:

http://askubuntu.com/questions/157321/can-i-set-a-custom-horizontal-width-for-a-gnome-panel

    dconf-editor->prg->gnome->gnome-panel->layout->toplevel-id-list

Changed from

    ['top-panel-0', 'bottom-panel-0']

to

    ['top-panel-0']

## Installing node/npm

Install nvm! Detailed here: https://github.com/creationix/nvm

	wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.24.1/install.sh | bash
	nvm install 0.10
	nvm use 0.10

## vsftpd

vsftpd is happier when users have a valid shell. Adding `/bin/false` to `/etc/shells` will prevent login via ssh, but allow vsftpd to work.

If running behind a dynamic IP, it is not enough to set `pasv_addr_resolve`, because this will try to resolve the domain once at startup. This should be done manually.

Put this in cron. Inspired from [this post](http://www.imovedtolinux.com/2009/07/configure-vsftpd-for-passive.html) but modified to more accurately get output from `host` with `ack`:

	#!/bin/sh
	vsftpd_conf=/etc/vsftpd.conf
	# change to your domain name in next line
	my_ip=$(host your_host.dyndns.org | ack-grep "has address (.*)" --output "\$1")
	vsftpd_ip=`grep pasv_address $vsftpd_conf | cut -f2 -d=`

	if [ "$my_ip" != "$vsftpd_ip" ] && [ "$my_ip" ] && [ "$vsftpd_ip" ]; then
	( echo ",s/$vsftpd_ip/$my_ip/g" && echo w ) | ed - $vsftpd_conf
	service vsftpd restart
	fi

## Git

### Push huge commits

https sometimes has issues with massive commits. Use ssh protocol instead. First make a key

    ssh-keygen -t rsa -C "$your_email"

Then upload the public key at `~/.ssh/id_rsa.pub` to remote repo.

Works over ssh

    git@git.domain.com:group/project.git

To use a non-standard port, we need to explicitly specify ssh protocol:

    ssh://git@git.domain.com:766/group/project.git

If absolutely hugenormous, we can use `trickle` to limit bandwidth so we don't choke the rest of the system

    trickle -s -u 20 git push -u origin master

Will run trickle in standalone mode and limit to 20KB/s.

## ddclient

`/etc/ddclient.conf`:

	daemon=1800
	protocol=freedns
	use=web, web=https://ipinfo.io/json, web-skip='ip" : "'
	server=freedns.afraid.org
	login=USERNAMEHERE
	password='PASSWORDHERE'
	full.domain.name.here

To test:

	sudo ddclient -daemon=0 -debug -verbose -noquiet

## AWS

To change the hostname of ubuntu instance without weird messages:

* Update in /etc/hostname
* Add next to localhost in /etc/hosts
* sudo service hostname restart

## Profiling Code

Can use Valgrind/Callgrind. kcachegrind is a visualizer.

## Pip

If you get messages about out of date packages when installing something via pip, you might need to upgrade the environment.

	sudo pip install whatever-you-are-trying-to-install-here --upgrade
