local M = {}

local fs = require('devdocs2.fs')
local log = require('devdocs2.log')
local utils = require('devdocs2.utils')

---@return string[]
M.get_installed_alias = function()
  local lockfile = fs.read_lockfile() or {}
  local installed = vim.tbl_keys(lockfile)
  return installed
end

---@return string[]
M.get_non_installed_alias = function()
  local results = {}
  local registry = fs.read_registry()
  local installed = M.get_installed_alias()

  if not registry then
    return {}
  end

  for _, entry in pairs(registry) do
    local alias = entry.slug:gsub('~', '-')
    if not vim.tbl_contains(installed, alias) then
      table.insert(results, alias)
    end
  end

  return results
end

---@param aliases string[]
---@return DocEntry[] | nil
M.get_doc_entries = function(aliases, opts)
  local operations = require('devdocs2.operations')
  opts = opts or {}
  local entries = {}

  local index = fs.read_index()
  if not index then
    return
  end

  for _, alias in pairs(aliases) do
    if index[alias] then
      local current_entries = index[alias].entries
      for idx, doc_entry in ipairs(current_entries) do
        local next_path = nil
        local entries_count = #current_entries

        if idx < entries_count then
          next_path = current_entries[idx + 1].path
        end

        -- vim.dbglog(doc_entry)
        local entry = {
          name = doc_entry.name,
          type = doc_entry.type,
          path = doc_entry.path,
          link = doc_entry.link,
          alias = alias,
          next_path = next_path,
        }

        if opts.line_count then
          local lines = operations.read_entry(doc_entry)
          entry.line_count = #lines
        end
        table.insert(entries, entry)
      end
    end
  end

  return entries
end

---@param predicate function
---@return RegistryEntry[]?
local function get_registry_entry(predicate)
  local registry = fs.read_registry()

  if not registry then
    log.error('DevDocs registry not found, please run :DevdocsFetch')
    return
  end

  return vim.tbl_filter(predicate, registry)
end

M.get_installed_registry = function()
  local installed = M.get_installed_alias()
  local predicate = function(entry)
    local alias = entry.slug:gsub('~', '-')
    return vim.tbl_contains(installed, alias)
  end
  return utils.get_alias_filetypes(get_registry_entry(predicate))
end

M.get_non_installed_registry = function()
  local installed = M.get_installed_alias()
  local predicate = function(entry)
    local alias = entry.slug:gsub('~', '-')
    return not vim.tbl_contains(installed, alias)
  end
  return utils.get_alias_filetypes(get_registry_entry(predicate))
end

M.get_updatable_registry = function()
  local updatable = M.get_updatable()
  local predicate = function(entry)
    local alias = entry.slug:gsub('~', '-')
    return vim.tbl_contains(updatable, alias)
  end
  return utils.get_alias_filetypes(get_registry_entry(predicate))
end

---@return string[]
M.get_updatable = function()
  local results = {}
  local registry = fs.read_registry()
  local lockfile = fs.read_lockfile()

  if not registry or not lockfile then
    return {}
  end

  for alias, value in pairs(lockfile) do
    for _, doc in pairs(registry) do
      if doc.slug == value.slug and doc.mtime > value.mtime then
        table.insert(results, alias)
        break
      end
    end
  end

  return results
end

---@param name string
---@return string[]
M.get_doc_variants = function(name)
  local variants = {}
  local entries = fs.read_registry()

  if not entries then
    return {}
  end

  for _, entry in pairs(entries) do
    if vim.startswith(entry.slug, name) then
      local alias = entry.slug:gsub('~', '-')
      table.insert(variants, alias)
    end
  end

  return variants
end

return M
