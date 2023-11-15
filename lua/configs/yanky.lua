local default = {
  ring = {
    history_length = 100,
    storage = 'shada',
    storage_path = vim.fn.stdpath('data') .. '/databases/yanky.db', -- Only for sqlite storage
    sync_with_numbered_registers = true,
    cancel_event = 'update',
    ignore_registers = { '_' },
    update_register_on_cycle = false,
  },
  picker = {
    select = {
      action = nil, -- nil to use default put action
    },
    telescope = {
      use_default_mappings = true, -- if default mappings should be used
      mappings = nil, -- nil to use default mappings or no mappings (see `use_default_mappings`)
    },
  },
  system_clipboard = {
    sync_with_ring = true,
  },
  highlight = {
    on_put = true,
    on_yank = true,
    timer = 500,
  },
  preserve_cursor_position = {
    enabled = true,
  },
  textobj = {
    enabled = true,
  },
}

local cfg = {
  ring = {
    history_length = 100,
    storage = 'shada',
    sync_with_numbered_registers = true,
    cancel_event = 'update',
    ignore_registers = { '_' },
    update_register_on_cycle = false,
  },
  system_clipboard = {
    sync_with_ring = true,
  },
  textobj = {
    enabled = true,
  },
  preserve_cursor_position = {
    enabled = true,
  },
}

require('yanky').setup(cfg)

vim.keymap.set({ 'o', 'x' }, '<leader>pl', function()
  require('yanky.textobj').last_put()
end, { desc = 'put last yanked text object' })
-- telescope actions
-- require("yanky.picker").actions.put("p") -- put after cursor
-- require("yanky.picker").actions.put("P") -- put before cursor
-- require("yanky.picker").actions.put("gp") -- put after cursor and leave the cursor after
-- require("yanky.picker").actions.put("gP") -- put before cursor and leave the cursor after
-- require("yanky.picker").actions.delete() -- delete entry from yank history
-- require("yanky.picker").actions.set_register(regname) -- fill register with selected value
-- require("yanky.picker").actions.put_and_set_register("p", regname) -- put and fill register with selected value

-- stylua: ignore start
-- vim.keymap.set({"n","x"}, "p",     "<Plug>(YankyPutAfter)")
-- vim.keymap.set({"n","x"}, "P",     "<Plug>(YankyPutBefore)")
-- vim.keymap.set({"n","x"}, "gp",    "<Plug>(YankyGPutAfter)")
-- vim.keymap.set({"n","x"}, "gP",    "<Plug>(YankyGPutBefore)")
-- vim.keymap.set("n",       "<c-n>", "<Plug>(YankyCycleForward)")
-- vim.keymap.set("n",       "<c-p>", "<Plug>(YankyCycleBackward)")
-- vim.keymap.set({"n","x"}, "p",     "<Plug>(YankyPutAfter)")
-- vim.keymap.set({"n","x"}, "P",     "<Plug>(YankyPutBefore)")
-- vim.keymap.set({"n","x"}, "gp",    "<Plug>(YankyGPutAfter)")
-- vim.keymap.set({"n","x"}, "gP",    "<Plug>(YankyGPutBefore)")
-- vim.keymap.set("n",       "<c-n>", "<Plug>(YankyCycleForward)")
-- vim.keymap.set("n",       "<c-p>", "<Plug>(YankyCycleBackward)")
