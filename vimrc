""
" .vimrc -- Vim Configuration File.
"
" Mike Barker <mike@thebarkers.com>
"
set nocompatible	" be iMproved, required by vundle
filetype off " required by vundle

"" Set OS specific vars here
if has("win32") || has("win16")
	let s:vim_path = expand("~/vimfiles")
else
	let s:vim_path = expand("~/.vim")
endif

"" Setting up Vundle - the vim plugin bundler
let s:vundle_path = s:vim_path . "/bundle/Vundle.vim"
let s:vundle_readme = s:vundle_path . "/README.md"

" Only initialize the vundle stuff if it is installed
if filereadable(s:vundle_readme)

	exe "set rtp+=" . s:vundle_path
	call vundle#begin()

	" let Vunlde manage Vundle, required!
	Plugin 'VundleVim/Vundle.vim'

	" add your plugins here...
	"Plugin 'Solarized'
	Plugin 'bling/vim-airline'
	Plugin 'minibufexpl.vim'
	Plugin 'SuperTab'

	" end plugns here	
	call vundle#end()

	" vim-airline settings
	set laststatus=2

	" miniBufExplorer settings
	let g:miniBufExplMapWindowNavVim = 1
	let g:miniBufExplMapWindowNavArrows = 1
	let g:miniBufExplMapCTabSwitchBufs = 1
	let g:miniBufExplModSelTarget = 1

	" SuperTab settings
	let g:SuperTabDefaultCompletionType = "context"
	set completeopt=menuone,longest,preview

endif

"" Only do this part when compiled with support for autocommands.
if has("autocmd")

	" Put these in an autocmd group, so that we can delete them easily.
	augroup vimrcEx
	au!

	" For all text files set 'textwidth' to 78 characters.
	autocmd FileType text setlocal textwidth=78

	" When editing a file, always jump to the last known cursor position.
	" Don't do it when the position is invalid or when inside an event handler
	" (happens when dropping a file on gvim).
	autocmd BufReadPost *
		\ if line("'\"") > 0 && line("'\"") <= line("$") |
		\   exe "normal g`\"" |
		\ endif
	
	augroup END		" end of vimrcEx augroup
	
endif " has("autocmd")

"" UI Settings, fonts, colors, etc.
if has("gui_running")
	if has("gui_gtk2")
		set guifont=Bitstream\ Vera\ Sans\ Mono\ 10

	elseif has("x11")
		set guifont=-*-courier-medium-r-normal-*-*-180-*-*-m-*-*

	else
		set guifont=Droid\ Sans\ Mono\ Slashed:h12

	endif

	"" Disable the toolbar in gui windows...
	set guioptions-=T

	"" Set the colorscheme
	"colorscheme solarized
	"highlight Pmenu guibg=grey gui=bold

else
	"colorscheme slate
	"highlight Pmenu ctermbg=238 gui=bold

endif

"" Base settings
syntax enable

" Enable file type detection.
" Use the default filetype settings, so that mail gets 'tw' set to 72,
" 'cindent' is on in C files, etc.
" Also load indent files, to automatically do language-dependent indenting.
filetype plugin indent on

"" omni complete all
"set omnifunc=syntaxcomplete#Complete

"" handle unicode files
set encoding=utf-8

"" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set history=50		" keep 50 lines of command line history
set ruler			" show the cursor position all the time
set showcmd			" display incomplete commands

"" Whitespace
set nowrap

"" Searching
set hlsearch
set incsearch
set ignorecase
set smartcase

"""
" http://vimcasts.org/episodes/tabs-and-spaces/ 
" Set how tabs are handled
set ts=4 sts=4 sw=4 noexpandtab
" Set viewing matched braces, brackets and parens
set showmatch

"" Change <leader> from \ to ,
let mapleader=","

"""
" http://vimcasts.org/episodes/show-invisibles/
" <leader>l toggles viewing whitespace.
nmap <leader>l :set list!<CR>
" Use TextMate symbols for tabstop and EOLs 
" ctrl-v u25b8 for tab
" ctrl-v u00ac for eol
set listchars=tab:▸\ ,eol:¬

"""
" http://dancingpenguinsoflight.com/2009/02/python-and-vim-make-your-own-ide/
" <leader>n to toggle line number on off
nnoremap <leader>n :set nonumber!<CR>:set foldcolumn=0<CR>

"""
" http://www.oreillynet.com/onlamp/blog/2006/08/make_your_vimrc_trivial_to_upd_1.html
" <leader>v brings up my .vimrc
" <leader>V reloads it -- making all changes active (have to save first)
nmap <silent> <leader>v :e $MYVIMRC<CR>
nmap <silent> <leader>V :source $MYVIMRC<CR>:filetype detect<CR>:exe ":echo 'reloaded $MYVIMRC...'"<CR>

""
" Open a web-browser with the URL in the current line
" http://vim.wikia.com/wiki/Open_a_web-browser_with_the_URL_in_the_current_line 
" 2013-04-05 MRB - Modified to handle Apple's native vim as well as MacVim
" by moving the system check under has('unix') and then testing the uname
" value.
" 2015-06-22 MRB - Refactor out opening the URI into OpenFile() so that
" it can be used to open the current file in the default app for the
" file type being edited. i.e. open the current html file in the default
" browser.
function! OpenURI()
	let s:uri = matchstr(getline("."), '[a-z]*:\/\/[^ >,;:"]*')
	if s:uri != ""
		call OpenFile(s:uri)
	else
		echohl WarningMsg
		echom "No URI found in current line."
		echohl None
	endif
endfunction

""
" Open a file or uri
function! OpenFile(f)
	let s:file=a:f
	let s:cmd=""
	if has("win32")
		let s:cmd = ":silent !start \"" . s:file . "\""
	elseif has("unix")
		let os=substitute(system('uname'), '\n', '', '')
		if os == 'Darwin' || os == 'Mac'
			let s:cmd = ":silent !open \"" . s:file . "\"" 
		else
			let s:cmd = ":silent !xdg-open \"" . s:file . "\""
		endif
	endif
	exec s:cmd
	redraw!
	echom s:cmd
endfunction
nmap <Leader>w :call OpenURI()<CR>
nmap <leader>W :update<CR>:call OpenFile(expand('%:p'))<CR>

" MRB - End Personal Settings
"""
