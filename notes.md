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
