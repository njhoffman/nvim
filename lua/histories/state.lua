local state = {
  jumps = {},
  jump_idx = 0,
  changes = {},
  change_idx = 0,
  selects = {},
  select_idx = 0,
  history = {},
  saves = {},
  augroup = vim.api.nvim_create_augroup('HistUtils', { clear = true }),
}

-- local ut = vim.fn.undotree()
--  "seq_last"
--  "seq_cur"  This differs from "seq_last" when some changes were undone.
--  "time_cur" Time last used for |:earlier| related (use strftime)
--  "save_last" Number of the last file write.  Zero when no write yet.
--  "save_cur"	Number of the current position in the undo tree.
--  "synced"	  Non-zero when the last undo block was synced. (waiting for input)
--  "entries"	  A list of dictionaries with information about undo blocks.
--    "seq"		  Undo sequence number.  Same as what appears in |:undolist|.
--    "time"	  Timestamp when the change happened.
--    "newhead"	Only appears in the item that is the last one that was added.
--              This marks the last change and where further changes will be added.
--    "curhead"	Only appears in the item that is the last one that was undone.
--              This marks the current pos in the undo tree, the block used by a redo command
--              When nothing was undone after the last change this item will not appear anywhere.
--    "save"  	Only appears on the last block before a file write. The number is the write count.
--             The first write has number 1, the last one the "save_last" mentioned above.
--    "alt"		Alternate entry.  This is again a List of undo blocks.  Each item may again have an "alt" item.

return state
