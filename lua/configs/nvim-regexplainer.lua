-- https://github.com/bennypowers/nvim-regexplainer
-- defaults
require "regexplainer".setup {
  -- 'narrative'
  mode = "narrative", -- TODO: 'ascii', 'graphical'
  -- automatically show the explainer when the cursor enters a regexp
  auto = false,
  -- Whether to log debug messages
  debug = false,
  -- 'split', 'popup'
  display = "popup",
  mappings = {
    toggle = "gR"
    -- examples, not defaults:
    -- show = 'gS',
    -- hide = 'gH',
    -- show_split = 'gP',
    -- show_popup = 'gU',
  },
  narrative = {
    separator = "\n"
  }
}

require "regexplainer".setup(
  {
    auto = true
  }
)

-- require'regexplainer'.show { display = 'split' }
-- require'regexplainer'.show {
--   display = 'popup',
--   popup = {
--     border = {
--       padding = { 1, 2 },
--       style = 'solid',
--     },
--   },
-- }

-- Render Options
-- narrative.separator can also be a function taking the current component and returning a string clause separator. For example, to separate clauses by a new line, followed by > for each level of capture-group depth, define the following function:

-- narrative = {
--   separator = function(component)
--     local sep = '\n';
--     if component.depth > 0 then
--       for _ = 1, component.depth do
--         sep = sep .. '> '
--       end
--     end
--     return sep
--   end
-- },
-- A Note about Lookbehinds
-- While https://github.com/tree-sitter/tree-sitter-regex/issues/13 is still open, lookbehind support is partial, and results may not be accurate, especially if the term in the lookbehind is complex, e.g.

-- /(?<!http|https:\/\/)www\.regex101\.com/;
