local list = require('devdocs.list')
local custom_filetypes = require('devdocs.filetypes')

local vim_filetypes = {}
for _, ft in ipairs(vim.fn.getcompletion('', 'filetype')) do
  vim_filetypes[ft] = true
end

local match_filetypes = function(slug)
  local matched_fts = {}
  if vim_filetypes[slug] == true then
    table.insert(matched_fts, slug)
  end
  for ft, ft_slugs in pairs(custom_filetypes) do
    ft_slugs = type(ft_slugs) == 'string' and { ft_slugs } or ft_slugs
    if vim.list_contains(ft_slugs, slug) then
      table.insert(matched_fts, ft)
    end
  end
  return matched_fts
end

local function add_filetypes(aliases, unmatched)
  unmatched = unmatched or {}
  for _, alias in ipairs(aliases) do
    local slug = alias.slug:gsub('~.*', '')
    alias.filetypes = match_filetypes(slug)
    if #alias.filetypes == 0 then
      unmatched[slug] = true
    end
  end
  return unmatched
end

local installed = list.get_installed_registery()
local noninstalled = list.get_non_installed_registery()

local unmatched = add_filetypes(installed)
add_filetypes(noninstalled, unmatched)
unmatched = vim.tbl_keys(unmatched)
vim.dbglog(vim.fn.sort(unmatched))
