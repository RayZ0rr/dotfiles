#!/usr/bin/env bash

SEL=`ls ~/.config/i3/layouts/ | dmenu -p "Choose a Layout" -i -l 11`
i3-msg 'workspace 3; append_layout "~/.config/i3/layouts/$SEL"'

# If you want to use zenity instead of dmenu
# LO=`ls -C ~/.config/i3/layouts/`
# SEL=`zenity --list --title="Choose a Layout" --column="Layouts" $LO`
# cat ~/.config/i3/layouts/$SEL | bash
