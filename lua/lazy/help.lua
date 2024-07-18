local Config = require("lazy.core.config")
local Util = require("lazy.util")

local Logger = require("logger")
local logger = Logger and Logger.init("lazy:docs")
local M = {}

function M.index(plugin)
  if Config.options.readme.skip_if_doc_exists and vim.uv.fs_stat(plugin.dir .. "/doc") then
    return {}
  end

  local files = {}

  for _, file in ipairs(Config.options.readme.files) do
    vim.list_extend(files, vim.fn.expand(plugin.dir .. "/" .. file, false, true))
  end

  ---@type table<string,{file:string, tag:string, line:string}>
  local tags, dests = {}, {}
  for _, file in ipairs(files) do
    file = Util.norm(file)
    if vim.uv.fs_stat(file) then
      local rel_file = file:sub(#plugin.dir + 1)
      local tag_filename = plugin.name
        .. vim.fn.fnamemodify(rel_file, ":h"):gsub("%W+", "-"):gsub("^%-$", "")
      local lines = vim.split(Util.read_file(file), "\n")
      for _, line in ipairs(lines) do
        local title = line:match("^#+%s*(.*)")
        if title then
          local tag = tag_filename .. "-" .. title:lower():gsub("%W+", "-")
          tag = tag:gsub("%-+", "-"):gsub("%-$", "")
          line = line:gsub("([%[%]/])", "\\%1")
          tags[tag] = { tag = tag, line = line, file = tag_filename .. ".md" }
        end
      end
      table.insert(lines, [[<!-- vim: set ft=markdown: -->]])
      local dest = Config.options.readme.root .. "/doc/" .. tag_filename .. ".md"
      local content = table.concat(lines, "\n")
      table.insert(dests, { dest, #lines })
      Util.write_file(dest, content)
    end
  end
  return tags, dests
end

function M.update()
  if Config.plugins["lazy.nvim"] then
    vim.cmd.helptags(Config.plugins["lazy.nvim"].dir .. "/doc")
  end
  if Config.options.readme.enabled == false then
    return
  end

  local docs = Config.options.readme.root .. "/doc"
  vim.fn.mkdir(docs, "p")

  local n_delete = 0
  Util.ls(docs, function(path, name, type)
    if type == "file" and name:sub(-2) == "md" then
      vim.uv.fs_unlink(path)
      n_delete = n_delete + 1
    end
  end)

  logger:debug("removed " .. n_delete .. " existing help files")

  ---@type {file:string, tag:string, line:string}[]
  local tags = {}
  local n_plugins, n_files = 0, 0
  for _, plugin in pairs(Config.plugins) do
    local plugin_tags, plugin_files = M.index(plugin)
    if plugin_files and not vim.tbl_isempty(plugin_files) then
      n_plugins = n_plugins + 1
      n_files = n_files + #plugin_files
    end
    for key, tag in pairs(plugin_tags) do
      tags[key] = tag
    end
  end
  logger:debug("indexed " .. n_files .. " help files in " .. n_plugins .. " plugins")
  local lines = { [[!_TAG_FILE_ENCODING	utf-8	//]] }
  Util.foreach(tags, function(_, tag)
    table.insert(lines, ("%s\t%s\t/%s"):format(tag.tag, tag.file, tag.line))
  end, { case_sensitive = true })
  local dest = docs .. "/tags"
  local content = table.concat(lines, "\n")
  Util.write_file(dest, content)
  logger:debug("wrote " .. #lines .. " tags to " .. dest:gsub("^" .. vim.env.HOME, "~"))
end

return M
