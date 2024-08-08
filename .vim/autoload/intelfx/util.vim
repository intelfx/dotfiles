vim9script

export def WinWidth(winnr: number = 0): number
  var winid = winnr != 0 ? winnr : win_getid()
  var info = getwininfo(winid)
  var width = info[0].width - info[0].textoff
  return width
enddef

export def CountVsplits(): number
  var wins = getwininfo()->filter((_, w) => w.tabnr == tabpagenr())
  var wincols = wins->mapnew((_, w) => w.wincol)->sort()->uniq()
  return len(wincols)
enddef

export def CountHsplits(): number
  var wins = getwininfo()->filter((_, w) => w.tabnr == tabpagenr())
  var winrows = wins->mapnew((_, w) => w.winrow)->sort()->uniq()
  return len(winrows)
enddef
