#!/bin/sh

# CAP_FILE="/sys/class/power_supply/BAT1/capacity"
# cat "$CAP_FILE"
echo $(acpiconf -i 0 | grep "Remaining capacity" | cut -f 2)
exit
