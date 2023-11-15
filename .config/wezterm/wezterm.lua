local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.use_ime = true
config.font = wezterm.font_with_fallback {
  'UDEV Gothic NF',
  'Noto Emoji',
  'Symbola',
}
config.font_size = 16.0
config.keys = require 'keys'.keys
config.enable_scroll_bar = true
config.check_for_updates = false
config.selection_word_boundary = '{}[]()"\'`,;: 　'
config.window_padding = {
  left = 16,
  right = 16,
  top = 0,
  bottom = 0,
}

config.color_scheme = 'GruvboxDark'
local scheme = wezterm.get_builtin_color_schemes()[config.color_scheme]
config.colors = {
    scrollbar_thumb = scheme["foreground"]
}
config.treat_east_asian_ambiguous_width_as_wide = true
-- config.pane_focus_follows_mouse = true
-- config.debug_key_events = true
return config
