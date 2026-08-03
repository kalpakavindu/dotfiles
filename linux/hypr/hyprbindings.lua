-- Written by KalpaKavindu <kalpadevonline@gmail.com>

local terminal = "uwsm app -- alacritty"
local fileManager = "uwsm app -- nautilus --new-window"
local scriptDir = "/home/kalpakavindu/.config/hypr/scripts"
local ewwScript = "/home/kalpakavindu/.config/eww/scripts/launch.sh"
local finder = "/home/kalpakavindu/.config/wofi/launch.sh"

local mainMod = "SUPER"

hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("pidof code | xargs kill -9 && uwsm stop"))
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("swaync-client -t -sw"))
hl.bind(mainMod .. " + F", hl.dsp.exec_cmd(finder .. " -t"))
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("cliphist list | " .. finder .. " -dm | cliphist decode | wl-copy"))

-- Window
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.window.kill())
hl.bind(mainMod .. " + F11", hl.dsp.window.fullscreen({ mode = 0, action = "toggle", window = "active" }))
hl.bind(mainMod .. " + O", hl.dsp.window.float({ action = "toggle", window = "active" }))

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag())
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize())

hl.bind(mainMod .. " + LEFT", hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + RIGHT", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + UP", hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + DOWN", hl.dsp.focus({ direction = "d" }))

hl.bind(mainMod .. " + ALT + LEFT", hl.dsp.window.move({ direction = "l", window = "active" }))
hl.bind(mainMod .. " + ALT + RIGHT", hl.dsp.window.move({ direction = "r", window = "active" }))
hl.bind(mainMod .. " + ALT + UP", hl.dsp.window.move({ direction = "u", window = "active" }))
hl.bind(mainMod .. " + ALT + DOWN", hl.dsp.window.move({ direction = "d", window = "active" }))
---------

-- Workspace
hl.bind(mainMod .. " + 1", hl.dsp.focus({ workspace = 1 }))
hl.bind(mainMod .. " + 2", hl.dsp.focus({ workspace = 2 }))
hl.bind(mainMod .. " + 3", hl.dsp.focus({ workspace = 3 }))
hl.bind(mainMod .. " + 4", hl.dsp.focus({ workspace = 4 }))
hl.bind(mainMod .. " + 5", hl.dsp.focus({ workspace = 5 }))
hl.bind(mainMod .. " + 6", hl.dsp.focus({ workspace = 6 }))
hl.bind(mainMod .. " + 7", hl.dsp.focus({ workspace = 7 }))
hl.bind(mainMod .. " + 8", hl.dsp.focus({ workspace = 8 }))
hl.bind(mainMod .. " + 9", hl.dsp.focus({ workspace = 9 }))
hl.bind(mainMod .. " + 0", hl.dsp.focus({ workspace = 10 }))
hl.bind(mainMod .. " + TAB", hl.dsp.focus({ workspace = "previous" }))

hl.bind(mainMod .. " + CTRL + 1", hl.dsp.window.move({ workspace = 1, follow = true, window = "active" }))
hl.bind(mainMod .. " + CTRL + 2", hl.dsp.window.move({ workspace = 2, follow = true, window = "active" }))
hl.bind(mainMod .. " + CTRL + 3", hl.dsp.window.move({ workspace = 3, follow = true, window = "active" }))
hl.bind(mainMod .. " + CTRL + 4", hl.dsp.window.move({ workspace = 4, follow = true, window = "active" }))
hl.bind(mainMod .. " + CTRL + 5", hl.dsp.window.move({ workspace = 5, follow = true, window = "active" }))
hl.bind(mainMod .. " + CTRL + 6", hl.dsp.window.move({ workspace = 6, follow = true, window = "active" }))
hl.bind(mainMod .. " + CTRL + 7", hl.dsp.window.move({ workspace = 7, follow = true, window = "active" }))
hl.bind(mainMod .. " + CTRL + 8", hl.dsp.window.move({ workspace = 8, follow = true, window = "active" }))
hl.bind(mainMod .. " + CTRL + 9", hl.dsp.window.move({ workspace = 9, follow = true, window = "active" }))
hl.bind(mainMod .. " + CTRL + 0", hl.dsp.window.move({ workspace = 10, follow = true, window = "active" }))

hl.bind(mainMod .. " + SHIFT + 1", hl.dsp.window.move({ workspace = 1, follow = false, window = "active" }))
hl.bind(mainMod .. " + SHIFT + 2", hl.dsp.window.move({ workspace = 2, follow = false, window = "active" }))
hl.bind(mainMod .. " + SHIFT + 3", hl.dsp.window.move({ workspace = 3, follow = false, window = "active" }))
hl.bind(mainMod .. " + SHIFT + 4", hl.dsp.window.move({ workspace = 4, follow = false, window = "active" }))
hl.bind(mainMod .. " + SHIFT + 5", hl.dsp.window.move({ workspace = 5, follow = false, window = "active" }))
hl.bind(mainMod .. " + SHIFT + 6", hl.dsp.window.move({ workspace = 6, follow = false, window = "active" }))
hl.bind(mainMod .. " + SHIFT + 7", hl.dsp.window.move({ workspace = 7, follow = false, window = "active" }))
hl.bind(mainMod .. " + SHIFT + 8", hl.dsp.window.move({ workspace = 8, follow = false, window = "active" }))
hl.bind(mainMod .. " + SHIFT + 9", hl.dsp.window.move({ workspace = 9, follow = false, window = "active" }))
hl.bind(mainMod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = 10, follow = false, window = "active" }))
------------

-- Screenshot
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd("hyprshot -m output -m active"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("hyprshot -m window"))
hl.bind(mainMod .. " + CTRL + S", hl.dsp.exec_cmd("hyprshot -m region"))
-------------

-- Launchers
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
------------

-- Media Controls
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(scriptDir .. "/volume.sh --inc"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(scriptDir .. "/volume.sh --dec"))
-- hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd(scriptDir.."/volume.sh --toggle-mic"))
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(scriptDir .. "/volume.sh --toggle"))
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"))
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"))
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(scriptDir .. "/backlight.sh --inc"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(scriptDir .. "/backlight.sh --dec"))
-----------------

-- Minimize trick
hl.bind(mainMod .. " + X", function()
    if hl.get_workspace("special:minimized") then
        hl.dispatch(hl.dsp.window.move({ workspace = hl.get_active_workspace(), window = "tag:minimized" }))
        hl.dispatch(hl.dsp.window.clear_tags({ window = "tag:minimized" }))
    else
        hl.dispatch(hl.dsp.window.tag({ tag = "minimized", window = hl.get_active_window() }))
        hl.dispatch(hl.dsp.window.move({ workspace = "special:minimized", follow = false }))
    end
end)
-----------------

-- Eww
hl.bind(mainMod .. " + SHIFT + B", hl.dsp.exec_cmd(ewwScript .. " --launch-bar"))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(ewwScript .. " --toggle-bar"))
------
