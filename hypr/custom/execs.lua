hl.on("hyprland.start", function()
    hl.exec_cmd("awww-daemon")
    hl.exec_cmd("systemctl --user start wallpaper-rotate.service")
end)
