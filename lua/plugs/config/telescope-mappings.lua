-- https://raw.githubusercontent.com/nvim-telescope/telescope.nvim/master/README.md
local actions_layout = require("telescope.actions.layout")
local actions = require("telescope.actions")
local custom = require("plugs.config.telescope-custom")

local mainMaps = {
  i = {
    ["<C-u>"] = false,
    ["<C-d>"] = false,
    -- ["<C-h>"] = require("tmux").move_left(),
    -- ["<C-l>"] = require("tmux").move_right(),
    ["<Esc>"] = actions.close,
    ["kj"] = actions.close,
    ["<C-f>"] = custom.actions.results_page_down,
    ["<C-b>"] = custom.actions.results_page_up,
    ["<M-n>"] = custom.actions.results_toggle_down,
    ["<M-p>"] = custom.actions.results_toggle_up,
    ["<CR>"] = actions.select_default + actions.center,
    ["<C-w>"] = actions.send_selected_to_qflist + actions.open_qflist,
    ["<C-q>"] = actions.send_to_qflist + actions.open_qflist + actions.center,
    ["<C-_>"] = actions_layout.toggle_preview,
    ["<M-/>"] = custom.actions.toggle_whichkey,
    ["<C-Down>"] = actions.cycle_history_next,
    ["<C-Up>"] = actions.cycle_history_prev,
    ["<Down>"] = actions.preview_scrolling_down,
    ["<Up>"] = actions.preview_scrolling_up,
    ["<M-a>"] = actions.toggle_all,
    ["<C-Space>"] = custom.actions.find_pickers,
    ["<M-}>"] = custom.actions.switch_picker,
    ["<C-^>"] = custom.actions.switch_layout,
    -- [F1-9] = set primary sort if # not set, toggle primary/secondary if set
    -- [S-F1-9] = add/remove secondary sort #
    -- [??] = clear sort
  },
  n = {
    ["<Esc>"] = actions.close,
  },
}

local fileMaps = {
  i = {
    -- change directory functionality
    ["<M-U>"] = custom.actions.directory_up,
    ["<CR>"] = custom.actions.multi_open,
  },
}
--  TODO: grep live
--  opts.search_dirs -- list of directory to search in
--  opts.grep_open_files -- boolean to restrict search to open files

--[[ tableMerge(baseMaps, fileMaps)
tableMerge(baseMaps, mainMaps) ]]
local mappings = {
  main = mainMaps,
  file_picker = fileMaps,
}
return mappings

--  Z telescope plugin:
--  <CR> (edit)	builtin.find_files    <C-x> (split)	:chdir to the dir
--  <C-v> (vsplit)	:lchdir to the dir  <C-t> (tabedit)	:tchdir to the dir
--  cmd Set command list to execute z -l or compatibles. Default: {vim.o.shell, '-c', 'z -l'}
--  cwd Transform result paths into relative ones with this value as base dir. Default: vim.fn.getcwd()
--  tail_path Show only basename of the path. Default value: false
--  shorten_path Call pathshorten() for each path. Default value: false

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

--  File Browser
--  Insert / Normal	Action
--  <C-f>/f	Toggle between file and folder browser
--  <C-y>/y	Copy (multi-selected) files or folders to cwd
--  <C-d>/dd	Delete (multi-selected) files or folders
--  <C-r>/r	Rename (multi-selected) files
--  <C-e>/e	Add File/Folder at cwd; trailing / creates folder
--       /m	Move multi-selected files to cwd
--  <C-h>/h	Toggle hidden files
--  <C-o>/o	Open file with default system application
--  <C-g>/g	Go to parent directory
--  <C-w>/w	Go to current working directory
--  <A-e>/--	Toggle all entires ignoring ./ and ../
