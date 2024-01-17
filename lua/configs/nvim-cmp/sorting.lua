local cmp = require('cmp')
local types = require('cmp.types')

local under_comparator = function(entry1, entry2)
  local _, entry1_under = entry1.completion_item.label:find('^_+')
  local _, entry2_under = entry2.completion_item.label:find('^_+')
  entry1_under = entry1_under or 0
  entry2_under = entry2_under or 0
  if entry1_under > entry2_under then
    return false
  elseif entry1_under < entry2_under then
    return true
  end
end

local kind_comparator = function(entry1, entry2)
  local kind1 = entry1:get_kind()
  kind1 = kind1 == types.lsp.CompletionItemKind.Text and 100 or kind1
  local kind2 = entry2:get_kind()
  kind2 = kind2 == types.lsp.CompletionItemKind.Text and 100 or kind2
  if kind1 ~= kind2 then
    if kind1 == types.lsp.CompletionItemKind.Snippet then
      return false
    end
    if kind2 == types.lsp.CompletionItemKind.Snippet then
      return true
    end
    local diff = kind1 - kind2
    if diff < 0 then
      return true
    elseif diff > 0 then
      return false
    end
  end
end

-- comparators = {
--   require('cmp_fuzzy_buffer.compare'),
--   compare.offset,
--   compare.exact,
--   compare.score,
--   compare.recently_used,
--   compare.kind,
--   compare.sort_text,
--   compare.length,
--   compare.order,
-- },
-- 				require("cmp_ai.compare"),
local sorting = {
  priority_weight = 2,
  comparators = {
    require('copilot_cmp.comparators').prioritize,
    require('cmp_fuzzy_buffer.compare'),
    cmp.config.compare.offset,
    under_comparator,
    cmp.config.compare.recently_used,
    cmp.config.compare.score,
    cmp.config.compare.exact,
    kind_comparator,
    cmp.config.compare.locality,
    cmp.config.compare.sort_text,
    cmp.config.compare.length,
    cmp.config.compare.order,
  },
}

return sorting
