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

local function is_whitespace(line)
  return vim.fn.match(line, [[^\s*$]]) ~= -1
end

local function all(tbl, check)
  for _, entry in ipairs(tbl) do
    if not check(entry) then
      return false
    end
  end
  return true
end

require('neoclip').setup({
  history = 1000,
  enable_persistent_history = true,
  length_limit = 1048576,
  continuous_sync = true,
  db_path = vim.fn.stdpath("data") .. "/databases/neoclip.sqlite3",
  filter = function(data)
    return not all(data.event.regcontents, is_whitespace)
  end,
  preview = true,
  default_register = '"',
  default_register_macros = '"',
  enable_macro_history = true,
  content_spec_column = true,
  on_paste = {
    set_reg = false,
  },
  on_replay = {
    set_reg = false,
  },
  keys = {
    telescope = {
      i = {
        select = '<cr>',
        paste = '<M-p>',
        -- paste = '<c-p>',
        -- paste_behind = '<c-k>',
        replay = '<c-q>', -- replay a macro
        delete = '<c-d>', -- delete an entry
        custom = {},
      },
      n = {
        select = '<cr>',
        paste = 'p',
        --- It is possible to map to more than one key.
        -- paste_behind = 'P',
        replay = 'q',
        delete = 'd',
        custom = {
          ['<space>'] = function(opts)
            -- do your stuff
            -- ...
            local handlers = require('neoclip.handlers')
            -- optionally set the registers with the entry
            -- handlers.set_registers(opts.register_names, opts.entry)
            -- optionally paste entry
            -- handlers.paste(opts.entry, 'p')
            -- optionally paste entry behind
            -- handlers.paste(opts.entry, 'P')
          end,
        }
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

-- If you don't want to store pure whitespace yanks you could specify a filter as:
-- local function is_whitespace(line)
--   return vim.fn.match(line, [[^\s*$]]) ~= -1
-- end
--
-- local function all(tbl, check)
--   for _, entry in ipairs(tbl) do
--     if not check(entry) then
--       return false
--     end
--   end
--   return true
-- end
--
-- require('neoclip').setup{
--   ...
--   filter = function(data)
--     return not all(data.event.regcontents, is_whitespace)
--   end,
--   ...
-- }
