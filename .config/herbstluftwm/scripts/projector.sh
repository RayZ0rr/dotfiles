#!/usr/bin/env bash

screen_primary="DP-4"
screen_external="HDMI-0"
# screen_external="DP-1"
regex_external="HDMI.* connected"
tag_external="Projector"
tag_icon_external="8-"

connect(){
    if xrandr -q | grep -E "${regex_external}" &> /dev/null; then
        if ! xrandr --listactivemonitors | grep "${screen_external}" &> /dev/null; then
            xrandr --output "${screen_primary}" --primary --mode 1920x1080 --pos 0x0 --rotate normal \
                --output "${screen_external}" --mode 1920x1080 --pos 1920x0 --rotate normal
        fi
        sleep 1
        if ! /usr/bin/herbstclient list_monitors | grep "${tag_external}" &> /dev/null; then
            /usr/bin/herbstclient add_monitor 1920x1080+1920+0 "${tag_icon_external}" "${tag_external}"
        fi
    fi
}
disconnect(){
    if /usr/bin/herbstclient list_monitors | grep "${tag_external}" &> /dev/null; then
        /usr/bin/herbstclient remove_monitor "${tag_external}"
    fi
    sleep 1
    if xrandr --listactivemonitors | grep "${screen_external}" &> /dev/null; then
        xrandr --output "${screen_external}" --off
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
