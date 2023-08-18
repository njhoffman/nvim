local configs = require('nvim-treesitter.configs')

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
    filetypes = {
      'html',
      'javascript',
      'javascriptreact',
      'typescriptreact',
      'svelte',
      'vue',
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
    smart_rename = { enable = true, keymaps = { smart_rename = 'gR' } },
    highlight_definitions = { enable = true },
    highlight_current_scope = { enable = false },
    navigation = {
      enable = true,
      keymaps = {
        goto_definition = 'gtd',
        list_definitions = 'gtD',
        list_definitions_toc = 'gt0',
        goto_next_usage = '<a-*>',
        goto_previous_usage = '<a-#>',
      },
    },
  },
  highlight = {
    enable = true,
    use_languagetree = true,
    disable = {

      -- 'wgsl',
      -- 'wgsl_bevy',
      -- 'help',
      -- 'latex',
      -- 'bash',
      -- 'typescript',
      -- 'markdown',
    },
    additional_vim_regex_highlighting = {
      'md',
      'zsh',
    },
    custom_captures = {
      -- Highlight the @foo.bar capture group with the "Identifier" highlight group.
      ['foo.bar'] = 'Identifier',
    },
  },
  incremental_custom = {
    enable = false,
    disable = { 'markdown' },
    keymaps = {
      init_selection = 'vv',
      node_incremental = 'v',
      -- scope_incremental = '<CR>',
      node_decremental = 'V',
    },
  },
  textsubjects = {
    -- Lua, Rust, Go, Ruby, Python, JavaScript / JSX, TypeScript / TSX, Elixir, Julia.
    -- v<CR><CR>...
    enable = false,
    keymaps = {
      ['gts'] = 'textsubjects-smart', -- works in visual mode
      ['gto'] = 'textsubjects-container-outer',
      ['.'] = 'textsubjects-smart',
      -- ["<tab>"] = "textsubjects-container-outer",
      -- [";"] = "textsubjects-container-outer",
      -- ["<cr>"] = "textsubjects-smart", -- works in visual mode
    },
  },
  pairs = {
    enable = true,
    disable = {},
    -- highlight_pair_events = { "CursorMoved" }, -- e.g. {"CursorMoved"}, -- when to highlight the pairs, use {} to deactivate highlighting
    highlight_self = true, -- whether to highlight also the part of the pair under cursor (or only the partner)
    goto_right_end = false, -- whether to go to the end of the right partner or the beginning
    fallback_cmd_normal = "silent! call matchit#Match_wrapper('',1,'n')", -- What command to issue when we can't find a pair (e.g. "normal! %")
    -- "call matchup#util#patch_match_words",
    keymaps = {
      -- goto_partner = "<leader>%",
      goto_partner = '<leader>%',
      delete_balanced = 'X',
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
      lookahead = true,
      enable = false,
      keymaps = {
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
        -- ["af"] = "@function.outer",
        -- ["if"] = "@function.inner",
        -- ["at"] = "@class.outer",
        -- ["it"] = "@class.inner",
        -- ["ac"] = "@call.outer",
        -- ["ic"] = "@call.inner",
        -- ["aa"] = "@parameter.outer",
        -- ["ia"] = "@parameter.inner",
        -- ["al"] = "@loop.outer",
        -- ["il"] = "@loop.inner",
        -- ["ai"] = "@conditional.outer",
        -- ["ii"] = "@conditional.inner",
        -- ["a/"] = "@comment.outer",
        -- ["i/"] = "@comment.inner",
        -- ["ab"] = "@block.outer",
        -- ["ib"] = "@block.inner",
        -- ["as"] = "@statement.outer",
        -- ["is"] = "@scopename.inner",
        -- ["aA"] = "@attribute.outer",
        -- ["iA"] = "@attribute.inner",
        -- ["aF"] = "@frame.outer",
        -- ["iF"] = "@frame.inner",
      },
    },
    swap = {
      enable = true,
      swap_next = { ['<leader>a'] = '@parameter.inner' },
      swap_previous = { ['<leader>A'] = '@parameter.inner' },
    },
    move = {
      enable = true,
      set_jumps = true,
      goto_next_start = {
        [']f'] = '@function.outer',
        [']c'] = '@class.outer',
      },
      goto_previous_start = {
        ['[f'] = '@function.outer',
        ['[c'] = '@class.outer',
      },
    },
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
