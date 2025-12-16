-- PSL (Percent Substitution Language) highlighting using matchadd
-- This works alongside treesitter without conflict

local function setup_psl_highlights()
  -- Define highlight groups if not already defined
  local hl = vim.api.nvim_set_hl
  hl(0, "pslMultiline", { fg = "#b48ead", default = true })
  hl(0, "pslDirective", { fg = "#b48ead", default = true })
  hl(0, "pslNegative", { fg = "#bf616a", default = true })
  hl(0, "pslPositive", { fg = "#a3be8c", default = true })
  hl(0, "pslImport", { fg = "#81a1c1", default = true })
  hl(0, "pslVariable", { fg = "#ebcb8b", default = true })

  -- Add matches for PSL patterns
  -- Higher priority = takes precedence (pslVariable is lowest so specific patterns win)
  -- Exclude MULTILINE and spidercode from pslVariable using negative lookahead
  vim.fn.matchadd("pslVariable", [[%\(MULTILINE\|spidercode\)\@![a-zA-Z_][a-zA-Z0-9_]*%]], 10)
  vim.fn.matchadd("pslNegative", [[%![^!]\+!%]], 11)
  vim.fn.matchadd("pslPositive", [[%?[^?]\+?%]], 11)
  -- Import: match opening %import and closing % separately so embedded vars get pslVariable
  vim.fn.matchadd("pslImport", [[%import ]], 11)
  vim.fn.matchadd("pslImport", [[\.\w\+\zs%\ze\($\|%\|<\)]], 11)
  vim.fn.matchadd("pslMultiline", [[^%MULTILINE%$]], 12)
  vim.fn.matchadd("pslDirective", [[^%spidercode%$]], 12)
end

vim.schedule(setup_psl_highlights)
