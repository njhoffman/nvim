local vim_filetypes = {}
for _, ft in ipairs(vim.fn.getcompletion('', 'filetype')) do
  vim_filetypes[ft] = true
end

local match_filetypes = function(slug)
  local custom_filetypes = require('devdocs.config').options.filetypes
  local matched_fts = {}
  -- first try to match filetype directly
  if vim_filetypes[slug] == true then
    table.insert(matched_fts, slug)
  end

  -- next try to match full slug to filetype
  for ft, ft_slugs in pairs(custom_filetypes) do
    ft_slugs = type(ft_slugs) == 'string' and { ft_slugs } or ft_slugs
    if vim.list_contains(ft_slugs, slug) then
      table.insert(matched_fts, ft)
    end
  end

  if #matched_fts == 0 then
    -- if no matches yet match against slug with hyphen trimmed off
    slug = slug:gsub('~.*', '')
    if vim_filetypes[slug] == true then
      table.insert(matched_fts, slug)
    end

    -- last try to match trimmed slug to custom fileltypes
    for ft, ft_slugs in pairs(custom_filetypes) do
      ft_slugs = type(ft_slugs) == 'string' and { ft_slugs } or ft_slugs
      if vim.list_contains(ft_slugs, slug) then
        table.insert(matched_fts, ft)
      end
    end
  end

  return matched_fts
end

local get_alias_filetypes = function(aliases, unmatched)
  unmatched = unmatched or {}
  for _, alias in ipairs(aliases) do
    alias.filetypes = vim.fn.join(match_filetypes(alias.slug), ',')
    if #alias.filetypes == 0 then
      unmatched[alias.slug] = true
    end
  end
  return aliases, unmatched
end

return {
  get_alias_filetypes = get_alias_filetypes,
}
