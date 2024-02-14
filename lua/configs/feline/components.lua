local provider_project = require('configs.feline.provider-project')
local provider_git = require('configs.feline.provider-git')
local provider_lsp_references = require('configs.feline.provider-lsp-references')
-- local provider_lsp_code_actions = require('configs.feline.provider-lsp-code-actions')
local provider_helptags = require('configs.feline.provider-helptags')
local provider_line_count = require('configs.feline.provider-line_count')

local M = {}

M.HelpTagsComponent = {
  enabled = function()
    return vim.bo.filetype == 'lua'
  end,
  provider = {
    name = 'helptags',
    update = { 'User' },
    opts = { pattern = 'StatusCountHelp' },
  },
  hl = provider_helptags.provider_hl,
  left_sep = {
    str = '',
    hl = {
      fg = 'NONE',
    },
  },
  right_sep = {
    str = '',
    hl = {
      fg = 'NONE',
    },
  },
}

-- M.LspCodeActionsComponent = {
--   enabled = function()
--     local ft_enabled = { 'lua', 'sh', 'typescript', 'javascript', 'go', 'python' }
--     return vim.tbl_contains(ft_enabled, vim.bo.filetype) and #vim.lsp.get_active_clients() > 0
--   end,
--   provider = {
--     name = 'lsp_code_actions',
--     update = { 'User' },
--     opts = {},
--   },
--   hl = provider_lsp_code_actions.hl,
--   left_sep = {
--     str = ' ',
--     hl = {
--       fg = 'NONE',
--     },
--   },
-- }

M.LspReferencesComponent = {
  enabled = function()
    local ft_enabled = { 'lua', 'sh', 'typescript', 'javascript', 'go', 'python' }
    return vim.tbl_contains(ft_enabled, vim.bo.filetype) and #vim.lsp.get_active_clients() > 0
  end,
  provider = {
    name = 'lsp_references',
    update = { 'User' },
    opts = {},
  },
  hl = provider_lsp_references.hl,
  left_sep = {
    str = ' ',
    hl = {
      fg = 'NONE',
    },
  },
  right_sep = {
    str = '',
    hl = {
      fg = 'NONE',
    },
  },
}

M.NeoComposerComponent = {
  enabled = true,
  provider = {
    name = 'neocomposer',
    update = { 'RecordingEnter', 'RecordingLeave' },
    opts = {},
  },
  hl = {
    fg = '#333344',
  },
  left_sep = {
    str = ' ',
    hl = {
      fg = 'NONE',
    },
  },
}

-- Display <e> 0x65
M.AsciiComponent = {
  hl = { fg = '#486088' },
  -- enabled = function()
  --   return vim.api.nvim_win_get_width(0) > 120
  -- end,
  provider = {
    -- %b\ 0x%B
    name = 'ascii',
    update = { 'CursorMoved' },
  },
  left_sep = ' ',
  right_sep = ' ',
}

M.ProjectComponent = {
  enabled = true,
  provider = {
    name = 'project',
    opts = {},
    -- update = { 'WinClosed', 'BufDelete' }
  },
  { ' ' },
  hl = provider_project.hl,
  left_sep = provider_project.left_sep,
  { ' ' },
  right_sep = provider_project.right_sep,
}

M.GitBranchComponent = {
  provider = provider_git.git_branch,
  hl = {
    fg = '#3696c2',
    style = 'bold',
  },
  left_sep = {
    str = '  ',
    hl = {
      fg = 'NONE',
    },
  },
  right_sep = {
    str = ' ',
    hl = {
      fg = 'NONE',
    },
  },
}

M.GitDiffAddedComponent = {
  provider = provider_git.git_diff_added,
  hl = {
    fg = '#129A77',
    bg = 'black',
  },
}

M.GitDiffChangedComponent = {
  provider = provider_git.git_diff_changed,
  hl = {
    fg = '#6191f1',
    bg = 'black',
  },
}

M.GitDiffRemovedComponent = {
  provider = provider_git.git_diff_removed,
  hl = {
    fg = '#8F313A',
    bg = 'black',
  },
}

M.ScrollBarComponent = {
  provider = 'scroll_bar',
  left_sep = {
    str = ' ',
    hl = {
      fg = 'NONE',
      bg = 'black',
    },
  },
  hl = {
    fg = 'skyblue',
    style = 'bold',
  },
}

M.FiletypeComponent = {
  -- Enable if current window width is higher than 100
  enabled = function()
    return vim.api.nvim_win_get_width(0) > 120
  end,
  hl = { fg = '#988088' },
  provider = {
    name = 'file_type',
    opts = { case = 'lowercase' },
  },
  left_sep = ' ',
  right_sep = '',
}

-- global components
local invi_sep = { str = ' ', hl = { fg = 'black', bg = 'black' } }

M.NoiceComponent = {
  enabled = function()
    return package.loaded['noice'] and require('noice').api.status.mode.has()
  end,
  update = function()
    return require('noice').api.status.mode.has()
  end,
  provider = function()
    return tostring(require('noice').api.status.mode.get())
  end,
  left_sep = { str = ' ', hl = { bg = 'base' } },
  hl = function()
    return {
      name = require('feline.providers.vi_mode').get_mode_highlight_name(),
      fg = require('feline.providers.vi_mode').get_mode_color(),
      bg = 'base',
    }
  end,
  priority = 1,
}

M.LinePercentageComponent = {
  provider = 'line_percentage',
  hl = { fg = '#4477aa', bg = 'bg', style = 'none' },
  left_sep = ' ',
}

vim.opt.showcmdloc = 'statusline'

M.FelineCmdComponent = {
  enabled = function()
    return vim.api.nvim_get_option_value('showcmd', {}) == true
      and vim.api.nvim_get_option_value('showcmdloc', {}) == 'statusline'
  end,
  provider = '%S',
  -- provider = ':%3.5(%S%)',
  left_sep = ' ',
  right_sep = ' ',
  hl = { name = 'FelineCMD', fg = 'gray' },
  -- priority = -9,
  -- truncate_hide = true,
}

-- macro
M.MacroComponent = {
  provider = 'macro',
  enabled = function()
    return vim.api.nvim_get_option('cmdheight') == 0
  end,
  hl = { fg = 'orange', bg = 'base' },
  left_sep = invi_sep,
}

-- search count
M.SearchCountComponent = {
  provider = 'search_count',
  enabled = function()
    return vim.api.nvim_get_option('cmdheight') == 0
  end,
  hl = {
    fg = 'cyan',
    bg = 'black',
  },
  left_sep = invi_sep,
}

M.LineCountComponent = {
  enabled = function()
    return vim.api.nvim_win_get_width(0) > 80
  end,
  hl = provider_line_count.get_hl,
  update = provider_line_count.update,
  provider = 'line_count',
  left_sep = '',
  right_sep = ' ',
}

M.ViMode = {
  -- get vim current mode, this information will be required by the provider
  -- and the highlight functions, so we compute it only once per component
  -- evaluation and store it as a component attribute
  init = function(self)
    self.mode = vim.fn.mode(1) -- :h mode()
  end,
  -- Now we define some dictionaries to map the output of mode() to the
  -- corresponding string and color. We can put these into `static` to compute
  -- them at initialisation time.
  static = {
    mode_names = { -- change the strings if you like it vvvvverbose!
      n = 'N',
      no = 'N?',
      nov = 'N?',
      noV = 'N?',
      ['no\22'] = 'N?',
      niI = 'Ni',
      niR = 'Nr',
      niV = 'Nv',
      nt = 'Nt',
      v = 'V',
      vs = 'Vs',
      V = 'V_',
      Vs = 'Vs',
      ['\22'] = '^V',
      ['\22s'] = '^V',
      s = 'S',
      S = 'S_',
      ['\19'] = '^S',
      i = 'I',
      ic = 'Ic',
      ix = 'Ix',
      R = 'R',
      Rc = 'Rc',
      Rx = 'Rx',
      Rv = 'Rv',
      Rvc = 'Rv',
      Rvx = 'Rv',
      c = 'C',
      cv = 'Ex',
      r = '...',
      rm = 'M',
      ['r?'] = '?',
      ['!'] = '!',
      t = 'T',
    },
    mode_colors = {
      n = 'red',
      i = 'green',
      v = 'cyan',
      V = 'cyan',
      ['\22'] = 'cyan',
      c = 'orange',
      s = 'purple',
      S = 'purple',
      ['\19'] = 'purple',
      R = 'orange',
      r = 'orange',
      ['!'] = 'red',
      t = 'red',
    },
  },
  -- We can now access the value of mode() that, by now, would have been
  -- computed by `init()` and use it to index our strings dictionary.
  -- note how `static` fields become just regular attributes once the
  -- component is instantiated.
  -- To be extra meticulous, we can also add some vim statusline syntax to
  -- control the padding and make sure our string is always at least 2
  -- characters long. Plus a nice Icon.
  provider = function(self)
    return ' %2(' .. self.mode_names[self.mode] .. '%)'
  end,
  -- Same goes for the highlight. Now the foreground will change according to the current mode.
  hl = function(self)
    local mode = self.mode:sub(1, 1) -- get only the first mode character
    return { fg = self.mode_colors[mode], bold = true }
  end,
  -- Re-evaluate the component only on ModeChanged event!
  -- Also allows the statusline to be re-evaluated when entering operator-pending mode
  update = {
    'ModeChanged',
    pattern = '*:*',
    callback = vim.schedule_wrap(function()
      vim.cmd('redrawstatus')
    end),
  },
}
return M
