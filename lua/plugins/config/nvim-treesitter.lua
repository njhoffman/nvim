local config = require("config").Treesitter
local tsmodules = require "plugins.config.nvim-treesitter-modules"

local ts = require "nvim-treesitter"
ts.define_modules(tsmodules)

require "nvim-treesitter.configs".setup {
  -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  ensure_installed = "all",
  ignore_install = { "phpdoc", "latex" },

  playground = {
    enable = true,
    disable = {},
    updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
    persist_queries = false, -- Whether the query persists across vim sessions
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
      show_help = "?"
    }
  },
  highlight = {
    enable = true,
    use_languagetree = true,
    disable = {
      -- 'lua',
      "latex",
      "bash",
      "markdown"
    },
    custom_captures = {
      -- Highlight the @foo.bar capture group with the "Identifier" highlight group.
      ["foo.bar"] = "Identifier"
    },
    additional_vim_regex_highlighting = true
  },
  context_commentstring = { enable = true, enable_autocmd = false },
  refactor = {
    smart_rename = { enable = true, keymaps = { smart_rename = "gR" } },
    highlight_definitions = { enable = true },
    highlight_current_scope = { enable = config.highlight },
    navigation = {
      enable = true,
      keymaps = {
        goto_definition = "gtd",
        list_definitions = "gtD",
        list_definitions_toc = "gt0",
        goto_next_usage = "<a-*>",
        goto_previous_usage = "<a-#>"
      }
    }
  },
  autotag = {
    enable = config.autotag,
    filetypes = { "html", "javascript", "javascriptreact", "typescriptreact", "svelte", "vue" },
    skip_tags = {
      "area",
      "base",
      "br",
      "col",
      "command",
      "embed",
      "hr",
      "img",
      "slot",
      "input",
      "keygen",
      "link",
      "meta",
      "param",
      "source",
      "track",
      "wbr",
      "menuitem"
    }
  },
  indent = {
    enable = config.indent
  },
  textobjects = {
    select = {
      lookahead = true,
      enable = true,
      keymaps = {
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner"
      }
    },
    swap = {
      enable = true,
      swap_next = { ["<leader>a"] = "@parameter.inner" },
      swap_previous = { ["<leader>A"] = "@parameter.inner" }
    },
    move = {
      enable = true,
      set_jumps = true,
      goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
      goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" }
    },
    lsp_interop = {
      enable = true,
      border = "none",
      peek_definition_code = { ["gp"] = "@function.outer", ["gP"] = "@class.outer" }
    }
  },
  rainbow = { enable = config.rainbow },
  matchup = {
    enable = true -- mandatory, false will disable the whole extension
    -- disable = {"c", "ruby"} -- optional, list of language that will be disabled
  },
  pairs = {
    enable = true,
    disable = {},
    -- e.g. {"CursorMoved"}, -- when to highlight the pairs, use {} to deactivate highlighting
    highlight_pair_events = {},
    highlight_self = false, -- whether to highlight also the part of the pair under cursor (or only the partner)
    goto_right_end = false, -- whether to go to the end of the right partner or the beginning
    -- What command to issue when we can't find a pair (e.g. "normal! %")
    fallback_cmd_normal = "call matchit#Match_wrapper('',1,'n')",
    keymaps = { goto_partner = "<leader>%" }
  },
  incremental_custom = tsmodules.incremental_custom,
  textsubjects = {
    -- Lua, Rust, Go, Ruby, Python, JavaScript / JSX, TypeScript / TSX, Elixir, Julia.
    -- v<CR><CR>...
    enable = false,
    keymaps = {
      ["gts"] = "textsubjects-smart", -- works in visual mode
      ["gto"] = "textsubjects-container-outer",
      ["."] = "textsubjects-smart",
      -- ["<tab>"] = "textsubjects-container-outer",
      -- [";"] = "textsubjects-container-outer",
      -- ["<cr>"] = "textsubjects-smart", -- works in visual mode
    }
  },
  endwise = {
    enable = true
  }
}

require 'treesitter-context'.setup {
  enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
  max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
  patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
    -- For all filetypes
    -- Note that setting an entry here replaces all other patterns for this entry.
    -- By setting the 'default' entry below, you can control which nodes you want to
    -- appear in the context window.
    default = {
      'class',
      'function',
      'method',
      -- 'for', -- These won't appear in the context
      -- 'while',
      -- 'if',
      -- 'switch',
      -- 'case',
    },
    -- Example for a specific filetype.
    -- If a pattern is missing, *open a PR* so everyone can benefit.
    --   rust = {
    --       'impl_item',
    --   },
  },
  exact_patterns = {
    -- Example for a specific filetype with Lua patterns
    -- Treat patterns.rust as a Lua pattern (i.e "^impl_item$" will
    -- exactly match "impl_item" only)
    -- rust = true,
  }
}

-- making dot repeatable
-- --local CR = vim.api.nvim_replace_termcodes("<cr>", true, true, true)

-- local function swap_textobject(query_string, direction)
--   local bufnr, textobject_range, node = shared.textobject_at_point(query_string)
--   if not node then return end
-- @@ -20,10 +22,12 @@ end

-- function M.swap_next(query_string)
--   swap_textobject(query_string, 1)
--   pcall(vim.fn["repeat#set"], ":TSTextobjectSwapNext "..query_string..CR)
-- end

-- -------------------- TEXT OBJECTS --------------------------
-- for _, ch in ipairs({
--   '<space>', '!', '#', '$', '%', '&', '*', '+', ',', '-', '.',
--   '/', ':', ';', '=', '?', '@', '<bslash>', '^', '_', '~', '<bar>',
-- }) do
--   map('x', fmt('i%s', ch), fmt(':<C-u>normal! T%svt%s<CR>', ch, ch), {silent = true})
--   map('o', fmt('i%s', ch), fmt(':<C-u>normal vi%s<CR>', ch), {silent = true})
--   map('x', fmt('a%s', ch), fmt(':<C-u>normal! F%svf%s<CR>', ch, ch), {silent = true})
--   map('o', fmt('a%s', ch), fmt(':<C-u>normal va%s<CR>', ch), {silent = true})
-- end

-- text objects:
-- @block.inner/outer
-- @call.inner/outer
-- @class.inner/outer
-- @comment.outer
-- @conditional.inner/outer
-- @frame.inner/outer
-- @function.inner/outer
-- @loop.inner/outer
-- @parameter.inner/outer
-- @scopename.inner
-- @statement.outer
