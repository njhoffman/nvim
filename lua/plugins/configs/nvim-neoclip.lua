--
-- shift+ins: *
-- :Telescope neoclip
-- If you instead want to directly paste it you can press by default <c-p> in insert mode and p in normal. Paste behind is by default <c-k> and P respectively.
-- If you want to replace another register with an entry from the history you can do for example:
-- :Telescope neoclip a
-- which will replace register a. The register [0-9a-z] and default (") are supported.
-- The following special registers are support:
-- ": Telescope neoclip unnamed *: Telescope neoclip star +: Telescope neoclip plus
-- and Telescope neoclip (and Telescope neoclip default) will use what you set default_register in the setup.

-- yank from x11: + *
-- yank from vim: +
-- delete from vim: +
-- vim p: + (ins) c-s-p: +

require('neoclip').setup({
  history = 1000,
  enable_persistent_history = true,
  db_path = vim.fn.getenv("HOME") .. "/.vim/databases/neoclip.sqlite3",
  filter = nil,
  preview = true,
  default_register = '"',
  content_spec_column = true,
  on_paste = { set_reg = false },
  keys = {
    telescope = {
      -- i = { select = "<cr>", paste = "<c-p>", paste_behind = "<c-k>" },
      -- n = { select = "<cr>", paste = "p", paste_behind = "P" },
      i = {
        select = '<cr>',
        paste = '<M-p>',
        paste_behind = '<c-k>',
        custom = {},
      },
      n = {
        select = '<cr>',
        paste = 'p',
        paste_behind = 'P',
        custom = {
          ['<space>'] = function(opts)
            print(vim.inspect(opts))
          end,
        },
      },
    },
    fzf = {
      select = 'default',
      paste = 'ctrl-p',
      paste_behind = 'ctrl-k',
      custom = {},
    },
  },
})
