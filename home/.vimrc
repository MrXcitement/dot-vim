" vim:fdm=marker:
"
" .vimrc -- Vim Configuration File.
"
" Mike Barker <mike@thebarkers.com>
"
" Get the running OS {{{
" functions to check what os vim is running on
function! GetRunningOS()
    if has('win32') || has('win64') && &shellcmdflag =~ '/'
        return 'win'
    elseif has('unix')
        if system('uname') =~ 'Darwin'
            return 'mac'
        else
            return 'unix'
        endif
    else
        return '?'
    endif
endfunction
function! IsWin()
    return GetRunningOS() =~ 'win'
endfunction
function! IsMac()
    return GetRunningOS() =~ 'mac'
endfunction
function! IsUnix()
    return GetRunningOS() =~ 'unix'
endfunction
" }}}
" Vundle - the vim plugin bundler {{{
filetype on     " do this to keep turning filetype off from crashing apple's vim
filetype off    " required by Vundle

let vim_path = IsWin() ? expand("$HOME/vimfiles") : expand("$HOME/.vim")
let vundle_path = vim_path . "/bundle/Vundle.vim"

" Check if Vundle is missing
if !isdirectory(vundle_path)
    echoerr 'Vundle is not installed! Use the install script, or clone it.'
    echoerr '$ git clone https://github.com/VundleVim/Vundle.vim ' . vundle_path

else
    " Only initialize the Vundle stuff if it is installed

    exe "set rtp+=" . vundle_path
    call vundle#begin()

    " let Vundle manage Vundle, required!
    Plugin 'VundleVim/Vundle.vim'

    " General plugins...
    Plugin 'tpope/vim-surround'
    Plugin 'farmergreg/vim-lastplace'
    Plugin 'editorconfig/editorconfig-vim'

    " UI plugins...
    Plugin 'vim-airline/vim-airline'
    Plugin 'xolox/vim-misc'
    Plugin 'xolox/vim-colorscheme-switcher'
    Plugin 'MrXcitement/vim-colorscheme-manager'
    
    " DevOps plugins...
    Plugin 'hashivim/vim-vagrant'
    Plugin 'pearofducks/ansible-vim'

    " Completion plugins
    Plugin 'ervandew/supertab'

    " Git/Gist support
    if executable('git')
        Plugin 'airblade/vim-gitgutter'
        Plugin 'tpope/vim-fugitive'
    endif
    Plugin 'mattn/webapi-vim'
    Plugin 'mattn/gist-vim'

    " Markdown support
    Plugin 'nelstrom/vim-markdown-folding'

    " Powershell support
    Plugin 'PProvost/vim-ps1'

    " Python plugins
    if executable('python') || executable('python3')
        Plugin 'hynek/vim-python-pep8-indent'
        Plugin 'tmhedberg/simpylfold'
        Plugin 'nvie/vim-flake8'
    endif

    " Rust plugins
    if executable('rustc')
        Plugin 'rust-lang/rust.vim'
        Plugin 'racer-rust/vim-racer'
    endif

    " Ruby plugins
    if executable('ruby')
        Plugin 'vim-ruby/vim-ruby'
    endif

    " Syntax plugins
    Plugin 'scrooloose/syntastic'

    " Swift plugins
    if executable('swift')
      Plugin 'keith/swift.vim'
    endif

    " end plugns here
    call vundle#end()

    " vim-airline settings {{{
    set laststatus=2
    " Enable the list of buffers
    let g:airline#extensions#tabline#enabled = 1
    " Show just the filename
    let g:airline#extensions#tabline#fnamemod = ':t'
    " Show powerline seperators
    let g:airline_powerline_fonts = 1
    " }}}
    " vim-colorscheme-manager settings {{{
    if !exists('g:colorscheme_switcher_exclude')
        let g:colorscheme_switcher_exclude = []
    endif
    " }}}
    " vim-gitgutter settings {{{
    if IsWin()
        let g:gitgutter_grep = ''
        let g:gitgutter_async = 0
    endif
    " }}}
    " python settings {{{
    " let g:flake8_show_in_gutter=1
    " autocmd FileType python nnoremap <buffer> <leader>f  :call Flake8()<CR>
    " autocmd FileType python nnoremap <buffer> <leader>tf :Pytest file<CR>
    " autocmd FileType python nnoremap <buffer> <leader>tc :Pytest class<CR>
    " autocmd FileType python nnoremap <buffer> <leader>tm :Pytest method<CR>
    " autocmd FileType python nnoremap <buffer> <leader>td :Pytest function<CR>
    " autocmd FileType python nnoremap <buffer> <leader>ts :Pytest session<CR>
    let g:pymode = 1
    " let g:pymode_rope = 1
    " }}}
    " syntastic settings {{{
    set statusline+=%#warningmsg#
    set statusline+=%{SyntasticStatuslineFlag()}
    set statusline+=%*

    let g:syntastic_always_populate_loc_list = 1
    let g:syntastic_auto_loc_list = 1
    let g:syntastic_check_on_open = 1
    let g:syntastic_check_on_wq = 0
    " let g:syntastic_python_checkers = ['flake8', 'pylint']
    " }}}
endif
" }}}
" Editor settings {{{
" Use the default filetype settings, so that mail gets 'tw' set to 72,
" 'cindent' is on in C files, etc.
" Also load indent files, to automatically do language-dependent indenting.
filetype plugin indent on
set backspace=indent,eol,start " allow backspacing over everything in insert mode
if &ttytype != "win32"
    set cursorline  " Highlight the current line, except in win console
endif
set encoding=utf-8  " handle unicode files
set history=50      " keep 50 lines of command line history
set nocompatible    " be iMproved, required by vundle
set nofoldenable    " Do not fold when opening files.
set nowrap          " Whitespace
set ruler           " show the cursor position all the time
set showcmd         " display incomplete commands
set showmatch       " Set viewing matched braces, brackets and parens
" }}}
" Spelling settings {{{
set spelllang=en
set spellfile=$HOME/SynologyDrive/AppData/vim/spell/en.utf-8.add
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
" Autocomands {{{
" Only do this part when compiled with support for autocommands.
if has("autocmd")

    " Put these in an autocmd group, so that we can delete them easily.
    augroup vimrcEx
    au!

    " For all text files set 'textwidth' to 78 characters.
    " autocmd FileType text setlocal textwidth=78
    
    " highlight lines that are longer than the textwidth
    " autocmd BufEnter * highlight OverLength ctermbg=darkgrey guibg=#592929
    " autocmd BufEnter * match OverLength /\%80v.*/

    " Fixup the Omnicompletion popup menu colors
    autocmd ColorScheme * highlight Pmenu ctermbg=Grey ctermfg=Black guibg=Grey guifg=Black
    autocmd ColorScheme * highlight PmenuSel ctermbg=DarkGrey ctermfg=Grey guibg=Black guifg=Grey
    
    augroup END     " end of vimrcEx augroup
endif " has("autocmd")
" }}}
" UI Settings, fonts, colors, etc. {{{
syntax enable
if has("gui_running")
    if has("gui_gtk")
        set guifont=DejaVu\ Sans\ Mono\ 10
    elseif has("gui_win32")
        set guifont=FiraCode-Regular:h10,Consolas:h10
    elseif has('gui_mac') || has('gui_macvim')
        set guifont=FiraCodeNerdFontComplete-Regular:h12,Monaco:h12
        if &guifont ==? 'Nerd'
            set macligatures
        endif
    elseif has("x11")
        set guifont=-*-courier-medium-r-normal-*-*-180-*-*-m-*-*
    endif

    "" Disable the toolbar in gui windows...
    set guioptions-=T

    "" Keep gui colorscheme seperate from cui/term colorscheme
    let g:colorscheme_manager_file = vim_path . '/.gcolorscheme'
else
    " Cursor Shapes for different modes
    let &t_SI = "\<Esc>[5 q"  "Insert Mode: Blinking vertical bar
    let &t_SR = "\<Esc>[3 q"  "Replace Mode: Blinking underscore
    let &t_EI = "\<Esc>[1 q"  "Normal Mode: Blinking block
endif
" }}}
" Change <leader> from \ to , {{{
let mapleader=","
" }}}
" remap - <leader>s toggle spell checking on and off {{{
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
nnoremap <silent> <leader>V :source $MYVIMRC<CR>:filetype detect<CR>:exe ":echo 'reloaded' $MYVIMRC"<CR>
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
