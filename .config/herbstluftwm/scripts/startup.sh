#!/usr/bin/env bash

# Auto screen-locker
betterlockscreen -u "$HOME/.local/src/lock.png" &
xset s on
xset -dpms
xset s 300 600
xss-lock -n 'bash ~/.local/bin/dim-screen.sh' -- ~/.local/bin/mylock &
# xss-lock -n 'bash ~/.local/bin/dim-screen.sh' -- betterlockscreen -l &
# xautolock -time 10 -notify 5 -notifier '/usr/lib/xsecurelock/until_nonidle /usr/lib/xsecurelock/dimmer' -locker 'betterlockscreen -l --blur 0.0' &

# feh --bg-fill $HOME/Pictures/Walls/Minimal/521028.png
feh --bg-fill $HOME/.local/src/wall.png &

~/.config/conky/Mine/branch/ConkybooterBranch &

picom --daemon

~/.local/src/battery_charge_notify.sh &

# For getting root password dialog prompts when running application that require root priveleges
# /usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 &
/usr/bin/lxqt-policykit-agent &

~/.config/eww/bar/hlwm_bar &
# ~/.config/polybar/hlwmbar.sh &
# tint2 &

sxhkd &
blueman-applet &
nm-applet &

# copyq &
