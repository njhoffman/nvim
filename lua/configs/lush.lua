require("highlite").setup({
  generator = { plugins = false, syntax = false },
  terminal_palette = false,
})

local function get_colorschemes()
  local paths = vim.api.nvim_get_runtime_file("colors/*.vim", true)
  local schemes = {}
  for _, path in ipairs(paths) do
    local scheme = path:match("colors/(.*)%.vim$")
    table.insert(schemes, scheme)
  end
  return schemes
end

local function select_theme(cb)
  local colorschemes = get_colorschemes()
  table.sort(colorschemes)
  vim.ui.select(colorschemes, {
    prompt = "Select a colorscheme:",
    kind = "colorscheme",
  }, function(choice)
    if choice then
      cb(choice)
      -- vim.cmd("colorscheme " .. choice)
    end
  end)
end

local function export_theme(cmd)
  vim.dbglog(cmd)
end

vim.api.nvim_create_user_command("ThemeExport", export_theme, {
  nargs = 1,
  complete = function(_, _)
    return { "bat", "fish", "nvim", "vim", "wezterm" }
  end,
})

-- -- bat fish nvim vim wezterm
-- require('highlite.export').bat(
--   '<colorscheme name>',
--   -- all settings below are OPTIONAL
--   {
--     -- controls the directory where the exported colorscheme will be written.
--     dir = '~/.config/nvim/colors/',
--     -- controls the name of the file that is created, as well as the name of the output colorscheme.
--     filename = 'foo',
--     -- skip exporting certain groups. Currently only works for the `nvim` and `vim` targets
--     filter = function(group, default_filter)
--       return default_filter(group) or (group:find '^Nvim' or group:find '^Redraw') ~= nil
--     end,

--     -- if `false`, an existing target file will not be overwritten. Instead, a file with a similar name will be created.
--     force = true,
--     -- if `true`, the function will not notify you when it is finished.
--     silent = false,
--   }
-- )

vim.cmd("colorscheme nord-nick")
