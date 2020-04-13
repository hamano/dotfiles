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

local bg = bg0;
local fg = fg1;

-- 16 colors
local black   = "#282828";
local red     = "#cc241d";
local green   = "#98971a";
local yellow  = "#d79921";
local blue    = "#458588";
local purple  = "#b16286";
local aqua    = "#689d61";
local white   = "#a89984";
local b_black = "#928374";
local b_red   = "#fb4934";
local b_green = "#b8bb26";
local b_yellow= "#fabd2f";
local b_blue  = "#83a598";
local b_purple= "#d3869b";
local b_aqua  = "#8ec07c";
local b_white = "#ebdbb2";

-- orange
local orange  = "#d65d0e";
local b_orange= "#fe8019";

local dpi = require("beautiful.xresources").apply_dpi
theme = dofile("/usr/share/awesome/themes/zenburn/theme.lua");
theme.font      = "Ricty 11";

local fg_focus  = fg
local bg_focus = bg
local fg_normal = fg3
local bg_normal = bg1

theme.bg_focus   = bg_focus
theme.bg_normal  = bg_normal
theme.fg_focus   = fg_focus
theme.fg_normal  = fg_normal
theme.bg_urgent  = orange
theme.bg_systray = bg_focus

-- {{{ Borders
theme.useless_gap   = dpi(0)
theme.border_width  = dpi(1)
theme.border_normal = fg_normal
theme.border_focus  = fg_focus
theme.border_marked = yellow;
-- }}}

-- {{{ Titlebars
theme.titlebar_bg_focus  = bg_focus
theme.titlebar_bg_normal = bg_normal
theme.titlebar_fg_focus  = fg_focus
theme.titlebar_fg_normal  = fg_normal
-- }}}

local conf_dir = gears.filesystem.get_configuration_dir()
local theme_path = string.format("%s/theme/gruvbox/", conf_dir)
theme.titlebar_close_button_normal = theme_path .. "close_normal.png"
theme.titlebar_close_button_focus  = theme_path .. "close_focus.png"

theme.titlebar_minimize_button_normal = theme_path .. "minimize_normal.png"
theme.titlebar_minimize_button_focus  = theme_path .. "minimize_focus.png"

theme.titlebar_maximized_button_focus_active  = theme_path .. "maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active = theme_path .. "maximized_normal_active.png"
theme.titlebar_maximized_button_focus_inactive  = theme_path .. "maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive = theme_path .. "maximized_normal_inactive.png"

return theme;
