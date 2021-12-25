require"shade".setup({
  overlay_opacity = 50,
  opacity_step = 1,
  keys = { brightness_up = "<C-Up>", brightness_down = "<C-Down>", toggle = "<Leader>s" },
})

--     -- Replace a string prefix in all items in a list
--     local function replace_prefix(table, old_prefix, new_prefix)
--       -- Escape all punctuation chars to protect from lua pattern chars.
--       old_prefix = old_prefix:gsub("[^%w]", "%%%0")
--       for index, value in ipairs(table) do table[index] = value:gsub("^" .. old_prefix, new_prefix, 1) end
--       return table
