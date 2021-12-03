#!/bin/bash

# utility for setting an mainting brightness
declare -r PROGNAME="$(basename "$0")"
usage() {
	echo "$PROGNAME: usgage: $PROGNAME []"
	return
}

XORG_DISPLAY=
set_display() {
	XORG_DISPLAY="$1"
	return
}

get_display_info() { # pass display 
	xrandr --verbose | grep -m 1 -w "$1 connected" -A8 | grep "$2" | cut -f2- -d: | tr -d ' '
}

get_brightness() {
	echo $(get_display_info "$XORG_DISPLAY" "Brightness: ")
}

set_brightness() {
	xrandr --output "$XORG_DISPLAY" --brightness "$1"
	return
}

brightness=
while [ -n "$1" ]; do
	case "$1" in
		-o | --output)
			shift
			set_display "$1"
			;;
		-s | --set)
			shift
			set_brightness "$1"
			exit
			;;
		-i | --increase)
			shift
			brightness=$(echo "$(get_brightness) + $1" | bc)
			if [ $(echo "$brightness>1.0"|bc) -eq 1 ]; then
				exit 1
			else
				set_brightness "$brightness"
			fi
			exit
			;;
		-d | --decrease)
			shift
			brightness=$(echo "$(get_brightness) - $1" | bc)
			if [ $(echo "$brightness<0.1"|bc) -eq 1 ]; then
				exit 1
			else
				set_brightness "$brightness"
			fi
			exit
			;;
		-g | --get)
			echo -e "$XORG_DISPLAY Brightness: $(get_brightness)\n"
			exit
			;;
		-h | --help)
			usage
			exit
			;;
		*)
			usage >&2
			exit 1
			;;
	esac
	shift
done

