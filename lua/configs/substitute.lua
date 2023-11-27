local defaults = {
  on_substitute = nil,
  yank_substituted_text = false,
  highlight_substituted_text = {
    enabled = true,
    timer = 500,
  },
  range = {
    prefix = 's',
    prompt_current_text = false,
    confirm = false,
    complete_word = false,
    motion1 = false,
    motion2 = false,
    suffix = '',
  },
  exchange = {
    motion = false,
    use_esc_to_cancel = true,
  },
}
-- ["x]S			Delete [count] lines [into register x] and start insert.  Synonym for "cc" |linewise|.
-- replace:  Siw replaces the current word with "+" register
-- exchange: Sxiw (move) Sxiw (or .)
--           cxw (move) cxw (or .)
--           (visual) X (move) (visual) X

require('substitute').setup({
  on_substitute = require('yanky.integration').substitute(),
  range = { prefix = 'S' },
})

local function setup_keymaps()
  vim.keymap.set('n', 'S', require('substitute').operator, { noremap = true, desc = 'substitute operator' })
  vim.keymap.set('n', 'S^', require('substitute').line, { noremap = true, desc = 'substitute line' })
  vim.keymap.set('n', 'S$', require('substitute').eol, { noremap = true, desc = 'substitute eol' })
  vim.keymap.set('x', 'S', require('substitute').visual, { noremap = true, desc = 'substitute visual' })

  vim.keymap.set('n', '<leader>s', function()
    require('substitute.range').operator({ prefix = 'S' })
  end, { noremap = true, desc = 'substitute range operator' })

  vim.keymap.set('x', '<leader>s', function()
    require('substitute.range').visual({ prefix = 'S' })
  end, { noremap = true, desc = 'substitute range visual' })

  vim.keymap.set('n', '<leader>ss', function()
    require('substitute.range').word({ prefix = 'S' })
  end, { noremap = true, desc = 'substitute range word' })

  vim.keymap.set('n', '<leader>sy', require('substitute').line, { noremap = true, desc = 'substitute line' })

  vim.keymap.set(
    'n',
    'cx',
    require('substitute.exchange').operator,
    { noremap = true, desc = 'substitute exchange operator' }
  )
  vim.keymap.set('n', 'cxx', require('substitute.exchange').line, { noremap = true, desc = 'substitute exchange line' })
  vim.keymap.set(
    'n',
    'X',
    require('substitute.exchange').operator,
    { noremap = true, desc = 'substitute exchange operator' }
  )
  vim.keymap.set(
    'x',
    'X',
    require('substitute.exchange').visual,
    { noremap = true, desc = 'substitute exchange visual' }
  )
  vim.keymap.set(
    'n',
    'cxc',
    require('substitute.exchange').cancel,
    { noremap = true, desc = 'substitute exchange cancel' }
  )
end

setup_keymaps()

-- vim.keymap.set("n", "s", require('substitute').operator, { noremap = true })
-- vim.keymap.set("n", "ss", require('substitute').line, { noremap = true })
-- vim.keymap.set("n", "S", require('substitute').eol, { noremap = true })
-- vim.keymap.set("x", "s", require('substitute').visual, { noremap = true })

-- vim.keymap.set("n", "<leader>s", require('substitute.range').operator, { noremap = true })
-- vim.keymap.set("x", "<leader>s", require('substitute.range').visual, { noremap = true })
-- vim.keymap.set("n", "<leader>ss", require('substitute.range').word, { noremap = true })

-- exchange operator
-- vim.keymap.set("n", "sx", require('substitute.exchange').operator, { noremap = true })
-- vim.keymap.set("n", "sxx", require('substitute.exchange').line, { noremap = true })
-- vim.keymap.set("x", "X", require('substitute.exchange').visual, { noremap = true })
-- vim.keymap.set("n", "sxc", require('substitute.exchange').cancel, { noremap = true })
