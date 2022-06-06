#!/usr/bin/env bash

if [[ -z "$@" ]] ; then
  echo "Needs aguments. Use [save|load]."
  exit 1
fi

if [[ "$1" == "save" ]] ; then

  FI=`zenity --entry --title="Save the current Layout" --text="Enter name of new Layout:" --entry-text "NewLayout"`
  ! [[ -d "${HOME}/.config/herbstluftwm/layouts" ]] && mkdir -p "${HOME}/.config/herbstluftwm/layouts"
  herbstclient dump > ~/.config/herbstluftwm/layouts/"$FI"
  exit 0

  # If you want to use dmenu instead of zenity
  # FI=`dmenu -p "Enter the name of the new layout" `
  # herbstclient dump > ~/.config/herbstluftwm/layouts/$FI

elif [[ "$1" == "load" ]] ; then

  SEL=`ls ~/.config/herbstluftwm/layouts/ | dmenu -p "Choose a Layout" -i -l 11`
  ! [[ -d "$HOME/.config/herbstluftwm/layouts" ]] && echo "Folder '~/.config/herbstluftwm/layouts' not found." && exit 1
  herbstclient load "$(cat ~/.config/herbstluftwm/layouts/$SEL)"
  exit 0

  # If you want to use zenity instead of dmenu
  # LO=`ls -C ~/.config/herbstluftwm/layouts/`
  # SEL=`zenity --list --title="Choose a Layout" --column="Layouts" $LO`
  # cat ~/.config/herbstluftwm/layouts/$SEL | bash

else
  echo "Invalid argument. Use [save|load]."
  exit 1
fi
