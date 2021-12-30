#!/bin/sh

# TODO: try to implement a wlan interface status and connection SSID or local IP
# https://unix.stackexchange.com/questions/352031/how-to-find-status-of-wlan0

status_str=
separator=" | "
while true; do
    status_str="BAT:"$(~/.config/sdorfehs/battery.sh)"$separator"
    status_str="$status_str"$(date +'%A %b.%e, %Y %I:%M%p')
    # status_str="$status_str"$(uptime -p)
    echo "$status_str" > ~/.config/sdorfehs/bar
    sleep 5 
done
