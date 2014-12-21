"<vundle>
set nocompatible              " be iMproved, required
filetype off                  " required

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'
" Workspace explorer
Plugin 'scrooloose/nerdtree'
" Sublime-like fuzzy search
Plugin 'kien/ctrlp.vim'
" Directory listing enhancer
" tpope/vim-vinegar
" Static code analysis
Plugin 'scrooloose/syntastic'
" Sets tab settings based on current file
Plugin 'myint/indent-finder'
" Powerline!
" Plugin 'Lokaltog/vim-powerline'
Plugin 'bling/vim-airline'

" Color scheme stuff
" A big pack of color schemes
Plugin 'flazz/vim-colorschemes'
" Automatically convert gvim true color themes into 256 color terminal approximations
Plugin 'godlygeek/csapprox'

call vundle#end()            " required
filetype plugin indent on    " required
"</vundle>

"==========================================
" COLOR SCHEMES
"==========================================
" There is a nice visualiser at http://bytefluent.com/vivify/

set t_Co=256                 " Make sure terminal is in 256 color mode
colorscheme molokai
" colorscheme darkZ

" Color listchar stuff
"hi NonText ctermfg=7 guifg=gray
"hi SpecialKey ctermfg=7 guifg=gray

let g:airline_theme='tomorrow'

"==========================================
" REMAPPINGS
"==========================================
" Some stuff taken from:
" http://danielmiessler.com/study/vim/
" http://statico.github.io/vim.html

" Use jk/kj to exit insertion mode (Writing this line was fun!) 
inoremap jk <ESC>
inoremap kj <ESC>

" Move up/down sensibly on wrapped lines
nmap j gj
nmap k gk

let mapleader = ","

" Open file browser
nmap ge :NERDTreeToggle<CR>

" Switching between buffers
nmap gh <C-w>h
nmap gj <C-w>j
nmap gk <C-w>k
nmap gl <C-w>l

syntax on
set encoding=utf-8

" Always show the status bar. Suggested the powerline plugin.
set laststatus=2

" Disable showing which mode we're in, we have plugins for that.
set noshowmode

" Mouse support
" http://vim.wikia.com/wiki/Using_the_mouse_for_Vim_in_an_xterm
set mouse=a

" Show line numbers
set number

" Explicitly show indents and newlines
:set listchars=tab:▸\ ,eol:¬
:set list

" Highlight results as you search
set incsearch

" TAB STUFF
" To be honest I think myint/indent-finder overrides some of these anyway
" It's all a bit of a mystery.
" Nice explanation: http://vimcasts.org/episodes/tabs-and-spaces/
set noexpandtab " Always use real tabs
set shiftround  " Round indent to multiple of 'shiftwidth'
set smartindent " Do smart indenting when starting a new line
set autoindent  " Copy indent from current line, over to the new line
" Set the tab width
let s:tabwidth=4                     " This is just a variable we make
exec 'set tabstop='    .s:tabwidth
exec 'set shiftwidth=' .s:tabwidth
exec 'set softtabstop='.s:tabwidth


" SPLITS

set splitbelow  " Open new splits below and to the right
set splitright