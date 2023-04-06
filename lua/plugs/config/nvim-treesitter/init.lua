local config = require("config").Treesitter
local tsmodules = require("plugs.config.nvim-treesitter.modules")
require("plugs.config.nvim-treesitter.context")

local ts = require("nvim-treesitter")

ts.define_modules(tsmodules)

local cfg = {
  -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  ensure_installed = "all",
  ignore_install = { "phpdoc", "latex", "wgsl", "wgsl_bevy" },

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
  highlight = {
    enable = true,
    use_languagetree = true,
    disable = {
      "wgsl",
      "wgsl_bevy",
      "help",
      "latex",
      "bash",
      "typescript",
      "markdown",
    },
    -- TODO: replace bash and lua highlights with treesitter
    additional_vim_regex_highlighting = true,
    custom_captures = {
      -- Highlight the @foo.bar capture group with the "Identifier" highlight group.
      ["foo.bar"] = "Identifier",
    },
  },
  context_commentstring = { enable = true, enable_autocmd = false },
  refactor = {
    smart_rename = { enable = true, keymaps = { smart_rename = "gR" } },
    highlight_definitions = { enable = true },
    highlight_current_scope = { enable = false },
    navigation = {
      enable = true,
      keymaps = {
        goto_definition = "gtd",
        list_definitions = "gtD",
        list_definitions_toc = "gt0",
        goto_next_usage = "<a-*>",
        goto_previous_usage = "<a-#>",
      },
    },
  },
  autotag = {
    enable = config.autotag,
    filetypes = {
      "html",
      "javascript",
      "javascriptreact",
      "typescriptreact",
      "svelte",
      "vue",
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
      "slot",
      "input",
      "keygen",
      "link",
      "meta",
      "param",
      "source",
      "track",
      "wbr",
      "menuitem",
    },
  },
  -- indent = {
  --   enable = config.indent,
  -- },
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
        ["ic"] = "@class.inner",
        -- ["af"] = "@function.outer",
        -- ["if"] = "@function.inner",
        -- ["am"] = "@call.outer",
        -- ["im"] = "@call.inner",
        -- ["ab"] = "@block.outer",
        -- ["ib"] = "@block.inner",
        -- ["aa"] = "@parameter.outer",
        -- ["ia"] = "@parameter.inner",
        -- ["as"] = "@statement.outer",
      },
    },
    swap = {
      enable = true,
      swap_next = { ["<leader>a"] = "@parameter.inner" },
      swap_previous = { ["<leader>A"] = "@parameter.inner" },
    },
    move = {
      enable = true,
      set_jumps = true,
      goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
      goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
    },
    lsp_interop = {
      enable = true,
      border = "none",
      peek_definition_code = { ["gPf"] = "@function.outer", ["gPc"] = "@class.outer" },
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
      "TSRainbowRed",
      "TSRainbowYellow",
      "TSRainbowBlue",
      "TSRainbowOrange",
      "TSRainbowGreen",
      "TSRainbowViolet",
      "TSRainbowCyan",
    },
    enable = true,
    -- disable = { "jsx", "cpp" },
    query = { "rainbow-parens", html = "rainbow-tags", latex = "rainbow-blocks" },
    strategy = require("ts-rainbow").strategy["local"],
    -- strategy = require("ts-rainbow").strategy.global,
    max_file_lines = 3000,
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
  pairs = {
    enable = true,
    disable = {},
    highlight_pair_events = { "CursorMoved" }, -- e.g. {"CursorMoved"}, -- when to highlight the pairs, use {} to deactivate highlighting
    highlight_self = false, -- whether to highlight also the part of the pair under cursor (or only the partner)
    goto_right_end = false, -- whether to go to the end of the right partner or the beginning
    fallback_cmd_normal = "call matchit#Match_wrapper('',1,'n')", -- What command to issue when we can't find a pair (e.g. "normal! %")
    keymaps = {
      -- goto_partner = "<leader>%",
      goto_partner = "%",
      delete_balanced = "X",
    },
    delete_balanced = {
      only_on_first_char = false, -- whether to trigger balanced delete when on first character of a pair
      fallback_cmd_normal = nil, -- fallback command when no pair found, can be nil
      longest_partner = false, -- whether to delete the longest or the shortest pair when multiple found.
      -- E.g. whether to delete the angle bracket or whole tag in  <pair> </pair>
    },
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
    },
  },
  endwise = {
    enable = true,
  },
}

require("nvim-treesitter.configs").setup(cfg)
require("nvim-treesitter.install").prefer_git = true

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
