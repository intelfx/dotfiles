"
" Defaults
"

" Get the defaults that most users want.
runtime! defaults.vim

" configure snipMate
let g:snipMate = { 'snippet_version' : 1 }

" configure rooter
let g:rooter_change_directory_for_non_project_files = 'current'
let g:rooter_cd_cmd = 'lcd'
let g:rooter_ignore = 1
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
  let g:vifm_replace_netrw = 0
endif

" configure ctrlp.vim
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'a'
let g:ctrlp_switch_buffer = 'et'
" set a reasonable directory listing command
" (piggyback on the same fd wrapper I wrote for zsh and later ported for vifm)
if executable('-fd-compgen')
  let g:ctrlp_user_command = '-fd-compgen -Xforce-vcs --hidden -tf %s'
elseif executable('fd')
  let g:ctrlp_user_command = 'fd --hidden -tf . %s'
endif
" set even more reasonable directory listing command(s) for specific types
" of roots, and reuse what we set earlier as a fallback
" (sadly, it is a pain to approximate git-ls-files behavior with fd(1)
"  in presence of nested git repositories and complicated gitignore rules
"  like we have for $HOME)
let g:ctrlp_user_command = {
  \'types': {
    \1: ['.git', 'git -C %s ls-files -co --exclude-standard'],
  \},
  \'fallback': get(g:, 'ctrlp_user_command', ''),
\}

" configure vim-vinegar / netrw
" I like it, eh
let g:netrw_banner = 1
" Hide dotfiles by default (netrw: `gh` to toggle)
let g:netrw_list_hide = '\(^\|\s\s\)\zs\.\S\+'
" TODO: make `y.` (yank absolute path under cursor) do something reasonable
"       wrt. all the clipboard dances, similar to vifm' `yf`/`yd`

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
 
" configure vifm.vim #3
" vifm.vim: remove commands conflicting with netrw shorthands
" TODO: rebind them under non-conflicting names (export s:StartVifm somehow)
if exists('loaded_vifm')
  delcommand EditVifm
  delcommand PeditVifm
  delcommand VsplitVifm
  delcommand SplitVifm
  delcommand DiffVifm
  delcommand TabVifm
endif

" tlib: remove commands conflicting with netrw shorthands
delcommand Texecloc
delcommand Texecqfl

" man: open in new tab
let g:ft_man_open_mode = 'tab'

" default text width for solid-color 'ruler' (see below)
let g:rulerwidth = 80


"
" Keybindings
"

" Remap ':' <-> ',' for better ergonomics instead of touching the leader
" https://konfekt.github.io/blog/2016/10/03/get-the-leader-right
"
nnoremap : ,
xnoremap : ,
onoremap : ,

nnoremap , :
xnoremap , :
onoremap , :

nnoremap g: g,
nnoremap g, <NOP>

nnoremap @, @:
nnoremap @: <NOP>

" NOTE: Causes lag when 'q' is hit, for example when
" - stopping to record a macro or
" - exiting a buffer by a custom mapping to 'q'.
nnoremap q, q:
xnoremap q, q:

nnoremap q: <NOP>
xnoremap q: <NOP>

" convert %% to dirname(%) to make invoking netrw easier
" (`:vs %%`, `:sp %%`, `:e %%`, ...)
" this _should_ be obsoleted by `:e.`, but it uses cwd rather than dirname(%).
" this also should be obsoleted by `:E`, but I still need to learn it.
cabbrev %% %:h

" <leader>d -- delete into black hole
nnoremap <leader>d "_d
vnoremap <leader>d "_d
" <leader><leader> -- anything into black hole (badum-tss)
nnoremap <leader><leader> "_
vnoremap <leader><leader> "_

" so far, most of my Vim usage consists of editing ~/.vimrc
nnoremap <leader>e :edit ~/.vimrc<CR>
nnoremap <leader>r :source ~/.vimrc<CR>

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

command! -nargs=+ Grep execute 'silent grep! <args>' | below copen | redraw

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
if &term =~ '^tmux'
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

set grepprg=rg\ --vimgrep\ --word-regexp\ $*
set grepformat=%f:%l:%c:%m


"
" Open multiple arguments in tabs by default
" (https://vi.stackexchange.com/a/2197/7826)
"

augroup args-to-tabs
    au!
    au VimEnter * ++nested if !&diff | tab all | tabfirst | endif
augroup end


"
" Clipboard integration
" TODO: OSC52 -> Vim
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

augroup ftdetect
  au!
  au BufNewFile,BufRead .neovintageousrc                   setl ft=vim

  " TODO: use a json syntax that's closer to what is actually supported
  "       (i.e. json+comments+trailing commas) rather than json5
  au BufNewFile,BufRead
    \ *.sublime-{color-scheme,commands,completions,keymap,menu,package,settings,snippet,syntax,workspace}
    \                                                      setl ft=json5

  au BufNewFile,BufRead *.tpl                              setl ft=gotexttmpl
  au BufNewFile,BufRead *.gotmpl                           setl ft=gotexttmpl
  au BufNewFile,BufRead /share/polkit-1/rules.d/*.rules    setl ft=javascript
  au BufNewFile,BufRead /etc/polkit-1/rules.d/*.rules      setl ft=javascript
augroup END

augroup ftsettings
  au!
  au FileType man                                          setl nolist nonumber keywordprg=:Man iskeyword+=(,)

  " disable colorcolumn (set to non-empty so that our ruler impl catches it) 
  au FileType man                                          setl colorcolumn=0
  au FileType netrw                                        setl colorcolumn=0
augroup END


"
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
" 'Smart' solid color ruler
" Features:
" - set multiple colorcolumns to de-emphasize the entire prohibited area
" - disable colorcolumns when the window width is less than starting column
"   (to avoid garbled appearance due to wrapping)
" - if wrapping is required and condition (2) does not apply, fill the
"   highest possible multiple of window width (again, to avoid garbled
"   appearance when the colored area ends)
"

function! s:RulerTrapColorcolumn()
  if v:option_type == 'local'
    let w:colorcolumn_set = v:option_new
  endif
endfunction

function! s:RulerCompute(pos, width)
  if a:pos <= a:width
    let a = a:pos
    let b = s:floorm(a:pos + 255, a:width)
    if a <= b
      let cols = range(a, b)
      return join(cols, ',')
    endif
  endif
  return ''
endfunction

function! s:RulerUpdate()
  " bail if explicitly disabled
  if exists('w:ruler_disable') || exists('b:ruler_disable')
    return
  endif
  " bail if we caught a `setl colorcolumn=...` and it was not us
  " also bail if it is intentionally disabled (HACK)
  " FIXME: also bail even if we didn't, but it was clearly set and it was not us:
  "        \ || (&l:colorcolumn != '' && &l:colorcolumn != get(w:, 'colorcolumn_last', v:null))
  "        however, this needs refinement in face of switching buffers and windows
  " NOTE: v:null is a sentinel which compares inequal to any string
  " HACK: '0' is a sentinel that I `setl` to disable colorcolumn (see above)
  if (exists('w:colorcolumn_set') && w:colorcolumn_set != get(w:, 'colorcolumn_last', v:null))
   \ || (&l:colorcolumn == '0')
    return
  endif

  if &textwidth > 0
    let ruler = &textwidth
  elseif &wrapmargin > 0
    let ruler = &wrapmargin
  else
    let ruler = g:rulerwidth
  endif

  let info = getwininfo(win_getid())
  let width = info[0].width - info[0].textoff
  let colorcolumn = s:RulerCompute(ruler + 1, width)

  let &l:colorcolumn = colorcolumn
  let w:colorcolumn_set = colorcolumn
  let w:colorcolumn_last = colorcolumn
endfunction

function! s:Ruler(windows)
  if empty(a:windows)
    call s:RulerUpdate()
  else
    call foreach(a:windows, {k, v -> win_execute(v, 'call s:RulerUpdate()')})
  endif
endfunction

augroup colorcolumn
  au!
  au VimEnter             *            call s:Ruler([])
  au BufWinEnter          *            call s:Ruler([])
  au WinResized           *            call s:Ruler(v:event.windows)
  au OptionSet            colorcolumn  call s:RulerTrapColorcolumn()
augroup END


"
" Personal functions
"
function! Pow(a, b)
  return float2nr(pow(a:a, a:b))
endfunction

function! Bytes(arg)
  let r = system('bscalc -b ' .. shellescape(a:arg))
  let r = substitute(r, '[^0-9]', '', 'g')
  return str2nr(r)
endfunction

function! Kib(arg)
  let r = system('bscalc --KiB ' .. shellescape(a:arg))
  let r = substitute(r, '[^0-9]', '', 'g')
  return str2nr(r)
endfunction

" floorm(arg, mul) -- round down a:arg to a multiple of a:mul
function! s:floorm(arg, mul)
  return a:arg - (a:arg % a:mul)
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
