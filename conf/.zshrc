# vim: fdm=marker

# EXPORTS AND ALIASES {{{1

export PATH=${PATH}:${HOME}/bin
export GIT_PROJ_DIR=${HOME}/g
export MEMEX_DIR=${HOME}/memex
export EDITOR=nvim

alias ec=$EDITOR
alias '?'='search'
alias '??'='search -e google'
# Navigate to a repo by fzf-ing through a colored list in `source/user/repo` format
# alias cdg='cd ${GIT_DIR} && cd $(find * -maxdepth 2 -mindepth 2 | sed "s#\([^/]\+\)/\([^/]\+\)#$(tput setaf 1)\1/$(tput setaf 6)\2$(tput sgr0)#" | fzf --ansi)'
alias cdg='cd $(ghq root)/$(ghq list | sed --posix -E "s#([^/]+)/([^/]+)#$(tput setaf 1)\1/$(tput setaf 6)\2$(tput sgr0)#" | fzf --ansi)'
alias mem='cd $MEMEX_DIR'
# Open unstructured notes file at the right place to quickly jot something down
uns() { nvim -c ':execute "normal Gza"' "${MEMEX_DIR}/unstructured/$(date +%Y-%m).md" }

alias grep='grep --color'
alias lynx='lynx -cfg=~/.lynxrc'
# To even attempt to open external browsers,
# amfora needs to be tricked into having DISPLAY set
alias amfora='DISPLAY=hack amfora'

# ZSH {{{1

export HISTSIZE=1000000

# Highlight current choice when spamming through tab complete menu
zstyle ':completion:*' menu select
# Enable colors in tab complete
zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"

# Ctrl + j/k to quickly go up/down (mimicks fzf controls)
bindkey '^K' up-line-or-search
bindkey '^J' down-line-or-search

# Make Vi mode transitions faster (KEYTIMEOUT is in hundredths of a second)
export KEYTIMEOUT=1

# Edit the command line in $EDITOR
autoload -U edit-command-line
zle -N edit-command-line
bindkey "^V" edit-command-line

##################
# PROMPT

# Check conf/.config/starship.toml
eval "$(starship init zsh)"

# FZF {{{1

# I manage fzf manually.
FZF_REPO=${GIT_PROJ_DIR}/github.com/junegunn/fzf
if [[ -d $FZF_REPO ]]; then
    # Always use 16 color theme. I find it easier to read.
    export FZF_DEFAULT_OPTS='--color 16'

    # Auto-completion
    [[ $- == *i* ]] && source "$FZF_REPO/shell/completion.zsh" 2> /dev/null
    # Key bindings
    source "$FZF_REPO/shell/key-bindings.zsh"
fi
