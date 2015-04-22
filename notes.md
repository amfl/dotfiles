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
