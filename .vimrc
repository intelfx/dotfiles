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
" Solarized Colorscheme Config
" ------------------------------------------------------------------
syntax enable

if $IS_SOLARIZED == "1" && &t_Co == 16
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

