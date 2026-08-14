-- Written by KalpaKavindu <kalpadevonline@gmail.com>

hl.layer_rule({
    match = {
        class = "^(eww_popup)$"
    },
    blur = true,
    ignore_alpha = 0
})

hl.layer_rule({
    match = {
        class = "^(swaync-control-center)$"
    },
    blur = true,
    ignore_alpha = 0
})

hl.layer_rule({
    match = {
        class = "^(wofi)$"
    },
    blur = true,
    ignore_alpha = 0
})


hl.window_rule({
    match = {
        class = ".*"
    },
    suppress_event = "maximize"
})

hl.window_rule({
    match = {
        class = "^$",
        title = "^$",
        xwayland = true,
        float = true,
        fullscreen = false,
        pin = false
    },
    no_focus = true
})

hl.window_rule({
    match = {
        class = "^(Chromium|Google-chrome)$",
    },
    no_blur = true
})

hl.window_rule({
    match = {
        class = "^(firefox|firefox-developer-edition)$",
        title = "^(Library)$"
    },
    float = true,
    size = "{884, 516}"
})

hl.window_rule({
    match = {
        class = "^(firefox|firefox-developer-edition)$",
        title = "^(Firefox - Choose a profile|Firefox Developer Edition - Choose a profile)$"
    },
    float = true,
    size = "{884, 634}"
})

hl.window_rule({
    match = {
        class = "^(firefox|firefox-developer-edition)$",
        title = "^(Firefox - Choose User Profile|Firefox Developer Edition - Choose User Profile)$"
    },
    float = true,
    size = "{884, 634}"
})

hl.window_rule({
    match = {
        class = "^(org.telegram.desktop)$"
    },
    float = true,
    size = "{1282, 681}"
})

hl.window_rule({
    match = {
        class = "^(TelegramDesktop)$"
    },
    float = true,
    size = "{1282, 681}"
})

hl.window_rule({
    match = {
        class = "^(org.telegram.desktop)$",
        title = "^(Media viewer)$"
    },
    float = true,
    size = "{662, 504}"
})

hl.window_rule({
    match = {
        class = "^(TelegramDesktop)$",
        title = "^(Media viewer)$"
    },
    float = true,
    size = "{662, 504}"
})

hl.window_rule({
    match = {
        class = "^(org.telegram.desktop)$",
        title = ".*Mini App.*"
    },
    float = true
})

hl.window_rule({
    match = {
        class = "^(TelegramDesktop)$",
        title = ".*Mini App.*"
    },
    float = true
})


-- VLC idle inhibit
hl.window_rule({
    match = {
        class = "^(vlc)$"
    },
    idle_inhibit = "fullscreen"
})
