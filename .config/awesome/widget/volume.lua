local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local font = beautiful.font
local dpi = require("beautiful.xresources").apply_dpi
local lain = require("lain")
local markup = lain.util.markup
local conf_dir = gears.filesystem.get_configuration_dir()
local icon_dir = string.format("%s/icon/", conf_dir)
local volume_icon = wibox.widget.imagebox()
local volume_high_icon = icon_dir.."volume-high.svg"
local volume_mute_icon = icon_dir.."volume-mute.svg"
local pprint = require("util.pprint")
local volume_device = wibox.widget.textbox()

local volume = lain.widget.pulse {
  devicetype = "sink",
  settings = function()
    volume_device.text = volume_now.device
    if volume_now.left == volume_now.right then
      vlevel = volume_now.left.."% "
    else
      vlevel = volume_now.left.."-"..volume_now.right.."%"
    end
    if volume_now.muted == "yes" then
      volume_icon.image = volume_mute_icon
    else
      volume_icon.image = volume_high_icon
    end
    widget:set_markup(lain.util.markup.font(font, vlevel))
  end
}

local change_sink = function()
  local proc = io.popen("pacmd list-sinks | grep index:")
  local sinks = {}
  local defaultindex = 1
  for line in proc:lines() do
    asterisk = string.match(line, "^%s**")
    index = string.match(line, "index:%s*(%d+)")
    table.insert(sinks, index)
    if asterisk then
      defualtindex = #sinks
    end
  end
  proc:close()
  local nextindex = defualtindex + 1
  if nextindex > #sinks then
    nextindex = 1
  end
  local next = sinks[nextindex]
  os.execute(string.format("pactl set-default-sink %d", next))
  volume.update()
end

local layout = wibox.layout.fixed.horizontal()
layout:buttons(
  awful.util.table.join(
    awful.button({}, 1, function() -- left click
        os.execute(string.format("pactl set-sink-mute %s toggle", volume.device))
        volume.update()
    end),
    awful.button({}, 2, function() -- middle click
        os.execute(string.format("pactl set-sink-volume %s 100%%", volume.device))
        volume.update()
    end),
    awful.button({}, 3, function() -- right click
        awful.spawn("pavucontrol")
    end),
    awful.button({}, 4, function() -- scroll up
        os.execute(string.format("pactl set-sink-volume %s +5%%", volume.device))
        volume.update()
    end),
    awful.button({}, 5, function() -- scroll down
        os.execute(string.format("pactl set-sink-volume %s -5%%", volume.device))
        volume.update()
    end),
    awful.button({"Mod4"}, 1, function() -- Mod+left click
	change_sink()
    end)
))

layout:add(wibox.container.margin(volume_icon, dpi(4), dpi(2), dpi(4), dpi(4)))
layout:add(wibox.container.margin(volume.widget, 0, 0, dpi(1.5), 0))
layout:add(wibox.container.margin(volume_device, 0, 0, dpi(1.5), 0))
return layout;
