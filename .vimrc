" ------------------------------------------------------------------
" Pathogen
" ------------------------------------------------------------------

execute pathogen#infect()

" ------------------------------------------------------------------
" Building
" ------------------------------------------------------------------
set makeprg=make\ -f\ ~/bin/Makefile.dbg\ %<
nnoremap <F7> :silent make! <bar> cwindow<CR><C-L>
nnoremap <F5> :!./%<<CR>

" ------------------------------------------------------------------
" Miscellanea
" ------------------------------------------------------------------
set exrc

nnoremap <leader>r :%s/\s\+$//e<CR>

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
set grepprg=git\ grep\ -n\ $*
let g:grep_operator_set_search_register = 1
nmap <leader>g <Plug>GrepOperatorCurrentDirectory
vmap <leader>g <Plug>GrepOperatorCurrentDirectory

source $HOME/.vimrc-solarized
