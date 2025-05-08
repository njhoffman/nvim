local scratch_cfg = {
  enabled = true,
  root = vim.fn.stdpath("data") .. "/scratch",
  autowrite = true, -- automatically write when the buffer is hidden
  ---@type string|string[]?
  -- unique key for the scratch file is based on:
  -- * name * ft * vim.v.count1 (useful for keymaps) * cwd (optional) * branch (optional)
  filekey = {
    cwd = false, -- use current working directory
    branch = false, -- use current branch name
    count = true, -- use vim.v.count1
  },
  ft = function()
    if vim.bo.buftype == "" and vim.bo.filetype ~= "" then
      return vim.bo.filetype
    end
    return "markdown"
  end,
  win = {
    style = "scratch",
    width = math.max(vim.o.columns - 5, 80),
    height = 30,
    relative = "editor",
    -- zindex = 50,
    -- -- position = "right",
    wo = { winhighlight = "NormalFloat:Normal" },
    -- minimal = false,
    -- noautocmd = false,
    bo = { buftype = "", buflisted = false, bufhidden = "hide", swapfile = false },
    -- position = "bottom", -- float
    border = "rounded",
    -- title_pos = "center",
    -- footer_pos = "center",
    -- height = 0.4,
    -- width = 0.4,
  },
  win_by_ft = {
    lua = {
      keys = {
        q = "close",
        ["<M-{>"] = "close",
        ["source"] = {
          "<cr>",
          function(self)
            local name = "scratch." .. vim.fn.fnamemodify(vim.api.nvim_buf_get_name(self.buf), ":e")
            Snacks.debug.run({ buf = self.buf, name = name })
          end,
          desc = "Source buffer",
          mode = { "n", "x" },
        },
      },
    },
  },
}

return scratch_cfg
