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
set exrc

nnoremap <leader>r :%s/\s\+$//e<CR>
vnoremap <C-h> y:%s/<C-r>"//g<left><left>

nnoremap <F2> :set invpaste<CR>
inoremap <F2> <C-\><C-O>:set invpaste<CR>

nnoremap <F3> :set invrnu<CR>
inoremap <F3> <C-\><C-O>:set invrnu<CR>

nnoremap <F4> :nohl<CR>
inoremap <F4> <C-\><C-O>:nohl<CR>

let &colorcolumn=join(range(81,999), ",")
set number

set nofsync
set swapsync=

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
set noet sts=0 sw=0 ts=8
autocmd filetype python setlocal noet sts=0 sw=0 ts=8 " why the fuck does python indent plugin change indentation settings?
set cindent
set cinoptions=(0,u0,U0

filetype plugin indent on

let g:ctab_disable_checkalign = 1
let g:ctab_filetype_maps = 1

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

if $IS_SOLARIZED == "1"
	set background=dark
	colorscheme solarized
else
	colorscheme elflord
endif
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

