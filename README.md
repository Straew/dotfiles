My First ever Hyprland ricing so its kinda bad ig, it will imporve after some more commits 

Installation:
```bash
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
chmod +x install.sh
./install.sh
```
### Dependencies
```bash
yay -S hyprland 
yay -S xdg-desktop-portal-hyprland  
yay -S xdg-desktop-portal-gtk       
yay -S qt5-wayland qt6-wayland      

yay -S waybar           
yay -S dunst          

yay -S kitty 
yay -S rofi
yay -S swww  
yay -S matugen
yay -S grim
yay -S thunar
yay -S playerctl 
yay -S pipewire  
yay -S mangohud 

yay -S ttf-jetbrains-mono-nerd
```
#To Uninstall js run the unistall.sh instead of the install.sh script 
if there are any issues with the installation js install zip extract it open in the terminal and run chmod and install.sh it should work

### Post Installation 
-> To use the wallpapers you need to add it to "~/Pictures/Wallpapers" 
 
### Keybinds

### General
| Keybind | Action |
|---------|--------|
| `Super + T` | Open terminal |
| `Super + A` | App launcher (Rofi) |
| `Super + E` | File manager (Thunar) |
| `Super + M` | Reload Hyprland config |
| `Super + D` | Toggle floating mode |
| `Super + P` | Pseudotile (dwindle) |
| `Super + J` | Toggle split (dwindle) |
| `Alt + F4` | Close active window |

### Theming & Visuals
| Keybind | Action |
|---------|--------|
| `Super + W` | Change wallpaper/theme |
| `Super + R` | Restart Waybar |
| `Super + G` | Toggle performance mode |
| `Super + L` | Lock screen |

### Screenshots
| Keybind | Action |
|---------|--------|
| `Super + Print` | Take screenshot |

### Window Management
| Keybind | Action |
|---------|--------|
| `Super + ←/→/↑/↓` | Move focus |
| `Super + 1-9` | Switch to workspace 1-9 |
| `Super + 0` | Switch to workspace 10 |
| `Super + Shift + 1-9` | Move window to workspace 1-9 |
| `Super + S` | Toggle scratchpad |
| `Super + Alt + S` | Move to scratchpad |
| `Super + Mouse Wheel` | Cycle workspaces |
| `Super + LMB` (drag) | Move window |
| `Super + RMB` (drag) | Resize window |

### System Controls
| Keybind | Action |
|---------|--------|
| `F1` | Mute audio |
| `F2` | Volume down |
| `F3` | Volume up |
| `F4` | Mute microphone |
| `F7` | Brightness down |
| `F8` | Brightness up |
