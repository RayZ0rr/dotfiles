#!/usr/bin/env bash

conn_info=$(nmcli -t -f STATE,TYPE,DEVICE device | grep "^connected" | head -n 1)

if [ -z "$conn_info" ]; then
    conn_state="disconnected"
    conn_type="NONE"
    conn_name="NONE"
else
    conn_state="connected"
    conn_type=$(echo "$conn_info" | cut -d: -f2)
    conn_name=$(echo "$conn_info" | cut -d: -f3)
fi

if [ "${conn_state}" == "disconnected" ]; then
    icon="ﲁ"
    text="Offline"
    col="#575268"
    description="No active network connection"
    speed="0 Mb/s"
else
    text=$(nmcli -t -f NAME connection show --active | head -n 1)
    speed=$(nmcli -f CAPABILITIES.SPEED dev show "${conn_name}" | awk '/SPEED/ {print $2 " " $3}' | head -n 1)

    if [ "${conn_type}" == "wifi" ]; then
        icon=" "
        col="#fabd2f"
        description="Connected to Wi-Fi: ${text} (${conn_name})"
    elif [ "${conn_type}" == "ethernet" ]; then
        icon="  "
        col="#83a598"
        description="Wired Connection: ${conn_name}"
    else
        icon="  "
        col="#8ec07c"
        description="Connected via ${conn_type}"
    fi
fi

case "$1" in
    "type")
        echo "${conn_type}"
        ;;
    "name")
        echo "${text}"
        ;;
    "icon")
        echo "${icon}"
        ;;
    "status")
        echo "${conn_state}"
        ;;
    "description")
        echo "${description}"
        ;;
    "speed")
        echo "${speed:-N/A}"
        ;;
    *)
        echo "${text}"
        ;;
esac
