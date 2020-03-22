local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = require("beautiful.xresources").apply_dpi

local conf_dir = gears.filesystem.get_configuration_dir()
local icon_dir = string.format("%s/icon/", conf_dir)
local calendar_icon = wibox.widget.imagebox(icon_dir.."outline-calendar-today.svg")
local calendar = wibox.widget.textclock("%b %d %a")
local clock_icon = wibox.widget.imagebox(icon_dir.."baseline-access-time.svg")
local clock = wibox.widget.textclock("%H:%M")

local layout = wibox.layout.fixed.horizontal()
layout:add(wibox.container.margin(calendar_icon, dpi(4), dpi(2), dpi(4), dpi(4)))
layout:add(wibox.container.margin(calendar, 0, 0, dpi(1.5), 0))
layout:add(wibox.container.margin(clock_icon, dpi(4), dpi(2), dpi(4), dpi(4)))
layout:add(wibox.container.margin(clock, 0, 0, dpi(1.5), 0))
return layout;
