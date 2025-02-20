local cfg  =  {
    "rachartier/tiny-glimmer.nvim",
    commit = "6f9706b",
    dependencies = {
      {
        "gbprod/yanky.nvim",
        optional = true,
        keys = { { "p", false }, { "P", false } },
        opts = { highlight = { on_yank = false, on_put = false } },
      },
    },
    event = "TextYankPost",
    keys = { { "p" }, { "P" } },
    opts = function(_, opts)
      if LazyVim.has("yanky.nvim") then
        -- for tiny-glimmer.nvim to hijack
        vim.keymap.set("n", "p", "<Plug>(YankyPutAfter)", { desc = "Put Text After Cursor" })
        vim.keymap.set("n", "P", "<Plug>(YankyPutBefore)", { desc = "Put Text Before Cursor" })
      end

      return vim.tbl_deep_extend("force", opts, {
        overwrite = {
          search = { enabled = false },
          paste = { enabled = true },
        },
      })
    end,
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyVimAutocmdsDefaults",
        callback = function()
          vim.api.nvim_del_augroup_by_name("lazyvim_highlight_yank")
        end,
      })
    end,
  },
