set nocompatible              " be iMproved, required
filetype off                  " required

" Include local configs
if filereadable(glob("~/.vimrc.local"))
	source ~/.vimrc.local
endif

"==========================================
" VUNDLE SETUP
"==========================================
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'
" Sensible defaults
Plugin 'tpope/vim-sensible'
" Workspace explorer
Plugin 'scrooloose/nerdtree'
" Sublime-like fuzzy search
Plugin 'kien/ctrlp.vim'
" Toggle between source and headers
Plugin 'vim-scripts/a.vim'
" Directory listing enhancer
" tpope/vim-vinegar
" Sets tab settings based on current file
Plugin 'myint/indent-finder'
" Powerline!
" Plugin 'Lokaltog/vim-powerline'
Plugin 'bling/vim-airline'
" Allow commenting blocks of code
Plugin 'tpope/vim-commentary'
" For manipulating surrounding text
Plugin 'tpope/vim-surround'
" Move around quickly
Plugin 'Lokaltog/vim-easymotion'
" Git integration
Plugin 'tpope/vim-fugitive'
" Disable basic navigation commands to become familiar with more advanced ones
Plugin 'wikitopian/hardmode'
" Snippets - Engine
Plugin 'SirVer/ultisnips'
" Snippets - Actual snippits
Plugin 'honza/vim-snippets'
" Swap two open windows without dorking up the layout
" (<leader>ww in one window, then <leader>ww in another and they will swap)
Plugin 'wesQ3/vim-windowswap'
" Grammar check.
Plugin 'vim-scripts/LanguageTool'
" LaTeX stuff.
Plugin 'gerw/vim-latex-suite'
" CamelCase movements
" Plugin 'bkad/CamelCaseMotion'

" Color scheme stuff
" A big pack of color schemes
Plugin 'flazz/vim-colorschemes'
" Automatically convert gvim true color themes into 256 color terminal approximations
Plugin 'godlygeek/csapprox'
" Colorscheme explorer so we can see what we have available
" Type :SCROLL to scroll through colorschemes with left/right arrows.
Plugin 'vim-scripts/ScrollColors'
" RAINBOW PARENS!
Plugin 'junegunn/rainbow_parentheses.vim'

" Additional plugins which are only for big crunchy machines.
" The g:heavyweight variable can be set in .vimrc.local to enable.
" (See the top of this file)
if exists("g:heavyweight")
	" Code completion! Note that this has a compiled component.
	Plugin 'Valloric/YouCompleteMe'
	" Static code analysis
	Plugin 'scrooloose/syntastic'
endif

call vundle#end()            " required
filetype plugin indent on    " required

"==========================================
" REMAPPINGS
"==========================================
" Some stuff taken from:
" http://danielmiessler.com/study/vim/
" http://statico.github.io/vim.html

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

" Remap some commonly used commands to leader key for speed
nnoremap <leader>w :w<CR>
nnoremap <leader>e :e 
nnoremap <leader>q :q<CR>

" Quicksave sessions
map <F2> :mksession! ~/.vim_session <cr> " Quick write session with F2
map <F3> :source ~/.vim_session <cr>     " And load session with F3

" PLUGIN REMAPS

" Switch between source and header
noremap <leader>h :A!<CR>
" Toggle hardmode
nnoremap <leader>/ <Esc>:call ToggleHardMode()<CR>
" Open file browser
nmap ge :NERDTreeToggle<CR>

" CamelCase mappings
" nmap <leader>cw <Plug>CamelCaseMotion_w
" nmap <leader>cb <Plug>CamelCaseMotion_b
" nmap <leader>ce <Plug>CamelCaseMotion_e

nnoremap <leader>r ::RainbowParentheses!!<CR>

set pastetoggle=<F10>  " Hotkey to paste without auto-indent problems

"==========================================
" SYNTASTIC CONFIG
"==========================================

let g:syntastic_python_checkers=['pylint']
let g:syntastic_javascript_checkers=['jshint']

"==========================================
" SNIPPITS AND AUTOCOMPLETE CONFIG
"==========================================

" Trigger configuration. Do not use <tab> if you use Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

"==========================================
" PROSE
"==========================================

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

"==========================================
" COLORS AND THEMES
"==========================================
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

"==========================================
" SEARCHING
"==========================================

set hlsearch             " Highlight all search results

" Case insensitive unless we type caps
" (Force sensitivity by suffixing with \C if neccesary)
set ignorecase  " Need this for smartcase to work
set smartcase

"==========================================
" TAB STUFF
"==========================================

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

"==========================================
" MISC
"==========================================

set omnifunc=syntaxcomplete#Complete   " Do autocomplete
set encoding=utf-8
set laststatus=2       " Always show the status bar (airline!)
set noshowmode         " airline shows mode so vim doesn't need to
set number             " Show line numbers
set foldmethod=marker  " Fold on markers in source
set mouse=a            " Mouse support
" http://vim.wikia.com/wiki/Using_the_mouse_for_Vim_in_an_xterm

:set listchars=tab:▸\ ,eol:¬,trail:-,extends:>,precedes:<,nbsp:+  " Special characters...
:set list                     " ...Please show them

set splitbelow         " Open new splits below and to the right
set splitright

" Remote system clipboard integration
vmap <C-c> y:call system("~/bin/sendclipboard", getreg("\""))<CR>

