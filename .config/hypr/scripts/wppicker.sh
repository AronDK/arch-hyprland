#!/bin/bash

# === CONFIG ===
WALLPAPER_DIR="$HOME/Pictures/wallpapers"
SYMLINK_PATH="$HOME/.config/hypr/current_wallpaper"

cd "$WALLPAPER_DIR" || exit 1

# === ICON-PREVIEW SELECTION WITH ROFI, SORTED BY NEWEST ===
SELECTED_WALL=$(
    find . -maxdepth 1 -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' \) -printf '%T@\t%P\n' |
        sort -rn |
        cut -f2- |
        while IFS= read -r wallpaper; do
            printf '%s\0icon\x1f%s\n' "$wallpaper" "$wallpaper"
        done |
        rofi -dmenu -p ""
)
[ -z "$SELECTED_WALL" ] && exit 1
SELECTED_PATH="$WALLPAPER_DIR/$SELECTED_WALL"

# === CREATE SYMLINK ===
mkdir -p "$(dirname "$SYMLINK_PATH")"
ln -sf "$SELECTED_PATH" "$SYMLINK_PATH"

# === TRANSITION WALLPAPER AND REGENERATE NON-COMPOSITOR COLORS ===
if ! awww query >/dev/null 2>&1; then
    awww-daemon >/dev/null 2>&1 &
    sleep 0.5
fi
awww img "$SELECTED_PATH" --resize crop --transition-type grow \
    --transition-pos 0.5,0.5 --transition-duration 1.1 --transition-fps 120
matugen image "$SELECTED_PATH" --source-color-index 0
