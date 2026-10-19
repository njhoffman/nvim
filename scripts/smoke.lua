-- Headless smoke test of the full config: startup, VeryLazy, filetype loads.
-- Collects deprecation warnings, notifications at WARN or above, and :messages.
-- Usage: nvim --headless --cmd "luafile scripts/smoke.lua" 2>stderr.log
-- Env: SMOKE_OUT=<dir> (required) receives report.txt and checkhealth.txt

local out_dir = assert(os.getenv("SMOKE_OUT"), "SMOKE_OUT is required")
vim.fn.mkdir(out_dir, "p")

local entries = {}
local seen = {}

local function caller()
  for level = 3, 30 do
    local info = debug.getinfo(level, "Sl")
    if not info then
      break
    end
    local src = info.short_src or ""
    if
      not src:find("vim/_core", 1, true)
      and not src:find("vim/shared", 1, true)
      and not src:find("smoke.lua", 1, true)
      and src ~= "[C]"
    then
      return src .. ":" .. (info.currentline or 0)
    end
  end
  return "?"
end

local function record(kind, msg, where)
  msg = tostring(msg):gsub("\n+$", "")
  local key = kind .. msg .. (where or "")
  if seen[key] then
    return
  end
  seen[key] = true
  table.insert(entries, { kind = kind, msg = msg, where = where or "" })
end

local orig_deprecate = vim.deprecate
vim.deprecate = function(name, alternative, version, plugin, backtrace)
  record("deprecated", ("%s -> %s (removal %s, %s)"):format(name, alternative or "-", version or "?", plugin or "Nvim"), caller())
  return orig_deprecate(name, alternative, version, plugin, backtrace)
end

-- Plugins replace vim.notify (noice, nvim-notify), so re-wrap whatever is current
local function wrap_notify()
  local current = vim.notify
  if rawequal(current, _G.__smoke_notify) then
    return
  end
  local wrapped = function(msg, level, opts)
    if (level or vim.log.levels.INFO) >= vim.log.levels.WARN then
      record(level >= vim.log.levels.ERROR and "error" or "warn", msg, caller())
    end
    return current(msg, level, opts)
  end
  vim.notify = wrapped
  _G.__smoke_notify = wrapped
end
wrap_notify()

local function write_report()
  local messages = vim.api.nvim_exec2("messages", { output = true }).output
  local report = {}
  for _, e in ipairs(entries) do
    local where = e.where ~= "" and ("  @ " .. e.where) or ""
    table.insert(report, ("[%s] %s%s"):format(e.kind, e.msg, where))
  end
  table.insert(report, "")
  table.insert(report, "===== :messages =====")
  vim.list_extend(report, vim.split(messages, "\n"))
  vim.fn.writefile(report, out_dir .. "/report.txt")
end

-- Watchdog: a step that blocks (prompt, getchar) is answered with <CR>, then abandoned
local current_step, step_started = nil, 0
local watchdog = assert(vim.uv.new_timer())
watchdog:start(1000, 1000, function()
  if not current_step then
    return
  end
  local elapsed = vim.uv.now() - step_started
  if elapsed > 10000 and elapsed < 11000 then
    vim.schedule(function()
      record("hang", ("step '%s' blocked > 10s, sending <CR>"):format(current_step), "")
    end)
    vim.api.nvim_input("<CR>")
  elseif elapsed > 30000 then
    watchdog:stop()
    vim.schedule(function()
      record("hang", ("step '%s' blocked > 30s, aborting"):format(current_step), "")
      write_report()
      vim.cmd("qa!")
    end)
  end
end)

local function step(name, fn)
  wrap_notify()
  current_step, step_started = name, vim.uv.now()
  vim.fn.writefile({ name }, out_dir .. "/progress.txt", "a")
  local ok, err = xpcall(fn, debug.traceback)
  if not ok then
    record("error", ("step '%s' failed: %s"):format(name, err), "")
  end
  vim.wait(400)
  current_step = nil
  wrap_notify()
end

local samples = {
  lua = "local x = 1\nreturn x\n",
  py = "def f():\n    return 1\n",
  js = "const x = () => 1;\n",
  ts = "const x: number = 1;\n",
  tsx = "export const A = () => <div />;\n",
  json = '{ "a": 1 }\n',
  md = "# Title\n\n- item\n",
  sh = "#!/usr/bin/env bash\necho hi\n",
  yaml = "a: 1\n",
  go = "package main\nfunc main() {}\n",
  rs = "fn main() {}\n",
  html = "<html><body></body></html>\n",
  css = "a { color: red; }\n",
  toml = "a = 1\n",
  vim = "let g:x = 1\n",
  http = "GET https://example.com\n",
  sql = "select 1;\n",
}

vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = vim.schedule_wrap(function()
    local sample_dir = out_dir .. "/samples"
    vim.fn.mkdir(sample_dir, "p")

    step("deferred startup", function()
      vim.wait(1500)
    end)

    step("VeryLazy", function()
      if not vim.g.did_very_lazy then
        vim.g.did_very_lazy = true
        vim.api.nvim_exec_autocmds("User", { pattern = "VeryLazy", modeline = false })
      end
      vim.wait(1000)
    end)

    for ext, body in vim.spairs(samples) do
      step("open ." .. ext, function()
        local path = sample_dir .. "/sample." .. ext
        vim.fn.writefile(vim.split(body, "\n"), path)
        vim.cmd.edit(vim.fn.fnameescape(path))
        vim.wait(300)
      end)
    end

    -- SMOKE_PLUGINS=a.nvim,b.nvim (or "all") force-loads plugins that are lazy on cmd/keys
    local wanted = os.getenv("SMOKE_PLUGINS") or ""
    if wanted == "all" then
      local names = vim.tbl_keys(require("lazy.core.config").plugins)
      table.sort(names)
      wanted = table.concat(names, ",")
    end
    for name in vim.gsplit(wanted, ",", { trimempty = true }) do
      step("load " .. name, function()
        require("lazy").load({ plugins = { vim.trim(name) } })
        vim.wait(300)
      end)
    end

    step("gitcommit buffer", function()
      vim.cmd.enew()
      vim.bo.filetype = "gitcommit"
    end)

    -- SMOKE_HEALTH="rest-nvim avante" adds :checkhealth sections to checkhealth.txt
    local health = vim.trim("vim.deprecated " .. (os.getenv("SMOKE_HEALTH") or ""))

    step("checkhealth " .. health, function()
      vim.cmd("checkhealth " .. health)
      vim.wait(500)
      local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
      vim.fn.writefile(lines, out_dir .. "/checkhealth.txt")
    end)

    watchdog:stop()
    write_report()
    vim.cmd("qa!")
  end),
})
