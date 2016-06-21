#!/bin/sh

SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

# --------------------------------------------------
# LIBRARY FUNCTIONS

git-update() {
  # Either clones a directory if it doesn't exist at the given location
  # or pulls it if it does exist.
  # $1 = repo URL
  # $2 = directory

  echo git-update $1 $2...
  if [ -d "$2" ]; then
    # Pull down the latest master and replay our changes on top.
    git -C $2 pull --rebase --stat origin master
  else
    git clone $1 $2;
  fi
}

# --------------------------------------------------
# ACTIONS

usage() {
  echo "Usage:"
  echo "  all           Do everything!"
  echo "  install       Install commonly used software"
  echo "  configure     Configure installed software"
  echo "  link          Link configs with stow"
  echo "  unlink        Unlink configs with stow"
}

install-pkg() {
  OS=`uname`

  # Universal list of software for all operating systems.
  # This list can be added to by other OSes. Useful if there are differences between package names.
  SOFTWARE="stow git tig tmux cmake zsh inotify-tools ncdu htop tree dict jq"

  case $OS in
    "Linux")
      PKGMAN="apt-get install"
      SOFTWARE="$SOFTWARE build-essential silversearcher-ag ack-grep dictd dict-gcide vim"
      ;;
    "Darwin")
      ;;
    "FreeBSD")
      PKGMAN="pkg install"
      SOFTWARE="$SOFTWARE the_silver_searcher ack neovim"
      ;;
    *)
      echo "Unknown OS: $OS"
      exit
      ;;
  esac

  echo "Detected OS: $OS"
  echo "sudo $PKGMAN $SOFTWARE"
  sudo $PKGMAN $SOFTWARE
}

install-git() {
  git-update https://github.com/sickill/stderred.git                  ~/.stderred
}

configure() {
  git config --global core.excludesfile ~/.gitignore_global

  # TODO Install stderred.
}

link() {
  stow -d $SCRIPTPATH -vt ~ conf
}

unlink() {
  stow -d $SCRIPTPATH -vDt ~ conf
}

# -----------------------------------------------
# MAIN

if [ "$#" -ne 1 ]; then
  usage
  exit
fi

case $1 in
  "all")
    install-pkg
    install-git
    configure
    link
    ;;
  "install")
    install-pkg
    install-git
    ;;
  "link")
    link
    ;;
  "unlink")
    unlink
    ;;
  "configure")
    configure
    ;;
  *)
    echo "Invalid command."
    usage
    ;;
esac

