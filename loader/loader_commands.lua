local exec = require("loader_exec")

local M = {}

-- Helper: build and run an nvim command with args
local function run_nvim(config, args)
  local parts = { config.nvim_bin }
  for _, a in ipairs(args) do
    parts[#parts + 1] = '"' .. a:gsub('"', '\\"') .. '"'
  end
  return exec.run(table.concat(parts, " "))
end

-- Helper: quote a shell arg
local function quote(s)
  return "'" .. s:gsub("'", "'\\''") .. "'"
end

M.handlers = {}

-- nvim.link: start a linked instance with renamed socket
function M.handlers.link(config, remaining_args, ctx)
  local socket = require("loader_socket")
  local tmux = require("loader_tmux")

  local existing = nil
  local prefix = socket.get_prefix(config, tmux)
  if prefix then
    existing = socket.find_existing(config.remote.sockets_dir, prefix)
  end

  local linked_addr = nil
  if existing then
    linked_addr = existing:gsub("nvim", "nvim_linked")
  else
    linked_addr = config.remote.sockets_dir .. "/nvim_linked_" .. os.time()
  end

  local args = { "--listen", linked_addr }
  for _, a in ipairs(remaining_args) do
    args[#args + 1] = a
  end
  return run_nvim(config, args)
end

-- nvim.rm: remove existing socket, then run normally
function M.handlers.rm(config, remaining_args, ctx)
  local socket = require("loader_socket")
  local tmux = require("loader_tmux")

  local prefix = socket.get_prefix(config, tmux)
  if prefix then
    local existing = socket.find_existing(config.remote.sockets_dir, prefix)
    if existing then
      exec.remove(existing)
    end
  end

  -- Return nil to signal "continue with normal run"
  return nil, remaining_args
end

-- nvim.rml: remove socket + open last file
function M.handlers.rml(config, remaining_args, ctx)
  local socket = require("loader_socket")
  local tmux = require("loader_tmux")

  local prefix = socket.get_prefix(config, tmux)
  if prefix then
    local existing = socket.find_existing(config.remote.sockets_dir, prefix)
    if existing then
      exec.remove(existing)
    end
  end

  local args = { "-c:e#<1" }
  for _, a in ipairs(remaining_args) do
    args[#args + 1] = a
  end
  return nil, args
end

-- nvim.sync: headless lazy sync
function M.handlers.sync(config, remaining_args)
  return run_nvim(config, { "--headless", "+Lazy! sync", "+qa" })
end

-- nman: open man page in nvim with telescope fallback
function M.handlers.man(config, remaining_args)
  local cmd = "hide Man"
  local section = nil
  local manpage = nil

  for _, arg in ipairs(remaining_args) do
    if arg == "-v" then
      cmd = "vertical Man"
    elseif arg == "-h" then
      cmd = "horizontal Man"
    elseif arg:match("^%-[0-9]") then
      section = arg
    else
      manpage = arg
    end
  end

  if not manpage then
    return run_nvim(config, { "+Telescope man_pages" })
  end

  -- Check if manpage exists
  local check = exec.run("man -w " .. quote(manpage) .. " >/dev/null 2>&1")
  if check ~= 0 then
    return run_nvim(config, { "+Telescope man_pages" })
  end

  local man_cmd = "+" .. cmd .. " " .. manpage
  if section then
    man_cmd = man_cmd .. " " .. section
  end
  return run_nvim(config, { man_cmd })
end

-- qvim: open quickfix from file or command
function M.handlers.qf(config, remaining_args)
  if #remaining_args > 0 and exec.file_exists(remaining_args[1]) then
    return run_nvim(config, { "-q", remaining_args[1] })
  end
  -- No file arg -- can't replicate shell's fc (last command) from lua
  io.stderr:write("qf: provide a file path containing error output\n")
  return 1
end

-- qvimw: open quickfix window
function M.handlers.qfwin(config, remaining_args)
  io.stderr:write("qfwin: provide a file path containing error output\n")
  return 1
end

-- nvim.diff
function M.handlers.diff(config, remaining_args)
  local args = { "-d" }
  for _, a in ipairs(remaining_args) do
    args[#args + 1] = a
  end
  return run_nvim(config, args)
end

-- lvim: open last file
function M.handlers.last(config, remaining_args)
  local args = { "-c:e#<1" }
  for _, a in ipairs(remaining_args) do
    args[#args + 1] = a
  end
  return run_nvim(config, args)
end

-- nvim.update: build nvim from source
function M.handlers.update(config, remaining_args)
  local tag = remaining_args[1] or "nightly"
  local old_version = exec.capture(config.nvim_bin .. " --version | head -n1") or "unknown"

  local home = os.getenv("HOME") or ""
  local script = table.concat({
    "rm -rfv " .. quote(home .. "/.local/share/nvim/runtime"),
    "cd " .. quote(home .. "/git/neovim"),
    "git checkout master",
    "git pull --tags --force",
    "git checkout " .. quote(tag),
    "make distclean",
    "make deps",
    "make CMAKE_BUILD_TYPE=RelWithDebInfo CMAKE_INSTALL_PREFIX=" .. quote(home .. "/.local") .. " install",
    "install build/bin/nvim " .. quote(home .. "/.local/bin"),
  }, " && ")

  local code = exec.run(script)

  local new_version = exec.capture(config.nvim_bin .. " --version | head -n1") or "unknown"
  print("Updated from:\n" .. old_version .. "\n" .. new_version)
  return code
end

-- Dispatch a subcommand. Returns:
--   exit_code (if handled completely)
--   nil, new_args (if should continue to normal run with modified args)
function M.dispatch(subcmd, config, remaining_args, ctx)
  local handler = M.handlers[subcmd]
  if not handler then
    io.stderr:write("unknown subcommand: " .. subcmd .. "\n")
    return 1
  end
  return handler(config, remaining_args, ctx)
end

return M
