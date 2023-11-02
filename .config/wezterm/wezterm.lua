local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.use_ime = true
config.enable_scroll_bar = true

config.color_scheme = 'GruvboxDark'
config.font = wezterm.font_with_fallback {
  'UDEV Gothic NF',
  'Noto Emoji',
  'Symbola',
}
config.font_size = 16.0

-- and finally, return the configuration to wezterm
return config
