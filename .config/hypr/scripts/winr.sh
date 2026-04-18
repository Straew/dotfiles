#!/bin/bash
# Toggle all windows between floating and tiled
# Save as ~/.config/hypr/scripts/winr.sh

STATE_FILE="/tmp/hypr_float_mode"

if [ -f "$STATE_FILE" ]; then
    # DISABLE: Make all windows tiled again
    echo "Switching to tiling mode..."
    
    # Get all window addresses
    windows=$(hyprctl clients -j | jq -r '.[].address')
    
    # Make each floating window tiled
    for win in $windows; do
        is_floating=$(hyprctl clients -j | jq -r ".[] | select(.address==\"$win\") | .floating")
        if [ "$is_floating" = "true" ]; then
            hyprctl dispatch togglefloating address:$win
        fi
    done
    
    rm "$STATE_FILE"
    notify-send "🪟 Tiling Mode" "All windows are tiled"
    
else
    # ENABLE: Make all windows floating
    echo "Switching to floating mode..."
    
    # Get all window addresses
    windows=$(hyprctl clients -j | jq -r '.[].address')
    
    # Make each tiled window floating
    for win in $windows; do
        is_floating=$(hyprctl clients -j | jq -r ".[] | select(.address==\"$win\") | .floating")
        if [ "$is_floating" = "false" ]; then
            hyprctl dispatch togglefloating address:$win
        fi
    done
    
    touch "$STATE_FILE"
    notify-send "🎈 Floating Mode" "All windows are floating"
fi