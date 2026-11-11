-- Neovide key remaps: the keys the terminals (alacritty, kitty, wezterm) turn
-- into Alt and other chords before nvim sees them, done here for Neovide,
-- which hands keys to nvim directly. Replaces the AutoKey items that did this
-- by replaying keys through XTest.
--
-- lhs is the key as Neovide delivers it (measured with vim.on_key), rhs the
-- key nvim reads from Alacritty for the same chord. Left out, because Neovide
-- delivers them as an existing key: Ctrl+[ and Ctrl+Shift+[ (<Esc>),
-- Ctrl+Shift+] (<C-]>), Ctrl+Shift+\ (<C-\>), Ctrl+Alt+Shift+\ (<Esc><C-\>),
-- Ctrl+Shift+6 (<C-^>), Ctrl+M (<CR>); Super+Shift+M (Neovide sends
-- nothing). The tmux prefix chords (Super+C, Super+Z, ...) have no tmux here.

local M = {}

-- stylua: ignore start
M.keys = {
  -- Ctrl+Shift+letter -> Alt+letter
  { "<C-S-A>", "<M-a>" },
  { "<C-S-B>", "<M-b>" },
  { "<C-S-C>", "<M-c>" },
  { "<C-S-D>", "<M-d>" },
  { "<C-S-E>", "<M-e>" },
  { "<C-S-F>", "<M-f>" },
  { "<C-S-G>", "<M-g>" },
  { "<C-S-H>", "<M-C-H>" },
  { "<C-S-I>", "<M-i>" },
  { "<C-S-L>", "<M-C-L>" },
  { "<C-S-M>", "<M-m>" },
  { "<C-S-N>", "<M-n>" },
  { "<C-S-O>", "<M-o>" },
  { "<C-S-P>", "<M-P>" },
  { "<C-S-Q>", "<M-q>" },
  { "<C-S-R>", "<M-r>" },
  { "<C-S-S>", "<M-s>" },
  { "<C-S-T>", "<M-t>" },
  { "<C-S-U>", "<M-u>" },
  { "<C-S-W>", "<M-w>" },
  { "<C-S-X>", "<M-x>" },
  { "<C-S-Y>", "<M-y>" },
  { "<S-NL>", "<M-S-NL>" }, -- Ctrl+Shift+J
  { "<C-S-K>", "<M-C-S-K>" },
  { "<C-S-Space>", "<M-C-Space>" },
  -- Ctrl+Shift+punctuation -> Alt+punctuation
  { "<C-!>", "<M-!>" },
  { "<C-*>", "<M-*>" },
  { "<C-(>", "<M-9>" },
  { "<C-)>", "<M-0>" },
  { "<C-+>", "<M-+>" },
  { "<C-lt>", "<M-lt>" },
  { "<C->>", "<M->>" },
  { "<C-?>", "<M-?>" },
  { "<C-:>", "<M-:>" },
  { '<C-">', "<M-C-S-'>" },
  -- Ctrl+punctuation
  { "<C-,>", "<C-S-Tab>" },
  { "<C-;>", "<C-Tab>" },
  { "<C-.>", "<M-.>" },
  { "<C-/>", "<M-/>" },
  { "<C-'>", "<M-'>" },
  { "<C-4>", "<M-$>" },
  { "<C-BS>", "<M-BS>" },
  { "<M-C-'>", "<M-C-S-'>" },
  { "<M-C-/>", "<M-_>" },
  { "<S-BS>", "<Del>" },
  -- Super
  { "<D-,>", "<C-S-Tab>" },
  { "<D-;>", "<C-Tab>" },
  { "<D-[>", "<M-[>" },
  { "<D-]>", "<M-]>" },
  { "<D-BS>", "<M-BS>" },
  { "<D-p>", "<F12>" },
}
-- stylua: ignore end

-- Every mode the terminals' remaps reach: normal, visual, select,
-- operator-pending, insert, command line and terminal
M.modes = { "n", "x", "s", "o", "i", "c", "t" }

function M.setup()
  for _, key in ipairs(M.keys) do
    vim.keymap.set(M.modes, key[1], key[2], {
      remap = true,
      silent = true,
      desc = "neovide: " .. key[2] .. " (as in the terminals)",
    })
  end
end

return M
