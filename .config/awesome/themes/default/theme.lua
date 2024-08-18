local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local themes_path = os.getenv("HOME") .. "/.config/awesome/themes/"
local theme = {}
local gears = require("gears")

theme.font = "sans 8"

theme.bg_normal = "#090311"
theme.bg_focus = "#1C0932"
theme.bg_urgent = "#ff0000"
theme.bg_minimize = "#444444"
theme.bg_systray = theme.bg_normal

theme.fg_normal = "#646464"
theme.fg_focus = "#D0D0D0"
theme.fg_urgent = "#ffffff"
theme.fg_minimize = "#ffffff"

theme.useless_gap = dpi(4)
theme.border_width = dpi(1)
theme.border_normal = "#090311"
theme.border_focus = "#1C0932"
theme.border_marked = "#23265A"
theme.primary = "#6268D8"
theme.secondary = "#23265A"
theme.notification_opacity = "100"
theme.notification_icon_size = 80
theme.notification_bg = "(0,0,0)"
theme.notification_fg = "#d4be98"

theme.taglist_squares_sel = themes_path .. "default/taglist/squire_focus.png"
theme.taglist_squares_unsel = themes_path .. "default/taglist/squire_normal_active.png"

theme.menu_submenu_icon = themes_path .. "default/submenu.png"
theme.menu_height = dpi(15)
theme.menu_width = dpi(100)

theme.titlebar_close_button_normal = themes_path .. "default/titlebar/close_normal.png"
theme.titlebar_close_button_focus = themes_path .. "default/titlebar/close_focus.png"

theme.titlebar_minimize_button_normal = themes_path .. "default/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus = themes_path .. "default/titlebar/minimize_focus.png"

theme.titlebar_ontop_button_normal_inactive = themes_path .. "default/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive = themes_path .. "default/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = themes_path .. "default/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active = themes_path .. "default/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = themes_path .. "default/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive = themes_path .. "default/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = themes_path .. "default/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active = themes_path .. "default/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = themes_path .. "default/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive = themes_path .. "default/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = themes_path .. "default/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active = themes_path .. "default/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = themes_path .. "default/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive = themes_path .. "default/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = themes_path .. "default/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active = themes_path .. "default/titlebar/maximized_focus_active.png"

theme.wallpaper = themes_path .. "default/background.jpg"

theme.layout_fairh = themes_path .. "default/layouts/fairh.png"
theme.layout_fairv = themes_path .. "default/layouts/fairv.png"
theme.layout_floating = themes_path .. "default/layouts/floating.png"
theme.layout_magnifier = themes_path .. "default/layouts/magnifier.png"
theme.layout_max = themes_path .. "default/layouts/max.png"
theme.layout_fullscreen = themes_path .. "default/layouts/fullscreen.png"
theme.layout_tilebottom = themes_path .. "default/layouts/tilebottom.png"
theme.layout_tileleft = themes_path .. "default/layouts/tileleft.png"
theme.layout_tile = themes_path .. "default/layouts/tile.png"
theme.layout_tiletop = themes_path .. "default/layouts/tiletop.png"
theme.layout_spiral = themes_path .. "default/layouts/spiral.png"
theme.layout_dwindle = themes_path .. "default/layouts/dwindle.png"
theme.layout_cornernw = themes_path .. "default/layouts/cornernw.png"
theme.layout_cornerne = themes_path .. "default/layouts/cornerne.png"
theme.layout_cornersw = themes_path .. "default/layouts/cornersw.png"
theme.layout_cornerse = themes_path .. "default/layouts/cornerse.png"

theme.awesome_icon = themes_path .. "default/awesome_icon.png"

theme.icon_theme = nil

return theme
