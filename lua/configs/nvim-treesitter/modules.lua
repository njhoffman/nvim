local modules = {
  query_linter = {
    enable = true,
    use_virtual_text = true,
    lint_events = { 'BufWrite', 'CursorHold' },
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
      toggle_query_editor = 'o',
      toggle_hl_groups = 'i',
      toggle_injected_languages = 't',
      toggle_anonymous_nodes = 'a',
      toggle_language_display = 'I',
      focus_language = 'f',
      unfocus_language = 'F',
      update = 'R',
      goto_node = '<cr>',
      show_help = '?',
    },
  },
  autotag = {
    enable = true,
    enable_rename = true,
    enable_close = true,
    enable_close_on_slash = true,
    filetypes = {
      'html',
      'javascript',
      'typescript',
      'javascriptreact',
      'typescriptreact',
      'svelte',
      'vue',
      'tsx',
      'jsx',
      'rescript',
      'xml',
      'php',
      'markdown',
    },
    skip_tags = {
      'area',
      'base',
      'br',
      'col',
      'command',
      'embed',
      'hr',
      'img',
      'slot',
      'input',
      'keygen',
      'link',
      'meta',
      'param',
      'source',
      'track',
      'wbr',
      'menuitem',
    },
  },
  refactor = {
    smart_rename = { enable = true, keymaps = { smart_rename = 'gR' } }, -- grr default
    -- highlight_definitions = { enable = true },
    highlight_current_scope = { enable = false },
    navigation = {
      enable = true,
      keymaps = {
        list_definitions_toc = 'gt0', -- gn0
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
      'css', -- PENDING https://github.com/tree-sitter/tree-sitter-css/issues/34
    },
    additional_vim_regex_highlighting = {
      -- 'md',
      'bash',
      'help',
      'make',
      'zsh',
    },
    custom_captures = {
      -- Highlight the @foo.bar capture group with the "Identifier" highlight group.
      ['foo.bar'] = 'Identifier',
    },
  },
  incremental_custom = {
    enable = true,
    disable = { 'markdown' },
    keymaps = {
      init_selection = 'vv',
      node_incremental = 'v',
      scope_incremental = false,
      node_decremental = 'V',
    },
  },
  textsubjects = {
    enable = true,
    prev_selection = '<BS>', -- (Optional) keymap to select the previous selection
    keymaps = {
      ['<cr>'] = 'textsubjects-smart',
      -- ['.'] = 'textsubjects-smart',
      ['<C-CR>'] = 'textsubjects-container-outer',
      ['<S-CR>'] = { 'textsubjects-container-inner', desc = 'Select inside containers (classes, functions, etc.)' },
    },
  },
  pairs = {
    enable = false,
    disable = {},
    -- highlight_pair_events = { "CursorMoved" }, -- e.g. {"CursorMoved"}, -- when to highlight the pairs, use {} to deactivate highlighting
    highlight_self = true, -- whether to highlight also the part of the pair under cursor (or only the partner)
    goto_right_end = false, -- whether to go to the end of the right partner or the beginning
    fallback_cmd_normal = "silent! call matchit#Match_wrapper('',1,'n')", -- What command to issue when we can't find a pair (e.g. "normal! %")
    -- "call matchup#util#patch_match_words",
    keymaps = {
      -- goto_partner = "<leader>%",
      goto_partner = false,
      delete_balanced = false,
    },
    delete_balanced = {
      only_on_first_char = false, -- whether to trigger balanced delete when on first character of a pair
      fallback_cmd_normal = nil, -- fallback command when no pair found, can be nil
      longest_partner = false, -- whether to delete the longest or the shortest pair when multiple found.
      -- E.g. whether to delete the angle bracket or whole tag in  <pair> </pair>
    },
  },
  rainbow = {

    -- `html` - `rainbow-tags` Matches both opening and closing tags in their entirety
    --`javascript`
    --   - `rainbow-parens-react` Supports the angle brackets of React.js tags
    --   - `rainbow-tags-react`   Alternative to the above, highlights entire tags
    -- latex` - `rainbow-blocks` Matches `\begin` and `\end` instructions
    --`tsx` - `rainbow-tags` Matches entire tags, like the same query in HTML
    hlgroups = {
      'TSRainbowRed',
      'TSRainbowYellow',
      'TSRainbowBlue',
      'TSRainbowOrange',
      'TSRainbowGreen',
      'TSRainbowViolet',
      'TSRainbowCyan',
    },
    enable = false,
    -- disable = { "jsx", "cpp" },
    query = { 'rainbow-parens', html = 'rainbow-tags', latex = 'rainbow-blocks' },
    strategy = require('ts-rainbow').strategy['local'],
    -- strategy = require("ts-rainbow").strategy.global,
    max_file_lines = 3000,
  },
  textobjects = {
    -- mini-ai takes care of this
    select = {
      disable = { 'markdown' }, -- so `al` can be remapped to link text object
      lookahead = true,
      enable = false,
      keymaps = {
        -- ['aa'] = '@parameter.outer',
        -- ['ia'] = '@parameter.inner',
        -- ['af'] = '@function.outer',
        -- ['if'] = '@function.inner',
        -- ['ac'] = '@class.outer',
        -- ["at"] = "@class.outer",
        -- ['ic'] = '@class.inner',
        -- ["it"] = "@class.inner",
        -- ['a/'] = '@comment.outer',
        -- ['i/'] = '@comment.inner',
        -- ['ab'] = '@block.outer',
        -- ['ib'] = '@block.inner',
        -- ["ac"] = "@call.outer",
        -- ["ic"] = "@call.inner",
        -- ["al"] = "@loop.outer",
        -- ["il"] = "@loop.inner",
        -- ["ai"] = "@conditional.outer",
        -- ["ii"] = "@conditional.inner",
        -- ["as"] = "@statement.outer",
        -- ["is"] = "@scopename.inner",
        -- ["aA"] = "@attribute.outer",
        -- ["iA"] = "@attribute.inner",
        -- ["aF"] = "@frame.outer",
        -- ["iF"] = "@frame.inner",
        -- INFO: outer key textobj defined via various textobjs
        -- ["ik"] = { query = "@assignment.lhs", desc = "󱡔 inner key textobj" },
        -- ["a<CR>"] = { query = "@return.outer", desc = "󱡔 outer return textobj" },
        -- ["i<CR>"] = { query = "@return.inner", desc = "󱡔 inner return textobj" },
        -- ["a/"] = { query = "@regex.outer", desc = "󱡔 outer regex textobj" },
        -- ["i/"] = { query = "@regex.inner", desc = "󱡔 inner regex textobj" },
        -- ["aa"] = { query = "@parameter.outer", desc = "󱡔 outer parameter textobj" },
        -- ["ia"] = { query = "@parameter.inner", desc = "󱡔 inner parameter textobj" },
        --
        -- -- stylua: ignore start
        -- ["iu"] = { query = "@loop.inner", desc = "󱡔 inner loop textobj" }, -- mnemonic: luup
        -- ["au"] = { query = "@loop.outer", desc = "󱡔 outer loop textobj" },
        -- ["a" .. textobjMaps.func] = { query = "@function.outer", desc = "󱡔 outer function textobj" },
        -- ["i" .. textobjMaps.func] = { query = "@function.inner", desc = "󱡔 inner function textobj" },
        -- ["a" .. textobjMaps.cond] = { query = "@conditional.outer", desc = "󱡔 outer cond. textobj" },
        -- ["i" .. textobjMaps.cond] = { query = "@conditional.inner", desc = "󱡔 inner cond. textobj" },
        -- ["a" .. textobjMaps.call] = { query = "@call.outer", desc = "󱡔 outer call textobj" },
        -- ["i" .. textobjMaps.call] = { query = "@call.inner", desc = "󱡔 inner call textobj" },
        -- -- stylua: ignore end
        --
        -- -- INFO later remapped to q only in operator pending mode to avoid conflict
        -- -- @comment.inner not supported yet for most languages
        -- ["&&&"] = { query = "@comment.outer", desc = "which_key_ignore" },
      },
    },
    swap = {
      enable = true,
      swap_next = { ['<leader>xa'] = '@parameter.inner' },
      swap_previous = { ['<leader>xA'] = '@parameter.inner' },
    },
    move = {
      enable = true,
      set_jumps = true,
      goto_next_start = { [']f'] = '@function.outer', [']c'] = '@class.outer' },
      goto_next_end = { [']F'] = '@function.outer', [']C'] = '@class.outer' },
      goto_previous_start = { ['[f'] = '@function.outer', ['[c'] = '@class.outer' },
      goto_previous_end = { ['[F'] = '@function.outer', ['[C'] = '@class.outer' },
    },
    -- select = {
    -- 			enable = true,
    --
    -- 			-- Automatically jump forward to textobj, similar to targets.vim
    -- 			lookahead = true,
    -- 			keymaps = {
    -- 				-- You can use the capture groups defined in textobjects.scm
    -- 				["a="] = { query = "@assignment.outer", desc = "Select outer part of an assignment" },
    -- 				["i="] = { query = "@assignment.inner", desc = "Select inner part of an assignment" },
    -- 				["l="] = { query = "@assignment.lhs", desc = "Select left hand side of an assignment" },
    -- 				["r="] = { query = "@assignment.rhs", desc = "Select right hand side of an assignment" },
    --
    -- 				["aa"] = { query = "@parameter.outer", desc = "Select outer part of a parameter/argument" },
    -- 				["ia"] = { query = "@parameter.inner", desc = "Select inner part of a parameter/argument" },
    --
    -- 				["ai"] = { query = "@conditional.outer", desc = "Select outer part of a conditional" },
    -- 				["ii"] = { query = "@conditional.inner", desc = "Select inner part of a conditional" },
    --
    -- 				["al"] = { query = "@loop.outer", desc = "Select outer part of a loop" },
    -- 				["il"] = { query = "@loop.inner", desc = "Select inner part of a loop" },
    --
    -- 				["af"] = { query = "@call.outer", desc = "Select outer part of a function call" },
    -- 				["if"] = { query = "@call.inner", desc = "Select inner part of a function call" },
    --
    -- 				["am"] = { query = "@function.outer", desc = "Select outer part of a method/function definition" },
    -- 				["im"] = { query = "@function.inner", desc = "Select inner part of a method/function definition" },
    --
    -- 				["ac"] = { query = "@class.outer", desc = "Select outer part of a class" },
    -- 				["ic"] = { query = "@class.inner", desc = "Select inner part of a class" },
    -- 			},
    --
    -- 		},
    -- 		swap = {
    -- 			enable = true,
    -- 			swap_next = {
    -- 				["<leader>sna"] = "@parameter.inner", -- swap parameters/argument with next
    -- 				["<leader>snm"] = "@function.outer", -- swap function with next
    -- 			},
    -- 			swap_previous = {
    -- 				["<leader>spa"] = "@parameter.inner", -- swap parameters/argument with prev
    -- 				["<leader>spm"] = "@function.outer", -- swap function with previous
    -- 			},
    --
    -- 		},
    -- 		move = {
    -- 			enable = true,
    -- 			set_jumps = true, -- whether to set jumps in the jumplist
    -- 			goto_next_start = {
    -- 				["]f"] = { query = "@call.outer", desc = "Next function call start" },
    -- 				["]m"] = { query = "@function.outer", desc = "Next method/function def start" },
    -- 				["]c"] = { query = "@class.outer", desc = "Next class start" },
    -- 				["]i"] = { query = "@conditional.outer", desc = "Next conditional start" },
    -- 				["]l"] = { query = "@loop.outer", desc = "Next loop start" },
    -- 				["]p"] = { query = "@parameter.inner", desc = "Next parameter start" },
    --
    -- 				-- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
    -- 				-- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
    -- 				["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
    -- 				["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
    -- 			},
    -- 			goto_next_end = {
    -- 				["]F"] = { query = "@call.outer", desc = "Next function call end" },
    -- 				["]M"] = { query = "@function.outer", desc = "Next method/function def end" },
    -- 				["]C"] = { query = "@class.outer", desc = "Next class end" },
    -- 				["]I"] = { query = "@conditional.outer", desc = "Next conditional end" },
    -- 				["]L"] = { query = "@loop.outer", desc = "Next loop end" },
    -- 			},
    -- 			goto_previous_start = {
    -- 				["[f"] = { query = "@call.outer", desc = "Prev function call start" },
    -- 				["[m"] = { query = "@function.outer", desc = "Prev method/function def start" },
    -- 				["[c"] = { query = "@class.outer", desc = "Prev class start" },
    -- 				["[i"] = { query = "@conditional.outer", desc = "Prev conditional start" },
    -- 				["[l"] = { query = "@loop.outer", desc = "Prev loop start" },
    -- 				["[p"] = { query = "@parameter.inner", desc = "Prev parameter start" },
    -- 			},
    -- 			goto_previous_end = {
    -- 				["[F"] = { query = "@call.outer", desc = "Prev function call end" },
    -- 				["[M"] = { query = "@function.outer", desc = "Prev method/function def end" },
    -- 				["[C"] = { query = "@class.outer", desc = "Prev class end" },
    -- 				["[I"] = { query = "@conditional.outer", desc = "Prev conditional end" },
    -- 				["[L"] = { query = "@loop.outer", desc = "Prev loop end" },
    -- 			},
    -- 		},
    -- 	},
    lsp_interop = {
      enable = true,
      border = 'none',
      peek_definition_code = { ['gPf'] = '@function.outer', ['gPc'] = '@class.outer' },
    },
  },
  matchup = {
    -- integration with treesitter-pairs
    enable = true, -- mandatory, false will disable the whole extension
    -- disable = {"c", "ruby"} -- optional, list of language that will be disabled
    --[[ do not use virtual text to highlight the virtual end of a block, for languages without explicit end markers (e.g., Python). ]]
    -- disable_virtual_text = {},
    --[[ additionally include traditional vim regex matches for symbols.
    --For example, highlights /* */ comments in C++ which are not supported in tree-sitter matching. ]]
    -- include_match_words = {},
  },
  endwise = {
    enable = true,
  },
}

return modules
