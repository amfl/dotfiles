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

Because I always forget how, and the ones on apt are crap.

Detailed here: https://github.com/joyent/node/wiki/installing-node.js-via-package-manager

Ubuntu tl;dr

	curl -sL https://deb.nodesource.com/setup | sudo bash -
	sudo apt-get install -y nodejs

Note that this CAN BREAK THINGS! Only do this is the defaults in apt don't work. I have had issues with nodejs not loading libraries properly.

## Install vundle

    git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim

(This is now in bootstrap.sh)

## vsftpd

vsftpd is happier when users have a valid shell. Adding `/bin/false` to `/etc/shells` will prevent login via ssh, but allow vsftpd to work.
