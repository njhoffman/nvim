local ref = {
  -- stylua: ignore start
  { "<Space>", "<cmd>lua require('various-textobjs').subword('inner')<CR>", mode = "o", desc = "󱡔 inner subword textobj" },
  { "i<Space>", "<cmd>lua require('various-textobjs').subword('inner')<CR>", mode = { "o", "x" }, desc = "󱡔 inner subword textobj" },
  { "a<Space>", "<cmd>lua require('various-textobjs').subword('outer')<CR>", mode = { "o", "x" }, desc = "󱡔 outer subword textobj" },

  { "iv", "<cmd>lua require('various-textobjs').value('inner')<CR>", mode = { "x", "o" }, desc = "󱡔 inner value textobj" },
  { "av", "<cmd>lua require('various-textobjs').value('outer')<CR>", mode = { "x", "o" }, desc = "󱡔 outer value textobj" },
  -- INFO `ik` defined via treesitter to exclude `local` and `let`; mapping the *inner* obj to `ak`, since it includes `local` and `let`
  { "ak", "<cmd>lua require('various-textobjs').key('inner')<CR>", mode = { "x", "o" }, desc = "󱡔 outer key textobj" },

  { "n", "<cmd>lua require('various-textobjs').nearEoL()<CR>", mode = { "o", "x" }, desc = "󱡔 near EoL textobj" },
  { "m", "<cmd>lua require('various-textobjs').toNextClosingBracket()<CR>", mode = { "o", "x" }, desc = "󱡔 to next closing bracket textobj" },
  { "w", "<cmd>lua require('various-textobjs').toNextQuotationMark()<CR>", mode = "o", desc = "󱡔 to next quote textobj", nowait = true },
  { "i" .. u.textobjMaps.wikilink, "<cmd>lua require('various-textobjs').doubleSquareBrackets('inner')<CR>", mode = { "x", "o" }, desc = "󱡔 inner wikilink" },
  { "a" .. u.textobjMaps.wikilink, "<cmd>lua require('various-textobjs').doubleSquareBrackets('outer')<CR>", mode = { "x", "o" }, desc = "󱡔 outer wikilink" },

  -- INFO not setting in visual mode, to keep visual block mode replace
  { "rv", "<cmd>lua require('various-textobjs').restOfWindow()<CR>", mode = "o", desc = "󱡔 rest of viewport textobj" },
  { "rp", "<cmd>lua require('various-textobjs').restOfParagraph()<CR>", mode = "o", desc = "󱡔 rest of paragraph textobj" },
  { "ri", "<cmd>lua require('various-textobjs').restOfIndentation()<CR>", mode = "o", desc = "󱡔 rest of indentation textobj" },
  { "rg", "G", mode = "o", desc = "󱡔 rest of buffer textobj" },
  { "gg", "<cmd>lua require('various-textobjs').entireBuffer()<CR>", mode = { "x", "o" }, desc = "󱡔 entire buffer textobj" },

  { "ge", "<cmd>lua require('various-textobjs').diagnostic()<CR>", mode = { "x", "o" }, desc = "󱡔 diagnostic textobj" },
  { "L", "<cmd>lua require('various-textobjs').url()<CR>", mode = "o", desc = "󱡔 link textobj" },
  { "o", "<cmd>lua require('various-textobjs').column()<CR>", mode = "o", desc = "󱡔 column textobj" },
  { "u", "<cmd>lua require('various-textobjs').multiCommentedLines()<CR>", mode = "o", desc = "󱡔 multi-comment-lint textobj" },
  { "in", "<cmd>lua require('various-textobjs').notebookCell('inner')<CR>", mode = { "x", "o" }, desc = "󱡔 inner cell textobj" },
  { "an", "<cmd>lua require('various-textobjs').notebookCell('outer')<CR>", mode = { "x", "o" }, desc = "󱡔 outer cell textobj" },

  { "ii", "<cmd>lua require('various-textobjs').indentation('inner', 'inner')<CR>", mode = { "x", "o" }, desc = "󱡔 inner indent textobj" },
  { "ai", "<cmd>lua require('various-textobjs').indentation('outer', 'outer')<CR>", mode = { "x", "o" }, desc = "󱡔 outer indent textobj" },
  { "ij", "<cmd>lua require('various-textobjs').indentation('outer', 'inner')<CR>", mode = { "x", "o" }, desc = "󱡔 top-border indent textobj" },
  { "aj", "<cmd>lua require('various-textobjs').indentation('outer', 'inner')<CR>", mode = { "x", "o" }, desc = "󱡔 top-border indent textobj" },
  { "ig", "<cmd>lua require('various-textobjs').greedyOuterIndentation('inner')<CR>", mode = { "x", "o" }, desc = "󱡔 inner greedy indent" },
  { "ag", "<cmd>lua require('various-textobjs').greedyOuterIndentation('outer')<CR>", mode = { "x", "o" }, desc = "󱡔 outer greedy indent" },

  { "i.", "<cmd>lua require('various-textobjs').chainMember('inner')<CR>", mode = { "x", "o" }, desc = "󱡔 inner indent textobj" },
  { "a.", "<cmd>lua require('various-textobjs').chainMember('outer')<CR>", mode = { "x", "o" }, desc = "󱡔 outer indent textobj" },

  -- python
  { "iy", "<cmd>lua require('various-textobjs').pyTripleQuotes('inner')<CR>", ft = "python", mode = { "x", "o" }, desc = "󱡔 inner tripleQuotes textobj" },
  { "ay", "<cmd>lua require('various-textobjs').pyTripleQuotes('outer')<CR>", ft = "python", mode = { "x", "o" }, desc = "󱡔 outer tripleQuotes textobj" },

  -- markdown
  { "il", "<cmd>lua require('various-textobjs').mdlink('inner')<CR>", mode = { "x", "o" }, ft = "markdown", desc = "󱡔 inner md link" },
  { "al", "<cmd>lua require('various-textobjs').mdlink('outer')<CR>", mode = { "x", "o" }, ft = "markdown", desc = "󱡔 outer md link" },
  { "i" .. u.textobjMaps.codeblock, "<cmd>lua require('various-textobjs').mdFencedCodeBlock('inner')<CR>", mode = { "x", },
    keys = {
      { "im", ft = { "markdown", "toml" }, mode = { "o", "x" }, function() require("various-textobjs").mdlink("inner") end, desc = "Markdown Link" },
      { "am", ft = { "markdown", "toml" }, mode = { "o", "x" }, function() require("various-textobjs").mdlink("outer") end, desc = "Markdown Link" },
      { "iC", ft = { "markdown" }, mode = { "o", "x" }, function() require("various-textobjs").mdFencedCodeBlock("inner") end, desc = "CodeBlock" },
      { "aC", ft = { "markdown" }, mode = { "o", "x" }, function() require("various-textobjs").mdFencedCodeBlock("outer") end, desc = "CodeBlock" },
      { "ie", ft = { "markdown" }, mode = { "o", "x" }, function() require("various-textobjs").mdEmphasis("inner") end, desc = "Emphasis" },
      { "ae", ft = { "markdown" }, mode = { "o", "x" }, function() require("various-textobjs").mdEmphasis("outer") end, desc = "Emphasis" },
      { "gd", mode = { "o", "x" }, function() require("various-textobjs").diagnostics() end, desc = "Diagnostics" },
      { "iy", ft = { "python" }, mode = { "o", "x" }, function() require("various-textobjs").pyTripleQuotes("inner") end, desc = "Triple Quotes" },
      { "ay", ft = { "python" }, mode = { "o", "x" }, function() require("various-textobjs").pyTripleQuotes("outer") end, desc = "Triple Quotes" },
      { "iC", ft = { "css", "scss", "less" }, mode = { "o", "x" }, function() require("various-textobjs").cssSelector("inner") end, desc = "CSS Selector" },
      { "aC", ft = { "css", "scss", "less" }, mode = { "o", "x" }, function() require("various-textobjs").cssSelector("outer") end, desc = "CSS Selector" },
      { "i#", ft = { "css", "scss", "less" }, mode = { "o", "x" }, function() require("various-textobjs").cssColor("inner") end, desc = "CSS Color" },
      { "a#", ft = { "css", "scss", "less" }, mode = { "o", "x" }, function() require("various-textobjs").cssColor("outer") end, desc = "CSS Color" },
      { "iP", ft = { "sh" }, mode = { "o", "x" }, function() require("various-textobjs").shellPipe("inner") end, desc = "Pipe" },
      { "aP", ft = { "sh" }, mode = { "o", "x" }, function() require("various-textobjs").shellPipe("outer") end, desc = "Pipe" },
      { "iH", ft = { "html, xml, css, scss, less" }, mode = { "o", "x" }, function() require("various-textobjs").htmlAttribute("inner") end, desc = "HTML Attribute" },
      { "iv", mode = { "o", "x" }, function() require("various-textobjs").value("inner") end, desc = "Value" },
      { "av", mode = { "o", "x" }, function() require("various-textobjs").value("outer") end, desc = "Value" },
      { "ik", mode = { "o", "x" }, function() require("various-textobjs").key("inner") end, desc = "Key" },
      { "ak", mode = { "o", "x" }, function() require("various-textobjs").key("outer") end, desc = "Key" },
      { "L", mode = { "o", "x" }, function() require("various-textobjs").url() end, desc = "Link" },
      { "iN", mode = { "o", "x" }, function() require("various-textobjs").number("inner") end, desc = "Number" },
      { "aN", mode = { "o", "x" }, function() require("various-textobjs").number("outer") end, desc = "Number" },
    },

    require('various-textobjs').setup({ useDefaultKeymaps = false })
    {
      "<leader>H",
      function() vim.cmd.TSTextobjectPeekDefinitionCode("@function.outer") end,
        desc = " Hover Peek Function",
      },
      {
        "q",
        function() vim.cmd.TSTextobjectSelect("@comment.outer") end,
        mode = "o", -- only operator-pending to not conflict with commenting selection
        desc = "󱡔  single comment textobj",
      },
      {
        "dq",
        function()
          local cursor = vim.api.nvim_win_get_cursor(0)
          vim.cmd.TSTextobjectSelect("@comment.outer")
          u.normal("d")
          vim.api.nvim_win_set_cursor(0, cursor)
        end,
        desc = " Sticky Delete Comment",
      },
      {
        "cq",
        function()
          vim.cmd.TSTextobjectSelect("@comment.outer")
          u.normal("d")
          local comStr = vim.bo.commentstring:format("")
          local line = vim.api.nvim_get_current_line():gsub("%s+$", "")
          vim.api.nvim_set_current_line(line .. " " .. comStr)
          vim.cmd.startinsert { bang = true }
        end,
        desc = " Change Comment",
      },
      {
        "<C-j>",
        "<cmd>TSTextobjectGotoNextStart @function.outer<CR>zv",
          desc = " Goto Next Function",
        },
        {
          "<C-k>",
          "<cmd>TSTextobjectGotoPreviousStart @function.outer<CR>zv",
            desc = " Goto Previous Function",
          },
          -----------------------------------------------------------------------
          -- INFO outer key textobj defined via various textobjs
          -- stylua: ignore start
          { "ik", "<cmd>TSTextobjectSelect @assignment.lhs<CR>", mode = { "x", "o" }, desc = "󱡔 inner key" },
          { "a<CR>", "<cmd>TSTextobjectSelect @return.outer<CR>", mode = { "x", "o" }, desc = "󱡔 outer return" },
          { "i<CR>", "<cmd>TSTextobjectSelect @return.inner<CR>", mode = { "x", "o" }, desc = "󱡔 inner return" },
          { "a/", "<cmd>TSTextobjectSelect @regex.outer<CR>", mode = { "x", "o" }, desc = "󱡔 outer regex" },
          { "i/", "<cmd>TSTextobjectSelect @regex.inner<CR>", mode = { "x", "o" }, desc = "󱡔 inner regex" },
          { "aa", "<cmd>TSTextobjectSelect @parameter.outer<CR>", mode = { "x", "o" }, desc = "󱡔 outer parameter" },
          { "ia", "<cmd>TSTextobjectSelect @parameter.inner<CR>", mode = { "x", "o" }, desc = "󱡔 inner parameter" },
          { "iu", "<cmd>TSTextobjectSelect @loop.inner<CR>", mode = { "x", "o" }, desc = "󱡔 inner loop" },
          { "au", "<cmd>TSTextobjectSelect @loop.outer<CR>", mode = { "x", "o" }, desc = "󱡔 outer loop" },
          { "af", "<cmd>TSTextobjectSelect @function.outer<CR>", mode = {"x","o"},desc = "󱡔 outer function" },
              { "if", "<cmd>TSTextobjectSelect @function.inner<CR>", mode = {"x","o"},desc = "󱡔 inner function" },
                    { "ao", "<cmd>TSTextobjectSelect @conditional.outer<CR>", mode = {"x","o"},desc = "󱡔 outer cond." },
                    { "io", "<cmd>TSTextobjectSelect @conditional.inner<CR>", mode = {"x","o"},desc = "󱡔 inner cond." },
                    { "al", "<cmd>TSTextobjectSelect @call.outer<CR>", mode = {"x","o"},desc = "󱡔 outer call" },
                    { "il", "<cmd>TSTextobjectSelect @call.inner<CR>", mode = {"x","o"},desc = "󱡔 inner call" },
                  -- stylua: ignore end
                },
                { "<Space>", "<cmd>lua require('various-textobjs').subword('inner')<CR>", mode = "o", desc = "󱡔 inner subword" },
                { "a<Space>", "<cmd>lua require('various-textobjs').subword('outer')<CR>", mode = { "o", "x" }, desc = "󱡔 outer subword" },

                { "iv", "<cmd>lua require('various-textobjs').value('inner')<CR>", mode = { "x", "o" }, desc = "󱡔 inner value" },
                { "av", "<cmd>lua require('various-textobjs').value('outer')<CR>", mode = { "x", "o" }, desc = "󱡔 outer value" },
                -- INFO `ik` defined via treesitter to exclude `local` and `let`;
                { "ak", "<cmd>lua require('various-textobjs').key('outer')<CR>", mode = { "x", "o" }, desc = "󱡔 outer key" },

                { "pp", "<cmd>lua require('various-textobjs').lastChange()<CR>", mode = "o", desc = "󱡔 last paste" },
                { "gg", "<cmd>lua require('various-textobjs').entireBuffer()<CR>", mode = { "x", "o" }, desc = "󱡔 entire buffer" },

                { "n", "<cmd>lua require('various-textobjs').nearEoL()<CR>", mode = "o", desc = "󱡔 near EoL" },
                { "m", "<cmd>lua require('various-textobjs').toNextClosingBracket()<CR>", mode = { "o", "x" }, desc = "󱡔 to next closing bracket" },
                { "w", "<cmd>lua require('various-textobjs').toNextQuotationMark()<CR>", mode = "o", desc = "󱡔 to next quote", nowait = true },
                { "b", "<cmd>lua require('various-textobjs').anyBracket('inner')<CR>", mode = "o", desc = "󱡔 inner anyBracket" },
                { "B", "<cmd>lua require('various-textobjs').anyBracket('outer')<CR>", mode = "o", desc = "󱡔 outer anyBracket" },
                { "k", "<cmd>lua require('various-textobjs').anyQuote('inner')<CR>", mode = "o", desc = "󱡔 inner anyQuote" },
                { "K", "<cmd>lua require('various-textobjs').anyQuote('outer')<CR>", mode = "o", desc = "󱡔 outer anyQuote" },
                { "iR", "<cmd>lua require('various-textobjs').doubleSquareBrackets('inner')<CR>", mode = { "x", "o" }, desc = "󱡔 inner wikilink" },
                { "aR", "<cmd>lua require('various-textobjs').doubleSquareBrackets('outer')<CR>", mode = { "x", "o" }, desc = "󱡔 outer wikilink" },

                -- INFO not setting in visual mode, to keep visual block mode replace
                { "rv", "<cmd>lua require('various-textobjs').restOfWindow()<CR>", mode = "o", desc = "󱡔 rest of viewport" },
                { "rp", "<cmd>lua require('various-textobjs').restOfParagraph()<CR>", mode = "o", desc = "󱡔 rest of paragraph" },
                { "ri", "<cmd>lua require('various-textobjs').restOfIndentation()<CR>", mode = "o", desc = "󱡔 rest of indentation" },
                { "rg", "G", mode = "o", desc = "󱡔 rest of buffer" },

                { "ge", "<cmd>lua require('various-textobjs').diagnostic()<CR>", mode = { "x", "o" }, desc = "󱡔 diagnostic" },
                { "L", "<cmd>lua require('various-textobjs').url()<CR>", mode = "o", desc = "󱡔 link" },
                { "o", "<cmd>lua require('various-textobjs').column()<CR>", mode = "o", desc = "󱡔 column" },

                { "in", "<cmd>lua require('various-textobjs').notebookCell('inner')<CR>", mode = { "x", "o" }, desc = "󱡔 inner notebookCell" },
                { "an", "<cmd>lua require('various-textobjs').notebookCell('outer')<CR>", mode = { "x", "o" }, desc = "󱡔 outer notebookCell" },

                { "ii", "<cmd>lua require('various-textobjs').indentation('inner', 'inner')<CR>", mode = { "x", "o" }, desc = "󱡔 inner indent" },
                { "ai", "<cmd>lua require('various-textobjs').indentation('outer', 'outer')<CR>", mode = { "x", "o" }, desc = "󱡔 outer indent" },
                { "aj", "<cmd>lua require('various-textobjs').indentation('outer', 'inner')<CR>", mode = { "x", "o" }, desc = "󱡔 top-border indent" },
                { "ig", "<cmd>lua require('various-textobjs').greedyOuterIndentation('inner')<CR>", mode = { "x", "o" }, desc = "󱡔 inner greedy indent" },
                { "ag", "<cmd>lua require('various-textobjs').greedyOuterIndentation('outer')<CR>", mode = { "x", "o" }, desc = "󱡔 outer greedy indent" },

                { "i.", "<cmd>lua require('various-textobjs').chainMember('inner')<CR>", mode = { "x", "o" }, desc = "󱡔 inner indent" },
                { "a.", "<cmd>lua require('various-textobjs').chainMember('outer')<CR>", mode = { "x", "o" }, desc = "󱡔 outer indent" },

                { "u", "<cmd>lua require('various-textobjs').multiCommentedLines()<CR>", mode = "o", desc = "󱡔 multi-line-comment" },
                { "guu", "guu" }, -- do not use `u` as textobject when using `guu`

                  -- python
                  { "iy", "<cmd>lua require('various-textobjs').pyTripleQuotes('inner')<CR>", ft = "python", mode = { "x", "o" }, desc = "󱡔 inner tripleQuotes" },
                  { "ay", "<cmd>lua require('various-textobjs').pyTripleQuotes('outer')<CR>", ft = "python", mode = { "x", "o" }, desc = "󱡔 outer tripleQuotes" },

                  -- markdown
                  { "iE", "<cmd>lua require('various-textobjs').mdFencedCodeBlock('inner')<CR>", mode = { "x", "o" }, ft = "markdown", desc = "󱡔 inner CodeBlock" },
                  { "aE", "<cmd>lua require('various-textobjs').mdFencedCodeBlock('outer')<CR>", mode = { "x", "o" }, ft = "markdown", desc = "󱡔 outer CodeBlock" },
                  { "il", "<cmd>lua require('various-textobjs').mdlink('inner')<CR>", mode = { "x", "o" }, ft = "markdown", desc = "󱡔 inner md link" },
                  { "al", "<cmd>lua require('various-textobjs').mdlink('outer')<CR>", mode = { "x", "o" }, ft = "markdown", desc = "󱡔 outer md link" },
                  { "if", "<cmd>lua require('various-textobjs').mdEmphasis('inner')<CR>", mode = { "x", "o" }, f } ,
}
