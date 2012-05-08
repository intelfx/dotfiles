filetype off
call pathogen#infect()
" ---- {{{{ Basic  
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
" set relativenumber
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
set undofile
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
" ---- {{{{ Key mappings 
" Enable/Disable paste mode, where data won't be autoindented
set pastetoggle=<F2>
" Enable/Disable search highlight with <F12>
map <F12> :set hls!<CR>
map <F12> <ESC>:set hls!<CR>a
vmap <F12> <ESC>:set hls!<CR>gv
" Remap leader key to ',' instead of '\'
let mapleader=","
" Quickly edit/reload the vimrc file
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>
" Scroll the viewport faster with <C-e> and <C-y> 
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>
" Remap Keys for opening a splitscreen and to move with hjkl
nnoremap <leader>w <C-w>v<C-w>l
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

nnoremap / /\v
vnoremap / /\v

inoremap jj <Esc>
" Folding
nnoremap <Space> za
vnoremap <Space> za

" Quicksave, quickload, treeexplorer to <F5><F6><F4>
nnoremap <F5> :YRShow<CR>
nnoremap <F4> :NERDTreeToggle<CR>
nnoremap <F6> :RainbowParenthesesLoadSquare <CR>:RainbowParenthesesLoadChevrons <CR>:RainbowParenthesesLoadRound <CR>:RainbowParenthesesLoadBraces <CR>
map! <C-v> <Esc>:u<CR>

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
" ---- {{{{ Appearance
set background=dark
set guifont=Menlo\ for\ Powerline\ 8 
set guioptions-=T
if (!has('gui_running'))
    set t_Co=256
    colorscheme jellybeans
else
    colorscheme molokai
endif
" ---- {{{{ Optional
set visualbell "Disable both visualbell and errorbells
set noerrorbells
set t_vb=
" ---- {{{{ Plugins
let NERDTreeShowHidden=1
nnoremap <F3> :GundoToggle <cr>
" ---- {{{{ Scripts
"  Show syntax highlighting groups for word under cursor
nmap <C-S-P> :call <SID>SynStack()<CR>
function! <SID>SynStack()
    if !exists("*synstack")
        return
    endif
    echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc
