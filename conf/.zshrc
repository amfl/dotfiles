# vim: fdm=marker

# EXPORTS AND ALIASES {{{1

# Various directories
export GIT_PROJ_DIR=${HOME}/g
export MEMEX_DIR=${HOME}/memex
export DOTFILES_DIR=${GIT_PROJ_DIR}/github.com/amfl/dotfiles

export EDITOR=nvim
export GCALPATH=${MEMEX_DIR}
export PATH=${PATH}:${HOME}/bin

if command -v bat >/dev/null; then
    # Use `bat` to syntax highlight man pages
    export MANROFFOPT="-c"
    export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi

alias ec=$EDITOR
alias '?'='searx 2>/dev/null ; search --engine searx_local'
alias '??'='search -e google'
alias '?~'='w3m $(tail -n 1 ~/.w3m/history)' # Open the last w3m page
# Navigate to a repo by fzf-ing through a colored list in `source/user/repo` format
# alias cdg='cd ${GIT_DIR} && cd $(find * -maxdepth 2 -mindepth 2 | sed "s#\([^/]\+\)/\([^/]\+\)#$(tput setaf 1)\1/$(tput setaf 6)\2$(tput sgr0)#" | fzf --ansi)'
alias cdg='cd $(ghq root)/$(ghq list | sed --posix -E "s#([^/]+)/([^/]+)#$(tput setaf 1)\1/$(tput setaf 6)\2$(tput sgr0)#" | fzf --ansi)'
alias mem='cd $MEMEX_DIR'
# Open unstructured notes file at the right place to quickly jot something down
uns() { nvim -c ':execute "normal Gza"' "${MEMEX_DIR}/unstructured/$(date +%Y-%m).md" }
alias kb='kubectl'

alias grep='grep --color'
alias lynx='lynx -cfg=~/.lynxrc'
# To even attempt to open external browsers,
# amfora needs to be tricked into having DISPLAY set
alias amfora='DISPLAY=hack amfora'

# Useful docker containers
alias dkgo='docker run --rm -it -u "$(id -u):$(id -g)" -v $(pwd):/tmp/workdir -w /tmp/workdir golang:latest bash'
alias dkrust='docker run --rm -it -u "$(id -u):$(id -g)" -v $(pwd):/tmp/workdir -w /tmp/workdir rust:latest bash'
alias dkpy='docker run --rm -it -u "$(id -u):$(id -g)" -v $(pwd):/tmp/workdir -w /tmp/workdir python:latest bash'

# Exa - https://the.exa.website/
# Use `exa` as `ls` if it's available
if command -v exa &> /dev/null
    then alias ls='exa -g'; fi

# ZSH {{{1

export HISTSIZE=1000000

# Highlight current choice when spamming through tab complete menu
zstyle ':completion:*' menu select
# Enable colors in tab complete
zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"
# Case-insensitive tab complete
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

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

if command -v starship >/dev/null; then
    # Check conf/.config/starship.toml
    eval "$(starship init zsh)"
else
    echo "Warning: Starship not detected. Using fallback prompt."
    source "$DOTFILES_DIR/deprecated/.zshrc.prompt"
fi

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

    # Use `fd` to respect .gitignore if available
    if command -v fd >/dev/null; then
        export FZF_DEFAULT_COMMAND='fd --type f'
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    fi
fi
