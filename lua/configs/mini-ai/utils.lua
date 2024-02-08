-- Function to update existing neovim keymap --
function UpdateKeymap(tbl, mode, keys, action, options)
  -- find the keymap in the table
  for i, v in pairs(tbl) do
    -- if the mode and keys match than update the action and options
    if v.mode == mode and v.keys == keys then
      v.action = action
      if options then
        v.options = options
      end
    end
  end
end

-- Usage
keymap = {
  { mode = 'n', keys = 'yy', action = 'Y$', options = { noremap = true } },
  -- some other keymaps...
}

-- Assume we want to update the 'yy' in normal mode.
UpdateKeymap(keymap, 'n', 'yy', '"_y', { noremap = true, silent = true })
-- vim.api.nvim_exec("map <key>", false)
local update_desc = function(key, value)
  local existing_x = vim.api.nvim_get_keymap('x')[key]
  local existing_o = vim.api.nvim_get_keymap('o')[key]
  vim.keymap.set({ 'x' }, existing_x.lhs, existing_x.rhs, { desc = value })
  vim.keymap.set({ 'o' }, existing_o.lhs, existing_o.rhs, { desc = value })
end

-- Function to apply keymaps --
function ApplyKeymaps(tbl)
  for _, map in pairs(tbl) do
    vim.api.nvim_set_keymap(map.mode, map.keys, map.action, map.options)
  end
end

-- Call whenever you modify keymaps
ApplyKeymaps(keymap)

-- Usage
keymap = {
  { mode = 'n', keys = 'yy', action = 'Y$', options = { noremap = true } },
  -- some other keymaps...
}

-- Assume we want to update the 'yy' in normal mode.
UpdateKeymap(keymap, 'n', 'yy', '"_y', { noremap = true, silent = true })

-- Apply the changes
ApplyKeymaps(keymap)
