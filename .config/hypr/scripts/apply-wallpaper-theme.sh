#!/usr/bin/env bash
set -euo pipefail

# Single wallpaper-to-Material-3 pipeline. Any picker, randomizer, key binding,
# or startup hook can call this helper without knowing which applications use
# the generated palette.
scheme_type=${MATUGEN_SCHEME_TYPE:-scheme-vibrant}
color_strategy=${MATUGEN_COLOR_STRATEGY:-dominant}
current_link="$HOME/.config/hypr/current_wallpaper"
transition=true

if [[ ${1:-} == --no-transition ]]; then
    transition=false
    shift
fi

image=${1:-$current_link}
resolved_image=$(readlink -f -- "$image" 2>/dev/null || true)
if [[ -z $resolved_image || ! -f $resolved_image ]]; then
    printf 'Wallpaper not found: %s\n' "$image" >&2
    exit 1
fi

previous_image=$(readlink -f -- "$current_link" 2>/dev/null || true)

start_awww_daemon() {
    nohup awww-daemon --quiet >/dev/null 2>&1 </dev/null &
    for _ in {1..30}; do
        awww query >/dev/null 2>&1 && return 0
        sleep 0.1
    done
    return 1
}

restart_awww_daemon() {
    awww kill >/dev/null 2>&1 || pkill -x awww-daemon 2>/dev/null || true
    for _ in {1..20}; do
        pgrep -x awww-daemon >/dev/null 2>&1 || break
        sleep 0.1
    done
    start_awww_daemon
}

daemon_started=false
if ! awww query >/dev/null 2>&1; then
    start_awww_daemon
    daemon_started=true
fi

# A freshly started daemon has black, empty output surfaces. Paint the previous
# wallpaper first so even its first animated change has a real image beneath
# the expanding circle.
if $daemon_started && $transition && [[ -n $previous_image && -f $previous_image ]]; then
    awww img "$previous_image" --resize crop --transition-type none
fi

mkdir -p "$(dirname "$current_link")"
if [[ $image != "$current_link" ]]; then
    ln -sfn -- "$resolved_image" "$current_link"
fi

# If Hyprpaper happens to be active after a restored session, update it before
# Awww starts so it cannot repaint over the visible transition afterward.
if pgrep -x hyprpaper >/dev/null 2>&1; then
    hyprctl hyprpaper wallpaper ",$current_link,cover" >/dev/null 2>&1 || true
fi

show_wallpaper() {
    if $transition; then
        awww img "$resolved_image" --resize crop --transition-type grow \
            --transition-pos 0.5,0.5 --transition-duration 1.1 --transition-fps 120
    else
        awww img "$resolved_image" --resize crop --transition-type none
    fi
}

# Recover once if Awww lost its Wayland socket or output buffers. Re-priming
# with the old image preserves the circle instead of exposing a black surface.
if ! show_wallpaper; then
    restart_awww_daemon
    if $transition && [[ -n $previous_image && -f $previous_image ]]; then
        awww img "$previous_image" --resize crop --transition-type none
    fi
    show_wallpaper
fi

# Dominant is the wallpaper-agnostic default: it represents the visual field
# instead of allowing a small, highly saturated detail to control the shell.
# The strategy stays configurable for callers that deliberately want a more
# contrasting accent.
case $color_strategy in
    dominant)
        color_arguments=(--source-color-index "${MATUGEN_SOURCE_COLOR_INDEX:-0}")
        ;;
    saturation|darkness|lightness|less-saturation|value|closest-to-fallback)
        color_arguments=(--prefer "$color_strategy")
        ;;
    *)
        printf 'Unsupported MATUGEN_COLOR_STRATEGY: %s\n' "$color_strategy" >&2
        exit 2
        ;;
esac

matugen image "$resolved_image" \
    --type "$scheme_type" \
    "${color_arguments[@]}" \
    --quiet

# Each consumer reads semantic roles from Matugen's generated files.
pkill -SIGUSR2 -x waybar 2>/dev/null || true
swaync-client --reload-css >/dev/null 2>&1 || true

# A full Hyprland reload reapplies monitor modes and can blank the outputs in
# the middle of Awww's circle. Only the two live compositor colors need an
# immediate update; lock-screen colors are read when Hyprlock starts.
active_border=$(sed -n 's/^\$outline = //p' "$HOME/.config/hypr/colors.conf" | head -n 1)
inactive_border=$(sed -n 's/^\$outline_variant = //p' "$HOME/.config/hypr/colors.conf" | head -n 1)
[[ -n $active_border ]] && hyprctl keyword general:col.active_border "$active_border" >/dev/null
[[ -n $inactive_border ]] && hyprctl keyword general:col.inactive_border "$inactive_border" >/dev/null
