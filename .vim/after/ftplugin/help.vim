"
" Open help windows in vertical or horizontal splits, depending on the total
" editor dimensions.
" cf. https://stackoverflow.com/a/18797550
"

vim9script

import autoload 'intelfx/util.vim'
import autoload 'intelfx/hacks.vim'

def HelpRearrange()
  var hsplit = false

  # bail if we are not in a help window (and remember window-ID while at it)
  var winid = win_getid()
  if winid->getwinvar('&buftype', '') != 'help'
    return
  endif

  # estimate the width of a new vertical split by counting existing splits,
  # ignoring the current window (as it is the one that will be the new split)
  if &columns / (util.CountVsplits((w) => w.winid != winid) + 1) < 70
    hsplit = true

  # check if the editor window is visually landscape or portrait
  elseif &columns < &lines * hacks.FontHcoef()
    hsplit = true

  # try vertical split, see what happens
  else
    :exe "wincmd " .. (&splitright ? "L" : "H")
    var width = util.WinWidth()
    if width < 70
      hsplit = true
    elseif width < 78
      :exe "vertical resize 78"
    endif
  endif

  # if we tried a vsplit and failed (or if we didn't try at all), do a hsplit
  if hsplit
    :exe "wincmd " .. (&splitbelow ? "J" : "K")
  endif
enddef

augroup my-ft-help
  au!
  au BufWinEnter <buffer> HelpRearrange()
augroup end
