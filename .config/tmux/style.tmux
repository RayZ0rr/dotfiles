###########################
# Style
###########################

#Color256 cheatsheet https://jonasjacek.github.io/colors/
# + Catppuccin (Mocha)
color_bg="#1e1e2e"
color_fg="#cdd6f4"
color_bg_light="#202328"
color_fg_light="#bbc2cf"
color_white="#ffffff"
color_black="#181825"
color_grey="#313244"
color_grey_light="#585b70"
color_green="#8CC77D"
color_green_dark="#98be65"
color_red="#B66467"
color_red_dark="#ec5f67"
color_blue="#6cb8f4"
color_blue_dark="#51afef"
color_skyblue="#7daea3"
color_oceanblue="#45707a"
color_cyan="#89dceb"
color_cyan_dark="#008080"
color_yellow="#f9e2af"
color_yellow_dark="#ECBE7B"
color_orange="#fab387"
color_orange_dark="#FF8800"
color_magenta="#cba6f7"
color_magenta_dark="#c678dd"
color_violet="#a9a1e1"
color_pink="#f5c2e7"
color_cream="#a89984"

# ------------------------------------------------
# statusbar
# ------------------------------------------------
## Theme settings mixed with colors (unfortunately, but there is no cleaner way)
set -g status-justify "left"
set -g status-left-style none
set -g status-left-length "80"
set -g status-right-style none
set -g status-right-length "80"

set -g status-style "fg=$color_grey bg=$color_bg_light"
# set -g status-style 'bg=colour18 fg=colour137 dim'

# Window title
# ------------------------------------------------
# default window title colors
set -g window-status-style "bg=$color_yellow,fg=$color_bg_light" # bg=yellow, fg=bg1
# default window with an activity alert
set -g window-status-activity-style "bg=$color_bg_light,fg=$color_fg_light" # bg=bg1, fg=fg3
# active window title colors
set -g window-status-current-style "bg=$color_bg,fg=$color_bg_light" # fg=bg1

# color of message bar
set -g message-style fg=colour235,bg=colour130
# message infos
set -g message-style bg=colour239,fg=colour223 # bg=bg2, fg=fg1
# writing commands inactive
set -g message-command-style bg=colour239,fg=colour223 # bg=fg3, fg=bg1
# pane number display
set -g display-panes-active-colour colour250 #fg2
set -g display-panes-colour colour237 #bg1
# clock
set -g clock-mode-colour colour004 #blue
# bell
set -g window-status-bell-style bg=colour001,fg=colour235 # bg=red, fg=bg

set -g window-status-format         "#[bg=$color_bg,nobold]#[fg=$color_cream]  #I #[fg=$color_bg]#[bg=$color_cream] #W "
set -g window-status-current-format "#[fg=$color_blue]#[bg=$color_bg]  #I #[fg=$color_bg]#[bg=$color_blue] #[fg=$color_bg]#[bg=$color_blue]#W "

set -g @left_arrow      ""
set -g @left_alt_arrow  ""
set -g @left_triangle  ""
set -g @right_arrow     ""
set -g @right_alt_arrow ""
set -g @right_triangle  ""

# set color of active pane
set -g pane-border-style "fg=$color_bg_light,bg=$color_black"
set -g pane-active-border-style "fg=$color_green,bg=$color_black"

# Status bar sections
set -g status-left   "#[fg=$color_grey,bold,bg=$color_violet]#{?client_prefix,#[bg=$color_grey]#[fg=$color_red],}  #{pane_current_command}#[fg=$color_violet,bold,bg=$color_yellow_dark]#{?client_prefix,#[fg=$color_grey]#[bg=$color_red],}#{@left_arrow}"
set -ga status-left  "#[fg=$color_grey]#[bg=$color_yellow_dark]#{?client_prefix,#[bg=$color_red]#[fg=$color_white],}  #S "

set -g  status-right "#{tmux_mode_indicator}"
# set -g  status-right "#{tmux_mode_indicator}#[fg=$color_bg,bg=$color_cream]#{?client_prefix,  #(whoami) ,  %H:%M }"
# set -ga status-right "#[fg=$color_oceanblue,bg=$color_cream]#{@right_arrow}#[fg=$color_bg,bg=$color_oceanblue]#{?client_prefix,  #h , %a %d/%m }"
# set -g  status-right "#{tmux_mode_indicator}#{?client_prefix,#[bg=$color_black],#[bg=$color_bg]}#[fg=$color_cream]#{@left_alt_separator} #[fg=$color_bg,bg=$color_cream]#{?client_prefix, #(whoami), %H:%M}"
# set -ga status-right "#[fg=$color_oceanblue,bg=$color_cream]#{@left_alt_separator} #[fg=$color_bg,bg=$color_oceanblue]#{?client_prefix, #h ,%a %d/%m}"
# set-option -g status-right "#[bg=$color_black,fg=$color_black, bold, nounderscore, noitalics] #[bg=$color_white,fg=$color_grey, bold] %d-%m-%Y #[bg=colour23,fg=$color_black, bold, nounderscore, noitalics] #[bg=$color_white,fg=$color_grey, bold] %H:%M #[bg=$color_white,fg=$color_white,nobold,noitalics,nounderscore] #[bg=$color_blue,fg=$color_grey, bold] #h "
