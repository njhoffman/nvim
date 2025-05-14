local telescope = require("telescope")
local sorters = require("telescope.sorters")
local H = require("helpers")
local actions = require("telescope.actions")
local mappings = require("configs.telescope.mappings")

local extension_configs = {
  -- locally managed
  ["arecibo"] = {
    ["selected_engine"] = "google",
    ["url_open_command"] = "xdg-open",
    ["show_http_headers"] = false,
    ["show_domain_icons"] = true,
  },
  ["telescope-alternate"] = require("configs.telescope.extensions-alternate"),
  -- ["devdocs"] = {},
  ["devhints"] = {},
  ["oldfiles"] = {
    mappings = mappings.file,
    include_current_session = true,
    show_time = true,
    show_size = false,
  },
  ["messages"] = {},
  ["enhanced_find_files"] = {},
  ["egrepify"] = {
    -- intersect tokens in prompt ala "str1.*str2" that ONLY matches
    -- if str1 and str2 are consecutively in line with anything in between (wildcard)
    AND = true, -- default
    permutations = false, -- opt-in to imply AND & match all permutations of prompt tokens
    lnum = true, -- default, not required
    lnum_hl = "EgrepifyLnum", -- default, not required, links to `Constant`
    col = false, -- default, not required
    col_hl = "EgrepifyCol", -- default, not required, links to `Constant`
    title = true, -- default, not required, show filename as title rather than inline
    filename_hl = "EgrepifyFile", -- default, not required, links to `Title`
    -- suffix = long line, see screenshot
    -- EXAMPLE ON HOW TO ADD PREFIX!
    prefixes = {
      -- ADDED ! to invert matches example prompt: ! sorter
      -- matches all lines that do not comprise sorter
      -- rg --invert-match -- sorter
      ["!"] = {
        flag = "invert-match",
      },
      -- HOW TO OPT OUT OF PREFIX
      -- ^ is not a default prefix and safe example
      ["^"] = false,
      -- DEFAULTS
      -- filter for file suffixes
      -- example prompt: #lua,md $MY_PROMPT
      -- searches with ripgrep prompt $MY_PROMPT in files with extensions lua and md
      -- i.e. rg --glob="*.{lua,md}" -- $MY_PROMPT
      ["#"] = {
        -- #$REMAINDER
        -- # is caught prefix
        -- `input` becomes $REMAINDER
        -- in the above example #lua,md -> input: lua,md
        flag = "glob",
        cb = function(input)
          return string.format([[*.{%s}]], input)
        end,
      },
      -- filter for (partial) folder names
      -- example prompt: >conf $MY_PROMPT
      -- searches with ripgrep prompt $MY_PROMPT in paths that have "conf" in folder
      -- i.e. rg --glob="**/conf*/**" -- $MY_PROMPT
      [">"] = {
        flag = "glob",
        cb = function(input)
          return string.format([[**/{%s}*/**]], input)
        end,
      },
      -- filter for (partial) file names
      -- example prompt: &egrep $MY_PROMPT
      -- searches with ripgrep prompt $MY_PROMPT in paths that have "egrep" in file name
      -- i.e. rg --glob="*egrep*" -- $MY_PROMPT
      ["&"] = {
        flag = "glob",
        cb = function(input)
          return string.format([[*{%s}*]], input)
        end,
      },
    },
    -- default mappings
    mappings = {
      i = {
        -- toggle prefixes, prefixes is default
        ["<C-z>"] = require("telescope._extensions.egrepify.actions").toggle_prefixes,
        -- toggle AND, AND is default, AND matches tokens and any chars in between
        ["<C-a>"] = require("telescope._extensions.egrepify.actions").toggle_and,
        -- toggle permutations, permutations of tokens is opt-in
        ["<C-r>"] = require("telescope._extensions.egrepify.actions").toggle_permutations,
      },
    },
  },
  ["env"] = {},
  -- ['fences'] = {},
  ["filetypes"] = {},
  ["pickers_history"] = {},
  -- ['smart_history'] = {},

  ["find_pickers"] = {},
  ["frecency"] = function()
    --   specify filter like :directory_name: or  :*:'. :etc: -> workspace browser (tab autocompletes)
    local baseDirs = {
      home = vim.fn.expand("$HOME"),
      config = vim.fn.stdpath("config"),
      data = vim.fn.stdpath("data"),
    }

    local frecency_cfg = {
      -- default_workspace = "$HOME/.config",
      db_safe_mode = false,
      auto_validate = true,
      show_scores = true,
      show_unindexed = true,
      ignore_patterns = { "*.git/*", "/mnt/*", "*/tmp/*" },
      mappings = mappings.file,
      -- stylua: ignore
      workspaces = {
        ['etc']     = '/etc',
        ['home']    = baseDirs.home,
        ['bin']     = baseDirs.home .. '/bin',
        ['git']     = baseDirs.home .. '/git',
        ['configs'] = baseDirs.home .. '/git/repo-refs/nvim-configs',
        ['config']  = baseDirs.home .. '/.config',
        ['nvim']    = baseDirs.config,
        ['lazy']    = baseDirs.data .. '/lazy',
        ['runtime'] = baseDirs.data .. '/runtime',
        ['zettel']  = baseDirs.home .. '/zettelkasten',
        ['zinit']   = baseDirs.home .. '/.zinit',
        ['zsh']     = baseDirs.home .. '/.config/zsh',
      },
    }
    return frecency_cfg
  end,
  quicknote = {
    defaultScope = "CWD", -- CurrentBuffer, CWD or Global
  },

  -- frecency_new = function()
  --   local baseDirs = {
  --     home = vim.fn.expand('$HOME'),
  --     config = vim.fn.stdpath('config'),
  --     data = vim.fn.stdpath('data'),
  --   }
  --   local frecency_cfg = {
  --     -- db_root = "/home/my_username/path/to/db_root",
  --     auto_validate = true,
  --     show_scores = true,
  --     show_unindexed = true,
  --     disable_devicons = false,
  --     ignore_patterns = { '*.git/*', '*/tmp/*' },
  --     -- stylua: ignore
  --     workspaces = {
  --       ['etc']     = '/etc',
  --       ['home']    = baseDirs.home,
  --       ['bin']     = baseDirs.home .. '/bin',
  --       ['git']     = baseDirs.home .. '/git',
  --       ['config']  = baseDirs.home .. '/.config',
  --       ['nvim']    = baseDirs.config,
  --       ['lazy']    = baseDirs.data .. '/lazy',
  --       ['runtime'] = baseDirs.data .. '/runtime',
  --       ['zettel']  = baseDirs.home .. '/zettelkasten',
  --       ['zinit']   = baseDirs.home .. '/.zinit',
  --       ['zsh']     = baseDirs.home .. '/.config/zsh',
  --     },
  --   }
  --   return frecency_cfg
  -- end,
  ["file_history"] = function()
    local cfg = {
      backup_dir = "~/.file-history-git",
      exclude_ft = { "oil" },
      git_cmd = "git",
    }
    require("file_history").setup(cfg)
  end,
  ["gitops"] = {},
  ["gotofile"] = {},
  ["locate"] = {},
  ["tester"] = { example_option = "example_value" },
  ["mapper"] = {
    sorter = sorters.fuzzy_with_index_bias,
    -- sorter = sorters.highlighter_only
  },
  ["nerdy"] = {},
  ["options"] = {},
  ["projects"] = {
    workspaces = {
      {
        name = "ghq",
        base_dirs = { { path = "~/ghq", max_depth = 4 } },
      },
      {
        name = "nvim",
        base_dirs = { { path = "~/lazy", max_depth = 2 } },
      },
      -- theme = "dropdown",
    },
  },
  ["helpgrep"] = {
    prompt_title = "Helptags Grep",
    -- glob_pattern = "*.txt",
    -- disable_coordinates = true,
    -- path_display = { "tail" },
    ignore_paths = {
      vim.fn.stdpath("state") .. "/lazy/readme",
    },
    mappings = {
      i = {
        ["<CR>"] = actions.select_default,
        ["<C-v>"] = actions.select_vertical,
      },
      n = {
        ["<CR>"] = actions.select_default,
        ["<C-s>"] = actions.select_horizontal,
      },
    },
    default_grep = require("telescope.builtin").live_grep,
  },
  -- ['zf-native'] = {
  --   -- options for sorting file-like items
  --   file = {
  --     -- override default telescope file sorter
  --     enable = true,

  --     -- highlight matching text in results
  --     highlight_results = true,

  --     -- enable zf filename match priority
  --     match_filename = true,

  --     -- optional function to define a sort order when the query is empty
  --     initial_sort = nil,
  --   },

  --   -- options for sorting all other items
  --   generic = {
  --     -- override default telescope generic item sorter
  --     enable = true,

  --     -- highlight matching text in results
  --     highlight_results = true,

  --     -- disable zf filename match priority
  --     match_filename = false,

  --     -- optional function to define a sort order when the query is empty
  --     initial_sort = nil,
  --   },
  -- },
  ["variables"] = {},
  ["what-key"] = {},

  -- 3rd party to sort through
  -- ["feed"] = {
  --   ---@type string
  --   db_dir = vim.fn.stdpath("data") .. "/feed",
  --   ---@type string
  --   colorscheme = "morning",
  --   ---@type string
  --   date_format = "%Y-%m-%d",
  --   ---@type string
  --   split_cmd = "13split",
  --   ---@type boolean
  --   enable_default_keybindings = true,
  --   options = {
  --     ---@type table<string, any>
  --     index = {
  --       conceallevel = 0,
  --       wrap = false,
  --       number = false,
  --       relativenumber = false,
  --       modifiable = false,
  --       listchars = "tab:> ,nbsp:+",
  --     },

  --     ---@type table<string, any>
  --     entry = {
  --       conceallevel = 3,
  --       concealcursor = "nvc",
  --       wrap = true,
  --       number = false,
  --       relativenumber = false,
  --       modifiable = false,
  --       filetype = "markdown",
  --     },
  --   },
  --   ---@type table<string, any>
  --   layout = {
  --     {
  --       "feed",
  --       width = 25,
  --       color = "Title",
  --     },
  --     {
  --       "tags",
  --       width = 25,
  --       color = "WhiteSpace",
  --     },
  --     {
  --       "title",
  --       right_justify = false,
  --       width = 80,
  --       color = "@markup.strong",
  --     },
  --     header = "Hint: <M-CR> open in split | <CR> open | + add tag | - remove tag | ? help", -- TODO: placeholder set to nil
  --   },
  --   search = {
  --     default_query = "@6-months-ago +unread",
  --   },
  --   ---@type feed.feed[]
  --   feeds = {},
  --   integrations = {
  --     telescope = {},
  --   },
  -- },
  ["cmdline"] = {
    -- Adjust telescope picker size and layout
    picker = {
      layout_config = {
        width = 120,
        height = 25,
      },
    },
    -- Adjust your mappings
    mappings = {
      complete = "<Tab>",
      run_selection = "<C-CR>",
      run_input = "<CR>",
    },
    -- Triggers any shell command using overseer.nvim (`:!`)
    overseer = {
      enabled = true,
    },
  },
  ["undo"] = {
    use_delta = true,
    -- side_by_side = true,
    layout_strategy = "bottom_pane",
    layout_config = {
      height = 0.4,
      preview_cutoff = 60,
      preview_width = 0.7,
      prompt_position = "top",
      width = 0.8,
    },
    diff_context_lines = vim.o.scrolloff,
    -- entry_format = '$NODE ($STAT) [$ID] $TIME',
    -- entry_format = 'state #$ID ($STAT): $TIME',
  },
  gpt = {
    title = "Gpt Actions",
    commands = {
      "add_tests",
      "chat",
      "docstring",
      "explain_code",
      "fix_bugs",
      "grammar_correction",
      "interactive",
      "optimize_code",
      "summarize",
      "translate",
    },
    theme = require("telescope.themes").get_dropdown({}),
  },
  ["aerial"] = {},
  ["asynctasks"] = {},
  ["ast_grep"] = {
    command = {
      "sg",
      "--json=stream",
      "-p",
    }, -- must have --json and -p
    grep_open_files = false, -- search in opened files
    lang = nil, -- string value, sepcify language for ast-grep `nil` for default
  },
  -- ['bookmarks'] = {
  --   selected_browser = 'chrome',
  --   url_open_command = 'xdg-open',
  --   url_open_plugin = nil, -- vim_external, open_browser
  --   firefox_profile_name = nil,
  -- },
  ["changes"] = {},
  ["git_file_history"] = {
    -- Keymaps inside the picker
    mappings = {
      i = {
        ["<C-g>"] = require("telescope").extensions.git_file_history.actions.open_in_browser,
      },
      n = {
        ["<C-g>"] = require("telescope").extensions.git_file_history.actions.open_in_browser,
      },
    },

    -- The command to use for opening the browser (nil or string)
    -- If nil, it will check if xdg-open, open, start, wslview are available, in that order.
    browser_command = nil,
  },
  ["cheatsheet"] = function()
    local ctactions = require("cheatsheet.telescope.actions")
    require("cheatsheet").setup({
      bundled_cheetsheets = {
        enabled = { "default", "lua", "markdown", "regex", "netrw", "unicode" },
        disabled = { "nerd-fonts" },
      },
      bundled_plugin_cheatsheets = {
        enabled = {
          "auto-session",
          "goto-preview",
          "octo.nvim",
          "telescope.nvim",
          "vim-easy-align",
          "vim-sandwich",
        },
        disabled = { "gitsigns" },
      },
      include_only_installed_plugins = true,
      telescope_mappings = {
        ["<CR>"] = ctactions.select_or_fill_commandline,
        ["<A-CR>"] = ctactions.select_or_execute,
        ["<C-Y>"] = ctactions.copy_cheat_value,
        ["<C-E>"] = ctactions.edit_user_cheatsheet,
      },
    })
  end,
  ["cder"] = {
    prompt_title = "cder",
    --   dir_command = { 'fd', '--hidden', '--type=d', '.', os.getenv('HOME') },
    dir_command = { "fd", "--type=d", ".", os.getenv("HOME") },
    command_executer = { "bash", "-c" },
    previewer_command = "exa "
      .. "-a "
      .. "--color=always "
      .. "-T "
      .. "--level=3 "
      .. "--icons "
      .. "--git-ignore "
      .. "--long "
      .. "--no-permissions "
      .. "--no-user "
      .. "--no-filesize "
      .. "--git "
      .. "--ignore-glob=.git",

    pager_command = 'bat --plain --paging=always --pager="less -RS"',
    entry_maker = function(line)
      return {
        value = line,
        display = function(entry)
          return "󰉋 " .. line:gsub(os.getenv("HOME") .. "/", ""),
            {
              { { 1, 3 }, "Directory" },
            }
        end,
        ordinal = line,
      }
    end,
  },
  ["command_palette"] = {
    {
      "File",
      { "entire selection (C-a)", ':call feedkeys("GVgg")' },
      { "save current file (C-s)", ":w" },
      { "save all files (C-A-s)", ":wa" },
      { "quit (C-q)", ":qa" },
      { "file browser (C-i)", ":lua require'telescope'.extensions.file_browser.file_browser()", 1 },
      { "search word (A-w)", ":lua require('telescope.builtin').live_grep()", 1 },
      { "git files (A-f)", ":lua require('telescope.builtin').git_files()", 1 },
      { "files (C-f)", ":lua require('telescope.builtin').find_files()", 1 },
    },
    {
      "Help",
      { "tips", ":help tips" },
      { "cheatsheet", ":help index" },
      { "tutorial", ":help tutor" },
      { "summary", ":help summary" },
      { "quick reference", ":help quickref" },
      { "search help(F1)", ":lua require('telescope.builtin').help_tags()", 1 },
    },
    {
      "Vim",
      { "reload vimrc", ":source $MYVIMRC" },
      { "check health", ":checkhealth" },
      { "jumps (Alt-j)", ":lua require('telescope.builtin').jumplist()" },
      { "commands", ":lua require('telescope.builtin').commands()" },
      { "command history", ":lua require('telescope.builtin').command_history()" },
      { "registers (A-e)", ":lua require('telescope.builtin').registers()" },
      { "colorshceme", ":lua require('telescope.builtin').colorscheme()", 1 },
      { "vim options", ":lua require('telescope.builtin').vim_options()" },
      { "keymaps", ":lua require('telescope.builtin').keymaps()" },
      { "buffers", ":Telescope buffers" },
      { "search history (C-h)", ":lua require('telescope.builtin').search_history()" },
      { "paste mode", ":set paste!" },
      { "cursor line", ":set cursorline!" },
      { "cursor column", ":set cursorcolumn!" },
      { "spell checker", ":set spell!" },
      { "relative number", ":set relativenumber!" },
      { "search highlighting (F12)", ":set hlsearch!" },
    },
  },
  ["color_names"] = {},
  ["docker"] = {},
  -- ["dap"]= {},
  ["filelinks"] = {},
  -- -- The working directory to search for files.
  -- -- Set to your wiki directory to create links (further examples below)
  -- working_dir = vim.fn.getcwd(),
  -- -- specify your own find_command according to telescope's find_command syntax, f. i. { "rg", "--files", "--color", "never" }. Default is nil because telescope's find_files function has it's own default/fall back find_command logic.
  -- find_command = nil,
  -- -- First letter in display name upper or lower case, i.e. `[Plugins](…)`
  -- -- or `[plugins](…)`
  -- first_upper = true,
  -- -- Format string for inserting file links. Default is Markdown syntax.
  -- -- When you are using some wiki syntax, change it to its syntax.
  -- -- Lua regex is used. Formatting only works when there are exactly two
  -- -- `%s`. Currently, no checks for a proper Lua regex are performed, so
  -- -- keep an eye on having exactly two `%s` and nothing else/more.
  -- format_string = '[%s](%s)',
  -- -- Append space to format_string for better typography and continuous typing
  -- format_string_append = " ",
  -- -- Title for the telescope prompt
  -- prompt_title = 'File Finder',
  -- -- Display file links with or without extension, f. i. `[Plugins](…)`
  -- -- or `[Plugins.lua](…)`
  -- remove_extension = true,
  -- -- Some link schemes like Wiki, Orgmode or AsciiDoc expect the URL first
  -- -- and the displayed text second. Markdown's order is vice versa. By
  -- -- setting to true URL first schemes are possible.
  -- url_first = false
  ["file_browser"] = {
    theme = "ivy",
    mappings = mappings.file,
  },
  -- ["fzf"] = {
  --   fuzzy = true, -- false will only do exact matching
  --   override_generic_sorter = true, -- override the generic sorter
  --   override_file_sorter = true, -- override the file sorter
  --   case_mode = "smart_case", -- or "ignore_case" or "respect_case"
  -- },
  ["fzy_native"] = {
    override_generic_sorter = false,
    override_file_sorter = true,
  },
  ["gh"] = {},
  ["ghn"] = {},
  ["ghq"] = {},
  ["git_diffs"] = {},
  ["glyph"] = {
    action = function(glyph)
      -- argument glyph is a table.
      -- {name="", value="", category="", description=""}
      vim.fn.setreg("*", glyph.value)
      print([[Press p or "*p to paste this glyph]] .. glyph.value)
      -- insert glyph when picked
      -- vim.api.nvim_put({ glyph.value }, 'c', false, true)
    end,
  },
  ["heading"] = {},
  ["hop"] = {},
  ["howdoi"] = vim.tbl_deep_extend("force", {
    -- How many answers to return in the response.
    num_answers = 3,
    -- The binary to execute the howdoi command with.
    command_executor = { "bash", "-c" },
    -- The command to pipe the results into for paging.
    pager_command = "less -RS",
    -- Mapping	Action
    -- Ctrl + d	Scroll the results down
    -- Ctrl + u	Scroll the results up
    -- Ctrl + y	Yank the results to the clipboard
    -- Ctrl + p	Pastes the results into the current buffer
    -- Ctrl + v	Pastes the results into a new vertical split
    -- Ctrl + x	Pastes the results into a new horizontal split
    -- Ctrl + r	Removes the selected query from the list
  }, require("telescope.themes").get_dropdown()),
  ["import"] = {
    -- Add imports to the top of the file keeping the cursor in place
    insert_at_top = true,
    -- Support additional languages
    custom_languages = {
      {
        -- The regex pattern for the import statement
        regex = [[^(?:import(?:[\"'\s]*([\w*{}\n, ]+)from\s*)?[\"'\s](.*?)[\"'\s].*)]],
        -- The Vim filetypes
        filetypes = { "typescript", "typescriptreact", "javascript", "react" },
        -- The filetypes that ripgrep supports (find these via `rg --type-list`)
        extensions = { "js", "ts" },
      },
    },
  },
  ["lazy"] = {
    theme = "ivy",
    show_icon = true,
    mappings = {
      open_in_browser = "<M-g>",
      open_in_file_browser = "<C-o>",
      open_in_find_files = "<M-f>",
      open_in_live_grep = "<M-e>",
      open_plugins_picker = "<M-b>", -- Works only after having called first another action
      open_lazy_root_find_files = "<C-r>f",
      open_lazy_root_live_grep = "<C-r>g",
    },
  },
  ["lazygit"] = {},
  ["live_grep_args"] = {
    auto_quoting = true, -- enable/disable auto-quoting,
    mappings = { -- extend mappings
      i = {
        ["<C-k>"] = require("telescope-live-grep-args.actions").quote_prompt(),
        ["<C-i>"] = require("telescope-live-grep-args.actions").quote_prompt({
          postfix = " --iglob ",
        }),
        -- freeze the current list and start a fuzzy search in the frozen list
        ["<C-space>"] = actions.to_fuzzy_refine,
      },
    },
    -- ... Your other configuration ...
    -- ['<C-Space>'] = cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Insert, select = true, },
    -- ["<c-f>"] = function(prompt_bufnr) actions_set.shift_selection(prompt_bufnr, 10) end,
    -- ["<c-b>"] = function(prompt_bufnr) actions_set.shift_selection(prompt_bufnr, -10) end,
    -- ["<c-u>"] = false,
    -- ["<a-n>"] = actions.toggle_selection + actions.move_selection_next,
    -- ["<a-p>"] = actions.toggle_selection + actions.move_selection_previous,
    -- ["<cr>"] = actions.select_default + actions.center,,
  },
  ["luasnip"] = {},
  -- ["make"]           = {},
  ["media"] = {
    backend = "viu", -- image/gif backend
    flags = {
      viu = {
        move = true, -- GIF preview
      },
    },
    -- on_confirm_single = canned.single.copy_path,
    -- on_confirm_muliple = canned.multiple.bulk_copy,
    -- cache_path = vim.fn.stdpath('cache') .. '/media',
  },

  ["media_files"] = {
    filetypes = { "png", "webp", "jpg", "jpeg", "webm", "pdf", "mp4", "svg", "mpv", "mkv" },
    find_cmd = "fd", -- find command (defaults to `fd`)
    -- sudo apt install uberzug ffmpegthumbnailer poppler-utils epub-utils
    -- font-viewer (fontpreview)? fd, rg, etc
  },
  ["menu"] = {
    default = {
      items = {
        -- Jump to another menu
        { "Editor", "Telescope menu editor" },
      },
    },
    -- `editor` is an example, and you can name it as you like.
    editor = {
      items = {
        { "Split window vertically", "vsplit" },
        { "Split window horizontally", "split" },
        { "Write", "w" },
      },
    },
  },
  ["menufacture"] = {
    -- add menu to menufecture
    -- vim.keymap.set( 'n', '<leader>sf',
    --   require('telescope').extensions.menufacture.add_menu_with_default_mapping(
    --     require('telescope.builtin').find_files,
    --     vim.tbl_extend('force', require('telescope').extensions.menufacture.find_files_menu, {
    --       ['change cwd to parent'] = function(opts, callback)
    --         local cwd = opts.cwd and vim.fn.expand(opts.cwd) or vim.loop.cwd()
    --         opts.cwd = vim.fn.fnamemodify(cwd, ':p:h:h')
    --         callback(opts)
    --       end,
    --     })
    --   )
    -- )
    -- mappings = {
    --   main_menu = { [{ 'i', 'n' }] = '<M-Bslash>' },
    -- },
  },
  ["node_modules"] = {},
  ["npm"] = {},
  ["openbrowser"] = {
    -- Add bookmark urls
    bookmarks = {
      ["luv docs"] = "https://github.com/luvit/luv/blob/master/docs.md",
    },
    bookmark_filepath = "~/.vim/telescope_openbrowser_bookmarks",
  },
  ["ports"] = {},
  ["recent_files"] = {},
  ["repo"] = {},
  -- ["session-lens"]= {},
  ["smart_open"] = {
    -- require('telescope').extensions.smart_open.smart_open({cwd_only = true})
    show_scores = true,
    max_unindexed = 2000,
    ignore_patterns = { "*.git/*", "*/tmp/*" },
    match_algorithm = "fzy",
    disable_devicons = false,
  },
  ["tailiscope"] = {
    -- register to copy classes to on selection
    register = "a",
    -- indicates what picker opens when running Telescope tailiscope
    -- can be any file inside of docs dir but most useful opts are
    -- all, base, categories, classes
    -- These are also accesible by running Telescope tailiscope <picker>
    default = "base",
    -- icon indicates an item which can be opened in tailwind docs
    -- can be icon or false
    doc_icon = " ",
    -- if you would prefer to copy with/without class selector
    -- dot is maintained in display to differentiate class from other pickers
    no_dot = true,
    maps = {
      i = {
        back = "<C-h>",
        open_doc = "<C-o>",
      },
      n = {
        back = "b",
        open_doc = "od",
      },
    },
  },
  ["terraform"] = {},
  ["tmux"] = {},
  -- ['ui-select'] = require('telescope.telethemes').get_theme('dropdown'),
  ["yank_history"] = {},
  ["vimwiki"] = {},
  ["z"] = {
    cmd = { "z", "-l" },
    -- cmd = { vim.o.shell, '-c', 'z -l' },
  },
}

local get_extensions = function()
  local extensions = {}
  for ext_name, ext_cfg in pairs(extension_configs) do
    if type(ext_cfg) == "function" then
      extensions[ext_name] = ext_cfg()
    elseif type(ext_cfg) == "table" and not vim.tbl_isempty(ext_cfg) then
      extensions[ext_name] = ext_cfg
    end
  end
  return extensions
end

local load_extensions = function()
  local installed = {}
  for ext_name, _ in pairs(extension_configs) do
    local res = require("telescope").load_extension(ext_name)
    -- vim.dbglog('res', ext_name, #vim.tbl_keys(res))
    table.insert(installed, ext_name)
    -- local ok, err = pcall(telescope.load_extension, ext_name)
    -- if ok then
    -- else
    --   local err_str = vim.split(err, '\n')
    --   local err_msg = 'Error loading telescope plugin: ' .. ext_name .. ' - ' .. err_str[1]
    --   vim.notify(err_msg, 4)
    -- end
  end
  -- TODO: output later or investigate preload messages
  local end_msg = "Loaded "
    .. H.table_len(installed)
    .. " out of "
    .. H.table_len(extension_configs)
    .. " telescope plugins"
  -- vim.notify(end_msg, 2)
end

-- vim.keymap.set("n", "<leader>fS", function()
--         vim.ui.input({ prompt = "Workspace symbols: " }, function(query)
--                 ts.lsp_workspace_symbols({ query = query })
--         end)
-- end, { desc = "LSP workspace symbols" })

return {
  load = load_extensions,
  get = get_extensions,
}

--  FZF Syntax:
--  Token	Match type	Description
--  sbtrkt	fuzzy-match	Items that match sbtrkt
--  'wild	exact-match (quoted)	Items that include wild
--  ^music	prefix-exact-match	Items that start with music
--  .mp3$	suffix-exact-match	Items that end with .mp3
--  !fire	inverse-exact-match	Items that do not include fire
--  !^music	inverse-prefix-exact-match	Items that do not start with music
--  !.mp3$	inverse-suffix-exact-match	Items that do not end with .mp3
--  A single bar character term acts as an OR ope
