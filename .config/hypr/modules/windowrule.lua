---@module 'hl'

--#############################

--## WINDOWS AND WORKSPACES ###

--#############################

-- See https://wiki.hypr.land/Configuring/Window-Rules/ for more

-- See https://wiki.hypr.land/Configuring/Workspace-Rules/ for workspace rules

-- Example windowrule

-- windowrule = float,class:^(kitty)$,title:^(kitty)$

-- Ignore maximize requests from apps.

hl.window_rule({
    name  = "windowrule-1",
    match = {
        class = ".*",
    },
    suppress_event = "maximize",
})

hl.window_rule({
    name  = "windowrule-2",
    match = {
        class = "^$",
        title = "^$",
        xwayland = true,
        float = true,
        fullscreen = false,
        pin = false,
    },
    no_focus = true,
})

hl.window_rule({
    name  = "windowrule-3",
    match = {
        class = "^(brave-browser)$",
    },
    opacity = "1.0 0.95",
})

hl.window_rule({
    name  = "windowrule-4",
    match = {
        class = "^(kitty)$",
    },
    opacity = "0.5 0.9",
})

hl.window_rule({
    name  = "windowrule-5",
    match = {
        class = "^(vesktop)$",
    },
    opacity = "1.0 0.95",
})

--windowrule {

-- name = .*

-- match:class =.*

-- float = on

-- opacity = 0.9 0.8

-- border_size = 2 override

--}
