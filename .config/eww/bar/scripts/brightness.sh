#!/usr/bin/env bash

bright_cur=$(brightnessctl get)
bright_src=$(brightnessctl -l | grep Device | head -n1 | cut -d "'" -f 2)
# bright_src=$(xbacklight -list | head -n1)

bright_full="100"
bright_max="80"
bright_mid="50"
bright_min="20"

bright_col="#458588"

bright_icon=""

if [ $bright_cur == $bright_full ] ; then
  bright_icon=""
else
  if [ $bright_cur -gt $bright_mid ] ; then
   [[ $bright_cur -gt $bright_max ]] && bright_icon=""
  else
    if [ $bright_cur -lt $bright_min ] ; then
      bright_icon=""
    else
      bright_icon=""
    fi
  fi
fi

case "$1" in
  "color")
    echo "${bright_cur}"
    ;;
  "icon")
    echo "${bright_icon}"
    ;;
  "get")
    echo "${bright_cur}"
    ;;
  "list")
    echo "[${bright_cur}%] ${bright_src}"
    ;;
  "up")
    brightnessctl set +10
    # xbacklight -inc 1
    ;;
  "down")
    brightnessctl set 10-
    # xbacklight -dec 1
    ;;
  *)
    echo "${bright_cur}"
    ;;
esac
