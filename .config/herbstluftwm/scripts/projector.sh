#!/usr/bin/env bash

connect(){
    if xrandr -q | grep -E "HDMI.* connected" &> /dev/null; then
        if ! xrandr --listactivemonitors | grep "HDMI" &> /dev/null; then
            # xrandr --output eDP --primary --mode 1920x1080 --pos 0x0 --rotate normal --output DP-1-0 --off --output DP-1-1 --off --output DP-1-2 --off --output DP-1-3 --off --output HDMI-1-0 --mode 1920x1080 --pos 1920x0 --rotate normal --output DP-1-4 --off
            xrandr --output eDP --primary --mode 1920x1080 --pos 0x0 --rotate normal --output HDMI-1-0 --mode 1920x1080 --pos 1920x0 --rotate normal
        fi
        sleep 1
        if ! /usr/bin/herbstclient list_monitors | grep "Projector" &> /dev/null; then
            /usr/bin/herbstclient add_monitor 1920x1080+1920+0 "8-" "Projector"
        fi
    fi
}
disconnect(){
    if /usr/bin/herbstclient list_monitors | grep "Projector" &> /dev/null; then
        /usr/bin/herbstclient remove_monitor "Projector"
    fi
    sleep 1
    if xrandr --listactivemonitors | grep "HDMI" &> /dev/null; then
        xrandr --output HDMI-1-0 --off
    fi
}

case "${1}" in
  "connect")
    connect
    exit 0 ;;
  "disconnect")
    disconnect
    exit 0 ;;
  *)
    printf "\nRun 'projector.sh [connect|disconnect]' to [connect|disconnect] the projector.\n"
    exit 1 ;;
esac
