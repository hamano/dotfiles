local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = require("beautiful.xresources").apply_dpi
local conf_dir = gears.filesystem.get_configuration_dir()
local icon_dir = string.format("%s/icon/", conf_dir)
local icon = wibox.widget.imagebox(icon_dir.."baseline-access-time.svg")
local clock = wibox.widget.textclock("%H:%M")
local margin = wibox.container.margin
local layout = wibox.layout.fixed.horizontal()
layout:add(margin(icon, dpi(4),0, dpi(4), dpi(4)))
layout:add(margin(clock, dpi(2), 0, dpi(2), 0))
return layout;
