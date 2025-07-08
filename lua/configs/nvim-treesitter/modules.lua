-- https://github.com/XXiaoA/ns-textobject.nvim

local modules = {
  indent = {
    enable = true,
    disable = {
      "markdown", -- indentation at bullet points is worse
      "javascript", -- some wrong indentation when using `o`
      "typescript",
      "yaml", -- wrong indentation in list continuation
    },
  },
  query_linter = {
    enable = true,
    use_virtual_text = true,
    lint_events = { "BufWrite", "CursorHold" },
  },
  playground = {
    enable = true,
    disable = {
      -- "wgsl",
      -- "wgsl_bevy",
    },
    updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
    persist_queries = true, -- Whether the query persists across vim sessions
    keybindings = {
      toggle_query_editor = "o",
      toggle_hl_groups = "i",
      toggle_injected_languages = "t",
      toggle_anonymous_nodes = "a",
      toggle_language_display = "I",
      focus_language = "f",
      unfocus_language = "F",
      update = "R",
      goto_node = "<cr>",
      show_help = "?",
    },
  },
  autotag = {
    enable = true,
    enable_rename = true,
    enable_close = true,
    enable_close_on_slash = true,
    filetypes = {
      "html",
      "javascript",
      "javascriptreact",
      "jsx",
      "markdown",
      "php",
      "rescript",
      "svelte",
      "tsx",
      "typescript",
      "typescriptreact",
      "vue",
      "xml",
    },
    skip_tags = {
      "area",
      "base",
      "br",
      "col",
      "command",
      "embed",
      "hr",
      "img",
      "input",
      "keygen",
      "link",
      "menuitem",
      "meta",
      "param",
      "slot",
      "source",
      "track",
      "wbr",
    },
  },
  refactor = {
    smart_rename = {
      enable = true,
      keymaps = {
        smart_rename = "grn",
      },
    }, -- grr default
    -- highlight_definitions = { enable = true },
    highlight_current_scope = { enable = true },
    navigation = {
      enable = true,
      keymaps = {
        list_definitions_toc = "gt0", -- gn0
        goto_definition = false,
        list_definitions = false,
        goto_next_usage = false,
        goto_previous_usage = false,
        -- goto_definition = 'gtd',  -- gnd
        -- list_definitions = 'gtD', -- gnD
        -- goto_next_usage = '<a-*>',
        -- goto_previous_usage = '<a-#>',
      },
    },
  },
  highlight = {
    enable = true,
    use_languagetree = true,
    disable = {
      -- "zsh",
      "tmux",
      "css", -- PENDING https://github.com/tree-sitter/tree-sitter-css/issues/34
    },
    additional_vim_regex_highlighting = {
      -- 'md',
      "javascript",
      -- "bash",
      -- 'help',
      "make",
      -- "zsh",
    },
    custom_captures = {
      -- Highlight the @foo.bar capture group with the "Identifier" highlight group.
      ["foo.bar"] = "Identifier",
    },
  },
  incremental_custom = {
    enable = true,
    disable = { "markdown" },
    keymaps = {
      -- <Tab>/<S-Tab>  v/V  + -
      -- init_selection = "v",
      init_selection = "<C-n>",
      scope_incremental = "<M-n>",
      node_incremental = "<C-n>",
      node_decremental = "<C-p>",
    },
  },
  textsubjects = {
    -- https://github.com/RRethy/nvim-treesitter-textsubjects
    enable = false,
  },
  pairs = {
    enable = false,
    disable = {},
    -- -- highlight_pair_events = { "CursorMoved" }, -- e.g. {"CursorMoved"}, -- when to highlight the pairs, use {} to deactivate highlighting
    -- highlight_self = true, -- whether to highlight also the part of the pair under cursor (or only the partner)
    -- goto_right_end = false, -- whether to go to the end of the right partner or the beginning
    -- fallback_cmd_normal = "silent! call matchit#Match_wrapper('',1,'n')", -- What command to issue when we can't find a pair (e.g. "normal! %")
    -- -- "call matchup#util#patch_match_words",
    -- keymaps = {
    --   -- goto_partner = "<leader>%",
    --   goto_partner = false,
    --   delete_balanced = false,
    -- },
    -- delete_balanced = {
    --   only_on_first_char = false, -- whether to trigger balanced delete when on first character of a pair
    --   fallback_cmd_normal = nil, -- fallback command when no pair found, can be nil
    --   longest_partner = false, -- whether to delete the longest or the shortest pair when multiple found.
    --   -- E.g. whether to delete the angle bracket or whole tag in  <pair> </pair>
    -- },
  },
  rainbow = {
    enable = false,
    -- `html` - `rainbow-tags` Matches both opening and closing tags in their entirety
    --`javascript`
    --   - `rainbow-parens-react` Supports the angle brackets of React.js tags
    --   - `rainbow-tags-react`   Alternative to the above, highlights entire tags
    -- latex` - `rainbow-blocks` Matches `\begin` and `\end` instructions
    --`tsx` - `rainbow-tags` Matches entire tags, like the same query in HTML
    hlgroups = {
      "TSRainbowRed",
      "TSRainbowYellow",
      "TSRainbowBlue",
      "TSRainbowOrange",
      "TSRainbowGreen",
      "TSRainbowViolet",
      "TSRainbowCyan",
    },
    -- disable = { "jsx", "cpp" },
    query = { "rainbow-parens", html = "rainbow-tags", latex = "rainbow-blocks" },
    strategy = require("ts-rainbow").strategy["local"],
    -- strategy = require("ts-rainbow").strategy.global,
    max_file_lines = 3000,
  },
  textobjects = {
    -- mini-ai takes care of this
    select = {
      disable = { "markdown" }, -- so `al` can be remapped to link text object
      lookahead = true,
      enable = true,
      -- You can choose the select mode (default is charwise 'v')
      selection_modes = {
        ["@parameter.outer"] = "v", -- charwise
        ["@function.outer"] = "V", -- linewise
        ["@class.outer"] = "<c-v>", -- blockwise
      },
      keymaps = {
        -- / comment.outer
        --   number.inner
        --   assignment.inner  assignment.outer
        --   assignment.lhs    assignment.rhs
        -- B block.inner       block.outer
        --   call.inner        call.outer
        --   conditional.inner conditional.outer
        -- f function.inner    function.outer
        -- L loop.inner        loop.outer
        -- a parameter.inner   parameter.outer
        --   return.inner      return.outer
        -- ["/"] = "@comment.outer",
        -- ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
        -- ["as"] = "@statement.outer",
        -- ["is"] = "@scopename.inner",
        -- ["aF"] = "@frame.outer",
        -- ["iF"] = "@frame.inner",
      },
    },
    swap = {
      enable = true,
      swap_next = {
        [">;"] = "@parameter.inner",
        [">a"] = "@parameter.inner",
      },
      swap_previous = {
        ["<;"] = "@parameter.inner",
        ["<a"] = "@parameter.inner",
      },
    },
    move = {
      enable = true,
      set_jumps = true,
      goto_next_start = {
        ["]f"] = "@function.outer",
        ["]c"] = "@class.outer",
        ["]["] = "@block.outer",
      },
      goto_next_end = {
        ["]F"] = "@function.outer",
        ["]C"] = "@class.outer",
        ["]]"] = "@block.outer",
      },
      goto_previous_start = {
        ["[f"] = "@function.outer",
        ["[c"] = "@class.outer",
        ["[["] = "@block.outer",
      },
      goto_previous_end = {
        ["[F"] = "@function.outer",
        ["[C"] = "@class.outer",
        ["[]"] = "@block.outer",
      },
    },

    lsp_interop = {
      enable = true,
      border = "none",
      peek_definition_code = {
        -- ["<leader>df"] = "@function.outer",
        -- ["<leader>dF"] = "@class.outer",
        ["gPf"] = "@function.outer",
        ["gPc"] = "@class.outer",
      },
    },
  },
  matchup = {
    -- vim-matchup integration with treesitter-pairs
    enable = false, -- mandatory, false will disable the whole extension
    -- disable = {"c", "ruby"} -- optional, list of language that will be disabled
    disable_virtual_text = true,
  },
  endwise = {
    enable = true,
  },
}

return modules

--[[ keys = {
  {
    '<leader>H',
    function()
      vim.cmd.TSTextobjectPeekDefinitionCode('@function.outer')
    end,
    desc = ' Hover Peek Function',
  },
  {
    'q',
    function()
      vim.cmd.TSTextobjectSelect('@comment.outer')
    end,
    mode = 'o', -- only operator-pending to not conflict with commenting selection
    desc = '󱡔  single comment textobj',
  },
  {
    'dq',
    function()
      local cursor = vim.api.nvim_win_get_cursor(0)
      vim.cmd.TSTextobjectSelect('@comment.outer')
      -- u.normal('d')
      vim.api.nvim_win_set_cursor(0, cursor)
    end,
    desc = ' Sticky Delete Comment',
  },
  {
    'cq',
    function()
      vim.cmd.TSTextobjectSelect('@comment.outer')
      -- u.normal('d')
      local comStr = vim.bo.commentstring:format('')
      local line = vim.api.nvim_get_current_line():gsub('%s+$', '')
      vim.api.nvim_set_current_line(line .. ' ' .. comStr)
      vim.cmd.startinsert({ bang = true })
    end,
    desc = ' Change Comment',
  },
  {
    '<C-j>',
    '<cmd>TSTextobjectGotoNextStart @function.outer<CR>zv',
    desc = ' Goto Next Function',
  },
  {
    '<C-k>',
    '<cmd>TSTextobjectGotoPreviousStart @function.outer<CR>zv',
    desc = ' Goto Previous Function',
  },
  ['aC'] = { query = '@conditional.outer', desc = 'ts: all conditional' },
  ['iC'] = { query = '@conditional.inner', desc = 'ts: inner conditional' },
  -- You can use the capture groups defined in textobjects.scm
  ['a='] = { query = '@assignment.outer', desc = 'Select outer part of an assignment' },
  ['i='] = { query = '@assignment.inner', desc = 'Select inner part of an assignment' },
  ['l='] = { query = '@assignment.lhs', desc = 'Select left hand side of an assignment' },
  ['r='] = { query = '@assignment.rhs', desc = 'Select right hand side of an assignment' },

  ['aa'] = {
    query = '@parameter.outer',
    desc = 'Select outer part of a parameter/argument',
  },
  ['ia'] = {
    query = '@parameter.inner',
    desc = 'Select inner part of a parameter/argument',
  },

  ['ai'] = { query = '@conditional.outer', desc = 'Select outer part of a conditional' },
  ['ii'] = { query = '@conditional.inner', desc = 'Select inner part of a conditional' },

  ['al'] = { query = '@loop.outer', desc = 'Select outer part of a loop' },
  ['il'] = { query = '@loop.inner', desc = 'Select inner part of a loop' },

  ['af'] = { query = '@call.outer', desc = 'Select outer part of a function call' },
  ['if'] = { query = '@call.inner', desc = 'Select inner part of a function call' },

  ['am'] = {
    query = '@function.outer',
    desc = 'Select outer part of a method/function definition',
  },
  ['im'] = {
    query = '@function.inner',
    desc = 'Select inner part of a method/function definition',
  },

  ['ac'] = { query = '@class.outer', desc = 'Select outer part of a class' },
  ['ic'] = { query = '@class.inner', desc = 'Select inner part of a class' },
  -- 			},

--[[ INFO: outer key textobj defined via various textobjs
 ["ik"] = { query = "@assignment.lhs", desc = "󱡔 inner key textobj" },
 ["a<CR>"] = { query = "@return.outer", desc = "󱡔 outer return textobj" },
 ["i<CR>"] = { query = "@return.inner", desc = "󱡔 inner return textobj" },
 ["a/"] = { query = "@regex.outer", desc = "󱡔 outer regex textobj" },
 ["i/"] = { query = "@regex.inner", desc = "󱡔 inner regex textobj" },
 ["aa"] = { query = "@parameter.outer", desc = "󱡔 outer parameter textobj" },
 ["ia"] = { query = "@parameter.inner", desc = "󱡔 inner parameter textobj" },

 -- stylua: ignore start
 ["iu"] = { query = "@loop.inner", desc = "󱡔 inner loop textobj" }, -- mnemonic: luup
 ["au"] = { query = "@loop.outer", desc = "󱡔 outer loop textobj" },
 ["a" .. textobjMaps.func] = { query = "@function.outer", desc = "󱡔 outer function textobj" },
 ["i" .. textobjMaps.func] = { query = "@function.inner", desc = "󱡔 inner function textobj" },
 ["a" .. textobjMaps.cond] = { query = "@conditional.outer", desc = "󱡔 outer cond. textobj" },
 ["i" .. textobjMaps.cond] = { query = "@conditional.inner", desc = "󱡔 inner cond. textobj" },
 ["a" .. textobjMaps.call] = { query = "@call.outer", desc = "󱡔 outer call textobj" },
 ["i" .. textobjMaps.call] = { query = "@call.inner", desc = "󱡔 inner call textobj" },
 -- stylua: ignore end

 -- INFO later remapped to q only in operator pending mode to avoid conflict
 -- @comment.inner not supported yet for most languages
 ["&&&"] = { query = "@comment.outer", desc = "which_key_ignore" }, ]]
