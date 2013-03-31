[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources
setxkbmap es &
xmodmap ~/.Xmodmap &
xsetroot -cursor_name left_ptr &
nitrogen --restore &
xset b off &
bind C-m previous-window &
pulseaudio --start &
exec xmonad
