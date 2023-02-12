"
" Defaults
"

" Get the defaults that most users want.
runtime! defaults.vim

let g:snipMate = {}
let g:snipMate.snippet_version = 1

packloadall

" The matchit plugin makes the % command work better, but it is not backwards
" compatible.
if has('syntax') && has('eval')
  packadd matchit
endif

"
" Keybindings
"

" use a better leader
let mapleader = ","

" <leader>d -- d into black hole
nnoremap <leader>d "_d
vnoremap <leader>d "_d
" <leader><leader> -- anything into black hole (badum-tss)
nnoremap <leader><leader> "_
vnoremap <leader><leader> "_

" don't require Shift to go to Ex mode
nnoremap ; :
vnoremap ; :

" convert %% to dirname(%)
cabbrev %% %:h

nnoremap <F2> :set invpaste<CR>
inoremap <F2> <C-\><C-O>:set invpaste<CR>

nnoremap <F3> :set invrnu<CR>
inoremap <F3> <C-\><C-O>:set invrnu<CR>

nnoremap <F4> :nohl<CR>
inoremap <F4> <C-\><C-O>:nohl<CR>

nnoremap <F10> :b <C-Z>

set wildmenu wildmode=full wildchar=<Tab>
set wildcharm=<C-Z> " something well unused

" grep operator
let g:grep_operator_set_search_register = 1
nmap <leader>g <Plug>GrepOperatorOnCurrentDirectory
vmap <leader>g <Plug>GrepOperatorOnCurrentDirectory

command! -nargs=+ Grep execute 'silent grep! <args>' | copen

" snippets
imap <leader><Tab> <Plug>snipMateNextOrTrigger
smap <leader><Tab> <Plug>snipMateNextOrTrigger

" autosudo
"cmap w!! w !sudo sponge %
cnoremap w!! execute 'silent! write !sudo sponge %' <bar> edit!

" search selection
" (z is for register z)
vnoremap // "zy/\V<C-R>z<CR>

"
" Miscellanea
"

set mouse+=a
if &term =~ "^tmux"
  " xterm2      Works like "xterm", but with the xterm reporting the
  "             mouse position while the mouse is dragged.
  " <...>
  " sgr         Mouse handling for the terminal that emits SGR-styled
  "             mouse reporting. The mouse works even in columns
  "             beyond 223. This option is backward compatible with
  "             "xterm2" because it can also decode "xterm2" style
  "             mouse codes.
  "
  " Thus, use "sgr" for drag support and no column count limitation under tmux
  " and other modern terminals.
  set ttymouse=sgr
endif

set hlsearch
set number
"set nofsync
set swapsync=
set hidden

silent !mkdir -p ~/.cache/vim/{swap,backup,undo}
set dir=~/.cache/vim/swap//,.
set backupdir=~/.cache/vim/backup//,.
set backup
set undodir=~/.cache/vim/undo//,.
set undofile
set viminfofile=~/.cache/vim/info

let &colorcolumn=join(range(81,999), ",")

set grepprg=rg\ --vimgrep\ --word-regexp\ $*
set grepformat=%f:%l:%c:%m


"
" Filetypes
"

au BufRead,BufNewFile *.tpl set filetype=gotexttmpl
au BufRead,BufNewFile *.gotmpl set filetype=gotexttmpl


"
" Indentation (smart tab plugin installed)
"

let g:ctab_filetype_maps = 1
let g:python_recommended_style = 0 " fuck you, I know better

filetype plugin indent on

" TODO: autodetermine per-project (rooter + .editorconfig)
setlocal noet sts=0 sw=0 ts=8
setlocal cinoptions=(0,u0,U0


"
" Colorscheme
"

" ------------------------------------------------------------------

" The following items are available options, but do not need to be
" included in your .vimrc as they are currently set to their defaults.

let g:solarized_termtrans=1
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

syntax enable
set background=dark
colorscheme solarized
