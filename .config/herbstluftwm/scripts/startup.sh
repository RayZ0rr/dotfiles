#!/usr/bin/env bash

# Map capslock to escape
/usr/bin/setxkbmap -option "caps:escape"

# bash $HOME/.local/bin/screensaver.sh "init" && bash $HOME/.local/bin/screensaver.sh "xset" &
# xset -dpms
# xset s 60 60
# xss-lock -n "bash $HOME/.local/bin/screensaver.sh start" -- $HOME/.local/bin/mylock &
xset -dpms
xset s 180 60
xss-lock -n "bash $HOME/.local/bin/dim-screen" -- $HOME/.local/bin/mylock &

# feh --bg-fill $HOME/Pictures/Walls/Minimal/521028.png
feh --no-fehbg --bg-fill $HOME/.local/src/wall/home.png &

$HOME/.config/conky/Mine/branch/ConkybooterBranch &

picom --daemon

$HOME/.local/src/scripts/battery_notifications.sh &

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
