" Paths on Windows:
"   config is C:\Users\User\AppData\Local\nvim
"   ~      is C:\Users\User\
"
" Automatically download vim-plug if we don't have it
" if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
"  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
"    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
"  autocmd VimEnter * PlugInstall | source $MYVIMRC
"endif

inoremap jk <esc>
inoremap kj <esc>
vnoremap jk <esc>
vnoremap kj <esc>

" Don't move the cursor back when exiting insert mode
autocmd InsertEnter * let CursorColumnI = col('.')
autocmd CursorMovedI * let CursorColumnI = col('.')
autocmd InsertLeave * if col('.') != CursorColumnI | call cursor(0, col('.')+1) | endif

" Pretty junky clipboard integration
" Windows: Make sure win32yank.exe is on your PATH.
nnoremap <S-Insert> "+P
inoremap <S-Insert> <esc>"+Pa
inoremap <C-v> <esc>"+Pa
vnoremap <C-c> "+y 

" Support the mouse
set mouse=a

set number        " Show line numbers
set cursorline    " Highlight the line the current cursor is on

" Remap leader to something easier to press
let mapleader = ","
map <space> <leader>

" Jump back to previous buffer
inoremap <leader><TAB> :e#<CR>
nnoremap <leader><TAB> :e#<CR>

" Plugins -------------------------------- {{{1
call plug#begin('~/.local/share/nvim/plugged')

if !has('nvim')
	Plug 'tpope/vim-sensible'       " Sensible defaults
endif

" Themes
" Plug 'morhetz/gruvbox'
Plug 'nanotech/jellybeans.vim'

Plug 'vim-airline/vim-airline'  " Cool powerline status bar
Plug 'vim-airline/vim-airline-themes'

" Usability
Plug 'tpope/vim-commentary'     " Allow commenting blocks of code
Plug 'tpope/vim-surround'       " For manipulating surrounding text
Plug 'tpope/vim-vinegar'        " Enhance the default file explorer, netrw
Plug 'ctrlpvim/ctrlp.vim'       " Jump around files

" Git
Plug 'tpope/vim-fugitive'       " Git integration
Plug 'airblade/vim-gitgutter'   " Compare lines to last git commit, stage chunks from in vim

" Languages
Plug 'rust-lang/rust.vim'

" Initialize plugin system
call plug#end()

" Appearance and Themes ---------------------------- {{{1

" colorscheme industry
" colorscheme gruvbox
colorscheme jellybeans
set background=dark

let g:airline_powerline_fonts = 1
" let g:airline_theme='powerlineish'
let g:airline_theme='jellybeans'

set noshowmode  " airline replaces the default vim mode line, so we don't need

