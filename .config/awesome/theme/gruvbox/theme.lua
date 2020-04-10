local gears = require("gears")
local fg0    = "#fbf1c7";
local fg1    = "#ebdbb2";
local fg2    = "#d5c4a1";
local fg3    = "#bdae93";
local fg4    = "#a89984";
local bg0    = "#282828";
local bg1    = "#3c3836";
local bg2    = "#504945";
local bg3    = "#665c54";
local bg4    = "#7c6f64";
local gray   = "#928374";
local fg     = "#ebdbb2";

local bg     = "#282828"
local red    = "#cc241d"
local green  = "#98971a"
local yellow = "#d79921"
local blue   = "#458588"
local purple = "#b16286"
local aqua   = "#689d61"

local b_blue = "#83a598"

local b_aqua = "#8ec07c"

local dpi = require("beautiful.xresources").apply_dpi
theme = dofile("/usr/share/awesome/themes/zenburn/theme.lua");
theme.font      = "Ricty 11";

local bg_normal = bg4
local bg_focus = bg2

--local bg_normal = b_aqua
--local bg_focus = aqua

-- {{{ Colors
theme.fg_normal  = fg2
theme.fg_focus   = bg0
theme.fg_urgent  = fg0
theme.bg_normal  = bg
theme.bg_focus   = gray
theme.bg_urgent  = red
theme.bg_systray = bg
-- }}}

-- {{{ Borders
theme.useless_gap   = dpi(0)
theme.border_width  = dpi(2)
theme.border_normal = bg_normal
theme.border_focus  = bg2
theme.border_marked = yellow;
-- }}}

-- {{{ Titlebars
theme.titlebar_bg_focus  = gray
theme.titlebar_bg_normal = bg
theme.titlebar_fg_focus  = bg0
-- }}}

local conf_dir = gears.filesystem.get_configuration_dir()
local icon_dir = string.format("%s/theme/gruvbox/", conf_dir)
theme.titlebar_close_button_normal = icon_dir .. "close_normal.png"
theme.titlebar_close_button_focus  = icon_dir .. "close_focus.png"

theme.titlebar_minimize_button_normal = icon_dir .. "minimize_normal.png"
theme.titlebar_minimize_button_focus  = icon_dir .. "minimize_focus.png"

return theme;
