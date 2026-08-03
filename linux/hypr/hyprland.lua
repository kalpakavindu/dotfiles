-- Written by KalpaKavindu <kalpadevonline@gmail.com>

-- Monitor --------

hl.monitor({
    output = "eDP-1",
    mode = "1920x1080@144",
    position = "0x0",
    scale = 1.0,
})

-------------------

-- Auto Start --------
hl.on("hyprland.start", function ()
    hl.exec_cmd("uwsm app -- hyprpaper")
    hl.exec_cmd("uwsm app -- hypridle")
    hl.exec_cmd("uwsm app -- hyprsunset")
    hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1")

    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
    
    hl.exec_cmd("/home/kalpakavindu/.config/eww/scripts/launch.sh --launch-bar")
    hl.exec_cmd("/home/kalpakavindu/.config/swaync/launch.sh")
end)
----------------------

-- Multi GPU --------
hl.env("AQ_DRM_DEVICES", "/dev/dri/card2:/dev/dri/card1")
---------------------

-- Behavior --------

hl.config({
    general = {
        gaps_in = 3,
        gaps_out = 5,
        border_size = 1,
        col = {
            active_border = "rgba(11aaddee)",
            inactive_border = "rgba(595959aa)",
        },
        layout = "dwindle",
        resize_on_border = false,
        allow_tearing = false,
    },

    decoration = {
        rounding = 10,
        active_opacity = 1.0,
        inactive_opacity = 0.8,

        blur = {
            enabled = true,
            size = 4,
            passes = 2,
            vibrancy = 0.1696,
        },

        shadow = {
            enabled = true,
            range = 4,
            render_power = 3,
            color = "rgba(1a1a1aee)",
        },
    },

    input = {
        kb_layout = "us",
        kb_variant = "",
        kb_options = "",
        follow_mouse = 1,
        sensitivity = 0,

        touchpad = {
            natural_scroll = true,
            tap_to_click = true,
            drag_lock = true,
            tap_and_drag = true,
            tap_to_click = true,
            scroll_factor = 1,
        },
    },

    misc = {
        force_default_wallpaper = 0,
        disable_splash_rendering = true,
        disable_hyprland_logo = true,
    }
})

--------------------

-- Animations --------

hl.curve("easeOutQuint", { type = "bezier", points = { {0.23, 1}, {0.32, 1} }})
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1} }})
hl.curve("linear", { type = "bezier", points = { {0, 0}, {1, 1} }})
hl.curve("almostLinear", { type = "bezier", points = { {0.5, 0.5}, {0.75, 1.0} }})
hl.curve("quick", { type = "bezier", points = { {0.15, 0}, {0.1, 1} }})

hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })

hl.animation({ leaf = "windows", enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.1, bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })

hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })

hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })

hl.animation({ leaf = "workspaces", enabled = true, speed = 1.94, bezier = "almostLinear", style = "slide" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 1.94, bezier = "almostLinear", style = "slide" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "slide" })

----------------------

require("hyprrules")
require("hyprbindings")