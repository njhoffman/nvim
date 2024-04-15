local state = {
  jumps = {},
  jump_idx = 0,
  changes = {},
  change_idx = 0,
  history = {},
  saves = {},
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
local process = function(list, pos_idx)
  local new_list = {}
  local hashes = {}
  local new_idx = 0
  local keys = vim.fn.sort(vim.tbl_keys(list and list[1]) or {})
  for i, item in ipairs(vim.fn.reverse(list)) do
    item.idx = #list - i + 1
    local hash = ''
    for _, key in ipairs(keys) do
      vim.dbglog('key', key)
      hash = hash .. tostring(item[key])
    end
    if i == (#list - pos_idx) then
      new_idx = #new_list
      table.insert(new_list, item)
    end
    if not vim.list_contains(hashes, hash) then
      table.insert(new_list, item)
      table.insert(hashes, i, hash)
    end
  end
  return new_list, new_idx
end

local get_jumps = function()
  -- bufnr col coladd filename lnum
  local jumplist = vim.fn.getjumplist(nil) or {}
  local new_list, new_idx = process(jumplist[1] or {}, jumplist[2] or {})
  state.jumps = new_list
  state.jump_idx = new_idx
end

local get_changes = function()
  -- col coladd lnum
  local changelist = vim.fn.getchangelist(vim.api.nvim_get_current_buf()) or {}
  local new_list, new_idx = process(changelist[1] or {}, changelist[2] or {})
  state.changes = new_list
  state.change_idx = new_idx
end

-- get_changes()
get_jumps()
vim.dbglog(state.jumps)

-- return { state = state, get_jumps = get_jumps, get_changes = get_changes }
