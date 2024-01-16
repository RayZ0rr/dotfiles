###########################
#  Key Bindings
###########################

#To make C-b the prefix, C-b C-x switch key bindings off,
#then F12 C-x switch them on again.
set -g prefix None
bind -Troot C-b switchc -Tprefix
bind -Tprefix C-x if -F '#{s/empty//:key-table}' 'set key-table empty' 'set -u key-table'
bind -Tempty F12 switchc -Tprefix

bind C-b last-window
bind a send-prefix

unbind -n MouseDrag1Pane
unbind -Tcopy-mode MouseDrag1Pane

# bind C-j new-window -n "session-switcher" "tmux list-sessions | sed -E 's/:.*$//' | grep -v \"^$(tmux display-message -p '#S')\$\" | fzf --reverse | xargs tmux switch-client -t"
# bind C-e display-popup -E "tmux list-sessions | sed -E 's/:.*$//' | grep -v \"^$(tmux display-message -p '#S')\$\" | fzf --reverse | xargs -I{} tmux switch-client -t{}"
bind C-e display-popup -E "tmux list-windows -a -F '#S:#I' | grep -v \"^$(tmux display-message -p '#S:#I')\$\" | fzf --reverse | xargs -I{} tmux switch-client -t{}"

if -b '[ "$SSH_CLIENT" ]' '         \
    set -g status-position bottom;     \
    set -g prefix M-b;              \
    bind    M-b resize-pane -Z;     \
    bind -r M-p previous-window;    \
    bind -r M-n next-window;        \
    ' '                             \
    set -g prefix C-b;              \
    bind    C-x resize-pane -Z;     \
    bind -r C-p previous-window;    \
    bind -r C-n next-window;        \
    '

bind -r tab  select-pane -t :.+
bind -r btab select-pane -t :.-

#Kill current session
bind X confirm-before kill-session

# Set bind key to reload configuration file
bind R source-file ~/.config/tmux/tmux.conf \; display "Tmux config Reloaded!"

#Open tmux config
bind C-c send-keys "$EDITOR ~/.config/tmux/tmux.conf ~/.config/tmux/keybindings.tmux ~/.config/tmux/plugins.tmux ~/.config/tmux/options.tmux ~/.config/tmux/style.tmux" Enter

#Log all the text on current pane to vim buffer, which is not saved
#bind lv capture-pane -S - \; save-buffer ~/.x \; delete-buffer \; new-window 'vim "set buftype=nofile" +"!rm ~/.x"

#Log save to file with prompt for filename
#bind-key lf command-prompt -p 'save history to filename:' -I '~/tmux.history' 'capture-pane -e -J -S- ; save-buffer $PWD/%1 ; delete-buffer'

# My custom keybindings table (activated with C-b C-m)
bind C-m switch-client -Tmy-keys
bind -Tmy-keys c new-window 'zsh'
bind -Tmy-keys x send-keys "echo my binding\n"
bind -Tmy-keys f command-prompt -p 'save history to filename:' -I '~/.config/tmux/history/' 'capture-pane -e -S- ; save-buffer %1 ; delete-buffer'
bind -Tmy-keys v capture-pane -e -S- \; save-buffer ~/tmuxtempfilelog \; delete-buffer \; new-window '$EDITOR "set buftype=nofile" +"!rm ~/tmuxtempfilelog" ~/tmuxtempfilelog +'

#bind v capture-pane -S - \; save-buffer ~/.x \; delete-buffer \; new-window 'vim "set buftype=nofile" +"!rm ~/.x" ~/.x +'
#
# Copy
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
bind -r < swap-window -t -
bind -r > swap-window -t +

# Keys to toggle monitoring activity in a window and the synchronize-panes option
bind m set monitor-activity
bind y set synchronize-panes\; display 'synchronize-panes #{?synchronize-panes,on,off}'
