local wezterm = require 'wezterm';
return {
  font = wezterm.font("FiraCode Nerd Font Mono"),
  font_size = 10.0,
  -- You can specify some parameters to influence the font selection;
  -- for example, this selects a Bold, Italic font variant.
  -- font = wezterm.font("JetBrains Mono", {weight="Bold", italic=true}),
  color_scheme = "Gruvbox Dark",
  default_prog = {"/usr/bin/bash"},
  window_decorations = "NONE",
  enable_scroll_bar = false,
  scrollback_lines = 3500,
  -- set to false to disable the tab bar completely
  enable_tab_bar = true,
  -- set to true to hide the tab bar when there is only
  -- a single tab in the window
  hide_tab_bar_if_only_one_tab = true,
}
