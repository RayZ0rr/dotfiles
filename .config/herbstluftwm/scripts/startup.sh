#!/usr/bin/env bash

# Auto screen-locker
# betterlockscreen -u "$HOME/.local/src/lock.png" &
# xset s on
# xset -dpms
# xset s 300 600
xset -dpms
xset s 60 120
xss-lock -n 'bash $HOME/.local/bin/dim-screen' -- $HOME/.local/bin/mylock &
# xss-lock -n 'bash $HOME/.local/bin/dim-screen.sh' -- betterlockscreen -l &
# xautolock -time 10 -notify 5 -notifier '/usr/lib/xsecurelock/until_nonidle /usr/lib/xsecurelock/dimmer' -locker 'betterlockscreen -l --blur 0.0' &

# feh --bg-fill $HOME/Pictures/Walls/Minimal/521028.png
feh --bg-fill $HOME/.local/src/wall.png &

$HOME/.config/conky/Mine/branch/ConkybooterBranch &

picom --daemon

$HOME/.local/src/battery_charge_notify.sh &

# For getting root password dialog prompts when running application that require root priveleges
# /usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 &
/usr/bin/lxqt-policykit-agent &

$HOME/.config/eww/bar/hlwm_bar &
# $HOME/.config/polybar/hlwmbar.sh &
# tint2 &

sxhkd &
blueman-applet &
nm-applet &

syncthing-gtk -m &

copyq &
