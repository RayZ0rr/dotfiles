###########################
# Plugins Config
###########################

TMUX_FZF_LAUNCH_KEY="C-f"
# Default value in tmux >= 3.2
TMUX_FZF_OPTIONS="-p -w 62% -h 38% -m"
TMUX_FZF_PREVIEW=1
TMUX_FZF_ORDER="session|window|pane|command|keybinding|clipboard|process"
TMUX_FZF_PANE_FORMAT="[#{window_name}] #{pane_current_command}  [#{pane_width}x#{pane_height}] [history #{history_size}/#{history_limit}, #{history_bytes} bytes] #{?pane_active,[active],[inactive]}"

set -g @logging-path '$HOME/.config/tmux/logs'
bind "C-w" run-shell -b "$HOME/.config/tmux/plugins/tmux-fzf/scripts/window.sh switch"
bind "C-e" run-shell -b "$HOME/.config/tmux/plugins/tmux-fzf/scripts/session.sh attach"

set -g @resurrect-dir '$HOME/.config/tmux/resurrect'
set -g @resurrect-capture-pane-contents 'on'
set -g @resurrect-processes '"nv->nv +SLoad"'

###########################
# Mode indicator plugin
###########################
set -g @mode_indicator_prefix_prompt " WAIT "
set -g @mode_indicator_prefix_mode_style "fg=#2e323b,bg=#B66467,bold"
set -g @mode_indicator_copy_prompt " COPY "
set -g @mode_indicator_copy_mode_style "fg=#2e323b,bg=#f5c2e7,bold"
set -g @mode_indicator_sync_prompt " SYNC "
set -g @mode_indicator_sync_mode_style "fg=#2e323b,bg=#B66467,bold"
set -g @mode_indicator_empty_prompt " TMUX "
set -g @mode_indicator_empty_mode_style "fg=$color_green,bold"
