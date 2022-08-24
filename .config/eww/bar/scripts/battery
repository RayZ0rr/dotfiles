#!/usr/bin/env bash

BAT=`ls /sys/class/power_supply | grep BAT | head -n 1`

battery() {
  cat /sys/class/power_supply/${BAT}/capacity
}
battery_stat() {
  cat /sys/class/power_supply/${BAT}/status
}

battery_cur="$(battery)"

battery_full="100"
battery_max="80"
battery_mid="50"
battery_min="20"

battery_col="#458588"

battery_icon=""

if [[ "$(battery_stat)" == "Charging" ]] ; then
  if [ $battery_cur == $battery_full ] ; then
    battery_icon=""
  else
    if [ $battery_cur -gt $battery_mid ] ; then
     [[ $battery_cur -gt $battery_max ]] && battery_icon=""
    else
      if [ $battery_cur -lt $battery_min ] ; then
	battery_icon=""
      else
	battery_icon=""
      fi
    fi
  fi
else
  if [ $battery_cur == $battery_full ] ; then
    battery_icon=""
  else
    if [ $battery_cur -gt $battery_mid ] ; then
     [[ $battery_cur -gt $battery_max ]] && battery_icon=""
    else
      if [ $battery_cur -lt $battery_min ] ; then
	battery_icon=""
      else
	battery_icon=""
      fi
    fi
  fi
fi

case "$1" in
  "get")
    battery
    ;;
  "status")
    battery_stat
    ;;
  "icon")
    echo "${battery_icon}"
    ;;
  *)
    battery
    ;;
esac
