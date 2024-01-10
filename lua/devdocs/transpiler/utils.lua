local normalize_html = function(str)
  local symbol_map = {
    ['&lt;'] = '<',
    ['&gt;'] = '>',
    ['&amp;'] = '&',
    ['&quot;'] = '"',
    ['&apos;'] = "'",
    ['&nbsp;'] = ' ',
    ['&copy;'] = '©',
    ['&ndash;'] = '–',
  }

  for key, value in pairs(symbol_map) do
    str = str:gsub(key, value)
  end

  return str
end

-- stylua: ignore
local tag_mappings = {
  h1         = { left  = '# ', right      = '\n\n' },
  h2         = { left  = '## ', right     = '\n\n' },
  h3         = { left  = '### ', right    = '\n\n' },
  h4         = { left  = '#### ', right   = '\n\n' },
  h5         = { left  = '##### ', right  = '\n\n' },
  h6         = { left  = '###### ', right = '\n\n' },
  span       = {},
  nav        = {},
  header     = {},
  div        = { left  = '\n', right      = '\n' },
  section    = { right = '\n' },
  p          = { right = '\n\n' },
  ul         = { right = '\n' },
  ol         = { right = '\n' },
  dl         = { right = '\n' },
  dt         = { right = '\n' },
  figure     = { right = '\n' },
  dd         = { left  = ': ' },
  pre        = { left  = '\n```\n', right = '\n```\n' },
  code       = { left  = '`', right  = '`' },
  samp       = { left  = '`', right  = '`' },
  var        = { left  = '`', right  = '`' },
  kbd        = { left  = '`', right  = '`' },
  mark       = { left  = '`', right  = '`' },
  tt         = { left  = '`', right  = '`' },
  b          = { left  = '`', right  = '`' },
  strong     = { left  = '**', right = '**' },
  i          = { left  = '_', right  = '_' },
  s          = { left  = '~~', right = '~~' },
  em         = { left  = '_', right  = '_' },
  small      = { left  = '_', right  = '_' },
  sup        = { left  = '^', right  = '^' },
  blockquote = { left  = '> ' },
  summary    = { left  = '<', right  = '>' },
  -- TODO: Handle these correctly
  math       = { left  = '```math\n', right = '\n```' },
  annotation = { left  = '[', right  = ']' },
  semantics  = {},
  mspace     = { left  = ' ' },
  msup       = { right = '^' },
  mfrac      = { right = '/' },
  mrow       = {},
  mo         = {},
  mn         = {},
  mi         = {},
  br         = { right = '\n' },
  hr         = { right = '---\n\n' },
}

local inline_tags = {
  'span',
  'a',
  'strong',
  'em',
  'abbr',
  'code',
  'tt',
  'i',
  's',
  'b',
  'sub',
  'sup',
  'mark',
  'small',
  'var',
  'kbd',
}

local skipable_tags = {
  'input',
  'use',
  'svg',
  'button',
  -- exceptions, (parent) table -> child
  'tr',
  'td',
  'th',
  'thead',
  'tbody',
}

local monospace_tags = {
  'code',
  'tt',
  'samp',
  'kbd',
}

local is_inline_tag = function(tag_name)
  return vim.tbl_contains(inline_tags, tag_name)
end
local is_skipable_tag = function(tag_name)
  return vim.tbl_contains(skipable_tags, tag_name)
end
local is_monospace_tag = function(tag_name)
  return vim.tbl_contains(monospace_tags, tag_name)
end

return {
  normalize_html = normalize_html,
  tag_mappings = tag_mappings,
  is_inline_tag = is_inline_tag,
  is_skipable_tag = is_skipable_tag,
  is_monospace_tag = is_monospace_tag,
}
