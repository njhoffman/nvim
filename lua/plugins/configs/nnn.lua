
--  NnnPicker ()-F mode), NnnExplorer (-P mode)

-- Bind NnnExplorer/NnnPicker to toggle the plugin on/off in normal and terminal mode. The commands accept a path as optional argument. To always open nnn in the directory of the currently active buffer, use %:p:h as argument:
-- tnoremap <C-A-n> <cmd>NnnExplorer<CR>
-- nnoremap <C-A-n> <cmd>NnnExplorer %:p:h<CR>
-- tnoremap <C-A-p> <cmd>NnnPicker<CR>
-- nnoremap <C-A-p> <cmd>NnnPicker<CR>
local builtin = require("nnn").builtin
mappings = {
{"<C-t>", builtin.open_in_tab}, -- open file(s) in tab
{"<C-s>", builtin.open_in_split}, -- open file(s) in split
{"<C-v>", builtin.open_in_vsplit}, -- open file(s) in vertical split
{"<C-p>", builtin.open_in_preview}, -- open file in preview split keeping nnn focused
{"<C-y>", builtin.copy_to_clipboard}, -- copy file(s) to clipboard
{"<C-w>", builtin.cd_to_path}, -- cd to file directory
{"<C-e>", builtin.populate_cmdline} -- populate cmdline (:) with file(s)
}
local cfg = {
  explorer = {
    cmd = "nnn -G", -- command overrride (-F1 flag is implied, -a flag is invalid!)
    width = 24, -- width of the vertical split
    side = "topleft", -- or "botright", location of the explorer window
    session = "", -- or "global" / "local" / "shared"
    tabs = true -- seperate nnn instance per tab
  },
  picker = {
    cmd = "tmux new-session nnn -Pp",
    style = {
      border = "rounded",
      width = 0.9, -- width in percentage of the viewport
      height = 0.8, -- height in percentage of the viewport
      xoffset = 0.5, -- xoffset in percentage
      yoffset = 0.5 -- yoffset in percentage
    },
    session = "" -- or "global" / "local" / "shared"
  },
  auto_open = {
    setup = nil, -- or "explorer" / "picker", auto open on setup function
    tabpage = nil, -- or "explorer" / "picker", auto open when opening new tabpage
    empty = false, -- only auto open on empty buffer
    ft_ignore = {
      -- dont auto open for these filetypes
      "gitcommit"
    }
  },
  auto_close = false, -- close tabpage/nvim when nnn is last window
  replace_netrw = nil, -- or "explorer" / "picker"
  mappings = {}, -- table containing mappings, see below
  windownav = {
    -- window movement mappings to navigate out of nnn
    left = "<C-w>h",
    right = "<C-w>l"
  }
}
require("nnn").setup(config)
