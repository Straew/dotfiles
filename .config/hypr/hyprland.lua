---@module 'hl'
-- Main entry point: ~/.config/hypr/hyprland.lua
-- (converted from hyprland.conf; sub-configs live in ~/.config/hypr/modules/)

------------------
---- MODULES -----
------------------
-- Order matters: env first, then look & feel, then binds/rules/autostart
require("modules.env")
require("modules.setting")     -- also pulls in pywal-colors.lua
require("modules.animations")
require("modules.windowrule")
require("modules.bind")
require("modules.exec")

------------------
---- MONITORS ----
------------------
-- https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({
    output   = "eDP-1",
    mode     = "1920x1080@144",
    position = "0x0",
    scale    = 1,
})
