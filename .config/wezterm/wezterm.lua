local general = require 'general'
local fonts = require 'fonts'
local keymaps = require 'keymaps'
local themes = require 'themes'
local tests = require 'tests'

local config = {}

general.apply_to_config(config)
fonts.apply_to_config(config)
keymaps.apply_to_config(config)
themes.apply_to_config(config)

return config
