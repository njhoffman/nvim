local h = require("tv").handlers

local config = {
  -- global window appearance (can be overridden per channel)
  window = {
    width = 0.8, -- 80% of editor width
    height = 0.8, -- 80% of editor height
    border = "none",
    title = " tv.nvim ",
    title_pos = "center",
  },
  -- per-channel configurations
  channels = {
    -- `files`: fuzzy find files in your project
    files = {
      keybinding = "<leader>Tf", -- Launch the files channel
      -- what happens when you press a key
      handlers = {
        ["<CR>"] = h.open_as_files, -- default: open selected files
        ["<C-q>"] = h.send_to_quickfix, -- send to quickfix list
        ["<C-s>"] = h.open_in_split, -- open in horizontal split
        ["<C-v>"] = h.open_in_vsplit, -- open in vertical split
        ["<C-y>"] = h.copy_to_clipboard, -- copy paths to clipboard
      },
    },
    -- `text`: ripgrep search through file contents
    text = {
      keybinding = "<leader>Tr",
      handlers = {
        ["<CR>"] = h.open_at_line, -- Jump to line:col in file
        ["<C-q>"] = h.send_to_quickfix, -- Send matches to quickfix
        ["<C-s>"] = h.open_in_split, -- Open in horizontal split
        ["<C-v>"] = h.open_in_vsplit, -- Open in vertical split
        ["<C-y>"] = h.copy_to_clipboard, -- Copy matches to clipboard
      },
    },
  },
  -- path to the tv binary (default: 'tv')
  tv_binary = "tv",
  global_keybindings = {
    channels = "<leader>tv", -- opens the channel selector
  },
  quickfix = {
    auto_open = true, -- automatically open quickfix window after populating
  },
}

require("tv").setup(config)
-- Commands:

-- :Tv files              " Find files
-- :Tv text               " Search text in files
-- :Tv text @TODO         " Search with pre-populated query
-- :Tv git-log            " Browse commits
-- :Tv                    " Open channel selector
-- Or use the keybindings you configured above.

-- TV comes with 30+ built-in channels. Use :Tv to see all available channels, or try:

-- :Tv git-branch         " Switch branches
-- :Tv zsh-history        " Browse command history
-- :Tv procs              " List running processes
