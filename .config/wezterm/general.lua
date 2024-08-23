local wezterm = require 'wezterm'

local module = {}

function module.apply_to_config(config)

    config.default_prog = {"zsh"}
    config.window_decorations = "NONE"
    config.window_background_opacity = 0.9
    config.text_background_opacity = 1.0
    config.warn_about_missing_glyphs = false
    config.window_padding = {
        left = 0,
        right = 0,
        top = 0,
        bottom = 0,
    }
    config.enable_scroll_bar = false
    config.scrollback_lines = 5000
    -- set to false to disable the tab bar completely
    config.enable_tab_bar = true
    -- set to true to hide the tab bar when there is only
    -- a single tab in the window
    config.hide_tab_bar_if_only_one_tab = true

    -- config.enable_kitty_keyboard = true
    -- config.enable_csi_u_key_encoding = true
end

-- return our module table
return module
