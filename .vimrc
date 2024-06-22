"
" Defaults
"

" Get the defaults that most users want.
runtime! defaults.vim

" configure snipMate
let g:snipMate = { 'snippet_version' : 1 }

" configure rooter
let g:rooter_change_directory_for_non_project_files = ''
let g:rooter_cd_cmd = 'lcd'
" HACK for kernel sources: do not anchor on Makefile if this dir has Kconfig
" (thus do not treat kernel subdirs as roots; we will still anchor on .git)
let g:rooter_patterns = ['.git', '_darcs', '.hg', '.bzr', '.svn', '!Kconfig', 'Makefile', 'package.json']

" configure vifm.vim #1
" approximate whether we will be able to embed vifm in vim
" (condition extracted from vifm.vim)
if has('nvim') || exists('*term_start')
  let g:vifm_embed_term = 1
  let g:vifm_embed_split = 1
  let g:vifm_embed_cwd = 1
  " ask to replace netrw
  let g:vifm_replace_netrw = 1
endif

" load plugins from $HOME/.vim/bundle
packloadall

" configure vifm.vim #2
" if we asked to replace netrw _and_ vifm.vim actually loaded, disable netrw
if exists('loaded_vifm') && g:vifm_replace_netrw
  let g:loaded_netrw = 1
  let g:loaded_netrwPlugin = 1
endif

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

" This never really took off, and `;` is already used to repeat f/t/F/T.
" " don't require Shift to go to Ex mode
" nnoremap ; :
" vnoremap ; :

" convert %% to dirname(%)
cabbrev %% %:h

nnoremap <F2> :set invpaste<CR>
inoremap <F2> <C-\><C-O>:set invpaste<CR>

nnoremap <F3> :set invrnu<CR>
inoremap <F3> <C-\><C-O>:set invrnu<CR>

nnoremap <F4> :nohl<CR>
inoremap <F4> <C-\><C-O>:nohl<CR>

nnoremap <F10> :b <C-Z>

set wildmenu wildmode=full wildoptions=fuzzy,pum
set wildchar=<Tab>
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

" Split line (antonym of J)
nnoremap <C-J> i<CR><Esc>k$

" Move lines around
" Teach vim to interpret Esc sequences
execute "set <A-j>=\ej"
execute "set <A-k>=\ek"
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

"
" Splits
"
set splitright
set splitbelow

" Split current buffer: C-W S (normal), C-W V (vertical)
" Split new buffer:     C-W N (normal), C-W M (vertical) <-- this is the new map
nnoremap <C-w>m :vnew<CR>

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
set undolevels=1000000

silent !mkdir -p ~/.cache/vim/{swap,backup,undo}
set dir=~/.cache/vim/swap//,.
set backupdir=~/.cache/vim/backup//,.
set backup
set undodir=~/.cache/vim/undo//,.
set undofile
set viminfofile=~/.cache/vim/info

if !empty($VIM_LARGE_FILE)
  set nofsync
  set undolevels=10
  set noswapfile
  set nobackup
  set noundofile
endif

let &colorcolumn=join(range(81,999), ",")

set grepprg=rg\ --vimgrep\ --word-regexp\ $*
set grepformat=%f:%l:%c:%m


"
" Clipboard integration
"

if has('unnamedplus') && has('clipboard_working')
  " For the day Arch vim build has clipboard integration...
  set clipboard^=unnamedplus,autoselect
elseif !has('nvim')
    " In the event that the clipboard isn't working, it's quite likely that
    " the + and * registers will not be distinct from the unnamed register. In
    " this case, a:event.regname will always be '' (empty string). However, it
    " can be the case that `has('clipboard_working')` is false, yet `+` is
    " still distinct, so we want to check them all.
    let s:VimOSCYankPostRegisters = ['', '+', '*']
    function! s:VimOSCYankPostCallback(event)
        if a:event.operator == 'y' && index(s:VimOSCYankPostRegisters, a:event.regname) != -1
            call OSCYankRegister(a:event.regname)
        endif
    endfunction
    augroup VimOSCYankPost
        autocmd!
        autocmd TextYankPost * call s:VimOSCYankPostCallback(v:event)
    augroup END
endif


"
" Filetypes
"

augroup filetypedetect

au BufRead,BufNewFile *.tpl setlocal filetype=gotexttmpl
au BufRead,BufNewFile *.gotmpl setlocal filetype=gotexttmpl
au BufRead,BufNewFile /share/polkit-1/rules.d/*.rules setlocal filetype=javascript
au BufRead,BufNewFile /etc/polkit-1/rules.d/*.rules setlocal filetype=javascript

augroup END

" automatically give executable permissions if file begins with #! and contains '/bin/' in the path
" see http://www.debian-administration.org/articles/571
" modified 23.12.2008 Benedikt Stegmaier
"
function s:ChmodX()
  let l:first = getline(1)
  if l:first =~ '^#! *\(/bin/\|/usr/bin/\|/usr/bin/env *\)bash\>'
    silent !chmod +x %:p
    silent set ft=bash
  elseif l:first =~ '^#! *\(/bin/\|/usr/bin/\|/usr/bin/env *\)zsh\>'
    silent !chmod +x %:p
    silent set ft=zsh
  elseif l:first =~ '^#! *\(/bin/\|/usr/bin/\|/usr/bin/env *\)sh\>'
    silent !chmod +x %:p
    silent set ft=sh
  endif
endfunction

augroup chmod
  autocmd!
  autocmd BufWritePost * call s:ChmodX()
augroup END

" simple implementation of a block-comment feature
"
function s:CommentSetup()
  if !exists('b:comment_leader')
    let b:comment_leader = '# '
  endif
  let b:_comment_leader_add = escape(b:comment_leader, '\/')
  let b:_comment_leader_remove = substitute(b:_comment_leader_add, ' ', ' \\?', 'g')
  noremap <buffer> <silent> <leader>cc :<C-B>silent <C-E>s/^/<C-R>=b:_comment_leader_add<CR>/<CR>:nohlsearch<CR>
  noremap <buffer> <silent> <leader>cu :<C-B>silent <C-E>s/^<C-R>=b:_comment_leader_remove<CR>//e<CR>:nohlsearch<CR>
endfunction

augroup comment
  autocmd!
  autocmd FileType c,cpp,go,rust                     let b:comment_leader = '// '
  autocmd FileType sh,bash,python                    let b:comment_leader = '# '
  autocmd FileType conf,fstab,systemd,udev           let b:comment_leader = '# '
  autocmd FileType ini,desktop                       let b:comment_leader = '# '
  autocmd FileType yaml                              let b:comment_leader = '# '
  autocmd FileType vim                               let b:comment_leader = '" '
  autocmd FileType *                                 call s:CommentSetup()
augroup END

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
" Personal functions
"
function! Pow(a, b)
  return float2nr(pow(a:a, a:b))
endfunction

function! Bytes(arg)
  let r = system('bscalc -b ' .. shellescape(a:arg))
  let r = substitute(r, "[^0-9]", "", "g")
  return str2nr(r)
endfunction

function! Kib(arg)
  let r = system('bscalc --KiB ' .. shellescape(a:arg))
  let r = substitute(r, "[^0-9]", "", "g")
  return str2nr(r)
endfunction

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
