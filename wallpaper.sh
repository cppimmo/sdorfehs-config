#!/bin/sh

# wallpaper setting script
# uses xwallpaper
declare -r PROGNAME="$(basename "$0")"
usage() {
	echo "$PROGNAME: usage: $PROGNAME [-f file | -o output]"
	return
}

if [ -z $(which xwallpaper) ]; then
	exit 1
fi

declare -r directory=~/Pictures/Wallpapers
filename=
output=
setpaper() {
    xwallpaper --output "$output" --stretch "$directory/$filename"
}

while [ -n "$1" ]; do
	case "$1" in
		-f | --file)
			shift
			filename="$1"
			if [ -z "$filename" ]; then
				exit 1
			fi
			;;
		-o | --output)
			shift
			output="$1"
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

if [ "$filename" -a "$output" ]; then
	setpaper
fi
