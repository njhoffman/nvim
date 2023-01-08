local default_options = {
  text = {
    spinner = "pipe", -- animation shown when tasks are ongoing
    done = "✔", -- character shown when all tasks are complete
    commenced = "Started", -- message shown when task starts
    completed = "Completed", -- message shown when task completes
  },
  align = {
    bottom = false, -- align fidgets along bottom edge of buffer
    right = true, -- align fidgets along right edge of buffer
  },
  timer = {
    spinner_rate = 125, -- frame rate of spinner animation, in ms
    fidget_decay = 2000, -- how long to keep around empty fidget, in ms
    task_decay = 1000, -- how long to keep around completed task, in ms
  },
  window = {
    relative = "editor", -- where to anchor, either "win" or "editor"
    blend = 0, -- &winblend for the window
    zindex = nil, -- the zindex value for the window
  },
  fmt = {
    leftpad = true,
    stack_upwards = false,
    fidget = function(fidget_name, spinner)
      return string.format("%s %s", spinner, fidget_name)
    end,
    task = function(task_name, message, percentage)
      return string.format("%s%s [%s]", message, percentage and string.format(" (%.0f%%)", percentage) or "", task_name)
    end,
  },
  debug = {
    logging = false, -- whether to enable logging, for debugging
  },
}

require("fidget").setup({
  text = {
    --see ~/.vim/plugged/fidget.nvim/lua/fidget/spinners.lua
    spinner = "zip",
  },
  window = {
    blend = 20,
  },
  align = {
    bottom = true, -- align fidgets along bottom edge of buffer
    right = true, -- align fidgets along right edge of buffer
  },
})

vim.api.nvim_create_autocmd("VimLeavePre", { command = [[silent! FidgetClose]] })
