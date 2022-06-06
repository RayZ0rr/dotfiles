#!/usr/bin/env bash

! [[ -d "${HOME}/.config/i3/layouts" ]] && mkdir -p "${HOME}/.config/i3/layouts"
# ! [[ -d "$HOME/.config/herbstluftwm/layouts" ]] && echo "~/.config/herbstluftwm/layouts"

FI=`zenity --entry --title="Save the current Layout to ~/.config/i3/layouts" --text="Enter name of new Layout:" --entry-text "NewLayout"`
i3-save-tree > ~/.config/i3/layouts/"$FI"

# If you want to use dmenu instead of zenity
# FI=`dmenu -p "Enter the name of the new layout" `
# herbstclient dump > ~/.config/herbstluftwm/layouts/$FI
