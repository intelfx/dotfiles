" ------------------------------------------------------------------
" Defaults
" ------------------------------------------------------------------

" Get the defaults that most users want.
source $VIMRUNTIME/defaults.vim

set nobackup
set noundofile

" The matchit plugin makes the % command work better, but it is not backwards
" compatible.
if has('syntax') && has('eval')
  packadd matchit
endif

" ------------------------------------------------------------------
" Pathogen
" ------------------------------------------------------------------

execute pathogen#infect()

" ------------------------------------------------------------------
" Building
" ------------------------------------------------------------------
set makeprg=make\ -f\ ~/bin/Makefile\ %<
nnoremap <F7> :silent make! <bar> cwindow<CR><C-L>
nnoremap <F5> :!./%<<CR>

" ------------------------------------------------------------------
" Miscellanea
" ------------------------------------------------------------------
set hlsearch
set number
"set nofsync
set swapsync=

let &colorcolumn=join(range(81,999), ",")

nnoremap <F2> :set invpaste<CR>
inoremap <F2> <C-\><C-O>:set invpaste<CR>

nnoremap <F3> :set invrnu<CR>
inoremap <F3> <C-\><C-O>:set invrnu<CR>

nnoremap <F4> :nohl<CR>
inoremap <F4> <C-\><C-O>:nohl<CR>


" ------------------------------------------------------------------
" Buffer management
" ------------------------------------------------------------------
set hidden

set wildchar=<Tab> wildmenu wildmode=full
set wildcharm=<C-Z> " something well unused
nnoremap <F10> :b <C-Z>
nnoremap <C-F10> :bd <C-Z>

" ------------------------------------------------------------------
" Delete into black hole (Normal, Visual, Select)
" ------------------------------------------------------------------
nnoremap <leader>d "_d
vnoremap <leader>d "_d

nnoremap <leader>x "_x
vnoremap <leader>x "_x

nnoremap <leader><leader> "_
vnoremap <leader><leader> "_

" ------------------------------------------------------------------
" Indentation (smart tab plugin installed)
" ------------------------------------------------------------------
let g:ctab_filetype_maps = 1
let g:python_recommended_style = 0 " fuck you, I know better

filetype plugin indent on

setlocal noet sts=0 sw=0 ts=8
setlocal cinoptions=(0,u0,U0


" ------------------------------------------------------------------
" grep operator
" ------------------------------------------------------------------
set grepprg=git\ grep\ -nHw\ $*
let g:grep_operator_set_search_register = 1
nmap <leader>g <Plug>GrepOperatorOnCurrentDirectory
vmap <leader>g <Plug>GrepOperatorOnCurrentDirectory


" ------------------------------------------------------------------
" snipmate
" ------------------------------------------------------------------
imap <leader><Tab> <Plug>snipMateNextOrTrigger
smap <leader><Tab> <Plug>snipMateNextOrTrigger

" ------------------------------------------------------------------
" Smart-Tabs
" ------------------------------------------------------------------

" ------------------------------------------------------------------
" Solarized Colorscheme Config
" ------------------------------------------------------------------
syntax enable

set background=dark
colorscheme solarized
" ------------------------------------------------------------------

" The following items are available options, but do not need to be
" included in your .vimrc as they are currently set to their defaults.

" let g:solarized_termtrans=0
" let g:solarized_degrade=0
" let g:solarized_bold=1
" let g:solarized_underline=1
" let g:solarized_italic=1
" let g:solarized_termcolors=16
" let g:solarized_contrast="normal"
" let g:solarized_visibility="normal"
" let g:solarized_diffmode="normal"
" let g:solarized_hitrail=0
" let g:solarized_menu=1

