local Hydra = require("hydra")

local lsp_hints = [[
  ^ ^       Lsp Options
  ^
  _d_ %{enabled_buffer} diagnostics buffer
  _D_ %{enabled_global} diagnostics global
  _i_ %{insert} diagnostics on insert
  _s_ %{signs} signs enabled
  _f_ %{format} format on write
  _v_ %{virtual_errors} virtual text errors
  _V_ %{virtual_all} virtual text all
  _u_ %{underline_errors} underline errors
  _U_ %{underline_all} underline all
  ^
       ^^^^                    _<Esc>_
]]
-- float diag on hover
-- virtual text only current line
local lsp_heads = {
  {
    "d",
    function()
      if vim.diagnostic.is_disabled(0) then
        vim.diagnostic.enable(0)
      else
        vim.diagnostic.disable(0)
      end
      print("enabled")
    end,
    { desc = "enabled buffer" },
  },
  {
    "D",
    function()
      if vim.diagnostic.is_disabled() then
        vim.diagnostic.enable()
      else
        vim.diagnostic.disable()
      end
    end,
    { desc = "enabled global" },
  },
  {
    "i",
    function()
      if vim.diagnostic.config().update_in_insert then
        vim.diagnostic.config({ update_in_insert = false })
      else
        vim.diagnostic.config({ update_in_insert = true })
      end
    end,
    { desc = "update in insert" },
  },
  {
    "s",
    function()
      if vim.diagnostic.config().signs then
        vim.diagnostic.config({ signs = false })
      else
        vim.diagnostic.config({ signs = true })
      end
    end,
    { desc = "signs" },
  },
  {
    "f",
    function()
      if vim.b.format_on_write == 0 then
        vim.b.format_on_write = 1
      else
        vim.b.format_on_write = 0
      end
    end,
    { desc = "format on write" },
  },
  {
    "v",
    function()
      if vim.diagnostic.config().virtual_text then
        vim.diagnostic.config({ virtual_text = false })
      else
        vim.diagnostic.config({ virtual_text = { severity = { min = 1 } } })
      end
    end,
    { desc = "virtual text errors" },
  },
  {
    "V",
    function()
      if vim.diagnostic.config().virtual_text then
        vim.diagnostic.config({ virtual_text = false })
      else
        vim.diagnostic.config({ virtual_text = true })
      end
    end,
    { desc = "virtual text all" },
  },
  {
    "u",
    function()
      if vim.diagnostic.config().underline then
        vim.diagnostic.config({ underline = false })
      else
        vim.diagnostic.config({ underline = { severity = { min = 1 } } })
      end
    end,
    { desc = "underline errors" },
  },
  {
    "U",
    function()
      if vim.diagnostic.config().underline then
        vim.diagnostic.config({ underline = false })
      else
        vim.diagnostic.config({ undeline = true })
      end
    end,
    { desc = "underline all" },
  },
}

--      
--   ﱣ      ﭦ
local toggles = { yes = "[]", no = "[ ]" }
local lsp_funcs = {
  enabled_buffer = function()
    if vim.diagnostic.is_disabled(0) then
      return toggles.no
    else
      return toggles.yes
    end
  end,
  enabled_global = function()
    if vim.diagnostic.is_disabled() then
      return toggles.no
    else
      return toggles.yes
    end
  end,
  insert = function()
    if vim.diagnostic.config().update_in_insert then
      return toggles.yes
    else
      return toggles.no
    end
  end,
  signs = function()
    if vim.diagnostic.config().signs then
      return toggles.yes
    else
      return toggles.no
    end
  end,
  format = function()
    if vim.b.format_on_write == 0 then
      return toggles.no
    else
      return toggles.yes
    end
  end,
  virtual_errors = function()
    if vim.diagnostic.config().virtual_text then
      return toggles.yes
    else
      return toggles.no
    end
  end,
  virtual_all = function()
    if vim.diagnostic.config().virtual_text == true then
      return toggles.yes
    else
      return toggles.no
    end
  end,
  underline_errors = function()
    if vim.diagnostic.config().underline then
      return toggles.yes
    else
      return toggles.no
    end
  end,
  underline_all = function()
    if vim.diagnostic.config().underline == true then
      return toggles.yes
    else
      return toggles.no
    end
  end,
}

Hydra({
  name = "LspOptions",
  hint = lsp_hints,
  heads = lsp_heads,
  config = {
    color = "amaranth", -- amaranth, teal, pink, red, blue
    invoke_on_body = true,
    hint = {
      funcs = lsp_funcs,
      type = "window",
      border = "rounded",
      position = "middle",
    },
  },
  mode = { "n", "x" },
  body = "gl",
})

local hint = [[
  ^ ^        Options
  ^
  _v_ %{ve} virtual edit
  _i_ %{list} invisible characters
  _s_ %{spell} spell
  _w_ %{wrap} wrap
  _c_ %{cul} cursor line
  _n_ %{nu} number
  _r_ %{rnu} relative number
  ^
       ^^^^                _<Esc>_
]]

local heads = {
  {
    "n",
    function()
      if vim.o.number == true then
        vim.o.number = false
      else
        vim.o.number = true
      end
    end,
    { desc = "number" },
  },
  {
    "r",
    function()
      if vim.o.relativenumber == true then
        vim.o.relativenumber = false
      else
        vim.o.number = true
        vim.o.relativenumber = true
      end
    end,
    { desc = "relativenumber" },
  },
  {
    "v",
    function()
      if vim.o.virtualedit == "all" then
        vim.o.virtualedit = "block"
      else
        vim.o.virtualedit = "all"
      end
    end,
    { desc = "virtualedit" },
  },
  {
    "i",
    function()
      if vim.o.list == true then
        vim.o.list = false
      else
        vim.o.list = true
      end
    end,
    { desc = "show invisible" },
  },
  {
    "s",
    function()
      if vim.o.spell == true then
        vim.o.spell = false
      else
        vim.o.spell = true
      end
    end,
    { exit = true, desc = "spell" },
  },
  {
    "w",
    function()
      if vim.o.wrap ~= true then
        vim.o.wrap = true
        -- If cursor is inside very long line in the file than wraps
        -- around several rows on the screen, then 'j' key moves you to
        -- the next line in the file, but not to the next row on the
        -- screen under your previous position as in other editors.
        vim.keymap.set("n", "k", function()
          return vim.v.count > 0 and "k" or "gk"
        end, { expr = true, desc = "k or gk" })
        vim.keymap.set("n", "j", function()
          return vim.v.count > 0 and "j" or "gj"
        end, { expr = true, desc = "j or gj" })
      else
        vim.o.wrap = false
        vim.keymap.del("n", "k")
        vim.keymap.del("n", "j")
      end
    end,
    { desc = "wrap" },
  },
  {
    "c",
    function()
      if vim.o.cursorline == true then
        vim.o.cursorline = false
      else
        vim.o.cursorline = true
      end
    end,
    { desc = "cursor line" },
  },
  { "<Esc>", nil, { exit = true } },
}

Hydra({
  name = "Options",
  hint = hint,
  heads = heads,
  config = {
    color = "amaranth", -- amaranth, teal, pink, red, blue
    invoke_on_body = true,
    hint = {
      border = "rounded",
      position = "middle",
    },
  },
  mode = { "n", "x" },
  body = "go",
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
