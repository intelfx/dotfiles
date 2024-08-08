"
" Open help windows in vertical or horizontal splits, depending on the total
" editor dimensions.
" cf. https://stackoverflow.com/a/18797550
"

vim9script

import autoload 'intelfx/util.vim'

def HelpRearrange()
  var hsplit = false

  # a vertical split will never have more columns than total / 2
  if &columns / 2 < 78
    hsplit = true

  # a font will never be wider than 2:1
  elseif &columns < &lines / 2
    hsplit = true

  # try vertical split, see what happens
  else
    :exe "wincmd " .. (&splitright ? "L" : "H")
    hsplit = util.WinWidth() < 78
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
