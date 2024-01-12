local entry_maker = function(entry)
  return {
    value = entry,
    display = entry.slug:gsub('~', '-'),
    ordinal = entry.slug:gsub('~', '-'),
  }
end
return entry_maker
