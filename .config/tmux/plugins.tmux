

###########################
# Plugins
###########################
# List of plugins
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'sainnhe/tmux-fzf'
# set -g @plugin 'tmux-plugins/tmux-sensible'
set -g @plugin 'tmux-plugins/tmux-resurrect'
set -g @plugin 'tmux-plugins/tmux-logging'
set -g @plugin 'MunifTanjim/tmux-mode-indicator'

#Auto install in new system
if "test ! -d ~/.config/tmux/plugins/tpm" \
   "run 'git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm && ~/.config/tmux/plugins/tpm/bin/install_plugins'"

#Plugins directory
set-environment -g TMUX_PLUGIN_MANAGER_PATH '$HOME/.config/tmux/plugins'

# Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)
run '~/.config/tmux/plugins/tpm/tpm'
