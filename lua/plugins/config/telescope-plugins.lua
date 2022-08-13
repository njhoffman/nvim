local sorters = require "telescope.sorters"
local tele_mappings = require("plugins.config.telescope-mappings")
local H = require("helpers")
local actions = require("telescope.actions")

local tele_plugs = {
  ["fences"]          = "telescope-fences.nvim",
  ["gotofile"]        = "telescope-gotofiles.nvim",
  ["env"]             = "telescope-env.nvim",
  ["find_pickers"]    = "telescope-find-pickers.nvim",
  ["options"]         = "telescope-options.nvim",
  ["variables"]       = "telescope-variables.nvim",
  ["filetypes"]       = "telescope-filetypes.nvim",
  --
  ["aerial"]          = "aerial.nvim",
  ["arecibo"]         = "telescope-arecibo.nvim",
  ["asynctasks"]      = "telescope-asynctasks.nvim",
  ["bookmarks"]       = "telescope-bookmarks.nvim",
  ["changes"]         = "telescope-changes.nvim",
  ["cheatsheet"]      = "cheatsheet.nvim",
  ["cder"]            = "cder.nvim",
  ["command_palette"] = "telescope-command-palette.nvim",
  ["dap"]             = "telescope-dap.nvim",
  ["file_browser"]    = "telescope-file-browser.nvim",
  ["frecency"]        = "telescope-frecency.nvim",
  ["fzf"]             = "telescope-fzf-native.nvim",
  ["gh"]              = "telescope-github.nvim",
  ["ghn"]             = "github-notifications",
  ["ghq"]             = "telescope-ghq.nvim",
  ["heading"]         = "telescope-heading.nvim",
  ["hop"]             = "telescope-hop.nvim",
  ["howdoi"]          = "howdoi.nvim",
  ["lazygit"]         = "lazygit.nvim",
  ["live_grep_args"]  = "telescope-rg.nvim",
  ["luasnip"]         = "telescope-luasnip.nvim",
  ["mapper"]          = "telescope-mapper.nvim",
  ["media_files"]     = "telescope-media-files.nvim",
  ["neoclip"]         = "nvim-neoclip.lua",
  ["node_modules"]    = "telescope-node-modules.nvim",
  -- ["notify"] = "nvim-notify",
  ["npm"]             = "telescope-npm.nvim",
  ["openbrowser"]     = "telescope-openbrowser.nvim",
  -- ["packer"] = "telescope-packer.nvim",
  ["ports"]           = "telescope-ports.nvim",
  ["project"]         = "telescope-project.nvim",
  ["repo"]            = "telescope-repo.nvim",
  ["session-lens"]    = "session-lens",
  ["tmux"]            = "telescope-tmux.nvim",
  ["ui-select"]       = "telescope-ui-select.nvim",
  ["vimwiki"]         = "telescope-vimwiki.nvim",
  ["z"]               = "telescope-z.nvim"
}

local M = {}
M.extensions = {}
M.load_extensions = function(telescope)
  local installed = {}
  for ext_name, plug_name in pairs(tele_plugs) do
    -- TODO: if pcall(require, plug_name)
    local ok, err = pcall(telescope.load_extension, ext_name)
    if ok then
      table.insert(installed, 0, ext_name)
    else
      local err_str = vim.split(err, "\n")
      local err_msg = "Error loading telescope plugin: " .. ext_name .. " - " .. err_str[1]
      vim.notify(err_msg, "warn")
    end
  end

  local end_msg = "Loaded " ..
    H.table_len(installed) .. " out of " .. H.table_len(tele_plugs) .. " telescope plugins"
  vim.notify(end_msg, "trace")
  return telescope
end

M.extensions.file_browser = {
  theme = "ivy",
  mappings = tele_mappings.file_picker
}

M.extensions.openbrowser = {
  -- Add bookmark urls
  bookmarks = {
    ["luv docs"] = "https://github.com/luvit/luv/blob/master/docs.md"
  },
  bookmark_filepath = "~/.vim/telescope_openbrowser_bookmarks"
}

M.extensions.packer = {
  theme = "ivy",
  layout_config = {
    height = .5
  }
}

M.extensions.howdoi = vim.tbl_deep_extend('force', {
  -- How many answers to return in the response.
  num_answers = 3,
  -- The binary to execute the howdoi command with.
  command_executor = { 'bash', '-c' },
  -- The command to pipe the results into for paging.
  pager_command = 'less -RS',
  -- Mapping	Action
  -- Ctrl + d	Scroll the results down
  -- Ctrl + u	Scroll the results up
  -- Ctrl + y	Yank the results to the clipboard
  -- Ctrl + p	Pastes the results into the current buffer
  -- Ctrl + v	Pastes the results into a new vertical split
  -- Ctrl + x	Pastes the results into a new horizontal split
  -- Ctrl + r	Removes the selected query from the list
}, require('telescope.themes').get_dropdown())

M.extensions.cder = {
  -- Ctrl + d	Scroll the preview down
  -- Ctrl + u	Scroll the preview up
  -- The title of the prompt.
  prompt_title = 'cder',

  -- The command used to generate a list of directories.
  -- Defaults to fd on the home directory.
  -- Example for showing hidden directories:
  --   dir_command = { 'fd', '--hidden', '--type=d', '.', os.getenv('HOME') },
  dir_command = { 'fd', '--type=d', '.', os.getenv('HOME') },

  -- The binary used to execute previewer_command | pager_command.
  -- This is needed because termopen in Neovim does not support piping
  -- multiple commands, so we get around this by just using bash -c.
  command_executer = { 'bash', '-c' },

  -- The command used to preview directories. Defaults to ls.
  previewer_command = 'exa ' ..
    '-a ' ..
    '--color=always ' ..
    '-T ' ..
    '--level=3 ' ..
    '--icons ' ..
    '--git-ignore ' ..
    '--long ' ..
    '--no-permissions ' ..
    '--no-user ' ..
    '--no-filesize ' ..
    '--git ' ..
    '--ignore-glob=.git',

  -- The command used to page directory previews. Defaults to bat.
  -- Receives the output of the previewer_command as input.
  -- Example without bat:
  --   pager_command = 'less -RS'
  pager_command = 'bat --plain --paging=always --pager="less -RS"',

  -- Function to create an entry in the picker given
  -- a line outputted from the dir_command.
  --   value is used as the directory in the :cd command
  --   display is what is actually displayed, so this can
  --     be a function that trims a path prefix for example.
  entry_maker = function(line)
    return {
      value = line,
      display = function(entry)
        return ' ' ..
          line:gsub(os.getenv('HOME') .. '/', ''), {
            { { 1, 3 }, 'Directory' },
          }
      end,
      ordinal = line,
    }
  end,
}

M.extensions["ui-select"] = {
  require("telescope.themes").get_dropdown {
    -- even more opts
  }
  -- pseudo code / specification for writing custom displays, like the one
  -- for "codeactions"
  -- specific_opts = {
  --   [kind] = {
  --     make_indexed = function(items) -> indexed_items, width,
  --     make_displayer = function(widths) -> displayer
  --     make_display = function(displayer) -> function(e)
  --     make_ordinal = function(e) -> string
  --   },
  --   codeactions = false,
  -- }
}

M.extensions.command_palette = {
  {
    "File",
    { "entire selection (C-a)", ':call feedkeys("GVgg")' },
    { "save current file (C-s)", ":w" },
    { "save all files (C-A-s)", ":wa" },
    { "quit (C-q)", ":qa" },
    { "file browser (C-i)", ":lua require'telescope'.extensions.file_browser.file_browser()", 1 },
    { "search word (A-w)", ":lua require('telescope.builtin').live_grep()", 1 },
    { "git files (A-f)", ":lua require('telescope.builtin').git_files()", 1 },
    { "files (C-f)", ":lua require('telescope.builtin').find_files()", 1 }
  }, {
    "Help",
    { "tips", ":help tips" },
    { "cheatsheet", ":help index" },
    { "tutorial", ":help tutor" },
    { "summary", ":help summary" },
    { "quick reference", ":help quickref" },
    { "search help(F1)", ":lua require('telescope.builtin').help_tags()", 1 }
  }, {
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
    { "search highlighting (F12)", ":set hlsearch!" }
  }
}

-- Frecency:
--   Default workspace tag to filter by e.g. 'CWD' to filter by default to the current directory
--   overridden by ':*:'
--   specify filter like :directory_name: or  :*:'.
--   :etc: -> workspace browser (tab autocompletes)
local baseDirs = {
  home = vim.fn.expand("$HOME"),
  config = vim.fn.stdpath("config"),
  data = vim.fn.stdpath("data")
}

M.extensions.frecency = {
  -- default_workspace = "$HOME/.config",
  db_safe_mode = false,
  auto_validate = true,
  show_scores = true,
  show_unindexed = true,
  ignore_patterns = { "*.git/*", "/mnt/*", "*/tmp/*" },
  mappings = tele_mappings.file_picker,
  workspaces = {
    ["etc"] = "/etc",
    ["bin"] = baseDirs.home .. "/bin",
    ["home"] = baseDirs.home,
    ["config"] = baseDirs.home .. "/.config",
    ["nvim"] = baseDirs.config,
    ["plugins"] = baseDirs.home .. "/_/nvim-plugs",
    ["nvim-cache"] = baseDirs.home .. "/_/nvim-cache",
    ["nvim-data"] = baseDirs.data,
    ["prettyfile"] = baseDirs.home .. "/git/prettyfile",
    ["zettel"] = baseDirs.home .. "/zettelkasten",
    ["zk"] = baseDirs.home .. "/zettelkasten",
    ["zinit"] = baseDirs.home .. "/.zinit",
    ["zsh"] = baseDirs.home .. "/.config/zsh"
  }
}

M.extensions.fzf = {
  fuzzy = true, -- false will only do exact matching
  override_generic_sorter = true, -- override the generic sorter
  override_file_sorter = true, -- override the file sorter
  case_mode = "smart_case" -- or "ignore_case" or "respect_case"
}

M.extensions.bookmarks = {
  selected_browser = "chrome",
  url_open_command = "xdg-open",
  url_open_plugin = nil, -- vim_external, open_browser
  firefox_profile_name = nil
}

M.extensions.live_grep_args = {
  auto_quoting = true, -- enable/disable auto-quoting,
  mappings = {
    -- ... Your other configuration ...
    --[[ ['<C-Space>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    },
    ["<c-f>"] = function(prompt_bufnr)
      actions_set.shift_selection(prompt_bufnr, 10)
    end,
    ["<c-b>"] = function(prompt_bufnr)
      actions_set.shift_selection(prompt_bufnr, -10)
    end, ]]
    ["<c-u>"] = false,
    ["<a-n>"] = actions.toggle_selection + actions.move_selection_next,
    ["<a-p>"] = actions.toggle_selection + actions.move_selection_previous,
    ["<cr>"] = actions.select_default + actions.center
  }
}

M.extensions.media_files = {
  filetypes = { "png", "webp", "jpg", "jpeg", "webm", "pdf", "mp4", "svg", "mpv", "mkv" },
  find_cmd = "fd" -- find command (defaults to `fd`)
  -- sudo apt install uberzug ffmpegthumbnailer poppler-utils epub-utils
  -- font-viewer (fontpreview)? fd, rg, etc
}

M.extensions.z = {
  cmd = { 'z', '-l' },
  -- cmd = { vim.o.shell, '-c', 'z -l' },
}


M.extensions.arecibo = {
  ["selected_engine"] = "google",
  ["url_open_command"] = "xdg-open",
  ["show_http_headers"] = false,
  ["show_domain_icons"] = true
}


M.extensions.project = {
  --[[ base_dirs = {
    '~/dev/src',
    {'~/dev/src2'},
    {'~/dev/src3', max_depth = 4},
    {path = '~/dev/src4'},
    {path = '~/dev/src5', max_depth = 2},
  }, ]]
  base_dirs = {
    {
      path = "~/git",
      max_depth = 4
    },
    {
      path = "~/ghq",
      max_depth = 4
    }
  },
  hidden_files = true,
  theme = "dropdown"
}

M.extensions.mapper = {
  sorter = sorters.fuzzy_with_index_bias
  -- sorter = sorters.highlighter_only
}
return M

-- local packer_attach = function(prompt_bufnr, map)
--   local actions = require "telescope.actions"
--   local builtin = require("telescope.builtin")
--   local action_state = require "telescope.actions.state"
--   actions.select_default:replace(
--     function()
--       local selection = action_state.get_selected_entry()
--       actions.close(prompt_bufnr)
--       vim.cmd(string.format(":e %s", selection.readme))
--     end
--   )

--   local Job = require "plenary.job"
--   local open_online = function()
--     local selection = action_state.get_selected_entry()
--     actions._close(prompt_bufnr)
--     local cmd =
--     vim.fn.has "win32" == 1 and "explorer" or vim.fn.has "mac" == 1 and "open" or "xdg-open"
--     local url =
--     vim.fn.trim(vim.fn.system(string.format("git -C %s ls-remote --get-url", selection.path)))
--     Job:new({ command = cmd, args = { url } }):start()
--   end

--   local open_finder = function(prompt_bufnr)
--     local selection = action_state.get_selected_entry()
--     actions._close(prompt_bufnr, true)
--     builtin.find_files({ cwd = selection.path })
--   end

--   local open_browser = function(prompt_bufnr)
--     local ok, file_browser = pcall(require, "telescope._extensions.file_browser")
--     if not ok then
--       vim.notify(
--         "nvim-telescope/telescope-file-browser.nvim is required to use this action",
--         vim.log.levels.ERROR,
--         { title = "Telescope" }
--       )
--       return
--     end
--     local selection = action_state.get_selected_entry()
--     actions._close(prompt_bufnr, true)
--     file_browser.exports.file_browser({ cwd = selection.path })
--   end

--   local open_grep = function(prompt_bufnr)
--     local selection = action_state.get_selected_entry()
--     actions._close(prompt_bufnr, true)
--     builtin.live_grep({ cwd = selection.path })
--   end

--   vim.api.nvim_set_keymap(prompt_bufnr, "i", "<C-e>", open_online)
--   vim.api.nvim_set_keymap(prompt_bufnr, "i", "<C-i>", open_finder)
--   vim.api.nvim_set_keymap(prompt_bufnr, "i", "<C-x>", open_browser)
--   vim.api.nvim_set_keymap(prompt_bufnr, "i", "<C-g>", open_grep)
-- end
