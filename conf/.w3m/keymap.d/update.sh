#!/bin/sh

cd "$(readlink -f "$(dirname "$0")")" || exit

# Update http://w3m.rocks keybinds
curl https://raw.githubusercontent.com/vparnas/config/master/.w3m/keymap -o 10-vparnas.keymap
# Concat everything into the keymap file
cat ./*.keymap > ../keymap
