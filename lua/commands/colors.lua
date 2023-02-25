local cmd = vim.api.nvim_create_user_command

local load_colorschemes = function()
  local schemes = {
    ["material deep ocean"] = {
      function()
        require("material").setup()
        vim.g.material_style = "deep ocean"
        vim.cmd("colorscheme material")
      end,
    },
    ["material palenight"] = {
      function()
        require("material").setup()
        vim.g.material_style = "palenight"
        vim.cmd("colorscheme material")
      end,
    },
    ["material oceanic"] = {
      function()
        require("material").setup()
        vim.g.material_style = "oceanic"
        vim.cmd("colorscheme material")
      end,
    },
    ["material lighter"] = {
      function()
        require("material").setup()
        vim.g.material_style = "lighter"
        vim.cmd("colorscheme material")
      end,
    },
    ["material darker"] = {
      function()
        require("material").setup()
        vim.g.material_style = "darker"
        vim.cmd("colorscheme material")
      end,
    },
  }
end

cmd("LoadColorschemes", load_colorschemes, {
  desc = "Load colorschemes",
})
