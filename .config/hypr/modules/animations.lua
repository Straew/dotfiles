---@module 'hl'

--###############################################################################

-- ANIMATIONS

-- https://wiki.hypr.land/Configuring/Variables/#animations

--###############################################################################

hl.config({
    animations = {
        enabled = true,
        -- ---------------------- Bézier Curves ----------------------
        -- NAME              X0     Y0     X1     Y1
        -- Custom curves
        -- ---------------------- Animations ----------------------
        --     NAME           ENABLE SPEED  CURVE       STYLE(optional)
        -- Default reference (commented for clarity)
        -- See https://wiki.hypr.land/Configuring/Animations
        --
        -- animation = global,        1,   10,  default
        -- animation = border,        1,   5.39, easeOutQuint
        -- animation = windows,       1,   4.79, easeOutQuint
        -- animation = windowsIn,     1,   4.1,  easeOutQuint, popin 87%
        -- animation = windowsOut,    1,   1.49, linear,       popin 87%
        -- animation = fadeIn,        1,   1.73, almostLinear
        -- animation = fadeOut,       1,   1.46, almostLinear
        -- animation = fade,          1,   3.03, quick
        -- animation = layers,        1,   3.81, easeOutQuint
        -- animation = layersIn,      1,   4,    easeOutQuint, fade
        -- animation = layersOut,     1,   1.5,  linear,       fade
        -- animation = fadeLayersIn,  1,   1.79, almostLinear
        -- animation = fadeLayersOut, 1,   1.39, almostLinear
        -- animation = workspaces,    1,   1.94, almostLinear, fade
        -- animation = workspacesIn,  1,   1.21, almostLinear, fade
        -- animation = workspacesOut, 1,   1.94, almostLinear, fade
        -- animation = zoomFactor,    1,   7,    quick
    },
})
hl.curve("easeOutQuint", {
    type = "bezier",
    points = { { 0.23, 1 }, { 0.32, 1 } },
})
hl.curve("easeInOutCubic", {
    type = "bezier",
    points = { { 0.65, 0.05 }, { 0.36, 1 } },
})
hl.curve("linear", {
    type = "bezier",
    points = { { 0, 0 }, { 1, 1 } },
})
hl.curve("almostLinear", {
    type = "bezier",
    points = { { 0.5, 0.5 }, { 0.75, 1 } },
})
hl.curve("quick", {
    type = "bezier",
    points = { { 0.15, 0 }, { 0.1, 1 } },
})
hl.curve("smoothOut", {
    type = "bezier",
    points = { { 0.36, 0 }, { 0.66, -0.56 } },
})
hl.curve("smoothIn", {
    type = "bezier",
    points = { { 0.25, 1 }, { 0.5, 1 } },
})
hl.curve("overshot", {
    type = "bezier",
    points = { { 0.05, 0.9 }, { 0.1, 1.1 } },
})
hl.animation({ leaf = "windows", enabled = true, speed = 5, bezier = "overshot", style = "slide" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 4, bezier = "smoothOut", style = "slide" })
hl.animation({ leaf = "border", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 8, bezier = "smoothIn" })
hl.animation({ leaf = "fadeDim", enabled = true, speed = 8, bezier = "smoothIn" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 6, bezier = "overshot", style = "slidevert" })

--###############################################################################

-- OPTIONAL SMART GAPS PRESETS

-- https://wiki.hypr.land/Configuring/Workspace-Rules/

--###############################################################################

-- Uncomment to enable:

--

-- workspace = w[tv1], gapsout:0, gapsin:0

-- workspace = f[1],  gapsout:0, gapsin:0

--

-- windowrule = bordersize 0, floating:0, onworkspace:w[tv1]

-- windowrule = rounding 0,   floating:0, onworkspace:w[tv1]

-- windowrule = bordersize 0, floating:0, onworkspace:f[1]

-- windowrule = rounding 0,   floating:0, onworkspace:f[1]

--###############################################################################

-- DWINDLE LAYOUT

-- https://wiki.hypr.land/Configuring/Dwindle-Layout/

--###############################################################################

--dwindle {

--   pseudotile = true        # Allows windows to retain their size (mod+P toggles)

--preserve_split = true    # Keeps split direction when resizing

--}

--###############################################################################

-- MASTER LAYOUT

-- https://wiki.hypr.land/Configuring/Master-Layout/

--###############################################################################

hl.config({
    master = {
        new_status = "master",
    },
})

--###############################################################################

-- MISC OPTIONS

-- https://wiki.hypr.land/Configuring/Variables/#misc

--###############################################################################

hl.config({
    misc = {
        force_default_wallpaper = -1,
        -- -1 = no forced wallpaper, disable mascot if 0 or 1
        disable_hyprland_logo = false,
        -- true = disables random Hyprland logo
    },
})
