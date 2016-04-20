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
set noet sts=0 ts=8 sw=8
set cindent
set cinoptions=(0,u0,U0

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
let g:ctab_disable_checkalign = 1

source $HOME/.vimrc-solarized
