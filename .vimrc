" Get the defaults that most users want.
runtime! defaults.vim


" ----------------------------------------------------------------------------
" PLUGINS :: EARLY CONFIGURATION
" ----------------------------------------------------------------------------

" configure snipMate
let g:snipMate = { 'snippet_version' : 1 }

" configure rooter
let g:rooter_change_directory_for_non_project_files = 'current'
let g:rooter_cd_cmd = 'lcd'
let g:rooter_ignore = 1
" Disable patterns that can appear below toplevel, pending airblade/vim-rooter#124
" let g:rooter_patterns = ['.git', '_darcs', '.hg', '.bzr', '.svn', 'Makefile', 'package.json']
let g:rooter_patterns = ['.git', '_darcs', '.hg', '.bzr', '.svn']
let g:rooter_targets = ['/', $HOME .. '/*']

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
  let g:ctrlp_user_command = '-fd-compgen -Xno-skip-vcs --hidden -tf %s'
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
let g:netrw_keepdir = 0

" configure vim-stabs
" do not set <TAB> and <CR> maps that conflict with vimcomplete; see below for
" unified mappings
let g:stabs_maps = 'boO='

" configure vimcomplete
" do not set <TAB> or <CR> maps that conflict with stabs; see below for
" unified mappings
let g:vimcomplete_tab_enable = 0
let g:vimcomplete_cr_enable = 0

" configure gitgutter
let g:gitgutter_set_sign_backgrounds = 1
setg updatetime=100
setg signcolumn=auto


" ----------------------------------------------------------------------------
" USER CONFIGURATION
" ----------------------------------------------------------------------------

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

xnoremap <Leader>$ $
xnoremap $         g_

" <leader>{d,c,s,x} -- delete into black hole
nnoremap <leader>d "_d
xnoremap <leader>d "_d
nnoremap <leader>c "_c
xnoremap <leader>c "_c
nnoremap <leader>s "_s
xnoremap <leader>s "_s
nnoremap <leader>x "_x
xnoremap <leader>x "_x

" so far, most of my Vim usage consists of editing ~/.vimrc
nnoremap <leader>e :edit ~/.vimrc<CR>
nnoremap <leader>r :source ~/.vimrc<CR>

nnoremap <F2> :set invpaste<CR>
inoremap <F2> <C-\><C-O>:set invpaste<CR>

nnoremap <F3> :set invrnu<CR>
inoremap <F3> <C-\><C-O>:set invrnu<CR>

nnoremap <F4> :nohl<CR>
inoremap <F4> <C-\><C-O>:nohl<CR>

setg wildchar=<Tab>

" grep operator
let g:grep_operator_set_search_register = 1
let g:grep_operator = 'RgRaw'
nmap <leader>g <Plug>GrepOperatorOnCurrentDirectory
vmap <leader>g <Plug>GrepOperatorOnCurrentDirectory

" snippets
imap <leader><Tab> <Plug>snipMateNextOrTrigger
smap <leader><Tab> <Plug>snipMateNextOrTrigger

" autosudo
"cmap w!! w !sudo sponge %
cnoremap w!! execute 'silent! write !sudo sponge %' <bar> edit!

" search selection
" (z is for register z)
vnoremap // "zy/\V<C-R>z<CR>

" change `n` and `N` to search in 'absolute direction' (i.e. `n` always
" searches forward, `N` always searches backward)
" Ref: https://github.com/inkarkat/vim-SearchRepeat
nnoremap <expr> n 'Nn'[v:searchforward]
nnoremap <expr> N 'nN'[v:searchforward]

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

" Split current buffer: C-W S (normal), C-W V (vertical)
" Split new buffer:     C-W N (normal), C-W M (vertical) <-- this is the new map
nnoremap <C-w>m :vnew<CR>


"
" Options
"

setg hlsearch
set number  " window-local for some reason
setg hidden

setg ignorecase
setg smartcase

setg completeopt=menu,popup,fuzzy
setg wildmenu wildmode=full wildoptions=fuzzy,pum
setg wildcharm=<C-Z> " something well unused

setg splitright
setg splitbelow

if executable('rg')
  setg grepprg=rg\ --vimgrep\ --word-regexp\ $*
  setg grepformat=%f:%l:%c:%m
endif

" man: open in new tab
let g:ft_man_open_mode = 'tab'

" default text width for solid-color 'ruler' (see below)
let g:rulerwidth = 80


"
" Indentation
"

" let g:ctab_filetype_maps = 1
let g:python_recommended_style = 0 " fuck you, I know better

filetype plugin indent on

setg noet sts=0 sw=0 ts=8
setg cinoptions=(0,u0,U0


"
" Filetype options
"

augroup ftdetect
  au!
  au BufNewFile,BufRead .neovintageousrc                   setl ft=vim

  " TODO: use a json syntax that's closer to what is actually supported
  "       (i.e. json+comments+trailing commas) rather than json5
  au BufNewFile,BufRead
    \ *.sublime-{color-scheme,commands,completions,keymap,menu,package,settings,snippet,syntax,workspace}
    \                                                      setl ft=json5
  au BufNewFile,BufRead
    \ *.sublime_session
    \                                                      setl ft=json

  au BufNewFile,BufRead *.tpl                              setl ft=gotexttmpl
  au BufNewFile,BufRead *.gotmpl                           setl ft=gotexttmpl
  au BufNewFile,BufRead /share/polkit-1/rules.d/*.rules    setl ft=javascript
  au BufNewFile,BufRead /etc/polkit-1/rules.d/*.rules      setl ft=javascript
augroup END

augroup ftsettings
  au!
  " set &keywordprg/&iskeyword for completeness, but see below for override
  au FileType man                                          setl nolist nonumber keywordprg=:Man iskeyword+=(,)
  " override entire built-in keyword feature (`K`) with a man-specific call,
  " because &isk is not flexible enough (see vim/vim#15117 for why exactly)
  au FileType man                                          nnoremap <silent> <buffer> K :call dist#man#PreGetPage(0)<CR>

  " disable colorcolumn (set to non-empty so that our ruler impl catches it)
  au FileType man                                          setl colorcolumn=0
  au FileType netrw                                        setl colorcolumn=0

  au FileType json                                         setl foldmethod=syntax
augroup END


"
" System settings
"

setg mouse+=a
if &term =~ '^tmux' || &ttymouse =~ '^xterm'
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
  setg ttymouse=sgr
endif

" setg nofsync
setg swapsync=
setg undolevels=1000000

" 2 GiB
setg maxmempattern=2097152
setg maxmemtot=2097152

silent !mkdir -p ~/.cache/vim/{swap,backup,undo}
setg dir=~/.cache/vim/swap//,.
set swapfile  " buffer-local for some reason
setg backupdir=~/.cache/vim/backup//,.
setg backup
setg undodir=~/.cache/vim/undo//,.
set undofile  " buffer-local for some reason
setg viminfofile=~/.cache/vim/info

if !empty($VIM_LARGE_FILE)
  setg nofsync
	setg swapsync=
  setg undolevels=10
  set noswapfile
  setg nobackup
  set noundofile
endif


" ----------------------------------------------------------------------------
" PERSONAL FUNCTIONS
" ----------------------------------------------------------------------------

def! Pow(a: number, b: number): number
  return float2nr(pow(a, b))
enddef

def! Bytes(arg: string): number
  var r = system('bscalc -b ' .. shellescape(arg))
  r = substitute(r, '[^0-9]', '', 'g')
  return str2nr(r)
enddef

def! Kib(arg: string): number
  var r = system('bscalc --KiB ' .. shellescape(arg))
  r = substitute(r, '[^0-9]', '', 'g')
  return str2nr(r)
enddef

" floorm(arg, mul) -- round down `arg` to a multiple of `mul`
def! s:floorm(arg: number, mul: number): number
  return arg - (arg % mul)
enddef

command! SynStack
  \ echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')

command! -nargs=* -complete=help Help
  \ tab help <args>

command! -nargs=* -complete=shellcmd Lterm
  \ call s:LocalTerm(<q-mods>, <q-args>)

def! s:LocalTerm(mods: string, args: string)
  var cmd = '[&shell]'
  var opts = {
    'cwd': expand('%:p:h'),
    'term_finish': 'close',
  }
  if !!args
    cmd = string(args)
    remove(opts, 'term_finish')
  endif
  execute printf('%s call term_start(%s, %s)', mods, cmd, string(opts))
enddef


" ----------------------------------------------------------------------------
" CUSTOM FEATURES & PLUGIN INTEGRATIONS
" ----------------------------------------------------------------------------

let s:SID = expand('<SID>')


"
" Completion
"

def! s:Vimcomplete()
  if !exists('g:VimCompleteOptionsSet')
    return
  endif
  g:vimcomplete_options = {
    completor: {
      alwaysOn: true,
      # noNewlineInCompletion: true,
      # noNewlineInCompletionEver: true,
      shuffleEqualPriority: true,
      postfixHighlight: true,
    },
    buffer: { enable: true, priority: 10, urlComplete: true, envComplete: true },
    abbrev: { enable: true, priority: 10 },
    # lsp: { enable: true, priority: 10, maxCount: 5 },
    # omnifunc: { enable: false, priority: 8, filetypes: ['python', 'javascript'] },
    # vsnip: { enable: true, priority: 11 },
    vimscript: { enable: true, priority: 11 },
    # ngram: {
    #   enable: true,
    #   priority: 10,
    #   bigram: false,
    #   filetypes: ['text', 'help', 'markdown'],
    #   filetypesComments: ['c', 'cpp', 'python', 'java'],
    # },
  }
  g:VimCompleteOptionsSet(g:vimcomplete_options)
enddef
augroup my-vimcomplete
  au!
  au VimEnter * call s:Vimcomplete()
augroup END


"
" Add combined mappings for <TAB> and <CR> to unify vimcomplete and vim-stabs
"

def! s:NonblankAtCursor(): bool
  # Inverse of vimcomplete#util#WhitespaceOnly()
  return strpart(getline('.'), col('.') - 2, 1) =~ '\S'
enddef

if exists("StabsTab")
  def! s:EmitTab(): string
    return StabsTab()
  enddef
else
  def! s:EmitTab(): string
    return "\<TAB>"
  enddef
endif

def! s:HandleTab(): string
  if pumvisible()
    return "\<C-n>"
  elseif exists('*vsnip#jumpable') && vsnip#jumpable(1)
    return "\<Plug>(vsnip-jump-next)"
  elseif s:NonblankAtCursor()
    return "\<C-n>"
  else
    return s:EmitTab()
  endif
enddef

def! s:HandleSTab(): string
  if pumvisible()
    return "\<C-p>"
  elseif exists('*vsnip#jumpable') && vsnip#jumpable(1)
    return "\<Plug>(vsnip-jump-prev)"
  elseif s:NonblankAtCursor()
    return "\<C-p>"
  else
    return "\<S-TAB>"
  endif
enddef

if exists("StabsCR")
  def! s:EmitCR(): string
    return StabsCR()
  enddef
else
  def! s:EmitCR(): string
    return "\<CR>"
  enddef
endif

def! s:HandleCR(): string
  # var skip = vimcomplete#completor#options.alwaysOn ? "\<Plug>(vimcomplete-skip)" : ""

  # OK, now we need to reverse-engineer how vimcomplete works AND how
  # normal Vim ins-completion work...
  #
  # (The below describes "default Vim behavior", which is maintained with
  #  `noNewlineInCompletion = true` and `noNewlineInCompletionEver = false`.)
  #
  # There are 4 possibilities:
  # 1. popup visible, entry was selected AND full entry text was inserted
  #    using <CTRL-N> / <CTRL-P> (likely via rebinds to <Tab> / <S-Tab>)
  # 2. popup visible, entry was selected but NOT inserted using cursor keys
  # 3. popup visible, no entry was selected
  # 4. popup not visible
  #
  # In case (1), <CR> would confirm selection, close popup and insert <CR>.
  # In case (2), <CR> would confirm selection and close popup.
  # In case (3), <CR> would dismiss popup.
  # In case (4), <CR> would insert <CR>.
  # In short, literal <CR> is inserted in cases (1) and (4).
  #
  # However, we are using auto-popup, and we don't want it to interfere with
  # <CR> (rule: never let automagic get in the way of user intentions). On the
  # other hand, we do not want to insert literal <CR> when the user has just
  # chosen a match to insert (same rule). Thus:
  #
  # - in case (1), <CR> must confirm selection and close popup (because the
  #   user meant to confirm the selection, not to insert <CR>);
  # - in case (3), <CR> must dismiss popup and insert <CR> (because the user
  #   never meant to engage with the completion system).
  #
  if complete_info().selected > -1
    # this handles cases (1) and (2)
    return "\<Plug>(vimcomplete-skip)\<C-y>"
  elseif pumvisible()
    # this handles case (3)
    # might also get away with <cr><cr>, but I might have missed something
    # above and we do not want to ever have a chance of inserting double <CR>
    return "\<Plug>(vimcomplete-skip)\<C-e>" .. s:EmitCR()
  else
    # this handles case (4)
    return s:EmitCR()
  endif
enddef

def! s:HandleESC(): string
  if pumvisible()
    return "\<Plug>(vimcomplete-skip)\<C-e>\<ESC>"
  else
    return "\<ESC>"
  endif
enddef

inoremap <silent> <expr> <TAB> <SID>HandleTab()
inoremap <silent> <expr> <S-TAB> <SID>HandleSTab()
inoremap <silent> <expr> <CR> <SID>HandleCR()
inoremap <silent> <expr> <ESC> <SID>HandleESC()


"
" Disable rooter on manual chdir
" HACK: there is no variable to control vim-rooter on a per-buffer basis,
"       so instead just set the "cached directory" to the one we lcd'ed to
"

def! s:handle_lcd(buf: number, cwd: string)
  setbufvar(buf, 'rootDir', cwd)
enddef

augroup my-handle-lcd
    au!
    " explicitly no ++nested, we don't want to trigger on vim-rooter's lcds
    au DirChanged window call s:handle_lcd(+expand('<abuf>'), expand('<afile>'))
augroup end


"
" Open multiple arguments in tabs by default
" (https://vi.stackexchange.com/a/2197/7826)
"

" only play buffer games if we start in a 'normal' disposition, without any
" splits or tabs (i.e. exactly 1 buffer shown, other buffers hidden) -- this
" is to avoid overriding `vimdiff` or `vim -[oO]` or custom startup commands
function! s:want_args_to_tabs()
  let buffers = getbufinfo()
  let shown = filter(copy(l:buffers), {_, v -> !empty(v.windows)})
  let hidden = filter(copy(l:buffers), {_, v -> empty(v.windows)})
  return len(l:shown) == 1 && len(l:hidden) > 0
endfunction

augroup my-args-to-tabs
    au!
    au VimEnter * ++nested if s:want_args_to_tabs() | tab all | tabfirst | endif
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

  def! s:VimOSCYankPostCallback(event: any)
    if event.operator == 'y' && index(s:VimOSCYankPostRegisters, event.regname) != -1
      g:OSCYankRegister(event.regname)
    endif
  enddef

  augroup VimOSCYankPost
    autocmd!
    autocmd TextYankPost * call s:VimOSCYankPostCallback(v:event)
  augroup END
endif


"
" automatically give executable permissions if file begins with #! and contains '/bin/' in the path
" see http://www.debian-administration.org/articles/571
" modified 23.12.2008 Benedikt Stegmaier
"
def! s:ChmodX()
  var first = getline(1)
  var scripttype = ''
  var hint = v:false

  if first =~ '\v^\#\! *(/hint/|/bin/|/usr/bin/|/usr/bin/env *)bash>'
    scripttype = 'bash'
  elseif first =~ '^\v\#\! *(/hint/|/bin/|/usr/bin/|/usr/bin/env *)zsh>'
    scripttype = 'zsh'
  elseif first =~ '\v^#! *(/hint/|/bin/|/usr/bin/|/usr/bin/env *)sh>'
    scripttype = 'sh'
  endif

  if first =~ '\v^#! */hint/'
    hint = v:true
  endif

  if scripttype != ''
    var path = expand('%:p')
    if !hint && !executable(path)
      silent system('chmod +x ' .. shellescape(path))
    endif
    if !&l:filetype
      &l:filetype = scripttype
    endif
  endif
enddef

augroup my-chmod-x
  autocmd!
  autocmd BufWritePost * call s:ChmodX()
augroup END


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

def! s:RulerTrapColorcolumn()
  if v:option_type == 'local'
    w:colorcolumn_set = v:option_new
  endif
enddef

def! s:RulerCompute(pos: number, width: number): string
  if pos <= width
    var a = pos
    var b = s:floorm(pos + 255, width)
    if a <= b
      var cols = range(a, b)
      return join(cols, ',')
    endif
  endif
  return ''
enddef

def! s:RulerUpdate()
  # bail if explicitly disabled
  if exists('w:ruler_disable') || exists('b:ruler_disable')
    return
  endif
  # bail if we caught a `setl colorcolumn=...` and it was not us
  # also bail if it is intentionally disabled (HACK)
  # FIXME: also bail even if we didn't, but it was clearly set and it was not us:
  #        \ || (&l:colorcolumn != '' && &l:colorcolumn != get(w:, 'colorcolumn_last', v:null))
  #        however, this needs refinement in face of switching buffers and windows
  # NOTE: v:null is a sentinel which compares inequal to any string
  # HACK: '0' is a sentinel that I `setl` to disable colorcolumn (see above)
  if (exists('w:colorcolumn_set') && w:colorcolumn_set != get(w:, 'colorcolumn_last', v:null))
        \ || (&l:colorcolumn == '0')
    return
  endif

  var ruler = g:rulerwidth
  if &textwidth > 0
    ruler = &textwidth
  elseif &wrapmargin > 0
    ruler = &wrapmargin
  endif

  var info = getwininfo(win_getid())
  var width = info[0].width - info[0].textoff
  var colorcolumn = s:RulerCompute(ruler + 1, width)

  &l:colorcolumn = colorcolumn
  w:colorcolumn_set = colorcolumn
  w:colorcolumn_last = colorcolumn
enddef

def! s:Ruler(windows: list<number>)
  if empty(windows)
    s:RulerUpdate()
  else
    foreach(windows, (k, v) => win_execute(v, 'call s:RulerUpdate()'))
  endif
enddef

augroup my-colorcolumn
  au!
  au VimEnter             *            call s:Ruler([])
  au VimResized           *            call s:Ruler([])
  au BufWinEnter          *            call s:Ruler([])
  au WinResized           *            call s:Ruler(v:event.windows)
  au OptionSet            colorcolumn  call s:RulerTrapColorcolumn()
augroup END


"
" Highlight trailing whitespace, except on current line in insert mode
" (cf. g:solarized_hitrail, which does not exclude current line)
" Link: https://vim.fandom.com/wiki/Highlight_unwanted_spaces
" Link: https://github.com/ntpeters/vim-better-whitespace/blob/master/plugin/better-whitespace.vim
"

augroup my-trailingspace
  au!
  au CursorMovedI,InsertEnter *  call s:TrailingSpace('i')
  au InsertLeave,BufWinEnter  *  call s:TrailingSpace('n')
augroup END

def! s:TrailingSpace(mode: string)
  var pattern = (mode == 'i') ? '\s\+\%#\@<!$' : '\s\+$'
  # FIXME: for some reason, w: variables sometimes get copied to newly created
  #        windows that do not actually have these match IDs. To work around
  #        that, also save the window ID and ignore the w: variables if they
  #        come from a different window.
  if exists('w:trailingspace_match') && w:trailingspace_win == win_getid()
    sil! matchdelete(w:trailingspace_match)
    matchadd('solarizedTrailingSpace', pattern, 10, w:trailingspace_match)
  else
    w:trailingspace_match = matchadd('solarizedTrailingSpace', pattern)
    w:trailingspace_win = win_getid()
  endif
enddef


"
" Set terminal title reasonably
" FIXME: this is fugly. All of it.
"

def! s:Abbreviate(arg: string,
                  sep: string,
                  prefix: string,
                  abbr: string,
                  fullmatch_is_prefix: bool): string
  if arg == prefix
    return fullmatch_is_prefix ? abbr : arg
  elseif arg[0 : len(prefix) - 1] == prefix
    return abbr .. sep .. arg[len(prefix) :]
  else
    return arg
  endif
enddef

def! s:Collapse(path: string): string
  var fullpath = fnamemodify(path, ':p')
  var fullhome = fnamemodify('~', ':p')
  return s:Abbreviate(fullpath, '', fullhome, '~/', true)
enddef

def! s:Getcwdfile(sep: string): string
  var path = s:Collapse(expand('%'))
  var cwd = s:Collapse(getcwd())
  return Abbreviate(path, sep, cwd, cwd[: -2], false)
enddef

def! Getcwd(): string
  var cwd = s:Collapse(getcwd())
  return cwd[: -2]
enddef

def! s:TitleCwdfile(sep: string): string
  if &filetype == 'netrw'
    return '%{' .. s:SID .. 'Getcwdfile(" ' .. sep .. ' ")}'
  elseif &buftype == ''
    return '%{' .. s:SID .. 'Getcwdfile(" ' .. sep .. ' ")}'
  elseif &buftype == 'directory'
    return '%{' .. s:SID .. 'Getcwdfile(" ' .. sep .. ' ")}'
  elseif &buftype == 'help'
    return '%t %h'
  else
    return '%t [%{&buftype}]'
  endif
enddef

setg title
let &titlestring = '%{% '.s:SID.'TitleCwdfile("/") %}'


"
" Set status line reasonably
" (this uses lightline and shares much code with the terminal title)
"

def s:StatusReadonly(): string
  if &buftype != '' || &filetype == 'netrw' || !&modifiable
    return ''
  elseif &readonly
    return 'RO'
  else
    return ''
  endif
enddef

def s:StatusModified(): string
  if &buftype != '' || &filetype == 'netrw'
    return ''
  elseif !&modifiable
    return '-'
  elseif &modified
    return '+'
  else
    return ''
  endif
enddef

def s:StatusGitTracked(): bool
  return exists('b:gitgutter.path') && type(b:gitgutter.path) == v:t_string
enddef

def s:StatusGit(): string
  if !s:StatusGitTracked()
    return ''
  endif

  var s = g:FugitiveStatusline()
  # strip [Git ... ]
  if len(s) > 4 && s[: 3] == '[Git' && s[-1 :] == ']'
    s = s[4 : -2]
  endif
  # strip ( ... )
  if len(s) > 2 && s[: 0] == '(' && s[-1 :] == ')'
    s = s[1 : -2]
  endif

  return s
enddef

def s:StatusGitHunks(): string
  if !s:StatusGitTracked()
    return ''
  endif

  var [a, m, r] = g:GitGutterGetHunkSummary()
  var s = printf("+%d ~%d -%d", a, m, r)
  return s
enddef

def s:Lightline()
  set noshowmode
  g:lightline = {
    'colorscheme': 'solarized',
    'subseparator': {
      # 'left': '│', 'right': '│'
      'left': '|', 'right': '|'
    },
    'active': {
      'left': [
        [ 'mode', 'paste' ],
        [ 'cwdfile', 'readonly', 'modified' ],
        [ 'gitbranch', 'githunks' ],
      ],
      'right': [
        [ 'lineinfo' ],
        [ 'fileformat', 'fileencoding', 'filetype' ],
      ],
    },
    'inactive': {
      'left': [
        [ 'cwdfile' ],
      ],
      'right': [
        [ 'lineinfo' ],
      ],
    },
    'component': {
      # TODO: perhaps split between separate components?
      'cwdfile': '%{% ' .. s:SID .. 'TitleCwdfile("/") %}',
    },
    # 'component_visible_condition': {
    # },
    'component_function_visible_condition': {
      'gitbranch': s:SID .. 'StatusGitTracked()',
      'githunks': s:SID .. 'StatusGitTracked()',
    },
    'component_function': {
      'gitbranch': s:SID .. 'StatusGit',
      'githunks': s:SID .. 'StatusGitHunks',
      # 'readonly' and 'modified' are defined via functions returning text
      # rather than functions returning %R or %M because in the latter case
      # we would also have to define the visibility condition, basically
      # duplicating the work.
      # thankfully %R / %M are not localized; if we ever want to use %r / %m
      # we would have to define both actual functions and visibility helpers
      'readonly': s:SID .. 'StatusReadonly',
      'modified': s:SID .. 'StatusModified',
    },
  }
enddef
call s:Lightline()

" For some reason, lightline sometimes fails on netrw buffers after repeated
" navigation
augroup my-lightline
  au!
  au FileType netrw call lightline#update()
augroup END


" ----------------------------------------------------------------------------
" COLOR SCHEME
" ----------------------------------------------------------------------------

" The following items are available options, but do not need to be
" included in your .vimrc as they are currently set to their defaults.

" FIXME: g:solarized_termtrans=1 causes massive flickering on down scrolling
"        (you'd think it would be exactly the opposite?)
let g:solarized_termtrans=0
let g:solarized_degrade=0
let g:solarized_bold=1
let g:solarized_underline=1
let g:solarized_italic=0  " see below
let g:solarized_termcolors=16
let g:solarized_contrast="normal"
let g:solarized_visibility="normal"
let g:solarized_diffmode="normal"
let g:solarized_hitrail=0  " see above for alternative implementation
" let g:solarized_menu=1

" try to determine if our output device supports italics
def! s:SolarizedSetItalic()
  if has("gui_running")
    g:solarized_italic = 1
    return
  endif

  if $SOLARIZED_ITALIC != ''
    g:solarized_italic = !!$SOLARIZED_ITALIC
    return
  endif

  var italic_term_blacklist = [
    "linux",
  ]
  for term in italic_term_blacklist
    if $TERM =~ term || $ORIG_TERM =~ term
      g:solarized_italic = 0
      return
    endif
  endfor

  var italic_term_whitelist = [
    "rxvt",
    "gnome-terminal",
    "xterm",
    "alacritty",
    "tmux",
  ]
  for term in italic_term_whitelist
    if $TERM =~ term || $ORIG_TERM =~ term
      g:solarized_italic = 1
      return
    endif
  endfor
enddef
call s:SolarizedSetItalic()

syntax enable
setg background=dark
colorscheme solarized

" Colorscheme tweaks
highlight! link SignColumn LineNr


" ----------------------------------------------------------------------------
" PLUGINS
" ----------------------------------------------------------------------------

" load plugins from $HOME/.vim/bundle
packloadall

" The matchit plugin makes the % command work better, but it is not backwards
" compatible.
if has('syntax') && has('eval')
  packadd matchit
endif


" ----------------------------------------------------------------------------
" PLUGINS :: LATE CONFIGURATION
" ----------------------------------------------------------------------------

" configure vifm.vim #2
" if we asked to replace netrw _and_ vifm.vim actually loaded, disable netrw
if exists('loaded_vifm') && g:vifm_replace_netrw
  let g:loaded_netrw = 1
  let g:loaded_netrwPlugin = 1
endif

" configure vifm.vim #3
" vifm.vim: remove commands conflicting with netrw shorthands
" TODO: rebind them under non-conflicting names (export s:StartVifm somehow)
if exists('loaded_vifm')
  silent! delcommand EditVifm
  silent! delcommand PeditVifm
  silent! delcommand VsplitVifm
  silent! delcommand SplitVifm
  silent! delcommand DiffVifm
  silent! delcommand TabVifm
endif

" tlib: remove commands conflicting with netrw shorthands
silent! delcommand Texecloc
silent! delcommand Texecqfl

" vim-textobj-line: remove commands conflicting with netrw shortcuts
silent! delcommand TextobjLineDefaultKeyMappings
