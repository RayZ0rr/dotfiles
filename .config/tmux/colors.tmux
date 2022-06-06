###########################
# Colors
###########################

#Color256 cheatsheet https://jonasjacek.github.io/colors/

# color of message bar
set -g message-style fg=colour235,bg=colour130

set -g @left_separator      ""
# set -g @left_alt_separator  ""
set -g @left_alt_separator  ""
set -g @right_separator     ""
set -g @right_alt_separator ""

# set color of active pane
set -g pane-border-style fg=colour240,bg=colour0
set -g pane-active-border-style fg=green,bg=black

# highlight current window
# setw -g window-status-style fg=green,bg=colour235
# Set different background color for active window
# setw -g window-status-current-style fg=black,bold,bg=cyan
#set -g window-status-current-bg magenta
# colorgrey=#5b5f71
set -g window-status-separator      ""
set -g window-status-format         "#[bg=colour235,nobold]#[fg=colour10]  #I#[fg=colour235]#[bg=colour10] #[fg=colour235]#[bg=colour10]#W #[bg=colour235]#[fg=colour10]#{@left_separator}"
set -g window-status-current-format "#[fg=colour30]#[bg=colour235]  #I#[fg=colour235]#[bg=colour30] #[fg=colour235]#[bg=colour30]#W#[fg=colour30]#[bg=colour235]#{@left_separator}"

# statusbar
set -g status-position bottom
# set -g status-style 'fg=colour235 bg=colour0'
set -g status-style 'fg=#5b5f71 bg=colour235'
# set -g status-style 'bg=colour18 fg=colour137 dim'

# Status basr sections
set -g  status-left-length 36
set -g status-left        "#[fg=colour235,nobold]#[bg=colour208]  #{pane_current_command}#[fg=colour208]#[bg=colour205]#{?client_prefix,#[bg=#ff0000],}"
set -ga status-left        "#[fg=colour235]#[bg=colour205]#{?client_prefix,#[bg=#ff0000]#[fg=white],}  #S#[fg=colour205]#[bg=colour235]#{?client_prefix,#[fg=#ff0000],}#{@left_separator}"

# set -g status-left ''
# set -g status-justify left

set -g  status-right-length 50
set -g  status-right        "#{prefix_highlight}#{?client_prefix,#[bg=colour0],#[bg=colour235]}#[fg=colour205]#{@right_separator}#[fg=colour235]#[bg=colour205]#{?client_prefix, #(whoami), %H:%M}"
set -ga status-right        "#[fg=colour208]#[bg=colour205]#[fg=colour235]#[bg=colour208]#{?client_prefix, #h ,%a %d/%m}"

# set -g status-right-length 50
# set -g status-right '#{prefix_highlight}#[fg=colour233,bg=colour39] %a %d/%m #[fg=colour233,bg=colour11]  %H:%M '
# set -g status-right '#{prefix_highlight} %a %Y-%m-%d  %H:%M'


# nerd-fonts-bitstream-vera-mono                                                                                                                                                          
# tmux_conf_theme_left_separator_main='\ue0c0'                                                                                                                                              
# tmux_conf_theme_left_separator_sub='\ue0c1'                                                                                                                                               
# tmux_conf_theme_right_separator_main='\ue0c2'
