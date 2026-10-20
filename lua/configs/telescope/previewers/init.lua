local from_entry = require("telescope.from_entry")
local conf = require("telescope.config").values
local builtin = require("telescope.builtin")
local previewers = require("telescope.previewers")
local Path = require("plenary.path")
local keymaps_previewer = require("configs.telescope.previewers.keymaps")
local pfiletype = require("plenary.filetype")

local M = {}

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
  vim.schedule(function()
    opts.ft = pfiletype.detect(filepath)
    previewers.buffer_previewer_maker(filepath, bufnr, opts)
  end)
end

M.buffer_cat = function(opts)
  opts = opts or {}
  local cwd = opts.cwd or vim.uv.cwd()
  return previewers.new_buffer_previewer({
    title = "File Preview",
    dyn_title = function(_, entry)
      vim.uv.fs_stat(from_entry.path(entry, false), function(_, stat)
        if not stat then
          return
        else
          local bytes_to_megabytes = math.pow(1024, 2)
          local mb_filesize = stat.size / bytes_to_megabytes
        end
      end)
      return Path:new(from_entry.path(entry, false, false)):normalize(cwd)
    end,

    get_buffer_by_name = function(_, entry)
      return from_entry.path(entry, false)
    end,

    define_preview = function(self, entry, status)
      opts.ft = pfiletype.detect(from_entry.path(entry, false))
      require("telescope.previewers.utils").highlighter(self.state.bufnr, opts.ft)

      local p = from_entry.path(entry, true)
      if p == nil or p == "" then
        return
      end
      local preview_opts = {
        bufname = self.state.bufname,
        winid = self.state.winid,
        preview = opts.preview,
        file_encoding = opts.file_encoding,
        filetype = opts.ft,
        bufnr = self.state.bufnr,
        cwd = opts.cwd,
      }

      conf.buffer_previewer_maker(p, self.state.bufnr, preview_opts)
    end,
  })
end

return M
