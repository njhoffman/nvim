-- https://github.com/jeetsukumaran/vim-indentwise
-- https://github.com/jessekelighine/vindent.vim
-- https://github.com/chrisgrieser/nvim-various-textobjs/blob/main/README.md#delete-surrounding-indentation

local map = function(modes, lhs, rhs, opts)
  if type(opts) == "string" then
    opts = { desc = "韛" .. opts } --  鶴 韛     ﱕ 
  elseif opts and opts.desc then
    opts.desc = "韛" .. opts.desc
  end
  local options = vim.tbl_extend("keep", opts or {}, { silent = true })
  vim.keymap.set(modes, lhs, rhs, options)
end

local helpers = require("configs.nvim-various-textobjs.helpers")
local various_textobjs = require("various-textobjs")
various_textobjs.setup({
  -- lines to seek forwards for "small" textobjs (mostly characterwise textobjs)
  -- set to 0 to only look in the current line
  forwardLooking = {
    small = 50,
    big = 100,
  },
  keymaps = {
    useDefaults = true,
    ---**inner/outer**
    -- number                 = "n",
    -- value                  = "v",
    -- key                    = "k",
    -- notebookCell           = "N",
    -- closedFold             = "z", -- z is the common prefix for folds
    -- chainMember            = "m",
    -- greedyOuterIndentation = "g",
    -- anyQuote               = "q",
    -- anyBracket             = "o",
    ---**single**
    -- nearEoL              = "n", -- does override the builtin "to next search match" textobj, but nobody really uses that
    -- visibleInWindow      = "gw",
    -- toNextClosingBracket = "C", -- % has a race condition with vim's builtin matchit plugin
    -- toNextQuotationMark  = "Q",
    -- restOfParagraph      = "r",
    -- restOfIndentation    = "R",
    -- restOfWindow         = "gW",
    -- diagnostic           = "!",
    -- column               = "|",
    -- entireBuffer         = "gG", -- G + gg
    -- url                  = "L", -- gu, gU, and U would conflict with gugu, gUgU, and gUU. u would conflict with gcu (undo comment)
    -- lastChange = "g;", -- consistent with g; movement
    ---**filetype**
    -- { map = { mdLink = "l" },               fts = { "markdown", "toml" } },
    -- { map = { mdEmphasis = "e" },           fts = { "markdown" } },
    -- { map = { pyTripleQuotes = "y" },       fts = { "python" } },
    -- { map = { mdFencedCodeBlock = "C" },    fts = { "markdown" } },
    -- { map = { doubleSquareBrackets = "D" }, fts = { "lua", "norg", "sh", "fish", "zsh", "bash", "markdown" } },
    -- { map = { cssSelector = "c" },          fts = { "css", "scss" } },
    -- { map = { cssColor = "#" },             fts = { "css", "scss" } },
    -- { map = { shellPipe = "P" },            fts = { "sh", "bash", "zsh", "fish" } },
    -- { map = { htmlAttribute = "x" },        fts = { "html", "css", "scss", "xml", "vue" } },
    -- "ii"  inner', 'inner'
    -- "ai"  outer', 'inner'
    -- "iI"  inner', 'inner'
    -- "aI"  outer', 'outer'
    disabledDefaults = {
      "_", -- lineCharacterwise , use 'l'
      "L", -- URL: Replaced with U
      "r", -- Rest of paragraph: Used for remote operator
      "R", -- Rest of indentation: Keep open for remote operator
      "ig", -- Replaced with iG
      "ag", -- Replaced with aG
      "ih", -- C/iC/aC for hlchunks
      "ii", -- Just use iI
      "ai", -- Just use aI
      "iI", -- Just use iI
      "aI", -- Just use aI
      "gG", -- anyBuffer: Replaced with mini.ai ig
      "iq", -- anyQuote: mini.ai quote
      "aq", -- anyQuote: mini.ai quote
      "il", -- Replaced with iL
      "al", -- Replaced with aL
      "io", -- anyBracket: Replaced with iO
      "ao", -- anyBracket: Replaced with aO
      "iD", -- Use vim-textobj-user's date instead
      "aD", -- Use vim-textobj-user's date instead
      "iS", -- subword: Replaced with i_
      "aS", -- subword: Replaced with a_
      "in", -- Disabled, use treesitter's iN, instead
      "an", -- Disabled, use treesitter's aN, instead
      "iN", -- Disabled, use treesitter's iN, instead
      "aN", -- Disabled, use treesitter's aN, instead
    },
  },
})
-- " % ' ( ) < > ? [ ] _ ` { } ia iA ib iB ic iC if ih ii il iL in iN io ip iq is
-- iG aG iE aE iL aL iU aU id ad r ix aX i- iE aE } [{ ix ax ic ac dsi gx
-- iv av ispace aspace ak n m w rv rp ri rg gg ge L o u in an ii ai ij aj ig ag  i. a.

local ox = { "o", "x" }

map(ox, "U", various_textobjs.url, "URL")
-- map(ox, "id", various_textobjs.diagnostic, "Diagnostic")
map(ox, "?", various_textobjs.diagnostic, "Diagnostic")
map(ox, "i_", function()
  return various_textobjs.subword("inner")
end, "Subword")
map(ox, "a_", function()
  return various_textobjs.subword("outer")
end, "Subword")
map(ox, "]}", function()
  return various_textobjs.toNextClosingBracket()
end, "To next closing bracket")
map(ox, "[{", function()
  return various_textobjs.toNextClosingBracket()
end, "To previous closing bracket")

local markdown_textobjs = function()
  map(ox, "iE", function()
    return various_textobjs.mdEmphasis("inner")
  end, { buffer = true, desc = "Markdown emphasis" })
  map(ox, "aE", function()
    return various_textobjs.mdEmphasis("outer")
  end, { buffer = true, desc = "Markdown emphasis " })
  map(ox, "ix", function()
    return various_textobjs.mdlink("inner")
  end, { buffer = true, desc = "Markdown link" })
  map(ox, "ax", function()
    return various_textobjs.mdlink("outer")
  end, { buffer = true, desc = "Markdown link" })
  map(ox, "ic", function()
    return various_textobjs.mdFencedCodeBlock("inner")
  end, { buffer = true, desc = "Markdown code block" })
  map(ox, "ac", function()
    return various_textobjs.mdFencedCodeBlock("outer")
  end, { buffer = true, desc = "Markdown code block" })
  -- 1st arg excludes starting border, 2nd arg excludes ending border
  -- map(ox, "ii", '<cmd>lua require("various-textobjs").indentation("inner", "outer")<CR>')
  -- map(ox, "ai", '<cmd>lua require("various-textobjs").indentation("outer", "outer")<CR>')
end

local augroup = vim.api.nvim_create_augroup("VariousTextobjs", {})
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  group = augroup,
  callback = markdown_textobjs,
})

map("n", "dsi", helpers.delete_surround_indent, { desc = "delete surrounding indentation" })

-- map('n', 'P', function()
--   require('various-textobjs').lastChange()
--   local changeFound = vim.fn.mode():find('v')
--   if changeFound then
--     vim.fn.normal({ '>', bang = true })
--   end
-- end, {})
--
-- when on unindented line, `ii` should select entire buffer
-- map('o', 'ii', function()
--   if tonumber(vim.fn.indent('.')) == 0 then
--     require('various-textobjs').entireBuffer()
--   else
--     require('various-textobjs').indentation('inner', 'inner')
--   end
-- end)

map("n", "gX", helpers.url_opener, { desc = "URL Opener" })
map("n", "<leader>p>", function()
  require("various-textobjs").lastChange()
  local changeFound = vim.fn.mode():find("v")
  if changeFound then
    vim.cmd.normal({ ">", bang = true })
  end
end, { desc = "Indent last paste" })

map("n", "ysii", helpers.yank_surround_indent, { desc = "Yank surrounding indent" })
-- map(ox, "ih", helpers.inner_chunk, { desc = "operate around hlchunk" })

-- { "im", ft = { "markdown", "toml" }, mode = { "o", "x" }, function() require("various-textobjs").mdlink("inner") end, desc = "Markdown Link" },
-- { "am", ft = { "markdown", "toml" }, mode = { "o", "x" }, function() require("various-textobjs").mdlink("outer") end, desc = "Markdown Link" },
-- { "iC", ft = { "markdown" }, mode = { "o", "x" }, function() require("various-textobjs").mdFencedCodeBlock("inner") end, desc = "CodeBlock" },
-- { "aC", ft = { "markdown" }, mode = { "o", "x" }, function() require("various-textobjs").mdFencedCodeBlock("outer") end, desc = "CodeBlock" },
-- { "ie", ft = { "markdown" }, mode = { "o", "x" }, function() require("various-textobjs").mdEmphasis("inner") end, desc = "Emphasis" },
-- { "ae", ft = { "markdown" }, mode = { "o", "x" }, function() require("various-textobjs").mdEmphasis("outer") end, desc = "Emphasis" },
-- { "gd", mode = { "o", "x" }, function() require("various-textobjs").diagnostics() end, desc = "Diagnostics" },
-- { "iy", ft = { "python" }, mode = { "o", "x" }, function() require("various-textobjs").pyTripleQuotes("inner") end, desc = "Triple Quotes" },
-- { "ay", ft = { "python" }, mode = { "o", "x" }, function() require("various-textobjs").pyTripleQuotes("outer") end, desc = "Triple Quotes" },
-- { "iC", ft = { "css", "scss", "less" }, mode = { "o", "x" }, function() require("various-textobjs").cssSelector("inner") end, desc = "CSS Selector" },
-- { "aC", ft = { "css", "scss", "less" }, mode = { "o", "x" }, function() require("various-textobjs").cssSelector("outer") end, desc = "CSS Selector" },
-- { "i#", ft = { "css", "scss", "less" }, mode = { "o", "x" }, function() require("various-textobjs").cssColor("inner") end, desc = "CSS Color" },
-- { "a#", ft = { "css", "scss", "less" }, mode = { "o", "x" }, function() require("various-textobjs").cssColor("outer") end, desc = "CSS Color" },
-- { "iP", ft = { "sh" }, mode = { "o", "x" }, function() require("various-textobjs").shellPipe("inner") end, desc = "Pipe" },
-- { "aP", ft = { "sh" }, mode = { "o", "x" }, function() require("various-textobjs").shellPipe("outer") end, desc = "Pipe" },
-- { "iH", ft = { "html, xml, css, scss, less" }, mode = { "o", "x" }, function() require("various-textobjs").htmlAttribute("inner") end, desc = "HTML Attribute" },
