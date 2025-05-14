local gen_spec = require("mini.ai").gen_spec

local miniAiGitsigns = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local hunks = require("gitsigns.cache").cache[bufnr].hunks
  hunks = vim.tbl_map(function(hunk)
    local from_line = hunk.added.start
    local from_col = 1
    local to_line = hunk.vend
    local to_col = #vim.api.nvim_buf_get_lines(bufnr, to_line - 1, to_line, false)[1] + 1
    return {
      from = { line = from_line, col = from_col },
      to = { line = to_line, col = to_col },
    }
  end, hunks)

  return hunks
end

local gen_ai_spec = require("mini.extra").gen_ai_spec
local custom_objects = {
  -- argument
  a = gen_spec.argument({ separator = "[,;]" }),
  -- Brackets
  b = { { "%b()", "%b[]", "%b{}" }, "^.().*().$" },
  -- Comments
  -- digits
  d = gen_ai_spec.number(),
  -- diagnostics
  e = gen_ai_spec.diagnostic(),
  -- Function call
  f = gen_spec.function_call(),
  -- grammer (sentence)
  g = {
    {
      "%b{}",
      "\n%s*\n()().-()\n%s*\n[%s]*()", -- normal paragraphs
      "^()().-()\n%s*\n[%s]*()", -- paragraph at start of file
      "\n%s*\n()().-()()$", -- paragraph at end of file
    },
    {
      "[%.?!][%s]+()().-[^%s].-()[%.?!]()[%s]", -- normal sentence
      "^[%{%[]?[%s]*()().-[^%s].-()[%.?!]()[%s]", -- sentence at start of paragraph
      "[%.?!][%s]+()().-[^%s].-()()[\n%}%]]?$", -- sentence at end of paragraph
      "^[%s]*()().-[^%s].-()()[%s]+$", -- sentence at that fills paragraph (no final punctuation)
    },
  },
  -- git hunks
  h = miniAiGitsigns,
  -- Indents
  i = gen_ai_spec.indent(),
  -- Jumps
  -- key (from key value pair)
  k = gen_spec.treesitter({
    i = { "@key.inner", "@assignment.lhs" },
    a = { "@key.inner", "@assignment.lhs" },
  }),
  -- List (quickfix)
  -- blOck
  o = gen_spec.treesitter({
    a = { "@block.outer", "@conditional.outer", "@loop.outer" },
    i = { "@block.inner", "@conditional.inner", "@loop.inner" },
  }),
  -- paragraph
  p = {
    {
      "\n%s*\n()().-()\n%s*\n()[%s]*", -- normal paragraphs
      "^()().-()\n%s*\n[%s]*()", -- paragraph at start of file
      "\n%s*\n()().-()()$", -- paragraph at end of file
    },
  },
  -- Quotes
  q = { { "%b''", '%b""', "%b``" }, "^.().*().$" },
  -- sub-word (below w on my keyboard)
  r = {
    {
      "%u[%l%d]+%f[^%l%d]",
      "%f[%S][%l%d]+%f[^%l%d]",
      "%f[%P][%l%d]+%f[^%l%d]",
      "^[%l%d]+%f[^%l%d]",
    },
    "^().*()$",
  },
  -- scope
  s = gen_spec.treesitter({
    a = { "@function.outer", "@class.outer", "@testitem.outer" },
    i = { "@function.inner", "@class.inner", "@testitem.inner" },
  }),
  -- Tag
  t = { "<(%w-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
  -- value (from key value pair)
  v = gen_spec.treesitter({
    i = { "@value.inner", "@assignment.rhs" },
    a = { "@value.inner", "@assignment.rhs" },
  }),
  -- WORD
  W = { {
    "()()%f[%w%p][%w%p]+()[ \t]*()",
  } },
  -- word
  w = { "()()%f[%w_][%w_]+()[ \t]*()" },
  -- line (same key as visual line in my mappings)
  x = gen_ai_spec.line(),
  -- chunk (as in from vim-textobj-chunk)
  z = {
    "\n.-%b{}.-\n",
    "\n().-()%{\n.*\n.*%}().-\n()",
  },
  ["$"] = gen_spec.pair("$", "$", { type = "balanced" }),
}

local treesitter_obj = function()
  local lines = vim.fn.line("$")
  local enable = true
  if lines > 8000 then -- skip some settings for large file
    print("skip treesitter obj")
    return
  end

  if lines > 4000 then
    enable = false
  end
  -- lprint('ts obj', enable)
  require("nvim-treesitter.configs").setup({
    -- indent = { enable = enable },
    incremental_selection = {
      enable = enable, -- use textobjects
      -- disable = {"elm"},
      keymaps = {
        -- mappings for incremental selection (visual mappings)
        init_selection = "gn", -- maps in normal mode to init the node/scope selection
        scope_incremental = "gn", -- increment to the upper scope (as defined in locals.scm)
        node_incremental = "<TAB>", -- increment to the upper named parent
        node_decremental = "<S-TAB>", -- decrement to the previous node
      },
    },
    textobjects = {
      -- syntax-aware textobjects
      lsp_interop = {
        enable = false, -- use LSP
        peek_definition_code = { ["DF"] = "@function.outer", ["CF"] = "@class.outer" },
      },
      move = {
        enable = enable,
        set_jumps = enable, -- whether to set jumps in the jumplist
        goto_next_start = {
          ["]m"] = { query = { "@function.outer" } }, -- use system default
          -- query = { '@scope', 'class.*', '@loop.*', '@conditional' },
          -- [']s'] = {
          --   query = { '@scope', '@class.*', '@loop.*', '@conditional' },
          --   query_group = 'locals',
          --   desc = 'Next scope',
          -- },
          ["]z"] = {
            query = { "@fold" },
            query_group = "folds",
            desc = "Next fold",
          },
          ["]]"] = {
            query = { "@class.outer", "@function.*", "block.outer" },
            desc = "nearest block",
          },
          -- default ]z [z fold jump; [s/]s scope jump
        },
        goto_next_end = {
          ["]M"] = "@function.outer", -- use nvim 0.11 default
          ["]C"] = {
            query = { "@loop.outer", "@conditional.outer", "@class.outer" },
            desc = "next scope",
          },
        },
        goto_previous_start = {
          ["[m"] = { query = { "@function.outer" }, desc = "nearest func" },
          ["[["] = {
            query = { "@function.*", "@class.outer", "block.outer" },
            desc = "prev func ; class ",
          },
          -- [']s'] = {
          --   query = { '@class.*', '@loop.*', '@conditional' },
          --   query_group = 'locals',
          --   desc = 'Previous scope',
          -- },
          -- ['[s'] = {
          --   query = { '@scope', '@class.*', '@loop.*', '@conditional' },
          --   query_group = 'locals',
          --   desc = 'Next scope',
          -- },
          ["[z"] = {
            query = { "@fold" },
            query_group = "folds",
            desc = "Next fold",
          },
        },
        goto_previous_end = {
          ["[M"] = { query = "@function.outer", desc = "previous func" },
          ["[]"] = { query = "@class.outer", desc = "previous class" },
        },
        goto_next = {
          ["]D"] = { query = "@conditional.outer", desc = "next conditional" },
        },
        goto_previous = {
          ["[D"] = { query = "@conditional.outer", desc = "previous conditional" },
        },
      },
      select = {
        enable = enable,
        lookahead = enable,
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ["af"] = { query = "@function.outer", desc = "select inner class" },
          ["if"] = { query = "@function.inner", desc = "select inner function" },
          ["ac"] = { query = "@class.outer", desc = "select outer class" },
          ["ic"] = { query = "@class.inner", desc = "select inner class" },
          ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
        },
        selection_modes = {
          ["@parameter.outer"] = "v", -- charwise
          ["@function.outer"] = "V", -- linewise
          ["@class.outer"] = "<c-v>", -- blockwise
        },
        include_surrounding_whitespace = false,
      },
      swap = { -- use ISWAP
        enable = false,
        -- swap_next = { ["<leader>a"] = "@parameter.inner" },
        -- swap_previous = { ["<leader>A"] = "@parameter.inner" },
      },
    },
  })
end

require("nvim-treesitter.configs").setup({
  indent = { enable = true, disable = { "python" } },
  textobjects = {
    -- syntax-aware textobjects
    enable = enable,
    disable = { "elm" },
    lsp_interop = {
      enable = enable,
      border = "single",
      peek_definition_code = {
        ["gl"] = "@function.outer",
        ["gK"] = "@class.outer",
      },
    },
    move = {
      enable = enable,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["gnf"] = "@function.outer",
        ["gnif"] = "@function.inner",
        ["gnp"] = "@parameter.inner",
        ["gnc"] = "@call.outer",
        ["gnic"] = "@call.inner",
      },
      goto_next_end = {
        ["gnF"] = "@function.outer",
        ["gniF"] = "@function.inner",
        ["gnP"] = "@parameter.inner",
        ["gnC"] = "@call.outer",
        ["gniC"] = "@call.inner",
      },
      goto_previous_start = {
        ["gpf"] = "@function.outer",
        ["gpif"] = "@function.inner",
        ["gpp"] = "@parameter.inner",
        ["gpc"] = "@call.outer",
        ["gpic"] = "@call.inner",
      },
      goto_previous_end = {
        ["gpF"] = "@function.outer",
        ["gpiF"] = "@function.inner",
        ["gpP"] = "@parameter.inner",
        ["gpC"] = "@call.outer",
        ["gpiC"] = "@call.inner",
      },
    },
    select = {
      enable = true,
      include_surrounding_whitespace = true,
      keymaps = {
        ["af"] = { query = "@function.outer", desc = "ts: all function" },
        ["if"] = { query = "@function.inner", desc = "ts: inner function" },
        ["ac"] = { query = "@class.outer", desc = "ts: all class" },
        ["ic"] = { query = "@class.inner", desc = "ts: inner class" },
        ["aC"] = { query = "@conditional.outer", desc = "ts: all conditional" },
        ["iC"] = { query = "@conditional.inner", desc = "ts: inner conditional" },
        -- FIXME: this is unusable
        -- https://github.com/nvim-treesitter/nvim-treesitter-textobjects/issues/133 is resolved
        -- ['ax'] = '@comment.outer',
      },
    },
    swap = {
      enable = enable,
      swap_next = { ["[W"] = "@parameter.inner" },
      swap_previous = { ["]W"] = "@parameter.inner" },
    },
  },
})

local keys = {
  {
    "<Space>",
    function()
      -- for deletions use the outer subword, otherwise the inner
      local scope = vim.v.operator == "d" and "outer" or "inner"
      require("various-textobjs").subword(scope)
    end,
    mode = "o",
    desc = "󰬞 subword",
  },

		-- stylua: ignore start
		{ "iv", "<cmd>lua require('various-textobjs').value('inner')<CR>", mode = {"x","o"}, desc = " inner value" },
		{ "av", "<cmd>lua require('various-textobjs').value('outer')<CR>", mode = {"x","o"}, desc = " outer value" },
		{ "ak", "<cmd>lua require('various-textobjs').key('outer')<CR>", mode = {"x","o"}, desc = "󰌆 outer key" },
		{ "ik", "<cmd>lua require('various-textobjs').key('inner')<CR>", mode = {"x","o"}, desc = "󰌆 inner key" },

		{ "gg", "<cmd>lua require('various-textobjs').entireBuffer()<CR>", mode = {"x","o"}, desc = " entire buffer" },

		{ "n", "<cmd>lua require('various-textobjs').nearEoL()<CR>", mode = "o", desc = "󰑀 near EoL" },
		{ "b", "<cmd>lua require('various-textobjs').toNextClosingBracket()<CR>", mode = "o", desc = "⦈ to closing bracket" },
		{ "w", "<cmd>lua require('various-textobjs').toNextQuotationMark()<CR>", mode = "o", desc = " to next quote" },
		{ "k", "<cmd>lua require('various-textobjs').anyQuote('inner')<CR>", mode = "o", desc = " inner-quote (any)" },
		{ "K", "<cmd>lua require('various-textobjs').anyQuote('outer')<CR>", mode = "o", desc = " outer-quote (any)" },

		-- not setting these in visual mode, to keep visual block mode replace
		{ "rp", "<cmd>lua require('various-textobjs').restOfParagraph()<CR>", mode = "o", desc = "¶ rest of paragraph" },
		{ "ri", "<cmd>lua require('various-textobjs').restOfIndentation()<CR>", mode = "o", desc = "󰉶 rest of indentation" },
		{ "rg", "G", mode = "o", desc = " rest of buffer" },

		{ "ge", "<cmd>lua require('various-textobjs').diagnostic()<CR>", mode = {"x","o"}, desc = " diagnostic" },
		{ "L", "<cmd>lua require('various-textobjs').url()<CR>", mode = "o", desc = " URL" },
		{ "C", "<cmd>lua require('various-textobjs').column()<CR>", mode = {"x","o"}, desc = "ﴳ column" },
		{ "#", "<cmd>lua require('various-textobjs').cssColor('outer')<CR>", mode = {"x","o"}, desc = " outer color" },

		{ "in", "<cmd>lua require('various-textobjs').number('inner')<CR>", mode = {"x","o"}, desc = " inner number" },
		{ "an", "<cmd>lua require('various-textobjs').number('outer')<CR>", mode = {"x","o"}, desc = " outer number" },

		{ "ii", "<cmd>lua require('various-textobjs').indentation('inner', 'inner')<CR>", mode = {"x","o"}, desc = "󰉶 inner indent" },
		{ "ai", "<cmd>lua require('various-textobjs').indentation('outer', 'outer')<CR>", mode = {"x","o"}, desc = "󰉶 outer indent" },
		{ "aj", "<cmd>lua require('various-textobjs').indentation('outer', 'inner')<CR>", mode = {"x","o"}, desc = "󰉶 top-border indent" },
		{ "ig", "<cmd>lua require('various-textobjs').greedyOuterIndentation('inner')<CR>", mode = {"x","o"}, desc = "󰉶 inner greedy indent" },
		{ "ag", "<cmd>lua require('various-textobjs').greedyOuterIndentation('outer')<CR>", mode = {"x","o"}, desc = "󰉶 outer greedy indent" },

		{ "i.", "<cmd>lua require('various-textobjs').chainMember('inner')<CR>", mode = {"x","o"}, desc = "󰌷 inner chainMember" },
		{ "a.", "<cmd>lua require('various-textobjs').chainMember('outer')<CR>", mode = {"x","o"}, desc = "󰌷 outer chainMember" },
		{ "i" .. textObj.wikilink, "<cmd>lua require('various-textobjs').doubleSquareBrackets('inner')<CR>", mode = {"x","o"}, desc = "󰖬 inner wikilink" },
		{ "a" .. textObj.wikilink, "<cmd>lua require('various-textobjs').doubleSquareBrackets('outer')<CR>", mode = {"x","o"}, desc = "󰖬 outer wikilink" },

		-- python
		{ "iS", "<cmd>lua require('various-textobjs').pyTripleQuotes('inner')<CR>", ft = "python", mode = {"x","o"}, desc = " inner tripleQuotes" },
		{ "aS", "<cmd>lua require('various-textobjs').pyTripleQuotes('outer')<CR>", ft = "python", mode = {"x","o"}, desc = " outer tripleQuotes" },

		-- markdown
		{ "iE", "<cmd>lua require('various-textobjs').mdFencedCodeBlock('inner')<CR>", mode = {"x","o"}, ft = "markdown", desc = " inner CodeBlock" },
		{ "aE", "<cmd>lua require('various-textobjs').mdFencedCodeBlock('outer')<CR>", mode = {"x","o"}, ft = "markdown", desc = " outer CodeBlock" },
		{ "il", "<cmd>lua require('various-textobjs').mdLink('inner')<CR>", mode = {"x","o"}, ft = "markdown", desc = " inner md-link" },
		{ "al", "<cmd>lua require('various-textobjs').mdLink('outer')<CR>", mode = {"x","o"}, ft = "markdown", desc = " outer md-link" },

		-- css
		{ "is", "<cmd>lua require('various-textobjs').cssSelector('inner')<CR>", mode = {"x","o"}, ft = "css", desc = " inner selector" },
		{ "as", "<cmd>lua require('various-textobjs').cssSelector('outer')<CR>", mode = {"x","o"}, ft = "css", desc = " outer selector" },

		-- shell
		{ "ix", "<cmd>lua require('various-textobjs').shellPipe('inner')<CR>", mode = "o", ft = {"bash", "zsh"}, desc = "󰟥 inner pipe" },
		{ "ax", "<cmd>lua require('various-textobjs').shellPipe('outer')<CR>", mode = "o", ft = {"bash", "zsh"}, desc = "󰟥 outer pipe" },
  -- stylua: ignore end

  { -- indent last paste
    "^",
    function()
      require("various-textobjs").lastChange()
      local changeFound = vim.fn.mode() == "v"
      if changeFound then
        vim.cmd.normal({ ">", bang = true })
      end
    end,
    desc = "󰉶 Indent last paste",
  },
  { -- dedent last paste (if showing up falsely in whichkey, disable `maplocalleader`)
    "\\", -- shift-^ on my keyboard
    function()
      require("various-textobjs").lastChange()
      local changeFound = vim.fn.mode() == "v"
      if changeFound then
        vim.cmd.normal({ "<", bang = true })
      end
    end,
    desc = "󰉵 Dedent last paste",
  },
  { -- delete surrounding indentation
    "dsi",
    function()
      local cursorBefore = vim.api.nvim_win_get_cursor(0)

      require("various-textobjs").indentation("outer", "outer")
      local indentationFound = vim.fn.mode() == "V"
      if not indentationFound then
        return
      end

      vim.cmd.normal({ "<", bang = true }) -- dedent indentation
      local endBorderLn = vim.api.nvim_buf_get_mark(0, ">")[1]
      local startBorderLn = vim.api.nvim_buf_get_mark(0, "<")[1]
      vim.cmd(endBorderLn .. " delete") -- delete end first so line index is not shifted
      vim.cmd(startBorderLn .. " delete")

      -- defer to due race condition with sticky deletion
      vim.defer_fn(function()
        vim.api.nvim_win_set_cursor(0, cursorBefore)
      end, 1)
    end,
    desc = " Delete surrounding indent",
  },
  { -- yank surrounding inner indentation
    "ysii", -- `ysi` would conflict with `ysib` and other textobs
    function()
      -- identify start- and end-border
      local startPos = vim.api.nvim_win_get_cursor(0)
      require("various-textobjs").indentation("outer", "outer")
      local indentationFound = vim.fn.mode() == "V"
      if not indentationFound then
        return
      end
      vim.cmd.normal({ "V", bang = true }) -- leave visual mode so <> marks are set
      vim.api.nvim_win_set_cursor(0, startPos) -- restore (= sticky yank)

      -- copy them into the `+` register
      local startLn = vim.api.nvim_buf_get_mark(0, "<")[1] - 1
      local endLn = vim.api.nvim_buf_get_mark(0, ">")[1] - 1
      local startLine = vim.api.nvim_buf_get_lines(0, startLn, startLn + 1, false)[1]
      local endLine = vim.api.nvim_buf_get_lines(0, endLn, endLn + 1, false)[1]
      vim.fn.setreg("+", startLine .. "\n" .. endLine .. "\n")

      -- highlight yanked text
      local duration = 1000
      local ns = vim.api.nvim_create_namespace("ysii")
      vim.api.nvim_buf_add_highlight(0, ns, "IncSearch", startLn, 0, -1)
      vim.api.nvim_buf_add_highlight(0, ns, "IncSearch", endLn, 0, -1)
      vim.defer_fn(function()
        vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
      end, duration)
    end,
    desc = "󰅍 Yank surrounding indent",
  },
  { -- open URL (forward seeking)
    "gx",
    function()
      local cursorBefore = vim.api.nvim_win_get_cursor(0)

      require("various-textobjs").url()
      local foundURL = vim.fn.mode() == "v"
      if not foundURL then
        return
      end

      vim.cmd.normal({ '"zy', bang = true })
      local url = vim.fn.getreg("z")
      vim.ui.open(url)
      vim.api.nvim_win_set_cursor(0, cursorBefore)
    end,
    desc = " Open next URL",
  },
  { -- to next `then` in lua
    "N",
    mode = "o",
    function()
      local charwise = require("various-textobjs.textobjs.charwise.core")
      local pattern = "().( then)"
      local row, _, endCol = charwise.getTextobjPos(pattern, "inner", 5)
      charwise.selectFromCursorTo({ row, endCol }, 5)
    end,
    ft = "lua",
    desc = "󰬞 to next `then`",
  },
  { -- path textobj
    "a-",
    mode = "o",
    function()
      local charwise = require("various-textobjs.textobjs.charwise.core")
      local pattern = {
        twoSlashes = "(%.?/[%w_%-./]+/)[%w_%-.]+[%d:]*()",
        oneSlashRelPath = "(%./)[%w_%-.]+()",
      }
      charwise.selectClosestTextobj(pattern, "outer", 5)
    end,
    desc = " outer path",
  },
  {
    "i-",
    mode = "o",
    function()
      local charwise = require("various-textobjs.textobjs.charwise.core")
      local pattern = {
        twoSlashes = "(%.?/[%w_%-./]+/)[%w_%-.]+[%d:]*()",
        oneSlashRelPath = "(%./)[%w_%-.]+()",
      }
      charwise.selectClosestTextobj(pattern, "inner", 5)
    end,
    desc = " inner path",
  },
}

local extraTextobjMaps = {
  func = "f",
  call = "l",
  condition = "o",
  wikilink = "R",
}

local treesitter_obj = { -- treesitter-based textobjs

  "nvim-treesitter/nvim-treesitter-textobjects",
  dependencies = "nvim-treesitter/nvim-treesitter",
	-- stylua: ignore
	cmd = { "TSTextobjectSelect", "TSTextobjectSwapNext", "TSTextobjectSwapPrevious", "TSTextobjectGotoNextStart", "TSTextobjectGotoPreviousStart" },
  -- SIC yes, configured via treesitter, not this plugin. Also, calling
  -- treesitter's `setup` a second time is apparently not a problem.
  main = "nvim-treesitter.configs",
  opts = {
    textobjects = {
      select = {
        lookahead = true,
        -- `true` would even remove line breaks from charwise objects,
        -- thus staying with `false`
        include_surrounding_whitespace = false,
      },
    },
  },
  keys = {
		-- MOVE
		-- stylua: ignore start
		{ "<C-j>", "<cmd>TSTextobjectGotoNextStart @function.outer<CR>", desc = " Goto next function" },
		{ "<C-k>", "<cmd>TSTextobjectGotoPreviousStart @function.outer<CR>", desc = " Goto prev function" },
		-- stylua: ignore end

		-- SWAP
		-- stylua: ignore start
		{ "ä", "<cmd>TSTextobjectSwapNext @parameter.inner<CR>", desc = " Swap next arg" },
		{ "Ä", "<cmd>TSTextobjectSwapPrevious @parameter.inner<CR>", desc = " Swap prev arg" },
		-- stylua: ignore end

		-- TEXT OBJECTS
		-- stylua: ignore start
		{ "a<CR>", "<cmd>TSTextobjectSelect @return.outer<CR>", mode = {"x","o"}, desc = "↩ outer return" },
		{ "i<CR>", "<cmd>TSTextobjectSelect @return.inner<CR>", mode = {"x","o"}, desc = "↩ inner return" },
		{ "a/", "<cmd>TSTextobjectSelect @regex.outer<CR>", mode = {"x","o"}, desc = " outer regex" },
		{ "i/", "<cmd>TSTextobjectSelect @regex.inner<CR>", mode = {"x","o"}, desc = " inner regex" },
		{ "aa", "<cmd>TSTextobjectSelect @parameter.outer<CR>", mode = {"x","o"}, desc = "󰏪 outer arg" },
		{ "ia", "<cmd>TSTextobjectSelect @parameter.inner<CR>", mode = {"x","o"}, desc = "󰏪 inner arg" },
		{ "iu", "<cmd>TSTextobjectSelect @loop.inner<CR>", mode = {"x","o"}, desc = "󰛤 inner loop" },
		{ "au", "<cmd>TSTextobjectSelect @loop.outer<CR>", mode = {"x","o"}, desc = "󰛤 outer loop" },
		{ "a" .. textObj.func, "<cmd>TSTextobjectSelect @function.outer<CR>", mode = {"x","o"},desc = " outer function" },
		{ "i" .. textObj.func, "<cmd>TSTextobjectSelect @function.inner<CR>", mode = {"x","o"},desc = " inner function" },
		{ "a" .. textObj.condition, "<cmd>TSTextobjectSelect @conditional.outer<CR>", mode = {"x","o"},desc = "󱕆 outer c[o]ndition" },
		{ "i" .. textObj.condition, "<cmd>TSTextobjectSelect @conditional.inner<CR>", mode = {"x","o"},desc = "󱕆 inner c[o]ndition" },
		{ "a" .. textObj.call, "<cmd>TSTextobjectSelect @call.outer<CR>", mode = {"x","o"},desc = "󰡱 outer ca[l]l" },
		{ "i" .. textObj.call, "<cmd>TSTextobjectSelect @call.inner<CR>", mode = {"x","o"},desc = "󰡱 inner ca[l]l" },

		-- CUSTOM TEXTOBJECTS
		{"g" .. textObj.call, "<cmd>TSTextobjectSelect @call.caller<CR>", mode = "o", desc = "󰡱 ca[l]ler" },
		-- stylua: ignore end

		-- COMMENTS

		-- only operator-pending to not conflict with selection-commenting
		-- stylua: ignore
		{ "q", "<cmd>TSTextobjectSelect @comment.outer<CR>", mode = "o", desc = "󰆈 single comment" },
    {
      "dq",
      function()
        local cursorBefore = vim.api.nvim_win_get_cursor(0)
        vim.cmd.TSTextobjectSelect("@comment.outer")
        vim.cmd.normal({ "d", bang = true })
        local trimmedLine = vim.api.nvim_get_current_line():gsub("%s+$", "")
        vim.api.nvim_set_current_line(trimmedLine)
        vim.api.nvim_win_set_cursor(0, cursorBefore)
      end,
      desc = "󰆈 Sticky delete comment",
    },
  },
}
local surrounds = {
  invalid_key_behavior = { add = false, find = false, delete = false, change = false },
  [extraTextobjMaps.call] = {
    find = "[%w.:_]+%b()", -- includes `:` for lua-methods/css-pseudoclasses
    delete = "([%w.:_]+%()().*(%))()",
  },
  [extraTextobjMaps.func] = { -- only one-line lua functions
    find = "function ?[%w_]* ?%b().- end",
    delete = "(function ?[%w_]* ?%b() ?)().-( end)()",
  },
  [extraTextobjMaps.condition] = { -- only one-line lua conditionals
    find = "if .- then .- end",
    delete = "(if .- then )().-( end)()",
  },
  [extraTextobjMaps.wikilink] = {
    find = "%[%[.-%]%]",
    add = { "[[", "]]" },
    delete = "(%[%[)().-(%]%])()",
    change = { target = "(%[%[)().-(%]%])()" },
  },
}

local spec = {
  { -- leader subgroups
    mode = { "n", "x" },
    { "<leader>", group = "󰓎 Leader" },
    { "<leader>c", group = " Code action" },
    { "<leader>e", group = "󰓗 Execute" },
    { "<leader>r", group = "󱗘 Refactor" },
    { "<leader>g", group = "󰊢 Git" },
    { "<leader>i", group = "󱈄 Inspect" },
    { "<leader>o", group = "󰒓 Option toggle" },
    { "<leader>p", group = "󰏗 Packages" },
    { "<leader>q", group = " Quickfix" },
    { "<leader>u", group = "󰕌 Undo" },
  },
  { -- not using `text_objects` preset, since it's too crowded
    mode = { "o", "x" },
    { "r", group = "rest of" },
    { "i", group = "inner" },
    { "a", group = "outer" },
    { "g", group = "misc" },
    { "ip", desc = "¶ paragraph" },
    { "ap", desc = "¶ paragraph" },
    { "ib", desc = "󰅲 bracket" },
    { "ab", desc = "󰅲 bracket" },
    { "it", desc = " tag" },
    { "at", desc = " tag" },
    { "is", desc = "󰰢 sentence" },
    { "as", desc = "󰰢 sentence" },
    { "iw", desc = "󰬞 word" },
    { "aw", desc = "󰬞 word" },
    { "gn", desc = " search result" },
  },
  { -- base groups
    mode = { "n", "x" },
    { "g", group = "Goto" },
    { "z", group = "Fold & spelling" },
  },
}
