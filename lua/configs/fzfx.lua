require("fzfx").setup({})

-- global variables
-- vim.g.fzfx_disable_buffer_previewer: Disable nvim buffer for previewing file contents, use fzf builtin preview window via bat with best performance. By default this feature is enabled.

-- vim.g.fzfx_disable_buffer_previewer = 1 -- or true
-- vim.g.fzfx_enable_bat_theme_autogen: Enable bat themes auto generation for fzf's builtin preview window, it generates the TextMate .tmTheme file (widely used by text editors such as Sublime Text, VS Code and bat command) for bat based on current Neovim's colorscheme, thus makes a closer looking to Neovim's buffer. By default this feature is disabled.

-- vim.g.fzfx_enable_bat_theme_autogen = 1 -- or true

-- buffer selector configuration
-- Creates a window with the list of all opened (not necessarily loaded) buffers and automatically sets its size to fit the content.
-- Think about a nice selector for :ls

local buffer_selector_config = {
  buffers = {

    fzf_opts = {
      "--info=hidden",
      "--padding=0",
      "--header=",
      "--preview-window=hidden",
    },

    win_opts = function()
      local bufs_fn_len = {}
      local max_len = 0

      for _, buf_nr in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_valid(buf_nr) then
          local buf_listed = vim.api.nvim_get_option_value("buflisted", { buf = buf_nr })
          local buf_nm = vim.api.nvim_buf_get_name(buf_nr)
          buf_nm = vim.fn.expand(buf_nm)
          buf_nm = vim.fn.fnamemodify(buf_nm, ":.")
          if buf_listed then
            if buf_nm ~= "" then
              buf_len = string.len(buf_nm)
              table.insert(bufs_fn_len, buf_len)
            end
          end
        end
      end

      for _, len in ipairs(bufs_fn_len) do
        max_len = math.max(max_len, len)
      end

      popup = {
        height = #bufs_fn_len + 3,
        width = max_len + 4,
        relative = "win",
        zindex = 51,
      }

      return popup
    end,
  },
}
local defaults = {
  -- Find files, i.e. the 'FzfxFiles' command.
  --
  --- @type fzfx.GroupConfig
  files = require("fzfx.cfg.files"),

  -- Live grep, i.e. the 'FzfxLiveGrep' command.
  --
  --- @type fzfx.GroupConfig
  live_grep = require("fzfx.cfg.live_grep"),

  -- Live grep only on current buffer, i.e. the 'FzfxBufLiveGrep' command.
  --
  --- @type fzfx.GroupConfig
  buf_live_grep = require("fzfx.cfg.buf_live_grep"),

  -- Find buffers, i.e. the 'FzfxBuffers' command.
  --
  --- @type fzfx.GroupConfig
  buffers = require("fzfx.cfg.buffers"),

  -- Find git files, i.e. the 'FzfxGFiles' command.
  --
  --- @type fzfx.GroupConfig
  git_files = require("fzfx.cfg.git_files"),

  -- Git live grep, i.e. the 'FzfxGLiveGrep' command.
  --
  --- @type fzfx.GroupConfig
  git_live_grep = require("fzfx.cfg.git_live_grep"),

  -- Search git status (changed files), i.e. the 'FzfxGStatus' command.
  --
  --- @type fzfx.GroupConfig
  git_status = require("fzfx.cfg.git_status"),

  -- Search git branches, i.e. the 'FzfxGBranches' command.
  --
  --- @type fzfx.GroupConfig
  git_branches = require("fzfx.cfg.git_branches"),

  -- Search git commits (logs), i.e. the 'FzfxGCommits' command.
  --
  --- @type fzfx.GroupConfig
  git_commits = require("fzfx.cfg.git_commits"),

  -- Search git blame (on current buffer), i.e. the 'FzfxGBlame' command.
  --
  --- @type fzfx.GroupConfig
  git_blame = require("fzfx.cfg.git_blame"),

  -- Search vim commands, i.e. the 'FzfxCommands' command.
  --
  --- @type fzfx.GroupConfig
  vim_commands = require("fzfx.cfg.vim_commands"),

  -- Search vim key mappings, i.e. the 'FzfxKeyMaps' command.
  --
  --- @type fzfx.GroupConfig
  vim_keymaps = require("fzfx.cfg.vim_keymaps"),

  -- Search vim marks, i.e. the 'FzfxMarks' command.
  --
  --- @type fzfx.GroupConfig
  vim_marks = require("fzfx.cfg.vim_marks"),

  -- Search (LSP) diagnostics, i.e. the 'FzfxLspDiagnostics' command.
  --
  --- @type fzfx.GroupConfig
  lsp_diagnostics = require("fzfx.cfg.lsp_diagnostics"),

  -- Search LSP definitions under cursor, i.e. the 'FzfxLspDefinitions' command.
  --
  --- @type fzfx.GroupConfig
  lsp_definitions = require("fzfx.cfg.lsp_definitions"),

  -- Search LSP type definitions under cursor, i.e. the 'FzfxLspTypeDefinitions' command.
  --
  --- @type fzfx.GroupConfig
  lsp_type_definitions = require("fzfx.cfg.lsp_type_definitions"),

  -- Search LSP references under cursor, i.e. the 'FzfxLspReferences' command.
  --
  --- @type fzfx.GroupConfig
  lsp_references = require("fzfx.cfg.lsp_references"),

  -- Search LSP implementations under cursor, i.e. the 'FzfxLspImplementations' command.
  --
  --- @type fzfx.GroupConfig
  lsp_implementations = require("fzfx.cfg.lsp_implementations"),

  -- Search LSP incoming calls under cursor, i.e. the 'FzfxLspIncomingCalls' command.
  --
  --- @type fzfx.GroupConfig
  lsp_incoming_calls = require("fzfx.cfg.lsp_incoming_calls"),

  -- Search LSP outgoing calls under cursor, i.e. the 'FzfxLspOutgoingCalls' command.
  --
  --- @type fzfx.GroupConfig
  lsp_outgoing_calls = require("fzfx.cfg.lsp_outgoing_calls"),

  -- Search files and directories, i.e. the 'FzfxFileExplorer' command.
  --
  --- @type fzfx.GroupConfig
  file_explorer = require("fzfx.cfg.file_explorer"),

  -- Yanked history, save yanked text as the input of 'put' variants.
  yank_history = {
    other_opts = {
      maxsize = 100,
    },
  },

  -- Basic fzf options.
  fzf_opts = {
    "--ansi",
    "--info=inline",
    "--layout=reverse",
    "--border=rounded",
    "--height=100%",
    "--bind=ctrl-e:toggle",
    "--bind=ctrl-a:toggle-all",
    "--bind=alt-p:toggle-preview",
    "--bind=ctrl-f:preview-half-page-down",
    "--bind=ctrl-b:preview-half-page-up",
  },

  -- Override fzf options, with highest priority, which could override 'fzf_opts' above.
  -- This option is to help configure fzf options easier. Since there're two 'fzf_opts' options: root level and command level.
  --
  -- For example now we have below config:
  --
  -- ```lua
  -- require("fzfx").setup({
  --   live_grep = {
  --     fzf_opts = {
  --       '--disabled',
  --       { '--prompt', 'Live Grep > ' },
  --       { '--preview-window', '+{2}-/2' },
  --     },
  --   },
  --   fzf_opts = {
  --     '--no-multi',
  --     { '--preview-window', 'top,70%' },
  --   },
  -- })
  -- ```
  --
  -- The '--preview-window' inside 'live_grep.fzf_opts' will override the one inside the root 'fzf_opts'.
  -- Because command level 'fzf_opts' will have higher priority then root level.
  --
  -- So finally the options emit to the 'fzf' binary will be:
  --
  -- ```bash
  -- fzf --no-multi --disabled --prompt 'Live Grep > ' --preview-window '+{2}-/2'
  -- ```
  --
  -- Now with this option ('override_fzf_opts'), it has the highest priority that can override command level 'fzf_opts'.
  -- Thus help configure some fzf options such as '--preview-window' globally.
  override_fzf_opts = {},

  -- Fzf colors.
  -- Please see: https://github.com/junegunn/fzf/blob/master/README-VIM.md#explanation-of-gfzf_colors.
  fzf_color_opts = {
    fg = { "fg", "Normal" },
    bg = { "bg", "Normal" },
    hl = { "fg", "Comment" },
    ["fg+"] = { "fg", "CursorLine", "CursorColumn", "Normal" },
    ["bg+"] = { "bg", "CursorLine", "CursorColumn" },
    ["hl+"] = { "fg", "Statement" },
    info = { "fg", "PreProc" },
    border = { "fg", "FloatBorder", "NormalFloat", "Normal" },
    prompt = { "fg", "Conditional" },
    pointer = { "fg", "Exception" },
    marker = { "fg", "Keyword" },
    spinner = { "fg", "Label" },
    header = { "fg", "Comment" },
    preview_label = { "fg", "Label" },
  },

  -- Icons.
  -- Please see nerd fonts: https://www.nerdfonts.com/cheat-sheet.
  -- Please see unicode: https://symbl.cc/en/.
  icons = {
    -- Nerd fonts:
    --     nf-fa-file_text_o               \uf0f6
    --     nf-fa-file_o                    \uf016 (default)
    unknown_file = "",

    -- Nerd fonts:
    --     nf-custom-folder                \ue5ff (default)
    --     nf-fa-folder                    \uf07b
    -- 󰉋    nf-md-folder                    \udb80\ude4b
    folder = "",

    -- Nerd fonts:
    --     nf-custom-folder_open           \ue5fe (default)
    --     nf-fa-folder_open               \uf07c
    -- 󰝰    nf-md-folder_open               \udb81\udf70
    folder_open = "",

    -- Nerd fonts:
    --     nf-oct-arrow_right              \uf432
    --     nf-cod-arrow_right              \uea9c
    --     nf-fa-caret_right               \uf0da
    --     nf-weather-direction_right      \ue349
    --     nf-fa-long_arrow_right          \uf178
    --     nf-oct-chevron_right            \uf460
    --     nf-fa-chevron_right             \uf054 (default)
    --
    -- Unicode:
    -- https://symbl.cc/en/collections/arrow-symbols/
    -- ➜    U+279C                          &#10140;
    -- ➤    U+27A4                          &#10148;
    fzf_pointer = "",

    -- Nerd fonts:
    --     nf-fa-star                      \uf005
    -- 󰓎    nf-md-star                      \udb81\udcce
    --     nf-cod-star_full                \ueb59
    --     nf-oct-dot_fill                 \uf444
    --     nf-fa-dot_circle_o              \uf192
    --     nf-cod-check                    \ueab2
    --     nf-fa-check                     \uf00c
    -- 󰄬    nf-md-check                     \udb80\udd2c
    --
    -- Unicode:
    -- https://symbl.cc/en/collections/star-symbols/
    -- https://symbl.cc/en/collections/list-bullets/
    -- https://symbl.cc/en/collections/special-symbols/
    -- •    U+2022                          &#8226;
    -- ✓    U+2713                          &#10003; (default)
    fzf_marker = "✓",
  },

  -- Popup window.
  popup = {
    -- Window layout.
    win_opts = {
      -- Height and width.
      --
      -- 1. If 0 <= `height`/`width` <= 1, they're evaluated as percentage value based on the editor/window's rows and columns,
      --    i.e. the final popup window's rows = `height` * rows, columns = `width` * columns.
      --
      -- 2. If `height`/`width` > 1, they're evaluated as absolute rows and columns count.
      height = 0.85,
      width = 0.85,

      -- Float window's relative, by default is based on the editor.
      --
      -- It has below options:
      --  1. "editor"
      --  2. "win"
      --  3. "cursor"
      relative = "editor",

      -- When relative is "editor" or "win", the anchor is the middle center, not the `nvim_open_win()` API's default 'NW' (north west).
      -- Because 'NW' is a little bit complicated for users to calculate the position.
      -- Intuitively we just put the popup window in the middle center of the editor or current window.
      --
      -- If you need to adjust the position of the popup window, you can specify the `row` and `col` options:
      --
      -- 1. If -0.5 <= `row`/`col` <= 0.5, they're evaluated as percentage value based on the editor/window's height and width.
      --    i.e. the final popup window's rows = `row` * height, columns = `col` * width.
      --
      -- 2. If `row`/`col` <= -1 or `row`/`col` >= 1, they're evaluated as absolute rows and columns count.
      --    For example, you can set 'row = -vim.o.cmdheight' to move the popup window up for 1~2 rows based on your 'cmdheight' option.
      --    This is especially useful when the popup window is too big and conflicts with the statusline at bottom.
      --
      -- 3. `row`/`col` cannot be in range (-1, -0.5) or (0.5, 1), it's invalid.
      --
      -- When relative is "cursor", the anchor is north west (NW).
      -- Because we just want to put the popup window relative to the cursor.
      -- So `row` and `col` will be directly passed to the `nvim_open_win()` API without any pre-processing.
      row = 0,
      col = 0,
    },
  },

  cache = {
    dir = require("fzfx.commons.path").join(vim.fn.stdpath("data"), "fzfx.nvim"),
  },

  -- debug
  debug = {
    enable = false,
    console_log = true,
    file_log = false,
  },
}

local recommended_keys = function()
  -- by args
  vim.keymap.set(
    "n",
    "<space>f",
    "<cmd>FzfxFiles<cr>",
    { silent = true, noremap = true, desc = "Find files" }
  )
  -- by visual select
  vim.keymap.set(
    "x",
    "<space>f",
    "<cmd>FzfxFiles visual<CR>",
    { silent = true, noremap = true, desc = "Find files" }
  )
  -- by cursor word
  vim.keymap.set(
    "n",
    "<space>wf",
    "<cmd>FzfxFiles cword<cr>",
    { silent = true, noremap = true, desc = "Find files by cursor word" }
  )
  -- by yank text
  vim.keymap.set(
    "n",
    "<space>pf",
    "<cmd>FzfxFiles put<cr>",
    { silent = true, noremap = true, desc = "Find files by yank text" }
  )
  -- by resume
  vim.keymap.set(
    "n",
    "<space>rf",
    "<cmd>FzfxFiles resume<cr>",
    { silent = true, noremap = true, desc = "Find files by resume last" }
  )

  -- ======== live grep ========

  -- live grep
  vim.keymap.set(
    "n",
    "<space>l",
    "<cmd>FzfxLiveGrep<cr>",
    { silent = true, noremap = true, desc = "Live grep" }
  )
  -- by visual select
  vim.keymap.set(
    "x",
    "<space>l",
    "<cmd>FzfxLiveGrep visual<cr>",
    { silent = true, noremap = true, desc = "Live grep" }
  )
  -- by cursor word
  vim.keymap.set(
    "n",
    "<space>wl",
    "<cmd>FzfxLiveGrep cword<cr>",
    { silent = true, noremap = true, desc = "Live grep by cursor word" }
  )
  -- by yank text
  vim.keymap.set(
    "n",
    "<space>pl",
    "<cmd>FzfxLiveGrep put<cr>",
    { silent = true, noremap = true, desc = "Live grep by yank text" }
  )
  -- by resume
  vim.keymap.set(
    "n",
    "<space>rl",
    "<cmd>FzfxLiveGrep resume<cr>",
    { silent = true, noremap = true, desc = "Live grep by resume last" }
  )

  -- ======== buffers ========

  -- by args
  vim.keymap.set(
    "n",
    "<space>bf",
    "<cmd>FzfxBuffers<cr>",
    { silent = true, noremap = true, desc = "Find buffers" }
  )

  -- ======== git files ========

  -- by args
  vim.keymap.set(
    "n",
    "<space>gf",
    "<cmd>FzfxGFiles<cr>",
    { silent = true, noremap = true, desc = "Find git files" }
  )

  -- ======== git live grep ========

  -- by args
  vim.keymap.set(
    "n",
    "<space>gl",
    "<cmd>FzfxGLiveGrep<cr>",
    { silent = true, noremap = true, desc = "Git live grep" }
  )
  -- by visual select
  vim.keymap.set(
    "x",
    "<space>gl",
    "<cmd>FzfxGLiveGrep visual<cr>",
    { silent = true, noremap = true, desc = "Git live grep" }
  )
  -- by cursor word
  vim.keymap.set(
    "n",
    "<space>wgl",
    "<cmd>FzfxGLiveGrep cword<cr>",
    { silent = true, noremap = true, desc = "Git live grep by cursor word" }
  )
  -- by yank text
  vim.keymap.set(
    "n",
    "<space>pgl",
    "<cmd>FzfxGLiveGrep put<cr>",
    { silent = true, noremap = true, desc = "Git live grep by yank text" }
  )
  -- by resume
  vim.keymap.set(
    "n",
    "<space>rgl",
    "<cmd>FzfxGLiveGrep resume<cr>",
    { silent = true, noremap = true, desc = "Git live grep by resume last" }
  )

  -- ======== git changed files (status) ========

  -- by args
  vim.keymap.set(
    "n",
    "<space>gs",
    "<cmd>FzfxGStatus<cr>",
    { silent = true, noremap = true, desc = "Find git changed files (status)" }
  )

  -- ======== git branches ========

  -- by args
  vim.keymap.set(
    "n",
    "<space>br",
    "<cmd>FzfxGBranches<cr>",
    { silent = true, noremap = true, desc = "Search git branches" }
  )

  -- ======== git commits ========

  -- by args
  vim.keymap.set(
    "n",
    "<space>gc",
    "<cmd>FzfxGCommits<cr>",
    { silent = true, noremap = true, desc = "Search git commits" }
  )

  -- ======== git blame ========

  -- by args
  vim.keymap.set(
    "n",
    "<space>gb",
    "<cmd>FzfxGBlame<cr>",
    { silent = true, noremap = true, desc = "Search git blame" }
  )

  -- ======== lsp diagnostics ========

  -- by args
  vim.keymap.set(
    "n",
    "<space>dg",
    "<cmd>FzfxLspDiagnostics<cr>",
    { silent = true, noremap = true, desc = "Search lsp diagnostics" }
  )

  -- ======== lsp symbols ========

  -- lsp definitions
  vim.keymap.set(
    "n",
    "gd",
    "<cmd>FzfxLspDefinitions<cr>",
    { silent = true, noremap = true, desc = "Goto lsp definitions" }
  )

  -- lsp type definitions
  vim.keymap.set(
    "n",
    "gt",
    "<cmd>FzfxLspTypeDefinitions<cr>",
    { silent = true, noremap = true, desc = "Goto lsp type definitions" }
  )

  -- lsp references
  vim.keymap.set(
    "n",
    "gr",
    "<cmd>FzfxLspReferences<cr>",
    { silent = true, noremap = true, desc = "Goto lsp references" }
  )

  -- lsp implementations
  vim.keymap.set(
    "n",
    "gi",
    "<cmd>FzfxLspImplementations<cr>",
    { silent = true, noremap = true, desc = "Goto lsp implementations" }
  )

  -- lsp incoming calls
  vim.keymap.set(
    "n",
    "gI",
    "<cmd>FzfxLspIncomingCalls<cr>",
    { silent = true, noremap = true, desc = "Goto lsp incoming calls" }
  )

  -- lsp outgoing calls
  vim.keymap.set(
    "n",
    "gO",
    "<cmd>FzfxLspOutgoingCalls<cr>",
    { silent = true, noremap = true, desc = "Goto lsp outgoing calls" }
  )

  -- ======== vim commands ========

  -- by args
  vim.keymap.set(
    "n",
    "<space>cm",
    "<cmd>FzfxCommands<cr>",
    { silent = true, noremap = true, desc = "Search vim commands" }
  )

  -- ======== vim key maps ========

  -- by args
  vim.keymap.set(
    "n",
    "<space>km",
    "<cmd>FzfxKeyMaps<cr>",
    { silent = true, noremap = true, desc = "Search vim keymaps" }
  )

  -- ======== vim marks ========

  -- by args
  vim.keymap.set(
    "n",
    "<space>mk",
    "<cmd>FzfxMarks<cr>",
    { silent = true, noremap = true, desc = "Search vim marks" }
  )

  -- ======== file explorer ========

  -- by args
  vim.keymap.set(
    "n",
    "<space>xp",
    "<cmd>FzfxFileExplorer<cr>",
    { silent = true, noremap = true, desc = "File explorer" }
  )
end
