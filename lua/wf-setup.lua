local wf = require('wf')
local wfkeys = require('wf-keymap')

-- stylua: ignore
local bookmark_dirs = {
  home     = '~',
  nvim     = '~/.config/nvim',
  plugins  = '~/.local/share/nvim/lazy',
  zinit    = '~/.zinit/plugins',
  reporefs = '~/git/repo-refs',
  macros   = '~/.config/nvim/lua/macros',
  -- snip  = '~/.config/nvim/UltiSnips',
  git      = '~/git',
  ghq      = '~/ghq',
}

local opts = {
  theme = 'space',
  bookmark_dirs = bookmark_dirs,
  behavior = {
    skip_front_duplication = true,
    skip_back_duplication = true,
  },
}

wf.setup(opts)

-- key_group_dict = { "<leader>l"="vimtex", "<leader>e"="conjure" }
-- {prefix_size} `(number)`

wf.setup(opts)
wfkeys.setup_global(opts)
-- wfkeys.timeout(100, wfkeys.which_keys)
-- wfkeys.timeout(100, wfkeys.setup_aucmd)
