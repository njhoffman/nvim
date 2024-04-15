local grammar_targets = {
  ['['] = '',
  [']'] = '',
  ['('] = '',
  [')'] = '',
  ['{'] = '',
  ['}'] = '',
  ['<'] = '',
  ['>'] = '',
  ['`'] = '',
  ["'"] = '',
  ['"'] = '',
}

local abbreviated_targets = {
  ['b'] = ' [bracket]',
}

local keywords_targets = {
  ['w'] = ' [word]',
  ['W'] = ' [WORD]',
  ['f'] = ' [function]',
  ['q'] = ' [quote]',
}

local all_targets = {}
for k, v in pairs(grammar_targets) do
  all_targets[k] = v
end
for k, v in pairs(abbreviated_targets) do
  all_targets[k] = v
end
for k, v in pairs(keywords_targets) do
  all_targets[k] = v
end

local abbreviated_and_grammar_targets = {}
for k, v in pairs(grammar_targets) do
  abbreviated_and_grammar_targets[k] = v
end
for k, v in pairs(abbreviated_targets) do
  abbreviated_and_grammar_targets[k] = v
end

local mappings = {
  ['s'] = { name = 'surround' },
}

-- around mappings
mappings['sa'] = { name = 'around' }
for char, desc in pairs(all_targets) do
  mappings['sa'][char] = { name = desc }
  for ichar, target in pairs(abbreviated_and_grammar_targets) do
    mappings['sa'][char][ichar] =
      { "<CMD>call feedkeys('ysa" .. char .. ichar .. "')<CR>", 'ysa' .. char .. ichar .. target }
  end
end

-- inner mappings
mappings['si'] = { name = 'inner' }
for char, desc in pairs(all_targets) do
  mappings['si'][char] = { name = desc }
  for ichar, target in pairs(all_targets) do
    mappings['si'][char][ichar] =
      { "<CMD>call feedkeys('ysi" .. char .. ichar .. "')<CR>", 'ysi' .. char .. ichar .. target }
  end
end

-- change mappings
mappings['cs'] = { name = 'change' }
for char, desc in pairs(all_targets) do
  mappings['cs'][char] = { name = desc }
  for ichar, target in pairs(all_targets) do
    mappings['cs'][char][ichar] =
      { "<CMD>call feedkeys('cs" .. char .. ichar .. "')<CR>", 'cs' .. char .. ichar .. target }
  end
end

-- delete mappings
mappings['ds'] = { name = 'delete' }
for char, target in pairs(all_targets) do
  mappings['ds'][char] = { "<CMD>call feedkeys('ds" .. char .. "')<CR>", 'ds' .. char .. target }
end

-- -- line mappings
-- mappings['s']['s'] = { name = '[s] line' }
-- for char, target in pairs(all_targets) do
--   mappings['s']['s'][char] =
--     { "<CMD>call feedkeys('yss" .. char .. "')<CR>", 'yss' .. char .. target }
-- end

vim.dbglog(mappings)
-- require('which-key').register(mappings)
