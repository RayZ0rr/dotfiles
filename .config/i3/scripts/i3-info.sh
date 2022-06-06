#!/usr/bin/env bash

current_layout() {
  info1=$(i3-msg -t get_tree | jq -r 'recurse(.nodes[];.nodes!=null)|select(.nodes[].focused).layout')
  echo "${info1}"
}

current_ws_num() {
  info2=$(i3-msg -t get_workspaces | jq '.[] | select(.focused).num')
  echo "${info2}"
}

current_ws_name() {
  info3=$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused==true).name')
  # i3-msg -t get_workspaces | jq '.[] | select(.focused==true).name' | cut -d"\"" -f2
  echo "${info3}"
}

case "${1}" in
  "all")
    current_layout
    current_ws_num
    current_ws_name
    exit 0 ;;
  "layout")
    current_layout
    exit 0 ;;
  "wsnum")
    current_ws_num
    exit 0 ;;
  "wsname")
    current_ws_name
    exit 0 ;;
  *)
    echo "Run 'i3-info [all|layout|wsnum|wsname]' to show info about [all|layout|workspace number|workspace name]"
    exit 1 ;;
esac
