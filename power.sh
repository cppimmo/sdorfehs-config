#!/bin/bash

lockfile -r 0 /tmp/power.sh.lock || exit 1

battery_status=100
battery_state=charging

get_battery() {
    battery_status=$(upower -i `upower -e | grep 'BAT'` | grep \
        'percentage:' | cut -f2 -d ':' | rev | cut -c2- | rev)
}

get_battery_state() {
    battery_state=$(upower -i `upower -e | grep 'BAT'` | grep \
        'state:' | cut -f2 -d ':')
}

declare -r REFRESH_RATE=15
declare -r STATE_CHARGING="charging"
declare -r STATE_DISCHARGING="discharging"
declare -r CRITICAL_WARNING=20
declare -r CRITICAL_SUSPEND=15
declare -r CRITICAL_HIBERNATE=10
declare -r SHOW_CHARGED=90

shown_once=0 # 0=false,1=true

while :; do
    sleep $REFRESH_RATE
    get_battery 
    get_battery_state
    if [[ "$battery_state" == *dis* ]]; then
	# echo "Discharging!"
        if [ "$battery_status" -le $CRITICAL_WARNING ]; then
            sdorfehs -c "echo Warning: Battery state is low!" &
	    notify-send --urgency=critical "Battery state is low!" &
        elif [ "$battery_status" -le $CRITICAL_SUSPEND ]; then
            loginctl suspend
        elif [ "$battery_status" -le $CRITICAL_HIBERNATE ]; then
            loginctl hibernate
        fi
	shown_once=0
    else
	# if [ \( "$battery_status" -ge $SHOW_CHARGED \) -a \( $shown_once -eq 0 \) ]; then
	   # shown_once=1
	   # sdorfehs -c "echo Notice: Battery is fully charged!"
	  #  notify-send --urgency=normal "Battery is fully charged!"
	# fi
    fi
    #else
	# echo "Charging!"
    #fi
    # echo $battery_status
    # echo $battery_state
done

# rm -f /tmp/power.sh.lock

