local is_installed = function(name)
  local plugins = require("lazy.core.config").spec.plugins
  return plugins[name] and plugins[name]._.installed
end

local sections = {
  {
    name = "neotree",
    text = "Neotree Explorer",
    enabled = function()
      return is_installed("neo-tree.nvim")
    end,
    open = function()
      vim.cmd("NeoTreeShow")
    end,
    close = function()
      vim.cmd("NeoTreeClose")
    end,
  },
  {
    name = "aerial ",
    text = "Aerial Symbols",
    enabled = function()
      return is_installed("aerial.nvim")
    end,
    float = function()
      require("aerial").open({ direction = "float" })
      vim.cmd("wincmd p")
    end,
    open = function()
      require("aerial").open({ direction = "right" })
      vim.cmd("wincmd p")
    end,
    close = function()
      vim.cmd("AerialClose")
    end,
  },
  {
    name = "mundo",
    text = "Mundo Tree",
    cycle = false,
    enabled = function()
      return false and is_installed("vim-mundo")
    end,
    open = function()
      vim.cmd("MundoShow")
      vim.cmd("wincmd p")
    end,
    close = function()
      vim.cmd("MundoHide")
    end,
  },
  {
    name = "nvimsidebar",
    text = "Nvim Sidebar",
    cycle = false,
    enabled = function()
      return false and is_installed("sidebar.nvim")
    end,
    open = function()
      vim.cmd("SidebarNvimOpen")
    end,
    close = function()
      vim.cmd("SidebarNvimClose")
    end,
  },
  {
    name = "tsplayground",
    text = "Treesitter Playground",
    cycle = false,
    enabled = function()
      return false and is_installed("nvim-treesitter")
    end,
    open = function()
      vim.cmd("TSPlaygroundToggle")
    end,
    close = function()
      vim.cmd("TSPlaygroundToggle")
    end,
  },
  {
    name = "dapui",
    text = "DAP Debug",
    enabled = false,
    open = function()
      require("dapui").toggle("sidebar")
    end,
  },
  -- todo comments, git actions, buffers, diagnostics, asynctasks, user-options, man, docker, tags, jumplist, changes
}

return sections
