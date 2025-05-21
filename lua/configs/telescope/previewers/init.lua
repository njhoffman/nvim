local from_entry = require("telescope.from_entry")
local conf = require("telescope.config").values
local builtin = require("telescope.builtin")
local previewers = require("telescope.previewers")
local Path = require("plenary.path")
local keymaps_previewer = require("configs.telescope.previewers.keymaps")
local pfiletype = require("plenary.filetype")
-- local putils = require('plenary.utils')

local M = {}

-- NOTE: go check if file is in specific git repo: dotbare ls-files --error-unmatch ~/.zlua
M.keymaps = keymaps_previewer

M.git_status = function(opts)
  opts = opts or {}
  opts.previewer = previewers.new_termopen_previewer({
    get_command = function(entry)
      if entry.status == "D " then
        return { "git", "show", "HEAD:" .. entry.value }
      elseif entry.status == "??" then
        return { "bat", "--style=plain", entry.value }
      end
      return {
        "git",
        "--no-pager",
        "-c",
        "core.pager=delta",
        "diff",
        entry.value,
      }
    end,
  })

  -- Use icons that resemble the `git status` command line.
  opts.git_icons = {
    added = "A",
    changed = "M",
    copied = "C",
    deleted = "-",
    renamed = "R",
    unmerged = "U",
    untracked = "?",
  }

  builtin.git_status(opts)
end

M.git_bcommits = previewers.new_termopen_previewer({
  get_command = function(entry)
    return {
      "git",
      "-c",
      "core.pager=delta",
      -- "-c",
      -- "delta.pager=less -R",
      "show",
      entry.value,
    }
  end,
})

M.delta = previewers.new_termopen_previewer({
  get_command = function(entry)
    if entry.status == "??" or "A " then
      return { "git", "diff", entry.value }
    end
    return { "git", "diff", entry.value .. "^!" }
  end,
})

local new_maker = function(filepath, bufnr, opts)
  opts = opts or {}
  local ft = pfiletype.detect(filepath)
  if ft == "markdown" then
    -- opts.use_ft_detect = false
    -- putils.regex_highlighter(bufnr, 'pandoc')
    -- putils.ts_highlighter(bufnr, 'markdown')
    vim.schedule(function()
      vim.api.nvim_set_option_value("syntax", "pandoc", { buf = bufnr })
      previewers.buffer_previewer_maker(filepath, bufnr, opts)
    end)
  end
  vim.schedule(function()
    previewers.buffer_previewer_maker(filepath, bufnr, opts)
  end)
end

M.buffer_cat = function(opts)
  opts = opts or {}
  local cwd = opts.cwd or vim.loop.cwd()
  return previewers.new_buffer_previewer({
    title = "File Preview",
    dyn_title = function(_, entry)
      vim.loop.fs_stat(from_entry.path(entry, false), function(_, stat)
        if not stat then
          return
        else
          local bytes_to_megabytes = math.pow(1024, 2)
          local mb_filesize = stat.size / bytes_to_megabytes
          -- print(mb_filesize * 1000)
        end
      end)
      return Path:new(from_entry.path(entry, false, false)):normalize(cwd)
    end,

    get_buffer_by_name = function(_, entry)
      return from_entry.path(entry, false)
    end,

    define_preview = function(self, entry, status)
      -- local ft = pfiletype.detect(from_entry.path(entry, false))
      local markdown_cb = function(bufnr)
        vim.schedule(function()
          -- vim.treesitter.language.register('markdown', 'pandoc')
          vim.api.nvim_set_option_value("syntax", "pandoc", { buf = self.state.bufnr })
          self:scroll_fn(1)
        end)
      end
      local ft =
        vim.filetype.match({ filename = from_entry.path(entry, false), buf = self.state.bufnr })

      -- local selected_row = 0
      --   -- only set up autocommand after showing preview completed
      --   vim.schedule(function()
      --     vim.api.nvim_create_autocmd(close_event, {
      --       pattern = close_pattern,
      --       buffer = close_buffer,
      --       once = true,
      --       callback = function()
      --         vim.schedule(function()
      --           pcall(vim.api.nvim_win_close, km_win_id, true)
      --           pcall(vim.api.nvim_win_close, km_opts.border.win_id, true)
      --           utils.buf_delete(km_buf)
      --         end)
      --       end,
      --     })
      --   end)
      -- end

      local utils = require("telescope.utils")
      local preview_winid = status.layout.preview and status.layout.preview.winid
      local other_cb = function()
        -- local total_lines = vim.api.nvim_buf_line_count(0)
        -- vim.api.nvim_buf_call(self.state.bufnr, function()
        --   vim.cmd('norm! zz')
        -- end)

        -- require('scrollbar.handlers').register('my_marks', function(bufnr)
        --   return {
        --     { line = 0 },
        --     { line = 1, text = 'x', type = 'Warn' },
        --     { line = 2, type = 'Error' },
        --   }
        -- end)
        -- vim.api.nvim_win_call(self.state.winid, function()
        --   vim.cmd([[normal! 10 j ]])
        -- end)
        -- utils.win_set_buf_noautocmd(preview_winid, self.state.bufnr)
        -- pcall(vim.api.nvim_win_set_cursor, preview_winid, { 0, 0 })

        -- putils.highlighter(bufnr, opts.ft, opts)
        -- require('telescope.previewers.utils').highlighter(bufnr, 'yaml')
        -- require('telescope.previewers.utils').regex_highlighter(bufnr, ft)`
        -- require('telescope.previewers.utils').ts_highlighter(self.state.bufnr, ft)
        -- vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
        -- self:scroll_fn(-1)
      end

      local p = from_entry.path(entry, true)
      if p == nil or p == "" then
        return
      end
      local preview_opts = {
        bufname = self.state.bufname,
        winid = self.state.winid,
        preview = opts.preview,
        file_encoding = opts.file_encoding,
      }

      -- vim.api.nvim_set_option_value('scrolloff', 0, { win = self.state.winid })
      -- self.window:option('conceallevel', 2)
      -- self.window:option('concealcursor', 'n')
      -- self.window:option('foldenable', false)
      -- self.window:option('linebreak', true)
      -- self.window:option('scrolloff', 0)
      -- self.window:option('showbreak', 'NONE')
      -- self.window:option('wrap', true)
      local extension = vim.fn.fnamemodify(p, ":e")
      if extension == "md" then
        preview_opts.callback = markdown_cb
      else
        preview_opts.callback = other_cb
      end
      conf.buffer_previewer_maker(p, self.state.bufnr, preview_opts)
    end,
  })
end

return M
