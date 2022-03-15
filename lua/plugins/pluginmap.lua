local M = {}

M.plugins = {}

M.skipped_plugins = {
  ["vista.vim"] = {use = "liuchengxu/vista.vim"}
}

M.search_plugins = {
  ["vim-searchsavy"] = {use = {"idbrii/vim-searchsavvy"}}
}

M.treesitter_plugins = {
  ["nvim-treesitter"] = {
    use = {"nvim-treesitter/nvim-treesitter", run = ":TSUpdate", requires = "nvim-lua/plenary.nvim"}
  },
  ["nvim-ts-context-commentstring"] = {
    use = {"JoosepAlviste/nvim-ts-context-commentstring", requires = "nvim-treesitter"}
  },
  ["nvim-treesitter-refactor"] = {use = {"nvim-treesitter/nvim-treesitter-refactor", requires = "nvim-treesitter"}},
  ["playground"] = {use = {"nvim-treesitter/playground", requires = "nvim-treesitter"}},
  ["nvim-treesitter-textobjects"] = {
    use = {"nvim-treesitter/nvim-treesitter-textobjects", requires = "nvim-treesitter"}
  },
  ["nvim-treesitter-textsubjects"] = {use = {"RRethy/nvim-treesitter-textsubjects", requires = "nvim-treesitter"}},
  ["nvim-ts-rainbow"] = {use = {"p00f/nvim-ts-rainbow", requires = "nvim-treesitter"}},
  ["nvim-treesitter-pairs"] = {use = {"theHamsta/nvim-treesitter-pairs", requires = "nvim-treesitter"}},
  ["nvim-ts-autotag"] = {use = {"windwp/nvim-ts-autotag", requires = "nvim-treesitter"}},
  ["tree-sitter-ntangle"] = {use = {"jbyuki/tree-sitter-ntangle"}},
  ["nvim-treesitter-endwise"] = {use = {"RRethy/nvim-treesitter-endwise"}}
}

M.dap_plugins = {
  ["dap-install"] = {use = "Pocco81/DAPInstall.nvim"},
  ["nvim-dap"] = {use = {"mfussenegger/nvim-dap"}},
  ["nvim-dap-ui"] = {
    use = {"rcarriga/nvim-dap-ui", requires = {"theHamsta/nvim-dap-virtual-text", "mfussenegger/nvim-dap"}}
  },
  ["one-small-step-for-vimkind"] = {use = {"jbyuki/one-small-step-for-vimkind", requires = "mfussenegger/nvim-dap"}},
  ["nvim-dap-python"] = {use = {"mfussenegger/nvim-dap-python", requires = "mfussenegger/nvim-dap"}},
  ["dash.nvim"] = {use = {"jbyuki/dash.nvim", requires = "jbyuki/ntangle.nvim"}},
  ["Telegraph.nvim"] = {use = {"WaylonWalker/Telegraph.nvim"}}
}

M.picker_plugins = {
  ["fzf.vim"] = {use = {"junegunn/fzf.vim", requires = {"junegunn/fzf", "ryanoasis/vim-devicons"}}},
  ["fzf-preview.vim"] = {use = {"yuki-yano/fzf-preview.vim", branch = "release/remote", requires = {"junegunn/fzf"}}},
  ["fzf-lua"] = {use = {"ibhagwan/fzf-lua", requires = {"vijaymarupudi/nvim-fzf", "kyazdani42/nvim-web-devicons"}}},
  ["nvim-spotify"] = {use = {"KadoBOT/nvim-spotify", requires = "nvim-telescope/telescope.nvim", run = "make"}},
  ["harpoon"] = {
    use = "ThePrimeagen/harpoon",
    requires = "nvim-lua/plenary.nvim"
  }
}

M.motion_plugins = {
  -- ["vim-sandwhich"] = {use = "machakann/vim-sandwich"},
  ["vim-matchup"] = {use = "andymass/vim-matchup"},
  ["vim-wordmotion"] = {use = "chaoren/vim-wordmotion"},
  ["vim-smoothie"] = {use = "psliwka/vim-smoothie"},
  ["clever-f"] = {use = "rhysd/clever-f.vim"},
  ["marks.nvim"] = {use = "chentau/marks.nvim"},
  ["markdown-preview.nvim"] = {use = "iamcco/markdown-preview.nvim", run = "cd app && yarn install"},
  ["neuron.nvim"] = {
    use = {
      "njhoffman/neuron.nvim",
      requires = {"nvim-lua/popup.nvim", "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim"}
    }
  }
}

M.format_plugins = {
  ["kommentary"] = {use = {"b3nj5m1n/kommentary"}},
  ["nvim-autopairs"] = {use = {"windwp/nvim-autopairs"}}, -- jiangmiao/auto-pairs
  ["splitjoin.vim"] = {use = {"andrewradev/splitjoin.vim"}}, -- FooSoft/vim-argwrap
  ["vim-easy-align"] = {use = {"junegunn/vim-easy-align"}}, -- tommcdo/vim-lion
  ["vim-table-mode"] = {use = {"dhruvasagar/vim-table-mode"}},
  ["dial.nvim"] = {use = {"monaqa/dial.nvim"}},
  ["iswap.nvim"] = {use = {"mizlan/iswap.nvim"}},
  ["vim-camelsnek"] = {use = {"nicwest/vim-camelsnek"}},
  ["vim-checkbox"] = {use = {"jkramer/vim-checkbox"}},
  ["vim-sort-motion"] = {use = {"christoomey/vim-sort-motion"}},
  ["telekasten.nvim"] = {use = {"renerocksai/telekasten.nvim", requires = {"renerocksai/calendar-vim"}}}
}

M.syntax_plugins = {
  ["BetterLua.vim"] = {use = "euclidianace/betterlua.vim"},
  ["Dockerfile.vim"] = {use = "ekalinin/dockerfile.vim"},
  ["ansible-vim"] = {use = "pearofducks/ansible-vim"},
  ["bat.vim"] = {use = "jamespwilliams/bat.vim"},
  ["bats.vim"] = {use = "aliou/bats.vim"},
  ["conflict-marker.vim"] = {use = "rhysd/conflict-marker.vim"},
  ["editorconfig-vim"] = {use = "editorconfig/editorconfig-vim"},
  ["glow.nvim"] = {use = "npxbr/glow.nvim"},
  ["i3-vim-syntax"] = {use = "potatoesmaster/i3-vim-syntax"},
  ["json5.vim"] = {use = "gutenye/json5.vim"},
  ["jsonc.vim"] = {use = "neoclide/jsonc.vim"},
  ["mkdx"] = {use = "SidOfc/mkdx"},
  ["nginx.vim"] = {use = "chr4/nginx.vim"},
  ["pgsql.vim"] = {use = "lifepillar/pgsql.vim"},
  ["php.vim"] = {use = "stanangeloff/php.vim"},
  ["requirements.txt.vim"] = {use = "raimon49/requirements.txt.vim"},
  ["scss-syntax.vim"] = {use = "cakebaker/scss-syntax.vim"},
  ["tabular"] = {use = "godlygeek/tabular"},
  ["tmux.vim"] = {use = "ericpruitt/tmux.vim"},
  ["vim-cpp-enhanced-highlight"] = {use = "octol/vim-cpp-enhanced-highlight"},
  ["vim-git"] = {use = "tpope/vim-git"},
  ["vim-gitignore"] = {use = "gisphm/vim-gitignore"},
  ["vim-glsl"] = {use = "tikhomirov/vim-glsl"},
  ["vim-graphql"] = {use = "jparise/vim-graphql"},
  ["vim-jinja2-syntax"] = {use = "glench/vim-jinja2-syntax"},
  ["vim-jq"] = {use = "bfrg/vim-jq"},
  ["vim-js"] = {use = "yuezk/vim-js"},
  ["vim-json"] = {use = "elzr/vim-json"},
  ["vim-jsx-pretty"] = {use = "maxmellon/vim-jsx-pretty"},
  ["vim-kubernetes"] = {use = "andrewstuart/vim-kubernetes"},
  ["vim-liquid"] = {use = "njhoffman/vim-liquid"},
  ["vim-log-highlighting"] = {use = "mtdl9/vim-log-highlighting"},
  ["vim-lua"] = {use = "tbastos/vim-lua"},
  ["vim-man"] = {use = "njhoffman/vim-man"}, -- "vim-utils/vim-man"
  ["vim-nix"] = {use = "lnl7/vim-nix"},
  ["vim-node"] = {use = "moll/vim-node"},
  ["vim-pandoc-syntax"] = {use = "vim-pandoc/vim-pandoc-syntax"},
  ["vim-puppet"] = {use = "rodjek/vim-puppet"},
  ["vim-systemd-syntax"] = {use = "wgwoods/vim-systemd-syntax"},
  ["vim-terraform"] = {use = "hashivim/vim-terraform"},
  ["yats.vim"] = {use = "herringtondarkholme/yats.vim"},
  ["zinit-vim-syntax"] = {use = "zdharma-continuum/zinit-vim-syntax"}

  -- use "plasticboy/vim-markdown"
  -- use "xolox/vim-lua-inspect"
  -- use { "xolox/vim-lua-ftplugin", requires = "xolox/vim-misc" }
  -- use "tpope/vim-liquid"
  -- use "kchmck/vim-coffee-script"
}

M.completion_plugins = {
  ["nvim-cmp"] = {use = "hrsh7th/nvim-cmp"},
  ["cmp-under-comparator"] = {use = {"lukas-reineke/cmp-under-comparator", after = "nvim-cmp"}},
  ["cmp-treesitter"] = {use = {"ray-x/cmp-treesitter", after = "nvim-cmp"}},
  ["cmp-spell"] = {use = {"f3fora/cmp-spell", after = "nvim-cmp"}},
  ["cmp-npm"] = {use = {"David-Kunz/cmp-npm", after = "nvim-cmp"}},
  ["cmp-zsh"] = {use = {"tamago324/cmp-zsh", after = "nvim-cmp"}},
  ["cmp-vimwiki-tags"] = {use = {"pontusk/cmp-vimwiki-tags", after = "nvim-cmp"}},
  ["cmp-pandoc-references"] = {use = {"jc-doyle/cmp-pandoc-references", after = "nvim-cmp"}},
  ["cmp-tabnine"] = {use = {"tzachar/cmp-tabnine", run = "./install.sh", after = "nvim-cmp"}},
  ["cmp-git"] = {use = {"petertriho/cmp-git", requires = "nvim-lua/plenary.nvim", after = "nvim-cmp"}},
  ["cmp-emoji"] = {use = {"hrsh7th/cmp-emoji", after = "nvim-cmp"}},
  ["cmp-nvim-lua"] = {use = {"hrsh7th/cmp-nvim-lua", after = "nvim-cmp"}},
  ["cmp-nvim-lsp"] = {use = {"hrsh7th/cmp-nvim-lsp", after = "nvim-cmp"}},
  ["cmp-buffer"] = {use = {"hrsh7th/cmp-buffer", after = "nvim-cmp"}},
  ["cmp-calc"] = {use = {"hrsh7th/cmp-calc", after = "nvim-cmp"}},
  ["cmp-path"] = {use = {"hrsh7th/cmp-path", after = "nvim-cmp"}},
  ["cmp-cmdline"] = {use = {"hrsh7th/cmp-cmdline", after = "nvim-cmp"}},
  ["vim-dadbod-completion"] = {
    use = {"kristijanhusak/vim-dadbod-completion", requires = "tpope/vim-dadbod", after = "nvim-cmp"}
  },
  ["cmp-vsnip"] = {use = {"hrsh7th/cmp-vsnip", after = "nvim-cmp", requires = "hrsh7th/vim-vsnip"}},
  ["friendly-snippets"] = {use = {"rafamadriz/friendly-snippets", after = "cmp-vsnip"}},
  ["vs-snippets"] = {use = {"kitagry/vs-snippets", after = "cmp-vsnip"}}
}
-- use "wellle/tmux-complete.vim"  not available for nvim-cmp yet
-- use {'neovim/nvim-lspconfig', requires = 'mfussenegger/nvim-jdtls'}
-- "lukas-reineke/cmp-rg",
-- "uga-rosa/cmp-dictionary",
-- { "andersevenrud/compe-tmux" },
-- 'saadparwaiz1/cmp_luasnip' -- Snippets source for nvim-cmp
-- 'L3MON4D3/LuaSnip' -- Snippets plugin
-- use "honza/vim-snippets"
-- use "SirVer/UltiSnips"
-- use { 'cstrap/python-snippets' }
-- use { 'ylcnfrht/vscode-python-snippet-pack' }
-- use { 'golang/vscode-go' }
-- use { 'rust-lang/vscode-rust' }

M.ui_plugins = {
  -- ["startup.nvim"] = {
  --   use = {"startup-nvim/startup.nvim", requires = {"nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim"}}
  -- },
  ["aerial.nvim"] = {use = "stevearc/aerial.nvim"},
  ["dressing-nvim"] = {use = {"stevearc/dressing.nvim", requires = "MunifTanjim/nui.nvim"}},
  ["nvim-hlslens"] = {use = "kevinhwang91/nvim-hlslens"},
  ["nvim-notify"] = {use = "rcarriga/nvim-notify"},
  ["nvim-scrollbar"] = {use = "petertriho/nvim-scrollbar"},
  ["specs.nvim"] = {use = "edluffy/specs.nvim"},
  ["stabilize.nvim"] = {use = "luukvbaal/stabilize.nvim"},
  ["todo-comments.nvim"] = {use = "folke/todo-comments.nvim"},
  ["twilight.nvim"] = {use = "folke/twilight.nvim"},
  ["vim-HiLinkTrace"] = {use = "gerw/vim-HiLinkTrace"},
  ["vim-bling"] = {use = "ivyl/vim-bling"},
  ["vim-cool"] = {use = "romainl/vim-cool"},
  ["vim-hexokinase"] = {use = {"RRethy/vim-hexokinase", run = "make hexokinase"}},
  ["vim-plugin-AnsiEsc"] = {use = "joeysino/vim-plugin-AnsiEsc"},
  ["vimade"] = {use = "TaDaa/vimade"},
  ["which-key.nvim"] = {use = "folke/which-key.nvim"},
  ["zen-mode.nvim"] = {use = "folke/zen-mode.nvim"},
  ["hop.nvim"] =  { use = "phaazon/hop.nvim" },
}

M.project_plugins = {
  ["auto-session"] = {use = "rmagatti/auto-session"},
  ["competitest.nvim"] = {use = {"xeluxee/competitest.nvim", requires = "MunifTanjim/nui.nvim"}},
  ["cpbooster.vim"] = {use = "searleser97/cpbooster.vim"},
  ["gitsigns.nvim"] = {use = {"lewis6991/gitsigns.nvim", requires = {"nvim-lua/plenary.nvim"}}},
  ["nvim-projectconfig"] = {use = "windwp/nvim-projectconfig"},
  ["project-nvim"] = {use = "ahmedkhalf/project.nvim"}, -- TODO: load before telescope
  ["octo.nvim"] = {use = {"pwntester/octo.nvim", requires = "kyazdani42/nvim-web-devicons"}},
  ["vim-flog"] = {use = "rbong/vim-flog"},
  ["vim-fugitive"] = {use = "tpope/vim-fugitive"},
  ["vim-rhubarb"] = {use = "tpope/vim-rhubarb"},
  ["vim-wakatime"] = {use = "wakatime/vim-wakatime"}
}

M.interface_plugins = {
  -- ["yank-history"] = {use = "yazgoo/yank-history"},
  ["alpha-nvim"] = {use = {"goolord/alpha-nvim", requires = "kyazdani42/nvim-web-devicons"}},
  ["diffview.nvim"] = {use = "sindrets/diffview.nvim"},
  ["nvim-bqf"] = {use = "kevinhwang91/nvim-bqf"},
  ["nvim-tree.lua"] = {use = "kyazdani42/nvim-tree.lua"},
  ["perfanno.nvim"] = {use = "t-troebst/perfanno.nvim"},
  ["quickmath.nvim"] = {use = "jbyuki/quickmath.nvim"},
  ["registers.nvim"] = {use = "tversteeg/registers.nvim"},
  ["vim-floaterm"] = {use = "voldikss/vim-floaterm"},
  ["vim-mundo"] = {use = "simnalamburt/vim-mundo"},
  ["vim-qf"] = {use = "romainl/vim-qf"},
  ["vim-qf-history"] = {use = "bfrg/vim-qf-history"},
  ["vim-yoink"] = {use = "svermeulen/vim-yoink"}
}

M.integration_plugins = {
  ["asynctasks.vim"] = {use = {"skywind3000/asynctasks.vim", requires = "skywind3000/asyncrun.vim"}},
  ["cheat.sh-vim"] = {use = "dbeniamine/cheat.sh-vim"},
  ["id3.vim"] = {use = "AndrewRadev/id3.vim"},
  ["nvim-magic"] = {use = {"jameshiew/nvim-magic", requires = {"nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim"}}},
  ["package-info.nvim"] = {use = {"vuki656/package-info.nvim", requires = "MunifTanjim/nui.nvim"}},
  ["vim-dadbod-ui"] = {use = {"kristijanhusak/vim-dadbod-ui", requires = "tpope/vim-dadbod"}},
  ["vim-ripple"] = {use = "urbainvaes/vim-ripple"},
  ["vim-test"] = {use = "vim-test/vim-test"},
  ["nvim-regexplainer"] = {
    use = {
      "bennypowers/nvim-regexplainer",
      requires = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim"
      }
    }
  }
}

M.sysutil_plugins = {
  ["vim-eunuch"] = {use = "tpope/vim-eunuch"},
  ["vim-renamer"] = {use = "qpkorr/vim-renamer"},
  ["nvim-remote-containers"] = {use = "jamestthompson3/nvim-remote-containers"},
  ["suda.vim"] = {use = "lambdalisue/suda.vim"},
  ["vim-scriptease"] = {use = "tpope/vim-scriptease"},
  ["vim-symlink"] = {use = "aymericbeaumet/vim-symlink"}
}

M.lsp_plugins = {
  ["fidget.nvim"] = {use = "j-hui/fidget.nvim"},
  ["null-ls.nvim"] = {use = {"jose-elias-alvarez/null-ls.nvim", requires = "nvim-lua/plenary.nvim"}},
  ["lua-dev.nvim"] = {use = "folke/lua-dev.nvim"},
  ["trouble.nvim"] = {use = "folke/trouble.nvim"},
  ["ntangle-lsp.nvim"] = {
    use = {"jbyuki/ntangle-lsp.nvim", requires = {"jbyuki/ntangle-ts.nvim", "neovim/nvim-lspconfig"}}
  }
}

M.theme_plugins = {
  ["barbar"] = {use = {"romgrk/barbar.nvim"}},
  ["lush.nvim"] = {use = "rktjmp/lush.nvim"},
  ["feline.nvim"] = {use = "feline-nvim/feline.nvim"}
}

M.check_require_exists = function(fname)
  local res = pcall(require, fname)
  return res
  -- local f=io.open(name,"r")
  -- if f ~= nil then io.close(f) return true else return false end
end

M.check_path_exists = function(path)
  path = path:gsub("~", os.getenv("HOME"))
  local ok, err, code = os.rename(path, path)
  if not ok then
    if code == 13 then
      -- Permission denied, but it exists
      return true
    end
  end
  return ok, err
end

M.split_env = function(env_name, sep)
  if sep == nil then
    sep = "%s"
  end
  local env_table = {}
  for str in string.gmatch(env_name, "([^" .. sep .. "]+)") do
    table.insert(env_table, str)
  end
  return env_table
end

M.concat_array = function(a, b)
  return table.move(b, 1, #b, #a + 1, a)
end

M.stats = {
  skipped = 0,
  disabled = 0,
  loaded = 0,
  lazy_loaded = 0,
  local_loaded = 0,
  fork_loaded = 0,
  config_loaded = 0
}

M.load_config = function(fname)
  -- print("CONFIG ", fname)
  M.stats.config_loaded = M.stats.config_loaded + 1
  pcall(require, fname)
end

M.plugin_config = function(name)
  name = name:gsub("[\\.]+", "-")
  local fname = "plugins.config." .. string.lower(name)
  local config = nil
  -- TODO: check if actual file exists, report if can't load
  -- print('checking ' .. fname)
  if M.check_require_exists(fname) then
    config = M.load_config(fname)
  -- else
  --   -- print("config not found: " .. fname)
  end
  return config
end

M.load_plugins = function(use, load_config)
  local env_lazy = os.getenv("NVIM_PLUGINS_LAZY")
  local env_disable = os.getenv("NVIM_PLUGINS_DISABLE")
  local env_skip = os.getenv("NVIM_PLUGINS_SKIP")

  -- local lazy = M.concat_array(env_lazy, load_config.lazy)
  -- local disable = M.concat_array(env_disable, load_config.disable)
  -- local skip = M.concat_array(env_skip, load_config.skip)

  local all_plugins = {
    M.dap_plugins,
    M.format_plugins,
    M.integration_plugins,
    M.interface_plugins,
    M.lsp_plugins,
    M.completion_plugins,
    M.motion_plugins,
    M.picker_plugins,
    M.project_plugins,
    M.search_plugins,
    M.syntax_plugins,
    M.sysutil_plugins,
    M.theme_plugins,
    M.treesitter_plugins,
    M.ui_plugins
  }

  for _, plugin_set in pairs(all_plugins) do
    for name, plugin_item in pairs(plugin_set) do
      -- print(vim.inspect(plugin_item))
      local plugin = plugin_item.use
      if type(plugin) == "string" then
        plugin = {plugin}
      end

      local plugin_config = plugin.config or M.plugin_config(name)
      if plugin_config ~= nil then
        plugin.config = plugin_config
      end

      if plugin_item.src ~= nil then
        if type(plugin_item.src) ~= "table" then
          plugin_item.src = {plugin_item.src}
        end
        if M.check_path_exists(plugin_item.src[1]) then
          M.stats.local_loaded = M.stats.local_loaded + 1
          plugin = plugin_item.src
        end
      elseif plugin_item.fork ~= nil then
        if type(plugin_item.fork) ~= "table" then
          plugin_item.fork = {plugin_item.fork}
        end
        M.stats.fork_loaded = M.stats.fork_loaded + 1
        plugin = plugin_item.fork
      end
      M.stats.loaded = M.stats.loaded + 1
      use(plugin)
    end
  end

  return M.stats
end

return M
-- use {
--   'myusername/example',        -- The plugin location string
--   -- The following keys are all optional
--   disable = boolean,           -- Mark a plugin as inactive
--   as = string,                 -- Specifies an alias under which to install the plugin
--   installer = function,        -- Specifies custom installer. See "custom installers" below.
--   updater = function,          -- Specifies custom updater. See "custom installers" below.
--   after = string or list,      -- Specifies plugins to load before this plugin. See "sequencing" below
--   rtp = string,                -- Specifies a subdirectory of the plugin to add to runtimepath.
--   opt = boolean,               -- Manually marks a plugin as optional.
--   branch = string,             -- Specifies a git branch to use
--   tag = string,                -- Specifies a git tag to use
--   commit = string,             -- Specifies a git commit to use
--   lock = boolean,              -- Skip updating this plugin in updates/syncs. Still cleans.
--   run = string, function, or table, -- Post-update/install hook. See "update/install hooks".
--   requires = string or list,   -- Specifies plugin dependencies. See "dependencies".
--   rocks = string or list,      -- Specifies Luarocks dependencies for the plugin
--   config = string or function, -- Specifies code to run after this plugin is loaded.
--   -- The setup key implies opt = true
--   setup = string or function,  -- Specifies code to run before this plugin is loaded.
--   -- The following keys all imply lazy-loading and imply opt = true
--   cmd = string or list,        -- Specifies commands which load this plugin. Can be an autocmd pattern.
--   ft = string or list,         -- Specifies filetypes which load this plugin.
--   keys = string or list,       -- Specifies maps which load this plugin. See "Keybindings".
--   event = string or list,      -- Specifies autocommand events which load this plugin.
--   fn = string or list          -- Specifies functions which load this plugin.
--   cond = string, function, or list of strings/functions,   -- Specifies a conditional test to load this plugin
--   module = string or list      -- Specifies Lua module names for require. When requiring a string which starts
--                                -- with one of these module names, the plugin will be loaded.
--   module_pattern = string/list -- Specifies Lua pattern of Lua module names for require. When
--   requiring a string which matches one of these patterns, the plugin will be loaded.
-- }
