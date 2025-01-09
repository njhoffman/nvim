local v_utils = require("configs.vimade.utils")

local setup_auto_cmds = function()
  vim.api.nvim_create_augroup("VimadeEvents", { clear = true })
  vim.api.nvim_create_autocmd({ "FocusLost", "WinLeave" }, {
    group = "VimadeEvents",
    callback = function(ev)
      -- local winid = vim.fn.bufwinid(ev.buf)
      -- vim.dbglog(ev.event)
      -- M.vimade_fade_global(0.5)
    end,
  })
  --
  -- -- vim.cmd('VimadeFadeActive')
  vim.api.nvim_create_autocmd({ "FocusGained", "WinEnter" }, {
    group = "VimadeEvents",
    callback = function(ev)
      -- local winid = vim.fn.bufwinid(ev.buf)
      -- vim.dbglog(ev.event)
      -- M.vimade_unfade_global()
    end,
  })
end

local setup_user_cmds = function()
  local clear_commands = { "VimadeInfo" }
  for _, cmd in ipairs(clear_commands) do
    vim.api.nvim_del_user_command(cmd)
  end
  vim.api.nvim_create_user_command(
    "VimadeReload",
    v_utils.vimade_reload,
    { desc = "reload vimade" }
  )

  vim.api.nvim_create_user_command("VimadeFadeAll", function()
    v_utils.vimade_fade_global()
  end, { desc = "apply global fade to all windows uniformly" })

  vim.api.nvim_create_user_command("VimadeUnfadeAll", function()
    M.vimade_unfade_global()
  end, { desc = "remove global fade from all windows" })
end

local setup = function()
  local fadelevel_cfg = {
    popup = 0.6,
    split = 0.7,
    global = 0.5,
    cmdline = 0.8,
    neotree = 0.8,
    whichkey = 0.8,
  }
  local vimade_cfg = {
    style = v_utils.style,
    fadelevel = v_utils.fadelevel(fadelevel_cfg),
    enablefocusfading = true,
    -- blocklist = {
    -- only_behind_float_windows = function(win, current)
    --   -- current can be nil
    --   if (win.win_config.relative == "") and (current and current.win_config.relative ~= "") then
    --     return false
    --   end
    --   return true
    -- end,
    -- buf_opts = {
    --   buftype = { "terminal" },
    --   filetype = {},
    -- },
    -- wintype = true,
    -- win_config = {},
    -- win_config = { relative = true },
    -- },
    -- filetype = {
    --   "CompetiTest",
    --   "Mundo",
    --   "MundoDiff",
    --   "NvimTree",
    --   "SidebarNvim",
    --   "Trouble",
    --   "aerial",
    --   "cmp_menu",
    --   "dap-log",
    --   "dap-repl",
    --   "dapui_breakpoints",
    --   "dapui_console",
    --   "dapui_scopes",
    --   "dapui_stacks",
    --   "dapui_watches",
    --   "neo-tree",
    --   "nerdtree",
    --   "noice",
    --   "tablegen",
    -- },
    -- normalncid = 0,
    -- ncmode = "buffers",
    -- nc_windows = true,
    -- nc_buffers = true,
    -- link = {},
    -- groupdiff = 1,
    -- groupscrollbind = 0,
    -- normalid = "",
    -- normalncid = "",
    -- nohlcheck = 1,
  }

  local setup_delay = vim.v.vim_did_enter == 1 and 500 or 3000
  vim.defer_fn(function()
    vim.dbglog("loading vimade: " .. vim.v.vim_did_enter)
    require("vimade").setup(vimade_cfg)
    setup_user_cmds()
    setup_auto_cmds()
  end, setup_delay)
end

setup()
