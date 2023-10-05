local wezterm = require 'wezterm';
return {
  font = wezterm.font{
    family = "JetBrainsMono Nerd Font",
    weight = "Regular",
    style = "Normal"
  },
  font_size = 12.0,
  -- You can specify some parameters to influence the font selection;
  -- for example, this selects a Bold, Italic font variant.
  -- font = wezterm.font("JetBrains Mono", {weight="Bold", italic=true}),
  -- color_scheme = "Classic Dark (base16)",
  -- color_scheme = "Pnevma",
  -- color_scheme = "Dracula (Official)",
  color_scheme = "Paradise",
  default_prog = {"zsh"},
  window_decorations = "NONE",
  window_background_opacity = 0.9,
  text_background_opacity = 1.0,
  warn_about_missing_glyphs = false,
  window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
  },
  enable_scroll_bar = false,
  scrollback_lines = 5000,
  -- set to false to disable the tab bar completely
  enable_tab_bar = true,
  -- set to true to hide the tab bar when there is only
  -- a single tab in the window
  hide_tab_bar_if_only_one_tab = true,
  -- timeout_milliseconds defaults to 1000 and can be omitted
  leader = { key = 'w', mods = 'ALT', timeout_milliseconds = 1000 },
  keys = {
    {
      key = '|',
      mods = 'LEADER|SHIFT',
      action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
    },
    -- {
    --   key = '_',
    --   mods = 'CTRL',
    --   action = wezterm.action.DisableDefaultAssignment,
    -- },
  },
}
