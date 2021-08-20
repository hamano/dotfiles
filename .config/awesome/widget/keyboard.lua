local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = require("beautiful.xresources").apply_dpi

local conf_dir = gears.filesystem.get_configuration_dir()
local icon_dir = string.format("%s/icon/", conf_dir)
local icon = wibox.widget.imagebox()
icon:set_image(icon_dir .. "outline-keyboard.svg")
local keyboard = awful.widget.keyboardlayout()
local layout = wibox.layout.fixed.horizontal()
layout:add(wibox.container.margin(icon, dpi(4), 0, dpi(4), dpi(4)))
layout:add(keyboard)
return layout
