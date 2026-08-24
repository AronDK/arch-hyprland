#!/bin/bash

WALLPAPER_DIR="$HOME/Pictures/wallpapers"
THEME_APPLIER="$HOME/.config/hypr/scripts/apply-wallpaper-theme.sh"

cd "$WALLPAPER_DIR" || exit 1

if [[ ${1:-} == --random ]]; then
    SELECTED_WALL=$(find . -maxdepth 1 -type f \
        \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' \) \
        -printf '%P\0' | shuf -z -n 1 | tr -d '\0')
else
    SELECTED_WALL=$(
        find . -maxdepth 1 -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' \) -printf '%T@\t%P\n' |
            sort -rn |
            cut -f2- |
            while IFS= read -r wallpaper; do
                printf '%s\0icon\x1f%s\n' "$wallpaper" "$wallpaper"
            done |
            rofi -dmenu -p ""
    )
fi
[ -z "$SELECTED_WALL" ] && exit 1
SELECTED_PATH="$WALLPAPER_DIR/$SELECTED_WALL"

exec "$THEME_APPLIER" "$SELECTED_PATH"
