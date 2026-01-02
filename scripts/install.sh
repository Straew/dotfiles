#!/bin/bash
# Dotfiles Installation Script

set -e  # Exit on error

echo "╔════════════════════════════════════════╗"
echo "║     Installing Dotfiles...             ║"
echo "╚════════════════════════════════════════╝"
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if running from dotfiles directory
if [ ! -d "hypr" ] || [ ! -d "waybar" ]; then
    echo -e "${RED}Error: Please run this script from the dotfiles directory!${NC}"
    exit 1
fi

# Backup existing configs
backup_configs() {
    BACKUP_DIR=~/.config/dotfiles_backup_$(date +%Y%m%d_%H%M%S)
    echo -e "${YELLOW}Creating backup at: $BACKUP_DIR${NC}"
    mkdir -p "$BACKUP_DIR"
    
    for dir in hypr waybar kitty rofi cava fastfetch lockscreen matugen swappy swww; do
        if [ -d ~/.config/$dir ]; then
            echo "  → Backing up $dir"
            cp -r ~/.config/$dir "$BACKUP_DIR/" 2>/dev/null || true
        fi
    done
    
    # Backup scripts
    if [ -d ~/.local/bin ]; then
        mkdir -p "$BACKUP_DIR/bin"
        for script in walp theme-switch gamemode; do
            if [ -f ~/.local/bin/$script ]; then
                cp ~/.local/bin/$script "$BACKUP_DIR/bin/" 2>/dev/null || true
            fi
        done
    fi
    
    echo -e "${GREEN}✓ Backup complete!${NC}"
    echo ""
}

# Install configs
install_configs() {
    echo -e "${YELLOW}Installing configurations...${NC}"
    
    # Create config directories
    mkdir -p ~/.config/{hypr,waybar,kitty,rofi,cava,fastfetch,glava,lockscreen,matugen,swappy,swww}
    mkdir -p ~/.local/bin/
    mkdir -p ~/Pictures/{Wallpapers,Screenshots}
    
    # Copy configs
    for dir in hypr waybar kitty rofi cava fastfetch lockscreen matugen swappy swww; do
        if [ -d "$dir" ]; then
            echo "  → Installing $dir"
            cp -r "$dir"/* ~/.config/"$dir"/
        fi
    done
    
    # Copy scripts
    if [ -d "scripts" ]; then
        echo "  → Installing scripts"
        cp -r scripts/* ~/.local/bin/ 2>/dev/null || true
    fi
    
    # Make scripts executable
    chmod +x ~/.local/bin/* 2>/dev/null || true
    
    echo -e "${GREEN}✓ Configurations installed!${NC}"
    echo ""
}

# Check dependencies
check_deps() {
    echo -e "${YELLOW}Checking dependencies...${NC}"
    
    MISSING_DEPS=()
    DEPS=(hyprland waybar kitty rofi swww matugen grim slurp)
    
    for dep in "${DEPS[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            MISSING_DEPS+=("$dep")
        fi
    done
    
    if [ ${#MISSING_DEPS[@]} -ne 0 ]; then
        echo -e "${RED}Missing dependencies:${NC}"
        printf '  - %s\n' "${MISSING_DEPS[@]}"
        echo ""
        echo "Install with: yay -S ${MISSING_DEPS[*]}"
        echo ""
        read -p "Continue anyway? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    else
        echo -e "${GREEN}✓ All dependencies found!${NC}"
    fi
    echo ""
}

# Post-install steps
post_install() {
    echo -e "${YELLOW}Post-installation steps...${NC}"
    
    # Generate initial theme
    if command -v walp &> /dev/null && [ -d ~/Pictures/Wallpapers ]; then
        WALLPAPER_COUNT=$(find ~/Pictures/Wallpapers -type f \( -iname "*.jpg" -o -iname "*.png" \) 2>/dev/null | wc -l)
        if [ "$WALLPAPER_COUNT" -gt 0 ]; then
            echo "  → Generating initial theme from wallpaper"
            ~/.local/bin/walp 2>/dev/null || true
        else
            echo -e "${YELLOW}  ! No wallpapers found in ~/Pictures/Wallpapers${NC}"
            echo "    Add some wallpapers and run 'walp' to generate theme"
        fi
    fi
    
    echo -e "${GREEN}✓ Post-install complete!${NC}"
    echo ""
}

# Main installation flow
main() {
    echo "This will install dotfiles to ~/.config/"
    echo ""
    read -p "Create backup of existing configs? (Y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Nn]$ ]]; then
        backup_configs
    fi
    
    check_deps
    install_configs
    post_install
    
    echo "╔════════════════════════════════════════╗"
    echo "║     Installation Complete! 🎉          ║"
    echo "╚════════════════════════════════════════╝"
    echo ""
    echo "Next steps:"
    echo "  1. Logout and login to Hyprland"
    echo "  2. Add wallpapers to ~/Pictures/Wallpapers"
    echo "  3. Run 'walp' to generate theme"
    echo ""
    echo "Keybinds:"
    echo "  Super + T      → Terminal"
    echo "  Super + A      → App launcher"
    echo "  Super + W      → Change wallpaper/theme"
    echo "  Super + E      → File manager"
    echo "  Super + G      → Toggle gamemode"
    echo ""
    
    if [ -d "$BACKUP_DIR" ]; then
        echo "Backup saved at: $BACKUP_DIR"
        echo ""
    fi
}

main