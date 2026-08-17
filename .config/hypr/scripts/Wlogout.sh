#!/bin/zsh

if command -v wlogout >/dev/null 2>&1; then
    exec wlogout
fi

choice=$(printf 'Lock\nSuspend\nLogout\nReboot\nShutdown\n' | rofi -dmenu -p 'Power') || exit 0
case "$choice" in
    Lock) hyprlock ;;
    Suspend) systemctl suspend ;;
    Logout) hyprctl dispatch exit ;;
    Reboot) systemctl reboot ;;
    Shutdown) systemctl poweroff ;;
esac
