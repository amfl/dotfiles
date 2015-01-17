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
" Allow commenting blocks of code
Plugin 'tpope/vim-commentary'
" Move around quickly
Plugin 'Lokaltog/vim-easymotion'
" Git integration
Plugin 'tpope/vim-fugitive'
" Disable basic navigation commands to become familiar with more advanced ones
Plugin 'wikitopian/hardmode'

" Color scheme stuff
" A big pack of color schemes
Plugin 'flazz/vim-colorschemes'
" Automatically convert gvim true color themes into 256 color terminal approximations
Plugin 'godlygeek/csapprox'

call vundle#end()            " required
filetype plugin indent on    " required
"</vundle>

"==========================================
" REMAPPINGS
"==========================================
" Some stuff taken from:
" http://danielmiessler.com/study/vim/
" http://statico.github.io/vim.html

" Remap leader to something easier to press
let mapleader = ","

" Use jk/kj to exit insertion mode (Writing this line was fun!) 
inoremap jk <ESC>
inoremap kj <ESC>

" Move up/down sensibly on wrapped lines
noremap j gj
noremap k gk

" Switching between buffers
nmap gh <C-w>h
nmap gj <C-w>j
nmap gk <C-w>k
nmap gl <C-w>l

" PLUGIN REMAPS

" Toggle hardmode
nnoremap <leader>h <Esc>:call ToggleHardMode()<CR>
" Open file browser
nmap ge :NERDTreeToggle<CR>

"==========================================
" SYNTASTIC CONFIG
"==========================================

let g:syntastic_python_checkers=['pylint']
let g:syntastic_javascript_checkers=['jshint']

"==========================================
" COLORS AND THEMES
"==========================================
" There is a nice visualiser at http://bytefluent.com/vivify/

set t_Co=256                 " Make sure terminal is in 256 color mode
" colorscheme paintbox
colorscheme molokai
" colorscheme darkZ

syntax on                    " Enable syntax highlighting

" Color listchar stuff
"hi NonText ctermfg=7 guifg=gray
"hi SpecialKey ctermfg=7 guifg=gray

let g:airline_theme='tomorrow'

" Don't show seperators
let g:airline_left_sep=''
let g:airline_right_sep=''

"==========================================
" SEARCHING
"==========================================
" Highlight results as you search
set incsearch
" Highlight all search results
set hlsearch
" Remove highlighting if we're done with it
nmap <C-n> :nohlsearch<CR>
" Do a case sensitive search only if we search for something which features
" uppercase letter
set ignorecase  " Need this for smartcase to work
set smartcase
" Remember you can force case sensitivity by suffixing your search with \C
" (Or force insensitivity with \c)

"==========================================
" TAB STUFF
"==========================================
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

"==========================================
" MISC
"==========================================

" Do autocomplete
set omnifunc=syntaxcomplete#Complete
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

" Have a hotkey we can use if we want to paste data in without it auto-indenting
set pastetoggle=<F10>

" Open new splits below and to the right
set splitbelow
set splitright

" Clipboard integration
vmap <C-c> y:call system("~/bin/sendclipboard", getreg("\""))<CR>
