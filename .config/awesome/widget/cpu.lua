local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = require("beautiful.xresources").apply_dpi
local lain = require("lain")
local markup = lain.util.markup
local font = beautiful.font
local conf_dir = gears.filesystem.get_configuration_dir()
local icon_dir = string.format("%s/icon/", conf_dir)
local cpu_icon = wibox.widget.imagebox(icon_dir .. "bx-chip.svg")
local mem_icon = wibox.widget.imagebox(icon_dir .. "bx-microchip.svg")

local cpu = lain.widget.cpu {
  settings = function()
    widget:set_markup(markup.font(font, string.format("%3d%% ", cpu_now.usage)))
  end
}

local mem = lain.widget.mem {
  settings = function()
    widget:set_markup(markup.font(font, string.format("%3d%%", mem_now.perc)))
  end
}

local layout = wibox.layout.fixed.horizontal()
layout:add(wibox.container.margin(cpu_icon, dpi(4), 0, dpi(4), dpi(4)))
layout:add(wibox.container.margin(cpu.widget, dpi(2), 0, dpi(2), 0))
layout:add(wibox.container.margin(mem_icon, dpi(4), 0, dpi(4), dpi(4)))
layout:add(wibox.container.margin(mem.widget, dpi(2), 0, dpi(2), 0))
return layout
