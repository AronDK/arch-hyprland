#!/bin/zsh

pkill waybar
waybar >/dev/null 2>&1 &
swaync-client -R
swaync-client -rs
