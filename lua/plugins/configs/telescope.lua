local sorters = require "telescope.sorters"
local previewers = require "telescope.previewers"
local telescope = require("telescope")
local actions = require("telescope.actions")
local action_set = require "telescope.actions.set"
local layout_actions = require "telescope.actions.layout"
local action_state = require('telescope.actions.state')
local H = require("helpers")

-- TODO: why can't replicate fuzzy matching behavior of fzf-lua
-- TODO: calculate page length for ctrl-f/ctrl-b

local custom_actions = {}
function custom_actions._multiopen(prompt_bufnr, open_cmd)
  local picker = action_state.get_current_picker(prompt_bufnr)
  local num_selections = #picker:get_multi_selection()
  if num_selections > 1 then
    local cwd = picker.cwd
    if cwd == nil then
      cwd = ""
    else
      cwd = string.format("%s/", cwd)
    end
    vim.cmd("bw!") -- wipe the prompt buffer
    for _, entry in ipairs(picker:get_multi_selection()) do
      vim.cmd(string.format("%s %s%s", open_cmd, cwd, entry.value))
    end
    vim.cmd('stopinsert')
  else
    if open_cmd == "vsplit" then
      actions.file_vsplit(prompt_bufnr)
    elseif open_cmd == "split" then
      actions.file_split(prompt_bufnr)
    elseif open_cmd == "tabe" then
      actions.file_tab(prompt_bufnr)
    else
      actions.select_default(prompt_bufnr)
      -- actions.file_edit(prompt_bufnr)
    end
  end
end

function custom_actions.multi_selection_open_vsplit(prompt_bufnr)
  custom_actions._multiopen(prompt_bufnr, "vsplit")
end
function custom_actions.multi_selection_open_split(prompt_bufnr)
  custom_actions._multiopen(prompt_bufnr, "split")
end
function custom_actions.multi_selection_open_tab(prompt_bufnr)
  custom_actions._multiopen(prompt_bufnr, "tabe")
end
function custom_actions.multi_selection_open(prompt_bufnr)
  custom_actions._multiopen(prompt_bufnr, "edit")
end


local telescopeConfig = {
  defaults = {
    vimgrep_arguments = {
      "rg",
      -- "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--hidden",
      "--column",
      "--smart-case",
      "--vimgrep",
    },
    find_command = { "rg", "--ignore", "--hidden", "--files", "prompt_prefix=🔍" },
    hidden = true,
    no_ignore = false,
    layout_config = {
      bottom_pane = {
        height = 25,
        preview_cutoff = 100,
        prompt_position = "top"
      },
      center = {
        preview_height = 0.5,
        height = 0.4,
        preview_cutoff = 40,
        prompt_position = "top",
        width = 0.5
      },
      cursor = {
        height = 0.9,
        preview_cutoff = 40,
        width = 0.8
      },
      horizontal = {
        height = 0.9,
        prompt_position = "bottom",
        width = 0.8,
        preview_cutoff = 80,
        prompt_position = "top",
        preview_width = 0.5,

      },
      vertical = {
        height = 0.9,
        preview_cutoff = 40,
        width = 0.8,
        prompt_position = "top",
        mirror = true,
        preview_height = 0.5,
      },
      flex = { flip_columns = 130 },

    },
    dynamic_preview_title = true,
    prompt_prefix = "λ ",
    selection_caret = "▶ ",
    selection_strategy = "reset", -- follow, reset, row
    sorting_strategy = "ascending",
    layout_strategy = "flex", -- flex, horizontal, veritical, center
    scroll_strategy = "cycle",
    color_devicons = true,
    winblend = 15,
    mappings = {
      i = {
        ["<esc>"] = actions.close,
        ["<c-f>"] = function(prompt_bufnr) action_set.shift_selection(prompt_bufnr, 15) end,
        ["<c-b>"] = function(prompt_bufnr) action_set.shift_selection(prompt_bufnr, -15) end,
        ["<c-u>"] = false,
        ["<a-n>"] = actions.toggle_selection + actions.move_selection_next,
        ["<a-p>"] = actions.toggle_selection + actions.move_selection_previous,
        -- ["<cr>"] = actions.select_default + actions.center,
        ["<cr>"] = custom_actions.multi_selection_open,
        ["<c-w>"] = actions.send_selected_to_qflist + actions.open_qflist,
        ["<c-q>"] = actions.send_to_qflist + actions.open_qflist + actions.center,
        ["<c-_>"] = function(prompt_bufnr) layout_actions.toggle_preview(prompt_bufnr) end,
        -- ["<tab>"] = actions.toggle_selection + actions.move_selection_next,
        -- ["<s-tab>"] = actions.toggle_selection + actions.move_selection_previous,
        -- ["<C-h>"] = actions.goto_file_selection_split,
        -- ["<C-v>"] = actions.goto_file_selection_vsplit
        -- ["<c-v>"] = custom_actions.multi_selection_open_vsplit,
        -- ["<c-s>"] = custom_actions.multi_selection_open_split,
        -- ["<c-t>"] = custom_actions.multi_selection_open_tab,
        -- ['<A- >'] = actions.toggle,
      },
      n = {
        ["<esc>"] = actions.close,
        -- ["<c-j>"] = actions.move_selection_next,
        -- ["<c-k>"] = actions.move_selection_previous,
        -- ["<C-w>"] = actions.send_selected_to_qflist,
        -- ["<C-q>"] = actions.send_to_qflist,
        -- ["<c-f>"] = function(prompt_bufnr) action_set.shift_selection(prompt_bufnr, 15) end,
        -- ["<c-b>"] = function(prompt_bufnr) action_set.shift_selection(prompt_bufnr, -15) end,
        -- ["<tab>"] = actions.toggle_selection + actions.move_selection_next,
        -- ["<s-tab>"] = actions.toggle_selection + actions.move_selection_previous,
        -- ["<cr>"] = custom_actions.multi_selection_open,
        -- ["<c-v>"] = custom_actions.multi_selection_open_vsplit,
        -- ["<c-s>"] = custom_actions.multi_selection_open_split,
        -- ["<c-t>"] = custom_actions.multi_selection_open_tab,
        -- ["<tab>"] = actions.toggle_selection + actions.move_selection_next,
        -- ["<s-tab>"] = actions.toggle_selection + actions.move_selection_previous,
      },
    },
    file_sorter =  require'telescope.sorters'.get_fuzzy_file,
    -- file_previewer = previewers.vim_buffer_cat.new,
    generic_sorter = require"telescope.sorters".get_generic_fuzzy_sorter,
    -- generic_sorter = require"telescope.sorters".generic_sorter,
    grep_previewer = previewers.vim_buffer_vimgrep.new,
    qflist_previewer = previewers.vim_buffer_qflist.new,
    include_extensions = true,
    path_display = { "absolute" }, -- tail, hidden, absolute, shorten
    file_ignore_patterns = {},
    preview = {
      check_mime_type = true,
      filesize_limit = 25,
      timeout = 1500,            -- default 250
      treesitter = true,
      msg_bg_fillchar = "╱",
      hide_on_startup = false,
    },
  },

  pickers = {
    find_files = {
      find_command = { "fd", "--type", "f", "--strip-cwd-prefix" },
      mappings = {
        n = {
          -- change directory functionality
          ["cd"] = function(prompt_bufnr)
            local selection = require("telescope.actions.state").get_selected_entry()
            local dir = vim.fn.fnamemodify(selection.path, ":p:h")
            require("telescope.actions").close(prompt_bufnr)
            -- Depending on what you want put `cd`, `lcd`, `tcd`
            vim.cmd(string.format("silent lcd %s", dir))
          end
        }
      }
    },
  },
  extensions = {},
}


-- You don't need to set any of these options.
telescopeConfig.extensions.file_browser = {
  theme = "ivy",
  mappings = {
    ["i"] = {
      -- your custom insert mode mappings
    },
    ["n"] = {
      -- your custom normal mode mappings
    },
  },
-- Insert / Normal	Action
-- <C-f>/f	Toggle between file and folder browser
-- <C-y>/y	Copy (multi-selected) files or folders to cwd
-- <C-d>/dd	Delete (multi-selected) files or folders
-- <C-r>/r	Rename (multi-selected) files
-- <C-e>/e	Add File/Folder at cwd; trailing / creates folder
--      /m	Move multi-selected files to cwd
-- <C-h>/h	Toggle hidden files
-- <C-o>/o	Open file with default system application
-- <C-g>/g	Go to parent directory
-- <C-w>/w	Go to current working directory
-- <A-e>/--	Toggle all entires ignoring ./ and ../
}

telescopeConfig.extensions.frecency = {
  -- db_safe_mode = false,
  show_scores = true,
  show_unindexed = true,
  -- Default workspace tag to filter by e.g. 'CWD' to filter by default to the current directory
  -- overridden by ':*:'
  -- default_workspace = 'CWD',

  ignore_patterns = { "*.git/*", "*/tmp/*" },
  -- specify filter like :directory_name: or  :*:'.
  -- :etc: -> workspace browser (tab autocompletes)
  workspaces = {
    ["etc"]        = "/etc",
    ["bin"]        = vim.fn.expand("$HOME") .. "/bin",
    ["nvim"]       = vim.fn.stdpath('config'),
    ["plugins"]    = vim.fn.stdpath('data') .. "/site/pack/packer/start",
    ["nvim-cache"] = vim.fn.stdpath('config'),
    ["nvim-data"]  = vim.fn.stdpath('data'),
    ["prettyfile"] = vim.fn.expand("$HOME") .. "/git/prettyfile",
    ["zettel"]     = vim.fn.expand("$HOME") .. "/zettelkasten",
    ["zk"]         = vim.fn.expand("$HOME") .. "/zettelkasten",
    ["zinit"]      = vim.fn.expand("$HOME") .. "/.zinit",
    ["zsh"]        = vim.fn.expand("$HOME") .. "/.config/zsh",
  },
}

telescopeConfig.extensions.fzf = {
  fuzzy = true, -- false will only do exact matching
  override_generic_sorter = true, -- override the generic sorter
  override_file_sorter = true, -- override the file sorter
  case_mode = "smart_case", -- or "ignore_case" or "respect_case"
}

telescopeConfig.extensions.bookmarks = {
  selected_browser = "google_chrome",
  url_open_command = "xdg-open",
  url_open_plugin = nil, -- vim_external, open_browser
  firefox_profile_name = nil,
}

telescopeConfig.extensions.media_files = {
  filetypes = { "png", "webp", "jpg", "jpeg", "webm", "pdf", "mp4" },
  find_cmd = "rg", -- find command (defaults to `fd`)
}

telescopeConfig.extensions.arecibo = {
  ["selected_engine"] = "google",
  ["url_open_command"] = "xdg-open",
  ["show_http_headers"] = false,
  ["show_domain_icons"] = true,
}

telescopeConfig.extensions.lsp_handlers = {
  disable = {},
  location = { telescope = {}, no_results_message = "No references found" },
  symbol = { telescope = {}, no_results_message = "No symbols found" },
  call_hierarchy = { telescope = {}, no_results_message = "No calls found" },
  code_action = {
    telescope = require("telescope.themes").get_dropdown({}),
    no_results_message = "No code actions available",
    prefix = "",
  },
}

telescopeConfig.extensions.mapper = {
  sorter = sorters.fuzzy_with_index_bias
  -- sorter = sorters.highlighter_only
}

telescope.setup(telescopeConfig)


if H.is_plugin_installed("aerial.nvim") then telescope.load_extension("aerial") end
if H.is_plugin_installed("telescope-arecibo.nvim") then telescope.load_extension("arecibo") end
if H.is_plugin_installed("telescope-asynctasks.nvim") then telescope.load_extension("asynctasks") end
if H.is_plugin_installed("telescope-bookmarks.nvim") then telescope.load_extension("bookmarks") end
if H.is_plugin_installed("telescope-dap.nvim") then telescope.load_extension("dap") end
if H.is_plugin_installed("telescope-frecency.nvim") then telescope.load_extension("frecency") end
if H.is_plugin_installed("telescope-ghq.nvim") then telescope.load_extension("ghq") end
if H.is_plugin_installed("telescope-github.nvim") then telescope.load_extension("gh") end
if H.is_plugin_installed("telescope-node-modules.nvim") then telescope.load_extension("node_modules") end

if H.is_plugin_installed("telescope-media-files.nvim") then telescope.load_extension("media_files") end
if H.is_plugin_installed("telescope-tmux.nvim") then telescope.load_extension("tmux") end
-- if H.is_plugin_installed("telescope-ultisnips.nvim") then telescope.load_extension("ultisnips") end
if H.is_plugin_installed("session-lens") then telescope.load_extension("session-lens") end

if H.is_plugin_installed("nvim-notify") then telescope.load_extension("notify") end

if H.is_plugin_installed("telescope-z.nvim") then
  telescope.load_extension("z")
  --   <CR> (edit)	builtin.find_files    <C-x> (split)	:chdir to the dir
  --   <C-v> (vsplit)	:lchdir to the dir  <C-t> (tabedit)	:tchdir to the dir
  -- cmd Set command list to execute z -l or compatibles. Default: {vim.o.shell, '-c', 'z -l'}
  -- cwd Transform result paths into relative ones with this value as base dir. Default: vim.fn.getcwd()
  -- tail_path Show only basename of the path. Default value: false
  -- shorten_path Call pathshorten() for each path. Default value: false
end

if H.is_plugin_installed("cheatsheet.nvim") then require("plugins.configs.telescope-cheatsheet") end
-- if H.is_plugin_installed("telescope-lsp-handlers.nvim") then require("plugins.configs.telescope-lsp-handlers") end

if H.is_plugin_installed("nvim-neoclip.lua") then
  require("plugins.configs.nvim-neoclip")
  telescope.load_extension("neoclip")
end

if H.is_plugin_installed("telescope-heading.nvim") then
  pcall(telescope.load_extension, "heading")
end


pcall(telescope.load_extension, "file_browser")
pcall(telescope.load_extension, "fzf")
--  FZF Syntax:
-- Token	Match type	Description
-- sbtrkt	fuzzy-match	Items that match sbtrkt
-- 'wild	exact-match (quoted)	Items that include wild
-- ^music	prefix-exact-match	Items that start with music
-- .mp3$	suffix-exact-match	Items that end with .mp3
-- !fire	inverse-exact-match	Items that do not include fire
-- !^music	inverse-prefix-exact-match	Items that do not start with music
-- !.mp3$	inverse-suffix-exact-match	Items that do not end with .mp3
-- A single bar character term acts as an OR ope

if H.is_plugin_installed("telescope-vimwiki.nvim") then
  pcall(telescope.load_extension, "vimwiki")
end

if H.is_plugin_installed("nvim-mapper") then
  require("plugins.configs.nvim_mapper")
  pcall(telescope.load_extension, "mapper")
end

if H.is_plugin_installed("project.nvim") then
  require("plugins.configs.project_nvim")
  pcall(telescope.load_extension, "projects")
end

if H.is_plugin_installed("nvim-notify") then telescope.load_extension("notify") end

if H.is_plugin_installed("telescope-ui-select.nvim") then
  pcall(telescope.load_extension, "ui-select")
end

if H.is_plugin_installed("telescope-hop.nvim") then
  pcall(telescope.load_extension, "hop")
end

-- if H.is_plugin_installed("telescope-packer.nvim") then
--   pcall(telescope.load_extension, 'packer')
--   pcall(telescope.extensions.packer.plugins, {})
-- end

if H.is_plugin_installed("telescope-rg.nvim") then
  pcall(telescope.load_extension, "rg")
end

if H.is_plugin_installed("github-notifications") then
  pcall(telescope.load_extension, "ghn")
end


if H.is_plugin_installed("telescope-npm.nvim") then
  pcall(telescope.load_extension, "npm")
end


-- sorters.fuzzy_with_index_bias = function(opts)
--   opts = opts or {}
--   opts.ngram_len = 2

--   -- TODO: Probably could use a better sorter here.
--   local fuzzy_sorter = sorters.get_generic_fuzzy_sorter(opts)

--   return Sorter:new {
--     scoring_function = function(_, prompt, _, entry)
--       local base_score = fuzzy_sorter:score(prompt, entry)

--       if base_score == -1 then
--         return -1
--       end

--       if base_score == 0 then
--         return entry.index
--       else
--         return math.min(math.pow(entry.index, 0.25), 2) * base_score
--       end
--     end,
--   }
-- end



-- sorters.get_generic_fuzzy_sorter = function(opts)
--   opts = opts or {}

--   local ngram_len = opts.ngram_len or 2

--   local cached_ngrams = {}
--   local function overlapping_ngrams(s, n)
--     if cached_ngrams[s] and cached_ngrams[s][n] then
--       return cached_ngrams[s][n]
--     end

--     local R = {}
--     for i = 1, s:len() - n + 1 do
--       R[#R + 1] = s:sub(i, i + n - 1)
--     end

--     if not cached_ngrams[s] then
--       cached_ngrams[s] = {}
--     end

--     cached_ngrams[s][n] = R

--     return R
--   end

--   return Sorter:new {
--     -- self
--     -- prompt (which is the text on the line)
--     -- line (entry.ordinal)
--     -- entry (the whole entry)
--     scoring_function = function(_, prompt, line, _)
--       if prompt == 0 or #prompt < ngram_len then
--         return 1
--       end

--       local prompt_lower = prompt:lower()
--       local line_lower = line:lower()

--       local prompt_ngrams = overlapping_ngrams(prompt_lower, ngram_len)

--       local N = #prompt

--       local contains_string = line_lower:find(prompt_lower, 1, true)

--       local consecutive_matches = 0
--       local previous_match_index = 0
--       local match_count = 0

--       for i = 1, #prompt_ngrams do
--         local match_start = line_lower:find(prompt_ngrams[i], 1, true)
--         if match_start then
--           match_count = match_count + 1
--           if match_start > previous_match_index then
--             consecutive_matches = consecutive_matches + 1
--           end

--           previous_match_index = match_start
--         end
--       end

--       -- TODO: Copied from ashkan.
--       local denominator = (
--           (10 * match_count / #prompt_ngrams)
--           -- biases for shorter strings
--           -- TODO(ashkan): this can bias towards repeated finds of the same
--           -- subpattern with overlapping_ngrams
--           + 3 * match_count * ngram_len / #line
--           + consecutive_matches
--           + N / (contains_string or (2 * #line)) -- + 30/(c1 or 2*N)

--         )

--       if denominator == 0 or denominator ~= denominator then
--         return -1
--       end

--       if #prompt > 2 and denominator < 0.5 then
--         return -1
--       end

--       return 1 / denominator
--     end,

--     highlighter = opts.highlighter or function(_, prompt, display)
--       return ngram_highlighter(ngram_len, prompt, display)
--     end,
--   }
-- end



-- -- telescope-config.lua
-- local M = {}

-- M.project_files = function()
--   local opts = {} -- define here if you want to define something
--   local ok = pcall(require"telescope.builtin".git_files, opts)
--   if not ok then require"telescope.builtin".find_files(opts) end
-- end

-- return M

-- call via:
-- :lua require"telescope-config".project_files()

-- example keymap:
-- vim.api.nvim_set_keymap("n", "<Leader><Space>", "<CMD>lua require'telescope-config'.project_files()<CR>", {noremap = true, silent = true})

-- -- new lsp instructions
-- https://alpha2phi.medium.com/neovim-lsp-and-dap-using-lua-3fb24610ac9f

-- For anyone looking for a basic fzf-type multiselection, where:

-- <CR> with selections <= 1 opens a file for editing
-- <CR> with selections > 1 opens the quick fix window (currently doesn't open the file for editing)
-- I've done the following:

-- local actions = require("telescope.actions")
-- local action_state = require("telescope.actions.state")

-- local custom_actions = {}

-- function custom_actions.fzf_multi_select(prompt_bufnr)
--   local picker = action_state.get_current_picker(prompt_bufnr)
--   local num_selections = table.getn(picker:get_multi_selection())

--   if num_selections > 1 then
--     -- actions.file_edit throws - context of picker seems to change
--     -- actions.file_edit(prompt_bufnr)
--     actions.send_selected_to_qflist(prompt_bufnr)
--     actions.open_qflist()
--   else
--     actions.file_edit(prompt_bufnr)
--   end
-- end
