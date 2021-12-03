#!/bin/sh

CAP_FILE="/sys/class/power_supply/BAT1/capacity"
cat "$CAP_FILE"
exit

