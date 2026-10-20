local M = {}

M.opts = {
  sign = "",
  sign_highlight = "@comment.note",

  filters = {
    -- Read more about `exrc`: `:h exrc`.
    same_project = false,
    same_file = false,
    same_filetype = false,
    only_loaded = false,
  },

  telescope = {
    autoload = true,
    mappings = {
      unmark_selected_entry = {
        normal = "dd",
        insert = "<M-d>",
      },
    },
  },

  -- https://github.com/neovim/neovim/issues/4295
  -- https://github.com/neovim/neovim/pull/24936 (0.10-only)
  wshada = false,
}

function M.setup(opts)
  M.opts = vim.tbl_deep_extend("force", M.opts, opts or {})

  vim.fn.sign_define("RecallSign", { text = M.opts.sign, texthl = M.opts.sign_highlight })

  local augroup = vim.api.nvim_create_augroup("RecallRefreshSigns", { clear = true })

  vim.api.nvim_create_autocmd("BufEnter", {
    group = augroup,
    pattern = "*",
    callback = function()
      require("recall.marking").refresh_signs()
    end,
  })

  if M.opts.telescope.autoload then
    vim.schedule(function()
      require("recall.telescope").autoload()
    end)
  end
end

return M
