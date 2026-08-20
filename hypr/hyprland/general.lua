-- NOTE: monitor= lines from the old general.conf were dropped here since you
-- already have a dedicated monitors.lua (from monitors.conf / nwg-displays).
-- Keeping monitor config in one place avoids the two files fighting each other.

hl.gesture({
	fingers = 4,
	direction = "horizontal",
	action = "workspace",
})
-- workspace_swipe_* options live under `gestures` in hl.config below (TODO:
-- verify these keys still live under `gestures` vs having moved onto
-- hl.gesture() itself in your Hyprland version)
hl.config({
	gestures = {
		workspace_swipe_distance = 700,
		workspace_swipe_cancel_ratio = 0.35,
		workspace_swipe_min_speed_to_force = 5,
		workspace_swipe_direction_lock = true,
		workspace_swipe_direction_lock_threshold = 10,
		workspace_swipe_create_new = true,
		workspace_swipe_use_r = true,
	},
})

-- Variables (plain Lua locals now, instead of $var)
local gaps_in = 2
local gaps_out = 6
local gaps_workspaces = 12
local border_size = 2
local rounding = 13
local shadow_range = 12

hl.config({
	general = {
		gaps_in = gaps_in,
		gaps_out = gaps_out,
		gaps_workspaces = gaps_workspaces, -- TODO: confirm this key still exists under `general`

		border_size = border_size,
		resize_on_border = true,
		no_focus_fallback = true,

		allow_tearing = true,

		snap = {
			enabled = true,
			window_gap = 4,
			monitor_gap = 5,
			respect_gaps = true,
		},
	},

	dwindle = {
		preserve_split = true,
		smart_split = false,
		smart_resizing = false,
	},

	decoration = {
		rounding = rounding,
		rounding_power = 2.5,

		blur = {
			enabled = true,
			size = 5,
			passes = 3,
			xray = true,
			special = false,
			popups = true,
		},

		shadow = {
			enabled = true,
			range = shadow_range,
			offset = { 0, 2 },
			render_power = 2,
			color = "rgba(00000030)",
		},

		dim_inactive = false,
	},

	animations = {
		enabled = true,
	},

	input = {
		kb_layout = "br",
		kb_options = "caps:escape",
		numlock_by_default = true,
		repeat_delay = 200,
		repeat_rate = 30,
		sensitivity = 0.95,
		follow_mouse = 2,
		touchpad = {
			natural_scroll = true,
			disable_while_typing = true,
			clickfinger_behavior = true,
			scroll_factor = 0.7,
			tap_to_click = true, -- note: underscore, not hyphen, in Lua keys
			tap_and_drag = true,
			drag_lock = 0,
		},
	},

	misc = {
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
		disable_scale_notification = true,
		vrr = 1,
		mouse_move_enables_dpms = true,
		key_press_enables_dpms = true,
		animate_manual_resizes = false,
		animate_mouse_windowdragging = false,
		enable_swallow = false,
		on_focus_under_fullscreen = 2,
		allow_session_lock_restore = true,
		initial_workspace_tracking = true,
		focus_on_activate = true,
	},

	binds = {
		scroll_event_delay = 0,
		hide_special_on_workspace_change = true,
	},

	cursor = {
		zoom_factor = 1,
	},

	xwayland = {
		force_zero_scaling = true,
	},
})

-- device{} block -> hl.device()
hl.device({
	name = "pnp0c50:0b-093a:0255-touchpad",
	sensitivity = 0.3,
})

-- plugin{} block: config for the hyprexpo plugin.
-- UPDATED: switched to the maintained fork at github.com/sandwichfarm/hyprexpo
-- (the original was retired from hyprwm/hyprland-plugins, which is why these
-- keys were being rejected as "unknown config key"). This fork uses separate
-- gaps_in/gaps_out instead of a single gap_size. Re-verify against
-- https://github.com/sandwichfarm/hyprexpo once you've confirmed it loads
-- and registers with the Lua config system on your Hyprland version --
-- workspace_method and any extra keys (gesture_distance, cancel_key,
-- show_cursor, show_pinned_windows, drag_drop, etc.) may need adjusting.
hl.config({
	plugin = {
		hyprexpo = {
			columns = 3,
			gaps_in = 5,
			gaps_out = 0,
			bg_col = "rgb(111111)",
			workspace_method = "center current",
		},
	},
})

-- ================= Animations (bezier curves) =================
-- hyprlang `bezier = name, x1, y1, x2, y2` -> hl.curve(name, { type = "bezier", points = {{x1,y1},{x2,y2}} })
hl.curve("dynaIn", { type = "bezier", points = { { 0.22, 1.0 }, { 0.36, 1.0 } } })
hl.curve("dynaOut", { type = "bezier", points = { { 0.55, 0.0 }, { 0.85, 0.36 } } })
hl.curve("dynaMove", { type = "bezier", points = { { 0.25, 0.8 }, { 0.25, 1.0 } } })
hl.curve("dynaFade", { type = "bezier", points = { { 0.4, 0.0 }, { 0.2, 1.0 } } })
hl.curve("linear", { type = "bezier", points = { { 1, 1 }, { 1, 1 } } })

-- hyprlang `animation = leaf, enable, speed, curve, style` -> hl.animation({...})
-- Windows
hl.animation({ leaf = "windowsIn", enabled = true, speed = 1.8, bezier = "dynaIn", style = "slide" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.5, bezier = "dynaOut", style = "slide" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 1.6, bezier = "dynaMove", style = "slide" })
hl.animation({ leaf = "border", enabled = true, speed = 1.5, bezier = "dynaFade" })

-- Fading
hl.animation({ leaf = "fade", enabled = true, speed = 1.5, bezier = "dynaFade" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.8, bezier = "dynaFade" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.5, bezier = "dynaFade" })
hl.animation({ leaf = "fadeSwitch", enabled = true, speed = 1.5, bezier = "dynaFade" })

-- Layers
hl.animation({ leaf = "layersIn", enabled = true, speed = 1.6, bezier = "dynaIn", style = "popin 95%" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.4, bezier = "dynaOut", style = "popin 97%" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.5, bezier = "dynaFade" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.4, bezier = "dynaFade" })

-- Workspaces
hl.animation({ leaf = "workspaces", enabled = true, speed = 1.8, bezier = "dynaMove", style = "slide" })
hl.animation({ leaf = "specialWorkspaceIn", enabled = true, speed = 1.6, bezier = "dynaMove", style = "slidevert" })
hl.animation({ leaf = "specialWorkspaceOut", enabled = true, speed = 1.4, bezier = "dynaMove", style = "slidevert" })
