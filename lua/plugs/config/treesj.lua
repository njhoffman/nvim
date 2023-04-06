local defaults = {
  -- Use default keymaps
  -- (<space>m - toggle, <space>j - join, <space>s - split)
  use_default_keymaps = true,

  -- Node with syntax error will not be formatted
  check_syntax_error = true,

  -- If line after join will be longer than max value,
  -- node will not be formatted
  max_join_length = 120,

  -- hold|start|end:
  -- hold - cursor follows the node/place on which it was called
  -- start - cursor jumps to the first symbol of the node being formatted
  -- end - cursor jumps to the last symbol of the node being formatted
  cursor_behavior = "hold",

  -- Notify about possible problems or not
  notify = true,
  -- langs = langs,
  -- Use `dot` for repeat action
  dot_repeat = true,
}

require("treesj").setup({
  use_default_keymaps = false,
  max_join_length = 360,
  check_syntax_error = false,
})

local langs = require("treesj.langs")["presets"]

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = "*",
  callback = function()
    local opts = { buffer = true }
    if langs[vim.bo.filetype] then
      vim.keymap.set("n", "gS", "<Cmd>TSJSplit<CR>", opts)
      vim.keymap.set("n", "gJ", "<Cmd>TSJJoin<CR>", opts)
      vim.keymap.set("n", "gjj", "<Cmd>TSJToggle<CR>", opts)
    else
      vim.keymap.set("n", "gS", "require('mini.splitjoin').split_at", opts)
      vim.keymap.set("n", "gJ", "require('mini.splitjoin').join_at", opts)
      vim.keymap.set("n", "gjj", "require('mini.splitjoin').toggle", opts)
    end
  end,
})
