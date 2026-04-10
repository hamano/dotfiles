-- Hyprland config (ported from ~/.config/sway/config)
-- Example: /usr/share/hypr/hyprland.lua
-- API stubs: /usr/share/hypr/stubs/hl.meta.lua
-- Check: Hyprland --verify-config

------------------
---- MONITORS ----
------------------

hl.monitor({
    output   = "eDP-1",
    mode     = "preferred",
    position = "auto",
    scale    = 1.75,
})

hl.monitor({
    output   = "desc:Eizo Nanao Corporation EV3895 21917034",
    mode     = "preferred",
    position = "0x0",
    scale    = 1.5,
})

-- fallback for any other output
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
})


---------------------
---- MY PROGRAMS ----
---------------------

local terminal    = "wezterm"
local fileManager = "nemo"
local menu        = "rofi -show drun"
local runner      = "rofi -show run"


-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("GTK_IM_MODULE", "fcitx")
hl.env("QT_IM_MODULE", "fcitx")
hl.env("XMODIFIERS", "@im=fcitx")


-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function ()
    hl.exec_cmd("xrdb -merge ~/.Xresources")
    hl.exec_cmd("fcitx5 -d --replace")
    hl.exec_cmd("dunst")
    hl.exec_cmd("iwgtk -i")
    hl.exec_cmd("waybar")
    hl.exec_cmd("dropbox start")
    hl.exec_cmd("swayidle -w timeout 300 'swaylock -f -c 282828'")
end)


-----------------------
---- LOOK AND FEEL ----
-----------------------

-- gruvbox (same as sway)
local fg     = "rgb(ebdbb2)"
local bg2    = "rgb(504945)"
local orange = "rgb(d65d0e)"

hl.config({
    general = {
        gaps_in  = 2,
        gaps_out = 4,

        border_size = 2,

        col = {
            active_border   = orange,
            inactive_border = bg2,
        },

        resize_on_border = true,
        allow_tearing    = false,

        layout = "dwindle",
    },

    decoration = {
        rounding = 4,

        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled = false,
        },

        blur = {
            enabled = false,
        },
    },

    animations = {
        enabled = true,
    },

    dwindle = {
        preserve_split = true,
    },

    -- like sway tabbed: Super+arrow moves through tabs first, then to neighbors
    binds = {
        movefocus_cycles_groupfirst = true,
    },

    group = {
        col = {
            border_active   = orange,
            border_inactive = bg2,
        },

        groupbar = {
            font_size           = 12,
            height              = 18,
            text_color          = fg,
            text_color_inactive = fg,
            col = {
                active   = "rgb(458588)",
                inactive = "rgb(3c3836)",
            },
        },
    },

    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo   = true,
    },

    input = {
        kb_layout = "jp",
        kb_model  = "jp106",

        -- like sway "focus_follows_mouse no"
        follow_mouse = 0,

        sensitivity = 0,

        touchpad = {
            natural_scroll = false,
        },
    },
})

hl.gesture({
    fingers   = 3,
    direction = "horizontal",
    action    = "workspace",
})


---------------------
---- KEYBINDINGS ----
---------------------

local mod = "SUPER"

hl.bind(mod .. " + Return",      hl.dsp.exec_cmd(terminal))
hl.bind(mod .. " + slash",       hl.dsp.exec_cmd(fileManager))
hl.bind(mod .. " + Escape",      hl.dsp.exec_cmd(menu))
hl.bind(mod .. " + D",           hl.dsp.exec_cmd(runner))
hl.bind(mod .. " + X",           hl.dsp.exec_cmd(runner))
hl.bind(mod .. " + SHIFT + Q",   hl.dsp.window.close())
hl.bind(mod .. " + F",           hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
hl.bind(mod .. " + SHIFT + space", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. " + T",           hl.dsp.layout("togglesplit"))
hl.bind(mod .. " + P",           hl.dsp.window.pseudo())
hl.bind(mod .. " + SHIFT + C",   hl.dsp.exec_cmd("hyprctl reload"))
hl.bind(mod .. " + SHIFT + E",   hl.dsp.exit())

-- tabs (sway: layout tabbed) -> groups
hl.bind(mod .. " + W",            hl.dsp.group.toggle())
hl.bind(mod .. " + Prior",        hl.dsp.group.prev())
hl.bind(mod .. " + Next",         hl.dsp.group.next())
hl.bind(mod .. " + SHIFT + W",    hl.dsp.window.move({ out_of_group = true }))

-- focus / move (vi keys and arrows)
local dirs = {
    { "H", "left" }, { "J", "down" }, { "K", "up" }, { "L", "right" },
    { "left", "left" }, { "down", "down" }, { "up", "up" }, { "right", "right" },
}
for _, d in ipairs(dirs) do
    hl.bind(mod .. " + " .. d[1],             hl.dsp.focus({ direction = d[2] }))
    hl.bind(mod .. " + SHIFT + " .. d[1],     hl.dsp.window.move({ direction = d[2] }))
    hl.bind(mod .. " + CTRL + " .. d[1],      hl.dsp.window.move({ into_group = d[2] }))
end

-- workspaces
for i = 1, 10 do
    local key = i % 10
    hl.bind(mod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- scratchpad
hl.bind(mod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- mouse
hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mod .. " + mouse:272",  hl.dsp.window.drag(),   { mouse = true })
hl.bind(mod .. " + mouse:273",  hl.dsp.window.resize(), { mouse = true })

-- volume (same as sway)
hl.bind(mod .. " + F1",         hl.dsp.exec_cmd("pactl set-sink-mute 0 toggle"),   { locked = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("pactl set-sink-mute 0 toggle"),   { locked = true })
hl.bind(mod .. " + F2",         hl.dsp.exec_cmd("pactl set-sink-volume 0 -5%"),    { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("pactl set-sink-volume 0 -5%"),    { locked = true, repeating = true })
hl.bind(mod .. " + F3",         hl.dsp.exec_cmd("pactl set-sink-volume 0 +5%"),    { locked = true, repeating = true })
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("pactl set-sink-volume 0 +5%"),    { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),  { locked = true, repeating = true })


--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})

hl.window_rule({
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
    no_focus = true,
})

-- chrome apps / popups (same as sway for_window)
hl.window_rule({
    name  = "float-chrome-apps",
    match = { class = "^chrome-.*" },
    float = true,
})
