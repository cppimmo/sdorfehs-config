#!/bin/bash

status_str=
separator=" | "
while true; do
    status_str="BAT:"$(~/.config/sdorfehs/battery.sh)"$separator"
    status_str="$status_str"$(date +'%A %b.%e, %Y%l:%M%p')"$separator"
    status_str="$status_str"$(uptime -p)
    echo "$status_str" > ~/.config/sdorfehs/bar
    sleep 5 
done
