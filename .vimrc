"<vundle>
set nocompatible              " be iMproved, required
filetype off                  " required

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'
Plugin 'scrooloose/nerdtree'

call vundle#end()            " required
filetype plugin indent on    " required
"</vundle>

" Some stuff taken from http://danielmiessler.com/study/vim/
inoremap jk <ESC>
let mapleader = ","

syntax on
set encoding=utf-8

" Mouse support
" http://vim.wikia.com/wiki/Using_the_mouse_for_Vim_in_an_xterm
set mouse=a

set number

