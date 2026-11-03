-- Marks the tmux pane this Neovim runs in with the pane option @pane-is-vim
-- while Neovim holds the terminal. The tmux bindings that pass keys through
-- to Neovim (alt-hjkl, ctrl-hjkl in ~/.config/tmux/conf.d/panes.conf) read it
-- with a format check (if -F), so a keypress no longer runs ps.
local M = {}

M.option = "@pane-is-vim"

-- The tmux command that sets (on) or unsets the flag on a pane.
function M.command(pane, on)
  if on then
    return { "tmux", "set-option", "-p", "-t", pane, M.option, "1" }
  end
  return { "tmux", "set-option", "-p", "-u", "-t", pane, M.option }
end

-- Runs a tmux command; wait blocks (briefly) so the flag is cleared before
-- Neovim suspends or exits and the shell gets the keys back.
local function default_run(args, wait)
  local ok, job = pcall(vim.system, args, { text = true })
  if ok and wait then
    pcall(job.wait, job, 500)
  end
end

local function default_has_ui()
  return #vim.api.nvim_list_uis() > 0
end

-- opts (for tests): env (default vim.env), run(args, wait), has_ui().
-- Returns true when the autocommands were installed.
function M.setup(opts)
  opts = opts or {}
  local env = opts.env or vim.env
  local run = opts.run or default_run
  local has_ui = opts.has_ui or default_has_ui
  local pane = env.TMUX_PANE
  if not env.TMUX or env.TMUX == "" or not pane or pane == "" then
    return false
  end
  -- Inside a :terminal of another Neovim the outer one owns the pane's flag.
  if env.NVIM and env.NVIM ~= "" then
    return false
  end

  local function set(on, wait)
    run(M.command(pane, on), wait)
  end
  local function enter()
    -- Headless Neovim (scripts, test runners) never reads the pane's keys.
    if has_ui() then
      set(true)
    end
  end

  local group = vim.api.nvim_create_augroup("TmuxPaneFlag", { clear = true })
  vim.api.nvim_create_autocmd({ "VimEnter", "VimResume" }, {
    group = group,
    desc = "Mark the tmux pane as running Neovim",
    callback = enter,
  })
  vim.api.nvim_create_autocmd({ "VimSuspend", "VimLeavePre" }, {
    group = group,
    desc = "Clear the tmux pane's Neovim mark",
    callback = function()
      set(false, true)
    end,
  })
  if vim.v.vim_did_enter == 1 then
    enter()
  end
  return true
end

return M
