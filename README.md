# Arch Hyprland rice

A portable Hyprland setup built from several community configurations and
adapted for current Hyprland releases. Matugen supplies application colours,
`awww` handles smooth wallpaper transitions, and the default Waybar layouts
use a single horizontal row without a workspace widget.

The repository intentionally avoids host-specific monitor connector names,
display model strings, usernames, absolute home paths, and timezones.

## Highlights

- Smooth `awww` wallpaper changes without a compositor or Waybar restart
- Scrollable Rofi wallpaper picker with image icons
- Compact Waybar layouts with no persistent or empty workspace container
- Slightly translucent Kitty background without compounded window opacity
- One private tmux session per Kitty window, with Vi copy mode and `hjkl` panes
- Compact Starship prompt showing only the current directory segment
- Current Hyprland window-rule, gesture, and layout syntax
- Adaptive pointer acceleration as a hardware-neutral default

## Requirements

Core components include Hyprland, Waybar, Rofi, Kitty, Zsh, tmux, Starship,
Matugen, `awww`, SwayNC, Hyprlock, Hypridle, and a Nerd Font. The scripts also
use `jq`, `find`, `wl-clipboard`, `cliphist`, `grim`, `slurp`, `swappy`,
`playerctl`, `brightnessctl`, `pamixer`, `NetworkManager`, Blueman, and udiskie.

The shell configuration expects `zsh-autosuggestions`,
`zsh-syntax-highlighting`, `zoxide`, `fzf`, `eza`, `bat`, `ripgrep`, `fd`, and
Neovim. `wlogout`, Cava, and Yazi are optional unless their shortcuts/modules
are used.

## Installation

These files mirror paths below `$HOME`. Back up any existing dotfiles, review
the configuration, then copy or symlink the files you want into place. Ensure
the files under `.config/hypr/scripts/` remain executable.

Choose a Waybar layout and style after installation:

```sh
ln -sfn "$HOME/.config/waybar/configs/bintang default" "$HOME/.config/waybar/config"
ln -sfn "$HOME/.config/waybar/style/bintang default.css" "$HOME/.config/waybar/style.css"
```

Wallpapers are read from `~/Pictures/wallpapers`. `Super+W` opens the picker;
the selected image is linked to `~/.config/hypr/current_wallpaper` and restored
at the next login.

## Local configuration

The fallback monitor rule uses preferred modes and automatic placement:

```ini
monitor = , preferred, auto, 1
```

Replace or supplement it locally when a machine needs explicit scaling,
refresh rates, or positions. Discover connector names with `hyprctl monitors`.
Device-specific input overrides should likewise stay local; use
`hyprctl devices` to find the exact device name.

Waybar inherits the operating system timezone. Configure it independently of
these dotfiles, for example:

```sh
sudo timedatectl set-timezone YOUR_REGION/YOUR_CITY
```

## Shortcuts

| Shortcut | Action |
|---|---|
| `Super+Enter` | Open an independent Kitty terminal |
| `Super+D` | Open the application launcher |
| `Super+E` | Open Thunar |
| `Super+W` | Open the wallpaper picker |
| `Super+Shift+S` | Capture a region and open it in Swappy |
| `Super+L` | Lock the session |
| `Super+H` | Toggle Waybar |
| `Super+Alt+B` | Select a Waybar layout |
| `Super+Ctrl+B` | Select a Waybar style |
| `Super+1` … `Super+0` | Switch workspaces (not shown in Waybar) |

Inside Kitty, `Ctrl+B` is the tmux prefix:

| Shortcut | Action |
|---|---|
| `Ctrl+B`, then `h/j/k/l` | Focus an adjacent pane |
| `Ctrl+B`, then `|` | Split horizontally |
| `Ctrl+B`, then `-` | Split vertically |
| Mouse drag, then `y` | Copy the selection to the Wayland clipboard |
| `Ctrl+B`, then `y` | Start Vi selection; move and press `y` to copy |
| `Ctrl+B`, then `p` | Paste the Wayland clipboard |

## Credits

This rice incorporates ideas and configuration from multiple projects,
including scripts and Waybar settings inspired by
[JaKooLit](https://github.com/JaKooLit).

![Desktop overview](https://github.com/user-attachments/assets/cdfc60a8-9241-4633-bc23-8d80ebe9f862)

![Desktop detail](https://github.com/user-attachments/assets/66696b8b-d479-4884-b10b-1920ae8b21a2)
