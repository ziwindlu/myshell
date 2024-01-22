#!/bin/bash

# todo
# [  ] auto adapt multi monitor (use xrandr)
# [  ] auto configration monitor dpi

pkill xwinwrap
videoRoot=/home/lzf/videoWrapper

video="$videoRoot/"`ls $videoRoot | shuf | head -n 1`

echo $video

xwinwrap -g 2560x1440 -ni -s -nf -b -un -ov -fdt -argb -- mpv -wid WID --ao=null --loop=inf --stop-screensaver= "$video" &

if ! test -z $1; then
		video="$videoRoot/"`ls $videoRoot | shuf | head -n 1`
fi

echo $video

xwinwrap -g 1920x1080+2560+0 -ni -s -nf -b -un -ov -fdt -argb -- mpv -wid WID --ao=null --loop=inf --stop-screensaver= "$video" &
