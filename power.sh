#!/bin/bash

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

while :; do
    sleep $REFRESH_RATE
    get_battery 
    get_battery_state
    if [[ "$battery_state" == *dis* ]]; then
	# echo "Discharging!"
        if [ "$battery_status" -le $CRITICAL_WARNING ]; then
            sdorfehs -c "echo Warning: Battery state is low!"
        elif [ "$battery_status" -le $CRITICAL_SUSPEND ]; then
            loginctl suspend
        elif [ "$battery_status" -le $CRITICAL_HIBERNATE ]; then
            loginctl hibernate
        fi
    fi
    #else
	# echo "Charging!"
    #fi
    # echo $battery_status
    # echo $battery_state
done

