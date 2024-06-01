local provider = function(_)
  return {
    name = 'keymaps_g',
    id_fields = { 'mode', 'lhs', 'rhs' },
    get_data = function()
      local keymaps = {
        n = vim.api.nvim_get_keymap('n'),
        i = vim.api.nvim_get_keymap('i'),
        o = vim.api.nvim_get_keymap('o'),
        v = vim.api.nvim_get_keymap('v'),
        c = vim.api.nvim_get_keymap('c'),
        t = vim.api.nvim_get_keymap('t'),
      }
      local key_table = {}
      for mode, keys in pairs(keymaps) do
        for _, key in ipairs(keys) do
          key.mode = mode
          table.insert(key_table, key)
        end
      end
      return key_table
    end,
    -- parse_data = function() end
  }
end

return provider
