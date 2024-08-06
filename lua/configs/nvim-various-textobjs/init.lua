-- https://github.com/jeetsukumaran/vim-indentwise
-- https://github.com/jessekelighine/vindent.vim
-- https://github.com/chrisgrieser/nvim-various-textobjs/blob/main/README.md#delete-surrounding-indentation

local map = function(modes, lhs, rhs, opts)
  if type(opts) == "string" then
    opts = { desc = "韛" .. opts } --  鶴 韛     ﱕ 
  end
  local options = vim.tbl_extend("keep", opts or {}, { silent = true })
  vim.keymap.set(modes, lhs, rhs, options)
end

local local_map = function(buffer)
  return function(modes, lhs, rhs, opts)
    if type(opts) == "string" then
      opts = { desc = opts, buffer = buffer }
    end
    local options = vim.tbl_extend("keep", opts or {}, { silent = true })
    vim.keymap.set(modes, lhs, rhs, options)
  end
end

local various_textobjs = require("various-textobjs")
various_textobjs.setup({
  -- lines to seek forwards for "small" textobjs (mostly characterwise textobjs)
  -- set to 0 to only look in the current line
  lookForwardSmall = 20,
  -- lines to seek forwards for "big" textobjs (mostly linewise textobjs)
  lookForwardBig = 50,
  useDefaultKeymaps = true,
  disabledKeymaps = {
    "P", -- Used for paste operator
    "|", -- Disabled
    "L", -- Replaced with iu
    "r", -- Used for remote operator
    "R", -- Keep open for remote operator
    "=", -- Use Treesitter's @assignment instead
    "ig", -- Replaced with iG
    "ag", -- Replaced with aG
    "ii", -- Just use iI
    "ai", -- Just use aI
    "gG", -- Replaced with ie
    "il", -- Replaced with iL
    "al", -- Replaced with aL
    "ic", -- Disabled (CSS class)
    "ac", -- Disabled (CSS class)
    "ix", -- Replaced with iX
    "ax", -- Replaced with iX
    "iD", -- Use vim-textobj-user's date instead
    "aD", -- Use vim-textobj-user's date instead
    "iS", -- Replaced with i-
    "aS", -- Replaced with a-
    "in", -- Disabled, use treesitter's iN, instead
    "an", -- Disabled, use treesitter's aN, instead
    "gc", -- commenting already setup
  },
})
-- " % ' ( ) < > ? [ ] _ ` { } ia iA ib iB ic iC if ih ii il iL in iN io ip iq is

-- { "aS", function() require("various-textobjs").subword(false) end, mode = { "o", "x" }, desc = "outer subword", },
-- { "iS", function() require("various-textobjs").subword(true) end, mode = { "o", "x" }, desc = "inner subword", },

-- iG aG iE aE iL aL iU aU id ad r ix aX i- iE aE } [{ ix ax ic ac dsi gx
-- iv av ispace aspace ak n m w rv rp ri rg gg ge L o u in an ii ai ij aj ig ag  i. a.

local ox = { "o", "x" }
map(ox, "iG", function()
  various_textobjs.greedyOuterIndentation("inner")
end, "Greedy outer indentation")
map(ox, "aG", function()
  various_textobjs.greedyOuterIndentation("outer")
end, "Greedy outer indentation")
map(ox, "ie", various_textobjs.entireBuffer, "Entire buffer")
map(ox, "il", function()
  return various_textobjs.lineCharacterwise("inner")
end, "Line")
map(ox, "al", function()
  return various_textobjs.lineCharacterwise("outer")
end, "Line")
map(ox, "iu", various_textobjs.url, "URL")
map(ox, "id", various_textobjs.diagnostic, "Diagnostic")
map(ox, "?", various_textobjs.diagnostic, "Diagnostic")
map(ox, "iX", function()
  return various_textobjs.htmlAttribute("inner")
end, "HTML attribute")
map(ox, "aX", function()
  return various_textobjs.htmlAttribute("outer")
end, "HTML attribute")
map(ox, "i-", function()
  return various_textobjs.subword("inner")
end, "HTML attribute")
map(ox, "a-", function()
  return various_textobjs.subword("outer")
end, "HTML attribute")
map(ox, "iE", function()
  return various_textobjs.mdEmphasis("inner")
end, "Markdown emphasis")
map(ox, "aE", function()
  return various_textobjs.mdEmphasis("outer")
end, "Markdown emphasis")
map(ox, "]}", function()
  return various_textobjs.toNextClosingBracket()
end, "To next closing bracket")
map(ox, "[{", function()
  return various_textobjs.toNextClosingBracket()
end, "To previous closing bracket")

local markdown_textobjs = function()
  local opts = { buffer = true }
  map(ox, "ix", function()
    return various_textobjs.mdlink("inner")
  end, opts)
  map(ox, "ax", function()
    return various_textobjs.mdlink("outer")
  end, opts)
  map(ox, "ic", function()
    return various_textobjs.mdFencedCodeBlock("inner")
  end, opts)
  map(ox, "ac", function()
    return various_textobjs.mdFencedCodeBlock("outer")
  end, opts)
end

local augroup = vim.api.nvim_create_augroup("VariousTextobjs", {})
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  group = augroup,
  callback = markdown_textobjs,
})
markdown_textobjs()

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
end, { desc = "Delete surrounding indentation" })

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
end, { desc = "indent last paste" })

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
