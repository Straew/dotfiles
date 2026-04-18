#!/bin/bash
# Combined Dotfiles Installation Script
# Supports Hyprland and Niri — choose your compositor at install time

set -e

# ─── Colors ───────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# ─── Logging ──────────────────────────────────────────────────────────────────
progress() { echo -e "${CYAN}[$(date +%H:%M:%S)]${NC} $1"; }
success()  { echo -e "${GREEN}✓${NC} $1"; }
warning()  { echo -e "${YELLOW}⚠${NC} $1"; }
error()    { echo -e "${RED}✗${NC} $1"; }

# ─── Banner ───────────────────────────────────────────────────────────────────
print_banner() {
    echo -e "${PURPLE}"
    cat << "EOF"
    ╔═══════════════════════════════════════════════╗
    ║                                               ║
    ║              Dotfiles Installer               ║
    ║           Hyprland  ·  Niri  ·  Shared         ║
    ║                                               ║
    ╚═══════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
}

# ─── Directory Check ──────────────────────────────────────────────────────────
check_directory() {
    progress "Checking installation directory..."

    if [ ! -d ".config" ]; then
        error "Could not find .config/ in the current directory."
        echo "  Please run this script from the root of the dotfiles repo."
        exit 1
    fi

    CONFIG_SOURCE=".config"
    success "Found dotfiles directory"
}

# ─── WM Selection ─────────────────────────────────────────────────────────────
select_wm() {
    echo ""
    echo -e "${CYAN}Which compositor would you like to install?${NC}"
    echo "  1) Hyprland"
    echo "  2) Niri"
    echo "  3) Both"
    echo ""
    read -p "Enter choice [1-3]: " wm_choice

    case $wm_choice in
        1) SELECTED_WM="hyprland" ;;
        2) SELECTED_WM="niri"     ;;
        3) SELECTED_WM="both"     ;;
        *)
            error "Invalid choice"
            exit 1
            ;;
    esac

    echo ""
    success "Selected: $SELECTED_WM"
}

# ─── Package Manager ──────────────────────────────────────────────────────────
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

install_aur_helper() {
    if command -v yay &> /dev/null || command -v paru &> /dev/null; then
        return
    fi

    progress "Installing yay (AUR helper)..."
    sudo pacman -S --needed --noconfirm git base-devel

    TEMP_DIR=$(mktemp -d)
    git clone https://aur.archlinux.org/yay.git "$TEMP_DIR/yay"
    pushd "$TEMP_DIR/yay" > /dev/null
    makepkg -si --noconfirm
    popd > /dev/null
    rm -rf "$TEMP_DIR"

    PKG_MANAGER="yay"
    success "Installed yay"
}

# ─── Package Lists ────────────────────────────────────────────────────────────

# Packages shared by both compositors
SHARED_PKGS=(
    # Wayland base
    wayland
    xdg-desktop-portal
    # Status bar & notifications
    waybar
    swaync
    # Terminal & shell
    kitty
    zsh
    # Launcher & menus
    rofi-wayland
    wlogout
    # Wallpaper & theming
    python-pywal
    imagemagick
    # Color picker
    hyprpicker
    # Screenshots
    grim
    slurp
    swappy
    # Media
    ffmpeg
    mpv
    # Audio
    pipewire
    wireplumber
    pavucontrol
    playerctl
    # File manager
    thunar
    thunar-volman
    gvfs
    # Fonts
    ttf-jetbrains-mono-nerd
    noto-fonts
    noto-fonts-emoji
    # System
    polkit-kde-agent
    networkmanager
    network-manager-applet
    bluez
    bluez-utils
    blueman
    brightnessctl
    # Python / image
    python
    python-pip
    python-pillow
    # Utilities
    jq
    fastfetch
)

HYPRLAND_PKGS=(
    hyprland
    hyprlock
    xdg-desktop-portal-hyprland
    awww
)

HYPRLAND_AUR_PKGS=(
    pyprland
)

NIRI_PKGS=(
    niri
    xdg-desktop-portal-gnome   # works well with niri; swap if you prefer gtk/wlr
    awww                        # wallpaper daemon
    xwayland-satellite          # XWayland support for niri
)

OPTIONAL_PKGS=(
    cava
    btop
    eza
    bat
    fd
    ripgrep
    fzf
)

# ─── Install Programs ─────────────────────────────────────────────────────────
install_programs() {
    progress "Installing shared packages..."
    $PKG_MANAGER -S --needed --noconfirm "${SHARED_PKGS[@]}" 2>&1 | grep -v "^warning: " || true

    if [[ "$SELECTED_WM" == "hyprland" || "$SELECTED_WM" == "both" ]]; then
        echo ""
        progress "Installing Hyprland packages..."
        $PKG_MANAGER -S --needed --noconfirm "${HYPRLAND_PKGS[@]}" 2>&1 | grep -v "^warning: " || true

        echo ""
        progress "Installing Hyprland AUR packages..."
        for pkg in "${HYPRLAND_AUR_PKGS[@]}"; do
            if [[ "$PKG_MANAGER" == "yay" || "$PKG_MANAGER" == "paru" ]]; then
                $PKG_MANAGER -S --needed --noconfirm "$pkg" 2>/dev/null && success "Installed: $pkg" || warning "Skipped: $pkg"
            else
                warning "AUR helper needed for: $pkg"
            fi
        done
    fi

    if [[ "$SELECTED_WM" == "niri" || "$SELECTED_WM" == "both" ]]; then
        echo ""
        progress "Installing Niri packages..."
        $PKG_MANAGER -S --needed --noconfirm "${NIRI_PKGS[@]}" 2>&1 | grep -v "^warning: " || true
    fi

    echo ""
    progress "Installing optional packages..."
    for pkg in "${OPTIONAL_PKGS[@]}"; do
        $PKG_MANAGER -S --needed --noconfirm "$pkg" 2>/dev/null && success "Installed: $pkg" || warning "Skipped: $pkg"
    done

    echo ""
    success "All packages installed"
}

# ─── Backup ───────────────────────────────────────────────────────────────────
backup_configs() {
    BACKUP_DIR=~/.config/dotfiles_backup_$(date +%Y%m%d_%H%M%S)
    progress "Creating backup at: $BACKUP_DIR"
    mkdir -p "$BACKUP_DIR"

    local backed_up=0
    local dirs=(hypr niri waybar kitty rofi cava fastfetch swaync wlogout colors MangoHud awww pyprland wal)

    for dir in "${dirs[@]}"; do
        if [ -d ~/.config/"$dir" ]; then
            cp -r ~/.config/"$dir" "$BACKUP_DIR/" && ((backed_up++)) || true
        fi
    done

    if [ -d ~/.local/bin ]; then
        mkdir -p "$BACKUP_DIR/bin"
        cp -r ~/.local/bin/. "$BACKUP_DIR/bin/" 2>/dev/null || true
    fi

    if [ "$backed_up" -gt 0 ]; then
        success "Backed up $backed_up existing config directories"
        echo "  → $BACKUP_DIR"
    else
        warning "No existing configs found to back up"
    fi
}

# ─── Install Configs ──────────────────────────────────────────────────────────

# Safe copy: copies contents of $1 into $2, reports result
copy_config() {
    local src="$1"   # e.g.  .config/waybar
    local dest="$2"  # e.g.  ~/.config/waybar
    local name
    name="$(basename "$src")"

    if [ ! -e "$src" ]; then
        warning "Source not found, skipping: $src"
        return 1
    fi

    mkdir -p "$dest"

    if [ -d "$src" ]; then
        # Copy directory contents — works even when the dir is empty
        cp -rT "$src" "$dest" && success "Installed: $name" || { warning "Failed: $name"; return 1; }
    else
        cp "$src" "$dest/" && success "Installed: $name" || { warning "Failed: $name"; return 1; }
    fi
}

install_configs() {
    progress "Installing configurations..."

    # Directories we always need
    mkdir -p ~/.local/bin
    mkdir -p ~/Pictures/{Wallpapers,Screenshots}
    mkdir -p ~/.cache/wal

    # ── Shared configs (both WMs use these) ──────────────────────────────────
    local SHARED_CONFIGS=(waybar kitty rofi cava fastfetch swaync wlogout colors MangoHud wal)
    local installed=0

    for dir in "${SHARED_CONFIGS[@]}"; do
        src="$CONFIG_SOURCE/$dir"
        dest=~/.config/"$dir"
        copy_config "$src" "$dest" && ((installed++)) || true
    done

    # ── WM-specific configs ───────────────────────────────────────────────────
    if [[ "$SELECTED_WM" == "hyprland" || "$SELECTED_WM" == "both" ]]; then
        copy_config "$CONFIG_SOURCE/hypr"     ~/.config/hypr     && ((installed++)) || true
        copy_config "$CONFIG_SOURCE/awww"     ~/.config/awww     && ((installed++)) || true
        copy_config "$CONFIG_SOURCE/pyprland" ~/.config/pyprland && ((installed++)) || true
    fi

    if [[ "$SELECTED_WM" == "niri" || "$SELECTED_WM" == "both" ]]; then
        copy_config "$CONFIG_SOURCE/niri" ~/.config/niri && ((installed++)) || true
    fi

    # ── Scripts ───────────────────────────────────────────────────────────────
    for scripts_dir in "$CONFIG_SOURCE/scripts" "scripts"; do
        if [ -d "$scripts_dir" ]; then
            cp -rT "$scripts_dir" ~/.local/bin/ && success "Installed: scripts" || warning "Failed to copy scripts"
            break
        fi
    done

    echo ""
    success "Installed $installed config directories"
}

# ─── Permissions ─────────────────────────────────────────────────────────────
fix_permissions() {
    progress "Setting permissions..."

    find ~/.local/bin -type f -exec chmod +x {} \; 2>/dev/null || true
    chmod -R 755 ~/.config/hypr      2>/dev/null || true
    chmod -R 755 ~/.config/niri      2>/dev/null || true
    chmod -R 755 ~/.config/waybar    2>/dev/null || true
    chmod -R 755 ~/.config/pyprland  2>/dev/null || true

    success "Permissions set"
}

# ─── Services ─────────────────────────────────────────────────────────────────
enable_services() {
    progress "Enabling system services..."

    systemctl list-unit-files | grep -q NetworkManager && \
        sudo systemctl enable --now NetworkManager 2>/dev/null && success "NetworkManager enabled" || true

    systemctl list-unit-files | grep -q bluetooth && \
        sudo systemctl enable --now bluetooth 2>/dev/null && success "Bluetooth enabled" || true
}

# ─── Post-install ─────────────────────────────────────────────────────────────
post_install() {
    progress "Running post-install tasks..."

    touch ~/.config/wallpaper_state

    # Hyprland: initialise awww
    if [[ "$SELECTED_WM" == "hyprland" || "$SELECTED_WM" == "both" ]]; then
        if command -v awww &> /dev/null; then
            awww-daemon & sleep 1; pkill awww-daemon 2>/dev/null || true
            success "Initialised awww"
        fi
    fi

    # Niri: initialise awww
    if [[ "$SELECTED_WM" == "niri" || "$SELECTED_WM" == "both" ]]; then
        if command -v awww-daemon &> /dev/null; then
            awww-daemon &
            sleep 1
            pkill awww-daemon 2>/dev/null || true
            success "Initialised awww"
        fi
    fi

    # pywal: generate initial theme from first wallpaper found
    WALLPAPER_COUNT=$(find ~/Pictures/Wallpapers -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" \) 2>/dev/null | wc -l)

    if [ "$WALLPAPER_COUNT" -eq 0 ]; then
        warning "No wallpapers found in ~/Pictures/Wallpapers"
        echo "  Add some images there to use the pywal theme system"
    else
        success "Found $WALLPAPER_COUNT wallpaper(s)"
        if command -v wal &> /dev/null; then
            FIRST_WALL=$(find ~/Pictures/Wallpapers -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" \) 2>/dev/null | head -n 1)
            [ -n "$FIRST_WALL" ] && wal -i "$FIRST_WALL" -n -q 2>/dev/null && success "Generated initial pywal theme" || true
        fi
    fi
}

# ─── Verification ─────────────────────────────────────────────────────────────
check_installation() {
    progress "Verifying installation..."
    local errors=0

    # Binaries always expected
    local always_bins=(waybar kitty rofi wal)
    for bin in "${always_bins[@]}"; do
        command -v "$bin" &> /dev/null || { error "Missing binary: $bin"; ((errors++)); }
    done

    # WM-specific binaries
    if [[ "$SELECTED_WM" == "hyprland" || "$SELECTED_WM" == "both" ]]; then
        for bin in hyprland awww; do
            command -v "$bin" &> /dev/null || { error "Missing binary: $bin"; ((errors++)); }
        done
        command -v pypr &> /dev/null || warning "pyprland not found — some features may not work"
    fi

    if [[ "$SELECTED_WM" == "niri" || "$SELECTED_WM" == "both" ]]; then
        command -v niri &> /dev/null || { error "Missing binary: niri"; ((errors++)); }
        command -v awww &> /dev/null || warning "awww not found — wallpaper daemon missing"
    fi

    # Config directories always expected
    for config in waybar kitty; do
        [ -d ~/.config/"$config" ] || { error "Missing config dir: $config"; ((errors++)); }
    done

    if [ "$errors" -eq 0 ]; then
        success "Installation verified"
        return 0
    else
        warning "$errors issue(s) found — installation may be incomplete"
        return 1
    fi
}

# ─── Final Instructions ───────────────────────────────────────────────────────
print_instructions() {
    echo ""
    echo -e "${GREEN}"
    cat << "EOF"
    ╔═══════════════════════════════════════════════╗
    ║                                               ║
    ║           Installation Complete! 🎉           ║
    ║                                               ║
    ╚═══════════════════════════════════════════════╝
EOF
    echo -e "${NC}"

    echo -e "${CYAN}📋 Next Steps:${NC}"
    echo ""
    echo "  1. Log out and log in to your chosen compositor"
    echo "  2. Add wallpapers to ~/Pictures/Wallpapers"

    if [[ "$SELECTED_WM" == "hyprland" || "$SELECTED_WM" == "both" ]]; then
        echo ""
        echo -e "${PURPLE}  Hyprland:${NC}"
        echo "    · Super + W  → change wallpaper & generate pywal theme"
        echo "    · Pyprland scratchpads and other features are active"
    fi

    if [[ "$SELECTED_WM" == "niri" || "$SELECTED_WM" == "both" ]]; then
        echo ""
        echo -e "${BLUE}  Niri:${NC}"
        echo "    · Super + W  → change wallpaper (awww + pywal)"
        echo "    · Super + Return → Kitty"
        echo "    · Super + D      → Rofi launcher"
    fi

    if [ -n "${BACKUP_DIR:-}" ] && [ -d "$BACKUP_DIR" ]; then
        echo ""
        echo -e "${YELLOW}  💾 Backup saved to:${NC} $BACKUP_DIR"
    fi

    echo ""
    echo -e "${PURPLE}  Enjoy your setup! 🎨✨${NC}"
    echo ""
}

# ─── Main ─────────────────────────────────────────────────────────────────────
main() {
    print_banner
    check_directory
    detect_package_manager
    select_wm

    echo ""
    echo -e "${YELLOW}  Installation target: ${CYAN}$SELECTED_WM${NC}"
    echo ""
    echo "  What would you like to do?"
    echo "    1) Full installation  (packages + configs)  [recommended]"
    echo "    2) Packages only"
    echo "    3) Configs only       (skip packages)"
    echo "    4) Exit"
    echo ""
    read -p "  Enter choice [1-4]: " choice

    case $choice in
        1)
            read -p "  Create backup of existing configs? (Y/n): " bk
            [[ ! $bk =~ ^[Nn]$ ]] && backup_configs
            echo ""
            install_aur_helper
            install_programs
            install_configs
            fix_permissions
            enable_services
            post_install
            check_installation
            print_instructions
            ;;
        2)
            install_aur_helper
            install_programs
            success "Packages installed"
            ;;
        3)
            read -p "  Create backup of existing configs? (Y/n): " bk
            [[ ! $bk =~ ^[Nn]$ ]] && backup_configs
            echo ""
            install_configs
            fix_permissions
            post_install
            check_installation
            print_instructions
            ;;
        4)
            echo "  Installation cancelled."
            exit 0
            ;;
        *)
            error "Invalid choice"
            exit 1
            ;;
    esac
}

main "$@"