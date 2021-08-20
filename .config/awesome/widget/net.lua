local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = require("beautiful.xresources").apply_dpi
local lain = require("lain")
local markup = lain.util.markup
local font = beautiful.font
local conf_dir = gears.filesystem.get_configuration_dir()
local icon_dir = string.format("%s/icon/", conf_dir)
local up_icon = wibox.widget.imagebox(icon_dir.."upload-outlined.svg")
local down_icon = wibox.widget.imagebox(icon_dir.."download-outlined.svg")
local pprint = require("util.pprint")

local up_text = wibox.widget.textbox()
local down_text = wibox.widget.textbox()
local net_update = function()
  up_text.text = string.format("%.3fMbps", net_now.sent / 1024 * 8)
  down_text.text = string.format("%.3fMbps", net_now.received / 1024 * 8)
end
local net = lain.widget.net {settings = net_update}
local layout = wibox.layout.fixed.horizontal()
layout:add(net.widget)
layout:add(wibox.container.margin(down_icon, dpi(4), 0, dpi(4), dpi(4)))
layout:add(wibox.container.margin(down_text, dpi(2), 0, dpi(2), 0))
layout:add(wibox.container.margin(up_icon, dpi(4), 0, dpi(4), dpi(4)))
layout:add(wibox.container.margin(up_text, dpi(2), 0, dpi(2), 0))

return layout
