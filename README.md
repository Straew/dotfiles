# 🎨 Hyprland Dotfiles

My first Hyprland rice!  Contributions and suggestions are always welcome!🫸🫷

![Hyprland Rice](2026-01-11_20-08-14.png)

## ✨ Features

- **Window Manager**: Hyprland (Wayland)
- **Panel**: Waybar with custom modules
- **Notifications**: SwayNC with blur effects
- **Terminal**: Kitty
- **Launcher**: Rofi
- **File Manager**: Thunar
- **Wallpaper**: SWWW with dynamic color generation (Matugen)
- **Theme**: Auto-generated from wallpapers using Matugen
- **Lock Screen**: Hyprlock with blur

## 📦 Quick Installation

```bash
git clone https://github.com/Straew/dotfiles.git ~/.dotfiles
cd ~/.dotfiles/scripts
chmod +x install.sh
./install.sh
```

The installer will:
- Install all required dependencies
- Backup your existing configs
- Copy all configurations
- Set up scripts and permissions

## 🔧 Manual Dependencies

If you prefer manual installation:

```bash
# Core
yay -S hyprland xdg-desktop-portal-hyprland xdg-desktop-portal-gtk
yay -S qt5-wayland qt6-wayland

# UI Components
yay -S waybar swaync kitty rofi thunar

# Wallpaper & Theming
yay -S swww matugen

# Utilities
yay -S grim slurp swappy playerctl pipewire brightnessctl
yay -S networkmanager bluez bluez-utils

# Fonts
yay -S ttf-jetbrains-mono-nerd noto-fonts noto-fonts-emoji

# Optional
yay -S mangohud cava btop fastfetch
```

## 🗑️ Uninstallation

```bash
cd ~/.dotfiles/scripts
chmod +x unistall.sh
./uninstall.sh
```

This will:
- Create a backup before removal
- Remove all dotfiles
- Optionally restore from previous backups

## 🖼️ Post Installation

### Add Wallpapers
Place your wallpapers in:
```bash
~/Pictures/Wallpapers/
```

### Generate Initial Theme
Press `Super + W` to select a wallpaper and generate the color scheme.

### Scripts
All scripts are in `~/.local/bin/`:
- `salp` - Wallpaper selector with previews
- `walp` - Same as salp but it wont let you choose a wallpaper manually (basically wallpaper rotation)
- `wlogout.sh` - Its wlogout XD
- `gamemode` - Performance mode

## ⌨️ Keybinds

### General
| Keybind | Action |
|---------|--------|
| `Super + T` | Terminal (Kitty) |
| `Super + A` | App launcher (Rofi) |
| `Super + E` | File manager (Thunar) |
| `Super + Shift + E` | Emoji picker |
| `Super + M` | Reload Hyprland |
| `Super + D` | Toggle floating |
| `Super + P` | Pseudotile |
| `Super + J` | Toggle split |
| `Alt + F4` | Close window |

### Theming & Wallpapers
| Keybind | Action |
|---------|--------|
| `Super + W` | Wallpaper selector |
| `Super + R` | Restart Waybar |
| `Super + G` | Toggle gamemode |
| `Super + L` | Lock screen |

### Screenshots
| Keybind | Action |
|---------|--------|
| `Super + Print` | Screenshot |

### Window Management
| Keybind | Action |
|---------|--------|
| `Super + ←/→/↑/↓` | Move focus |
| `Super + 1-9` | Switch workspace |
| `Super + 0` | Workspace 10 |
| `Super + Shift + 1-9` | Move to workspace |
| `Super + S` | Scratchpad |
| `Super + Alt + S` | Move to scratchpad |
| `Super + Mouse Wheel` | Cycle workspaces |
| `Super + LMB` (drag) | Move window |
| `Super + RMB` (drag) | Resize window |
| `Super + Alt + F` | Window resize menu |

### System Controls
| Keybind | Action |
|---------|--------|
| `Super + F1` | Mute/unmute audio |
| `Super + F2` | Volume down |
| `Super + F3` | Volume up |
| `Super + F4` | Mute/unmute mic |
| `Super + F7` | Brightness down |
| `Super + F8` | Brightness up |

### Media Controls
| Keybind | Action |
|---------|--------|
| `XF86AudioPlay` | Play/Pause |
| `XF86AudioNext` | Next track |
| `XF86AudioPrev` | Previous track |

## 📁 Directory Structure

```
~/.dotfiles/
├── hypr/              # Hyprland configs
├── cava/
├── fastfetch/
├── waybar/            # Waybar configs
├── kitty/             # Kitty terminal
├── rofi/              # Rofi launcher
├── swaync/            # Notification center
├── wlogout/           # Logout menu
├── colors/            # Color schemes
├── scripts/           # Utility scripts
│   ├── gamemode
│   ├── install.sh
│   ├── salp
│   └── uninstall.sh
│   ├── walp
│   ├── wlogout.sh
└── README.md
```

## 🎨 Customization

### Change Colors
Colors are auto-generated from wallpapers using Matugen. To manually adjust:
```bash
matugen image /path/to/wallpaper.png
```

### Waybar Modules
Edit `~/.config/waybar/` to add/remove modules.
Modules are split into separate files in `~/.config/waybar/modules/`.

### SwayNC Theme
Edit `~/.config/swaync/` for notification styling.
Separate CSS files in `~/.config/swaync/styles` for modular theming.

## 🐛 Troubleshooting

### Wallpaper not changing on lock screen
```bash
ls -la ~/.cache/current_wallpaper
```
Make sure the symlink points to a valid wallpaper.

### Waybar not showing icons
Install Nerd Fonts:
```bash
yay -S ttf-jetbrains-mono-nerd
```

### Blur not working
Check Hyprland version and decoration settings in `~/.config/hypr/hyprland.conf`.

### Installation issues
If you have issues with the installer, extract the zip, navigate to the directory, and run:
```bash
chmod +x scripts/install.sh
./scripts/install.sh
```

## 📝 Credits

- [Hyprland](https://hyprland.org/)
- [Claude.ai_&_youtube]✌

## 📄 License

Feel free to use and modify these dotfiles for your own setup!

---
