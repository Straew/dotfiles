---@module 'hl'

-- =====================================================================

-- LOOK AND FEEL CONFIGURATION

-- =====================================================================

-- Reference: https://wiki.hypr.land/Configuring/Variables/

-- ---------------------------------------------------------------------

-- GENERAL SETTINGS

-- ---------------------------------------------------------------------

-- https://wiki.hypr.land/Configuring/Variables/#general

local c = require("pywal-colors")

hl.config({
    general = {
        gaps_in = 7,
        gaps_out = 17,
        border_size = 3,
        -- Border colors
        -- https://wiki.hypr.land/Configuring/Variables/#variable-types
        -- Window behavior
        resize_on_border = false,
        allow_tearing = false,
        layout = "dwindle",
        col = {
            active_border = c.color0,
            inactive_border = "rgba(00000000)",
        },
    },
})

-- ---------------------------------------------------------------------

-- DECORATION & VISUAL EFFECTS

-- ---------------------------------------------------------------------

-- https://wiki.hypr.land/Configuring/Variables/#decoration

hl.config({
    decoration = {
        -- Rounding
        rounding = 12,
        rounding_power = 2,
        -- Opacity
        active_opacity = 1.0,
        inactive_opacity = 1.0,
        fullscreen_opacity = 1.0,
        -- Shadow effects
        shadow = {
            enabled = true,
            range = 30,
            render_power = 3,
            color = "rgba(00000099)",
            offset = "0 2",
            scale = 1.0,
        },
        -- Blur effects
        -- https://wiki.hypr.land/Configuring/Variables/#blur
        blur = {
            enabled = true,
            size = 10,
            passes = 5,
            new_optimizations = true,
            ignore_opacity = true,
            -- Vibrancy
            vibrancy = 0.1696,
            vibrancy_darkness = 0.0,
            -- Brightness and contrast
            brightness = 1.0,
            contrast = 1.0,
            noise = 0.01,
            -- Popup settings
            popups = true,
            popups_ignorealpha = 0.2,
        },
        -- Dimming for inactive windows
        dim_inactive = true,
        dim_strength = 0.1,
    },
})

-- =====================================================================

-- INPUT CONFIGURATION

-- =====================================================================

-- ---------------------------------------------------------------------

-- KEYBOARD SETTINGS

-- ---------------------------------------------------------------------

-- https://wiki.hypr.land/Configuring/Variables/#input

hl.config({
    input = {
        -- Keyboard layout
        kb_layout = "us",
        -- Mouse behavior
        follow_mouse = 1,
        sensitivity = 0,
        -- -1.0 to 1.0, 0 means no modification
        -- Touchpad settings
        touchpad = {
            natural_scroll = false,
        },
    },
})

-- ---------------------------------------------------------------------

-- GESTURES

-- ---------------------------------------------------------------------

-- See https://wiki.hypr.land/Configuring/Gestures

hl.gesture({
    ["fingers"] = 3,
    ["direction"] = "horizontal",
    ["action"] = "workspace",
})

-- ---------------------------------------------------------------------

-- PER-DEVICE CONFIGURATION

-- ---------------------------------------------------------------------

-- Example per-device config

-- See https://wiki.hypr.land/Configuring/Keywords/#per-device-input-configs

hl.device({
    name = "epic-mouse-v1",
    sensitivity = -0.5,
})

hl.config({
    cursor = {
        no_hardware_cursors = true,
    },
})
