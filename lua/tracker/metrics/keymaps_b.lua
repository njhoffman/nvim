local diff_utils = require("tracker.diff")

local provider = {
  name = "keymaps",
  diff = diff_utils.diff,
  get = function(data)
    local bufnr = 0
    local keymaps = data
      or {
        n = vim.api.nvim_buf_get_keymap(bufnr, "n"),
        i = vim.api.nvim_buf_get_keymap(bufnr, "i"),
        o = vim.api.nvim_buf_get_keymap(bufnr, "o"),
        v = vim.api.nvim_buf_get_keymap(bufnr, "v"),
        c = vim.api.nvim_buf_get_keymap(bufnr, "c"),
        t = vim.api.nvim_buf_get_keymap(bufnr, "t"),
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
  output = function(delta)
    for _, added in ipairs(delta.added) do
      vim.dbglog(" + keymaps_b " .. added.mode .. " " .. added.lhs .. " : " .. added.rhs)
    end
    for _, removed in ipairs(delta.removed) do
      vim.dbglog(" - keymaps_b " .. removed.mode .. " " .. removed.lhs .. " : " .. removed.rhs)
    end
  end,
}

return provider
