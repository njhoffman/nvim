local util = require("import.util")

local provider = {
  name = "keymaps",
  diff = function(prev, next)
    local deltas = {}
    for mode, keys in pairs(prev) do
      deltas[mode] = util.diff(keys, next[mode])
    end
    return deltas
  end,
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
        key_table[mode][tostring(util.get_crc(hash))] = key
      end
    end
    return key_table
  end,
  summary = function(deltas)
    local out = ""
    for mode, delta in pairs(deltas) do
      if #delta.added > 0 then
        out = table.concat({ out, " ", #delta.added, mode })
      end
      -- if #delta.removed > 0 then
      --   out = table.concat({ out, " ", #delta.removed, mode })
      -- end
    end
    return string.format("%25s", out)
  end,
  report = function(path, deltas)
    local report = ""
    for mode, delta in pairs(deltas) do
      local out = ""
      for _, added in ipairs(delta.added) do
        out = table.concat({ out, "\n", mode, "+ keymap add ", path, added.lhs, added.desc }, " ")
      end
      for _, removed in ipairs(delta.removed) do
        out = table.concat({ out, "\n", mode, "+ keymap rem ", path, removed.lhs, removed.desc }, " ")
      end
      local summary = table.concat(
        { "\n", path, " +", tostring(#delta.added), ":-", tostring(#delta.removed), mode, " keymaps" },
        " "
      )
      report = (report or "") .. (out or "") .. summary
    end
    return report
  end,
}

return provider
