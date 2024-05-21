local opts = {
  treesitter_textobjects = true,
  serendipity = {
    highlight = 'guibg=LightCyan guifg=none',
  },
}

local cfg = {
  treesitter_textobjects = true,
  mappings = {
    save = '<leader>vs',
    docs = '<leader>vK',
    to_normal = 'jk',
  },
  commands = {
    save = {
      pre_amend = { '<sde>', '<esc>', '<cmd>w<cr>' }, -- <sde> is for exiting serendipity, also <sdi> for init it and <sdt> for toggling
      post_amend = {},
      modes = { 'sd', 'v' }, -- "sd", "v", or "n"
      amend = false, -- if true, also run the original keymap
      countable = false, -- can this mapping be counted (e.g. 3w, 3e, etc.)
    },
    docs = {
      pre_amend = {
        '<sde><esc>',
        vim.lsp.buf.hover,
      },
      post_amend = {},
      modes = { 'sd' },
      amend = false, -- can't use true, because keys feeded to nvim are the mode seen by `K` is visual even after <esc>. Same issue as macros.
      countable = false,
    },
    to_normal = { -- only `amend` and `countable` keys are needed and only if true
      { '<sde><esc>' },
      {},
      { 'sd', 'n' },
    },
  },
}

require('visual').setup(opts)
