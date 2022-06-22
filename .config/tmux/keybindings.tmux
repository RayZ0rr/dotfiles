
###########################
#  Key Bindings
###########################

# Tmux prefix
# Current solution is to keep the default
# and have term map C-; to C-b. This is the nicest
# bind I've found and this is the only way to enable it in tmux
#unbind C-b
#set -g prefix C-a
#bind C-b send-prefix

#To make C-b the prefix, C-b C-x switch key bindings off,
#then F12 C-x switch them on again.
set -g prefix None
bind -Troot C-b switchc -Tprefix
bind -Tprefix C-x if -F '#{s/empty//:key-table}' 'set key-table empty' 'set -u key-table'
bind -Tempty F12 switchc -Tprefix

bind-key C-b last-window
bind-key a send-prefix

# bind C-j new-window -n "session-switcher" "tmux list-sessions | sed -E 's/:.*$//' | grep -v \"^$(tmux display-message -p '#S')\$\" | fzf --reverse | xargs tmux switch-client -t"
bind C-j display-popup -E "tmux list-sessions | sed -E 's/:.*$//' | grep -v \"^$(tmux display-message -p '#S')\$\" | fzf --reverse | xargs tmux switch-client -t"

if -b '[ "$SSH_CLIENT" ]' '         \
    set -g status-position bottom;     \
    set -g prefix M-b;              \
    bind    M-b resize-pane -Z;     \
    bind -r M-p previous-window;    \
    bind -r M-n next-window;        \
    ' '                             \
    set -g prefix C-b;              \
    bind    C-b resize-pane -Z;     \
    bind -r C-p previous-window;    \
    bind -r C-n next-window;        \
    '

bind -r tab  select-pane -t :.+
bind -r btab select-pane -t :.-

#Kill current session
bind X confirm-before kill-session

# Set bind key to reload configuration file
bind R source-file ~/.tmux.conf \; display "Tmux config Reloaded!"

#Open tmux config
bind C-c send-keys "$EDITOR ~/.tmux.conf ~/.config/tmux/keybindings.tmux ~/.config/tmux/plugins.tmux ~/.config/tmux/options.tmux ~/.config/tmux/colors.tmux" Enter

#Log all the text on current pane to vim buffer, which is not saved
#bind lv capture-pane -S - \; save-buffer ~/.x \; delete-buffer \; new-window 'vim "set buftype=nofile" +"!rm ~/.x"

#Log save to file with prompt for filename
#bind-key lf command-prompt -p 'save history to filename:' -I '~/tmux.history' 'capture-pane -e -J -S- ; save-buffer $PWD/%1 ; delete-buffer'

# My custom keybindings table (activated with C-b C-m)
bind-key -Tmy-keys c new-window 'zsh'
bind-key -Tmy-keys x send-keys "echo my binding\n"
bind-key -Tmy-keys f command-prompt -p 'save history to filename:' -I '~/.config/tmux/history/' 'capture-pane -e -S- ; save-buffer %1 ; delete-buffer'
bind-key -Tmy-keys v capture-pane -e -S- \; save-buffer ~/tmuxtempfilelog \; delete-buffer \; new-window '$EDITOR "set buftype=nofile" +"!rm ~/tmuxtempfilelog" ~/tmuxtempfilelog +'
bind-key C-m switch-client -Tmy-keys
# bind-key C-l switch-client -Tmy-keys-log-type
#bind-key -Troot C-q switch-client -Tmy-keys-log

#bind v capture-pane -S - \; save-buffer ~/.x \; delete-buffer \; new-window 'vim "set buftype=nofile" +"!rm ~/.x" ~/.x +'
#
# Copy
setw -g mode-keys vi
bind -T copy-mode-vi v      send -X begin-selection
bind -T copy-mode-vi C-v    send -X rectangle-toggle
bind -T copy-mode-vi y      send -X copy-selection-and-cancel
bind -T copy-mode-vi Escape send -X cancel
bind -T copy-mode-vi L      send -X end-of-line
bind -T copy-mode-vi H      send -X start-of-line

# resize panes
bind -r H resize-pane -L 2   # 5 px bigger to the left
bind -r J resize-pane -D 2   # 5 px bigger down
bind -r K resize-pane -U 2   # 5 px bigger up
bind -r L resize-pane -R 2   # 5 px bigger right
# bind > swap-pane -D       # swap current pane with the next one
# bind < swap-pane -U       # swap current pane with the previous one
bind-key -r < swap-window -t -
bind-key -r > swap-window -t +
