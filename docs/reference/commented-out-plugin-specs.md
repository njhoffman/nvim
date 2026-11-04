# Commented-out plugin specs

Plugin specs and options that were commented out in `lua/plugins/` until v0.31.3, kept as candidates. Lines are from
that version.

## lua/plugins/colorscheme.lua:51

```lua
-- { "edluffy/hologram.nvim", cond = os.getenv("KITTY_WINDOW_ID") ~= nil
-- ["nvim-highlight-colors"] = { "brenoprata10/nvim-highlight-color" },
-- ["icon-picker.nvim"] = { "ziontee113/icon-picker.nvim"}
-- ["codewindow.nvim"] = { "gorbit99/codewindow.nvim" },
-- https://github.com/anuvyklack/windows.nvim
-- ["yank-history"] = {"yazgoo/yank-history"},
-- https://github.com/gbprod/yanky.nvim
```

## lua/plugins/lsp.lua:122

```lua
    -- keys = {
    --   {
    --     "<leader>xx",
    --     "<cmd>Trouble diagnostics toggle<cr>",
    --     desc = "Diagnostics (Trouble)",
    --   },
    --   {
    --     "<leader>xX",
    --     "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
    --     desc = "Buffer Diagnostics (Trouble)",
    --   },
    --   {
    --     "<leader>cs",
    --     "<cmd>Trouble symbols toggle focus=false<cr>",
    --     desc = "Symbols (Trouble)",
    --   },
    --   {
    --     "<leader>cl",
    --     "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
    --     desc = "LSP Definitions / references / ... (Trouble)",
    --   },
    --   {
    --     "<leader>xL",
    --     "<cmd>Trouble loclist toggle<cr>",
    --     desc = "Location List (Trouble)",
    --   },
    --   {
    --     "<leader>xQ",
    --     "<cmd>Trouble qflist toggle<cr>",
    --     desc = "Quickfix List (Trouble)",
    --   },
    -- },
```

## lua/plugins/lsp.lua:3

```lua
--   "pmizio/typescript-tools.nvim",
-- "RRethy/vim-illuminate",
-- 'zeioth/garbage-day.nvim',
-- https://github.com/onsails/diaglist.nvim
-- https://github.com/mfussenegger/nvim-jdtls
-- https://github.com/jmbuhr/otter.nvim
-- "KostkaBrukowa/definition-or-references.nvim",
-- "Chaitanyabsprip/fastaction.nvim",
-- { 'Wansmer/symbol-usage.nvim', event = 'LspAttach' },
-- { "jose-elias-alvarez/typescript.nvim" },
-- ["cmp-tabnine"] = { "tzachar/cmp-tabnine", run = "./install.sh", after = "nvim-cmp" },
--   { "inkarkat/vim-UnconditionalPaste",
--   requires = "inkarkat/vim-ingo-library" },
```

## lua/plugins/main.lua:1269

```lua
        -- archives_dir = {
        --   description = [[The directory to store the archives]],
        --   default = vim.fn.stdpath('cache') .. path.separator .. 'fundo',
        -- },
        -- limit_archives_size = {
        --   description = [[Limit the archives directory size, unit is MB(megabyte), elder files will be
        -- removed based on their modified time]],
        --   default = 512,
        -- },
```

## lua/plugins/main.lua:926

```lua
    -- -- Change default URI
    -- opts = { git = { base_uri_format = "https://git.home.arpa/%s.git" } }
    -- -- Open my own repositories by name with SSH.
    -- -- E.g. "git-dev.nvim" rather than "moyiz/git-dev.nvim"
    -- opts = { git = { default_org = "moyiz", base_uri_format = "git@github.com:%s.git" } }
    -- -- Enforce only full URIs (do not accept partial names).
    -- opts = { git = { base_uri_format = "%s" } }
```

## lua/plugins/main.lua:918

```lua
      -- local repo = vim.fn.input('Repository name / URI: ')
      -- git = {
      --    base_uri_format = "https://git.home.arpa/%s.git",
      --  }
      -- if repo ~= '' then
      --   require('git-dev').open(repo)
      -- end
```

## lua/plugins/main.lua:743

```lua
  --   "dhruvasagar/vim-table-mode",
  --   lazy = false,
  --   -- ft = { "markdown", "pandoc", "vimwiki" },
  --   init = function()
  --     require("configs.vim-table-mode")
  --   end,
  -- },
```

## lua/plugins/main.lua:575

```lua
    -- keys = {
    --   -- Run API request
    --   { "<leader>A", "<cmd>HurlRunner<CR>", desc = "Run All requests" },
    --   { "<leader>a", "<cmd>HurlRunnerAt<CR>", desc = "Run Api request" },
    --   { "<leader>te", "<cmd>HurlRunnerToEntry<CR>", desc = "Run Api request to entry" },
    --   { "<leader>tm", "<cmd>HurlToggleMode<CR>", desc = "Hurl Toggle Mode" },
    --   { "<leader>tv", "<cmd>HurlVerbose<CR>", desc = "Run Api in verbose mode" },
    --   -- Run Hurl request in visual mode
    --   { "<leader>h", ":HurlRunner<CR>", desc = "Hurl Runner", mode = "v" },
    -- },
```

## lua/plugins/main.lua:508

```lua
      -- {
      --   "Davidyz/VectorCode",
      --   -- pipx install git+https://github.com/Davidyz/VectorCode
      --   build = "pipx upgrade vectorcode", -- If you used pipx to install the CLI
      --   -- pipx install chromadb==0.6.3
      --   -- build = "uv tool upgrade vectorcode",
      --   -- pipx install --force "vectorcode[lsp,mcp]"
      --   -- pipx inject vectorcode vectorcode[lsp] --force
      --   -- uv tool install vectorcode[lsp,mcp]
      --   -- mkdir -p ~/.local/share/vectorcode/chromadb
      --   dependencies = { "nvim-lua/plenary.nvim" },
      -- },
```

## lua/plugins/main.lua:321

```lua
      -- showBlankVirtLine = true,
      -- highlightColor = { link = "Comment" },
      -- hints = {
      --      Caret = { text = "^", prio = 2 },
      --      Dollar = { text = "$", prio = 1 },
      --      MatchingPair = { text = "%", prio = 5 },
      --      Zero = { text = "0", prio = 1 },
      --      w = { text = "w", prio = 10 },
      --      b = { text = "b", prio = 9 },
      --      e = { text = "e", prio = 8 },
      --      W = { text = "W", prio = 7 },
      --      B = { text = "B", prio = 6 },
      --      E = { text = "E", prio = 5 },
      -- },
      -- gutterHints = {
      --     G = { text = "G", prio = 10 },
      --     gg = { text = "gg", prio = 9 },
      --     PrevParagraph = { text = "{", prio = 8 },
      --     NextParagraph = { text = "}", prio = 8 },
      -- },
      -- disabled_fts = {
      --     "startify",
      -- },
```

## lua/plugins/main.lua:263

```lua
    -- config = function()
    --   local neocodeium = require("neocodeium")
    --   neocodeium.setup()
    --   vim.keymap.set("i", "<A-f>", neocodeium.accept)
    -- end,
```
