local cmp = require('cmp')
local types = require('cmp.types')

-- sorting = {
-- 			priority_weight = 2,
-- 			comparators = {
-- 				require("cmp_ai.compare"),
-- 				cmp.config.compare.offset,
-- 				cmp.config.compare.exact,
-- 				cmp.config.compare.score,
-- 				cmp.config.compare.recently_used,
-- 				require("clangd_extensions.cmp_scores"),
-- 				cmp.config.compare.locality,
-- 				cmp.config.compare.kind,
-- 				cmp.config.compare.sort_text,
-- 				cmp.config.compare.length,
-- 				cmp.config.compare.order,
-- 			},
-- 		},
local sorting = {
  priority_weight = 2,
  comparators = {

    require('copilot_cmp.comparators').prioritize,
    -- cmp.config.compare.locality,
    -- cmp.config.compare.recently_used,
    cmp.config.compare.score,
    cmp.config.compare.offset,
    cmp.config.compare.exact,
    cmp.config.compare.score,
    function(entry1, entry2)
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
    end,
    cmp.config.compare.sort_text,
    cmp.config.compare.length,
    cmp.config.compare.order,
  },
}

return sorting
