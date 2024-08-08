vim9script

export def WinWidth(winnr: number = 0): number
  var winid = winnr != 0 ? winnr : win_getid()
  var info = getwininfo(winid)
  var width = info[0].width - info[0].textoff
  return width
enddef
