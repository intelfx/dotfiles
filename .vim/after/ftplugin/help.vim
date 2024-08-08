"
" Open help windows in vertical or horizontal splits, depending on the total
" editor dimensions.
" cf. https://stackoverflow.com/a/18797550
"

vim9script

import autoload 'intelfx/util.vim'

def HelpRearrange()
  var hsplit = false

  # estimate the width of a vertical split
  if &columns / (util.CountVsplits() + 1) < 70
    hsplit = true

  # a font will never be wider than 2:1
  elseif &columns < &lines / 2
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
