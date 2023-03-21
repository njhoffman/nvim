local telemap = require("telescope.telemap")
local telethemes = require("telescope.telethemes")

local function get_options(mapkey, user_opts)
  user_opts = user_opts or {}
  local theme_opts = {}
  local map_opts = vim.tbl_get(telemap, mapkey, "opts") or {}
  local opts = {}
  if type(map_opts) == "table" then
    opts = map_opts
  elseif type(map_opts) == "function" then
    opts = map_opts(user_opts)
  end

  if type(user_opts.theme) == "string" then
    theme_opts = telethemes.get_theme(user_opts.theme)
  elseif type(opts.theme) == "string" then
    theme_opts = telethemes.get_theme(opts.theme)
  end
  return vim.tbl_deep_extend("keep", user_opts or {}, opts, theme_opts)
end

local function run(plugin, cmd, user_opts)
  local extensions = require("telescope._extensions").manager
  local builtin = require("telescope.builtin")

  local mapkey = plugin

  -- TODO: lookup and match single commands
  -- single word command given, either run(cmd, opts) or run(cmd, _, opts)
  if type(cmd) == "nil" or type(cmd) == "table" then
    user_opts = (type(cmd) == "table" and cmd) or user_opts
    cmd = vim.fn.empty(cmd) == 1 and plugin or cmd
    plugin = ""
  else
    mapkey = mapkey .. "_" .. cmd
  end

  local opts = get_options(mapkey, user_opts)

  local tele_cmd = vim.tbl_get(telemap, mapkey, "cmd")
  if type(tele_cmd) == "table" then
    plugin, cmd = table.unpack(tele_cmd)
  elseif type(tele_cmd) == "function" then
    return telemap[mapkey].cmd(opts)
  end

  if plugin == "builtin" and type(builtin[cmd]) == "function" then
    builtin[cmd](opts)
  elseif type(extensions[plugin]) == "table" then
    extensions[plugin][cmd](opts)
  else
    local msg = "cmd: " .. cmd
    if vim.fn.empty(plugin) == 0 then
      msg = "plugin: " .. plugin .. " - " .. msg
    end
    vim.notify("No telescope extension found with " .. msg)
  end
end

_G.TelescopeLoad = run

return run
