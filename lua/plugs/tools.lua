local utils = require("utils.lazy")
local plugins = {
  {
    "nvim-neotest/neotest",
    cmd = { "Neotest", "NeotestSummary", "NeotestNearest", "NeotestAttach" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-neotest/neotest-python",
      "nvim-neotest/neotest-plenary",
      "rouge8/neotest-rust",
      "akinsho/neotest-go",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      {
        "nvim-neotest/neotest-vim-test",
        dependencies = { "vim-test/vim-test", cmd = { "Test", "TestNearest", "TestFile" } },
      },
    },
  },
  { 'gennaro-tedesco/nvim-jqx', lazy = true, cmd = { 'JqxList', 'JqxQuery' } },
  { 'bfrg/vim-jqplay', ft = 'jq', cmd = { 'Jqplay', 'JqplayScratch', 'JqplayScratchNoInput' } },
  { "npxbr/glow.nvim", cmd = "Glow" },
  { "NTBBloodbath/rest.nvim", cmd = { "RESTRunLast", "RESTRun", "RESTPreview" } },
  { "dbeniamine/cheat.sh-vim", cmd = "Cheat" },
  { "potamides/pantran.nvim", cmd = "Pantran" },
  { "sidebar-nvim/sidebar.nvim", cmd = { "SidebarNvimOpen", "SidebarNvimToggle" } },
  { "anuvyklack/hydra.nvim", event = "VeryLazy" },
  { "goolord/alpha-nvim", event = "VimEnter", dependencies = "nvim-tree/nvim-web-devicons" },
  { "nvim-colortils/colortils.nvim", cmd = "Colortils" },
  { "xeluxee/competitest.nvim", cmd = "CompetiTestRun", dependencies = "MunifTanjim/nui.nvim" },
  { "AckslD/nvim-neoclip.lua", event = "VimEnter", dependencies = "kkharji/sqlite.lua" },
  {
    "simnalamburt/vim-mundo",
    cmd = { "MundoToggle", "MundoShow", "MundoHide" },
    build = function()
      vim.cmd([[UpdateRemotePlugins]])
    end,
    config = function()
      vim.g.mundo_prefer_python3 = 1
      vim.g.mundo_width = 35
      vim.g.mundo_preview_height = 5
      vim.g.mundo_right = 1
      vim.g.mundo_help = 0
      vim.g.mundo_disable = 0
      vim.g.mundo_preview_bottom = 1
      vim.g.mundo_close_on_revert = 0
      vim.g.mundo_auto_preview = 1
      vim.g.mundo_playback_delay = 60
      -- vim.g.mundo_preview_statusline = nil
      -- vim.g.mundo_tree_statusline = nil
    end,
  },
  {
    "tools-life/taskwiki",
    cmd = { "TW", "TWSync" },
    build = "pip3 install --upgrade git+git://github.com/tbabej/tasklib@develop",
    dependencies = {
      {
        "vimwiki/vimwiki",
        branch = "dev",
        init = function()
          vim.g.vimwiki_filetypes = { "vimwiki", "markdown", "pandoc" }
          vim.g.vimwiki_global_ext = 0
          vim.g.vimwiki_key_mappings = { all_maps = 0 }
          -- vim.cmd([[let g:vimwiki_key_mappings = { 'all_maps': 0, }]])
        end,
      },
      "vim-plugin-AnsiEsc",
      "farseer90718/vim-taskwarrior",
      "preservim/tagbar",
    },
  },
  {
    "jackMort/ChatGPT.nvim",
    cmd = { "ChatGPT", "ChatGPTEditWithInstructions", "ChatGPTActAs" },
    -- enabled = false,
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "njhoffman/telescope.nvim",
    },
  },
}

utils.apply_configs(plugins)
return plugins
