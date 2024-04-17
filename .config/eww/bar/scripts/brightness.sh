#!/usr/bin/env bash

bright_src=$(brightnessctl -l | grep Device | head -n1 | cut -d "'" -f 2)

bright_full=$(printf "%.0f" "$(brightnessctl max)")
bright_high=$(echo "${bright_full} * 0.80" | bc -l | printf "%.0f")
bright_mid=$(echo "${bright_full} * 0.50" | bc -l | printf "%.0f")
bright_min=$(echo "${bright_full} * 0.20" | bc -l | printf "%.0f")

bright_col="#458588"

getBrightness() {
    bright_cur=$(printf "%.0f" "$(brightnessctl get)")
}

getIcon() {
    getBrightness
    bright_icon=""

    if [[ "$bright_cur" = "$bright_full" ]] ; then
        bright_icon="󰃠"
    else
        if [[ "$bright_cur" -gt "$bright_mid" ]] ; then
            [[ "$bright_cur" -gt "$bright_high" ]] && bright_icon="󰃝"
        else
            if [[ "$bright_cur" -lt "$bright_min" ]] ; then
                bright_icon="󰃞"
            else
                bright_icon="󰃟"
            fi
        fi
    fi
}

sendNotification() {
    getBrightness
    bright_notification_icon=""

    if [[ "$bright_cur" = "$bright_full" ]] ; then
        bright_notification_icon="display-brightness-symbolic"
    else
        if [[ "$bright_cur" -gt "$bright_mid" ]] ; then
            [[ "$bright_cur" -gt "$bright_high" ]] && bright_notification_icon="display-brightness-high-symbolic"
        else
            if [[ "$bright_cur" -lt "$bright_min" ]] ; then
                bright_notification_icon="display-brightness-low-symbolic"
            else
                bright_notification_icon="display-brightness-medium-symbolic"
            fi
        fi
    fi

    notify-send --icon="${bright_notification_icon}" "${bright_cur}"
}

case "$1" in
    "color")
        echo "${bright_col}"
        ;;
    "icon")
        getIcon
        echo "${bright_icon}"
        ;;
    "get")
        getBrightness
        echo "${bright_cur}"
        ;;
    "get-percent")
        getBrightness
        num="${bright_cur}*100"
        value=$(echo "${num}/${bright_full}" | bc)
        echo "$value"
        ;;
    "list")
        getBrightness
        echo "[${bright_cur}%] ${bright_src}"
        ;;
    "up")
        brightnessctl set +10
        sendNotification
        exit 0
        ;;
    "down")
        brightnessctl set 10-
        sendNotification
        exit 0
        ;;
    "set")
        brightnessctl set "${2}%" &&
        sendNotification
        ;;
    *)
        echo "${bright_cur}"
        notify-send "[Info] (brightness.sh): provided value ${1}"
        exit 1
        ;;
esac
