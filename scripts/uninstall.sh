#!/bin/bash
# Dotfiles Uninstallation Script

set -e  # Exit on error

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Progress indicator
progress() {
    echo -e "${BLUE}[$(date +%H:%M:%S)]${NC} $1"
}

# Success message
success() {
    echo -e "${GREEN}✓${NC} $1"
}

# Warning message
warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

# Error message
error() {
    echo -e "${RED}✗${NC} $1"
}

# ASCII Art Banner
print_banner() {
    echo -e "${RED}"
    cat << "EOF"
    ╔═══════════════════════════════════════════════╗
    ║                                               ║
    ║        🗑️  Dotfiles Uninstaller 🗑️            ║
    ║                                               ║
    ╚═══════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
}

# List what will be removed
show_removal_list() {
    echo -e "${YELLOW}The following will be removed:${NC}"
    echo ""
    
    local configs=(hypr waybar kitty rofi cava fastfetch matugen swaync wlogout colors MangoHud swww)
    local found=0
    
    for dir in "${configs[@]}"; do
        if [ -d ~/.config/"$dir" ]; then
            echo "  ✗ ~/.config/$dir"
            ((found++))
        fi
    done
    
    # Check scripts
    if [ -d ~/.local/bin ]; then
        local scripts=($(find ~/.local/bin -type f -name "*wallpaper*" -o -name "*theme*" -o -name "salp" -o -name "lockscreen" 2>/dev/null))
        if [ ${#scripts[@]} -gt 0 ]; then
            echo "  ✗ Scripts in ~/.local/bin"
            ((found++))
        fi
    fi
    
    # Check cache files
    if [ -f ~/.cache/current_wallpaper ] || [ -f ~/.config/wallpaper_state ]; then
        echo "  ✗ Wallpaper cache files"
    fi
    
    echo ""
    
    if [ $found -eq 0 ]; then
        warning "No dotfiles found to remove"
        exit 0
    fi
}

# Create backup before removing
backup_before_removal() {
    BACKUP_DIR=~/.config/dotfiles_removed_$(date +%Y%m%d_%H%M%S)
    progress "Creating backup at: $BACKUP_DIR"
    mkdir -p "$BACKUP_DIR"
    
    local backed_up=0
    local dirs=(hypr waybar kitty rofi cava fastfetch matugen swaync wlogout colors MangoHud swww)
    
    for dir in "${dirs[@]}"; do
        if [ -d ~/.config/"$dir" ]; then
            cp -r ~/.config/"$dir" "$BACKUP_DIR/" 2>/dev/null && {
                ((backed_up++))
            } || true
        fi
    done
    
    # Backup scripts
    if [ -d ~/.local/bin ]; then
        mkdir -p "$BACKUP_DIR/bin"
        cp ~/.local/bin/* "$BACKUP_DIR/bin/" 2>/dev/null || true
    fi
    
    # Backup wallpaper state
    if [ -f ~/.config/wallpaper_state ]; then
        cp ~/.config/wallpaper_state "$BACKUP_DIR/" 2>/dev/null || true
    fi
    
    if [ $backed_up -gt 0 ]; then
        success "Backed up $backed_up configurations"
        echo "  Location: $BACKUP_DIR"
    fi
}

# Remove configurations
remove_configs() {
    progress "Removing configurations..."
    
    local removed=0
    local dirs=(hypr waybar kitty rofi cava fastfetch matugen swaync wlogout colors MangoHud swww)
    
    for dir in "${dirs[@]}"; do
        if [ -d ~/.config/"$dir" ]; then
            rm -rf ~/.config/"$dir" && {
                success "Removed: ~/.config/$dir"
                ((removed++))
            } || error "Failed to remove: ~/.config/$dir"
        fi
    done
    
    echo ""
    progress "Removing scripts..."
    
    # Remove specific scripts (be careful not to remove everything)
    local scripts=(change-wallpaper salp lockscreen walp theme-switch)
    for script in "${scripts[@]}"; do
        if [ -f ~/.local/bin/"$script" ]; then
            rm -f ~/.local/bin/"$script" && success "Removed: $script"
        fi
    done
    
    echo ""
    progress "Removing cache files..."
    
    # Remove cache files
    [ -f ~/.cache/current_wallpaper ] && rm -f ~/.cache/current_wallpaper && success "Removed wallpaper cache"
    [ -f ~/.config/wallpaper_state ] && rm -f ~/.config/wallpaper_state && success "Removed wallpaper state"
    [ -d ~/.cache/wallpaper-thumbnails ] && rm -rf ~/.cache/wallpaper-thumbnails && success "Removed thumbnails"
    
    echo ""
    success "Removed $removed configurations"
}

# List available backups
list_backups() {
    local backups=(~/.config/dotfiles_backup_* ~/.config/dotfiles_removed_*)
    local valid_backups=()
    
    for backup in "${backups[@]}"; do
        if [ -d "$backup" ]; then
            valid_backups+=("$backup")
        fi
    done
    
    if [ ${#valid_backups[@]} -eq 0 ]; then
        return 1
    fi
    
    echo "${valid_backups[@]}"
    return 0
}

# Restore from backup
restore_from_backup() {
    progress "Checking for backups..."
    
    local backups_list=$(list_backups)
    if [ $? -ne 0 ]; then
        warning "No backups found"
        return
    fi
    
    echo ""
    echo "Found backups:"
    local backups=($backups_list)
    local i=1
    for backup in "${backups[@]}"; do
        echo "  $i) $(basename "$backup")"
        ((i++))
    done
    echo "  0) Skip restore"
    echo ""
    
    read -p "Select backup to restore [0-$((${#backups[@]})]: " choice
    
    if [ "$choice" -eq 0 ] || [ -z "$choice" ]; then
        echo "Skipping restore"
        return
    fi
    
    if [ "$choice" -ge 1 ] && [ "$choice" -le "${#backups[@]}" ]; then
        local selected_backup="${backups[$((choice-1))]}"
        progress "Restoring from: $(basename "$selected_backup")"
        
        local restored=0
        for dir in "$selected_backup"/*; do
            if [ -d "$dir" ] && [ "$(basename "$dir")" != "bin" ]; then
                local dirname=$(basename "$dir")
                cp -r "$dir" ~/.config/ && {
                    success "Restored: $dirname"
                    ((restored++))
                }
            fi
        done
        
        # Restore scripts
        if [ -d "$selected_backup/bin" ]; then
            cp -r "$selected_backup/bin"/* ~/.local/bin/ 2>/dev/null && {
                chmod +x ~/.local/bin/* 2>/dev/null
                success "Restored: scripts"
            }
        fi
        
        echo ""
        success "Restored $restored items from backup"
    else
        error "Invalid choice"
    fi
}

# Main uninstall flow
main() {
    print_banner
    
    show_removal_list
    
    echo -e "${RED}⚠ WARNING: This will remove all dotfiles configurations!${NC}"
    echo ""
    read -p "Are you sure you want to continue? (yes/NO): " confirm
    
    if [[ ! $confirm =~ ^[Yy][Ee][Ss]$ ]]; then
        echo "Uninstall cancelled"
        exit 0
    fi
    
    echo ""
    read -p "Create backup before removal? (Y/n): " backup_choice
    if [[ ! $backup_choice =~ ^[Nn]$ ]]; then
        backup_before_removal
    fi
    
    echo ""
    remove_configs
    
    echo ""
    read -p "Would you like to restore from a previous backup? (y/N): " restore_choice
    if [[ $restore_choice =~ ^[Yy]$ ]]; then
        echo ""
        restore_from_backup
    fi
    
    echo ""
    echo -e "${GREEN}"
    cat << "EOF"
    ╔═══════════════════════════════════════════════╗
    ║                                               ║
    ║        ✓ Uninstall Complete                   ║
    ║                                               ║
    ╚═══════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    
    if [ -n "$BACKUP_DIR" ] && [ -d "$BACKUP_DIR" ]; then
        echo -e "${YELLOW}💾 Final backup saved at:${NC}"
        echo "  $BACKUP_DIR"
        echo ""
    fi
    
    echo "To reinstall, run: ./install.sh"
    echo ""
    echo -e "${YELLOW}NOTE:${NC} Logout/login or restart Hyprland for changes to take effect"
    echo ""
}

main "$@"