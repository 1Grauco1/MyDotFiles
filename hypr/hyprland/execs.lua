-- Autostart processes.
-- exec-once -> hl.exec_cmd() calls inside an "hyprland.start" event handler.
-- See https://wiki.hypr.land/Configuring/Basics/Autostart/
hl.on("hyprland.start", function()
    -- Bar
    hl.exec_cmd("~/.config/quickshell/launch.sh start")

    -- Core components
    hl.exec_cmd("env GNOME_KEYRING_CONTROL=/run/user/1000/keyring GNOME_KEYRING_PID=$(pgrep -u $USER gnome-keyring-daemon) gnome-keyring-daemon --start --components=secrets,ssh")
    hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1 || /usr/libexec/polkit-kde-authentication-agent-1 || /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 || /usr/libexec/polkit-gnome-authentication-agent-1")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("dbus-update-activation-environment --all")
    hl.exec_cmd("sleep 1 && dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("hyprpm reload")

    -- Input method
    -- hl.exec_cmd("fcitx5")

    -- Audio (optional)
    -- hl.exec_cmd("easyeffects --gapplication-service")

    -- Clipboard history
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")

    -- Cursor
    hl.exec_cmd("hyprctl setcursor Bibata-Modern-Classic 22")
end)
