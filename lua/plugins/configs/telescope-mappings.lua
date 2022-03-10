local mappings = {}
local actions = require("telescope.actions")
local actions_layout = require "telescope.actions.layout"
local actions_set = require "telescope.actions.set"
local custom_actions = require("plugins.configs.telescope-custom-actions")

mappings.main = {
  i = {
    ["<esc>"] = actions.close,
    ["<c-f>"] = function(prompt_bufnr)
      actions_set.shift_selection(prompt_bufnr, 15)
    end,
    ["<c-b>"] = function(prompt_bufnr)
      actions_set.shift_selection(prompt_bufnr, -15)
    end,
    ["<c-u>"] = false,
    ["<a-n>"] = actions.toggle_selection + actions.move_selection_next,
    ["<a-p>"] = actions.toggle_selection + actions.move_selection_previous,
    ["<cr>"] = actions.select_default + actions.center,
    ["<c-w>"] = actions.send_selected_to_qflist + actions.open_qflist,
    ["<c-q>"] = actions.send_to_qflist + actions.open_qflist + actions.center,
    ["<c-_>"] = function(prompt_bufnr)
      actions_layout.toggle_preview(prompt_bufnr)
    end,
    ["<A-U>"] = custom_actions.switch_picker_type,
    ["<M-/>"] = actions.which_key,
    ["<C-DOWN>"] = require("telescope.actions").cycle_history_next,
    ["<C-UP>"] = require("telescope.actions").cycle_history_prev
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
    ["<esc>"] = actions.close
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
  }
}

mappings.file_picker = {
  i = {
    -- change directory functionality
    ["<C-g>"] = custom_actions.directory_up,
    [":bd"] = custom_actions.directory_up,
    ["<cr>"] = custom_actions.multi_selection_open
  }
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
