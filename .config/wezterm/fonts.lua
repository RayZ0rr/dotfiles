local wezterm = require 'wezterm'

local module = {}

function module.apply_to_config(config)

    config.font_size = 12.0

    -- You can specify some parameters to influence the font selection;
    -- for example, this selects a Bold, Italic font variant.
    -- config.font = wezterm.font("JetBrains Mono", {weight="Bold", italic=true}),
    config.font = wezterm.font{
        -- family = "JetBrainsMono NF Light",
        family = "JetBrainsMono Nerd Font",
        -- weight = "Regular",
        -- style = "Normal",
        harfbuzz_features = {'zero', 'ss19'},
    }

    -- config.font = wezterm.font{
    --     family = "FiraCode Nerd Font",
    --     harfbuzz_features = {'ss08'},
    -- }
    -- config.font_rules = {
    --     {
    --         italic = true,
    --         intensity = 'Bold',
    --         font = wezterm.font {
    --             family = 'JetBrainsMono Nerd Font',
    --             weight = 'Bold',
    --             style = 'Italic',
    --         },
    --     },
    --     {
    --         italic = true,
    --         intensity = 'Half',
    --         font = wezterm.font {
    --             family = 'JetBrainsMono Nerd Font',
    --             weight = 'DemiBold',
    --             style = 'Italic',
    --         },
    --     },
    --     -- {
    --     --     italic = true,
    --     --     intensity = 'Normal',
    --     --     font = wezterm.font {
    --     --         family = 'VictorMono Nerd Font',
    --     --         style = 'Italic',
    --     --     },
    --     -- },
    --     {
    --         italic = true,
    --         intensity = 'Normal',
    --         font = wezterm.font {
    --             family = 'JetBrainsMono Nerd Font',
    --             style = 'Italic',
    --         },
    --     },
    -- }

end

-- return our module table
return module
