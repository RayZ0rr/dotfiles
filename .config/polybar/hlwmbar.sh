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
# polybar main -c ~/.config/polybar/configHLWM.ini >&1 | tee -a /tmp/polybar.log & disown
MONITOR=$MONITOR polybar main -c ~/.config/polybar/configHLWM.ini 2>&1 | tee -a /tmp/polybar.log &
# polybar mainDWM -c ~/.config/polybar/configDWM.ini 2>&1 | tee -a /tmp/polybar.log & disown
# polybar main -c "$HOME/.config/polybar/config.ini" 2>&1 | tee -a /tmp/polybar.log & disown

echo "Polybar launched..."
