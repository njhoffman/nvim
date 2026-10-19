local sorters = require("telescope.sorters")
local H = require("helpers")
local actions = require("telescope.actions")
local mappings = require("configs.telescope.mappings")
local c_actions = require("configs.telescope.actions")

local extension_configs = {
  ["devhints"] = {},
  ["nerdy"] = {},
  ["unicode"] = {},

  ["oldfiles"] = {
    mappings = mappings.file,
    include_current_session = true,
    show_time = true,
    show_size = false,
  },
  ["messages"] = {},
  ["enhanced_find_files"] = {},
  ["egrepify"] = {
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--hidden",
      "--trim", -- add this value
    },
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
    mappings = {
      i = {
        ["<M-lt>"] = c_actions.directory_up,
        ["<M->>"] = c_actions.directory_picker,
        ["<CR>"] = c_actions.multi_open,
        ["<C-Q>"] = function(prompt_bufnr)
          actions.smart_send_to_qflist(prompt_bufnr) -- sends selected, or if none selected, sends all
          vim.cmd.cfirst()
        end,
        ["<M-{>"] = c_actions.switch_grep_pickers_prev,
        ["<M-}>"] = c_actions.switch_grep_pickers_next,
        ["<c-space>"] = actions.to_fuzzy_refine,
        ["<C-z>"] = require("telescope._extensions.egrepify.actions").toggle_prefixes,
        -- toggle AND, AND is default, AND matches tokens and any chars in between
        ["<C-a>"] = require("telescope._extensions.egrepify.actions").toggle_and,
        -- toggle permutations, permutations of tokens is opt-in
        ["<C-r>"] = require("telescope._extensions.egrepify.actions").toggle_permutations,
      },
    },
  },
  ["env"] = {},
  ["filetypes"] = {},
  ["syntax"] = {},
  ["pickers_history"] = {},

  ["find_pickers"] = {},
  ["frecency"] = function()
    --   specify filter like :directory_name: or  :*:'. :etc: -> workspace browser (tab autocompletes)
    local baseDirs = {
      home = vim.fn.expand("$HOME"),
      config = vim.fn.stdpath("config"),
      data = vim.fn.stdpath("data"),
    }

    local frecency_cfg = {
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
        ['zsh']     = baseDirs.home .. '/.shell',
      },
    }
    return frecency_cfg
  end,
  quicknote = {
    defaultScope = "CWD", -- CurrentBuffer, CWD or Global
  },

  ["file_history"] = function()
    local cfg = {
      backup_dir = "~/.file-history-git",
      exclude_ft = { "oil" },
      git_cmd = "git",
    }
    require("file_history").setup(cfg)
  end,
  ["gitops"] = {},
  ["locate"] = {},
  ["tester"] = { example_option = "example_value" },
  ["mapper"] = {
    sorter = sorters.fuzzy_with_index_bias,
  },
  ["options"] = {},
  ["projects"] = {
    workspaces = {
      {
        name = "ghq",
        base_dirs = { {
          path = "~/git",
          max_depth = 2,
        } },
      },
      {
        name = "nvim",
        base_dirs = {
          {
            path = "~/lazy",
            max_depth = 2,
          },
          {
            path = "~/.local/share/nvim/runtime",
            max_depth = 2,
          },
          {
            path = "~/.local/share/nvim/site",
            max_depth = 2,
          },
          {
            path = "~/.local/share/nvim/mason",
            max_depth = 2,
          },
        },
      },
    },
    theme = "dropdown",
  },
  ["helpgrep"] = {
    prompt_title = "Helptags Grep",
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
  ["variables"] = {},
  ["what-key"] = {},

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
    layout_strategy = "bottom_pane",
    layout_config = {
      height = 0.4,
      preview_cutoff = 60,
      preview_width = 0.7,
      prompt_position = "top",
      width = 0.8,
    },
    diff_context_lines = vim.o.scrolloff,
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
  ["git_file_history"] = {
    mappings = {},
    -- If nil, checks xdg-open, open, start, wslview in order.
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
  ["color_names"] = {},
  ["filelinks"] = {},
  ["file_browser"] = {
    theme = "ivy",
    mappings = mappings.file,
  },
  ["fzf"] = {
    fuzzy = true, -- false will only do exact matching
    override_generic_sorter = true, -- override the generic sorter
    override_file_sorter = true, -- override the file sorter
    case_mode = "smart_case", -- or "ignore_case" or "respect_case"
  },
  ["fzy_native"] = {
    override_generic_sorter = false,
    override_file_sorter = false,
  },
  ["gh"] = {},
  ["ghn"] = {},
  ["ghq"] = {},
  ["git_diffs"] = {},
  ["glyph"] = {
    action = function(glyph)
      -- argument glyph is a table: {name, value, category, description}
      vim.fn.setreg("*", glyph.value)
      print([[Press p or "*p to paste this glyph]] .. glyph.value)
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
  },
  ["media"] = {
    backend = "viu", -- image/gif backend
    flags = {
      viu = {
        move = true, -- GIF preview
      },
    },
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
  ["menufacture"] = {},
  ["node_modules"] = {},
  ["npm"] = {},
  ["openbrowser"] = {
    -- Add bookmark urls
    bookmarks = {
      ["luv docs"] = "https://github.com/luvit/luv/blob/master/docs.md",
    },
    bookmark_filepath = "~/.vim/telescope_openbrowser_bookmarks",
  },
  ["recent_files"] = {},
  ["repo"] = {},
  ["smart_open"] = {
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
  ["yank_history"] = {},
  ["vimwiki"] = {},
  ["z"] = {
    cmd = { "z", "-l" },
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
    require("telescope").load_extension(ext_name)
    table.insert(installed, ext_name)
  end
end

return {
  load = load_extensions,
  get = get_extensions,
}
