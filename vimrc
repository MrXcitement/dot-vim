""
" .vimrc -- Vim Configuration File.
"
" Mike Barker <mike@thebarkers.com>
"
set nocompatible	" vi compatability disabled

"" Only do this part when compiled with support for autocommands.
if has("autocmd")

	" load Vundle
	" Setting up Vundle - the vim plugin bundler
	let iCanHazVundle=1
	let vundle_readme=expand('~/.vim/bundle/vundle/README.md')
	if !filereadable(vundle_readme)
		echo "Installing Vundle..."
		echo ""
		silent !mkdir -p ~/vim/bundle
		silent !git clone https://github.com/gmarik/vundle ~/.vim/bundle/vundle
		let iCanHazVundle=0
	endif
	set rtp+=~/.vim/bundle/vundle/
	call vundle#rc()
	Plugin 'gmarik/vundle'
	
	" add your plugins here...
	Plugin 'Solarized'
	Plugin 'minibufexpl.vim'
	Plugin 'SuperTab'

	" end plugns here	
	if iCanHazVundle == 0
		echo "Installing Plugins..."
		echo ""
		:PluginInstall
	endif
	
	" miniBufExplorer settings
	let g:miniBufExplMapWindowNavVim = 1
	let g:miniBufExplMapWindowNavArrows = 1
	let g:miniBufExplMapCTabSwitchBufs = 1
	let g:miniBufExplModSelTarget = 1

	" SuperTab settings
	let g:SuperTabDefaultCompletionType = "context"
	set completeopt=menuone,longest,preview

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
	
	" Python code completion
	autocmd FileType python set omnifunc=pythoncomplete#Complete
	
	augroup END		" end of vimrcEx augroup


else
	set autoindent		" always set autoindenting on

endif " has("autocmd")

"" Set the font to use
if has("gui_running")
	if has("gui_gtk2")
		set gfn=Bitstream\ Vera\ Sans\ Mono\ 10

	elseif has("x11")
		set guifont=-*-courier-medium-r-normal-*-*-180-*-*-m-*-*

	else
		set guifont=Droid\ Sans\ Mono\ Slashed:h12

	endif
	"" Disable the toolbar in gui windows...
	set guioptions-=T

	"" Set the colorscheme
	colorscheme solarized
	highlight Pmenu guibg=grey gui=bold

else
	highlight Pmenu ctermbg=238 gui=bold

endif

"" Base settings
syntax enable

" Enable file type detection.
" Use the default filetype settings, so that mail gets 'tw' set to 72,
" 'cindent' is on in C files, etc.
" Also load indent files, to automatically do language-dependent indenting.
filetype plugin indent on

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

" Change <leader> from \ to ,
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
" I changed this command to use \n for the shortcut
nnoremap <leader>n :set nonumber!<CR>:set foldcolumn=0<CR>

"""
" http://www.oreillynet.com/onlamp/blog/2006/08/make_your_vimrc_trivial_to_upd_1.html
"<leader>v brings up my .vimrc
"<leader>V reloads it -- making all changes active (have to save first)
nmap <silent> <leader>v :e $MYVIMRC<CR>
nmap <silent> <leader>V :source ~/.vimrc<CR>:filetype detect<CR>:exe ":echo 'vimrc reloaded'"<CR>

""
" Open a web-browser with the URL in the current line
" http://vim.wikia.com/wiki/Open_a_web-browser_with_the_URL_in_the_current_line 
" 2013-04-05 MRB - Modified to handle Apple's native vim as well as MacVim
" by moving the system check under has('unix') and then testing the uname
" value.
function! OpenURI()
	let s:uri = matchstr(getline("."), '[a-z]*:\/\/[^ >,;:]*')
	if s:uri != ""
		echo s:uri
		if has("win32")
			exec ":silent !start \"" . s:uri . "\""
		elseif has("unix")
			let os=substitute(system('uname'), '\n', '', '')
			if os == 'Darwin' || os == 'Mac'
				exec ":silent !open \"" . s:uri . "\""
			else
				exec ":silent !xdg-open \"" . s:uri . "\""
			endif
		endif
	else
		echo "No URI found in current line."
	endif
endfunction
map <Leader>w :call OpenURI()<CR>


" MRB - End Personal Settings
"""
