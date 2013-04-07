[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources
setxkbmap es &
xmodmap ~/.Xmodmap &
xsetroot -cursor_name left_ptr &
nitrogen --restore &
xset b off &
bind C-m previous-window &
pulseaudio --start &
compton -cCfb -D 3.5 &
dropboxd &
dunst &
ssh-agent &
sysndaemon -t -k -i 2 -d &
exec dbus-launch xmonad
