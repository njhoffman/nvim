local scratch_cfg = {
  enabled = true,
  ft = function()
    if vim.bo.buftype == "" and vim.bo.filetype ~= "" then
      return vim.bo.filetype
    end
    return "markdown"
  end,
  ---@type string|string[]?
  icon = nil, -- `icon|{icon, icon_hl}`. defaults to the filetype icon
  root = vim.fn.stdpath("data") .. "/scratch",
  autowrite = true, -- automatically write when the buffer is hidden
  -- unique key for the scratch file is based on:
  -- * name * ft * vim.v.count1 (useful for keymaps) * cwd (optional
  win = {
    style = "scratch",
    -- zindex = 50,
    -- -- position = "right",
    -- wo = { winhighlight = "NormalFloat:Normal" },
    -- minimal = false,
    -- noautocmd = false,
    -- bo = { buftype = "", buflisted = false, bufhidden = "hide", swapfile = false },
    -- position = "bottom", -- float
    -- border = "rounded",
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
