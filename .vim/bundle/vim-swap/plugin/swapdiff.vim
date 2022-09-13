function! s:HandleRecover()
  echo system('diff - ' . shellescape(expand('%:p')), join(getline(1, '$'), "\n") . "\n")
  if v:shell_error
    call s:DiffOrig()
  elseif !empty(glob(b:swapname))
    echohl WarningMsg
    echomsg "No differences; deleting the old swap file: '" . b:swapname . "'"
    echohl NONE
    call delete(b:swapname)
  endif
endfunction

function! s:DiffOrig()
  vert new
  set bt=nofile
  r #
  0d_
  diffthis
  wincmd p
  diffthis
endfunction

autocmd SwapExists  * let b:swapchoice = '?' | let b:swapname = v:swapname
autocmd BufReadPost * let b:swapchoice_likely = (&l:ro ? 'o' : 'r')
autocmd BufEnter    * let b:swapchoice_likely = (&l:ro ? 'o' : 'e')
autocmd BufWinEnter * if exists('b:swapchoice') && exists('b:swapchoice_likely') | let b:swapchoice = b:swapchoice_likely | unlet b:swapchoice_likely | endif
autocmd BufWinEnter * if exists('b:swapchoice') && b:swapchoice == 'r' | call s:HandleRecover() | endif