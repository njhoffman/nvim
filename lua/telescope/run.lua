local telemap = require("telescope.telemap")
local telethemes = require("telescope.telethemes")

local log_picker = function(picker)
  local p = vim.deepcopy(picker)
  p.finder.results = #p.finder.results
  p.manager.linked_states = nil
  vim.dbglog(p)
end

local function run(plugin, cmd, user_opts)
  user_opts = user_opts or {}
  local bufnr = vim.api.nvim_get_current_buf()
  local extensions = require("telescope").extensions
  local builtin = require("telescope.builtin")

  -- single word command given, either run(cmd, opts) or run(cmd, _, opts)
  if type(cmd) == "table" or type(cmd) == "nil" then
    user_opts = type(cmd) == "table" and cmd or user_opts
    cmd = plugin
    plugin = "builtin"
  end

  local mapkey = cmd
  if not telemap[cmd] then
    mapkey = plugin .. "_" .. cmd
  end

  local opts = vim.tbl_get(telemap, mapkey, "opts") or {}
  if type(opts) == "function" then
    opts = opts(user_opts)
  end

  local theme = user_opts.theme or opts.theme or nil
  if theme then
    opts = vim.tbl_deep_extend("force", opts, telethemes.get_theme(theme))
  end
  opts = vim.tbl_deep_extend("force", opts, user_opts)

  local fun = vim.tbl_get(telemap, mapkey, "fun")
  if type(fun) == "table" then
    plugin, cmd = table.unpack(fun)
  elseif type(fun) == "function" then
    return telemap[mapkey].fun(opts)
  end

  local ok, err
  if plugin == "builtin" and type(builtin[cmd]) == "function" then
    return builtin[cmd](opts)
  elseif vim.tbl_get(extensions, plugin, cmd) then
    return extensions[plugin][cmd](opts)
  else
    vim.notify("No telescope extension found for plugin: " .. plugin .. ",  command: " .. cmd)
  end
  return false
end

_G.TelescopeLoad = run

return run
