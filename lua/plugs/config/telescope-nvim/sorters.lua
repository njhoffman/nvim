local utils = require("telescope.utils")

local M = {}
M.frecency_score = function(self, prompt, line, entry)
  if prompt == nil or prompt == "" then
    for _, file_entry in ipairs(self.state.frecency) do
      local filepath = entry.cwd .. "/" .. entry.value
      if file_entry.filename == filepath then
        return 9999 - file_entry.score
      end
    end

    return 9999
  end

  return self.default_scoring_function(self, prompt, line, entry)
end

M.frecency_start = function(self, prompt)
  self.default_start(self, prompt)
  if not self.state.frecency then
    self.state.frecency = M.frecency_db.get_file_scores()
  end
end

local frecency_sorter = function(opts)
  local fzf_sorter = M.fzf.native_fzf_sorter()

  fzf_sorter.default_scoring_function = fzf_sorter.scoring_function
  fzf_sorter.default_start = fzf_sorter.start

  fzf_sorter.scoring_function = frecency_score
  fzf_sorter.start = M.frecency_start

  return fzf_sorter
end

M.search_dotfiles = function()
  _telescope.find_files({
    prompt_title = "Dotfiles",
    cwd = "~",
  })
end

-- custom function for lsp_references entries
M._qf_as_filenames = function(opts)
  opts = opts or {}

  local displayer = entry_display.create({
    separator = "▏",
    items = {
      { width = 8 },
      { width = 50 },
      { remaining = true },
    },
  })

  local make_display = function(entry)
    local filename = utils.transform_path(opts, entry.filename)
    local line_info = { table.concat({ entry.lnum, entry.col }, ":"), "TelescopeResultsLineNr" }

    return displayer({
      line_info,
      filename,
    })
  end

  return function(entry)
    local filename = entry.filename or vim.api.nvim_buf_get_name(entry.bufnr)

    return {
      valid = true,
      value = entry,
      ordinal = (not opts.ignore_filename and filename or "") .. " " .. entry.text,
      display = make_display,
      bufnr = entry.bufnr,
      filename = filename,
      lnum = entry.lnum,
      col = entry.col,
      text = entry.text,
      start = entry.start,
      finish = entry.finish,
    }
  end
end

---
return { frecency_sorter = frecency_sorter }

-- local packer_attach = function(prompt_bufnr, map)
--   local actions = require "telescope.actions"
--   local builtin = require("telescope.builtin")
--   local action_state = require "telescope.actions.state"
--   actions.select_default:replace(
--     function()
--       local selection = action_state.get_selected_entry()
--       actions.close(prompt_bufnr)
--       vim.cmd(string.format(":e %s", selection.readme))
--     end
--   )

--   local Job = require "plenary.job"
--   local open_online = function()
--     local selection = action_state.get_selected_entry()
--     actions._close(prompt_bufnr)
--     local cmd =
--     vim.fn.has "win32" == 1 and "explorer" or vim.fn.has "mac" == 1 and "open" or "xdg-open"
--     local url =
--     vim.fn.trim(vim.fn.system(string.format("git -C %s ls-remote --get-url", selection.path)))
--     Job:new({ command = cmd, args = { url } }):start()
--   end

--   local open_finder = function(prompt_bufnr)
--     local selection = action_state.get_selected_entry()
--     actions._close(prompt_bufnr, true)
--     builtin.find_files({ cwd = selection.path })
--   end

--   local open_browser = function(prompt_bufnr)
--     local ok, file_browser = pcall(require, "telescope._extensions.file_browser")
--     if not ok then
--       vim.notify(
--         "nvim-telescope/telescope-file-browser.nvim is required to use this action",
--         vim.log.levels.ERROR,
--         { title = "Telescope" }
--       )
--       return
--     end
--     local selection = action_state.get_selected_entry()
--     actions._close(prompt_bufnr, true)
--     file_browser.exports.file_browser({ cwd = selection.path })
--   end

--   local open_grep = function(prompt_bufnr)
--     local selection = action_state.get_selected_entry()
--     actions._close(prompt_bufnr, true)
--     builtin.live_grep({ cwd = selection.path })
--   end

--   vim.api.nvim_set_keymap(prompt_bufnr, "i", "<C-e>", open_online)
--   vim.api.nvim_set_keymap(prompt_bufnr, "i", "<C-i>", open_finder)
--   vim.api.nvim_set_keymap(prompt_bufnr, "i", "<C-x>", open_browser)
--   vim.api.nvim_set_keymap(prompt_bufnr, "i", "<C-g>", open_grep)
-- end
