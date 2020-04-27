local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local lain = require("lain")
local dpi = require("beautiful.xresources").apply_dpi
local conf_dir = gears.filesystem.get_configuration_dir()
local icon_dir = string.format("%s/icon/", conf_dir)
local icon = wibox.widget.imagebox(icon_dir.."outline-calendar-today.svg")
local calendar = wibox.widget.textclock("%b %d %a")

local margin = wibox.container.margin
local layout = wibox.layout.fixed.horizontal()
layout:add(margin(icon, dpi(2), dpi(2), dpi(4), dpi(4)))
layout:add(margin(calendar, 0, dpi(2), dpi(2), 0))
layout.lainwidget = lain.widget.cal {
  attach_to = { layout },
  notification_preset = {
    font = theme.font,
    fg   = theme.fg_normal,
    bg   = theme.bg_normal
  }
}
return layout;
