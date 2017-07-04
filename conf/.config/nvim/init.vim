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

" Set cursor colors based on modes
highlight CursorLine ctermbg=Yellow ctermfg=None guibg=Yellow

" Pretty junky clipboard integration
nnoremap <S-Insert> "+p
inoremap <S-Insert> <esc>"+pa
vnoremap <C-c> "+y 

set number        " Show line numbers
set cursorline    " Highlight the line the current cursor is on

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

Plug 'tpope/vim-commentary'     " Allow commenting blocks of code
Plug 'tpope/vim-surround'       " For manipulating surrounding text

Plug 'tpope/vim-fugitive'       " Git integration

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

