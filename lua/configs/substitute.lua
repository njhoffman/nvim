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

-- replace:  Siw replaces the current word with "+" register
-- exchange: Sxiw (move to next work) Sxiw (or .)
require('substitute').setup({ range = { prefix = 'S' } })

vim.keymap.set('n', 'S', require('substitute').operator, { noremap = true })
vim.keymap.set('n', 'SS', require('substitute').line, { noremap = true })
-- vim.keymap.set("n", "S", require('substitute').eol, { noremap = true })
vim.keymap.set('x', 'S', require('substitute').visual, { noremap = true })

vim.keymap.set('n', '<leader>S', function()
  require('substitute.range').operator({ prefix = 'S' })
end, { noremap = true })

vim.keymap.set('n', 'Sx', require('substitute.exchange').operator, { noremap = true })
vim.keymap.set('n', 'Sxx', require('substitute.exchange').line, { noremap = true })
vim.keymap.set('x', 'X', require('substitute.exchange').visual, { noremap = true })
vim.keymap.set('n', 'Sxc', require('substitute.exchange').cancel, { noremap = true })

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
