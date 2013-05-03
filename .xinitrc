[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources
setxkbmap es -option caps:swapescape &
xmodmap ~/.Xmodmap &
xsetroot -cursor_name left_ptr &
nitrogen --restore &
xset b off &
bind C-m previous-window &
pulseaudio --start &
compton -cCfb -D 3.5 &
sleep 10 && dropboxd &
dunst &
eval $(keychain --eval --agents ssh -Q --quiet id_rsa) &
syndaemon -k -i 1 -d &
synclient FingerHigh=50 &
synclient FingerLow=50 &
synclient PalmDetect=1 &
sleep 3 && stalonetray --geometry 1x1-1-1 --transparent true &
mpd &
xset +dpms
xset dpms 0 0 300
exec dbus-launch xmonad
