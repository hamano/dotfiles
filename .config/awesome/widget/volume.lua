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
local volume_medium_icon = icon_dir.."volume-medium.svg"
local volume_low_icon = icon_dir.."volume-low.svg"
local volume_off_icon = icon_dir.."volume-off.svg"
local volume_mute_icon = icon_dir.."volume-mute.svg"
local pprint = require("util.pprint")
local volume_device = wibox.widget.textbox()

local volume = lain.widget.pulse {
  devicetype = "sink",
  settings = function()
    volume_device.text = volume_now.device
    volume_level_left = tonumber(volume_now.left)
    volume_level_right = tonumber(volume_now.right)
    if volume_level_left == nil or volume_level_right == nil then
      return
    end
    volume_level = (volume_level_left + volume_level_right) / 2
    volume_level_text = string.format("%3d%% ", volume_level)
    if volume_level > 100 then
      volume_icon.image = volume_high_icon
    elseif volume_level > 50 then
      volume_icon.image = volume_medium_icon
    elseif volume_level > 0 then
      volume_icon.image = volume_low_icon
    else
      volume_icon.image = volume_off_icon
    end

    if volume_now.muted == "yes" then
      volume_icon.image = volume_mute_icon
    end
    widget:set_markup(lain.util.markup.font(font, volume_level_text))
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

local l1 = wibox.layout.fixed.horizontal()
l1:buttons(
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

volume_device:buttons(
  awful.util.table.join(
    awful.button({}, 1, function() -- left click
	change_sink()
    end)
))

l1:add(wibox.container.margin(volume_icon, dpi(4), dpi(2), dpi(4), dpi(4)))
l1:add(wibox.container.margin(volume.widget, 0, 0, dpi(1.5), 0))

local layout = wibox.layout.fixed.horizontal()
layout:add(l1)
layout:add(wibox.container.margin(volume_device, 0, 0, dpi(1.5), 0))
return layout;
