vim9script

export def FontHcoef(): float
  # TODO: implement TIOCGWINSZ + CSI 14 t in VTE and Linux VT and use that
  # to get terminal size in pixels instead of assuming
  if $TERM =~ "linux" || $ORIG_TERM =~ "linux"
    # ter-c24n
    return 24.0 / 12.0
  else
    # Iosevka Term 8 @ HiDPI 2x @ vte
    return 30.0 / 10.0
  endif
enddef
