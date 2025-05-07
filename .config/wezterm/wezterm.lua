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
  { family = 'EAW CONSOLE' },
  { family = 'EAW CONSOLE', assume_emoji_presentation = true },
}

config.font_size = 16.0
config.keys = require 'keys'.keys
config.enable_scroll_bar = true
config.check_for_updates = false
config.selection_word_boundary = '{}[]()"\'`,;: 　'
config.window_padding = {
  left = 4,
  right = 4,
  top = 0,
  bottom = 0,
}

config.color_scheme = 'GruvboxDark'
local scheme = wezterm.get_builtin_color_schemes()[config.color_scheme]
config.colors = {
    scrollbar_thumb = scheme["foreground"]
}

-- config.treat_east_asian_ambiguous_width_as_wide = true
config.cell_widths = require 'eaw-console'

-- config.cell_widths = {
--   {first = 0x1F604, last = 0x1F604, width = 2}, -- smile
--   {first = 0x2460, last = 0x2473, width = 2}, -- ①..⑳
--   {first = 0x24EA, last = 0x24EA, width = 2}, -- ⓪
--   {first = 0x2668, last = 0x2668, width = 2}, -- ♨
--   {first = 0xE000, last = 0xF8FF, width = 2}, -- Private Use Area
--   {first = 0xF0000, last = 0xF2000, width = 2}, -- Last of Nerdfont
-- }

-- config.pane_focus_follows_mouse = true
-- config.debug_key_events = true

-- from https://github.com/wez/wezterm/issues/3803
config.hyperlink_rules = {
  -- Matches: a URL in parens: (URL)
  {
    regex = '\\((\\w+://\\S+)\\)',
    format = '$1',
    highlight = 1,
  },
  -- Matches: a URL in brackets: [URL]
  {
    regex = '\\[(\\w+://\\S+)\\]',
    format = '$1',
    highlight = 1,
  },
  -- Matches: a URL in curly braces: {URL}
  {
    regex = '\\{(\\w+://\\S+)\\}',
    format = '$1',
    highlight = 1,
  },
  -- Matches: a URL in angle brackets: <URL>
  {
    regex = '<(\\w+://\\S+)>',
    format = '$1',
    highlight = 1,
  },
  -- Then handle URLs not wrapped in brackets
  {
    -- Before
    --regex = '\\b\\w+://\\S+[)/a-zA-Z0-9-]+',
    --format = '$0',
    -- After
    regex = '[^(]\\b(\\w+://\\S+[)/a-zA-Z0-9-]+)',
    format = '$1',
    highlight = 1,
  },
  -- implicit mailto link
  {
    regex = '\\b\\w+@[\\w-]+(\\.[\\w-]+)+\\b',
    format = 'mailto:$0',
  },
}
return config
