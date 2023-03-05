-- https://raw.githubusercontent.com/nvim-telescope/telescope.nvim/master/README.md
local actions_layout = require("telescope.actions.layout")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local custom = require("plugs.config.telescope.custom")

local dirpicker = require("plugs.config.telescope.dirpicker")

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

local mainMaps = {
  -- stylua: ignore
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
    ["<M-n>"]     = custom.actions.results_toggle_down,
    ["<M-p>"]     = custom.actions.results_toggle_up,
    ["<C-q>"]     = send_to_qflist,
    ["<C-_>"]     = actions_layout.toggle_preview,
    ["<M-/>"]     = custom.actions.toggle_whichkey,
    ["<M-}>"]     = custom.actions.switch_picker,
    ["<C-^>"]     = custom.actions.switch_layout,
    ["<M-a>"]     = actions.toggle_all,
    ["<C-Space>"] = custom.actions.find_pickers,
    ["<CR>"]      = select_default,
    -- [F1-9] = set primary sort if # not set, toggle primary/secondary if set
    -- [S-F1-9] = add/remove secondary sort #
    -- [??] = clear sort
  },
  n = {
    ["<Esc>"] = actions.close,
  },
}

local launch_dirpicker = function(bufnr)
  local current_picker = action_state.get_current_picker(bufnr) -- picker state
  local picker_title = current_picker.prompt_title

  local opts = {}
  opts.result_title = "Choose Directory"
  local dirpicker_mappings = {
    default = function(directory)
      opts.cwd = directory
      opts.results_title = string.gsub(directory, os.getenv("HOME") or "", "~")
      if picker_title == "Find Files" then
        pcall(require("telescope.builtin").find_files, opts)
      elseif string.find(picker_title, "%^Grep") then
        pcall(require("telescope.builtin").live_grep, opts)
      else
        vim.notify("Error: don't know what picker to open: " .. picker_title)
      end
    end,
  }

  opts.mappings = dirpicker_mappings
  pcall(dirpicker.run, opts)
end

local fileMaps = {
  i = {
    -- change directory functionality
    ["<M-.>"] = launch_dirpicker,
    ["<M-,>"] = custom.actions.directory_up,
    ["<CR>"] = custom.actions.multi_open,
  },
}
local mappings = {
  main = mainMaps,
  file_picker = fileMaps,
}
return mappings
