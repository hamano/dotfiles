local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = require("beautiful.xresources").apply_dpi
local font = beautiful.font
local lain = require("lain")
local markup = lain.util.markup
local fs = require("gears.filesystem")
local pprint = require("util.pprint")
local hostname = require("util.hostname")

local conf_dir = gears.filesystem.get_configuration_dir()
local icon_dir = string.format("%s/icon/", conf_dir)
local icon = wibox.widget.imagebox(icon_dir .. "temperature.svg")
local fs = require("gears.filesystem")

local host = hostname()

local tempfile
-- for Intel
if fs.file_readable('/sys/devices/virtual/thermal/thermal_zone0/temp') then
  tempfile = '/sys/devices/virtual/thermal/thermal_zone0/temp'
end
-- for Thinkpad AMD
if fs.file_readable('/sys/devices/platform/thinkpad_hwmon/hwmon/hwmon4/temp1_input') then
  tempfile = '/sys/devices/platform/thinkpad_hwmon/hwmon/hwmon4/temp1_input'
end
-- for GPD
if host == 'gpd' then
  tempfile = '/sys/devices/virtual/thermal/thermal_zone6/temp'
end

local temp = lain.widget.temp {
  tempfile = tempfile,
  settings = function()
--    now = math.floor(coretemp_now)
    now = coretemp_now
    if type(now) == "number" then
      widget:set_markup(markup.font(font, string.format("%d℃", now)))
    else
      widget:set_markup(markup.font(font, now))
    end
  end
}

local layout = wibox.layout.fixed.horizontal()
layout:add(wibox.container.margin(icon, dpi(4), 0, dpi(4), dpi(4)))
layout:add(wibox.container.margin(temp.widget, 0, dpi(4), 0, 0))
return layout
