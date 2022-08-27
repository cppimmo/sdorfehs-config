#!/bin/bash

# TODO: try to implement a wlan interface status and connection SSID or local IP
# https://unix.stackexchange.com/questions/352031/how-to-find-status-of-wlan0

status_str=
separator=" | "
while true; do
    status_str="BAT:"$(~/.config/sdorfehs/battery.sh)"$separator"
	status_str="$status_str"$(printf "BRT:%03.0f%%" $(echo "scale=2 ; (`brightnessctl get` / `brightnessctl max`) * 100" | bc))"$separator"
    status_str="$status_str"$(date +'%a. %b.%e, %Y %I:%M%p')"$separator"
    status_str="$status_str"$(date -d "$(uptime -s) + now" '+UP:%d-%b-%Y %T' | tr [:lower:] [:upper:])
    echo "$status_str" > ~/.config/sdorfehs/bar
    sleep 5 
done

