local wezterm = require 'wezterm'

local module = {}

function module.apply_to_config(config)

  -- config.color_scheme = "Classic Dark (base16)"
  -- config.color_scheme = "Pnevma"
  -- config.color_scheme = "Dracula (Official)"
  config.color_scheme = 'Batman'
  config.color_scheme = "Paradise"

end

-- return our module table
return module

