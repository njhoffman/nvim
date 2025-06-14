local previewers = require("telescope.previewers")
local builtin = require("telescope.builtin")
local from_entry = require("telescope.from_entry")
local utils = require("telescope.utils")

local git_command = utils.__git_command

local git_difftastic_previewer = function(opts)
  return previewers.new_termopen_previewer({
    title = "Git File Difftastic Preview",

    get_command = function(entry)
      local command = git_command({ "--no-pager", "diff" }, opts)

      if entry.status and (entry.status == "??" or entry.status == "A ") then
        local p = from_entry.path(entry, true, false)
        if p == nil or p == "" then
          return
        end
        table.insert(command, { "--no-index", "/dev/null" })
      else
        table.insert(command, { "HEAD", "--" })
      end

      return utils.flatten({ utils.flatten(command), entry.value })
    end,

    scroll_fn = function(self, direction)
      if not self.state then
        return
      end

      local bufnr = self.state.termopen_bufnr
      -- 0x05 -> <C-e>; 0x19 -> <C-y>
      local input = direction > 0 and string.char(0x05) or string.char(0x19)
      local count = math.abs(direction)

      vim.api.nvim_win_call(vim.fn.bufwinid(bufnr), function()
        vim.cmd([[normal! ]] .. count .. input)
      end)
    end,
  })
end

local git_status_difftastic = function(opts)
  opts = opts or {}
  opts.previewer = git_difftastic_previewer(opts)

  builtin.git_status(opts)
end

local delta_bcommits = previewers.new_termopen_previewer({
  get_command = function(entry)
    return {
      "git",
      "-c",
      "core.pager=delta",
      "-c",
      "delta.side-by-side=false",
      "diff",
      entry.value .. "^!",
      "--",
      entry.current_file,
    }
  end,
})

local git_bcommits = function(opts)
  opts = opts or {}
  opts.previewer = {
    delta_bcommits,
    previewers.git_commit_message.new(opts),
    previewers.git_commit_diff_as_was.new(opts),
  }

  builtin.git_bcommits(opts)
end

--
-- local delta_previewer = previewers.new_termopen_previewer {
--   get_command = function(entry)
--     return { 'git', '-c', 'core.pager=delta', '-c', 'delta.side-by-side=false', 'diff', entry.value .. '^!' }
--   end
-- }

local buffer_previewer = previewers.new_buffer_previewer({
  define_preview = function(self, entry, status)
    local dir_name = vim.fn.substitute(vim.fn.getcwd(), "^.*/", "", "")
    local t = {}
    if entry.value == dir_name then
      local s = vim.fn.system("git status -s")
      for chunk in string.gmatch(s, "[^\n]+") do
        t[#t + 1] = chunk
      end
    else
      local s = vim.fn.system("git -C " .. entry.value .. " status -s")
      for chunk in string.gmatch(s, "[^\n]+") do
        t[#t + 1] = chunk
      end
    end
    vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, true, t)
  end,
})

return {
  buffer_previewer = buffer_previewer,
  git_status_difftastic = git_status_difftastic,
  git_bcommits = git_bcommits,
}
