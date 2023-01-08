local M = {}

M.get_table = function()
  local autocmd_table = {}

  local pattern = {}
  pattern.BUFFER = "<buffer=%d+>"
  pattern.EVENT = "[%a]+"
  pattern.GROUP = "[%a%d_:]+"
  pattern.INDENT = "^%s%s%s%s" -- match indentation of 4 spaces

  local event, group, ft_pat, cmd, source_file, source_lnum
  local current_event, current_group, current_ft

  local inner_loop = function(line)
    -- capture group and event
    group, event = line:match("^(" .. pattern.GROUP .. ")%s+(" .. pattern.EVENT .. ")")
    -- ..or just an event
    if event == nil then event = line:match("^(" .. pattern.EVENT .. ")") end

    if event then
      group = group or "<anonymous>"
      if event ~= current_event or group ~= current_group then
        current_event = event
        current_group = group
      end
      return
    end

    -- non event/group lines
    ft_pat = line:match(pattern.INDENT .. "(%S+)")
    if ft_pat then
      if ft_pat:match "^%d+" then ft_pat = "<buffer=" .. ft_pat .. ">" end
      current_ft = ft_pat

      -- is there a command on the same line?
      cmd = line:match(pattern.INDENT .. "%S+%s+(.+)")
      return
    end

    if current_ft and cmd == nil then
      -- trim leading spaces
      cmd = line:gsub("^%s+", "")
      return
    end

    if current_ft and cmd then
      source_file, source_lnum = line:match "Last set from (.*) line (.*)"
      if source_file then
        local autocmd = {}

        autocmd.event = current_event
        autocmd.group = current_group
        autocmd.ft_pattern = current_ft
        autocmd.command = cmd
        autocmd.source_file = source_file
        autocmd.source_lnum = source_lnum
        table.insert(autocmd_table, autocmd)
        cmd = nil
      end
    end
  end

  local cmd_output = vim.fn.execute("verb autocmd *", "silent")
  for line in cmd_output:gmatch "[^\r\n]+" do inner_loop(line) end
  return autocmd_table
end

-- TODO: strip this down
M.get_counts = function()
  local autocmd_table = {}
  local aucounts = { commands = 0, groups = 0}

  local pattern = {}
  pattern.BUFFER = "<buffer=%d+>"
  pattern.EVENT = "[%a]+"
  pattern.GROUP = "[%a%d_:]+"
  pattern.INDENT = "^%s%s%s%s" -- match indentation of 4 spaces

  local event, group, ft_pat, cmd, source_file, source_lnum
  local current_event, current_group, current_ft

  local inner_loop = function(line)
    -- capture group and event
    group, event = line:match("^(" .. pattern.GROUP .. ")%s+(" .. pattern.EVENT .. ")")
    -- ..or just an event
    if event == nil then event = line:match("^(" .. pattern.EVENT .. ")") end

    if event then
      group = group or "<anonymous>"
      if event ~= current_event or group ~= current_group then
        aucounts.groups = aucounts.groups + 1
        current_event = event
        current_group = group
      end
      return
    end

    -- non event/group lines
    ft_pat = line:match(pattern.INDENT .. "(%S+)")
    if ft_pat then
      if ft_pat:match "^%d+" then ft_pat = "<buffer=" .. ft_pat .. ">" end
      current_ft = ft_pat

      -- is there a command on the same line?
      cmd = line:match(pattern.INDENT .. "%S+%s+(.+)")
      return
    end

    if current_ft and cmd == nil then
      -- trim leading spaces
      cmd = line:gsub("^%s+", "")
      return
    end

    if current_ft and cmd then
      source_file, source_lnum = line:match "Last set from (.*) line (.*)"
      if source_file then
        local autocmd = {}
        autocmd.event = current_event
        autocmd.group = current_group
        autocmd.ft_pattern = current_ft
        autocmd.command = cmd
        autocmd.source_file = source_file
        autocmd.source_lnum = source_lnum
        table.insert(autocmd_table, autocmd)
        aucounts.commands = aucounts.commands + 1
        cmd = nil
      end
    end
  end

  local cmd_output = vim.fn.execute("verb autocmd *", "silent")

  for line in cmd_output:gmatch "[^\r\n]+" do inner_loop(line) end

  local entries_n = 0
  for i, _ in pairs(autocmd_table) do entries_n = i end

  local groups_n = 0
  for i, _ in pairs(vim.fn.getcompletion("", "augroup")) do groups_n = i end

  return { groups = groups_n, commands = entries_n }
end

return M
