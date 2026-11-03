-- The clipboard provider: + is written here, at once, because unnamedplus makes
-- every `p` read it back (`ddp` must see the delete). Everything else about a copy
-- (a tmux buffer, the history, its context) belongs to `clipd yank`, which runs in
-- the background with the destinations of ~/.config/clipd/config.toml. Without
-- clipd, a yank still gets a tmux buffer.
local M = {}

-- A flush runs once, on the tick after both the provider and TextYankPost ran:
-- neovim calls them in a different order for yanks and deletes.
local pending = { text = nil, event = nil, scheduled = false }

local function has_clipd()
  if M._has_clipd == nil then
    M._has_clipd = vim.fn.executable("clipd") == 1
  end
  return M._has_clipd
end

local function classify(event)
  local name = vim.api.nvim_buf_get_name(0)
  if vim.fs.basename(name):match("^claude%-prompt") then
    return "claude"
  end
  if event and event.operator ~= "y" then
    return "nvim-delete"
  end
  return "nvim"
end

local function context(event)
  local ctx = {
    "filetype=" .. vim.bo.filetype,
    "file=" .. vim.api.nvim_buf_get_name(0),
    "cwd=" .. vim.fn.getcwd(),
  }
  if event then
    table.insert(ctx, "operator=" .. event.operator)
    table.insert(ctx, "lines=" .. event.lines)
  end
  if vim.env.TMUX_PANE then
    table.insert(ctx, "pane=" .. vim.env.TMUX_PANE)
  end
  return ctx
end

local function flush()
  local text, event = pending.text, pending.event
  pending.text, pending.event, pending.scheduled = nil, nil, false
  if not text then
    return
  end
  local source = classify(event)
  if has_clipd() then
    local cmd = { "clipd", "yank", "--source", source, "--skip", "clipboard" }
    for _, item in ipairs(context(event)) do
      vim.list_extend(cmd, { "--ctx", item })
    end
    vim.system(cmd, { stdin = text, text = false })
  elseif source == "nvim" and vim.env.TMUX then
    vim.system({ "tmux", "load-buffer", "-" }, { stdin = text, text = false })
  end
end

local function schedule_flush()
  if not pending.scheduled then
    pending.scheduled = true
    vim.schedule(flush)
  end
end

function M.on_yank(event)
  local first, last = vim.fn.line("'["), vim.fn.line("']")
  pending.event = {
    operator = event.operator,
    lines = first == last and tostring(first) or (first .. "-" .. last),
  }
  schedule_flush()
end

local function copy_plus(lines)
  local text = table.concat(lines, "\n")
  vim.fn.system("xsel -i -b", text)
  pending.text = text
  schedule_flush()
end

local function copy_star(lines)
  vim.fn.system("xsel -i -p", table.concat(lines, "\n"))
end

local function paster(flag)
  return function()
    -- Try xsel first, fallback to tmux
    local xsel_result = vim.fn.system("xsel -o " .. flag)
    if vim.v.shell_error == 0 and xsel_result ~= "" then
      return vim.split(xsel_result, "\n")
    end
    return vim.split(vim.fn.system("tmux save-buffer - 2>/dev/null"), "\n")
  end
end

function M.setup()
  vim.g.clipboard = {
    name = "xsel_clipd",
    copy = { ["+"] = copy_plus, ["*"] = copy_star },
    paste = { ["+"] = paster("-b"), ["*"] = paster("-p") },
    cache_enabled = 1,
  }
  vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("ClipdYank", { clear = true }),
    callback = function()
      -- Only registers that reach the provider; "ay stays inside neovim.
      local reg = vim.v.event.regname
      if reg == "" or reg == "+" then
        M.on_yank(vim.v.event)
      end
    end,
  })
end

return M
