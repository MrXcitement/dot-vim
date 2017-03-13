" vim:fdm=marker:
"
" .vimrc -- Vim Configuration File.
"
" Mike Barker <mike@thebarkers.com>
"
" OS specific paths {{{
" check if running under windows and in a non-posix shell
let mswin = (has('win32') || has('win64')) && &shellcmdflag =~ '/'
let vim_path = mswin ? expand("$HOME/vimfiles") : expand("$HOME/.vim")
" }}}
" Vundle - the vim plugin bundler {{{
filetype on     " do this to keep turning filetype off from crashing apple's vim
filetype off    " required by Vundle
let vundle_path = vim_path . "/bundle/Vundle.vim"
let vundle_readme = expand(vundle_path . "/README.md")

" Only initialize the Vundle stuff if it is installed
if filereadable(vundle_readme)

    exe "set rtp+=" . vundle_path
    call vundle#begin()

    " let Vundle manage Vundle, required!
    Plugin 'VundleVim/Vundle.vim'

    " General plugins...
    Plugin 'tpope/vim-surround'

    " UI plugins...
    Plugin 'vim-airline/vim-airline'
    Plugin 'xolox/vim-misc'
    Plugin 'xolox/vim-colorscheme-switcher'
    Plugin 'MrXcitement/vim-colorscheme-manager'
    
    " Git/Gist support
    Plugin 'airblade/vim-gitgutter'
    Plugin 'tpope/vim-fugitive'
    Plugin 'mattn/webapi-vim'
    Plugin 'mattn/gist-vim'

    " DevOps plugins...
    Plugin 'hashivim/vim-vagrant'
    Plugin 'pearofducks/ansible-vim'

    " Completion plugins
    "Plugin 'Valloric/YouCompleteMe'
    Plugin 'SuperTab'

    " Python plugins
    "Plugin 'hynek/vim-python-pep8-indent'
    "Plugin 'nvie/vim-flake8'
    "Plugin 'tmhedberg/simpylfold'
    "Plugin 'lambdalisue/vim-pyenv'
    "Plugin 'davidhalter/jedi-vim'

    " Rust plugins
    Plugin 'rust-lang/rust.vim'
    Plugin 'racer-rust/vim-racer'

    " end plugns here
    call vundle#end()

    " ycm setup {{{
    "let g:ycm_server_python_interpreter = '/Users/mike/.pyenv/versions/2.7.11/bin/python'
    "let g:ycm_python_binary_path='python'
    "let g:ycm_rust_src_path = expand("$HOME/src/rust/src")
    " }}}
    " vim-airline settings {{{
    set laststatus=2
    " Enable the list of buffers
    let g:airline#extensions#tabline#enabled = 1
    " Show just the filename
    let g:airline#extensions#tabline#fnamemod = ':t'
    " }}}
    " vim-colorscheme-manager settings {{{
    if !exists('g:colorscheme_switcher_exclude')
        let g:colorscheme_switcher_exclude = []
    endif
    " }}}
    " python settings {{{
    "let g:flake8_show_in_gutter=1
    "let g:jedi#force_py_version=3 
    "if jedi#init_python()
    "    function! s:jedi_auto_force_py_version() abort
    "        let major_version = pyenv#python#get_internal_major_version()
    "        call jedi#force_py_version(major_version)
    "    endfunction
    "    augroup vim-pyenv-custom-augroup
    "        autocmd! *
    "        autocmd User vim-pyenv-activate-post   call s:jedi_auto_force_py_version()
    "        autocmd User vim-pyenv-deactivate-post call s:jedi_auto_force_py_version()
    "    augroup END
    "endif
    " }}}
endif
" }}}
" Editor settings {{{
" Use the default filetype settings, so that mail gets 'tw' set to 72,
" 'cindent' is on in C files, etc.
" Also load indent files, to automatically do language-dependent indenting.
filetype plugin indent on
set nocompatible    " be iMproved, required by vundle
set encoding=utf-8  " handle unicode files
set backspace=indent,eol,start " allow backspacing over everything in insert mode
set history=50      " keep 50 lines of command line history
set ruler           " show the cursor position all the time
set showcmd         " display incomplete commands
set nowrap          " Whitespace
set showmatch       " Set viewing matched braces, brackets and parens
" }}}
" Spelling settings {{{
set spelllang=en
set spellfile=$HOME/Dropbox/apps/vim/spell/en.utf-8.add
" }}}
" Completion {{{
set omnifunc=syntaxcomplete#Complete    " omni complete all
set completeopt=menuone,longest,preview
" }}}
" Show line numbers {{{
" - relative numbers with current line number 
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
" Configure autocomands {{{
" Only do this part when compiled with support for autocommands.
if has("autocmd")

    " Put these in an autocmd group, so that we can delete them easily.
    augroup vimrcEx
    au!

    " For all text files set 'textwidth' to 78 characters.
    autocmd FileType text setlocal textwidth=78

    " jump to last known position {{{
    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid or when inside an event handler
    " (happens when dropping a file on gvim).
    autocmd BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal g`\"" |
        \ endif
    "}}}
    " python flake8 setup {{{
    autocmd FileType python nnoremap <buffer> <leader>f :call Flake8()<cr>
    autocmd BufWritePost *.py cal Flake8()
    " }}}
    " SimplyFold setup {{{
    autocmd BufWinEnter *.py setlocal foldexpr=SimpylFold(v:lnum) foldmethod=expr
    autocmd BufWinLeave *.py setlocal foldexpr< foldmethod<
    " }}}
    augroup END     " end of vimrcEx augroup
endif " has("autocmd")
" }}}
" UI Settings, fonts, colors, etc. {{{
if has("gui_running")
    " GUI Settings {{{
    if has("gui_gtk")
        set guifont=DejaVu\ Sans\ Mono\ 10
    elseif has("gui_win32")
        set guifont=Consolas:h10
    elseif has('gui_mac') || has('gui_macvim')
        set guifont=Menlo\ for\ Powerline:h12
        let g:airline_powerline_fonts = 1
    elseif has("x11")
        set guifont=-*-courier-medium-r-normal-*-*-180-*-*-m-*-*
    endif

    "" Disable the toolbar in gui windows...
    set guioptions-=T

    "" Keep gui colorscheme seperate from cui/term colorscheme
    let g:colorscheme_manager_file = vim_path . '/.gcolorscheme'
    " }}}
else
    " CUI Settings {{{
    highlight Pmenu ctermbg=blue ctermfg=white
    highlight PmenuSel ctermbg=darkblue ctermfg=white
    " }}}
endif
syntax enable
" }}}
" Change <leader> from \ to , {{{
let mapleader=","
" }}}
" nnoremap - <leader>s toggle spell checking on and off {{{
nnoremap <silent> <leader>s :set spell!<CR>
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
nnoremap <leader>n :set nonumber!<CR>:set foldcolumn=0<CR>
" }}}
" remap - <leader>v/V to edit/reload vimrc {{{
" http://www.oreillynet.com/onlamp/blog/2006/08/make_your_vimrc_trivial_to_upd_1.html
" <leader>v brings up my .vimrc
" <leader>V reloads it -- making all changes active (have to save first)
nnoremap <silent> <leader>v :e $MYVIMRC<CR>
nnoremap <silent> <leader>V :source $MYVIMRC<CR>:filetype detect<CR>:exe ":echo 'reloaded $MYVIMRC...'"<CR>
" }}}
" remap - <leader>c toggle cursorline and cursorcolum {{{
nnoremap <Leader>c :set cursorline! cursorcolumn!<CR>
" }}}
" remap - window movement shortcuts {{{
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-H> <C-W><C-H>
nnoremap <C-L> <C-W><C-L>
" }}}
" remap - remove arrow key mapping {{{
noremap <Up> <nop>
noremap <Down> <nop>
noremap <Left> <nop>
noremap <Right> <nop>
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
" host: eeyore setup {{{
let hostname = substitute(system('hostname'), '\n', '', '')
if hostname == "eeyore" 
    set pythonthreedll=c:\python3\python35.dll
endif
"}}}
