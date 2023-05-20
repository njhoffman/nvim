local attr_map = {
  { 'buffer', '@' },
  { 'silent', '!' },
  { 'noremap', '*' },
  { 'expr', '+' },
  { 'nowait', '' },
  -- unique
}

for _, attr in pairs(attr_map) do
  vim.dbglog('ATTR', attr)
end
