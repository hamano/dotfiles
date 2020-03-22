local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = require("beautiful.xresources").apply_dpi
local font = beautiful.font
local lain = require("lain")
local markup = lain.util.markup

local conf_dir = gears.filesystem.get_configuration_dir()
local icon_dir = string.format("%s/icon/", conf_dir)
local icon = wibox.widget.imagebox(icon_dir .. "temperature.svg")

local temp = lain.widget.temp {
  settings = function()
    now = math.floor(coretemp_now)
    widget:set_markup(markup.font(font, string.format("%d%%", now)))
  end
}

local layout = wibox.layout.fixed.horizontal()
layout:add(wibox.container.margin(icon, dpi(4), 0, dpi(4), dpi(4)))
layout:add(wibox.container.margin(temp.widget, 0, 0, dpi(1.5), 0))
return layout
