#!/bin/bash

TrayColor()
{
  COLOR="#e06c75"
  if pgrep -x "stalonetray" > /dev/null
  then
    COLOR="#608B4E"
  fi
  echo $COLOR
}

TrayToggle()
{
  if pgrep -x "stalonetray" > /dev/null
  then
    killall stalonetray &> /dev/null
  else
    stalonetray &
  fi
}

case "$1" in
  "color")
    TrayColor
    ;;
  "toggle")
    TrayToggle
    ;;
  *)
    echo "Invalid option. Use 'toggle' or 'color'."
    ;;
esac
