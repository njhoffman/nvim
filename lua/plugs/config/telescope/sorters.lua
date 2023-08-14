local utils = require('telescope.utils')

local M = {}
M.frecency_score = function(self, prompt, line, entry)
  if prompt == nil or prompt == '' then
    for _, file_entry in ipairs(self.state.frecency) do
      local filepath = entry.cwd .. '/' .. entry.value
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
    prompt_title = 'Dotfiles',
    cwd = '~',
  })
end

-- custom function for lsp_references entries
M._qf_as_filenames = function(opts)
  opts = opts or {}

  local displayer = entry_display.create({
    separator = '▏',
    items = {
      { width = 8 },
      { width = 50 },
      { remaining = true },
    },
  })

  local make_display = function(entry)
    local filename = utils.transform_path(opts, entry.filename)
    local line_info = { table.concat({ entry.lnum, entry.col }, ':'), 'TelescopeResultsLineNr' }

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
      ordinal = (not opts.ignore_filename and filename or '') .. ' ' .. entry.text,
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

local telescope = require('telescope')
local sorters = require('telescope.sorters')
local fzy_sorter = sorters.get_fzy_sorter()
local filter = vim.tbl_filter

-- Copied from: https://github.com/nvim-telescope/telescope.nvim/blob/dc192faceb2db64231ead71539761e055df66d73/lua/telescope/builtin/__internal.lua#L17-L29
local function apply_cwd_only_aliases(opts)
  local has_cwd_only = opts.cwd_only ~= nil
  local has_only_cwd = opts.only_cwd ~= nil

  if has_only_cwd and not has_cwd_only then
    -- Internally, use cwd_only
    opts.cwd_only = opts.only_cwd
    opts.only_cwd = nil
  end

  return opts
end

-- Copied from: https://github.com/nvim-telescope/telescope.nvim/blob/dc192faceb2db64231ead71539761e055df66d73/lua/telescope/builtin/__internal.lua#L872-L923
local get_buffers = function(opts)
  opts = opts or {}
  opts = apply_cwd_only_aliases(opts)
  local bufnrs = filter(function(b)
    if 1 ~= vim.fn.buflisted(b) then
      return false
    end
    -- only hide unloaded buffers if opts.show_all_buffers is false, keep them listed if true or nil
    if opts.show_all_buffers == false and not vim.api.nvim_buf_is_loaded(b) then
      return false
    end
    if opts.ignore_current_buffer and b == vim.api.nvim_get_current_buf() then
      return false
    end
    if opts.cwd_only and not string.find(vim.api.nvim_buf_get_name(b), vim.loop.cwd(), 1, true) then
      return false
    end
    if not opts.cwd_only and opts.cwd and not string.find(vim.api.nvim_buf_get_name(b), opts.cwd, 1, true) then
      return false
    end
    return true
  end, vim.api.nvim_list_bufs())
  if not next(bufnrs) then
    return
  end
  if opts.sort_mru then
    table.sort(bufnrs, function(a, b)
      return vim.fn.getbufinfo(a)[1].lastused > vim.fn.getbufinfo(b)[1].lastused
    end)
  end

  local buffers = {}
  for _, bufnr in ipairs(bufnrs) do
    local flag = bufnr == vim.fn.bufnr('') and '%' or (bufnr == vim.fn.bufnr('#') and '#' or ' ')

    local element = {
      bufnr = bufnr,
      flag = flag,
      info = vim.fn.getbufinfo(bufnr)[1],
    }

    if opts.sort_lastused and (flag == '#' or flag == '%') then
      local idx = ((buffers[1] ~= nil and buffers[1].flag == '%') and 2 or 1)
      table.insert(buffers, idx, element)
    else
      table.insert(buffers, element)
    end
  end
  return buffers
end

local is_file_open = function(line)
  local buffers = get_buffers()
  if not buffers then
    return false
  end
  -- TODO: This may not be performant if there are many open buffers.
  -- We could implement a map / lookup table instead.
  for _, buffer in ipairs(buffers) do
    local buffer_name = buffer.info.name
    if vim.endswith(buffer_name, line) then
      return true
    end
  end
  return false
end

-- Copied from: https://github.com/nvim-telescope/telescope.nvim/blob/dc192faceb2db64231ead71539761e055df66d73/lua/telescope/sorters.lua#L437-L466
-- Sorter using the fzy algorithm
local fzy_sorter = function(opts)
  opts = opts or {}
  local fzy = opts.fzy_mod or require('telescope.algos.fzy')
  local OFFSET = -fzy.get_score_floor()

  return sorters.Sorter:new({
    discard = fzy_sorter.discard,

    scoring_function = function(_, prompt, line)
      -- Check for actual matches before running the scoring alogrithm.
      if not fzy.has_match(prompt, line) then
        return -1
      end

      local fzy_score = fzy.score(prompt, line)

      -- The fzy score is -inf for empty queries and overlong strings.  Since
      -- this function converts all scores into the range (0, 1), we can
      -- convert these to 1 as a suitable "worst score" value.
      if fzy_score == fzy.get_score_min() then
        return 1
      end

      -- CUSTOM CODE ADDED HERE 👇
      -- Double score if file is open.
      -- TODO: Score boost could take into account sort order of buffers.
      -- Like which one was last used.
      if is_file_open(line) then
        fzy_score = fzy_score * 2
      end
      -- END CUSTOM CODE

      -- Poor non-empty matches can also have negative values. Offset the score
      -- so that all values are positive, then invert to match the
      -- telescope.Sorter "smaller is better" convention. Note that for exact
      -- matches, fzy returns +inf, which when inverted becomes 0.
      return 1 / (fzy_score + OFFSET)
    end,

    highlighter = fzy_sorter.highlighter,
  })
end

---
return { frecency_sorter = frecency_sorter, fzy_sorter }

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
