-- $ nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

local packerConfig = {
  -- log = {level = "info"}, -- The default print log level. One of: "trace", "debug", "info", "warn", "error", "fatal".
  profile = {
    enable = false,
    threshold = 1 -- the amount in ms that a plugins load time must be over for it to be included in the profile
  },
  compile_path = vim.fn.stdpath("config") .. "/plugin/packer_compiled.lua",
  display = {
    non_interactive = false, -- If true, disable display windows for all operations
    open_fn = function()
      return require("packer.util").float { border = "single" }
    end,
    -- open_cmd = '65vnew \\[packer\\]', -- An optional command to open a window for packer's display
    working_sym = "⟳", -- The symbol for a plugin being installed/updated
    error_sym = "✗", -- The symbol for a plugin with an error in installation/updating
    clone_timeout = 180, -- Timeout, in seconds, for git clones
    done_sym = "✓", -- The symbol for a plugin which has completed installation/updating
    removed_sym = "-", -- The symbol for an unused plugin which was removed
    moved_sym = "→", -- The symbol for a plugin which was moved (e.g. from opt to start)
    header_sym = "━", -- The symbol for the header line in packer's display
    show_all_info = true, -- Should packer show all update details automatically?
    prompt_border = "double", -- Border style of prompt popups.
    keybindings = {
      -- Keybindings for the display window
      quit = "<esc>",
      toggle_info = "<CR>",
      diff = "d",
      prompt_revert = "r"
    }
  }
}

return packerConfig
