if pgrep '^polybar' > /dev/null; then
  exit 0
fi

 Terminate already running bar instances
killall -q polybar
# If all your bars have ipc enabled, you can also use
# polybar-msg cmd quit

# Launch Polybar, using default config location ~/.config/polybar/config
polybar main -c ~/.config/polybar/configDWM.ini 2>&1 | tee -a /tmp/polybar.log & disown
# polybar mainDWM -c ~/.config/polybar/configDWM.ini 2>&1 | tee -a /tmp/polybar.log & disown
# polybar main -c "$HOME/.config/polybar/config.ini" 2>&1 | tee -a /tmp/polybar.log & disown

echo "Polybar launched..."
