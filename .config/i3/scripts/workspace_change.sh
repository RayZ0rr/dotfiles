#!/usr/bin/env bash

# https://github.com/RayZ0rr
#
# A simple script for workspace switching within a range
# specified by the variable $num_limit below.
#
# === Dependencies ===
# 1. jq (https://github.com/stedolan/jq)
#
# === Usage ===
#
# Put this script somewhere, say (~/.config/i3/scripts/workspace_changer.sh).
# Make sure it is executable:
#
#     chmod +x ~/.config/i3/scripts/workspace_change.sh
#
# Use as (use your desired key instead of 'n' and 'm'):
# bindsym $mod+n exec --no-startup-id ~/.config/i3/scripts/workspace_change.sh prev
# bindsym $mod+m exec --no-startup-id ~/.config/i3/scripts/workspace_change.sh next


num_current_ws=$(i3-msg -t get_workspaces | jq '.[] | select(.focused).num')

num_limit=9

num_minus=$((${num_current_ws} - 1))
num_plus=$((${num_current_ws} + 1))

case "${num_current_ws}" in
  "${num_limit}")
    num_plus=1 ;;
  "1")
    num_minus=${num_limit} ;;
esac

if [[ "$@" = "next" ]] ; then
  i3-msg workspace number ${num_plus} &> /dev/null
  exit 0
elif [[ "$@" = "prev" ]] ; then
  i3-msg workspace number ${num_minus} &> /dev/null
  exit 0
else
  echo "invalid argument. Use 'next' or 'prev'"
  exit 1
fi
