local map = function(modes, lhs, rhs, opts)
  if type(opts) == 'string' then
    opts = { desc = opts }
  end
  local options = vim.tbl_extend('keep', opts or {}, { silent = true })
  vim.keymap.set(modes, lhs, rhs, options)
end

local local_map = function(buffer)
  return function(modes, lhs, rhs, opts)
    if type(opts) == 'string' then
      opts = { desc = opts, buffer = buffer }
    end
    local options = vim.tbl_extend('keep', opts or {}, { silent = true })

    vim.keymap.set(modes, lhs, rhs, options)
  end
end
local various_textobjs = require('various-textobjs')

various_textobjs.setup({
  useDefaultKeymaps = true,
  disabledKeymaps = {
    'P',
    'ig', -- Replaced with iG
    'ag', -- Replaced with aG
    'ii', -- Just use iI
    'ai', -- Just use aI
    'gG', -- Replaced with ie
    '|', -- Disabled
    'L', -- Replaced with iu
    'r', -- I only want this for normal mode
    '=', -- Use Treesitter's @assignment instead
    'il', -- Replaced with iL
    'al', -- Replaced with aL
    'ic', -- Disabled (CSS class)
    'ac', -- Disabled (CSS class)
    'ix', -- Replaced with iX
    'ax', -- Replaced with iX
    'iD', -- Use vim-textobj-user's date instead
    'aD', -- Use vim-textobj-user's date instead
    'iS', -- Replaced with i-
    'aS', -- Replaced with a-
    'in', -- Disabled, use treesitter's iN, instead
    'an', -- Disabled, use treesitter's aN, instead
    'gc', -- commenting already setup
  },
})
-- " % ' ( ) < > ? [ ] _ ` { } ia iA ib iB ic iC if ih ii il iL in iN io ip iq is

-- { "aS", function() require("various-textobjs").subword(false) end, mode = { "o", "x" }, desc = "outer subword", },
-- { "iS", function() require("various-textobjs").subword(true) end, mode = { "o", "x" }, desc = "inner subword", },

-- iG aG iE aE iL aL iU aU id ad r ix aX i- iE aE } [{ ix ax ic ac dsi gx
-- iv av ispace aspace ak n m w rv rp ri rg gg ge L o u in an ii ai ij aj ig ag  i. a.

local ox = { 'o', 'x' }
map(ox, 'iG', function()
  various_textobjs.greedyOuterIndentation('inner')
end, 'Greedy outer indentation')
map(ox, 'aG', function()
  various_textobjs.greedyOuterIndentation('outer')
end, 'Greedy outer indentation')
map(ox, 'ie', various_textobjs.entireBuffer, 'Entire buffer')
map(ox, 'iL', function()
  return various_textobjs.lineCharacterwise('inner')
end, 'Line')
map(ox, 'aL', function()
  return various_textobjs.lineCharacterwise('outer')
end, 'Line')
map(ox, 'iu', various_textobjs.url, 'URL')
map(ox, 'id', various_textobjs.diagnostic, 'Diagnostic')
map(ox, '?', various_textobjs.diagnostic, 'Diagnostic')
map('o', 'r', various_textobjs.restOfParagraph, 'Rest of paragraph')
map(ox, 'iX', function()
  return various_textobjs.htmlAttribute('inner')
end, 'HTML attribute')
map(ox, 'aX', function()
  return various_textobjs.htmlAttribute('outer')
end, 'HTML attribute')
map(ox, 'i-', function()
  return various_textobjs.subword('inner')
end, 'HTML attribute')
map(ox, 'a-', function()
  return various_textobjs.subword('outer')
end, 'HTML attribute')
map(ox, 'iE', function()
  return various_textobjs.mdEmphasis('inner')
end, 'Markdown emphasis')
map(ox, 'aE', function()
  return various_textobjs.mdEmphasis('outer')
end, 'Markdown emphasis')
map(ox, ']}', function()
  return various_textobjs.toNextClosingBracket()
end, 'To next closing bracket')
map(ox, '[{', function()
  return various_textobjs.toNextClosingBracket()
end, 'To previous closing bracket')

local markdown_textobjs = function()
  local opts = { buffer = true }
  map(ox, 'ix', function()
    return various_textobjs.mdlink('inner')
  end, opts)
  map(ox, 'ax', function()
    return various_textobjs.mdlink('outer')
  end, opts)
  map(ox, 'ic', function()
    return various_textobjs.mdFencedCodeBlock('inner')
  end, opts)
  map(ox, 'ac', function()
    return various_textobjs.mdFencedCodeBlock('outer')
  end, opts)
end

local augroup = vim.api.nvim_create_augroup('VariousTextobjs', {})
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  group = augroup,
  callback = markdown_textobjs,
})
markdown_textobjs()

map('n', 'dsi', function()
  -- select inner indentation
  various_textobjs.indentation('inner', 'inner')

  -- Plugin only switches to visual mode when a textobj has been found
  local notOnIndentedLine = vim.fn.mode():find('V') == nil
  if notOnIndentedLine then
    return
  end

  -- Dedent indentation
  vim.cmd.normal({ '<', bang = true })

  -- Delete surrounding lines
  local endBorderLn = vim.api.nvim_buf_get_mark(0, '>')[1] + 1
  local startBorderLn = vim.api.nvim_buf_get_mark(0, '<')[1] - 1
  vim.cmd(tostring(endBorderLn) .. ' delete') -- delete end first so line index is not shifted
  vim.cmd(tostring(startBorderLn) .. ' delete')
end, { desc = 'Delete surrounding indentation' })

-- map('n', 'P', function()
--   require('various-textobjs').lastChange()
--   local changeFound = vim.fn.mode():find('v')
--   if changeFound then
--     vim.cmd.normal({ '>', bang = true })
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
  if vim.fn.has('macunix') == 1 then
    opener = 'open'
  elseif vim.fn.has('linux') == 1 then
    opener = 'xdg-open'
  elseif vim.fn.has('win64') == 1 or vim.fn.has('win32') == 1 then
    opener = 'start'
  end
  local openCommand = string.format("%s '%s' >/dev/null 2>&1", opener, url)
  vim.fn.system(openCommand)
end

map('n', 'gx', function()
  require('various-textobjs').url()
  local foundURL = vim.fn.mode():find('v')
  if foundURL then
    vim.fn.normal('"zy')
    local url = vim.fn.getreg('z')
    openURL(url)
  else
    -- find all URLs in buffer
    local urlPattern = require('various-textobjs.charwise-textobjs').urlPattern
    local bufText = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), '\n')
    local urls = {}
    for url in bufText:gmatch(urlPattern) do
      table.insert(urls, url)
    end
    if #urls == 0 then
      return
    end

    -- select one, use a plugin like dressing.nvim for nicer UI for
    -- `vim.ui.select`
    vim.ui.select(urls, { prompt = 'Select URL:' }, function(choice)
      if choice then
        openURL(choice)
      end
    end)
  end
end, { desc = 'URL Opener' })

map('n', '<leader>p>', function()
  require('various-textobjs').lastChange()
  local changeFound = vim.fn.mode():find('v')
  if changeFound then
    vim.cmd.normal({ '>', bang = true })
  end
end, { desc = 'indent last paste' })

map('n', 'ysii', function()
  local startPos = vim.api.nvim_win_get_cursor(0)

  -- identify start- and end-border
  require('various-textobjs').indentation('outer', 'outer')
  local indentationFound = vim.fn.mode():find('V')
  if not indentationFound then
    return
  end
  vim.cmd.normal({ 'V', bang = true }) -- leave visual mode so the `'<` `'>` marks are set

  -- copy them into the + register
  local startLn = vim.api.nvim_buf_get_mark(0, '<')[1] - 1
  local endLn = vim.api.nvim_buf_get_mark(0, '>')[1] - 1
  local startLine = vim.api.nvim_buf_get_lines(0, startLn, startLn + 1, false)[1]
  local endLine = vim.api.nvim_buf_get_lines(0, endLn, endLn + 1, false)[1]
  vim.fn.setreg('+', startLine .. '\n' .. endLine .. '\n')

  -- highlight yanked text
  local ns = vim.api.nvim_create_namespace('ysi')
  vim.highlight.range(0, ns, 'IncSearch', { startLn, 0 }, { startLn, -1 })
  vim.highlight.range(0, ns, 'IncSearch', { endLn, 0 }, { endLn, -1 })
  vim.defer_fn(function()
    vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
  end, 1000)

  -- restore cursor position
  vim.api.nvim_win_set_cursor(0, startPos)
end, { desc = 'Yank surrounding indentation' })

--   -- stylua: ignore start
--   { "<Space>", "<cmd>lua require('various-textobjs').subword('inner')<CR>", mode = "o", desc = "󱡔 inner subword textobj" },
--   { "i<Space>", "<cmd>lua require('various-textobjs').subword('inner')<CR>", mode = { "o", "x" }, desc = "󱡔 inner subword textobj" },
--   { "a<Space>", "<cmd>lua require('various-textobjs').subword('outer')<CR>", mode = { "o", "x" }, desc = "󱡔 outer subword textobj" },
--
--   { "iv", "<cmd>lua require('various-textobjs').value('inner')<CR>", mode = { "x", "o" }, desc = "󱡔 inner value textobj" },
--   { "av", "<cmd>lua require('various-textobjs').value('outer')<CR>", mode = { "x", "o" }, desc = "󱡔 outer value textobj" },
--   -- INFO `ik` defined via treesitter to exclude `local` and `let`; mapping the *inner* obj to `ak`, since it includes `local` and `let`
--   { "ak", "<cmd>lua require('various-textobjs').key('inner')<CR>", mode = { "x", "o" }, desc = "󱡔 outer key textobj" },
--
--   { "n", "<cmd>lua require('various-textobjs').nearEoL()<CR>", mode = { "o", "x" }, desc = "󱡔 near EoL textobj" },
--   { "m", "<cmd>lua require('various-textobjs').toNextClosingBracket()<CR>", mode = { "o", "x" }, desc = "󱡔 to next closing bracket textobj" },
--   { "w", "<cmd>lua require('various-textobjs').toNextQuotationMark()<CR>", mode = "o", desc = "󱡔 to next quote textobj", nowait = true },
--   { "i" .. u.textobjMaps.wikilink, "<cmd>lua require('various-textobjs').doubleSquareBrackets('inner')<CR>", mode = { "x", "o" }, desc = "󱡔 inner wikilink" },
--   { "a" .. u.textobjMaps.wikilink, "<cmd>lua require('various-textobjs').doubleSquareBrackets('outer')<CR>", mode = { "x", "o" }, desc = "󱡔 outer wikilink" },
--
--   -- INFO not setting in visual mode, to keep visual block mode replace
--   { "rv", "<cmd>lua require('various-textobjs').restOfWindow()<CR>", mode = "o", desc = "󱡔 rest of viewport textobj" },
--   { "rp", "<cmd>lua require('various-textobjs').restOfParagraph()<CR>", mode = "o", desc = "󱡔 rest of paragraph textobj" },
--   { "ri", "<cmd>lua require('various-textobjs').restOfIndentation()<CR>", mode = "o", desc = "󱡔 rest of indentation textobj" },
--   { "rg", "G", mode = "o", desc = "󱡔 rest of buffer textobj" },
--   { "gg", "<cmd>lua require('various-textobjs').entireBuffer()<CR>", mode = { "x", "o" }, desc = "󱡔 entire buffer textobj" },
--
--   { "ge", "<cmd>lua require('various-textobjs').diagnostic()<CR>", mode = { "x", "o" }, desc = "󱡔 diagnostic textobj" },
--   { "L", "<cmd>lua require('various-textobjs').url()<CR>", mode = "o", desc = "󱡔 link textobj" },
--   { "o", "<cmd>lua require('various-textobjs').column()<CR>", mode = "o", desc = "󱡔 column textobj" },
--   { "u", "<cmd>lua require('various-textobjs').multiCommentedLines()<CR>", mode = "o", desc = "󱡔 multi-comment-lint textobj" },
--   { "in", "<cmd>lua require('various-textobjs').notebookCell('inner')<CR>", mode = { "x", "o" }, desc = "󱡔 inner cell textobj" },
--   { "an", "<cmd>lua require('various-textobjs').notebookCell('outer')<CR>", mode = { "x", "o" }, desc = "󱡔 outer cell textobj" },
--
--   { "ii", "<cmd>lua require('various-textobjs').indentation('inner', 'inner')<CR>", mode = { "x", "o" }, desc = "󱡔 inner indent textobj" },
--   { "ai", "<cmd>lua require('various-textobjs').indentation('outer', 'outer')<CR>", mode = { "x", "o" }, desc = "󱡔 outer indent textobj" },
--   { "ij", "<cmd>lua require('various-textobjs').indentation('outer', 'inner')<CR>", mode = { "x", "o" }, desc = "󱡔 top-border indent textobj" },
--   { "aj", "<cmd>lua require('various-textobjs').indentation('outer', 'inner')<CR>", mode = { "x", "o" }, desc = "󱡔 top-border indent textobj" },
--   { "ig", "<cmd>lua require('various-textobjs').greedyOuterIndentation('inner')<CR>", mode = { "x", "o" }, desc = "󱡔 inner greedy indent" },
--   { "ag", "<cmd>lua require('various-textobjs').greedyOuterIndentation('outer')<CR>", mode = { "x", "o" }, desc = "󱡔 outer greedy indent" },
--
--   { "i.", "<cmd>lua require('various-textobjs').chainMember('inner')<CR>", mode = { "x", "o" }, desc = "󱡔 inner indent textobj" },
--   { "a.", "<cmd>lua require('various-textobjs').chainMember('outer')<CR>", mode = { "x", "o" }, desc = "󱡔 outer indent textobj" },
--
--   -- python
--   { "iy", "<cmd>lua require('various-textobjs').pyTripleQuotes('inner')<CR>", ft = "python", mode = { "x", "o" }, desc = "󱡔 inner tripleQuotes textobj" },
--   { "ay", "<cmd>lua require('various-textobjs').pyTripleQuotes('outer')<CR>", ft = "python", mode = { "x", "o" }, desc = "󱡔 outer tripleQuotes textobj" },
--
--   -- markdown
--   { "il", "<cmd>lua require('various-textobjs').mdlink('inner')<CR>", mode = { "x", "o" }, ft = "markdown", desc = "󱡔 inner md link" },
--   { "al", "<cmd>lua require('various-textobjs').mdlink('outer')<CR>", mode = { "x", "o" }, ft = "markdown", desc = "󱡔 outer md link" },
--   { "i" .. u.textobjMaps.codeblock, "<cmd>lua require('various-textobjs').mdFencedCodeBlock('inner')<CR>", mode = { "x",

-- keys = {
--   { "im", ft = { "markdown", "toml" }, mode = { "o", "x" }, function() require("various-textobjs").mdlink("inner") end, desc = "Markdown Link" },
--   { "am", ft = { "markdown", "toml" }, mode = { "o", "x" }, function() require("various-textobjs").mdlink("outer") end, desc = "Markdown Link" },
--   { "iC", ft = { "markdown" }, mode = { "o", "x" }, function() require("various-textobjs").mdFencedCodeBlock("inner") end, desc = "CodeBlock" },
--   { "aC", ft = { "markdown" }, mode = { "o", "x" }, function() require("various-textobjs").mdFencedCodeBlock("outer") end, desc = "CodeBlock" },
--   { "ie", ft = { "markdown" }, mode = { "o", "x" }, function() require("various-textobjs").mdEmphasis("inner") end, desc = "Emphasis" },
--   { "ae", ft = { "markdown" }, mode = { "o", "x" }, function() require("various-textobjs").mdEmphasis("outer") end, desc = "Emphasis" },
--   { "gd", mode = { "o", "x" }, function() require("various-textobjs").diagnostics() end, desc = "Diagnostics" },
--   { "iy", ft = { "python" }, mode = { "o", "x" }, function() require("various-textobjs").pyTripleQuotes("inner") end, desc = "Triple Quotes" },
--   { "ay", ft = { "python" }, mode = { "o", "x" }, function() require("various-textobjs").pyTripleQuotes("outer") end, desc = "Triple Quotes" },
--   { "iC", ft = { "css", "scss", "less" }, mode = { "o", "x" }, function() require("various-textobjs").cssSelector("inner") end, desc = "CSS Selector" },
--   { "aC", ft = { "css", "scss", "less" }, mode = { "o", "x" }, function() require("various-textobjs").cssSelector("outer") end, desc = "CSS Selector" },
--   { "i#", ft = { "css", "scss", "less" }, mode = { "o", "x" }, function() require("various-textobjs").cssColor("inner") end, desc = "CSS Color" },
--   { "a#", ft = { "css", "scss", "less" }, mode = { "o", "x" }, function() require("various-textobjs").cssColor("outer") end, desc = "CSS Color" },
--   { "iP", ft = { "sh" }, mode = { "o", "x" }, function() require("various-textobjs").shellPipe("inner") end, desc = "Pipe" },
--   { "aP", ft = { "sh" }, mode = { "o", "x" }, function() require("various-textobjs").shellPipe("outer") end, desc = "Pipe" },
--   { "iH", ft = { "html, xml, css, scss, less" }, mode = { "o", "x" }, function() require("various-textobjs").htmlAttribute("inner") end, desc = "HTML Attribute" },
--   { "iv", mode = { "o", "x" }, function() require("various-textobjs").value("inner") end, desc = "Value" },
--   { "av", mode = { "o", "x" }, function() require("various-textobjs").value("outer") end, desc = "Value" },
--   { "ik", mode = { "o", "x" }, function() require("various-textobjs").key("inner") end, desc = "Key" },
--   { "ak", mode = { "o", "x" }, function() require("various-textobjs").key("outer") end, desc = "Key" },
--   { "L", mode = { "o", "x" }, function() require("various-textobjs").url() end, desc = "Link" },
--   { "iN", mode = { "o", "x" }, function() require("various-textobjs").number("inner") end, desc = "Number" },
--   { "aN", mode = { "o", "x" }, function() require("various-textobjs").number("outer") end, desc = "Number" },
-- },
-- require('various-textobjs').setup({ useDefaultKeymaps = false })
