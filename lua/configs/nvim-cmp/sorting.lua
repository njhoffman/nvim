local cmp = require("cmp")
local types = require("cmp.types")
local compare = cmp.config.compare

---@type cmp.ComparatorFunction
local deprioritize_snippets = function(entry1, entry2)
  local types = require("cmp.types")
  local kind1 = entry1:get_kind() --- @type lsp.CompletionItemKind | number
  local kind2 = entry2:get_kind() --- @type lsp.CompletionItemKind | number
  -- Lower the priority of snippets
  kind1 = kind1 == types.lsp.CompletionItemKind.Snippet and 100 or 0
  kind2 = kind2 == types.lsp.CompletionItemKind.Snippet and 100 or 0
  local diff = kind1 - kind2
  if diff < 0 then
    return true
  elseif diff > 0 then
    return false
  end
  return nil
end

---@type cmp.ComparatorFunction
local sort_by_label = function(entry1, entry2)
  if entry1.completion_item.label and entry2.completion_item.label then
    local diff = vim.stricmp(entry1.completion_item.label, entry2.completion_item.label)
    if diff < 0 then
      return true
    elseif diff > 0 then
      return false
    end
  end
  return nil
end

local under_comparator = function(entry1, entry2)
  local _, entry1_under = entry1.completion_item.label:find("^_+")
  local _, entry2_under = entry2.completion_item.label:find("^_+")
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

-- 				require("cmp_ai.compare"),
local _sorting_1 = {
  priority_weight = 0, -- Disable score adjustment by source priority and source index
  comparators = {
    -- 1. Sort based on how the input matches
    compare.offset,
    compare.exact,
    compare.score, -- Matching score (see https://github.com/hrsh7th/nvim-cmp/blob/ae644feb7b67bf1ce4260c231d1d4300b19c6f30/lua/cmp/matcher.lua)
    -- 2. Sort based on the type and content of the matched string
    -- deprioritize_snippets,
    compare.kind,
    sort_by_label,
    compare.sort_text, -- Text provided by an LSP server for sorting
  },
}
local default_sorting = {
  priority_weight = 2,
  comparators = {
    compare.offset,
    compare.exact,
    -- compare.scopes,
    compare.score,
    compare.recently_used,
    compare.locality,
    compare.kind,
    compare.sort_text,
    compare.length,
    compare.order,
  },
}

local sorting = {
  priority_weight = 0,
  comparators = {
    require("cmp_fuzzy_path.compare"),
    require("cmp_fuzzy_buffer.compare"),
    require("copilot_cmp.comparators").prioritize,
    compare.offset,
    under_comparator,
    compare.exact,
    compare.score,
    compare.recently_used,
    compare.kind,
    -- kind_comparator,
    sort_by_label,
    compare.sort_text,
    -- compare.locality,
    -- compare.length,
    -- compare.order,
  },
}

return sorting
