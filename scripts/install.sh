#!/bin/bash
# Complete Dotfiles Installation Script
# Installs all dependencies, configs, and scripts for your Hyprland setup

set -e  # Exit on error

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# ASCII Art Banner
print_banner() {
    echo -e "${PURPLE}"
    cat << "EOF"
    ╔═══════════════════════════════════════════════╗
    ║                                               ║
    ║               Dotfiles                        ║
    ║               Hyprland                        ║
    ║                                               ║
    ╚═══════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
}

# Progress indicator
progress() {
    echo -e "${CYAN}[$(date +%H:%M:%S)]${NC} $1"
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

# Check if running from dotfiles directory
check_directory() {
    progress "Checking installation directory..."
    
    if [ ! -d "hypr" ] && [ ! -d ".config/hypr" ]; then
        error "Not in dotfiles directory!"
        echo "Please run this script from your dotfiles directory"
        exit 1
    fi
    
    # Handle both dotfiles/ and dotfiles/.config/ structures
    if [ -d ".config" ]; then
        CONFIG_SOURCE=".config"
    else
        CONFIG_SOURCE="."
    fi
    
    success "Found dotfiles directory"
}

# Detect package manager
detect_package_manager() {
    if command -v yay &> /dev/null; then
        PKG_MANAGER="yay"
    elif command -v paru &> /dev/null; then
        PKG_MANAGER="paru"
    elif command -v pacman &> /dev/null; then
        PKG_MANAGER="sudo pacman"
    else
        error "No supported package manager found (yay/paru/pacman)"
        exit 1
    fi
    
    success "Using package manager: $PKG_MANAGER"
}

# Install AUR helper if needed
install_aur_helper() {
    if command -v yay &> /dev/null || command -v paru &> /dev/null; then
        return
    fi
    
    progress "Installing yay (AUR helper)..."
    
    sudo pacman -S --needed --noconfirm git base-devel
    
    TEMP_DIR=$(mktemp -d)
    cd "$TEMP_DIR"
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd -
    rm -rf "$TEMP_DIR"
    
    PKG_MANAGER="yay"
    success "Installed yay"
}

# Backup existing configs
backup_configs() {
    BACKUP_DIR=~/.config/dotfiles_backup_$(date +%Y%m%d_%H%M%S)
    progress "Creating backup at: $BACKUP_DIR"
    mkdir -p "$BACKUP_DIR"
    
    local backed_up=0
    local dirs=(hypr waybar kitty rofi cava fastfetch matugen swaync wlogout colors MangoHud swww)
    
    for dir in "${dirs[@]}"; do
        if [ -d ~/.config/$dir ]; then
            cp -r ~/.config/$dir "$BACKUP_DIR/" 2>/dev/null && ((backed_up++)) || true
        fi
    done
    
    # Backup scripts
    if [ -d ~/.local/bin ]; then
        mkdir -p "$BACKUP_DIR/bin"
        cp -r ~/.local/bin/* "$BACKUP_DIR/bin/" 2>/dev/null || true
    fi
    
    if [ $backed_up -gt 0 ]; then
        success "Backed up $backed_up configurations"
        echo "  Backup location: $BACKUP_DIR"
    else
        warning "No existing configs to backup"
    fi
}

# Install dependencies
install_dependencies() {
    progress "Installing dependencies..."
    echo ""
    
    # Core packages
    local CORE_PKGS=(
        # Window Manager & Display
        hyprland
        hyprpaper
        hyprlock
        hypridle
        xdg-desktop-portal-hyprland
        
        # Wayland essentials
        wayland
        wl-clipboard
        
        # Bar & Notifications
        waybar
        swaync
        
        # Terminal & Shell
        kitty
        
        # Launchers & Menus
        rofi-wayland
        wlogout
        
        # Wallpaper & Theming
        swww
        matugen
        
        # Screenshots & Screen recording
        grim
        slurp
        swappy
        
        # Audio
        pipewire
        wireplumber
        pavucontrol
        playerctl
        
        # File Manager
        thunar
        thunar-volman
        gvfs
        
        # Fonts
        ttf-jetbrains-mono-nerd
        noto-fonts
        noto-fonts-emoji
        
        # System utilities
        polkit-kde-agent
        networkmanager
        network-manager-applet
        bluez
        bluez-utils
        blueman
        brightnessctl
        
        # Additional tools
        imagemagick
        jq
        fastfetch
    )
    
    # Optional packages (don't fail if not found)
    local OPTIONAL_PKGS=(
        cava
        btop
        eza
        bat
        fd
        ripgrep
        fzf
    )
    
    echo "Installing core packages..."
    $PKG_MANAGER -S --needed --noconfirm "${CORE_PKGS[@]}" 2>&1 | grep -v "warning: " || true
    
    echo ""
    echo "Installing optional packages..."
    for pkg in "${OPTIONAL_PKGS[@]}"; do
        $PKG_MANAGER -S --needed --noconfirm "$pkg" 2>/dev/null || warning "Skipped: $pkg"
    done
    
    echo ""
    success "Dependencies installed"
}

# Install configs
install_configs() {
    progress "Installing configurations..."
    
    # Create necessary directories
    mkdir -p ~/.config/{hypr,waybar,kitty,rofi,cava,fastfetch,matugen,swaync,wlogout,colors,MangoHud,swww}
    mkdir -p ~/.local/bin
    mkdir -p ~/Pictures/{Wallpapers,Screenshots}
    mkdir -p ~/.cache
    
    # Copy configs
    local dirs=(hypr waybar kitty rofi cava fastfetch matugen swaync wlogout colors MangoHud swww)
    local installed=0
    
    for dir in "${dirs[@]}"; do
        if [ -d "$CONFIG_SOURCE/$dir" ]; then
            cp -r "$CONFIG_SOURCE/$dir"/* ~/.config/"$dir"/ 2>/dev/null && {
                success "Installed: $dir"
                ((installed++))
            } || warning "Failed: $dir"
        fi
    done
    
    # Copy scripts
    if [ -d "$CONFIG_SOURCE/scripts" ]; then
        cp -r "$CONFIG_SOURCE/scripts"/* ~/.local/bin/ 2>/dev/null && success "Installed: scripts"
    elif [ -d "scripts" ]; then
        cp -r scripts/* ~/.local/bin/ 2>/dev/null && success "Installed: scripts"
    fi
    
    # Make scripts executable
    chmod +x ~/.local/bin/* 2>/dev/null || true
    
    echo ""
    success "Installed $installed configurations"
}

# Fix permissions
fix_permissions() {
    progress "Setting correct permissions..."
    
    # Make scripts executable
    find ~/.local/bin -type f -exec chmod +x {} \; 2>/dev/null || true
    
    # Fix config permissions
    chmod -R 755 ~/.config/hypr 2>/dev/null || true
    chmod -R 755 ~/.config/waybar 2>/dev/null || true
    
    success "Permissions fixed"
}

# Enable services
enable_services() {
    progress "Enabling system services..."
    
    # Enable NetworkManager
    if systemctl list-unit-files | grep -q NetworkManager; then
        sudo systemctl enable --now NetworkManager 2>/dev/null && success "NetworkManager enabled" || true
    fi
    
    # Enable Bluetooth
    if systemctl list-unit-files | grep -q bluetooth; then
        sudo systemctl enable --now bluetooth 2>/dev/null && success "Bluetooth enabled" || true
    fi
}

# Post-install configuration
post_install() {
    progress "Running post-installation tasks..."
    
    # Create wallpaper state file
    touch ~/.config/wallpaper_state
    
    # Initialize swww
    if command -v swww &> /dev/null; then
        swww-daemon &
        sleep 1
        pkill swww-daemon
        success "Initialized swww"
    fi
    
    # Check for wallpapers
    WALLPAPER_COUNT=$(find ~/Pictures/Wallpapers -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" \) 2>/dev/null | wc -l)
    
    if [ "$WALLPAPER_COUNT" -eq 0 ]; then
        warning "No wallpapers found in ~/Pictures/Wallpapers"
        echo "  Add wallpapers there to use the theme system"
    else
        success "Found $WALLPAPER_COUNT wallpapers"
    fi
}

# Print final instructions
print_instructions() {
    echo ""
    echo -e "${GREEN}"
    cat << "EOF"
    ╔═══════════════════════════════════════════════╗
    ║                                               ║
    ║           Installation Complete!              ║
    ║                                               ║
    ╚═══════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    
    echo -e "${CYAN}📋 Next Steps:${NC}"
    echo ""
    echo "1. Logout and login to Hyprland"
    echo "2. Add wallpapers to ~/Pictures/Wallpapers"
    echo "3. Press Super + W to change wallpaper and generate theme"
    echo ""
    
    if [ -n "$BACKUP_DIR" ] && [ -d "$BACKUP_DIR" ]; then
        echo -e "${YELLOW}💾 Backup Location:${NC}"
        echo "  $BACKUP_DIR"
        echo ""
    fi
    
    echo -e "${PURPLE}Enjoy your new setup! 🎨✨${NC}"
    echo ""
}

# Check for errors
check_installation() {
    progress "Verifying installation..."
    
    local errors=0
    
    # Check critical binaries
    local critical_bins=(hyprland waybar kitty rofi swww)
    for bin in "${critical_bins[@]}"; do
        if ! command -v "$bin" &> /dev/null; then
            error "Missing: $bin"
            ((errors++))
        fi
    done
    
    # Check critical configs
    local critical_configs=(hypr waybar kitty)
    for config in "${critical_configs[@]}"; do
        if [ ! -d ~/.config/"$config" ]; then
            error "Missing config: $config"
            ((errors++))
        fi
    done
    
    if [ $errors -eq 0 ]; then
        success "Installation verified successfully"
        return 0
    else
        warning "Found $errors issues - installation may be incomplete"
        return 1
    fi
}

# Main installation flow
main() {
    print_banner
    
    # Pre-flight checks
    check_directory
    detect_package_manager
    
    echo ""
    echo -e "${YELLOW}This will install dotfiles and all dependencies${NC}"
    echo ""
    echo "What would you like to do?"
    echo "  1) Full installation (recommended)"
    echo "  2) Install dependencies only"
    echo "  3) Install configs only (skip dependencies)"
    echo "  4) Exit"
    echo ""
    read -p "Enter choice [1-4]: " choice
    
    case $choice in
        1)
            echo ""
            read -p "Create backup of existing configs? (Y/n): " backup_choice
            if [[ ! $backup_choice =~ ^[Nn]$ ]]; then
                backup_configs
            fi
            echo ""
            
            install_aur_helper
            install_dependencies
            install_configs
            fix_permissions
            enable_services
            post_install
            check_installation
            print_instructions
            ;;
        2)
            echo ""
            install_aur_helper
            install_dependencies
            success "Dependencies installed"
            ;;
        3)
            echo ""
            read -p "Create backup of existing configs? (Y/n): " backup_choice
            if [[ ! $backup_choice =~ ^[Nn]$ ]]; then
                backup_configs
            fi
            echo ""
            
            install_configs
            fix_permissions
            post_install
            check_installation
            print_instructions
            ;;
        4)
            echo "Installation cancelled"
            exit 0
            ;;
        *)
            error "Invalid choice"
            exit 1
            ;;
    esac
}

# Run main function
main "$@"