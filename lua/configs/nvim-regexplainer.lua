-- https://github.com/bennypowers/nvim-regexplainer
-- defaults
require "regexplainer".setup {
  -- 'narrative'
  mode = "narrative",
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

-- Render Options
-- narrative.separator can also be a function taking the current component and returning a string clause separator. For example, to separate clauses by a new line, followed by > for each level of capture-group depth, define the following function:

-- /(?<!http|https:\/\/)www\.regex101\.com/;
