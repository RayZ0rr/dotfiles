#!/usr/bin/env bash

# EXAMPLE
#---------------------------------------------
# Start iceweasel on workspace 3, then switch back to workspace 1
# (Being a command-line utility, i3-msg does not support startup notifications,
#  hence the exec --no-startup-id.)
# (Starting iceweasel with i3’s exec command is important in order to make i3
#  create a startup notification context, without which the iceweasel window(s)
#  cannot be matched onto the workspace on which the command was started.)
# exec --no-startup-id i3-msg 'workspace 3; exec iceweasel; workspace 1'
#----------------------------------------------

if [ -x "$(command -v alacritty)" ]
then
  i3-msg 'workspace 1; append_layout ~/.config/i3/layouts/2Win_SidebySide.json'
  alacritty --class Al1 &
  alacritty --class Al2 &
  sleep 1
  i3-msg "workspace number 1; [instance=Al1] focus, exec --no-startup-id xdotool type $'neofetch\n'"
  sleep 1
  i3-msg "workspace number 1; [instance=Al2] focus, exec --no-startup-id xdotool type $'la\n'"
else
  echo "Alacritty not installed"
fi

if [ -x "$(command -v st)" ]
then
  sleep 1
  i3-msg "workspace number 4; exec --no-startup-id st -n stVifm"
  sleep 1
  # i3-msg "workspace number 2; [title="Vifm"] focus, exec --no-startup-id xdotool key Return"
  i3-msg "workspace number 4; [instance=\"^stVifm$\"] focus, exec --no-startup-id xdotool type $'vf\n'"
  sleep 1
  i3-msg "workspace number 5; exec --no-startup-id st -n stBottom"
  sleep 1
  i3-msg "workspace number 5; [instance=\"^stBottom$\"] focus, exec --no-startup-id xdotool type $'btm\n'"
  sleep 1
  i3-msg 'workspace 3; append_layout ~/.config/i3/layouts/6win_2bigCenter.json'
  sleep 1
  st -n stHtop -e htop &
  st -n stNothing1 &
  st -n stNothing2 &
  st -n stAqua -e asciiquarium  &
  st -n stCmatrix -e cmatrix &
  st -n stPipes -e ~/.local/bin/pipes &
else
  echo "st(simple terminal) not installed"
  exit 1
fi

sleep 1
i3-msg "workspace number 1"
exit 0
