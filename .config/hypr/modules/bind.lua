---@module 'hl'
-- KEYBINDINGS
-- https://wiki.hypr.land/Configuring/Basics/Binds/

local terminal    = "kitty"
local fileManager = "thunar"
local menu        = "rofi --show drun"
local mainMod     = "SUPER"

-- Apps / misc
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(terminal))
hl.bind("ALT + F4", hl.dsp.window.close())
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("hyprctl reload"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd("hypremoji"))
hl.bind(mainMod .. " + D", hl.dsp.window.float())
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd("pkill rofi || rofi -show drun"))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())          -- dwindle
-- hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit")) -- dwindle (was commented out)
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd("~/.config/waybar/scripts/launch.sh"))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("~/.local/bin/salp"))
hl.bind(mainMod .. " + PRINT", hl.dsp.exec_cmd(
    "grim ~/Pictures/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png && notify-send \"Screenshot Taken 💥\""))
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + G", hl.dsp.exec_cmd("~/.local/bin/gamemode"))
hl.bind(mainMod .. " + ALT + F", hl.dsp.exec_cmd("~/.config/hypr/scripts/winr.sh"))

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

-- Workspaces: mainMod + [0-9] to switch, mainMod + SHIFT + [0-9] to move window
for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key,             hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key,     hl.dsp.window.move({ workspace = i }))
end

-- Special workspace (scratchpad)
hl.bind(mainMod .. " + S",       hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + ALT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Volume / brightness (was bindel = repeat + works when locked)
hl.bind(mainMod .. " + F3", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { repeating = true, locked = true })
hl.bind(mainMod .. " + F2", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { repeating = true, locked = true })
hl.bind(mainMod .. " + F1", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),      { repeating = true, locked = true })
hl.bind(mainMod .. " + F4", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),    { repeating = true, locked = true })
hl.bind(mainMod .. " + F8", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                   { repeating = true, locked = true })
hl.bind(mainMod .. " + F7", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                   { repeating = true, locked = true })
hl.bind(mainMod .. " + F5", hl.dsp.exec_cmd("asusctl profile next"))

-- Media keys (requires playerctl)
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

-- Pyprland scratchpads
hl.bind(mainMod .. " + grave",     hl.dsp.exec_cmd("pypr toggle term"))        -- dropdown terminal
hl.bind(mainMod .. " + V",         hl.dsp.exec_cmd("pypr toggle volume"))      -- volume control
hl.bind(mainMod .. " + SHIFT + M", hl.dsp.exec_cmd("pypr toggle music"))       -- music player
hl.bind(mainMod .. " + B",         hl.dsp.exec_cmd("pypr toggle btop"))        -- system monitor
hl.bind(mainMod .. " + C",         hl.dsp.exec_cmd("pypr toggle calculator"))  -- calculator
-- hl.bind(mainMod .. " + Tab", hl.dsp.exec_cmd("pypr expose"))                -- show all windows
hl.bind(mainMod .. " + Z",         hl.dsp.exec_cmd("pypr zoom"))               -- toggle zoom
