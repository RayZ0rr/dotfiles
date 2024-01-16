##########################
#  Options
###########################

set -g default-terminal "tmux-256color"
set -g default-shell "/usr/bin/zsh"

# address vim mode switching delay (http://superuser.com/a/252717/65504)
set -g escape-time 10

set -g status-position top

# Undercurl
# set -g default-terminal "${TERM}"
# set-option -as terminal-features ',XXX:RGB'
set -as terminal-overrides ',*:Smulx=\E[4::%p1%dm'  # undercurl support
set -as terminal-overrides ',*:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m'  # underscore colours - needs tmux-3.0
set -as terminal-features ",alacritty*:RGB"
set -as terminal-features ",wezterm*:RGB"
set -as terminal-features ",xterm-*:RGB"
set -as terminal-overrides ",xterm-*:Tc"

set -qg status-utf8 on                  # expect UTF-8 (tmux < 2.2)
set -qg utf8 on

# use vim key bindings
set -g mode-keys vi

# enable mouse
set -g mouse on

# Enable mouse control (clickable windows, panes, resizable panes)
# set -g mouse-select-window on
# set -g mouse-select-pane on
# set -g mouse-resize-pane on
# set -g mouse-select-pane off
# set -g mouse-resize-pane off
# set -g mouse-select-window off

# Set the base index for windows to 1 instead of 0
set -g base-index 1

# Set the base index for panes to 1 instead of 0
set -g pane-base-index 1

#Don't rename windows automatically
set -g allow-rename off

# Use titles in tabs
set -g set-titles on

# re-number windows when one is closed
set -g renumber-windows on

# No bells at all
set -g bell-action none
# focus events enabled for terminals that support them
set -g focus-events on
# highlight window when it has new activity
set -g monitor-activity on
# set -g visual-activity on

# increase scrollback buffer size
set -g history-limit 5000

# tmux messages are displayed for 4 seconds
# set -g display-time 4000

# refresh 'status-left' and 'status-right' more often
# set -g status-interval 5

# set only on OS X where it's required
# set -g default-command "reattach-to-user-namespace -l $SHELL"

# emacs key bindings in tmux command prompt (prefix + :) are better than
# vi keys, even for vim users
# set -g status-keys emacs

# set -g focus-events on

# super useful when using "grouped sessions" and multi-monitor setup
# setw -g aggressive-resize on

