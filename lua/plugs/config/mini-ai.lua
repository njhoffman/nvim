-- :h MiniAlign-glossary, MiniAlign-algorithm, MiniAlign-examples

local default = {
  -- Table with textobject id as fields, textobject specification as values.
  -- Also use this to disable builtin textobjects. See |MiniAi.config|.
  custom_textobjects = nil,

  -- Module mappings. Use `''` (empty string) to disable one.
  mappings = {
    -- Main textobject prefixes
    around = "a",
    inside = "i",

    -- Next/last variants
    around_next = "an",
    inside_next = "in",
    around_last = "al",
    inside_last = "il",

    -- Move cursor to corresponding edge of `a` textobject
    goto_left = "g[",
    goto_right = "g]",
  },

  -- Number of lines within which textobject is searched
  n_lines = 50,

  -- How to search for object (first inside current line, then inside
  -- neighborhood). One of 'cover', 'cover_or_next', 'cover_or_prev',
  -- 'cover_or_nearest', 'next', 'previous', 'nearest'.
  search_method = "cover_or_next",

  -- Whether to disable showing non-error feedback
  silent = false,
}

local opts = { n_lines = 80 }
require("mini.ai").setup(opts)
-- require("mini.ai").setup(opts)
--       -- register all text objects with which-key
--       if require("lazyvim.util").has("which-key.nvim") then
--         ---@type table<string, string|table>
--         local i = {
--           [" "] = "Whitespace",
--           ['"'] = 'Balanced "',
--           ["'"] = "Balanced '",
--           ["`"] = "Balanced `",
--           ["("] = "Balanced (",
--           [")"] = "Balanced ) including white-space",
--           [">"] = "Balanced > including white-space",
--           ["<lt>"] = "Balanced <",
--           ["]"] = "Balanced ] including white-space",
--           ["["] = "Balanced [",
--           ["}"] = "Balanced } including white-space",
--           ["{"] = "Balanced {",
--           ["?"] = "User Prompt",
--           _ = "Underscore",
--           a = "Argument",
--           b = "Balanced ), ], }",
--           c = "Class",
--           f = "Function",
--           o = "Block, conditional, loop",
--           q = "Quote `, \", '",
--           t = "Tag",
--         }
--         local a = vim.deepcopy(i)
--         for k, v in pairs(a) do
--           a[k] = v:gsub(" including.*", "")
--         end
--
--         local ic = vim.deepcopy(i)
--         local ac = vim.deepcopy(a)
--         for key, name in pairs({ n = "Next", l = "Last" }) do
--           i[key] = vim.tbl_extend("force", { name = "Inside " .. name .. " textobject" }, ic)
--           a[key] = vim.tbl_extend("force", { name = "Around " .. name .. " textobject" }, ac)
--         end
--         require("which-key").register({
--           mode = { "o", "x" },
--           i = i,
--           a = a,
--         })
--       end
--
-- Press s to enter split Lua pattern.
-- Press j to choose justification side from available ones ("left", "center", "right", "none").
-- Press m to enter merge delimiter.
-- Press f to enter filter Lua expression to configure which parts will be affected (like "align only first column").
-- Press i to ignore some commonly unwanted split matches.
-- Press p to pair neighboring parts so they be aligned together.
-- Press t to trim whitespace from parts.
-- Press <BS> (backspace) to delete some last pre-step.

-- ## Modifiers ~
--
-- `MiniAlign.config.modifiers` is used to define interactive user experience
-- of managing alignment process. It is a table with single character keys and
-- modifier function values.
--
-- Each modifier function:
-- - Is called when corresponding modifier key is pressed.
-- - Has signature `(steps, opts)` and should modify any of its input in place.
--
-- Examples:
-- - Modifier function used for default 'i' modifier:
-- >
--   function(steps, _)
--     table.insert(steps.pre_split, MiniAlign.gen_step.ignore_split())
--   end
-- <
-- - Tweak 't' modifier to use highest indentation instead of keeping it:
-- >
--   require('mini.align').setup({
--     t = function(steps, _)
--       table.insert(steps.pre_justify, MiniAlign.gen_step.trim('both', 'high'))
--     end
--   })
-- <
-- - Tweak `j` modifier to cycle through available "justify_side" option
--   values (like in 'junegunn/vim-easy-align'):
-- >
--   require('mini.align').setup({
--     modifiers = {
--       j = function(_, opts)
--         local next_option = ({
--           left = 'center', center = 'right', right = 'none', none = 'left',
--         })[opts.justify_side]
--         opts.justify_side = next_option or 'left'
--       end,
--     },
--   })
