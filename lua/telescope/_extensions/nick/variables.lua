local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local finders = require "telescope.finders"
local make_entry = require "telescope.make_entry"
local Path = require "plenary.path"
local pickers = require "telescope.pickers"
local utils = require "telescope.utils"

local conf = require("telescope.config").values

nick.variables = function(opts)
  -- Load vim options.
  local vim_opts = loadfile(Path:new({ utils.data_directory(), "options", "options.lua" }):absolute())().option

  pickers.new(opts, {
    prompt_title = "options",
    finder = finders.new_table {
      results = vim_opts,
      entry_maker = opts.entry_maker or make_entry.gen_from_vimoptions(opts),
    },
    -- TODO: previewer for Vim options
    -- previewer = previewers.help.new(opts),
    sorter = conf.generic_sorter(opts),
    attach_mappings = function()
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        if selection == nil then
          utils.__warn_no_selection "builtin.vim_options"
          return
        end

        local esc = ""
        if vim.fn.mode() == "i" then
          -- TODO: don't make this local
          esc = vim.api.nvim_replace_termcodes("<esc>", true, false, true)
        end

        -- TODO: Make this actually work.

        -- actions.close(prompt_bufnr)
        -- vim.api.nvim_win_set_var(vim.api.nvim_get_current_win(), "telescope", 1)
        -- print(prompt_bufnr)
        -- print(vim.fn.bufnr())
        -- vim.cmd([[ autocmd BufEnter <buffer> ++nested ++once startinsert!]])
        -- print(vim.fn.winheight(0))

        -- local prompt_winnr = vim.fn.getbufinfo(prompt_bufnr)[1].windows[1]
        -- print(prompt_winnr)

        -- local float_opts = {}
        -- float_opts.relative = "editor"
        -- float_opts.anchor = "sw"
        -- float_opts.focusable = false
        -- float_opts.style = "minimal"
        -- float_opts.row = vim.api.nvim_get_option("lines") - 2 -- TODO: inc `cmdheight` and `laststatus` in this calc
        -- float_opts.col = 2
        -- float_opts.height = 10
        -- float_opts.width = string.len(selection.last_set_from)+15
        -- local buf = vim.api.nvim_create_buf(false, true)
        -- vim.api.nvim_buf_set_lines(buf, 0, 0, false,
        --                           {"default value: abcdef", "last set from: " .. selection.last_set_from})
        -- local status_win = vim.api.nvim_open_win(buf, false, float_opts)
        -- -- vim.api.nvim_win_set_option(status_win, "winblend", 100)
        -- vim.api.nvim_win_set_option(status_win, "winhl", "Normal:PmenuSel")
        -- -- vim.api.nvim_set_current_win(status_win)
        -- vim.cmd[[redraw!]]
        -- vim.cmd("autocmd CmdLineLeave : ++once echom 'beep'")
        vim.api.nvim_feedkeys(string.format("%s:set %s=%s", esc, selection.name, selection.current_value), "m", true)
      end)

      return true
    end,
  }):find()
end
