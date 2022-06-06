#!/usr/bin/env bash

case $1 in
  parent)
    i3 mark target_child
    i3-msg "focus parent, focus parent, focus parent, focus parent, focus parent"
    # i3 focus parent
    i3 mark target_parent
    i3 [con_mark="target_child"] focus
    i3 move window to mark target_parent
    i3 unmark target_parent
    i3 unmark target_child
    ;;
esac
