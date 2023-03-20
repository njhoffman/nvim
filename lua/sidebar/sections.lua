local is_installed = function(name)
  local plugins = require("lazy.core.config").spec.plugins
  return plugins[name] and plugins[name]._.installed
end

local sections = {
  neotree = {
    text = "Neotree Explorer",
    enabled = function()
      return is_installed("neo-tree.nvim")
    end,
    open = function()
      vim.cmd("NeoTreeShow")
      -- require("neo-tree").show()
    end,
    close = function()
      vim.cmd("NeoTreeClose")
      -- require("neo-tree").close_all()
    end,
  },
  aerial = {
    text = "Aerial Symbols",
    enabled = function()
      return is_installed("aerial.nvim")
    end,
    open = function()
      vim.cmd("AerialOpen")
      -- require("aerial").open()
    end,
    close = function()
      vim.cmd("AerialClose")
      -- require("aerial").close()
    end,
  },
  mundo = {
    text = "Mundo Tree",
    enabled = function()
      return is_installed("vim-mundo")
    end,
    open = function()
      vim.cmd("MundoShow")
    end,
    close = function()
      vim.cmd("MundoHide")
    end,
  },
  tsplayground = {
    text = "Treesitter Playground",
    enabled = function()
      return is_installed("nvim-treesitter")
    end,
    open = function()
      vim.cmd("TSPlaygroundToggle")
    end,
    close = function()
      vim.cmd("TSPlaygroundToggle")
    end,
  },
  dapui = {
    text = "DAP Debug",
    enabled = false,
    open = function()
      require("dapui").toggle("sidebar")
    end,
  },
  -- todo comments, git actions, buffers, diagnostics, asynctasks, user-options, man, docker, tags, jumplist, changes
}

return sections
