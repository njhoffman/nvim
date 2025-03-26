local whichkey = require("which-key")

-- - **[1]**(`string`) lhs **(required)**
-- - **[2]**(`string|fun()`) rhs **(optional)**when present, it will create the mapping
-- - **desc**(`string|fun():string`) description **(required for non-groups)**
-- - **group**(`string|fun():string`) group name **(optional)**
-- - **mode**(`string|string[]`) mode **(optional, defaults to "n")**
-- - **cond**(`boolean|fun():boolean`) condition to enable the mapping **(optional)**
-- - **hidden**(`boolean`) hide the mapping **(optional)**
-- - **icon**(`string|wk.Icon|fun():(wk.Icon|string)`) icon spec **(optional)**
-- - **proxy**(`string`) proxy to another mapping **(optional)**
-- - **expand**(`fun():wk.Spec`) nested mappings **(optional)**
-- - any other option valid for `vim.keymap.set`. These are only used for creating mappings.
-- When `desc`, `group`, or `icon` are functions, they are evaluated every time the popup is shown.
-- wk.add({
--   { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find File", mode = "n" },
--   { "<leader>fb", function() print("hello") end, desc = "Foobar" },
--   { "<leader>fn", desc = "New File" },
--   { "<leader>f1", hidden = true }, -- hide this keymap
--   { "<leader>w", proxy = "<c-w>", group = "windows" }, -- proxy to window mappings
--   {
--     mode = { "n", "v" }, -- NORMAL and VISUAL mode
--     { "<leader>q", "<cmd>q<cr>", desc = "Quit" },
--   }
-- })

local map = function(mode, lhs, opts)
  local key = vim.tbl_deep_extend("force", opts, {
    [1] = lhs,
    desc = opts.label or opts.desc or "",
    buffer = opts.buffer == true and 0 or opts.buffer,
    mode = mode == "" and "n" or mode,
  })
  key.label = nil
  key.category = nil
  whichkey.add(key)
end

local prefix = function(mode, prefix, name)
  whichkey.add({ prefix, group = name, mode = mode })
end

return { map = map, prefix = prefix }
