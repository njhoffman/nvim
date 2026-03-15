-- https://github.com/0x100101/lab.nvim

-- Debug Adapter Protocol plugins
-- Focused on Lua debugging with one-small-step-for-vimkind
-- How to use Lua debugging:

-- 1. Method 1: Debug current file (quick)
--   - Open a Lua file
--   - Set breakpoints with <leader>db or <F9>
--   - Run :DapLuaRunThis or <leader>dl
-- 2. Method 2: Two-instance debugging (full control)
--   - Instance A (debuggee): Run :DapLuaLaunch or <leader>dL
--   - Instance B (debugger): Set breakpoints, then <F5> or <leader>dc to attach
--   - Execute code in Instance A

-- Key mappings:
-- | Key                | Action                    |
-- |--------------------|---------------------------|
-- | <F5> / <leader>dc  | Continue                  |
-- | <F9> / <leader>db  | Toggle breakpoint         |
-- | <F10> / <leader>do | Step over                 |
-- | <F11> / <leader>di | Step into                 |
-- | <F12> / <leader>dO | Step out                  |
-- | <leader>dL         | Launch debug server (Lua) |
-- | <leader>dl         | Debug current Lua file    |
-- | <leader>dv         | Toggle DAP View           |
-- | <leader>dr         | Toggle REPL               |
-- | ]b / [b            | Next/prev breakpoint      |

local plugins = {
  -- Core DAP client
  {
    "mfussenegger/nvim-dap",
    lazy = true,
    cmd = {
      "DapContinue",
      "DapToggleBreakpoint",
      "DapStepOver",
      "DapStepInto",
      "DapStepOut",
      "DapTerminate",
    },
    keys = {
      {
        "<F5>",
        function()
          require("dap").continue()
        end,
        desc = "DAP Continue",
      },
      {
        "<F9>",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "DAP Toggle Breakpoint",
      },
      {
        "<F10>",
        function()
          require("dap").step_over()
        end,
        desc = "DAP Step Over",
      },
      {
        "<F11>",
        function()
          require("dap").step_into()
        end,
        desc = "DAP Step Into",
      },
      {
        "<F12>",
        function()
          require("dap").step_out()
        end,
        desc = "DAP Step Out",
      },
      {
        "<leader>db",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "Toggle Breakpoint",
      },
      {
        "<leader>dB",
        function()
          require("dap").set_breakpoint(vim.fn.input("Condition: "))
        end,
        desc = "Conditional Breakpoint",
      },
      {
        "<leader>dc",
        function()
          require("dap").continue()
        end,
        desc = "Continue",
      },
      {
        "<leader>dC",
        function()
          require("dap").run_to_cursor()
        end,
        desc = "Run to Cursor",
      },
      {
        "<leader>di",
        function()
          require("dap").step_into()
        end,
        desc = "Step Into",
      },
      {
        "<leader>do",
        function()
          require("dap").step_over()
        end,
        desc = "Step Over",
      },
      {
        "<leader>dO",
        function()
          require("dap").step_out()
        end,
        desc = "Step Out",
      },
      {
        "<leader>dp",
        function()
          require("dap").pause()
        end,
        desc = "Pause",
      },
      {
        "<leader>dr",
        function()
          require("dap").repl.toggle()
        end,
        desc = "Toggle REPL",
      },
      {
        "<leader>ds",
        function()
          require("dap").session()
        end,
        desc = "Session Info",
      },
      {
        "<leader>dt",
        function()
          require("dap").terminate()
        end,
        desc = "Terminate",
      },
      {
        "<leader>dw",
        function()
          require("dap.ui.widgets").hover()
        end,
        desc = "Widgets Hover",
      },
    },
    dependencies = {
      -- Lua debugging in Neovim
      {
        "jbyuki/one-small-step-for-vimkind",
        keys = {
          {
            "<leader>dL",
            function()
              require("osv").launch({ port = 8086 })
            end,
            ft = "lua",
            desc = "Launch Lua Debugger Server",
          },
          {
            "<leader>dl",
            function()
              require("osv").run_this()
            end,
            ft = "lua",
            desc = "Debug Current Lua File",
          },
        },
      },
    },
  },

  -- DAP View - lightweight debugging UI
  {
    "igorlfs/nvim-dap-view",
    dependencies = { "mfussenegger/nvim-dap" },
    lazy = true,
    cmd = { "DapViewOpen", "DapViewClose", "DapViewToggle", "DapViewWatch" },
    keys = {
      { "<leader>dv", "<cmd>DapViewToggle<cr>", desc = "Toggle DAP View" },
      { "<leader>dW", "<cmd>DapViewWatch<cr>", desc = "DAP Watch" },
    },
    opts = {
      winbar = {
        show = true,
        sections = { "watches", "exceptions", "breakpoints", "threads", "repl" },
        default_section = "watches",
      },
      windows = {
        height = 12,
        terminal = {
          position = "left",
          hide = {},
          start_hidden = false,
        },
      },
    },
  },

  -- Virtual text for variable values
  {
    "theHamsta/nvim-dap-virtual-text",
    dependencies = { "mfussenegger/nvim-dap", "nvim-treesitter/nvim-treesitter" },
    lazy = true,
    cmd = { "DapVirtualTextEnable", "DapVirtualTextDisable", "DapVirtualTextToggle" },
    opts = {
      enabled = true,
      enabled_commands = true,
      highlight_changed_variables = true,
      highlight_new_as_changed = false,
      show_stop_reason = true,
      commented = false,
      only_first_definition = true,
      all_references = false,
      filter_references_pattern = "<module",
      virt_text_pos = "eol",
      all_frames = false,
      virt_lines = false,
      virt_text_win_col = nil,
    },
  },

  -- Navigate between breakpoints
  {
    "ofirgall/goto-breakpoints.nvim",
    dependencies = { "mfussenegger/nvim-dap" },
    lazy = true,
    keys = {
      {
        "]b",
        function()
          require("goto-breakpoints").next()
        end,
        desc = "Next Breakpoint",
      },
      {
        "[b",
        function()
          require("goto-breakpoints").prev()
        end,
        desc = "Prev Breakpoint",
      },
    },
  },

  -- Persistent breakpoints across sessions
  {
    "Weissle/persistent-breakpoints.nvim",
    dependencies = { "mfussenegger/nvim-dap" },
    event = "BufReadPost",
    opts = {
      load_breakpoints_event = { "BufReadPost" },
    },
    keys = {
      {
        "<leader>dP",
        function()
          require("persistent-breakpoints.api").toggle_breakpoint()
        end,
        desc = "Toggle Persistent Breakpoint",
      },
      {
        "<leader>dX",
        function()
          require("persistent-breakpoints.api").clear_all_breakpoints()
        end,
        desc = "Clear All Breakpoints",
      },
    },
  },
}

return plugins
