set nobin
set eol
au BufEnter * set eol nobin
" http://stackoverflow.com/questions/164847/what-is-in-your-vimrc
" Make Vim more useful
set nocompatible
" Use the OS clipboard by default (on versions compiled with `+clipboard`)
set clipboard=unnamed
" Enhance command-line completion
set wildmenu
" Allow cursor keys in insert mode
"set esckeys
" Allow backspace in insert mode
set backspace=indent,eol,start
" Optimize for fast terminal connections
set ttyfast
" Add the g flag to search/replace by default
set gdefault
" Use UTF-8 without BOM
set encoding=utf-8 nobomb
" Don’t add empty newlines at the end of files
"set binary
"set noeol
" Respect modeline in files
set modeline
set modelines=4
" Enable per-directory .vimrc files and disable unsafe commands in them
"set exrc
"set secure
" Enable line numbers
set number
" Enable mouse in all modes
set mouse=a
" Disable error bells
set noerrorbells
" Don’t reset cursor to start of line when moving around.
set nostartofline
" Don’t show the intro message when starting Vim
set shortmess=atI
" Show the current mode
set showmode
" Show the filename in the window titlebar
set title
" Show the (partial) command as it’s being typed
set showcmd
" Use relative line numbers
if exists("&relativenumber")
    set relativenumber
    au BufReadPost * set relativenumber
endif
" Big history
set history=1000
" do not store global and local values in a session
" http://stackoverflow.com/questions/1642611/how-to-save-a-session-in-vim
set ssop-=options
" change the mapleader from \ to ,
let mapleader=","

" http://www.vim.org/scripts/script.php?script_id=365
" http://www.thegeekstuff.com/2009/02/make-vim-as-your-bash-ide-using-bash-support-plugin
" bash-support
let g:BASH_AuthorName   = $LOGNAME
let g:BASH_Email        = $USERMAIL

" Multiple vim configurations
" http://stackoverflow.com/questions/1889602/multiple-vim-configurations
function! CheckCustomConfiguration()
    let this_dir=expand('%:p:h')
    let custom_conf=escape(this_dir.'/.vim', ' \')
    if (filereadable(custom_conf))
        execute "source " . custom_conf
    endif

    au BufNewFile,BufRead *.tex call CheckCustomConfiguration()
endfunction

augroup vimrc_optimizations
    " http://stackoverflow.com/questions/4775605/vim-syntax-highlight-improve-performance
    " http://vim.wikia.com/wiki/Fix_syntax_highlighting
    set nocursorcolumn
    set nocursorline
    syntax sync minlines=100
    syntax sync minlines=200
    let g:tex_fast= ""
augroup END

augroup vimrc_CheckCustomConfiguration
    let this_dir=expand('%:p:h')
    let custom_conf=escape(this_dir.'/.vim', ' \')
    if (filereadable(custom_conf))
        execute "source " . custom_conf
    endif
augroup END

augroup vimrc_swapsbackups
    " Centralize backups, swapfiles and undo history
    set backup
    set backupdir=~/.vim/backup,.,/tmp
    set directory=~/.vim/swap,/tmp

    " Incremental Backups
    " http://vimdoc.sourceforge.net/htmldoc/options.html#'backupext'
    au BufWritePre * let &bex = '-' . strftime("%y%m%d-%Hh%M") .глооф

    set undodir=~/.vim/undo
    set undofile
augroup END

augroup vimrc_highlights
    " Enable syntax highlighting
    "  syntax on
    " Highlight current line
    set cursorline

    " http://stackoverflow.com/questions/1551231/highlight-variable-under-cursor-in-vim-like-in-netbeans
    autocmd CursorMoved * exe printf('match IncSearch /\V\<%s\>/', escape(expand('<cword>'), '/\'))

    " Show the cursor position
    set ruler
augroup END

augroup vimrc_search
    " Highlight searches
    set hlsearch
    " Ignore case of searches
    set ignorecase
    " Highlight dynamically as pattern is typed
    set incsearch
    " http://stackoverflow.com/questions/657447/vim-clear-last-search-highlighting
    nnoremap <silent> <Esc> :noh<CR><Esc>
augroup END

augroup vimrc_outlook
    " Make tabs as wide as four spaces
    set tabstop=4
    " size of an indent"
    set shiftwidth=4
    " Show “invisible” characters
    set lcs=tab:▸\ ,trail:·,eol:¬,nbsp:_
    set list
    set iskeyword+=.
    " http://stackoverflow.com/questions/235439/vim-80-column-layout-concerns
    if exists('+colorcolumn')
        set colorcolumn=81
    else
        au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>81v.\+', -1)
    endif
augroup END

augroup vimrc_colorscheme
    if $COLORTERM == 'gnome-terminal'
        set term=gnome-256color
        colorscheme railscat
    endif
augroup END

augroup vimrc_behavior
    " Start scrolling three lines before the horizontal window border
    set scrolloff=3
augroup END

augroup vimrc_statusline
    " Always show status line
    set laststatus=2
    set statusline =%<%f
    set statusline+=\ %h%m%r%=%-14.(%l,%c%)
    set statusline+=\ %P
    " http://vim.wikia.com/wiki/Show_fileencoding_and_bomb_in_the_status_line
    set statusline+=\ %{\"[\".(&fenc==\"\"?&enc:&fenc).((exists(\"+bomb\")\ &&\ &bomb)?\",B\":\"\").\"]\ \"} 
    set statusline+=\ %0*0x%04B
    set statusline+=\ %*
augroup END

augroup vimrc_REFINEME
    " Strip trailing whitespace (,ss)
    function! StripWhitespace()
        let save_cursor = getpos(".")
        let old_query = getreg('/')
        :%s/\s\+$//e
        call setpos('.', save_cursor)
        call setreg('/', old_query)
    endfunction

    noremap <leader>sss :call StripWhitespace()<CR>
    " Save a file as root (,W)
    "noremap <leader>W :w !sudo tee % > /dev/null<CR>
    cmap w!! w !sudo tee % >/dev/null

    " Automatic commands
    if has("autocmd")
        " Enable file type detection
        filetype on
        " Treat .json files as .js
        autocmd BufNewFile,BufRead *.json setfiletype json syntax=javascript
		autocmd BufNewFile,BufRead *Dockerfile setfiletype conf
    endif
augroup END

augroup vimrc_filetype
    " au FileType java unmap <silent> <F6>

    " set up syntax folding automatically for XML files
    let g:xml_syntax_folding=1
    au FileType xml setl foldmethod=syntax
    au FileType python setl ts=8 et sw=4 sts=4
    au FileType conf setl ts=4 et sw=4 sts=4
    au FileType sh setl ts=4 et sw=4 sts=4
    au FileType javascript setl ts=2 et sw=2 sts=2
augroup END

augroup vimrc_cpp
    "  au BufNewFile,BufRead *.sty set filetype=texsty | set foldmethod=syntax
    "  au BufNewFile,BufRead *.sty set filetype=tex | set foldmethod=syntax
    au FileType c set lcs=tab:\ \ ,trail:· | set autoread
    au FileType cpp set lcs=tab:\ \ ,trail:· | set autoread
    let g:C_CreateMenusDelayed='yes'
augroup END

augroup vimrc_clangscrathremove
    " Automatically remove the preview window after autocompletion
    " http://stackoverflow.com/questions/3105307/how-do-you-automatically-remove-the-preview-window-after-autocompletion-in-vim
    autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
    autocmd InsertLeave * if pumvisible() == 0|pclose|endif
augroup END

augroup vimrc_cscope
    if has('cscope')
        set cscopetag cscopeverbose

        if has('quickfix')
            set cscopequickfix=s-,c-,d-,i-,t-,e-
        endif

        cnoreabbrev csa cs add
        cnoreabbrev csf cs find
        cnoreabbrev csk cs kill
        cnoreabbrev csr cs reset
        cnoreabbrev css cs show
        cnoreabbrev csh cs help

        command -nargs=0 Cscope cs add $VIMSRC/src/cscope.out $VIMSRC/src
    endif
augroup END

augroup vimrc_plugins
    let g:vimwiki_list = [{'path': '~/Documents/Dropbox/vimwiki/',
                \ 'path_html': '~/Documents/Dropbox/vimwiki/html/'}]

    let g:C_UseTool_cmake = 'yes'
    let g:C_UseTool_doxygen = 'yes'
augroup END

augroup vimrc_tags
    set tags=./tags;/
    let Tlist_Auto_Open = 1
    let Tlist_Compact_Format = 1
augroup END

augroup vimrc_maps
    map <silent> <Esc><Esc> :w<CR>
    " https://github.com/fholgado/minibufexpl.vim
    let g:miniBufExplCycleArround = 1
    noremap <silent> <C-Tab> :bn<CR>
    noremap <silent> <C-S-Tab> :bp<CR>
    inoremap <silent> <C-Tab> <esc>:bn<CR>i
    inoremap <silent> <C-S-Tab> <esc>:bp<CR>i

    map <C-w><C-w> :Kwbd<CR>

    map <F2> :if exists("g:syntax_on") <Bar>
                \   syntax off <Bar>
                \ else <Bar>
                \   syntax enable <Bar>
                \ endif <CR>

    map <F4> :vertical resize 87<CR>

    " autoindent
    map <silent> <F6> gg=G:retab<CR>

    map <Home> ^
    imap <Home> <Esc>^i

    map <F8> :TlistToggle<CR>
    map <A-F8> :TagbarToggle<CR>
    map <F10> :edit ./.vim<CR>
    map <A-F10> :edit ~/.vimrc<CR>
    map <C-F10> :so ./.vim<CR>
    map <C-s> :w<CR>
    map! <C-s> <Esc>:w<CR>
    nnoremap ; :

    map <up> <nop>
    map <down> <nop>
    map <left> <nop>
    map <right> <nop>
    imap <up> <nop>
    imap <down> <nop>
    imap <left> <nop>
    imap <right> <nop>

	" toggle comments
	map <C-\> <Plug>NERDCommenterToggle<CR>
augroup END

augroup vimrcAutoComp
	" http://vim.wikia.com/wiki/Make_Vim_completion_popup_menu_work_just_like_in_an_IDE
	set completeopt=longest,menuone
	inoremap <expr> <Esc>      pumvisible() ? "\<C-e>" : "\<Esc>"
	inoremap <expr> <CR>       pumvisible() ? "\<C-y>" : "\<CR>"
	inoremap <expr> <Down>     pumvisible() ? "\<C-n>" : "\<Down>"
	inoremap <expr> <Up>       pumvisible() ? "\<C-p>" : "\<Up>"
	inoremap <expr> <PageDown> pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<PageDown>"
	inoremap <expr> <PageUp>   pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<PageUp>"
	inoremap <expr> <C-d>      pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<C-d>"
	inoremap <expr> <C-u>      pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<C-u>"
	if has("gui_running")
		" C-Space seems to work under gVim on both Linux and win32
	inoremap <C-Space> <C-n>
	else " no gui
		if has("unix")
			inoremap <Nul> <C-n>
		else
			" I have no idea of the name of Ctrl-Space elsewhere
		endif
	endif
augroup END

" run it sometimes
" helptags ~/.vim/doc
