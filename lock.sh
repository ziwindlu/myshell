#!/bin/bash 

# 静音
amixer sset Master mute
# 关闭屏幕
xset dpms force off
# 关闭动态壁纸 
pkill xwinwrap
# 锁屏
# if ! test -z $1; then
# i3lock-color-example -n ; bash ~/shell/lockAfter.sh
# else
i3lock-color-example 
# fi
