local output = require("stats.output")
local utils = require("stats.utils")
-- local list_align = require("notify.parsers.list_align")

local completion = function(stats_map)
  return function(query, cmd)
    if query == "" then
      cmd = string.gsub(string.gsub(cmd, "Stats ", ""), " $", "")
      local cmds = {}
      if #cmd > 0 then
        local stats_cmd = vim.tbl_get(stats_map, unpack(vim.split(cmd, " ")))
        if stats_cmd ~= nil then
          if vim.isarray(stats_cmd) then
            cmds = vim.tbl_values(stats_cmd)
          else
            cmds = vim.tbl_keys(stats_cmd)
          end
        end
      else
        cmds = vim.tbl_keys(stats_map)
      end
      return cmds
    end
  end
end

local stats_overview = function(view)
  view = view or "notify"
  local counts = utils.get_counts()
  -- local lines, hls = list_align(counts)
  -- FIX:  error when title is not array
  -- output[view](lines, nil, hls)

  local lines, hls = utils.align_list(counts)
  output[view](lines, "Overview", hls)
end

local command = function(cmd)
  --stylua: ignore
  local cmd_map = {
    keys    = require('stats.commands.keys'),
    lazy    = require('stats.commands.lazy'),
    profile = require('stats.commands.profile'),
    files  = require('stats.commands.files'),
  }
  if cmd_map[cmd.fargs[1]] then
    cmd_map[cmd.fargs[1]].stats(cmd.fargs)
  else
    stats_overview(cmd.fargs[1])
  end
end

return { command = command, completion = completion }
