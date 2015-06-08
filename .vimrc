" .vimrc
" Author: amfl
" Source: https://github.com/amfl/dotfiles/blob/master/.vimrc

" Preamble ---------------------------------------------------------------- {{{

" Much of this file has been inspired by (Read: Outright stolen from)
" the following sources:
"   http://danielmiessler.com/study/vim/
"   http://statico.github.io/vim.html
"   http://bitbucket.org/sjl/dotfiles/src/tip/vim/

set nocompatible

" Each machine can have their own custom config.
if filereadable(glob("~/.vimrc.local"))
	source ~/.vimrc.local
endif

" }}}
" General Settings -------------------------------------------------------- {{{

set omnifunc=syntaxcomplete#Complete   " Do autocomplete
set encoding=utf-8
set laststatus=2    " Always show the status bar (airline!)
set noshowmode      " airline shows mode so vim doesn't need to
set number          " Show line numbers
set cursorline      " Highlight the line the cursor is on.
set hidden          " Switch buffers without abandoning changes or writing out
set lazyredraw      " Don't redraw the screen when executing macros

set mouse=a         " Mouse support in all modes
if &term =~ '^screen'
	" tmux knows the extended mouse mode
	set ttymouse=xterm2
endif

" Special characters
set showbreak=»
set listchars=tab:▸\ ,eol:¬,trail:-,extends:>,precedes:<,nbsp:+  " Special characters...
set list                     " ...Please show them

set splitbelow         " Open new splits below and to the right
set splitright

set scrolloff=3        " Keep cursor from very top or bottom of screen

" Resize splits when the window is resized
augroup vimrc_general
	autocmd!
	autocmd VimResized * :wincmd =
augroup END

" Remote system clipboard integration
vmap <C-c> y:call system("~/bin/sendclipboard", getreg("\""))<CR>

" ----- The Silver Searcher / ag ----- {{{
" http://codeinthehole.com/writing/using-the-silver-searcher-with-vim/
" https://robots.thoughtbot.com/faster-grepping-in-vim
if executable('ag')
    " Note we extract the column as well as the file and line number
    set grepprg=ag\ --nogroup\ --nocolor\ --column
    set grepformat=%f:%l:%c%m

	" Ctrl+P plugin
	let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
	" ag is fast enough that CtrlP doesn't need to cache
	" let g:ctrlp_use_caching = 0
endif

" Search for stuff in a quickfix window
command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
nnoremap \ :Ag<SPACE>
" }}}
" }}}
" Plugin Setup ------------------------------------------------------------ {{{

let g:plug_timeout = 9999

call plug#begin()

Plug 'tpope/vim-sensible'       " Sensible defaults.
Plug 'kien/ctrlp.vim'           " Sublime-like fuzzy search
Plug 'derekwyatt/vim-fswitch'   " Toggle between source and headers
Plug 'tpope/vim-vinegar'        " Enhance the built-in directory explorer, netrw.
Plug 'bling/vim-airline'        " Powerline!
Plug 'tpope/vim-commentary'     " Allow commenting blocks of code
Plug 'tpope/vim-surround'       " For manipulating surrounding text
" Plug 'Lokaltog/vim-easymotion'  " Move around quickly
Plug 'tpope/vim-fugitive'       " Git integration
Plug 'wikitopian/hardmode'      " Disable basic navigation commands to become familiar with more advanced ones
Plug 'wesQ3/vim-windowswap'     " Swap two open windows without dorking up the layout
                                " (<leader>ww in one window, then <leader>ww in another and they will swap)
" Plug 'bkad/CamelCaseMotion'   " CamelCase movements
Plug 'godlygeek/tabular'        " Shift code around easily. Also required for vim-markdown.
Plug 'vasconcelloslf/vim-interestingwords' " <leader>k to highlight words, <leader>K to clear.

" SYNTAX/LANGUAGES
Plug 'amfl/mrc.vim'             " mIRC script syntax highlighting
Plug 'amfl/vim-evennia'         " Evennia batch file support
Plug 'tikhomirov/vim-glsl'      " OpenGL Shading Language

" UNIT TESTING
Plug 'junegunn/vader.vim'

" PROSE RELATED
Plug 'amfl/vim-markdown'        " Syntax highlighting, matching rules and mappings for Markdown.
Plug 'vim-scripts/LanguageTool' " Grammar check.
Plug 'gerw/vim-latex-suite'     " LaTeX stuff.

" COLORS AND THEMES
Plug 'flazz/vim-colorschemes'           " A big pack of color schemes
" Plug 'godlygeek/csapprox'               " Automatically convert gvim true color themes into 256 color terminal approximations
Plug 'vim-scripts/ScrollColors'         " Colorscheme explorer. Type :SCROLL and use left/right arrows.
Plug 'junegunn/rainbow_parentheses.vim' " RAINBOW PARENS!

" REQUIRES PYTHON
if has("python")
	Plug 'myint/indent-finder'      " Sets tab settings based on current file
	Plug 'SirVer/ultisnips'         " Snippets - Engine
	Plug 'honza/vim-snippets'       " Snippets - Actual snippits
endif

" HEAVYWEIGHT
" Only for powerful machines! Set g:heavyweight in .vimrc.local to enable.
if exists("g:heavyweight")
	Plug 'Valloric/YouCompleteMe' " Code completion! Note that this has a compiled component.
	Plug 'scrooloose/syntastic'   " Static code analysis
endif

" GVIM
if has('gui_running')
	Plug 'vim-scripts/zoom.vim'
endif

call plug#end()

" }}}
" Backups ----------------------------------------------------------------- {{{

set backup                        " Enable backups
set noswapfile

set undodir=~/.vim/tmp/undo//     " Undo files
set backupdir=~/.vim/tmp/backup// " Backups
set directory=~/.vim/tmp/swap//   " Swap files

" Make those folders automatically if they don't already exist.
if !isdirectory(expand(&undodir))
    call mkdir(expand(&undodir), "p")
endif
if !isdirectory(expand(&backupdir))
    call mkdir(expand(&backupdir), "p")
endif
if !isdirectory(expand(&directory))
    call mkdir(expand(&directory), "p")
endif

" Make sure crontab doesn't explode
" http://vim.wikia.com/wiki/Editing_crontab
set backupskip=/tmp/*,/private/tmp/*

" }}}
" Remappings -------------------------------------------------------------- {{{

" Remap leader to something easier to press
let mapleader = ","
map <space> <leader>

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

" Open file explorer
nmap ge :e.<CR>

" Tabs
noremap <C-\> gt
inoremap <C-\> <ESC>gti
noremap <C-]> gT
inoremap <C-]> <ESC>gTi
noremap <C-t> :tabnew<CR>
inoremap <C-t> <ESC>:tabnew<CR>i

" Keep search matches in the middle of the window.
nnoremap n nzzzv
nnoremap N Nzzzv

" Easier to type, and I never use the default behavior.
" noremap H ^
" noremap L $
" vnoremap L g_
noremap H gT
noremap L gt

" Bind c-a and c-e to behave as in shell in insert mode
inoremap <c-a> <esc>I
inoremap <c-e> <esc>A
cnoremap <c-a> <home>
cnoremap <c-e> <end>

" Speed up window scrolling commands
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>
" ...And make them available in insert mode
inoremap <C-e> <Esc>3<C-e>i
inoremap <C-y> <Esc>3<C-y>i

" Remap some commonly used commands to leader key for speed
nnoremap <leader>w :w<CR>
nnoremap <leader>e :e 
nnoremap <leader>q :q<CR>
" Edit the alt-file - Ie, the file we were just in
nnoremap <leader>a :e#<CR>

" Quicksave sessions
map <F2> :mksession! ~/.vim_session <cr> " Quick write session with F2
map <F3> :source ~/.vim_session <cr>     " And load session with F3
"
" Paste without auto-indent problems
nnoremap <leader>p :set invpaste paste?<CR>

" Dump timestamp {{{

let tzformat = "%Y.%m.%d"
:nnoremap <F5> "=strftime(g:tzformat)<CR>P
:inoremap <F5> <C-R>=strftime(g:tzformat)<CR>

" }}}
" Show Syntax group under cursor {{{

command ShowSyntaxUnderCursor :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"

map <F10> :ShowSyntaxUnderCursor<CR>

" }}}
" DiffSaved {{{

" http://vim.wikia.com/wiki/Diff_current_buffer_and_the_original_file
function! s:DiffWithSaved()
  let filetype=&ft
  diffthis
  vnew | r # | normal! 1Gdd
  diffthis
  exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction
com! DiffSaved call s:DiffWithSaved()

" }}}

" Plugin Remaps ----------------------------------------------------------- {{{

" Switch between source and header
noremap <leader>h :FSHere<CR>
" Toggle hardmode
nnoremap <leader>/ <Esc>:call ToggleHardMode()<CR>
" Tabularize
nmap <leader>t :Tabularize /

" CamelCase mappings
" nmap <leader>cw <Plug>CamelCaseMotion_w
" nmap <leader>cb <Plug>CamelCaseMotion_b
" nmap <leader>ce <Plug>CamelCaseMotion_e

nnoremap <leader>r ::RainbowParentheses!!<CR>

" }}}
" }}}
" Plugin Config ----------------------------------------------------------- {{{

" SYNTASTIC CONFIG

let g:syntastic_python_checkers=['pylint']
let g:syntastic_javascript_checkers=['jshint']

" SNIPPITS AND AUTOCOMPLETE CONFIG

" Trigger configuration. Do not use <tab> if you use Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" VIM-COMMENTARY CONFIG

" Always use line-style comments because they hurt my soul less
augroup vimrc_cpp_comment
	autocmd!
	autocmd FileType cpp set commentstring=//\ %s
augroup END

let g:vim_markdown_fold_on_headings=1

" }}}
" Prose ------------------------------------------------------------------- {{{

" .md files are markdown instead of Modula-2
augroup vimrc_prose
	autocmd!
	autocmd BufNewFile,BufReadPost *.md set filetype=markdown
augroup END

map <leader>ss :setlocal spell!<CR>   " Toggle spellcheck

" Grammar checking
map <leader>g :LanguageToolCheck<CR>
let g:languagetool_jar = "~/bin/languagetool-commandline.jar"

" Custom spellcheck colors
" hi SpellBad    ctermfg=167
" hi SpellLocal  ctermfg=109
" hi SpellRare   ctermfg=175
" hi SpellCap    ctermfg=142

" Add dictionary words to the autocomplete
" set complete +=kspell

" }}}
" Colors and Themes ------------------------------------------------------- {{{

" There is a nice visualiser at http://bytefluent.com/vivify/

set t_Co=256                 " Make sure terminal is in 256 color mode
set background=dark
syntax on                    " Enable syntax highlighting

let g:current_theme = "none"
function SetTheme(theme)
	if (a:theme == g:current_theme)
		" No action needs to be taken.
		return
	endif
	if (a:theme == "default")
		let g:gruvbox_guisp_as_guifg=1
		let g:gruvbox_italic=1
		let g:gruvbox_italicize_comments=0
		colorscheme gruvbox

		hi Normal ctermbg=0          " Nice dark background
		
		" Copy RainbowParentheses config from previous forks
		if exists('g:rbpt_colorpairs')
			let g:rainbow#colors = {
			\ 'dark': g:rbpt_colorpairs,
			\ 'light': g:rbpt_colorpairs
			\ }
		endif
		RainbowParentheses
	elseif (a:theme == "prose")
		setlocal spell spelllang=en_us
		colorscheme last256
		" hi Normal ctermfg=lightgrey
	endif

	let g:current_theme = a:theme
endfunction

" Automatically switch themes based on the currently open filetype.
augroup vimrc_themes
	autocmd!
	autocmd BufEnter,FileType *
		\   if &ft ==# 'markdown' | call SetTheme("prose") |
		\   else | call SetTheme("default") |
		\   endif
augroup END

" Color listchar stuff
" hi NonText ctermfg=7 guifg=gray        " ¬ character at EOL
" hi SpecialKey ctermfg=7 guifg=gray     " ▸ character at indent

" let g:airline_theme='tomorrow'

" Don't show seperators
let g:airline_left_sep=''
let g:airline_right_sep=''
" Show seperators with standard left/right arrow chars
" let g:airline_left_sep='▶'
" let g:airline_right_sep='◀'

let g:rainbow#max_level = 16
let g:rainbow#pairs = [['(', ')'], ['[', ']'], ['{', '}']]

" }}}
" gVim -------------------------------------------------------------------- {{{
if has('gui_running')
	set guioptions-=T  " no toolbar
	" set guioptions-=m  " no menubar
	if has('gui_win32')
		set guifont=Consolas:h12:cANSI
	endif

	nmap _ :ZoomOut<CR>
endif
" }}}
" Searching --------------------------------------------------------------- {{{

set hlsearch             " Highlight all search results

" Case insensitive unless we type caps
" (Force sensitivity by suffixing with \C if neccesary)
set ignorecase  " Need this for smartcase to work
set smartcase

" }}}
" Tabs and Indentation ---------------------------------------------------- {{{

" To be honest I think myint/indent-finder overrides some of these anyway
" It's all a bit of a mystery.
" Nice explanation: http://vimcasts.org/episodes/tabs-and-spaces/

set noexpandtab " Always use real tabs
set shiftround  " Round indent to multiple of 'shiftwidth'
set smartindent " Do smart indenting when starting a new line

" Set the tab width
let s:tabwidth=4                     " This is just a variable we make
exec 'set tabstop='    .s:tabwidth
exec 'set shiftwidth=' .s:tabwidth
exec 'set softtabstop='.s:tabwidth

if exists("&breakindent")
	" Keep correct indent on wrapped lines
	set breakindent
endif

" }}}
" Folding ----------------------------------------------------------------- {{{

set foldmethod=marker  " Fold on markers in source

" "Focus" the current line.
nnoremap <leader>z zMzvzz

function! MyFoldText() " {{{
    let line = getline(v:foldstart)

    let nucolwidth = &fdc + &number * &numberwidth
    let windowwidth = winwidth(0) - nucolwidth - 3
    let foldedlinecount = v:foldend - v:foldstart

    " expand tabs into spaces
    let onetab = strpart('          ', 0, &tabstop)
    let line = substitute(line, '\t', onetab, 'g')

    let line = strpart(line, 0, windowwidth - 2 -len(foldedlinecount))
    let fillcharcount = windowwidth - len(line) - len(foldedlinecount)
    return line . '…' . repeat(" ",fillcharcount) . foldedlinecount . '…' . ' '
endfunction " }}}
set foldtext=MyFoldText()

" }}}
" Autocorrect ------------------------------------------------------------- {{{

" Every time god damn it
iab ednl endl
iab ednkl endl;
iab nedl endl

iab inculde include
iab prgama pragma

" }}}
