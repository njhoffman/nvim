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
  require("mapper").map({ 'x' }, existing_x.lhs, existing_x.rhs, { desc = value })
  require("mapper").map({ 'o' }, existing_o.lhs, existing_o.rhs, { desc = value })
end

-- Function to apply keymaps --
function ApplyKeymaps(tbl)
  for _, m in pairs(tbl) do
    require("mapper").map(m.mode, m.keys, m.action, m.options)
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
