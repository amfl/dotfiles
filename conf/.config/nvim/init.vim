" vim:fdm=marker
"
" Paths on Windows:
"   config is C:\Users\User\AppData\Local\nvim
"   ~      is C:\Users\User\

" Non-plugin Customization ----------------------------------------------- {{{1

if has("win32")
    let g:config_path = '~/AppData/Local/nvim/'
else
    let g:config_path = '~/.config/nvim/'
endif

" Special characters
set showbreak=»
" eol:¬¶, trail:•¤
set listchars=nbsp:¬,tab:→\ ,extends:»,precedes:«,trail:-
set list          " Actually show the listchars above

" Set tabs to be 4 spaces
set tabstop=4
set shiftwidth=4
set expandtab
autocmd Filetype yaml setlocal tabstop=2 shiftwidth=2
autocmd Filetype ruby setlocal tabstop=2 shiftwidth=2
autocmd Filetype Jenkinsfile setlocal commentstring=//\ %s

" Case insensitive unless we type caps
" (Force sensitivity by suffixing with \C if neccesary)
set ignorecase  " Need this for smartcase to work
set smartcase

" Show regex replace preview live as you type :%s/foo/bar/g
set inccommand=nosplit

" Support the mouse
set mouse=a

set number        " Show line numbers
set cursorline    " Highlight the line the current cursor is on

set hidden        " Switch buffers without abandoning changes or writing out
"
" Don't move the cursor back when exiting insert mode
autocmd InsertEnter * let CursorColumnI = col('.')
autocmd CursorMovedI * let CursorColumnI = col('.')
autocmd InsertLeave * if col('.') != CursorColumnI | call cursor(0, col('.')+1) | endif

" Non-plugin Remaps ------------------------------------------------------ {{{1

" Use jk/kj to exit insertion mode (Writing this line was fun!)
inoremap jk <esc>
inoremap kj <esc>

" Move up/down sensibly on wrapped lines
noremap j gj
noremap k gk

" Make Y behave as C and D do
noremap Y y$

" Pretty junky clipboard integration
" Windows: Make sure win32yank.exe is on your PATH.
nnoremap <S-Insert> "+P
inoremap <S-Insert> <esc>"+Pa
inoremap <C-v> <esc>"+Pa
vnoremap <C-c> "+y

" Quicksave sessions
map <F2> :mksession! ~/.vim_session <cr> " Quick write session with F2
map <F3> :source ~/.vim_session <cr>     " And load session with F3

" Spacemacs-esque Remaps -----------------

" Remap leader key to something easier to press (Space!)
let mapleader = ","
map <space> <leader>

" Remove highlighting
nnoremap <leader>sc :nohl<CR>

" Paste without auto-indent problems
nnoremap <leader>op :set invpaste paste?<CR>

" Toggle line numbers
nnoremap <leader>tn :set invnumber<CR>:GitGutterToggle<CR>

" Shortcut to edit dotfiles
nnoremap <leader>fed :execute "e " . g:config_path . "init.vim"<CR>
nnoremap <leader>fex :execute "e ~/.nixos.dotfiles/configuration.nix"<CR>

" Filetype-specific
" TODO: Refactor so these aren't global..
nnoremap <leader>mt :Toc<CR>

" Jump back to previous buffer
inoremap <leader><TAB> :e#<CR>
nnoremap <leader><TAB> :e#<CR>

" Plugins ---------------------------------------------------------------- {{{1

" Automatically download vim-plug if we don't have it
if empty(glob(g:config_path . 'autoload/plug.vim'))
  execute '!curl -fLo ' . g:config_path . 'autoload/plug.vim --create-dirs' .
         \' https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  " Install plugins, re-source config so colorschemes are applied
  autocmd VimEnter * PlugInstall --sync | execute 'source '.g:config_path.'init.vim'
endif

call plug#begin('~/.local/share/nvim/plugged')

if !has('nvim')
    Plug 'tpope/vim-sensible'   " Sensible defaults. Neovim has this inbuilt.
endif

" Themes (256 color)
" Plug 'morhetz/gruvbox'
Plug 'nanotech/jellybeans.vim'

Plug 'vim-airline/vim-airline'  " Cool powerline status bar
Plug 'vim-airline/vim-airline-themes'

" Usability
Plug 'tpope/vim-commentary'     " Allow commenting blocks of code
Plug 'tpope/vim-surround'       " For manipulating surrounding text
Plug 'tpope/vim-vinegar'        " Enhance the default file explorer, netrw
Plug 'tpope/vim-unimpaired'     " misc shortcuts + new lines in normal mode

Plug 'w0rp/ale'                 " Asynchronous Lint Engine
Plug 'sgur/vim-editorconfig'    " Obey `.editorconfig` files (https://editorconfig.org/)
                                " (This has better performance than the official plugin)

if has("win32")
    Plug 'ctrlpvim/ctrlp.vim'       " Jump around files
else
    " Fuzzy finder - fzf
    " This will also install fzf for the OS.
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plug 'junegunn/fzf.vim'
endif

" Git
Plug 'tpope/vim-fugitive'       " Git integration
Plug 'airblade/vim-gitgutter'   " See working dir changes, stage hunks from vim

" Languages (Uncomment as required)
" Plug 'rust-lang/rust.vim'
" Plug 'jceb/vim-orgmode'                " Basic emacs org-mode functionality
" Plug 'martinda/Jenkinsfile-vim-syntax'
" Plug 'LnL7/vim-nix'

Plug 'godlygeek/tabular'               " md: plasticboy/vim-markdown dependency
Plug 'plasticboy/vim-markdown'         " md: Markdown support
Plug 'junegunn/vim-easy-align'         " md: Align tables
" Stolen from https://robots.thoughtbot.com/align-github-flavored-markdown-tables-in-vim
au FileType markdown vmap <Leader><Bslash> :EasyAlign*<Bar><Enter>

" Initialize plugin system
call plug#end()

" Appearance and Themes -------------------------------------------------- {{{1

" colorscheme industry
" colorscheme gruvbox
colorscheme jellybeans
set background=dark

let g:airline_powerline_fonts = 1
" let g:airline_theme='powerlineish'
let g:airline_theme='jellybeans'

set noshowmode  " airline replaces the default vim mode line, so we don't need

" Fold markdown on the same line as the title, not the line after
let g:vim_markdown_folding_style_pythonic = 1
let g:vim_markdown_toc_autofit = 1    " Make ToC not take up half the screen

" Plugin remaps ---------------------------------------------------------- {{{1

function! s:find_git_root()
    return system('git rev-parse --show-toplevel 2> /dev/null')[:-2]
endfunction
command! ProjectFiles execute 'Files' s:find_git_root()
" Source: https://github.com/junegunn/fzf.vim/issues/47

" Git commands
nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>gb :Gblame<CR>

" pf : Open files in current project (See also: `:e .`)
" pr : Open files you have opened recently (See also: `:bro ol` or `:ol`)
" pb : Open a buffer that is already open (See also: `:ls`)
" pt : Open files in notes dir
if has("win32")
    nnoremap <leader>pf :CtrlP<CR>
    nnoremap <leader>pr :CtrlPMRU<CR>
    nnoremap <leader>pb :CtrlPBuffer<CR>
    nnoremap <leader>pt :CtrlP ~/txt<CR>
else
    nnoremap <leader>pf :ProjectFiles<CR>
    nnoremap <leader>pr :History<CR>
    nnoremap <leader>pb :Buffers<CR>
    nnoremap <leader>pt :FZF ~/txt<CR>
    nnoremap <leader>sp :Ag 
endif

