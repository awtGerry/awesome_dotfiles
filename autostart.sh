#!/bin/sh

# Set the wallpaper
~/.local/bin/awt --walls &
~/.local/bin/awt --keys rate &

xrandr --output DP-1 --mode 1920x1080 --rate 144.00 --primary &
# xrandr --output DP-1 --mode 1920x1080 --rate 144.00 --primary --output HDMI-0 --mode 1360x768 --rate 60.00 --right-of DP-1 &

autostart="picom --experimental-backends -b dunst"
for app in $autostart; do
    pidof -s "$app" || setsid -f "$app"
done >/dev/null 2>&1
