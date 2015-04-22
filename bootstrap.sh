#!/usr/bin/env bash
cd "$(dirname "${BASH_SOURCE}")"

# Actually this might be deceptive, because the old script keeps running.
# I'll comment it out for now so I don't confuse myself.
# echo Updating dotfiles directory...
# git pull origin master

function git-update() {
	# Either clones a directory if it doesn't exist at the given location
	# or pulls it if it does exist.
	# $1 = repo URL
	# $2 = directory
	pushd . > /dev/null

	echo git-update $1 $2...
	if cd $2; then
		git pull
	else
		git clone $1 $2;
	fi
	popd > /dev/null
}
function doIt() {
	rsync --exclude ".git/" --exclude ".DS_Store" --exclude "bootstrap.sh" \
		--exclude "README.md" --exclude "notes.md" -av --no-perms . ~

	git config --global core.excludesfile ~/.gitignore_global

	git-update https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
	git-update https://github.com/sickill/stderred.git                  ~/.stderred
	
	# Install vim-plug
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
		    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

	# Setup stderred
	cd ~/.stderred
	if [[ "$OSTYPE" == "linux-gnu" ]]; then
		make;
	elif [[ "$OSTYPE" == "darwin"* ]]; then
		make universal;
	else
		echo Cannot install stderred: Unknown OS.;
	fi

	# source ~/.bash_profile
}
if [ "$1" == "--force" -o "$1" == "-f" ]; then
	doIt
else
	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1
	echo
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		doIt
	fi
fi
unset doIt
