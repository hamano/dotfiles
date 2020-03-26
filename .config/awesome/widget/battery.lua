local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = require("beautiful.xresources").apply_dpi
local lain = require("lain")
local markup = lain.util.markup
local pprint = require("util.pprint")

local conf_dir = gears.filesystem.get_configuration_dir()
local icon_dir = string.format("%s/icon/", conf_dir)
local icon = wibox.widget.imagebox()
local bat = lain.widget.bat({
    settings = function()
      pprint(bat_now)
      if bat_now.ac_status == 1 then
	icon_path = icon_dir .. "battery-charging.svg"
      else
	icon_path = icon_dir .. "battery-full.svg"
      end
      icon:set_image(icon_path)
      local perc = bat_now.perc .. "% "
      widget:set_markup(markup.font(beautiful.font, perc))
    end
})

local layout = wibox.layout.fixed.horizontal()
layout:add(wibox.container.margin(icon, dpi(6), dpi(2), dpi(4), dpi(4)))
layout:add(wibox.container.margin(bat.widget, 0, 0, dpi(1), 0))
return layout
