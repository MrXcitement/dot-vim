" vim:fdm=marker:
"
" .vimrc -- Vim Configuration File.
"
" Mike Barker <mike@thebarkers.com>
"
" Enable file type detection. {{{
" Use the default filetype settings, so that mail gets 'tw' set to 72,
" 'cindent' is on in C files, etc.
" Also load indent files, to automatically do language-dependent indenting.
filetype plugin indent on
" }}}
" Editor settings {{{
set nocompatible    " be iMproved, required by vundle
set encoding=utf-8  " handle unicode files
set backspace=indent,eol,start " allow backspacing over everything in insert mode
set history=50      " keep 50 lines of command line history
set ruler           " show the cursor position all the time
set showcmd         " display incomplete commands
set nowrap          " Whitespace
set showmatch       " Set viewing matched braces, brackets and parens
" }}}
" Completion {{{
set omnifunc=syntaxcomplete#Complete    " omni complete all
set completeopt=menuone,longest,preview
" }}}
" Line number - relative numbers with current line number {{{
set number          " display line numbers
set relativenumber  " display relative number from current line
" }}}
" Searching {{{
set hlsearch
set incsearch
set ignorecase
set smartcase
" }}}
" Indentation {{{
" at http://vimcasts.org/episodes/tabs-and-spaces/
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
" }}}
" Set OS specific paths {{{
" }}}
"Vundle - the vim plugin bundler {{{
filetype off " required by vundle

if has("win32") || has("win16")
    let s:vim_path = expand("~/vimfiles")
else
    let s:vim_path = expand("~/.vim")
endif
let s:vundle_path = s:vim_path . "/bundle/Vundle.vim"
let s:vundle_readme = expand(s:vundle_path . "/README.md")

" Only initialize the vundle stuff if it is installed
if filereadable(s:vundle_readme)

    exe "set rtp+=" . s:vundle_path
    call vundle#begin()

    " let Vunlde manage Vundle, required!
    Plugin 'VundleVim/Vundle.vim'

    " add your plugins here...
    Plugin 'SuperTab'
    Plugin 'tpope/vim-fugitive'
    Plugin 'vim-airline/vim-airline'
    Plugin 'airblade/vim-gitgutter'
    Plugin 'hashivim/vim-vagrant'
    Plugin 'vim-scripts/indentpython.vim'

    " end plugns here
    call vundle#end()

    " vim-airline settings {{{
    set laststatus=2
    " Enable the list of buffers
    let g:airline#extensions#tabline#enabled = 1
    " Show just the filename
    let g:airline#extensions#tabline#fnamemod = ':t'
    " }}}

    " SuperTab settings
    " WTF! Not sure why, but when this line below is enabled, pressing tab
    " inserts the word context and does not tab-complete the current word.
    " Everywhere I see this being set for tab completion to work and yet that
    " is not my experience. For now I have just commented it out.
    "let g:SuperTabDefaultCompletionType = "context"

endif
" }}}
" Configure autocomands {{{
" Only do this part when compiled with support for autocommands.
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

    augroup END     " end of vimrcEx augroup
endif " has("autocmd")
" }}}
" UI Settings, fonts, colors, etc. {{{
if has("gui_running")
    " GUI Settings {{{
    if has("gui_gtk2")
        set guifont=Bitstream\ Vera\ Sans\ Mono\ 10
    elseif has("x11")
        set guifont=-*-courier-medium-r-normal-*-*-180-*-*-m-*-*
    elseif has("win32")
        set guifont=Consolas:h12
    else
        set guifont=Menlo\ for\ Powerline
        let g:airline_powerline_fonts = 1
    endif

    "" Disable the toolbar in gui windows...
    set guioptions-=T

    "" Set the colorscheme
    "colorscheme solarized
    "highlight Pmenu guibg=grey gui=bold
    " }}}
else
    " CUI Settings {{{
    highlight Pmenu ctermbg=blue ctermfg=white
    highlight PmenuSel ctermbg=darkblue ctermfg=white
    let g:airline_left_sep=''   " airline left seperator
    let g:airline_right_sep=''  " airline right seperator
    " }}}
endif
syntax enable
" }}}
" Change <leader> from \ to , {{{
let mapleader=","
" }}}
" remap - <leader>l toggles viewing whitespace {{{
" http://vimcasts.org/episodes/show-invisibles/
" Use TextMate symbols for tabstop and EOLs
" ctrl-v u25b8 for tab
" ctrl-v u00ac for eol
nnoremap <leader>l :set list!<CR>
set listchars=tab:▸\ ,eol:¬
" }}}
" remap - <leader>n turn on/off line number {{{
" http://dancingpenguinsoflight.com/2009/02/python-and-vim-make-your-own-ide/
" <leader>n to toggle line number on off
nnoremap <leader>n :set nonumber!<CR>:set foldcolumn=0<CR>
" }}}
" remap - <leader>v/V to edit/reload vimrc {{{
" http://www.oreillynet.com/onlamp/blog/2006/08/make_your_vimrc_trivial_to_upd_1.html
" <leader>v brings up my .vimrc
" <leader>V reloads it -- making all changes active (have to save first)
nnoremap <silent> <leader>v :e $MYVIMRC<CR>
nnoremap <silent> <leader>V :source $MYVIMRC<CR>:filetype detect<CR>:exe ":echo 'reloaded $MYVIMRC...'"<CR>
" }}}
" remap - window movement shortcuts {{{
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-H> <C-W><C-H>
nnoremap <C-L> <C-W><C-L>
" }}}
" Function OpenURI {{{
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
" }}}
" Function OpenFile {{{
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

nnoremap <Leader>w :call OpenURI()<CR>
nnoremap <leader>W :update<CR>:call OpenFile(expand('%:p'))<CR>
" }}}
