local config = {
  prefix_char = "> ",
  filetype = {
    lua = {
      cmd = "lua",
    },
    javascript = {
      cmd = "node",
    },
  },
}

local eval_ns = vim.api.nvim_create_namespace("eval_ns")

local function set_virtual_text(data, pos)
  vim.api.nvim_buf_set_virtual_text(
    0,
    eval_ns,
    pos,
    { { config.prefix_char .. data:gsub("\n", ""), "TSComment" } },
    {}
  )
end

local lines = {}

local function display_result(data)
  set_virtual_text(data, lines[2] - 1)
end

local function onread(error, data)
  if error then
    print("ERROR: ", error)
  end
  if data then
    display_result(data)
  end
end

local function get_visual_selection()
  local _, begln, _, _ = unpack(vim.fn.getpos("'<'"))
  local _, endln, _, _ = unpack(vim.fn.getpos("'>'"))

  -- 1-based index line and column numbers
  return { begln, endln }
end

local function clear_virtual_text()
  vim.api.nvim_buf_clear_namespace(0, eval_ns, 0, -1)
end

local function get_lines(begln, endln)
  local selected = vim.api.nvim_buf_get_lines(0, begln - 1, endln, false)
  return table.concat(selected, "\n")
end

local function run(input, lines_)
  local filetype = vim.bo.filetype

  lines = lines_
  -- Creating the stream handles
  local stdin = vim.loop.new_pipe(false)
  local stdout = vim.loop.new_pipe(false)
  local stderr = vim.loop.new_pipe(false)
  local handle, pid

  if not config.filetype[filetype] then
    print("No setup for filetype " .. filetype .. ".")
    return
  elseif stdin == nil or stdout == nil or stderr == nil then
    print("Failed to create pipes.")
    return
  end

  local cmd = config.filetype[filetype].cmd
  handle, _ = vim.loop.spawn(cmd, {
    stdio = { stdin, stdout, stderr },
  }, function(code, signal)
    -- closing streams on exit
    stderr:read_stop()
    stdout:read_stop()
    stderr:close()
    stdout:close()
    stdin:close()
    handle:close()
  end)

  -- reading output from streams
  vim.loop.read_start(stderr, vim.schedule_wrap(onread))
  vim.loop.read_start(stdout, vim.schedule_wrap(onread))

  -- writing the input
  vim.loop.write(stdin, input)
  stdin:shutdown()
end

local eval = function(begln, endln)
  clear_virtual_text()
  local code = get_lines(begln, endln)
  run(code, { begln, endln })
end

vim.cmd([[
  command! -range=% Eval lua require("commands.eval").eval(<line1>, <line2>)
    ]])
return { eval = eval }
-- vim.api.nvim_create_user_command("Eval", eval, {})
