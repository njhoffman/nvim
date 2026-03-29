local v_utils = require("configs.vimade.utils")
local fade_controller = require("configs.vimade.fade_controller")
local range_hl = require("configs.vimade.range_hl")

local setup_user_cmds = function()
  local clear_commands = { "VimadeInfo" }
  for _, cmd in ipairs(clear_commands) do
    pcall(vim.api.nvim_del_user_command, cmd)
  end
  vim.api.nvim_create_user_command("VimadeInfo", v_utils.vimade_info, { desc = "vimade info" })

  vim.api.nvim_create_user_command(
    "VimadeReload",
    v_utils.vimade_reload,
    { desc = "reload vimade" }
  )

  vim.api.nvim_create_user_command("VimadeFadeAll", function()
    v_utils.vimade_fade_global()
  end, { desc = "apply global fade to all windows uniformly" })

  vim.api.nvim_create_user_command("VimadeUnfadeAll", function()
    v_utils.vimade_unfade_global()
  end, { desc = "remove global fade from all windows" })

  vim.api.nvim_create_user_command("VimadeFade", function(opts)
    local args = vim.split(opts.args, "%s+")
    local bufnr = tonumber(args[1]) or vim.api.nvim_get_current_buf()
    local level = args[2] or "0.5"
    local source = args[3] or "cmd"
    fade_controller.fade(bufnr, level, source)
  end, { nargs = "*", desc = "fade a buffer: VimadeFade [bufnr] [level] [source]" })

  vim.api.nvim_create_user_command("VimadeUnfade", function(opts)
    local bufnr = tonumber(opts.args) or vim.api.nvim_get_current_buf()
    fade_controller.unfade(bufnr)
  end, { nargs = "?", desc = "unfade a buffer: VimadeUnfade [bufnr]" })
end

local setup_autocommands = function()
  local augroup = vim.api.nvim_create_augroup("vimade_fade_controller", { clear = true })

  -- Clean up state for deleted buffers.
  vim.api.nvim_create_autocmd("BufDelete", {
    group = augroup,
    callback = function()
      fade_controller._cleanup()
      range_hl._cleanup()
    end,
  })
end

local setup = function()
  local fadelevel_cfg = {
    dimmed = 0.5,
    popup = 0.6,
    split = 0.6,
    global = 0.6,
    cmdline = 0.2,
    neotree = 0.8,
    whichkey = 0.8,
  }

  local vimade_cfg = {
    style = v_utils.style,
    fadelevel = fade_controller.make_fadelevel(fadelevel_cfg),
    -- ncmode = "focus",
    enablefocusfading = true,
    checkinterval = 500,
    focus = {
      providers = {
        filetypes = {
          default = {
            -- {'snacks', {}},
            -- { "mini", {} },
            -- { "hlchunk", {} },
            { "treesitter", { min_node_size = 2, exclude = { "if_statement" } } },

            -- if treesitter fails or there isn't a good match, fallback to blanks
            -- (similar to limelight)
            {
              "blanks",
              {
                min_size = 1,
                max_size = "35%",
              },
            },
            -- if blanks fails to find a good match, fallback to static 35%
            { "static", {
              size = "35%",
            } },
          },
        },
      },
    },
    -- usecursorhold = true,
    -- nohlcheck = false,
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
    -- win_config = { relative = true }, },
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
  }

  local setup_delay = vim.v.vim_did_enter == 1 and 500 or 3000
  vim.defer_fn(function()
    require("vimade").setup(vimade_cfg)
    setup_user_cmds()
    setup_autocommands()
    range_hl.enable_visual_restore()
  end, setup_delay)
end

setup()
