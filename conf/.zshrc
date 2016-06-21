####################################################
# ANTIGEN

source ~/.antigen/antigen.zsh

# Load oh-my-zsh's library.
antigen use oh-my-zsh

antigen bundle common-aliases

antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions

antigen theme pygmalion

antigen apply

####################################################
# EXPORTS

# Adding the below line lets emacsclient start emacs if it isn't already started
# ...Intuitive, right?
export ALTERNATE_EDITOR=''

# Make 777 stuff readable in ls
# export LS_COLORS='ow=01;30;42'

####################################################
# CUSTOM ALIASES

# Enable mass, easy renaming... Why isn't this a default
# http://www.mfasold.net/blog/2008/11/moving-or-renaming-multiple-files/
#   mmv *.dat *.dat_old
#   mmv foo.* bar.*
#   mmv **/*2008.mp3 **/*2009.mp3
autoload -U zmv
alias mmv='noglob zmv -W'

# Easily start a new emacs client in terminal
alias ec="emacsclient -t"

####################################################
# MACHINE SPECIFIC

if [ -f ~/.zshrc.local ]; then
  source ~/.zshrc.local
fi
