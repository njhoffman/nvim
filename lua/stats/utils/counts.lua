-- getcompletion({pat}, {type} [, {filtered}])
-- { arglist, augroup, buffer, breakpoint, cmdline, color, command, compiler, diff_buffer}
-- { dir, environment, event, expression, file, file_in_path, filetype, function, help }
-- { highlight, history, locale, mapclear, mapping, menu, messages, option, packadd  }
-- { runtime, scriptnames, shellcmd, sign, syntax, syntime, tag, tag_listfiles, user, var  }

local counts = {}

counts.aucommands = function()
  local aucounts = require("stats.utils.aucommands").traverse()
  return aucounts.total
end

counts.augroups = function()
  local aucounts = require("stats.utils.aucommands").traverse()
  return aucounts.groups
end

counts.namespaces = function()
  return #vim.tbl_keys(vim.api.nvim_get_namespaces())
end

counts.memory = function()
  local pid = vim.fn.getpid()
  return table.remove(vim.fn.systemlist("ps h -p " .. pid .. " -o rss"), 1)
end

counts.virtual = function()
  local pid = vim.fn.getpid()
  -- vim.uv.get_free_memory() get_total, get_available, get_constrained
  return table.remove(vim.fn.systemlist("ps h -p " .. pid .. " -o vsz"), 1)
end

counts.timers = function()
  local timers = vim.fn.timer_info()
  return #timers
end

counts.ext_leaked = function()
  local nsn = vim.api.nvim_get_namespaces()
  local count = 0
  for name, ns in pairs(nsn) do
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      count = count + #vim.api.nvim_buf_get_extmarks(buf, ns, 0, -1, {})
    end
  end
  return count
  -- local nsn = vim.api.nvim_get_namespaces()
  -- local count = 0
  -- for name, ns in pairs(nsn) do
  --   for _, buf in ipairs(vim.api.nvim_list_bufs()) do
  --     local extmarks = vim.api.nvim_buf_get_extmarks(buf, ns, 0, -1, {
  --       -- type = 'highlight', -- highlight, sign, virt_text, virt_lines
  --       details = true,
  --       hl_name = true,
  --     })
  --     -- extmarks[1][4] = { end_col = 68, end_right_gravity = false, end_row = 4, hl_eol = false, hl_group = "MatchParen", ns_id = 15, priority = 4096, right_gravity = true }
  --     -- extmarks[1][4].virtual_text = { [1] = { [1] = "", [2] = "ActionHintsDefinition" }, [2] = { [1] = "", [2] = "ActionHintsReferences" }, [3] = { [1] = " 9", [2] = "ActionHintsCodeActions" } }, virt_text_hide = false, virt_text_pos = "eol"virt_text = { [1] = { [1] = " ", [2] = "ScrollbarHandle" } }, virt_text_hide = false, virt_text_pos = "right_align" }
  --   end
  -- end
end

local get_options = function(scope, conf_opts)
  local res = {}
  scope = scope or "all"
  for _, v in pairs(vim.api.nvim_get_all_options_info()) do
    if scope == "all" or scope == v.scope then
      table.insert(res, v)
    end
  end
  table.sort(res, function(left, right)
    return left.scope .. left.name < right.scope .. right.name
  end)
  return res
end

counts.options_buffer = function()
  return #get_options("buf")
end

counts.options_window = function()
  return #get_options("win")
end

counts.options_global = function()
  return #get_options("global")
end

counts.options = function()
  return #get_options()
end

counts.packages = function()
  -- return #package.loaders   7
  -- return #package.path      345
  -- return #package.cpath     163
  -- return #package.config    10
  -- return #vim.tbl_keys(package.preload)
  return #vim.tbl_keys(package.loaded)
end

counts.windows = function()
  return #vim.api.nvim_list_wins()
end

counts.buffers = function()
  return #vim.api.nvim_list_bufs()
end

local exe_output = function(cmd)
  local cmd_lines = [[
    let temp_reg = @" | redir @" | silent! execute "]] .. cmd .. [[" | redir END
    let output = copy(@") | let @" = temp_reg | let w:output_len=len(split(output, "\n"))
  ]]
  vim.cmd(cmd_lines)
  return vim.api.nvim_eval("w:output_len")
end

--stylua: ignore
local count_commands = {
  { 'changes',          ':changes' },
  { 'commands',         ':command' },
  { 'functions',        ':function' },
  { 'highlights',       ':highlight' },
  { 'history',          ':history' },
  { 'messages',         ':message' },
  { 'oldfiles',         ':oldfiles' },
  { 'scriptnames',      ':scriptnames' },
  { 'variables',        ':let' },
  { 'variables_predef', ':let v:' },
  { 'variables_buffer', ':let b:' },
  { 'variables_window', ':let w:' },
  { 'variables_global', ':let g:' },
  -- {  menu, ':menu'},
  -- {  syntax, ':syntax'},
}

local function format_int(number)
  local i, j, minus, int, fraction = tostring(number):find("([-]?)(%d+)([.]?%d*)")
  int = int:reverse():gsub("(%d%d%d)", "%1,")
  return minus .. int:reverse():gsub("^,", "") .. fraction
end

for i, cmd_item in ipairs(count_commands) do
  local key, cmd = cmd_item[1], cmd_item[2]
  counts[key] = function()
    return exe_output(cmd)
  end
end

local get_counts = function(keys)
  local default_keys = {
    "virtual",
    "memory",
    "augroups",
    "aucommands",
    "variables",
    -- 'variables_predef',
    -- 'variables_buffer',
    -- 'variables_window',
    -- 'variables_global',
    -- 'options',
    -- 'options_buffer',
    -- 'options_window',
    -- 'options_global',
    -- "functions",
    -- "commands",
    -- "packages",
    -- "scriptnames",
    -- 'oldfiles',
    -- 'changes',
    -- 'history',
    "namespaces",
    "highlights",
    "ext_leaked",
    "timers",
    "windows",
    "buffers",
    -- syntax
    -- messages
    -- menu
  }
  keys = keys or default_keys
  local results = {}
  for _, key in ipairs(keys) do
    table.insert(results, { key, format_int(counts[key]()) })
  end
  return results
end

return { counts = counts, get_counts = get_counts }
