-- smoothie_toggle.lua: Toggle between VimL and Lua smoothie implementations
local M = {}

-- State to track which implementation is active
local state = {
  implementation = "viml", -- "viml" or "lua"
  viml_keymaps_active = false,
  lua_keymaps_active = false,
}

---Get current implementation
---@return string
function M.get_implementation()
  return state.implementation
end

---Setup VimL keymaps
local function setup_viml_keymaps()
  if state.viml_keymaps_active then
    return
  end

  -- These are already set up in lua/commands/buffer/smoothie.lua
  -- Just ensure they're calling the vimscript functions
  vim.cmd([[
    noremap <silent> <Plug>(SmoothieDownwards) <cmd>call smoothie#downwards()           <CR>
    noremap <silent> <Plug>(SmoothieUpwards)   <cmd>call smoothie#upwards()             <CR>
    noremap <silent> <Plug>(SmoothieForwards)  <cmd>call smoothie#forwards()            <CR>
    noremap <silent> <Plug>(SmoothieBackwards) <cmd>call smoothie#backwards()           <CR>
    noremap <silent> <Plug>(Smoothie_gg)       <cmd>call smoothie#cursor_movement('gg') <CR>
    noremap <silent> <Plug>(Smoothie_G)        <cmd>call smoothie#cursor_movement('G')  <CR>
  ]])

  state.viml_keymaps_active = true
  state.lua_keymaps_active = false
end

---Setup Lua keymaps
local function setup_lua_keymaps()
  if state.lua_keymaps_active then
    return
  end

  local smoothie = require("smoothie")

  -- Override the plug mappings to use Lua functions
  vim.keymap.set({ "n", "x" }, "<Plug>(SmoothieDownwards)", smoothie.downwards, { silent = true })
  vim.keymap.set({ "n", "x" }, "<Plug>(SmoothieUpwards)", smoothie.upwards, { silent = true })
  vim.keymap.set({ "n", "x" }, "<Plug>(SmoothieForwards)", smoothie.forwards, { silent = true })
  vim.keymap.set({ "n", "x" }, "<Plug>(SmoothieBackwards)", smoothie.backwards, { silent = true })
  vim.keymap.set({ "n", "x" }, "<Plug>(Smoothie_gg)", function()
    smoothie.cursor_movement("gg")
  end, { silent = true })
  vim.keymap.set({ "n", "x" }, "<Plug>(Smoothie_G)", function()
    smoothie.cursor_movement("G")
  end, { silent = true })

  state.lua_keymaps_active = true
  state.viml_keymaps_active = false
end

---Switch to VimL implementation
function M.use_viml()
  if state.implementation == "viml" then
    vim.notify("Already using VimL implementation", vim.log.levels.INFO)
    return
  end

  -- Stop any active Lua scrolling
  local smoothie_lua = require("smoothie")
  smoothie_lua.stop()

  -- Setup VimL keymaps
  setup_viml_keymaps()

  state.implementation = "viml"
  vim.notify("Switched to VimL smoothie implementation", vim.log.levels.INFO)
end

---Switch to Lua implementation
function M.use_lua()
  if state.implementation == "lua" then
    vim.notify("Already using Lua implementation", vim.log.levels.INFO)
    return
  end

  -- Stop any active VimL scrolling
  vim.fn["smoothie#stop"]()

  -- Setup Lua implementation
  local smoothie_lua = require("smoothie")
  smoothie_lua.setup({
    enabled = vim.g.smoothie_enabled == 1,
    update_interval = vim.g.smoothie_update_interval or 20,
    speed_constant_factor = vim.g.smoothie_speed_constant_factor or 10,
    speed_linear_factor = vim.g.smoothie_speed_linear_factor or 8,
    speed_exponentiation_factor = vim.g.smoothie_speed_exponentiation_factor or 0.9,
    break_on_reverse = vim.g.smoothie_break_on_reverse == 1,
    redraw_at_finish = vim.g.smoothie_redraw_at_finish == 1,
    hide_cursor = vim.g.smoothie_hide_cursor == 1,
    benchmark_enabled = vim.g.smoothie_benchmark_enabled == 1,
  })

  -- Setup Lua keymaps
  setup_lua_keymaps()

  state.implementation = "lua"
  vim.notify("Switched to Lua smoothie implementation", vim.log.levels.INFO)
end

---Toggle between implementations
function M.toggle()
  if state.implementation == "viml" then
    M.use_lua()
  else
    M.use_viml()
  end
end

---Show current implementation
function M.status()
  local benchmark_status = ""
  if state.implementation == "viml" then
    if vim.g.smoothie_benchmark_enabled == 1 then
      benchmark_status = " (benchmarking enabled)"
    end
  else
    local smoothie_lua = require("smoothie")
    if smoothie_lua.config.benchmark_enabled then
      benchmark_status = " (benchmarking enabled)"
    end
  end

  vim.notify(
    string.format("Smoothie implementation: %s%s", state.implementation:upper(), benchmark_status),
    vim.log.levels.INFO
  )
end

---Setup commands
function M.setup_commands()
  vim.api.nvim_create_user_command("SmoothieUseVimL", M.use_viml, {
    desc = "Switch to VimL smoothie implementation",
  })

  vim.api.nvim_create_user_command("SmoothieUseLua", M.use_lua, {
    desc = "Switch to Lua smoothie implementation",
  })

  vim.api.nvim_create_user_command("SmoothieToggle", M.toggle, {
    desc = "Toggle between VimL and Lua implementations",
  })

  vim.api.nvim_create_user_command("SmoothieStatus", M.status, {
    desc = "Show current smoothie implementation",
  })

  -- Lua benchmarking commands
  vim.api.nvim_create_user_command("SmoothieBenchmarkEnableLua", function()
    local smoothie_lua = require("smoothie")
    smoothie_lua.benchmark.enable()
    smoothie_lua.config.benchmark_enabled = true
  end, {
    desc = "Enable Lua smoothie benchmarking",
  })

  vim.api.nvim_create_user_command("SmoothieBenchmarkDisableLua", function()
    local smoothie_lua = require("smoothie")
    smoothie_lua.benchmark.disable()
    smoothie_lua.config.benchmark_enabled = false
  end, {
    desc = "Disable Lua smoothie benchmarking",
  })

  vim.api.nvim_create_user_command("SmoothieBenchmarkToggleLua", function()
    local smoothie_lua = require("smoothie")
    smoothie_lua.benchmark.toggle()
    smoothie_lua.config.benchmark_enabled = not smoothie_lua.config.benchmark_enabled
  end, {
    desc = "Toggle Lua smoothie benchmarking",
  })

  vim.api.nvim_create_user_command("SmoothieBenchmarkResetLua", function()
    local smoothie_lua = require("smoothie")
    smoothie_lua.benchmark.reset()
  end, {
    desc = "Reset Lua smoothie benchmark data",
  })

  vim.api.nvim_create_user_command("SmoothieBenchmarkStatsLua", function()
    local smoothie_lua = require("smoothie")
    smoothie_lua.benchmark.show_stats()
  end, {
    desc = "Show Lua smoothie benchmark stats",
  })
end

-- Auto-setup commands
M.setup_commands()

return M
