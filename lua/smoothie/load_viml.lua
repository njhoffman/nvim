-- load_viml.lua: Load VimL smoothie implementation from lua/smoothie folder
local M = {}

---Setup VimL <Plug> mappings
---This defines the <Plug> mappings that call VimL smoothie functions
function M.setup_plug_mappings()
  vim.cmd([[
    noremap <silent> <Plug>(SmoothieDownwards) <cmd>call smoothie#downwards()           <CR>
    noremap <silent> <Plug>(SmoothieUpwards)   <cmd>call smoothie#upwards()             <CR>
    noremap <silent> <Plug>(SmoothieForwards)  <cmd>call smoothie#forwards()            <CR>
    noremap <silent> <Plug>(SmoothieBackwards) <cmd>call smoothie#backwards()           <CR>
    noremap <silent> <Plug>(Smoothie_gg)       <cmd>call smoothie#cursor_movement('gg') <CR>
    noremap <silent> <Plug>(Smoothie_G)        <cmd>call smoothie#cursor_movement('G')  <CR>
  ]])
end

---Load VimL smoothie code
function M.load()
  local smoothie_path = vim.fn.fnamemodify(debug.getinfo(1).source:sub(2), ":h")

  -- Source the VimL smoothie implementation
  vim.cmd("source " .. smoothie_path .. "/smoothie.vim")

  -- Source the benchmark commands (defines user commands)
  vim.cmd("source " .. smoothie_path .. "/smoothie_benchmark.vim")

  -- Setup <Plug> mappings
  M.setup_plug_mappings()
end

return M
