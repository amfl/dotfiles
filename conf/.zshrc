####################################################
# MACHINE SPECIFIC

if [ -f ~/.zshrc.local ]; then
  source ~/.zshrc.local
fi

####################################################
# ANTIGEN

source ~/.antigen/antigen.zsh

# Load oh-my-zsh's library.
antigen use oh-my-zsh

antigen bundle common-aliases

# Supercharge C-r for history searching
# antigen bundle zsh-users/zaw
# bindkey '^;' zaw-history
# bindkey -M filterselect '^J' down-line-or-history
# bindkey -M filterselect '^K' up-line-or-history

# Cool, but slows everything down :(
# antigen bundle zsh-users/zsh-autosuggestions
# bindkey '^ ' autosuggest-accept

# Highlight valid commands as green when they are typed
antigen bundle zsh-users/zsh-syntax-highlighting

antigen theme pygmalion

antigen apply

####################################################
# EXPORTS

export EDITOR='nvim'
# Adding the below line lets emacsclient start emacs if it isn't already started
# ...Intuitive, right?
export ALTERNATE_EDITOR=''

# Make 777 stuff readable in ls
export LS_COLORS='ow=01;30;42'

export PATH="${PATH}:/${HOME}/bin"

####################################################
# CUSTOM ALIASES

if command -v fd >/dev/null; then
    # fd is a program, so don't let common-aliases clobber it!
    # https://github.com/sharkdp/fd
    unalias fd
fi

# Enable mass, easy renaming... Why isn't this a default
# http://www.mfasold.net/blog/2008/11/moving-or-renaming-multiple-files/
#   mmv *.dat *.dat_old
#   mmv foo.* bar.*
#   mmv **/*2008.mp3 **/*2009.mp3
autoload -U zmv
alias mmv='noglob zmv -W'

# Easily start a new emacs client in terminal
alias ec="emacsclient -t"

# Package manager commands
# Will extend these definitions to other distros as required
alias pks='apt-cache search'
alias pki='apt-get install'

# Pull down a webpage as googlebot
alias googlebot='curl -L -A "Googlebot/2.1 (+http://www.google.com/bot.html)"'

# I like things simple :)
alias tree='tree --charset=ASCII'

