local min_defaults = {
  "yarospace/dev-tools.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter" }, -- code manipulation in buffer
  specs = {
    {
      "folke/snacks.nvim",
      opts = {
        picker = { enabled = true }, -- actions picker
        terminal = { enabled = true }, -- terminal for running spec actions
      },
    },
    {
      "ThePrimeagen/refactoring.nvim", -- refactoring library
      dependencies = { "nvim-lua/plenary.nvim" },
    },
  },

  opts = {
    ---@type Action[]|fun():Action[]
    actions = {},

    filetypes = { -- filetypes for which to attach the LSP
      include = {}, -- {} to include all
      exclude = {},
    },

    builtin_actions = {
      include = {}, -- filetype/group/name of actions to include or {} to include all
      exclude = {}, -- filetype/group/name of actions to exclude or true to exclude all
    },

    action_opts = { -- override options for actions
      {
        group = "Debugging",
        name = "Log vars under cursor",
        opts = {
          keymap = nil, -- action keymap, e.g.
          -- {
          --   global = "<leader>dl" | { "<leader>dl", mode = { "n", "x" } },
          --   picker = "<M-l>",
          --   hide = true,  -- hide the action from the picker
          -- }
        },
      },
    },

    ui = {
      override = true, -- override vim.ui.select
      group_actions = true, -- group actions by group name
    },
  },
}

local vimlsp = require("dev-tools.lsp")
vimlsp.start = function(buf, ft)
  local buftype = vim.api.nvim_get_option_value("buftype", { buf = buf })
  if
    vim.tbl_contains({
      "nofile",
      "prompt",
      "file",
      "quickfix",
      "terminal",
    }, buftype) or not buftype
  then
    return
  end

  local Config = require("dev-tools.config")
  if vim.tbl_contains(Config.filetypes.exclude or {}, ft) then
    return
  end
  if
    #(Config.filetypes.include or {}) > 0 and not vim.tbl_contains(Config.filetypes.include, ft)
  then
    return
  end

  vimlsp.start_lsp(buf)
end

require("dev-tools").setup()

-- full convig:

---@class Action
---@field name string - name of the action
---@field group string|nil - group of the action
---@field condition string|nil|fun(action: ActionCtx): boolean - function or pattern to match against buffer name
---@field filetype string[]|nil - filetype to limit the action to
---@field fn fun(action: ActionCtx) - function to execute the action

---@class ActionCtx: Action
---@field ctx Ctx - context of the action

---@class Ctx
---@field buf number - buffer number
---@field win number - window number
---@field row number - current line number
---@field col number - current column number
---@field line string - current line
---@field word string - word under cursor
---@field ts_node TSNode|nil - current TS node
---@field ts_type string|nil - type of the current TS node
---@field ts_range table<number, number, number, number>|nil - range of the current TS node
---@field bufname string - full path to file in buffer
---@field root string - root directory of the file
---@field filetype string - filetype
---@field range Range|nil - range of the current selection
---@field edit Edit - edititng functions

---@class Range
---@field start {line: number, character: number} - start position of the range
---@field end {line: number, character: number} - end position of the range
---@field rc table<number, number, number, number> - row/col format

opts = {
  ---@type Action[]|fun():Action[]
  actions = {
    {
      name = "Extract variable",
      filetype = { "lua" },
      fn = function(action)
        local ctx = action.ctx

        vim.ui.input({ prompt = "Variable name:", default = "" }, function(var_name)
          if not var_name then
            return
          end

          local var_body = ("local %s = %s"):format(var_name, ctx.edit:get_range()[1])

          ctx.edit:set_range({ var_name })
          ctx.edit:set_lines({ var_body }, ctx.range.rc[1], ctx.range.rc[1])

          ctx.edit:indent(ctx.range.rc[1] - 1, ctx.range.rc[3] + 1)
          ctx.edit:set_cursor(ctx.range.rc[1] + 2, ctx.range.rc[2] + 1)
        end)
      end,
    },
  },
}
