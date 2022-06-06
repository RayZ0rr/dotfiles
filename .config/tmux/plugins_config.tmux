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
bind-key "C-w" run-shell -b "$HOME/.config/tmux/plugins/tmux-fzf/scripts/window.sh switch"
bind-key "C-t" run-shell -b "$HOME/.config/tmux/plugins/tmux-fzf/scripts/session.sh attach"

set -g @resurrect-dir '$HOME/.config/tmux/resurrect'
set -g @resurrect-capture-pane-contents 'on'
set -g @resurrect-processes '"nv->nv +SLoad"'
###########################
# Prefix highlight plugin
###########################

set -g @prefix_highlight_fg '#ff0000' # default is 'colour231'
set -g @prefix_highlight_bg 'black'  # default is 'colour04'

set -g @prefix_highlight_show_copy_mode 'on'
set -g @prefix_highlight_copy_mode_attr 'fg=colour11,bg=black,bold' # default is 'fg=default,bg=yellow'
set -g @prefix_highlight_show_sync_mode 'on'
set -g @prefix_highlight_sync_mode_attr 'fg=#0000ff,bg=black' # default is 'fg=default,bg=yellow'

set -g @prefix_highlight_prefix_prompt 'Prefix'
set -g @prefix_highlight_copy_prompt 'Copy'
set -g @prefix_highlight_sync_prompt 'Sync'

# set -g @prefix_highlight_output_prefix '< '
# set -g @prefix_highlight_output_suffix ' >'

# set -g @prefix_highlight_empty_prompt '        '          # default is '' (empty char)
set -g @prefix_highlight_empty_attr 'fg=colour10,bg=colour235' # default is 'fg=default,bg=default'

set -g @prefix_highlight_empty_has_affixes 'on' # default is 'off'
set -g @prefix_highlight_empty_prompt 'Tmux'
# set -g @prefix_highlight_output_prefix '< '
# set -g @prefix_highlight_output_suffix ' >'
