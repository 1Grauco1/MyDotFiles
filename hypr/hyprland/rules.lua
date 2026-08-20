-- windowrule "match:field value, action" -> hl.window_rule({ match = {...}, action = ... })
-- Your original rules.conf already used the newer `match:` syntax, so most of
-- this is a fairly direct 1:1 mapping into Lua tables.

-- ######## Global Popup / Submenu Rules ########

hl.window_rule({ name = "untitled-popups", match = { title = "^()$" }, float = true })
hl.window_rule({ name = "classless-popups", match = { class = "^()$" }, float = true })

hl.window_rule({ name = "no-hyphen-titles", match = { title = "^(?!.* - ).*$" }, float = true, center = true })
hl.window_rule({ match = { title = ".*Select.*" }, float = true, center = true })
hl.window_rule({ match = { title = ".*Confirm.*" }, float = true, center = true })
hl.window_rule({ match = { title = ".*Warning.*" }, float = true, center = true })
hl.window_rule({ match = { title = ".*Error.*" }, float = true, center = true })
hl.window_rule({ match = { title = "^(Receiving file — KDE Connect Daemon)$" }, float = true, center = true })

-- ######## Window rules ########

-- Disable blur for xwayland context menus
hl.window_rule({ match = { class = "^()$", title = "^()$" }, no_blur = true })

-- Disable blur for every window
hl.window_rule({ match = { class = ".*" }, no_blur = true })

-- My Rules
hl.window_rule({ match = { title = "^(Overview)(.*)$" }, float = true, center = true })
-- TODO: `size` here is written as a string mirroring the old hyprlang expr syntax.
-- Verify hl.window_rule expects a string or a {w, h} table on your Hyprland build.
hl.window_rule({
	match = { title = "^(Wallpaper Selector)(.*)$" },
	float = true,
	center = true,
	size = "monitor_w*.52 monitor_h*.55",
})
hl.window_rule({
	match = { title = "^(Hyprland Keybinds Cheatsheet)(.*)$" },
	float = true,
	center = true,
	size = "monitor_w*.40 monitor_h*.80",
})
hl.window_rule({ match = { title = "^(mako)(.*)$" }, float = true, move = "monitor_w*.70 monitor_h*.05" })
hl.window_rule({ match = { title = "^(Extract)(.*)$" }, float = true, center = true })
hl.window_rule({ match = { title = "^(Compress)(.*)$" }, float = true, center = true })
hl.window_rule({ match = { title = "^(Rename)(.*)$" }, float = true, center = true })
hl.window_rule({ match = { title = "^(WallpaperPicker)(.*)$" }, float = true, center = true })
hl.window_rule({ match = { title = "^(File Operation Progress)(.*)$" }, center = true, float = true })
hl.window_rule({ match = { title = "^(Zenith Installer)(.*)$" }, float = true, center = true })

-- Combined File Dialog Rules
hl.window_rule({
	match = { title = "^(Open File|Select a File|Open Folder|Save As|Library|File Upload)(.*)$" },
	float = true,
	center = true,
})

hl.window_rule({ match = { title = "^(.*)(wants to save|wants to open)$" }, float = true, center = true })

hl.window_rule({
	match = { class = "^(org.gnome.FileRoller)$" },
	float = true,
	center = true,
	size = "monitor_w*.35 monitor_h*.16",
})
hl.window_rule({
	match = { class = "^(blueberry\\.py)$" },
	float = true,
	center = true,
	size = "monitor_w*.45 monitor_h*.45",
})
hl.window_rule({ match = { class = "^(guifetch)$" }, float = true, center = true })

-- Pavucontrol
hl.window_rule({
	match = { class = "^(pavucontrol|org.pulseaudio.pavucontrol|com.saivert.pwvucontrol)$" },
	float = true,
	center = true,
	size = "monitor_w*.45 monitor_h*.45",
})

-- Networking
hl.window_rule({
	match = { class = "^(nm-connection-editor)$" },
	float = true,
	center = true,
	size = "monitor_w*.45 monitor_h*.45",
})

hl.window_rule({ match = { class = ".*plasmawindowed.*" }, float = true, center = true })
hl.window_rule({ match = { title = ".*Welcome" }, float = true, center = true })
hl.window_rule({ match = { title = ".*Shell conflicts.*" }, float = true, center = true })
hl.window_rule({
	match = { class = "org.freedesktop.impl.portal.desktop.kde" },
	float = true,
	center = true,
	size = "monitor_w*.60 monitor_h*.65",
})

-- Tiling
hl.window_rule({ match = { class = "^dev\\.warp\\.Warp$" }, tile = true })

-- Picture-in-Picture
hl.window_rule({
	match = { title = "^([Pp]icture[-\\s]?[Ii]n[-\\s]?[Pp]icture)(.*)$" },
	float = true,
	pin = true,
	keep_aspect_ratio = true,
	move = "monitor_w*.744 monitor_h*.739",
	size = "monitor_w*.25 monitor_h*.25",
})

-- --- Tearing ---
hl.window_rule({ match = { title = ".*\\.exe" }, immediate = true })
hl.window_rule({ match = { title = ".*minecraft.*" }, immediate = true })
hl.window_rule({ match = { class = "^(steam_app).*" }, immediate = true })

-- No shadow for tiled windows
hl.window_rule({ match = { float = false }, no_shadow = true })

-- ######## Workspace rules ########
hl.workspace_rule({ workspace = "special:special", gaps_out = 30 })

-- ######## Layer rules ########
hl.layer_rule({ match = { namespace = ".*" }, xray = true })
hl.layer_rule({
	match = { namespace = "(walker|selection|overview|anyrun|indicator.*|osk|hyprpicker|noanim)" },
	no_anim = true,
})

hl.layer_rule({ match = { namespace = "(gtk-layer-shell|launcher|notifications|osd)" }, blur = true })
hl.layer_rule({ match = { namespace = "launcher" }, ignore_alpha = 0.5 })
hl.layer_rule({ match = { namespace = "(notifications|osd)" }, ignore_alpha = 0.69 })
hl.layer_rule({ match = { namespace = "logout_dialog" }, blur = true })

-- Launchers FAST
hl.layer_rule({ match = { namespace = "gtk4-layer-shell" }, no_anim = true })

-- Tags
-- TODO: tagging via `tag = "name"` on hl.window_rule is a best-effort mapping.
-- Confirm against the wiki's Window-Rules/Tags page for your Hyprland version —
-- it's possible tags are instead applied via a dedicated hl.tag_rule() or
-- similar call rather than a field on window_rule.
hl.window_rule({
	tag = "browser",
	match = { class = "^([Zz]en-browser|zen|zen-browser|[Ff]irefox|org.mozilla.firefox|[Ff]irefox-esr)$" },
})
hl.window_rule({
	tag = "terminal",
	match = { class = "^(Alacritty|kitty|kitty-dropterm|gnome-terminal|foot|terminal)$" },
})
hl.window_rule({
	tag = "email",
	match = { class = "^([Tt]hunderbird|org.gnome.Evolution|eu.betterbird.Betterbird)$" },
})
hl.window_rule({
	tag = "projects",
	match = { class = "^(VSCode|code-url-handler|code|visual-studio-code|vscode|zeditor)$" },
})
hl.window_rule({ tag = "screenshare", match = { class = "^(com.obsproject.Studio)$" } })
hl.window_rule({ tag = "im", match = { class = "^([Dd]iscord|[Ww]ebCord|[Vv]esktop)$" } })
hl.window_rule({ tag = "games", match = { class = "^(gamescope|steam_app_\\d+)$" } })
hl.window_rule({ tag = "gamestore", match = { class = "^([Ss]team)$", title = "^([Ll]utris)$" } })
hl.window_rule({ tag = "file-manager", match = { class = "^([Nn]emo|[Tt]hunar|org.gnome.Nautilus|[Pp]cmanfm-qt)$" } })
hl.window_rule({
	tag = "multimedia",
	match = { class = "^(youtube-music-bin|youtube-music|youtube-music-git|[Aa]udacious)$" },
})
hl.window_rule({ tag = "player", match = { class = "^(vlc|mpv)$" } })
hl.window_rule({
	tag = "settings",
	match = {
		class = "^(gnome-disks|wihotspot(-gui)?|file-roller|org.gnome.FileRoller|nm-applet|nm-connection-editor|blueman-manager|pavucontrol|org.pulseaudio.pavucontrol|com.saivert.pwvucontrol|nwg-look|qt5ct|qt6ct|[Yy]ad|xdg-desktop-portal-gtk|org.kde.polkit-kde-authentication-agent-1)$",
		title = "^(Kvantum Manager)$",
	},
})
hl.window_rule({
	tag = "viewer",
	match = {
		class = "^(gnome-system-monitor|org.gnome.SystemMonitor|io.missioncenter.MissionCenter|eog|org.gnome.Loupe)$",
	},
})

-- Opacity
-- FIXED: hl.window_rule has no `opacity_active`/`opacity_inactive` fields --
-- confirmed by the "unknown field" errors on lines 124-134. The Lua API uses
-- a single `opacity` field that takes the same string format as the old
-- hyprlang windowrule syntax: "<active> [override] <inactive> [override]".
-- `override` forces an absolute value instead of Hyprland's default
-- multiplicative stacking, matching your original intent.
hl.window_rule({ match = { tag = "browser*" }, opacity = "0.99 override 0.96 override" })
hl.window_rule({ match = { tag = "projects*" }, opacity = "0.95 override 0.9 override" })
hl.window_rule({ match = { tag = "im*" }, opacity = "0.95 override 0.9 override" })
hl.window_rule({ match = { tag = "multimedia*" }, opacity = "0.9 override 0.8 override" })
hl.window_rule({ match = { tag = "player*" }, opacity = "1 override 1 override" })
hl.window_rule({ match = { tag = "file-manager*" }, opacity = "0.95 override 0.92 override" })
hl.window_rule({ match = { tag = "terminal*" }, opacity = "0.85 override 0.8 override" })
hl.window_rule({ match = { tag = "settings*" }, opacity = "0.95 override 0.9 override" })
hl.window_rule({ match = { tag = "viewer*" }, opacity = "0.95 override 0.9 override" })
hl.window_rule({ match = { tag = "wallpaper*" }, opacity = "0.95 override 0.9 override" })
hl.window_rule({ match = { class = "^(gedit|org.gnome.TextEditor|mousepad)$" }, opacity = "0.95 override 0.9 override" })

hl.window_rule({ match = { tag = "(browser|terminal|projects)*" }, no_blur = false })
