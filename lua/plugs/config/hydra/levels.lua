local Hydra = require("hydra")

local hints = [[
  ^ ^       Lsp Levels
  ^
  _0_ %{trace} trace
  _1_ %{debug} debug
  _2_ %{info} info
  _3_ %{warn} warn
  _4_ %{error} error
  _5_ %{none} none
  ^
       ^^^^                    _<Esc>_
]]

local heads = {
  {
    "0",
    function()
      if vim.diagnostic.config().signs then
        vim.diagnostic.config({ signs = false })
      else
        vim.diagnostic.config({ signs = true })
      end
    end,
    { desc = "signs", exit = true },
  },
  {
    "1",
    function()
      if vim.b.format_on_write == 0 then
        vim.b.format_on_write = 1
      else
        vim.b.format_on_write = 0
      end
    end,
    { desc = "format on write", exit = true },
  },
  {
    "2",
    function()
      if vim.b.format_on_write == 0 then
        vim.b.format_on_write = 1
      else
        vim.b.format_on_write = 0
      end
    end,
    { desc = "format on write", exit = true },
  },
  {
    "3",
    function()
      if vim.b.format_on_write == 0 then
        vim.b.format_on_write = 1
      else
        vim.b.format_on_write = 0
      end
    end,
    { desc = "format on write", exit = true },
  },
  {
    "4",
    function()
      if vim.b.format_on_write == 0 then
        vim.b.format_on_write = 1
      else
        vim.b.format_on_write = 0
      end
    end,
    { desc = "format on write", exit = true },
  },
  {
    "5",
    function()
      if vim.b.format_on_write == 0 then
        vim.b.format_on_write = 1
      else
        vim.b.format_on_write = 0
      end
    end,
    { desc = "format on write", exit = true },
  },
  { "<Esc>", nil, { exit = true } },
}

local toggles = {
  yes = "[]",
  no = "[ ]",
  num = function(num)
    return "[" .. num .. "]"
  end,
}

local funcs = {
  trace = function()
    return toggles.yes
  end,
  debug = function()
    return toggles.yes
  end,
  info = function()
    return toggles.yes
  end,
  warn = function()
    return toggles.yes
  end,
  error = function()
    return toggles.yes
  end,
  none = function()
    return toggles.yes
  end,
}

local hydra = function()
  return Hydra({
    name = "Levels",
    hint = hints,
    heads = heads,
    config = {
      color = "amaranth", -- amaranth, teal, pink, red, blue
      invoke_on_body = true,
      hint = {
        funcs = funcs,
        border = "rounded",
        position = "middle",
      },
    },
    mode = { "n", "x" },
    -- buffer = true,
    -- on_enter = function()
    --   print("Hydra enter")
    --   -- temporary set `nomodifiable` while Hydra is active
    --   vim.bo.modifiable = false
    -- end,
    -- on_exit = function()
    --   print("Hydra exit")
    --   -- No need to set modifiable back here
    -- end,
  })
end

return { hydra = hydra }
