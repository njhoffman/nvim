-- https://raw.githubusercontent.com/nvim-telescope/telescope.nvim/master/README.md
local actions_layout = require("telescope.actions.layout")
local actions = require("telescope.actions")
local custom = require("plugs.config.telescope.custom")

local send_to_qflist = function(prompt_bufnr)
  actions.send_to_qflist(prompt_bufnr)
  actions.open_qflist(prompt_bufnr)
  actions.center(prompt_bufnr)
end

local select_default = function(prompt_bufnr)
  actions.select_default(prompt_bufnr)
  actions.center(prompt_bufnr)
end

local backspace_word = function(prompt_bufnr)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-w>", true, true, true), "i", true)
end

local main = function()
  -- stylua: ignore
  return {
    i = {
      ["<C-u>"]     = backspace_word,
      ["<C-d>"]     = actions.close,
      ["<Esc>"]     = actions.close,
      ["<C-Down>"]  = actions.cycle_history_next,
      ["<C-Up>"]    = actions.cycle_history_prev,
      ["<Down>"]    = actions.preview_scrolling_down,
      ["<Up>"]      = actions.preview_scrolling_up,
      ["<C-f>"]     = custom.actions.results_page_down,
      ["<C-b>"]     = custom.actions.results_page_up,
      ["<M-Down>"]  = custom.actions.results_toggle_down,
      ["<M-Up>"]    = custom.actions.results_toggle_up,
      ["<C-q>"]     = send_to_qflist,
      ["<C-_>"]     = actions_layout.toggle_preview,
      ["<M-/>"]     = custom.actions.toggle_whichkey,
      ["<M-}>"]     = custom.actions.switch_picker,
      ["<C-^>"]     = custom.actions.switch_layout,
      ["<M-a>"]     = actions.toggle_all,
      ["<C-Space>"] = custom.actions.find_pickers,
      ["<CR>"]      = select_default

    },
    n = {
      ["<Esc>"] = actions.close,
    },
  }
end

local file = function()
  return {
    i = {
      -- change directory functionality
      ["<M-.>"] = custom.actions.launch_dirpicker,
      ["<M-,>"] = custom.actions.directory_up,
      ["<CR>"] = custom.actions.multi_open,
    },
  }
end

local mappings = {
  main = main,
  file = file,
}

return mappings
