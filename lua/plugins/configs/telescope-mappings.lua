local actions_layout = require "telescope.actions.layout"
local actions_set = require "telescope.actions.set"
local actions = require("telescope.actions")
local custom = require("plugins.configs.telescope-custom")

local mainMaps = {
  i = {
    ["<esc>"] = actions.close,
    ["kj"] = actions.close,
    ["<c-f>"] = function(prompt_bufnr)
      actions_set.shift_selection(prompt_bufnr, 15)
    end,
    ["<c-b>"] = function(prompt_bufnr)
      actions_set.shift_selection(prompt_bufnr, -15)
    end,
    ["<a-n>"] = actions.toggle_selection + actions.move_selection_next,
    ["<a-p>"] = actions.toggle_selection + actions.move_selection_previous,
    ["<c-u>"] = false,
    ["<cr>"] = actions.select_default + actions.center,
    -- ["<cr>"] = custom.actions.multi_selection_open,
    ["<c-w>"] = actions.send_selected_to_qflist + actions.open_qflist,
    ["<c-q>"] = actions.send_to_qflist + actions.open_qflist + actions.center,
    ["<c-_>"] = function(prompt_bufnr)
      actions_layout.toggle_preview(prompt_bufnr)
    end,
    ["<C-]>"] = custom.actions.switch_picker_type,
    ["<M-/>"] = function(prompt_bufnr)
      local whichkey_default = {
        max_height = 0.4,
        only_show_current_mode = true,
        mode_width = 1,
        keybind_width = 5,
        name_width = 30,
        line_padding = 1,
        separator = " -> ",
        close_with_action = true,
        normal_hl = "TelescopePrompt",
        border_hl = "TelescopePromptBorder",
        winblend = 15, --  config.values.winblend,
        column_padding = "  "
      }

      local whichkey_opts = {
        name_width = 20,
        separator = " ➜ ",
        column_padding = " "
      }
      actions.which_key(prompt_bufnr, vim.tbl_deep_extend(whichkey_opts, whichkey_default))
    end,
    ["<C-DOWN>"] = actions.cycle_history_next,
    ["<C-UP>"] = actions.cycle_history_prev,
    ["<A-a>"] = actions.toggle_all
  },
  n = {
    ["<esc>"] = actions.close
  }
}

local fileMaps = {
  i = {
    -- change directory functionality
    ["<A-U>"] = custom.actions.directory_up,
    [":bd"] = custom.actions.directory_up,
    ["<cr>"] = custom.actions.multi_selection_open
  }
}
--  TODO: grep live
--  opts.search_dirs -- list of directory to search in
--  opts.grep_open_files -- boolean to restrict search to open files

function tableMerge(t1, t2)
  for k, v in pairs(t2) do
    if type(v) == "table" then
      if type(t1[k] or false) == "table" then
        tableMerge(t1[k] or {}, t2[k] or {})
      else
        t1[k] = v
      end
    else
      t1[k] = v
    end
  end
  return t1
end

--[[ tableMerge(baseMaps, fileMaps)
tableMerge(baseMaps, mainMaps) ]]
local mappings = {
  base = baseMaps,
  main = mainMaps,
  file_picker = fileMaps
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
