-- require("telescope.builtin").git_branches(
-- require "neuron/telescope".find_zettels(opts)
-- require("telescope").extensions.z.list(opts)
-- _G.TelePreconfg(require("telescope").extensions.octo.live_prs, opts)


-- Dropdown list theme using a builtin theme definitions :
local dropdown = require "telescope.themes".get_dropdown({
  winblend = 20,
  -- layout_config = { width = 0.5 },
  -- results_height = 15,
  previewer = false,
  find_command = command_rg
}
)

local ivy = require "telescope.themes".get_ivy({
  winblend = 20,
  layout_config = { height = 15 },
  find_command = command_rg
})

local dropdown_preview = require "telescope.themes".get_dropdown({
  winblend = 20,
  prompt = " ",
  -- results_height = 15,
  layout_config = { width = 0.5 },
  find_command = command_rg
})

-- Settings for with preview option
local with_preview = {
  find_command = command_rg,
  winblend = 10,
  show_line = false,
  results_title = false,
  preview_title = false
  -- layout_config = { preview_width = 0.5 },
}

local modifyOptions = function(path, cmd, opts)
  return opts
end

-- _G._LoadTelescope = function(req_file, func_name)
--   --"telescope.builtin".oldfiles, opts)
--   --"telescope".extensions.frecency.frecency, opts)
--   print(req_file, func_name)
-- end

_G.LoadTelescope = function(modulePath, command, opts)
  vim.logger:info('loading: ' .. modulePath .. ', command: ' .. command)
  require(modulePath)[command](opts)
end
