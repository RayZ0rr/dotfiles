#!/usr/bin/env bash

initScreensaver() {
    killall -q xscreensaver &> /dev/null
    while pgrep -u $UID -x xscreensaver >/dev/null; do sleep 1; done
    xscreensaver --no-splash &> /dev/null &
    while ! pgrep -u $UID -x xscreensaver >/dev/null; do sleep 1; done
}
set_xset() {
    while xset -q | grep "timeout.* 0" > /dev/null; do
        xset s 60 60
        sleep 1
    done
}
startScreensaver() {
    /usr/bin/xscreensaver-command -activate
}

case "${1}" in
  "init")
      initScreensaver
      exit 0 ;;
  "xset")
      set_xset
      exit 0 ;;
  "start")
      startScreensaver &&
      set_xset
      exit 0 ;;
  *)
    echo "--------------------------------------------------"
    printf "screensaver control script\n"
    echo "--------------------------------------------------"
    printf "\nRun 'bash screensaver.sh [init|xset|start]' to [initialize|setup xset settings|start] screensaver.\n"
    exit 1 ;;
esac
