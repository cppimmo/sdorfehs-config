#!/bin/sh

CAP_FILE="/sys/class/power_supply/BAT0/capacity"
cat "$CAP_FILE"
exit

