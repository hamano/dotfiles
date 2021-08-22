local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = require("beautiful.xresources").apply_dpi
local lain = require("lain")
local markup = lain.util.markup
local pprint = require("util.pprint")
local fs = require("gears.filesystem")

local conf_dir = gears.filesystem.get_configuration_dir()
local icon_dir = string.format("%s/icon/", conf_dir)
local icon = wibox.widget.imagebox()

local ac = "AC"
if fs.is_dir("/sys/class/power_supply/bq24190-charger") then
    ac = "bq24190-charger"
end

-- for Thinkpad
local battery
if fs.is_dir("/sys/class/power_supply/BAT0") then
  battery = "BAT0"
end
-- for GPD
if fs.is_dir("/sys/class/power_supply/max170xx_battery") then
  battery = "max170xx_battery"
end

local bat = lain.widget.bat({
    ac = ac,
    battery = battery,
    settings = function()
      --pprint(bat_now)
      if bat_now.perc == 'N/A' then
        icon_path = icon_dir .. 'round-battery-unknown.svg'
        icon:set_image(icon_path)
        widget:set_markup(markup.font(beautiful.font, 'N/A'))
        return
      end
      if bat_now.status == 'Charging' then
	charging = 'charging-'
      elseif bat_now.status == 'Full' then
	charging = 'charging-'
      else
	charging = ''
      end
      if bat_now.perc > 99 then
	icon_path = icon_dir .. 'round-battery-' .. charging .. 'full.svg'
      elseif bat_now.perc > 90 then
	icon_path = icon_dir .. 'round-battery-' .. charging .. '90.svg'
      elseif bat_now.perc > 80 then
	icon_path = icon_dir .. 'round-battery-' .. charging .. '80.svg'
      elseif bat_now.perc > 60 then
	icon_path = icon_dir .. 'round-battery-' .. charging .. '60.svg'
      elseif bat_now.perc > 50 then
	icon_path = icon_dir .. 'round-battery-' .. charging .. '50.svg'
      elseif bat_now.perc > 30 then
	icon_path = icon_dir .. 'round-battery-' .. charging .. '30.svg'
      else
	icon_path = icon_dir .. 'round-battery-' .. charging .. '20.svg'
      end
      icon:set_image(icon_path)
      local perc = bat_now.perc .. "% "
      widget:set_markup(markup.font(beautiful.font, perc))
    end
})

local margin = wibox.container.margin
local layout = wibox.layout.fixed.horizontal()
layout:add(margin(icon, dpi(4), 0, dpi(4), dpi(4)))
layout:add(margin(bat.widget, dpi(2), 0, dpi(2), 0))
return layout
