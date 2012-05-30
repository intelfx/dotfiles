" Basic Options
" =============
"
" Pathogen and Powerline 
filetype off
call pathogen#infect()
let g:Powerline_symbols = 'fancy'

set nocompatible
set hidden
set history=1000
set undolevels=1000
set title
syntax on
filetype plugin indent on
set backspace=indent,eol,start
set ruler
set number
"set relativenumber
set scrolloff=4

set autoindent
set copyindent
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set shiftround 
set smarttab
set showmatch

set showmode
set showcmd
set gdefault

set wrap
set linebreak
set textwidth=82
set formatoptions=qrn1
set colorcolumn=85

set fileformats="unix,dos,mac"
set formatoptions+=1
set laststatus=2

set ignorecase
set smartcase
set incsearch
set nohlsearch

set wildmode=longest,list,full
set wildmenu
set wildignore=*.swp,*.bak,*.pyc,*.class
set mouse=a
set nobackup
set noswapfile
set nomodeline
set undofile
if exists("+undofile")
  " undofile - This allows you to use undos after exiting and restarting
  " This, like swap and backups, uses .vim-undo first, then ~/.vim/undo
  " :help undo-persistence
  " This is only present in 7.3+
  if isdirectory($HOME . '/.vimtmp') == 0
    :silent !mkdir -p ~/.vimtmp > /dev/null 2>&1
  endif
  set undodir=~/.vimtmp//
  set undofile
endif
set cursorline

" Key mappings 
" ============
"
" Enable/Disable paste mode, where data won't be autoindented
set pastetoggle=<F2>

" Remap leader key to ',' instead of '\'
let mapleader=","

" Quickly edit/reload the vimrc file
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

" Scroll the viewport faster with <C-e> and <C-y> 
nnoremap <C-e> 5<C-e>
nnoremap <C-y> 5<C-y>

" Remap Keys for opening a splitscreen and to move with hjkl
nnoremap <leader>v <C-w>v<C-w>l
nnoremap <leader>h :split<CR>
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Makes posible the use of python/perl regex in vim
nnoremap / /\v
vnoremap / /\v

" Easy insert mode exit
inoremap jj <Esc>

" Folding
nnoremap <Space> za
vnoremap <Space> za
nnoremap ; :

" Show the YankRing & NERDTree
nnoremap <F5> :YRShow<CR>
nnoremap <F4> :NERDTreeToggle<CR>

map! <C-v> <Esc>:u<CR>

" Save/Load a working session
map <F8> :SessionSave<CR>
map <F9> :SessionList<CR>

" Tabs
map <leader>t :tabedit<CR>
map <leader>n :tabn<CR>

" Bubbling text
nmap <C-Up> [e
nmap <C-Down> ]e
vmap <C-Up> [egv
vmap <C-Down> ]egv

" Spell checkikg
nmap <silent> <leader>s :set spell!<CR>

" Opens/Close Gundo window
nnoremap <F3> :GundoToggle <cr>

" Appearance
" ==========
"
set background=dark
set guifont=Menlo\ for\ Powerline\ 8 
" Remove menu bars, toolbox and scrollbars in GVIM
set guioptions-=T
set guioptions-=m
set guioptions-=r
if (!has('gui_running'))
    set t_Co=256
    "colorscheme jellybeans
    colorscheme darkmirror
else
    colorscheme molokai
endif

" Disable error bell
set visualbell 
set noerrorbells
set t_vb=
" Plugins specific options
let NERDTreeShowHidden=1

" Functions
" =========
"
"  Show syntax highlighting groups for word under cursor
nmap <leader>hi :call <SID>SynStack()<CR>
function! <SID>SynStack()
    if !exists("*synstack")
        return
    endif
    echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc
