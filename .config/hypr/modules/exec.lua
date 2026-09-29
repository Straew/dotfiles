---@module 'hl'
-- AUTOSTART (was exec-once)

hl.on("hyprland.start", function()
    hl.exec_cmd("waybar")
    hl.exec_cmd("awww-daemon")
    hl.exec_cmd("swaync")
    hl.exec_cmd("rog-control-center")
    hl.exec_cmd("rm -f /run/user/1000/hypr/*/.pyprland.sock && pypr")
end)
