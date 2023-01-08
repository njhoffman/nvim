local M = {
  continue1 = {
    cmd   = "<cmd>lua require('dap').continue()<cr>",
    short = "dap continue",
    long  = "dap continue",
  },
  step_over1 = {
    cmd   = "<cmd>lua require('dap').step_over()<cr>",
    short = "dap step-over",
    long  = "dap step-over",
  },
  step_into1 = {
    cmd   = "<cmd>lua require('dap').step_into()<cr>",
    short = "dap step-into",
    long  = "dap step-into",
  },
  step_out1 = {
    cmd   = "<cmd>lua require('dap').step_out()<cr>",
    short = "dap step-out",
    long  = "dap step-out",
  },
  repl_run_last = {
    cmd = "<cmd>lua require('dap').repl.run_last()<cr>",
    short = "dap repl run last",
    long = "dap repl run last"
  },
  set_breakpoint = {
    cmd = "<cmd>lua require'dap'.set_breakpoint()<cr>",
    short = "set breakpoint",
    ong = "dap set breakpoint"
  },
  toggle_breakpoint1 = { cmd = "<cmd>lua require'dap'.toggle_breakpoint()<cr>", short = "toggle breakpoint" },
  toggle_breakpoint2 = { cmd = "<cmd>lua require'dap'.toggle_breakpoint()<cr>", short = "toggle breakpoint" },
  toggle_breakpoint3 = { cmd = "<cmd>lua require'dap'.toggle_breakpoint()<cr>", short = "toggle breakpoint" },
  toggle_breakpoint4 = { cmd = "<cmd>lua require'dap'.toggle_breakpoint()<cr>", short = "toggle breakpoint" },
  conditional_breakpoint = {
    cmd = "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>",
    short = "conditional breakpoint",
    long = "conditional breakpoint"
  },
  logging_breakpoint = {
    cmd = "<cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<cr>",
    short = "logging breakpoint",
    long = "logging breakpoint"
  },
  toggle_ui1 = { cmd = "<cmd>lua require'dapui'.toggle()<cr>", short = "toggle dap ui", long = "toggle dap ui" },
  toggle_ui2 = { cmd = "<cmd>lua require'dapui'.toggle()<cr>", short = "toggle dap ui", long = "toggle dap ui" },
  start_lua = { cmd = "<cmd>lua require'dap'.continue()<cr>", short = "start lua dap", long = "start lua dap" },
  toggle_ui_sidebar = {
    cmd = "<cmd>lua require'dapui'.toggle('sidebar')<cr>",
    short = "toggle ui sidebar",
    long = "toggle ui sidebar"
  },
  continue2 = { cmd = "<cmd>lua require'dap'.continue()<cr>", short = "dap continue", long = "dap continue" },
  step_into2 = { cmd = "<cmd>lua require('dap').step_into()<cr>", short = "dap step-into", long = "dap step-into" },
  step_over2 = { cmd = "<cmd>lua require('dap').step_over()<cr>", short = "dap step-over", long = "dap step-over" },
  repl_toggle = {
    cmd = "<cmd>lua require('dap').repl.toggle()<cr>",
    short = "dap repl toggle",
    long = "dap repl toggle"
  },
  debug_start = { cmd = "<cmd>DebugStart<cr>", "Start", short = "debug start", long = "debug start" },
  tmux_send = { cmd = "<cmd>SlimuxShellLast<cr>", short = "tmux send", long = "tmux send via slimux" },
  sniprun_info = { cmd = "<cmd>lua require'sniprun'.info()<cr>", short = "sniprun info", long = "sniprun info" },
  sniprun_bloc = { cmd = "<Plug>SnipRun", short = "sniprun bloc", long = "sniprun bloc" }
}

return M
