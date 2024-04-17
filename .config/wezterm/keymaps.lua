local wezterm = require 'wezterm'

local module = {}

function module.apply_to_config(config)

    -- timeout_milliseconds defaults to 1000 and can be omitted
    config.leader = { key = 'w', mods = 'ALT', timeout_milliseconds = 1000 }
    config.keys = {
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
    }

end

-- return our module table
return module
