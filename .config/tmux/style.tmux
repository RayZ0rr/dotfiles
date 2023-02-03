###########################
# Style
###########################

#Color256 cheatsheet https://jonasjacek.github.io/colors/
color_bg="#202328"
color_fg="#bbc2cf"
color_yellow="#ECBE7B"
color_cyan="#008080"
color_green="#98be65"
color_orange="#FF8800"
color_violet="#a9a1e1"
color_magenta="#c678dd"
color_skyblue="#7daea3"
color_blue="#51afef"
color_oceanblue="#45707a"
color_darkblue="#081633"
color_red="#ec5f67"
color_cream="#a89984"
color_grey="#bbc2cf"
color_black="#202328"
color_white="#ffffff"

# ------------------------------------------------
# statusbar
# ------------------------------------------------
set -g status-style 'fg=#5b5f71 bg=colour235'
# set-option -g status-style bg=colour000,fg=colour223
# set -g status-style 'fg=colour235 bg=colour0'
# set -g status-style 'bg=colour18 fg=colour137 dim'

# Window title
# ------------------------------------------------
# setw -g window-status-style fg=green,bg=colour235
# Set different background color for active window
# setw -g window-status-current-style fg=black,bold,bg=red
#set -g window-status-current-bg magenta
# colorgrey=#5b5f71
# default window title colors
set-window-option -g window-status-style bg=colour003,fg=colour237 # bg=yellow, fg=bg1
# default window with an activity alert
set-window-option -g window-status-activity-style bg=colour237,fg=colour248 # bg=bg1, fg=fg3
# active window title colors
set-window-option -g window-status-current-style bg=colour001,fg=colour237 # fg=bg1

# color of message bar
set -g message-style fg=colour235,bg=colour130
# message infos
set-option -g message-style bg=colour239,fg=colour223 # bg=bg2, fg=fg1
# writing commands inactive
set-option -g message-command-style bg=colour239,fg=colour223 # bg=fg3, fg=bg1
# pane number display
set-option -g display-panes-active-colour colour250 #fg2
set-option -g display-panes-colour colour237 #bg1
# clock
set-window-option -g clock-mode-colour colour004 #blue
# bell
set-window-option -g window-status-bell-style bg=colour001,fg=colour235 # bg=red, fg=bg

## Theme settings mixed with colors (unfortunately, but there is no cleaner way)
set-option -g status-justify "left"
set-option -g status-left-style none
set-option -g status-left-length "80"
set-option -g status-right-style none
set-option -g status-right-length "80"
set -g window-status-separator      ""
set -g window-status-format         "#[bg=colour235,nobold]#[fg=colour10]  #I#[fg=colour235]#[bg=colour10] #[fg=colour235]#[bg=colour10]#W #[bg=colour235]#[fg=colour10]#{@left_separator}"
set -g window-status-current-format "#[fg=colour30]#[bg=colour235]  #I#[fg=colour235]#[bg=colour30] #[fg=colour235]#[bg=colour30]#W#[fg=colour30]#[bg=colour235]#{@left_separator}"

set -g @left_separator      ""
# set -g @left_alt_separator  ""
set -g @left_alt_separator  ""
set -g @right_separator     ""
set -g @right_alt_separator ""
# set -g @right_alt_separator ""

# set color of active pane
set -g pane-border-style fg=colour240,bg=colour0
set -g pane-active-border-style fg=green,bg=black

# Status basr sections
# set -g status-left        "#[fg=colour235,nobold]#[bg=colour208]  #{pane_current_command}#[fg=colour208]#[bg=colour205]#{?client_prefix,#[bg=#ff0000],}"
# set -ga status-left        "#[fg=colour235]#[bg=colour205]#{?client_prefix,#[bg=#ff0000]#[fg=white],}  #S#[fg=colour205]#[bg=colour235]#{?client_prefix,#[fg=#ff0000],}#{@left_separator}"
set -g status-left   "#[fg=colour239,bold,bg=colour003]  #{pane_current_command}#[fg=colour003,bold,bg=colour239]#{?client_prefix,#[bg=#ff0000],} "
set -ga status-left  "#[fg=colour003]#[bg=colour239]#{?client_prefix,#[bg=#ff0000]#[fg=white],}  #S#[fg=colour239,bg=colour235]#{?client_prefix,#[fg=#ff0000],}#{@left_separator}"

set -g  status-right "#{tmux_mode_indicator}#{?client_prefix,#[bg=colour000],#[bg=colour235]}#[fg=$color_cream]#{@left_alt_separator} #[fg=colour235,bg=$color_cream]#{?client_prefix, #(whoami), %H:%M}"
set -ga status-right "#[fg=$color_oceanblue,bg=$color_cream]#{@left_alt_separator} #[fg=colour235,bg=$color_oceanblue]#{?client_prefix, #h ,%a %d/%m}"
# set-option -g status-right "#[bg=colour000,fg=colour000, bold, nounderscore, noitalics] #[bg=colour007,fg=colour239, bold] %d-%m-%Y #[bg=colour000,fg=colour000, bold, nounderscore, noitalics] #[bg=colour007,fg=colour239, bold] %H:%M #[bg=colour000,fg=colour000,nobold,noitalics,nounderscore] #[bg=colour004,fg=colour239, bold] #h "

# set -g status-right-length 50
# set -g status-right '#{prefix_highlight}#[fg=colour233,bg=colour39] %a %d/%m #[fg=colour233,bg=colour11]  %H:%M '
# set -g status-right '#{prefix_highlight} %a %Y-%m-%d  %H:%M'
set -g default-terminal "tmux-256color"
