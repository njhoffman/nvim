#!/usr/bin/env lua

-- Add loader/ directory to package.path
local script_dir = arg[0]:match("(.*/)") or "./"
package.path = script_dir .. "loader/?.lua;" .. script_dir .. "loader/?/init.lua;" .. package.path

math.randomseed(os.time())

local config_mod = require("loader_config")
local log = require("loader_log")
local tmux = require("loader_tmux")
local socket = require("loader_socket")
local session = require("loader_session")
local gods = require("loader_gods")
local exec = require("loader_exec")
local commands = require("loader_commands")

-- Parse arguments: extract --subcmd=<name> and --help, collect the rest
local function parse_args(raw_args)
  local subcmd = nil
  local remaining = {}

  for i = 1, #raw_args do
    local a = raw_args[i]
    local sub = a:match("^%-%-subcmd=(.+)$")
    if sub then
      subcmd = sub
    else
      remaining[#remaining + 1] = a
    end
  end

  return subcmd, remaining
end

-- Parse file:line:col patterns into separate file and cursor args
-- Supports: file(line:col), file(line), file:line:col, file:line:, file:line
local function parse_file_location(a)
  if a:match("^%-") or a:match("^%+") then
    return { a }
  end

  local file, line, col

  file, line, col = a:match("^(.-)%((%d+):(%d+)%)$")
  if not file then
    file, line = a:match("^(.-)%((%d+)%)$")
  end
  if not file then
    file, line, col = a:match("^(.-):(%d+):(%d+)$")
  end
  if not file then
    file, line = a:match("^(.-):(%d+):$")
  end
  if not file then
    file, line = a:match("^(.-):(%d+)$")
  end

  if not file or file == "" then
    return { a }
  end

  local f = io.open(file, "r")
  if not f then
    return { a }
  end
  f:close()

  if col then
    return { "+call cursor(" .. line .. "," .. col .. ")", file }
  else
    return { "+" .. line, file }
  end
end

-- Expand file:line:col patterns in an args list
local function expand_file_locations(args)
  local expanded = {}
  for _, a in ipairs(args) do
    local parts = parse_file_location(a)
    for _, p in ipairs(parts) do
      expanded[#expanded + 1] = p
    end
  end
  return expanded
end

-- Build the nvim command string from an args table
local function nvim_cmd(nvim_bin, args)
  local parts = { nvim_bin }
  for _, a in ipairs(args) do
    -- Quote args that contain spaces or special chars
    if a:match("[%s\"'\\]") then
      parts[#parts + 1] = '"' .. a:gsub('"', '\\"') .. '"'
    else
      parts[#parts + 1] = a
    end
  end
  return table.concat(parts, " ")
end

-- Send files/commands to an existing nvim instance via --server
local function remote_open(nvim_bin, socket_path, nvim_args)
  if #nvim_args == 0 then
    -- No args: just focus the pane (handled by caller)
    return 0
  end

  nvim_args = expand_file_locations(nvim_args)

  -- Separate files from flags (-S, -c, etc.)
  local files = {}
  local cmds = {}
  local i = 1
  while i <= #nvim_args do
    local a = nvim_args[i]
    if a == "-S" and i < #nvim_args then
      -- Source session: send as command
      cmds[#cmds + 1] = "source " .. nvim_args[i + 1]
      i = i + 2
    elseif a:match("^%-c") then
      -- -c command or -c:command (joined)
      local cmd_str = a:match("^%-c(.+)$")
      if cmd_str then
        cmds[#cmds + 1] = cmd_str
      elseif i < #nvim_args then
        cmds[#cmds + 1] = nvim_args[i + 1]
        i = i + 1
      end
      i = i + 1
    elseif a:match("^%+") then
      -- +command syntax
      cmds[#cmds + 1] = a:sub(2)
      i = i + 1
    elseif not a:match("^%-") then
      files[#files + 1] = a
      i = i + 1
    else
      -- Unknown flag, skip
      i = i + 1
    end
  end

  -- Open files via --remote
  if #files > 0 then
    local args = { "--server", socket_path, "--remote" }
    for _, f in ipairs(files) do
      args[#args + 1] = f
    end
    exec.run(nvim_cmd(nvim_bin, args))
  end

  -- Send commands via --remote-send
  for _, cmd in ipairs(cmds) do
    local escaped = cmd:gsub('"', '\\"')
    local args = { "--server", socket_path, "--remote-send", ":" .. escaped .. "<CR>" }
    exec.run(nvim_cmd(nvim_bin, args))
  end

  return 0
end

-- Launch a new nvim instance with --listen
local function launch_new(config, socket_path, nvim_args)
  local args = { "--listen", socket_path }
  if config.startuptime then
    args[#args + 1] = "--startuptime"
    args[#args + 1] = config.startuptime
  end
  for _, a in ipairs(nvim_args) do
    args[#args + 1] = a
  end
  log.info("create new socket: " .. socket_path .. " -- args: (" .. #nvim_args .. "): " .. table.concat(nvim_args, " "))
  return exec.run(nvim_cmd(config.nvim_bin, args))
end

-- Launch nvim directly (no socket management)
local function launch_direct(config, nvim_args)
  local args = {}
  if config.remote.listen_address then
    args[#args + 1] = "--listen"
    args[#args + 1] = config.remote.listen_address
  end
  if config.startuptime then
    args[#args + 1] = "--startuptime"
    args[#args + 1] = config.startuptime
  end
  for _, a in ipairs(nvim_args) do
    args[#args + 1] = a
  end
  log.info("command nvim: " .. table.concat(args, " "))
  return exec.run(nvim_cmd(config.nvim_bin, args))
end

-- Main run loop (equivalent to nvim.run in bash)
local function run(user_args, config)
  local ran_once = false
  local reload_session = nil
  local prefix = socket.get_prefix(config, tmux)

  -- Get saved session (only in tmux)
  local saved_session = nil
  if tmux.is_active() then
    local session_name = tmux.session_name()
    saved_session = session.get_saved(config.sessions.saved_dir, session_name)
  end

  local nvim_args = { unpack(user_args) }

  while not ran_once or reload_session do
    session.clean_temp(config.sessions.load_dir, prefix)

    -- Determine what session/args to use
    if reload_session and exec.file_exists(reload_session) then
      if reload_session:match("_runonce%.vim$") then
        reload_session = session.prepare_reload(reload_session)
      end
      nvim_args = { "-S", reload_session }
      log.info("reload: " .. reload_session)
    elseif saved_session and exec.file_exists(saved_session) then
      nvim_args = { "-S", saved_session }
      log.info("load saved: " .. saved_session)
    end

    -- Launch nvim
    if tmux.is_active() and config.remote.attach_on ~= "none" then
      local existing = socket.find_existing(config.remote.sockets_dir, prefix)

      if existing and socket.is_alive(existing, config.nvim_bin) then
        -- Attach to existing instance
        local pane_id = tmux.get_nvim_pane()
        log.info("nvim existing: " .. existing .. " - pane: " .. (pane_id or "?") .. " -- nvim " .. table.concat(nvim_args, " "))
        remote_open(config.nvim_bin, existing, nvim_args)
        tmux.focus_pane(pane_id)
        return 0
      elseif existing then
        -- Stale socket
        socket.cleanup(existing, log)
      end

      -- Create new socket and launch
      local god_name = gods.random(config.gods_file)
      local new_socket = socket.create(config.remote.sockets_dir, prefix, god_name)
      log.info("create socket: " .. new_socket)
      launch_new(config, new_socket, nvim_args)
    else
      launch_direct(config, nvim_args)
    end

    -- After nvim exits
    session.clean_temp(config.sessions.load_dir, prefix)
    reload_session = session.get_reload(config.sessions.load_dir, prefix)
    nvim_args = {}
    ran_once = true
  end

  -- Remove remaining "always reload" sessions
  if reload_session and reload_session:match("_always%.vim$") then
    log.info("removing always on session: " .. reload_session)
    exec.remove(reload_session)
  end

  return 0
end

-- Entry point
local function main()
  -- Passthrough --help
  if arg[1] == "--help" then
    os.execute("nvim --help")
    os.exit(0)
  end

  local config = config_mod.load()
  log.setup(config)

  local subcmd, remaining = parse_args(arg)

  if subcmd then
    local result, modified_args = commands.dispatch(subcmd, config, remaining)
    if result ~= nil then
      os.exit(result)
    end
    -- Some subcommands (rm, rml) modify args then continue to normal run
    if modified_args then
      remaining = modified_args
    end
  end

  remaining = expand_file_locations(remaining)
  local exit_code = run(remaining, config)
  os.exit(exit_code)
end

main()
