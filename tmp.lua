


local M = {}
-- = {
--   remote_jump             = '<cr>',
--   tree_search             = 'R',
--   op_tree_search          = 'M',
--   goto_prefix             = ';;',
--   goto_next               = ';;',
--   goto_previous           = ';;',
--   goto_next_outer         = ']]',
--   goto_previous_outer     = '[[',
--   goto_next_end           = '<leader>]', -- ")",
--   goto_previous_end       = '<leader>[', -- "(",
--   goto_next_outer_end     = '<leader>]]', -- "))",
--   goto_previous_outer_end = '<leader>[[', -- "((",
--   select                  = '&',
--   select_dynamic          = 'm',
--   select_remote           = 'r',
--   select_remote_dynamic   = 'ir',
--   select_outer            = '<M-S-7>', -- M-&
--   select_next             = 'in',
--   select_previous         = 'iN',
--   select_next_outer       = 'an',
--   select_previous_outer   = 'aN',
--   exchange_node           = 'rix',
--   exchange_motion         = 'rx',
--   exchange_vline          = 'rxx',
--   remote_replace          = ';R',
--   replace_remote_motion   = ';ry',
--   replace_remote_d_motion = ';rd',
--   replace_remote_c_motion = ';rc',
--   replace_node            = ';rY',
--   replace_d_node          = ';rD',
--   replace_c_node          = ';rC',
--   remote_op               = 'u',
--   remote                  = ';rw',
-- }

local remote_jump = function()
  require("flash").jump({ mode = "remote_ts" })
end

local tree_search = function()
  Flash.treesitter_search({
      label = { before = true, after = true, style = 'inline' },
      remote_op = { restore = true },
    })
end

local op_tree_search = function()
  Flash.treesitter_search({
      label = { before = true, after = true, style = "inline" },
      remote_op = { restore = true },
    })
end

local select_remote_node = function()
  require("flash").jump({ mode = "remote_ts" })
end

local select_remote_node_next = function()
  require("flash").jump({ mode = "remote_ts", treesitter = { starting_from_pos = true } })
end

local select_remote_node_prev  = function()
  require("flash").jump({ mode = "remote_ts", treesitter = { ending_at_pos = true } })
end

local select_remote_node_end = function()
require("flash").jump({ mode = "remote_ts", treesitter = { end_of_node = true }, jump = { pos = "end" } })
end

local select_remote_node_start = function()
  require("flash").jump({
      mode = "remote_ts",
      treesitter = { start_of_node = true },
      jump = { pos = "start" },
    })

end

  local jump_cword = function()
    require("flash").jump({ mode = "textcase", pattern = vim.fn.expand("<cword>") })
  end

  local jump_word = function()
    require("flash").jump({ mode = "textcase", pattern = vim.fn.expand("<cWORD>") })
  end

  -- local goto_next =
  -- local goto_previous =
  -- local goto_next_outer =
  -- local goto_previous_outer =
  -- local goto_next_end =
  -- local goto_previous_end =
  -- local goto_next_outer_end =
  -- local goto_previous_outer_end =
  -- local select_outer =
  -- local select_next =
  -- local select_previous =
  -- local select_next_outer =
  -- local select_previous_outer =

  local exchange_node =             function() lib.swap_with({ mode = 'remote_ts' }) end
  local exchange_motion =           function() lib.swap_with() end
  local exchange_vline =            function() lib.swap_with({ exchange = { visual_mode = 'V', } }) end
  local remote_replace =            function() lib.swap_with({ exchange = { not_there = true } }) end
  local replace_remote_motion =     function() vim.api.nvim_feedkeys(';r', 'm', false) vim.schedule(function() require('flash').jump({ mode = 'remote_ts' }) end) end
  local replace_remote_d_motion =   function() lib.swap_with({ exchange = { not_there = true } }) end
  local replace_remote_c_motion =   function() lib.swap_with({ exchange = { not_there = true } }) end
  local replace_node =              function() lib.swap_with({ mode = 'remote_ts', exchange = { not_there = true } }) end
  local replace_d_node =            function() lib.swap_with({ mode = 'remote_ts', exchange = { not_there = true } }) end
  local replace_c_node =            function() lib.swap_with({ mode = 'remote_ts', exchange = { not_there = true } }) end

  local remote_op = function()
    Flash.treesitter({
        filter = function(matches)
          ---@param m Flash.Match.TS
          -- for all matches,  match[n+1] should use previous match[n] label. Do in reverse order, to prevet copying first label to all matches
          for i = #matches, 2, -1 do
            matches[i].label = matches[i - 1].label
          end
          table.remove(matches, 1) -- remove first match, as it is same as word under cursor thus redundant with word motion
        end
        label = {
          rainbow = {
            enabled = true,
          },
        },
      })
  end

  local remote = function()
    Flash.jump({
        matcher = gen_dyn_matcher(basic_query),
        -- select the range
        jump = { pos = 'range' },
      })
  end


  function() Flash.treesitter_search({ label = { before = true, after = true, style = 'inline' }, remote_op = { restore = true } }) end
  function() require('flash').jump({ mode = 'remote_ts' }) end
  function() require('flash').jump({ mode = 'remote_ts', treesitter = { starting_from_pos = true } }) end
  function() require('flash').jump({ mode = 'remote_ts', treesitter = { ending_at_pos = true } }) end
  function() require('flash').jump({ mode = 'remote_ts', treesitter = { end_of_node = true }, jump = { pos = 'end' } }) end
  function() require('flash').jump({ mode = 'remote_ts', treesitter = { start_of_node = true }, jump = { pos = 'start' } }) end
  function() require('flash').jump({ mode = 'textcase', pattern = vim.fn.expand('<cword>') }) end
  function() require('flash').jump({ mode = 'textcase', pattern = vim.fn.expand('<cWORD>') }) end
  function() require('flash').jump({ continue = true }) end

  function() lib.swap_with({ mode = 'remote_ts' }) end
  function() lib.swap_with() end
  function() lib.swap_with({ exchange = { visual_mode = 'V', } }) end
  function() lib.swap_with({ exchange = { not_there = true } }) end
  function() vim.api.nvim_feedkeys(';r', 'm', false) vim.schedule(function() require('flash').jump({ mode = 'remote_ts' }) end) end
  function() lib.swap_with({ exchange = { not_there = true } }) end
  function() lib.swap_with({ exchange = { not_there = true } }) end
  function() lib.swap_with({ mode = 'remote_ts', exchange = { not_there = true } }) end
  function() lib.swap_with({ mode = 'remote_ts', exchange = { not_there = true } }) end
  function() lib.swap_with({ mode = 'remote_ts', exchange = { not_there = true } }) end


ts.goto_prev = ts.goto_previous
ts.select_prev = ts.select_previous

ts.select_node_next = ts.goto_next .. ts.select_remote_dynamic
ts.select_node_prev = ts.goto_prev .. ts.select_remote_dynamic
ts.jump_node_end    = ts.goto_next .. ts.select_remote_dynamic
ts.jump_node_start  = ts.goto_prev .. ts.select_remote_dynamic
ts.jump_cword       = ts.goto_prefix .. 'W'
ts.jump_continue    = ts.goto_prefix .. 'n'

-- TODO: stop verbs from being labels TODO: allow searching continuations 'Flash <cword>', },
-- TODO: y<motion><something><leap><motion>
-- TODO: use leap?

local defs = {
  { ts.remote_jump,             { 'o', 'x' }, 'Remote Jump' },
  { ts.tree_search,              { 'n'      }, 'Treesitter Search | show labeled treesitter nodes around the search matches', },
  { ts.op_tree_search,          { 'x', 'o' }, 'Treesitter Search | show labeled treesitter nodes around the search matches', },
  { ts.select_remote_dynamic,   { 'o', 'x' }, 'Remote Node' },
  { ts.select_node_next,        { 'o', 'x' }, 'Select node' },
  { ts.select_node_prev,        { 'o', 'x' }, 'Select node' },
  { ts.jump_node_end,           { 'n'      }, 'Jump to end of node' },
  { ts.jump_node_start,         { 'n'      }, 'Jump to start of node' },
  { ts.jump_cword,              { 'n'      }, 'Flash <cWORD>' },
  { ts.jump_continue,           { 'n'      }, 'Continue Flash' },
  { ts.exchange_node,           { 'x', 'n' }, 'Exchange <motion1> with <node>' },
  { ts.exchange_motion,         { 'n', 'x' }, 'Exchange <motion1> with <motion2>' },
  { ts.exchange_vline,          { 'n', 'x' }, 'Exchange V<motion1> with V<motion2>' },
  { ts.remote_replace,          { 'n'      }, 'Remote Replace' },
  -- TODO: Copy there, Paste here
  -- NOTE: fix start
  { ts.replace_remote_motion,   { 'x', 'n' }, 'Replace with <remote-motion>' },
  { ts.replace_remote_d_motion, { 'x', 'n' }, 'Replace with d<remote-motion>' },
  { ts.replace_remote_c_motion, { 'x', 'n' }, 'Replace with c<remote-motion>' },
  { ts.replace_node,            { 'n'      }, 'Replace with <node>' },
  { ts.replace_d_node,          { 'x', 'n' }, 'Replace with d<node>' },
  { ts.replace_c_node,          { 'x', 'n' }, 'Replace with c<node>' },
-- NOTE: fix end
  { ts.remote_op,               { 'o', 'x' }, 'Replace remote op target' },
  { ts.remote,                  { 'n'     },     'Replace remote target' },
}
}
