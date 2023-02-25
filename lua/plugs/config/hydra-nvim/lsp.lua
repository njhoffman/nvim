local Hydra = require("hydra")
-- local popup = require("plugs.config.hydra.popup")
local levels = require("plugs.config.hydra-nvim.levels")

local hints = [[
  ^ ^       Lsp Options
  ^
  _d_ %{enabled_buffer} diagnostics buffer
  _D_ %{enabled_global} diagnostics global
  _i_ %{insert} diagnostics on insert
  _f_ %{format} format on write
  _s_ %{signs_toggle} signs enabled
  _S_ %{signs_level} signs level
  _v_ %{virtual_toggle} virtual text enabled
  _V_ %{virtual_level} virtual text level
  _u_ %{underline_toggle} underline enabled
  _U_ %{underline_level} underline level
  ^
       ^^^^                    _<Esc>_
]]

-- float diag on hover
-- virtual text only current line
local heads = {
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
    "s",
    function()
      if vim.diagnostic.config().signs then
        vim.diagnostic.config({ signs = false })
      else
        vim.diagnostic.config({ signs = true })
      end
    end,
    { desc = "signs toggle" },
  },
  {
    "S",
    function()
      if vim.diagnostic.config().signs then
        vim.diagnostic.config({ signs = false })
      else
        vim.diagnostic.config({ signs = true })
      end
    end,
    { desc = "signs level", exit = true },
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
    { desc = "virtual text toggle" },
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
    { desc = "virtual text level", exit = true },
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
    { desc = "underline toggle" },
  },
  {
    "U",
    function()
      vim.schedule(function()
        local ret = levels.hydra()
        ret:activate()
      end)
      -- popup.open({ " 0 trace", " 1 debug", " 2 info", " 3 warn", " 4 error", " 5 off" }, function(res)
      --   vim.dbglog("res", res)
      -- end)
      -- if vim.diagnostic.config().underline then
      --   vim.diagnostic.config({ underline = false })
      -- else
      --   vim.diagnostic.config({ undeline = true })
      -- end
    end,
    { desc = "underline level", exit = true },
  },
  { "<Esc>", nil, { exit = true } },
}

--            ﱣ     ﭦ 
local toggles = {
  yes = "      ",
  no = "      ",
  num = function(num)
    return " " .. num .. " "
  end,
  lvl = function(num)
    return "[" .. string.lower(tostring(vim.lsp.log_levels[num])) .. "]"
    -- return string.format("%8s", "[" .. string.lower(tostring(vim.lsp.log_levels[num])) .. "]")
  end,
}

local funcs = {
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
  format = function()
    if vim.b.format_on_write == 0 then
      return toggles.no
    else
      return toggles.yes
    end
  end,
  signs_toggle = function()
    if vim.diagnostic.config().signs then
      return toggles.yes
    else
      return toggles.no
    end
  end,
  signs_level = function()
    local severity = vim.tbl_get(vim.diagnostic.config(), "signs", "severity", "min") or vim.diagnostic.config().signs
    if severity == false then
      severity = 5
    elseif severity == true then
      severity = 0
    end
    return toggles.lvl(severity)
    -- return toggles.num(severity)
  end,
  virtual_toggle = function()
    -- vim.dbg(vim.diagnostic.config().virtual_text)
    if vim.diagnostic.config().virtual_text then
      return toggles.yes
    else
      return toggles.no
    end
  end,
  virtual_level = function()
    local severity = vim.tbl_get(vim.diagnostic.config(), "virtual_text", "severity", "min")
      or vim.diagnostic.config().virtual_text
    if severity == false then
      severity = 5
    elseif severity == true then
      severity = 0
    end
    return toggles.lvl(severity)
    -- return toggles.num(severity)
  end,
  underline_toggle = function()
    if vim.diagnostic.config().underline then
      return toggles.yes
    else
      return toggles.no
    end
  end,
  underline_level = function()
    local severity = vim.tbl_get(vim.diagnostic.config(), "underline", "severity", "min")
      or vim.diagnostic.config().underline
    if severity == false then
      severity = 5
    elseif severity == true then
      severity = 0
    end
    return toggles.lvl(severity)
    -- return toggles.num(severity)
  end,
}

local hydra = function()
  return Hydra({
    name = "Lsp",
    hint = hints,
    heads = heads,
    config = {
      color = "amaranth", -- amaranth, teal, pink, red, blue
      invoke_on_body = true,
      hint = {
        funcs = funcs,
        type = "window",
        border = "rounded",
        position = "middle",
      },
      on_enter = function()
        vim.bo.modifiable = false -- temporary set `nomodifiable` while Hydra is active
        vim.cmd("VimadeFadeActive")
      end,
      on_exit = function()
        vim.cmd("VimadeUnfadeActive")
      end,
    },
    mode = { "n", "x" },
    body = "gl",
  })
end

return { hydra = hydra }
