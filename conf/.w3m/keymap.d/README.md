# Keymap.d

I want to split my keymap configs into different files, and w3m doesn't appear
to support it. Oh well, let's do it manually.

Higher number files override keybinds in lower number files.

To update everything:

```sh
# Update http://w3m.rocks keybinds
curl https://raw.githubusercontent.com/vparnas/config/master/.w3m/keymap -o 10-vparnas.keymap
# Concat everything into the keymap file
cat *.keymap > ../keymap
```
