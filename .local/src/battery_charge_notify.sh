#!/usr/bin/env bash

while true
do
  User=$(whoami)

  BATTERY0_STATUS="/sys/class/power_supply/BAT0/status"
  BATTERY0_CAPACITY="/sys/class/power_supply/BAT0/capacity"

  BATTERY1_STATUS="/sys/class/power_supply/BAT1/status"
  BATTERY1_CAPACITY="/sys/class/power_supply/BAT1/capacity"

  state_charging="Charging" ;
  charge_full="90" ;
  icon_full="/usr/share/icons/Papirus/22x22/panel/battery-good-charging.svg"

  state_discharging="Discharging" ;
  charge_low="20" ;
  icon_low="/usr/share/icons/Papirus/22x22/panel/battery-low.svg"

  state_notcharging="Not charging" ;
  icon_not="/usr/share/icons/Papirus/22x22/panel/battery-caution.svg" ;

  hibernation="on" ;
  charge_critical="5" ;

  # Source the environment variables required for notify-send to work.
  env_vars_path="$HOME/.cache/.battery_env_vars"

  rm -f "${env_vars_path}"
  touch "${env_vars_path}"
  chmod 600 "${env_vars_path}"

  # Array of the environment variables.
  env_vars=("DBUS_SESSION_BUS_ADDRESS" "XAUTHORITY" "DISPLAY")

  for env_var in "${env_vars[@]}"
  do
    # echo "$env_var"
    env | grep "${env_var}" >> "${env_vars_path}";
    echo "export ${env_var}" >> "${env_vars_path}";
  done
  source "${env_vars_path}"

  # upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep -E \"state|to\ full|percentage\" ;  --- There are different ways we get battery status - this is no 1
  # upower -i $(upower -e | grep 'BAT') | grep -E \"state|to\ full|percentage\" | awk '/perc/{print \$2}' --- There are different ways we get battery status - this is no 2
  # \$ find /sys/class/power_supply/BAT0/ -type f | xargs -tn1 cat --- There are different ways we get battery status - this is no 3
  # \$ cat /sys/class/power_supply/BAT0/status --- There are different ways we get battery status - this is no 4
  # \$ cat /sys/class/power_supply/BAT0/capacity --- There are different ways we get battery status - this is no 5

  # Set state variable
  # cat "${BATTERY0_STATUS}"
  status=$(cat "${BATTERY0_STATUS}")
  if [[ -n "${status}" ]]; then
    state=$(cat "${BATTERY0_STATUS}") ;
  else
    state=$(cat "${BATTERY1_STATUS}") ;
  fi


  # Set capacity variable =
  # cat "${BATTERY0_CAPACITY}"
  if [ $? -eq 0 ]; then
    percent=$(cat "${BATTERY0_CAPACITY}") ;
  else
    percent=$(cat "${BATTERY1_CAPACITY}") ;
  fi

  #### play_beep = \$(play -q -n synth 0.2 sin 880 >& /dev/null)
  #### play -q -n synth 0.1 sin 880 ---> Changing the 0.1 will change the length of the sound, Changing sin 880 will adjust the pitch ... lots of possibilities!
  # touch ~/.local/src/bat_test

  # ------- Overcharging Protection -------
  if [[ "${state}" == "${state_charging}" ]];
  then
    if [ $percent -gt $charge_full ];
    then
      notify-send -t 20000 -i $icon_full -u normal -h string:hlcolor:#4444ff -h string:fgcolor:#1d6636 "Battery is almost full ($percent %)" "Disconnect power supply to improve battery life" ;
      paplay /usr/share/sounds/freedesktop/stereo/suspend-error.oga
      # (notify-send -i $icon_full "Battery is almost CHARGED = $percent %" "Disconnect power supply to improve battery life" ; $(play -q -n synth 0.2 sin 880 >& /dev/null) ; sleep 1 ; spd-say "Disconnect Charger" || speak "Disconnect Charger")
    fi
  # ------- Discharging Protection -------
  elif [[ "${state}" == "${state_discharging}" ]];
  then
    # ------- Very low hibernate -------
    if [[ "${hibernation}" == "on" ]];
    then
      if [ $percent -lt $charge_critical ];
      then
	choice=`zenity --entry --title="Hibernate system? (yes or no) " --text="Choice:" --entry-text "yes or no"`
	! [[ "${choice}" == "no" ]] && systemctl hibernate
      fi
    elif [ $percent -lt $charge_low ];
    then
      notify-send -i $icon_low -u critical "Battery is very low ($percent %)" "Connect power supply to continue" ;
      paplay /usr/share/sounds/freedesktop/stereo/suspend-error.oga
      # (notify-send -i $icon_low "Battery is about to DISCHARGE = $percent % remaining" "Connect power supply to continue" ; $(play -q -n synth 0.2 sin 880 >& /dev/null) ; sleep 1 ; spd-say "Connect Charger" || speak "Connect Charger")
    fi
  # ------- Full cahrge/Not charging -------
  elif [[ "${state}" == "${state_notcharging}" ]];
  then
    if [ $percent -gt $charge_full ];
    then
      notify-send -t 20000 -i $icon_not -u normal -h string:hlcolor:#4444ff -h string:fgcolor:#1d6636 "Battery is full ($percent %)" "Disconnect power supply to improve battery life" ;
      paplay /usr/share/sounds/freedesktop/stereo/suspend-error.oga
      # (notify-send -i $icon_full "Battery is almost CHARGED = $percent %" "Disconnect power supply to improve battery life" ; $(play -q -n synth 0.2 sin 880 >& /dev/null) ; sleep 1 ; spd-say "Disconnect Charger" || speak "Disconnect Charger")
    elif [ $percent -lt $charge_low ];
    then
      notify-send -i $icon_low -u critical "Battery not charging ($percent %)" "Connect power supply to continue" ;
      paplay /usr/share/sounds/freedesktop/stereo/suspend-error.oga
      # (notify-send -i $icon_low "Battery is about to DISCHARGE = $percent % remaining" "Connect power supply to continue" ; $(play -q -n synth 0.2 sin 880 >& /dev/null) ; sleep 1 ; spd-say "Connect Charger" || speak "Connect Charger")
    fi
  # else exit 0
  fi
  sleep 300
done
