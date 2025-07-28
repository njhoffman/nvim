-- -- When in diff mode, we want to use the default
-- -- vim text objects c & C instead of the treesitter ones.
-- local move = require('nvim-treesitter.textobjects.move') ---@type table<string,fun(...)>

-- local configs = require('nvim-treesitter.configs')

-- for name, fn in pairs(move) do
--   if name:find('goto') == 1 then
--     move[name] = function(q, ...)
--       if vim.wo.diff then
--         local config = configs.get_module('textobjects.move')[name] ---@type table<string,string>
--         for key, query in pairs(config or {}) do
--           if q == query and key:find('[%]%[][cC]') then
--             vim.cmd('normal! ' .. key)
--             return
--           end
--         end
--       end
--       return fn(q, ...)
--     end
--   end
-- end

-- DOCS https://github.com/nvim-treesitter/nvim-treesitter-textobjects/tree/main#nvim-treesitter-textobjectshttps://github.com/nvim-treesitter/nvim-treesitter-textobjects/tree/main#nvim-treesitter-textobjects
--------------------------------------------------------------------------------
local function select(textobj)
  return function()
    require("nvim-treesitter-textobjects.select").select_textobject(textobj, "textobjects")
  end
end

local cfg = {
  select = {
    lookahead = true,
    -- `true` would even remove line breaks from charwise objects,
    -- thus staying with `false`
    include_surrounding_whitespace = false,
  },
}

require("nvim-treesitter-textobjects").setup(cfg)

local keys = {
  -- MOVE
  {
    "<C-j>",
    function()
      local move = require("nvim-treesitter-textobjects.move")
      move.goto_next_start("@function.outer", "textobjects")
    end,
    desc = " Goto next function",
  },
  {
    "<C-k>",
    function()
      local move = require("nvim-treesitter-textobjects.move")
      move.goto_previous_start("@function.outer", "textobjects")
    end,
    desc = " Goto prev function",
  },

  -- SWAP
  {
    "ä",
    function()
      require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner")
    end,
    desc = " Swap next arg",
  },
  {
    "Ä",
    function()
      require("nvim-treesitter-textobjects.swap").swap_previous("@parameter.inner")
    end,
    desc = " Swap prev arg",
  },

  -- TEXT OBJECTS
  { "a<CR>", select("@return.outer"), mode = { "x", "o" }, desc = "↩ outer return" },
  { "i<CR>", select("@return.inner"), mode = { "x", "o" }, desc = "↩ inner return" },
  { "a/", select("@regex.outer"), mode = { "x", "o" }, desc = " outer regex" },
  { "i/", select("@regex.inner"), mode = { "x", "o" }, desc = " inner regex" },
  { "aa", select("@parameter.outer"), mode = { "x", "o" }, desc = "󰏪 outer arg" },
  { "ia", select("@parameter.inner"), mode = { "x", "o" }, desc = "󰏪 inner arg" },
  { "iu", select("@loop.inner"), mode = { "x", "o" }, desc = "󰛤 inner loop" },
  { "au", select("@loop.outer"), mode = { "x", "o" }, desc = "󰛤 outer loop" },
  { "al", select("@call.outer"), mode = { "x", "o" }, desc = "󰡱 outer call" },
  { "il", select("@call.inner"), mode = { "x", "o" }, desc = "󰡱 inner call" },
  { "af", select("@function.outer"), mode = { "x", "o" }, desc = " outer function" },
  { "if", select("@function.inner"), mode = { "x", "o" }, desc = " inner function" },
  { "ao", select("@conditional.outer"), mode = { "x", "o" }, desc = "󱕆 outer condition" },
  { "io", select("@conditional.inner"), mode = { "x", "o" }, desc = "󱕆 inner condition" },

  -- CUSTOM TEXTOBJECTS (defined in my .scm files)
  { "rl", select("@call.justCaller"), mode = "o", desc = "󰡱 rest of caller" },
  {
    "ad",
    select("@docstring.outer"),
    mode = { "x", "o" },
    desc = "󰌠 outer docstring",
    ft = "python",
  },
  {
    "id",
    select("@docstring.inner"),
    mode = { "x", "o" },
    desc = "󰌠 inner docstring",
    ft = "python",
  },
  { -- override default inner conditional for some languages
    "io",
    select("@conditional.conditionOnly"),
    mode = { "x", "o" },
    desc = "󱕆 inner conditional",
    ft = { "javascript", "typescript", "lua", "swift", "python", "bash", "zsh" },
  },

  -- COMMENTS
  -- only operator-pending to not conflict with selection-commenting
  { "q", select("@comment.outer"), mode = "o", desc = "󰆈 single comment" },

  {
    "cq",
    function()
      -- not using `@comment.inner`, since not supported for many languages
      local selectObj = require("nvim-treesitter-textobjects.select").select_textobject
      selectObj("@comment.outer", "textobjects")
      local comStr = vim.bo.commentstring:format("")
      vim.cmd.normal({ "c" .. comStr, bang = true })
      vim.cmd.startinsert({ bang = true })
    end,
    desc = "󰆈 Change single comment",
  },

  {
    "dq",
    function()
      -- as opposed to regular usage of the textobj, also trims the line
      -- and preserves the cursor position
      local cursorBefore = vim.api.nvim_win_get_cursor(0)
      local selectObj = require("nvim-treesitter-textobjects.select").select_textobject
      selectObj("@comment.outer", "textobjects")
      vim.cmd.normal({ "d", bang = true })
      local trimmedLine = vim.api.nvim_get_current_line():gsub("%s+$", "")
      vim.api.nvim_set_current_line(trimmedLine)
      vim.api.nvim_win_set_cursor(0, cursorBefore)
    end,
    desc = "󰆈 Sticky delete single comment",
  },
}
