#!/bin/bash
# Dotfiles Uninstallation Script
# Supports Hyprland + Niri configs

# NOTE: intentionally NO set -e here — we want to continue on partial failures
# and bash arithmetic like ((n++)) returns exit 1 when result is 0, which
# would silently kill the script under set -e.

# ─── Colors ───────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

# ─── Logging ──────────────────────────────────────────────────────────────────
progress() { echo -e "${BLUE}[$(date +%H:%M:%S)]${NC} $1"; }
success()  { echo -e "${GREEN}✓${NC} $1"; }
warning()  { echo -e "${YELLOW}⚠${NC} $1"; }
error()    { echo -e "${RED}✗${NC} $1"; }

# ─── All config dirs this dotfiles repo manages ───────────────────────────────
ALL_CONFIGS=(hypr niri waybar kitty rofi cava fastfetch swaync wlogout colors MangoHud awww pyprland wal)

# Scripts installed by this repo (add any others your scripts/ dir contains)
INSTALLED_SCRIPTS=(salp wallpaper change-wallpaper lockscreen walp theme-switch pywal-theme)

# ─── Banner ───────────────────────────────────────────────────────────────────
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

# ─── Show what will be removed ────────────────────────────────────────────────
show_removal_list() {
    echo -e "${YELLOW}The following will be removed:${NC}"
    echo ""

    local found=0

    for dir in "${ALL_CONFIGS[@]}"; do
        if [ -d ~/.config/"$dir" ]; then
            echo "  ✗ ~/.config/$dir"
            found=$((found + 1))
        fi
    done

    # Scripts
    local found_scripts=0
    for script in "${INSTALLED_SCRIPTS[@]}"; do
        if [ -f ~/.local/bin/"$script" ]; then
            found_scripts=$((found_scripts + 1))
        fi
    done
    [ "$found_scripts" -gt 0 ] && echo "  ✗ $found_scripts script(s) in ~/.local/bin"

    # Cache/state files
    { [ -f ~/.cache/current_wallpaper ] || [ -f ~/.config/wallpaper_state ] || [ -d ~/.cache/wal ]; } && \
        echo "  ✗ Wallpaper and pywal cache files"

    echo ""

    if [ "$found" -eq 0 ] && [ "$found_scripts" -eq 0 ]; then
        warning "No dotfiles found to remove"
        exit 0
    fi
}

# ─── Backup before removal ────────────────────────────────────────────────────
backup_before_removal() {
    BACKUP_DIR=~/.config/dotfiles_removed_$(date +%Y%m%d_%H%M%S)
    progress "Creating backup at: $BACKUP_DIR"
    mkdir -p "$BACKUP_DIR"

    local backed_up=0

    for dir in "${ALL_CONFIGS[@]}"; do
        if [ -d ~/.config/"$dir" ]; then
            cp -r ~/.config/"$dir" "$BACKUP_DIR/" && backed_up=$((backed_up + 1)) || true
        fi
    done

    # Backup scripts
    if [ -d ~/.local/bin ]; then
        mkdir -p "$BACKUP_DIR/bin"
        # Use cp -r to handle subdirs; filter to only known scripts
        for script in "${INSTALLED_SCRIPTS[@]}"; do
            [ -f ~/.local/bin/"$script" ] && cp ~/.local/bin/"$script" "$BACKUP_DIR/bin/" || true
        done
    fi

    # Backup state files
    [ -f ~/.config/wallpaper_state ] && cp ~/.config/wallpaper_state "$BACKUP_DIR/" || true
    [ -d ~/.cache/wal ] && cp -r ~/.cache/wal "$BACKUP_DIR/" || true

    if [ "$backed_up" -gt 0 ]; then
        success "Backed up $backed_up config directories"
        echo "  → $BACKUP_DIR"
    else
        warning "Nothing was backed up (configs may already be gone)"
    fi
}

# ─── Remove configs ───────────────────────────────────────────────────────────
remove_configs() {
    progress "Removing config directories..."
    local removed=0

    for dir in "${ALL_CONFIGS[@]}"; do
        if [ -d ~/.config/"$dir" ]; then
            rm -rf ~/.config/"$dir" && {
                success "Removed: ~/.config/$dir"
                removed=$((removed + 1))
            } || error "Failed to remove: ~/.config/$dir"
        fi
    done

    echo ""
    progress "Removing scripts..."
    for script in "${INSTALLED_SCRIPTS[@]}"; do
        if [ -f ~/.local/bin/"$script" ]; then
            rm -f ~/.local/bin/"$script" && success "Removed script: $script" || true
        fi
    done

    echo ""
    progress "Removing cache and state files..."
    [ -f ~/.cache/current_wallpaper ]     && rm -f ~/.cache/current_wallpaper     && success "Removed: wallpaper cache"
    [ -f ~/.config/wallpaper_state ]      && rm -f ~/.config/wallpaper_state      && success "Removed: wallpaper state"
    [ -d ~/.cache/wallpaper-thumbnails ]  && rm -rf ~/.cache/wallpaper-thumbnails && success "Removed: wallpaper thumbnails"
    [ -d ~/.cache/wal ]                   && rm -rf ~/.cache/wal                  && success "Removed: pywal cache"

    echo ""
    success "Removed $removed config directories"
}

# ─── List available backups ───────────────────────────────────────────────────
list_backups() {
    # Store results in the global BACKUPS array rather than relying on
    # word-splitting a string (which breaks on paths with spaces)
    BACKUPS=()
    while IFS= read -r -d '' dir; do
        BACKUPS+=("$dir")
    done < <(find ~/.config -maxdepth 1 -type d \( -name "dotfiles_backup_*" -o -name "dotfiles_removed_*" \) -print0 2>/dev/null | sort -z)

    [ "${#BACKUPS[@]}" -gt 0 ]
}

# ─── Restore from backup ──────────────────────────────────────────────────────
restore_from_backup() {
    progress "Checking for backups..."

    if ! list_backups; then
        warning "No backups found"
        return
    fi

    echo ""
    echo "Found backups:"
    local i=1
    for backup in "${BACKUPS[@]}"; do
        echo "  $i) $(basename "$backup")"
        i=$((i + 1))
    done
    echo "  0) Skip restore"
    echo ""

    read -p "Select backup to restore [0-${#BACKUPS[@]}]: " choice

    if [ -z "$choice" ] || [ "$choice" -eq 0 ]; then
        echo "Skipping restore"
        return
    fi

    if [ "$choice" -ge 1 ] && [ "$choice" -le "${#BACKUPS[@]}" ]; then
        local selected="${BACKUPS[$((choice - 1))]}"
        progress "Restoring from: $(basename "$selected")"

        local restored=0
        for item in "$selected"/*/; do
            local dirname
            dirname="$(basename "$item")"
            [ "$dirname" = "bin" ] && continue   # handle scripts separately
            if [ -d "$item" ]; then
                cp -r "$item" ~/.config/ && {
                    success "Restored: $dirname"
                    restored=$((restored + 1))
                } || warning "Failed to restore: $dirname"
            fi
        done

        # Restore scripts
        if [ -d "$selected/bin" ]; then
            mkdir -p ~/.local/bin
            cp -r "$selected/bin/." ~/.local/bin/ 2>/dev/null && {
                find ~/.local/bin -type f -exec chmod +x {} \;
                success "Restored: scripts"
            } || warning "Failed to restore scripts"
        fi

        # Restore pywal cache
        if [ -d "$selected/wal" ]; then
            mkdir -p ~/.cache
            cp -r "$selected/wal" ~/.cache/ 2>/dev/null && success "Restored: pywal cache" || true
        fi

        echo ""
        success "Restored $restored items from backup"
    else
        error "Invalid choice"
    fi
}

# ─── Main ─────────────────────────────────────────────────────────────────────
main() {
    print_banner
    show_removal_list

    echo -e "${RED}⚠  WARNING: This will remove all dotfiles configurations!${NC}"
    echo ""
    read -p "Are you sure you want to continue? (yes/NO): " confirm

    if [[ ! $confirm =~ ^[Yy][Ee][Ss]$ ]]; then
        echo "Uninstall cancelled"
        exit 0
    fi

    echo ""
    read -p "Create backup before removal? (Y/n): " bk
    [[ ! $bk =~ ^[Nn]$ ]] && backup_before_removal

    echo ""
    remove_configs

    echo ""
    read -p "Would you like to restore from a previous backup? (y/N): " rc
    [[ $rc =~ ^[Yy]$ ]] && { echo ""; restore_from_backup; }

    echo ""
    echo -e "${GREEN}"
    cat << "EOF"
    ╔═══════════════════════════════════════════════╗
    ║                                               ║
    ║         ✓ Uninstall Complete                  ║
    ║                                               ║
    ╚═══════════════════════════════════════════════╝
EOF
    echo -e "${NC}"

    if [ -n "${BACKUP_DIR:-}" ] && [ -d "$BACKUP_DIR" ]; then
        echo -e "${YELLOW}  💾 Backup saved to:${NC} $BACKUP_DIR"
        echo ""
    fi

    echo "  To reinstall, run: ./install.sh"
    echo ""
    echo -e "${YELLOW}  NOTE:${NC} Log out and back in for changes to take effect"
    echo ""
}

main "$@"