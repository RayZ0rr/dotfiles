#!/usr/bin/env bash

# if pgrep '^polybar' > /dev/null; then
#   exit 0
# fi

# Terminate already running bar instances
killall -q polybar
# If all your bars have ipc enabled, you can also use
# polybar-msg cmd quit

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

MONITOR=$(polybar -m|tail -1|sed -e 's/:.*$//g')

# Launch Polybar, using default config location ~/.config/polybar/config
# polybar dummy -c ~/.config/polybar/config_i3.ini 2>&1 | tee -a /tmp/polybar.log & disown
MONITOR=$MONITOR polybar main -c ~/.config/polybar/config_i3.ini 2>&1 | tee -a /tmp/polybar.log & disown
# polybar left -c ~/.config/polybar/config_i3.ini 2>&1 | tee -a /tmp/polybar.log & disown
# polybar center -c ~/.config/polybar/config_i3.ini 2>&1 | tee -a /tmp/polybar.log & disown
# polybar right -c ~/.config/polybar/config_i3.ini 2>&1 | tee -a /tmp/polybar.log & disown

echo "Polybar launched..."
