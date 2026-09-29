---@module 'hl'
-- ENVIRONMENT VARIABLES
-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("PATH", os.getenv("HOME") .. "/.local/bin:" .. os.getenv("PATH"))
hl.env("CURRENT_WALLPAPER", os.getenv("HOME") .. "/.cache/current_wallpaper")

-- Nvidia
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("WLR_NO_HARDWARE_CURSORS", "1")
