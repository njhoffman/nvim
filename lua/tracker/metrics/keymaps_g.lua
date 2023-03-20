local utils = require("metrics.utils")

local provider = {
  name = "keymaps",
  diff = utils.diff,
  get = function(data)
    local keymaps = data
      or {
        n = vim.api.nvim_get_keymap("n"),
        i = vim.api.nvim_get_keymap("i"),
        o = vim.api.nvim_get_keymap("o"),
        v = vim.api.nvim_get_keymap("v"),
        c = vim.api.nvim_get_keymap("c"),
        t = vim.api.nvim_get_keymap("t"),
      }
    local key_table = {}
    for mode, keys in pairs(keymaps) do
      key_table[mode] = {}
      for _, key in ipairs(keys) do
        local hash = table.concat({ mode, key.desc or "", key.lhs, key.rhs or "" })
        key_table[mode][tostring(utils.get_crc(hash))] = key
      end
    end
    return key_table
  end,
  output = function(path, delta)
    for _, added in ipairs(delta.added) do
      vim.dbglog(" + keymaps_b " .. path .. " " .. added.event .. " " .. added.pattern)
    end
    for _, removed in ipairs(delta.removed) do
      vim.dbglog(" - keymaps_b " .. path .. " " .. removed.event .. " " .. removed.pattern)
    end
  end,
}

return provider
