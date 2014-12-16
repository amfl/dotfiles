"<vundle>
set nocompatible              " be iMproved, required
filetype off                  " required

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'myint/indent-finder'
" Color scheme stuff
Plugin 'flazz/vim-colorschemes'
Plugin 'felixhummel/setcolors.vim'
" Some colorschemes I found on http://cocopon.me/app/vim-color-gallery/
Plugin 'altercation/vim-colors-solarized'
Plugin 'nanotech/jellybeans.vim'
Plugin 'tomasr/molokai'

call vundle#end()            " required
filetype plugin indent on    " required
"</vundle>

" Some stuff taken from http://danielmiessler.com/study/vim/
inoremap jk <ESC>
inoremap kj <ESC>
let mapleader = ","

syntax on
set encoding=utf-8

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

" COLOR SCHEMES
" Color listchar stuff from above
"hi NonText ctermfg=7 guifg=gray
"hi SpecialKey ctermfg=7 guifg=gray

" let g:solarized_termcolors=256
" set background=dark
" colorscheme solarized

let g:rehash256 = 1
colorscheme molokai

" colorscheme jellybeans

" SPLITS

set splitbelow  " Open new splits below and to the right
set splitright
