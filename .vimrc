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
set laststatus=2       " Always show the status bar (airline!)
set noshowmode         " airline shows mode so vim doesn't need to
set number             " Show line numbers
set cursorline         " Highlight the line the cursor is on.

set mouse=a            " Mouse support in all modes
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

" Resize splits when the window is resized
au VimResized * :wincmd =

" Remote system clipboard integration
vmap <C-c> y:call system("~/bin/sendclipboard", getreg("\""))<CR>

" }}}
" Plugin Setup ------------------------------------------------------------ {{{

let g:plug_timeout = 9999

call plug#begin()

Plug 'tpope/vim-sensible'       " Sensible defaults.
Plug 'scrooloose/nerdtree'      " Workspace explorer
Plug 'kien/ctrlp.vim'           " Sublime-like fuzzy search
Plug 'vim-scripts/a.vim'        " Toggle between source and headers
" tpope/vim-vinegar             " Directory listing enhancer
Plug 'myint/indent-finder'      " Sets tab settings based on current file
Plug 'bling/vim-airline'        " Powerline!
Plug 'tpope/vim-commentary'     " Allow commenting blocks of code
Plug 'tpope/vim-surround'       " For manipulating surrounding text
Plug 'Lokaltog/vim-easymotion'  " Move around quickly
Plug 'tpope/vim-fugitive'       " Git integration
Plug 'wikitopian/hardmode'      " Disable basic navigation commands to become familiar with more advanced ones
Plug 'SirVer/ultisnips'         " Snippets - Engine
Plug 'honza/vim-snippets'       " Snippets - Actual snippits
Plug 'wesQ3/vim-windowswap'     " Swap two open windows without dorking up the layout
                                " (<leader>ww in one window, then <leader>ww in another and they will swap)
Plug 'vim-scripts/LanguageTool' " Grammar check.
Plug 'gerw/vim-latex-suite'     " LaTeX stuff.
" Plug 'bkad/CamelCaseMotion'   " CamelCase movements
Plug 'godlygeek/tabular'        " Shift code around easily. Also required for vim-markdown.
Plug 'plasticboy/vim-markdown'  " Syntax highlighting, matching rules and mappings for Markdown.
Plug 'vasconcelloslf/vim-interestingwords' " <leader>k to highlight words, <leader>K to clear.
Plug 'amfl/mrc.vim'             " mIRC script syntax highlighting

" COLORS AND THEMES
Plug 'flazz/vim-colorschemes'           " A big pack of color schemes
Plug 'godlygeek/csapprox'               " Automatically convert gvim true color themes into 256 color terminal approximations
Plug 'vim-scripts/ScrollColors'         " Colorscheme explorer so we can see what we have available
                                        " Type :SCROLL to scroll through colorschemes with left/right arrows.
Plug 'junegunn/rainbow_parentheses.vim' " RAINBOW PARENS!

" Additional plugins which are only for big crunchy machines.
" The g:heavyweight variable can be set in .vimrc.local to enable.
" (See the top of this file)
if exists("g:heavyweight")
	Plug 'Valloric/YouCompleteMe' " Code completion! Note that this has a compiled component.
	Plug 'scrooloose/syntastic'   " Static code analysis
endif

if has('gui_running')
	Plug 'vim-scripts/zoom.vim'
endif

call plug#end()

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

" Tabs
noremap <C-\> gt
noremap <C-]> gT
noremap <C-t> :tabnew<CR>

" Keep search matches in the middle of the window.
nnoremap n nzzzv
nnoremap N Nzzzv

" Easier to type, and I never use the default behavior.
noremap H ^
noremap L $
vnoremap L g_

" Bind c-a and c-e to behave as in shell in insert mode
inoremap <c-a> <esc>I
inoremap <c-e> <esc>A
cnoremap <c-a> <home>
cnoremap <c-e> <end>

" Remap some commonly used commands to leader key for speed
nnoremap <leader>w :w<CR>
nnoremap <leader>e :e 
nnoremap <leader>q :q<CR>

" Quicksave sessions
map <F2> :mksession! ~/.vim_session <cr> " Quick write session with F2
map <F3> :source ~/.vim_session <cr>     " And load session with F3

" Dump timestamp
let tzformat = "%Y.%m.%d"
:nnoremap <F5> "=strftime(g:tzformat)<CR>P
:inoremap <F5> <C-R>=strftime(g:tzformat)<CR>

" Paste without auto-indent problems
nnoremap <leader>p :set invpaste paste?<CR>

" Plugin Remaps ----------------------------------------------------------- {{{

" Switch between source and header
noremap <leader>h :A!<CR>
" Toggle hardmode
nnoremap <leader>/ <Esc>:call ToggleHardMode()<CR>
" Open file browser
nmap ge :NERDTreeToggle<CR>
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

" }}}
" Prose ------------------------------------------------------------------- {{{

" .md files are markdown instead of Modula-2
autocmd BufNewFile,BufReadPost *.md set filetype=markdown

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

let g:current_theme = "none"
function SetTheme(theme)
	if (a:theme == g:current_theme)
		" No action needs to be taken.
		return
	endif
	if (a:theme == "default")
		" colorscheme molokai
		colorscheme gruvbox
		let g:gruvbox_guisp_as_guifg=1
		let g:gruvbox_italic=1
		let g:gruvbox_italicize_comments=0

		syntax on                    " Enable syntax highlighting
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
		syntax on
		" hi Normal ctermfg=lightgrey
	endif

	let g:current_theme = a:theme
endfunction

" Automatically switch themes based on the currently open filetype.
:autocmd BufEnter,FileType *
	\   if &ft ==# 'markdown' | call SetTheme("prose") |
	\   else | call SetTheme("default") |
	\   endif

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
