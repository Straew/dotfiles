#!/bin/bash
# Dotfiles Uninstallation Script

set -e  # Exit on error

echo "╔════════════════════════════════════════╗"
echo "║     Uninstalling Dotfiles...           ║"
echo "╚════════════════════════════════════════╝"
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Warning
echo -e "${RED}WARNING: This will remove all dotfiles configurations!${NC}"
echo ""
echo "The following will be removed:"
echo "  - ~/.config/hypr"
echo "  - ~/.config/waybar"
echo "  - ~/.config/kitty"
echo "  - ~/.config/rofi"
echo "  - ~/.config/cava"
echo "  - ~/.config/fastfetch"
echo "  - ~/.config/lockscreen"
echo "  - ~/.config/matugen"
echo "  - ~/.config/swappy"
echo "  - ~/.config/swww"
echo "  - ~/.local/bin/walp"
echo "  - ~/.local/bin/gamemode"
echo ""

read -p "Are you sure you want to continue? (yes/NO): " -r
echo
if [[ ! $REPLY =~ ^[Yy][Ee][Ss]$ ]]; then
    echo "Uninstall cancelled."
    exit 0
fi

# Create backup before removing
backup_before_removal() {
    BACKUP_DIR=~/.config/dotfiles_removed_$(date +%Y%m%d_%H%M%S)
    echo -e "${YELLOW}Creating final backup at: $BACKUP_DIR${NC}"
    mkdir -p "$BACKUP_DIR"
    
    for dir in hypr waybar kitty rofi cava fastfetch lockscreen matugen swappy swww; do
        if [ -d ~/.config/$dir ]; then
            echo "  → Backing up $dir"
            cp -r ~/.config/$dir "$BACKUP_DIR/" 2>/dev/null || true
        fi
    done
    
    # Backup scripts
    mkdir -p "$BACKUP_DIR/bin"
    for script in walp theme-switch gamemode; do
        if [ -f ~/.local/bin/$script ]; then
            cp ~/.local/bin/$script "$BACKUP_DIR/bin/" 2>/dev/null || true
        fi
    done
    
    echo -e "${GREEN}✓ Backup created at: $BACKUP_DIR${NC}"
    echo ""
}

# Remove configurations
remove_configs() {
    echo -e "${YELLOW}Removing configurations...${NC}"
    
    # Remove config directories
    for dir in hypr waybar kitty rofi cava fastfetch lockscreen matugen swappy swww; do
        if [ -d ~/.config/$dir ]; then
            echo "  → Removing ~/.config/$dir"
            rm -rf ~/.config/"$dir"
        fi
    done
    
    # Remove scripts
    for script in walp theme-switch gamemode; do
        if [ -f ~/.local/bin/$script ]; then
            echo "  → Removing ~/.local/bin/$script"
            rm -f ~/.local/bin/"$script"
        fi
    done
    
    # Remove cache files
    if [ -f ~/.cache/current_wallpaper ]; then
        rm -f ~/.cache/current_wallpaper
    fi
    
    if [ -f ~/.config/wallpaper_state ]; then
        rm -f ~/.config/wallpaper_state
    fi
    
    if [ -f /tmp/gamemode_active ]; then
        rm -f /tmp/gamemode_active
    fi
    
    echo -e "${GREEN}✓ Configurations removed!${NC}"
    echo ""
}

# Restore check
check_restore() {
    echo -e "${YELLOW}Checking for previous backups...${NC}"
    
    BACKUPS=(~/.config/dotfiles_backup_*)
    if [ -d "${BACKUPS[0]}" ]; then
        echo ""
        echo "Found previous backups:"
        for backup in "${BACKUPS[@]}"; do
            if [ -d "$backup" ]; then
                echo "  - $(basename "$backup")"
            fi
        done
        echo ""
        read -p "Do you want to restore from a backup? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo ""
            echo "Available backups:"
            select backup in "${BACKUPS[@]}" "Cancel"; do
                if [ "$backup" = "Cancel" ]; then
                    echo "Restore cancelled."
                    break
                elif [ -d "$backup" ]; then
                    echo "Restoring from: $backup"
                    
                    for dir in hypr waybar kitty rofi cava fastfetch lockscreen matugen swappy swww; do
                        if [ -d "$backup/$dir" ]; then
                            echo "  → Restoring $dir"
                            cp -r "$backup/$dir" ~/.config/
                        fi
                    done
                    
                    if [ -d "$backup/bin" ]; then
                        echo "  → Restoring scripts"
                        cp -r "$backup/bin"/* ~/.local/bin/ 2>/dev/null || true
                        chmod +x ~/.local/bin/* 2>/dev/null || true
                    fi
                    
                    echo -e "${GREEN}✓ Restore complete!${NC}"
                    break
                fi
            done
        fi
    else
        echo "  No previous backups found"
    fi
    echo ""
}

# Main uninstall flow
main() {
    read -p "Create backup before removal? (Y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Nn]$ ]]; then
        backup_before_removal
    fi
    
    remove_configs
    check_restore
    
    echo "╔════════════════════════════════════════╗"
    echo "║     Uninstall Complete!                ║"
    echo "╚════════════════════════════════════════╝"
    echo ""
    echo "Dotfiles have been removed."
    echo ""
    
    if [ -d "$BACKUP_DIR" ]; then
        echo "Final backup saved at: $BACKUP_DIR"
        echo "You can restore manually from this backup if needed."
        echo ""
    fi
    
    echo "To reinstall, run: ./install.sh"
    echo ""
    echo "NOTE: You may need to logout/login or restart Hyprland"
    echo "      for all changes to take effect."
    echo ""
}

main