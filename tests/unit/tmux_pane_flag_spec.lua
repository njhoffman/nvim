-- tmux.pane_flag: marks the tmux pane with @pane-is-vim while Neovim runs
local pane_flag = require("tmux.pane_flag")

local TMUX_ENV = { TMUX = "/tmp/tmux-1000/default,1,0", TMUX_PANE = "%7" }

describe("tmux.pane_flag", function()
  local calls

  local function setup(env, has_ui)
    calls = {}
    return pane_flag.setup({
      env = env,
      run = function(args, wait)
        table.insert(calls, { args = args, wait = wait or false })
      end,
      has_ui = function()
        return has_ui ~= false
      end,
    })
  end

  after_each(function()
    pcall(vim.api.nvim_del_augroup_by_name, "TmuxPaneFlag")
  end)

  it("builds set and unset commands for the pane", function()
    assert.same({ "tmux", "set-option", "-p", "-t", "%7", "@pane-is-vim", "1" }, pane_flag.command("%7", true))
    assert.same({ "tmux", "set-option", "-p", "-u", "-t", "%7", "@pane-is-vim" }, pane_flag.command("%7", false))
  end)

  it("sets the flag on VimEnter", function()
    assert.is_true(setup(TMUX_ENV))
    calls = {}
    vim.api.nvim_exec_autocmds("VimEnter", { group = "TmuxPaneFlag" })
    assert.same({ { args = pane_flag.command("%7", true), wait = false } }, calls)
  end)

  it("clears the flag, waiting, on suspend and on leave", function()
    setup(TMUX_ENV)
    calls = {}
    vim.api.nvim_exec_autocmds("VimSuspend", { group = "TmuxPaneFlag" })
    vim.api.nvim_exec_autocmds("VimLeavePre", { group = "TmuxPaneFlag" })
    local unset = { args = pane_flag.command("%7", false), wait = true }
    assert.same({ unset, unset }, calls)
  end)

  it("sets the flag again on resume", function()
    setup(TMUX_ENV)
    calls = {}
    vim.api.nvim_exec_autocmds("VimResume", { group = "TmuxPaneFlag" })
    assert.same({ { args = pane_flag.command("%7", true), wait = false } }, calls)
  end)

  it("does nothing outside tmux", function()
    assert.is_false(setup({}))
    assert.is_false(setup({ TMUX = "", TMUX_PANE = "%7" }))
    assert.is_false(setup({ TMUX = TMUX_ENV.TMUX, TMUX_PANE = "" }))
    assert.same({}, calls)
    assert.is_false(pcall(vim.api.nvim_get_autocmds, { group = "TmuxPaneFlag" }))
  end)

  it("leaves the flag to the outer Neovim inside a :terminal", function()
    assert.is_false(setup(vim.tbl_extend("force", TMUX_ENV, { NVIM = "/run/user/1000/nvim.1.0" })))
    assert.same({}, calls)
  end)

  it("does not set the flag without a UI (headless)", function()
    assert.is_true(setup(TMUX_ENV, false))
    vim.api.nvim_exec_autocmds("VimResume", { group = "TmuxPaneFlag" })
    assert.same({}, calls)
  end)
end)
