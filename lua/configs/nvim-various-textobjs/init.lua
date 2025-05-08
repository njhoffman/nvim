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
    -- subword                = "S", -- lowercase taken for sentence textobj
    -- notebookCell           = "N",
    -- closedFold             = "z", -- z is the common prefix for folds
    -- chainMember            = "m",
    -- lineCharacterwise      = "_",
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
      "|", -- column: Disabled
      "L", -- URL: Replaced with U
      "r", -- Rest of paragraph: Used for remote operator
      "R", -- Rest of indentation: Keep open for remote operator
      "ig", -- Replaced with iG
      "ag", -- Replaced with aG
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
      "iS", -- subword: Replaced with i-
      "aS", -- subword: Replaced with a-
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
-- map(ox, "i-", function()
--   return various_textobjs.subword("inner")
-- end, "Subword")
-- map(ox, "a-", function()
--   return various_textobjs.subword("outer")
-- end, "Subword")
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

map("n", "dsi", function()
  -- select inner indentation
  various_textobjs.indentation("inner", "inner")

  -- Plugin only switches to visual mode when a textobj has been found
  local notOnIndentedLine = vim.fn.mode():find("V") == nil
  if notOnIndentedLine then
    return
  end

  -- Dedent indentation
  vim.fn.normal({ "<", bang = true })

  -- Delete surrounding lines
  local endBorderLn = vim.api.nvim_buf_get_mark(0, ">")[1] + 1
  local startBorderLn = vim.api.nvim_buf_get_mark(0, "<")[1] - 1
  vim.cmd(tostring(endBorderLn) .. " delete") -- delete end first so line index is not shifted
  vim.cmd(tostring(startBorderLn) .. " delete")
end, { desc = "delete surrounding indentation" })

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

local function openURL(url)
  local opener
  if vim.fn.has("macunix") == 1 then
    opener = "open"
  elseif vim.fn.has("linux") == 1 then
    opener = "xdg-open"
  elseif vim.fn.has("win64") == 1 or vim.fn.has("win32") == 1 then
    opener = "start"
  end
  local openCommand = string.format("%s '%s' >/dev/null 2>&1", opener, url)
  vim.fn.system(openCommand)
end

map("n", "gX", function()
  require("various-textobjs").url()
  local foundURL = vim.fn.mode():find("v")
  if foundURL then
    vim.fn.normal('"zy')
    local url = vim.fn.getreg("z")
    openURL(url)
  else
    -- find all URLs in buffer
    local urlPattern = require("various-textobjs.charwise-textobjs").urlPattern
    local bufText = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
    local urls = {}
    for url in bufText:gmatch(urlPattern) do
      table.insert(urls, url)
    end
    if #urls == 0 then
      return
    end

    -- select one, use a plugin like dressing.nvim for nicer UI for
    -- `vim.ui.select`
    vim.ui.select(urls, { prompt = "Select URL:" }, function(choice)
      if choice then
        openURL(choice)
      end
    end)
  end
end, { desc = "URL Opener" })

map("n", "<leader>p>", function()
  require("various-textobjs").lastChange()
  local changeFound = vim.fn.mode():find("v")
  if changeFound then
    vim.cmd.normal({ ">", bang = true })
  end
end, { desc = "Indent last paste" })

map("n", "ysi", function()
  local startPos = vim.api.nvim_win_get_cursor(0)

  -- identify start- and end-border
  require("various-textobjs").indentation("outer", "outer")
  local indentationFound = vim.fn.mode():find("V")
  if not indentationFound then
    return
  end
  vim.cmd.normal({ "V", bang = true }) -- leave visual mode so the '< '> marks are set

  -- copy them into the + register
  local startLn = vim.api.nvim_buf_get_mark(0, "<")[1] - 1
  local endLn = vim.api.nvim_buf_get_mark(0, ">")[1] - 1
  local startLine = vim.api.nvim_buf_get_lines(0, startLn, startLn + 1, false)[1]
  local endLine = vim.api.nvim_buf_get_lines(0, endLn, endLn + 1, false)[1]
  vim.fn.setreg("+", startLine .. "\n" .. endLine .. "\n")

  -- highlight yanked text
  local ns = vim.api.nvim_create_namespace("ysi")
  vim.api.nvim_buf_add_highlight(0, ns, "IncSearch", startLn, 0, -1)
  vim.api.nvim_buf_add_highlight(0, ns, "IncSearch", endLn, 0, -1)
  vim.defer_fn(function()
    vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
  end, 1000)

  -- restore cursor position
  vim.api.nvim_win_set_cursor(0, startPos)
end, { desc = "Yank surrounding indent" })

map(ox, "ih", function()
  local chunkHelper = require("hlchunk.utils.chunkHelper")
  local CHUNK_RANGE_RET = chunkHelper.CHUNK_RANGE_RET
  local pos = vim.api.nvim_win_get_cursor(0)
  local retcode, cur_chunk_range = chunkHelper.get_chunk_range({
    pos = { bufnr = 0, row = pos[1] - 1, col = pos[2] },
    use_treesitter = true,
  })
  if retcode ~= CHUNK_RANGE_RET.OK then
    return
  end
  local s_row = cur_chunk_range.start + 1
  local e_row = cur_chunk_range.finish + 1
  local ctrl_v = vim.api.nvim_replace_termcodes("<C-v>", true, true, true)
  local cur_mode = vim.fn.mode()
  if cur_mode == "v" or cur_mode == "V" or cur_mode == ctrl_v then
    vim.cmd("normal! " .. cur_mode)
  end

  vim.api.nvim_win_set_cursor(0, { s_row, 0 })
  vim.cmd("normal! V")
  vim.api.nvim_win_set_cursor(0, { e_row, 0 })
end, { desc = "operate around hlchunk" })
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
