local M = {}

M.plugins = {}

M.skipped_plugins = {
  ["vista.vim"] = { "liuchengxu/vista.vim" }
}

M.search_plugins = {
  ["vim-searchsavy"] = { "idbrii/vim-searchsavvy" }
}

M.buffer_plugins = {
  ["vim-saynoara"] = { "mhinz/vim-sayonara" },
  ["vim-bbye"] = { "moll/vim-bbye" },
  ["nvim-bufdel"] = { "ojroques/nvim-bufdel" }
}

M.mapping_plugins = {
  ["vim-repeat"] = { "tpope/vim-repeat" },
  ["vim-alias"] = { "Konfekt/vim-alias" }
}

M.treesitter_plugins = {
  ["nvim-treesitter"] = {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    requires = "nvim-lua/plenary.nvim"
  },
  ["nvim-ts-context-commentstring"] = {
    "JoosepAlviste/nvim-ts-context-commentstring",
    requires = "nvim-treesitter"
  },
  ["nvim-treesitter-context"] = { "romgrk/nvim-treesitter-context", requires = "nvim-treesitter" },
  ["nvim-treesitter-refactor"] = { "nvim-treesitter/nvim-treesitter-refactor", requires = "nvim-treesitter" },
  ["playground"] = { "nvim-treesitter/playground", requires = "nvim-treesitter" },
  ["nvim-treesitter-textobjects"] = {
    "nvim-treesitter/nvim-treesitter-textobjects",
    requires = "nvim-treesitter"
  },
  ["nvim-treesitter-textsubjects"] = { "RRethy/nvim-treesitter-textsubjects", requires = "nvim-treesitter" },
  ["nvim-ts-rainbow"] = { "p00f/nvim-ts-rainbow", requires = "nvim-treesitter" },
  ["nvim-treesitter-pairs"] = { "theHamsta/nvim-treesitter-pairs", requires = "nvim-treesitter" },
  ["nvim-ts-autotag"] = { "windwp/nvim-ts-autotag", requires = "nvim-treesitter" },
  ["tree-sitter-ntangle"] = { "jbyuki/tree-sitter-ntangle" },
  ["nvim-treesitter-endwise"] = { "RRethy/nvim-treesitter-endwise" }
}

M.dap_plugins = {
  ["dap-install"] = { "Pocco81/DAPInstall.nvim" },
  ["nvim-dap"] = { "mfussenegger/nvim-dap" },
  ["nvim-dap-ui"] = {
    "rcarriga/nvim-dap-ui",
    requires = { "theHamsta/nvim-dap-virtual-text", "mfussenegger/nvim-dap" }
  },
  ["one-small-step-for-vimkind"] = { "jbyuki/one-small-step-for-vimkind", requires = "mfussenegger/nvim-dap" },
  ["nvim-dap-python"] = { "mfussenegger/nvim-dap-python", requires = "mfussenegger/nvim-dap" },
  ["dash.nvim"] = { "jbyuki/dash.nvim", requires = "jbyuki/ntangle.nvim" },
  ["Telegraph.nvim"] = { "WaylonWalker/Telegraph.nvim" }
}

M.picker_plugins = {
  ["fzf.vim"] = { "junegunn/fzf.vim", requires = { "junegunn/fzf", "ryanoasis/vim-devicons" } },
  -- needs tool-versions nodejs 15.14.0
  -- ["fzf-preview.vim"] = { "yuki-yano/fzf-preview.vim", branch = "release/remote", requires = { "junegunn/fzf" }, run = "function() vim.cmd('UpdateRemotePlugins') end" },
  ["fzf-preview.vim"] = { "yuki-yano/fzf-preview.vim", branch = "release/rpc", requires = { "junegunn/fzf" }, run = "function() vim.cmd('FzfPreviewInstall') end" },
  ["fzf-lua"] = { "ibhagwan/fzf-lua", requires = { "vijaymarupudi/nvim-fzf", "kyazdani42/nvim-web-devicons" } },
  ["nvim-spotify"] = { "KadoBOT/nvim-spotify", requires = "nvim-telescope/telescope.nvim", run = "make" },
  ["tmuxjump.vim"] = { "shivamashtikar/tmuxjump.vim", requires = "junegunn/fzf.vim" },
  ["harpoon"] = {
    "ThePrimeagen/harpoon",
    requires = "nvim-lua/plenary.nvim"
  }
}

M.motion_plugins = {
  -- ["vim-sandwhich"] = {"machakann/vim-sandwich"},
  ["vim-matchup"]           = { "andymass/vim-matchup" },
  ["vim-wordmotion"]        = { "chaoren/vim-wordmotion" },
  ["vim-smoothie"]          = { "psliwka/vim-smoothie", commit = "10fd0aa" }, -- f2aaab1
  ["clever-f"]              = { "rhysd/clever-f.vim" },
  ["marks.nvim"]            = { "chentoast/marks.nvim" },
  ["markdown-preview.nvim"] = { "iamcco/markdown-preview.nvim", run = "cd app && yarn install" },
  -- ["neuron-v2.vim"]         = { "chiefnoah/neuron-v2.vim" },
  ["neuron.nvim"]           = {
    "njhoffman/neuron.nvim",
    requires = {
      "nvim-lua/popup.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim"
    }
  }
}

M.format_plugins = {
  ["kommentary"]      = { "b3nj5m1n/kommentary" },
  ["nvim-autopairs"]  = { "windwp/nvim-autopairs" }, -- jiangmiao/auto-pairs
  ["splitjoin.vim"]   = { "andrewradev/splitjoin.vim" }, -- FooSoft/vim-argwrap
  ["vim-easy-align"]  = { "junegunn/vim-easy-align" }, -- tommcdo/vim-lion
  ["vim-table-mode"]  = { "dhruvasagar/vim-table-mode" },
  ["dial.nvim"]       = { "monaqa/dial.nvim" },
  ["iswap.nvim"]      = { "mizlan/iswap.nvim" },
  ["vim-camelsnek"]   = { "nicwest/vim-camelsnek" },
  ["vim-checkbox"]    = { "jkramer/vim-checkbox" },
  ["vim-sort-motion"] = { "christoomey/vim-sort-motion" },
  ["telekasten.nvim"] = { "renerocksai/telekasten.nvim", requires = { "renerocksai/calendar-vim" } }
}

M.syntax_plugins = {
  ["BetterLua.vim"] = { "euclidianace/betterlua.vim" },
  ["Dockerfile.vim"] = { "ekalinin/dockerfile.vim" },
  ["ansible-vim"] = { "pearofducks/ansible-vim" },
  ["bat.vim"] = { "jamespwilliams/bat.vim" },
  ["bats.vim"] = { "aliou/bats.vim" },
  ["conflict-marker.vim"] = { "rhysd/conflict-marker.vim" },
  ["editorconfig-vim"] = { "editorconfig/editorconfig-vim" },
  ["glow.nvim"] = { "npxbr/glow.nvim" },
  ["i3-vim-syntax"] = { "potatoesmaster/i3-vim-syntax" },
  ["json5.vim"] = { "gutenye/json5.vim" },
  ["jsonc.vim"] = { "neoclide/jsonc.vim" },
  ["mkdx"] = { "SidOfc/mkdx" },
  ["nginx.vim"] = { "chr4/nginx.vim" },
  ["pgsql.vim"] = { "lifepillar/pgsql.vim" },
  ["php.vim"] = { "stanangeloff/php.vim" },
  ["requirements.txt.vim"] = { "raimon49/requirements.txt.vim" },
  ["scss-syntax.vim"] = { "cakebaker/scss-syntax.vim" },
  ["tabular"] = { "godlygeek/tabular" },
  ["tmux.vim"] = { "ericpruitt/tmux.vim" },
  ["vim-cpp-enhanced-highlight"] = { "octol/vim-cpp-enhanced-highlight" },
  ["vim-git"] = { "tpope/vim-git" },
  ["vim-gitignore"] = { "gisphm/vim-gitignore" },
  ["vim-glsl"] = { "tikhomirov/vim-glsl" },
  ["vim-graphql"] = { "jparise/vim-graphql" },
  ["vim-jinja2-syntax"] = { "glench/vim-jinja2-syntax" },
  ["vim-jq"] = { "bfrg/vim-jq" },
  ["vim-js"] = { "yuezk/vim-js" },
  ["vim-json"] = { "elzr/vim-json" },
  ["vim-jsx-pretty"] = { "maxmellon/vim-jsx-pretty" },
  ["vim-kubernetes"] = { "andrewstuart/vim-kubernetes" },
  ["vim-liquid"] = { "njhoffman/vim-liquid" },
  ["vim-log-highlighting"] = { "mtdl9/vim-log-highlighting" },
  ["vim-lua"] = { "tbastos/vim-lua" },
  ["vim-man"] = { "njhoffman/vim-man" }, -- {"vim-utils/vim-man"},
  ["vim-nix"] = { "lnl7/vim-nix" },
  ["vim-node"] = { "moll/vim-node" },
  ["vim-pandoc-syntax"] = { "vim-pandoc/vim-pandoc-syntax" },
  ["vim-puppet"] = { "rodjek/vim-puppet" },
  ["vim-systemd-syntax"] = { "wgwoods/vim-systemd-syntax" },
  ["vim-terraform"] = { "hashivim/vim-terraform" },
  ["yats.vim"] = { "herringtondarkholme/yats.vim" },
  ["zinit-vim-syntax"] = { "zdharma-continuum/zinit-vim-syntax" }

  -- use "plasticboy/vim-markdown"
  -- use "xolox/vim-lua-inspect"
  -- use { "xolox/vim-lua-ftplugin", requires = "xolox/vim-misc" }
  -- use "tpope/vim-liquid"
  -- use "kchmck/vim-coffee-script"
}

M.completion_plugins = {
  ["nvim-cmp"] = { "hrsh7th/nvim-cmp" },
  ["cmp-nvim-lsp-document-symbol"] = { "hrsh7th/cmp-nvim-lsp-document-symbol", after = "nvim-cmp" },
  ["cmp-emoji"] = { "hrsh7th/cmp-emoji", after = "nvim-cmp" },
  ["cmp-nvim-lua"] = { "hrsh7th/cmp-nvim-lua", after = "nvim-cmp" },
  ["cmp-nvim-lsp"] = { "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp" },
  ["cmp-buffer"] = { "hrsh7th/cmp-buffer", after = "nvim-cmp" },
  ["cmp-calc"] = { "hrsh7th/cmp-calc", after = "nvim-cmp" },
  ["cmp-path"] = { "hrsh7th/cmp-path", after = "nvim-cmp" },
  ["cmp-cmdline"] = { "hrsh7th/cmp-cmdline", after = "nvim-cmp" },
  ["cmp-vsnip"] = { "hrsh7th/cmp-vsnip", after = "nvim-cmp", requires = "hrsh7th/vim-vsnip" },
  ["cmp-nvim-lsp-signature-help"] = { "hrsh7th/cmp-nvim-lsp-signature-help", after = "nvim-cmp" },
  ["cmp-under-comparator"] = { "lukas-reineke/cmp-under-comparator", after = "nvim-cmp" },
  ["cmp-treesitter"] = { "ray-x/cmp-treesitter", after = "nvim-cmp" },
  ["cmp-spell"] = { "f3fora/cmp-spell", after = "nvim-cmp" },
  ["cmp-npm"] = { "David-Kunz/cmp-npm", after = "nvim-cmp" },
  ["cmp-zsh"] = { "tamago324/cmp-zsh", after = "nvim-cmp" },
  ["cmp-vimwiki-tags"] = { "pontusk/cmp-vimwiki-tags", after = "nvim-cmp" },
  ["cmp-pandoc-references"] = { "jc-doyle/cmp-pandoc-references", after = "nvim-cmp" },
  -- ["cmp-tabnine"] = { "tzachar/cmp-tabnine", run = "./install.sh", after = "nvim-cmp" },
  ["cmp-git"] = { "petertriho/cmp-git", requires = "nvim-lua/plenary.nvim", after = "nvim-cmp" },
  ["cmp-tmux"] = { "andersevenrud/cmp-tmux", after = "nvim-cmp" },
  -- ["vim-dadbod-completion"] = {
  --   "kristijanhusak/vim-dadbod-completion",
  --   requires = "tpope/vim-dadbod",
  --   after = "nvim-cmp"
  -- },
  ["friendly-snippets"] = { "rafamadriz/friendly-snippets" },
  ["vs-snippets"] = { "kitagry/vs-snippets" },
  ["vscode-es7-javascript-react-snippets"] = {
    "dsznajder/vscode-es7-javascript-react-snippets",
    run = "yarn install --frozen-lockfile && yarn compile"
  }
}

M.ui_plugins = {
  -- ["startup.nvim"] = {
  --   use = {"startup-nvim/startup.nvim", requires = {"nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim"}}
  -- },
  ["aerial.nvim"] = { "stevearc/aerial.nvim" },
  ["dressing-nvim"] = { "stevearc/dressing.nvim", requires = "MunifTanjim/nui.nvim" },
  ["nvim-hlslens"] = { "kevinhwang91/nvim-hlslens" },
  ["nvim-notify"] = { "rcarriga/nvim-notify" },
  ["nvim-scrollbar"] = { "petertriho/nvim-scrollbar" },
  ["specs.nvim"] = { "edluffy/specs.nvim" },
  ["stabilize.nvim"] = { "luukvbaal/stabilize.nvim" },
  ["todo-comments.nvim"] = { "robertgzr/todo-comments.nvim" }, -- folke/todo-comments
  ["twilight.nvim"] = { "folke/twilight.nvim" },
  ["vim-HiLinkTrace"] = { "gerw/vim-HiLinkTrace" },
  ["vim-bling"] = { "ivyl/vim-bling" },
  ["vim-cool"] = { "romainl/vim-cool" },
  ["vim-hexokinase"] = { "RRethy/vim-hexokinase", run = "make hexokinase" },
  ["vim-plugin-AnsiEsc"] = { "joeysino/vim-plugin-AnsiEsc" },
  ["vimade"] = { "TaDaa/vimade" },
  ["which-key.nvim"] = { "folke/which-key.nvim" },
  ["zen-mode.nvim"] = { "folke/zen-mode.nvim" },
  ["hop.nvim"] = { "phaazon/hop.nvim" },
  -- ["wilder.nvim"] = {
  --   "gelguy/wilder.nvim",
  --   rocks = { "luarocks-fetch-gitrec", "pcre2" },
  --   requires = { "romgrk/fzy-lua-native", "kyazdani42/nvim-web-devicons" }
  -- }
}

M.project_plugins = {
  ["auto-session"]       = { "rmagatti/auto-session" },
  ["competitest.nvim"]   = { "xeluxee/competitest.nvim", requires = "MunifTanjim/nui.nvim" },
  ["cpbooster.vim"]      = { "searleser97/cpbooster.vim" },
  ["gitsigns.nvim"]      = { "lewis6991/gitsigns.nvim", requires = { "nvim-lua/plenary.nvim" } },
  ["nvim-projectconfig"] = { "windwp/nvim-projectconfig" },
  ["project-nvim"]       = { "ahmedkhalf/project.nvim" }, -- TODO: load before telescope
  ["octo.nvim"]          = { "pwntester/octo.nvim", requires = "kyazdani42/nvim-web-devicons" },
  ["vim-flog"]           = { "rbong/vim-flog" },
  ["vim-fugitive"]       = { "tpope/vim-fugitive" },
  ["vim-rhubarb"]        = { "tpope/vim-rhubarb" },
  ["vim-wakatime"]       = { "wakatime/vim-wakatime" }
}

M.interface_plugins = {
  -- ["yank-history"] = {"yazgoo/yank-history"},
  ["alpha-nvim"]     = { "goolord/alpha-nvim", requires = "kyazdani42/nvim-web-devicons" },
  ["diffview.nvim"]  = { "sindrets/diffview.nvim" },
  ["nvim-bqf"]       = { "kevinhwang91/nvim-bqf" },
  ["nvim-tree.lua"]  = { "kyazdani42/nvim-tree.lua" },
  ["perfanno.nvim"]  = { "t-troebst/perfanno.nvim" },
  ["quickmath.nvim"] = { "jbyuki/quickmath.nvim" },
  ["registers.nvim"] = { "tversteeg/registers.nvim" },
  ["vim-floaterm"]   = { "voldikss/vim-floaterm" },
  ["vim-mundo"]      = { "simnalamburt/vim-mundo" },
  ["vim-qf"]         = { "romainl/vim-qf" },
  ["vim-qf-history"] = { "bfrg/vim-qf-history" },
  ["vim-yoink"]      = { "svermeulen/vim-yoink" }
}

M.integration_plugins = {
  ["asynctasks.vim"] = { "skywind3000/asynctasks.vim", requires = "skywind3000/asyncrun.vim" },
  ["cheat.sh-vim"] = { "dbeniamine/cheat.sh-vim" },
  ["id3.vim"] = { "AndrewRadev/id3.vim" },
  ["nvim-magic"] = { "jameshiew/nvim-magic", requires = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim" } },
  ["nvim-luapad"] = { "rafcamlet/nvim-luapad" },
  ["sniprun"] = { "michaelb/sniprun", run = "bash ./install.sh" },
  ["package-info.nvim"] = { "vuki656/package-info.nvim", requires = "MunifTanjim/nui.nvim" },
  ["vim-dadbod-ui"] = { "kristijanhusak/vim-dadbod-ui", requires = "tpope/vim-dadbod" },
  ["vim-ripple"] = { "urbainvaes/vim-ripple" },
  ["vim-test"] = { "vim-test/vim-test" },
  ["rest.nvim"] = { "NTBBloodbath/rest.nvim" },
  ["lazygit.nvim"] = { "kdheepak/lazygit.nvim" },
  ["tmux.nvim"] = { "aserowy/tmux.nvim" },
  ["nvim-regexplainer"] = {
    "bennypowers/nvim-regexplainer",
    requires = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim"
    }
  }
}

M.sysutil_plugins = {
  ["vim-renamer"] = { "qpkorr/vim-renamer" },
  ["nvim-remote-containers"] = { "jamestthompson3/nvim-remote-containers" },
  ["suda.vim"] = { "lambdalisue/suda.vim" },
  ["vim-scriptease"] = { "tpope/vim-scriptease" },
  ["vim-symlink"] = { "aymericbeaumet/vim-symlink" },
  ["vim-profiler"] = { "bchretien/vim-profiler" },
  ["startuptime.vim"] = { "tweekmonster/startuptime.vim" }
}

M.lsp_plugins = {
  ["fidget.nvim"] = { "j-hui/fidget.nvim" },
  ["null-ls.nvim"] = { "jose-elias-alvarez/null-ls.nvim", requires = "nvim-lua/plenary.nvim" },
  ["lua-dev.nvim"] = { "folke/lua-dev.nvim" },
  ["lsp-colors.nvim"] = { "folke/lsp-colors.nvim" },
  ["nvim-lightbulb"] = { "kosayoda/nvim-lightbulb" },
  ["lsp_signature.nvim"] = { "ray-x/lsp_signature.nvim" },
  ["lspsaga.nvim"] = { "glepnir/lspsaga.nvim" },
  ["nvim-code-action-menu"] = { "weilbith/nvim-code-action-menu", cmd = "CodeActionMenu" },
  ["nvim-lsp-installer"] = { "williamboman/nvim-lsp-installer", requires = "neovim/nvim-lspconfig" },
  ["nvim-lspconfig"] = { "neovim/nvim-lspconfig" },
  ["trouble.nvim"] = { "folke/trouble.nvim" },
  ["ntangle-lsp.nvim"] = {
    "jbyuki/ntangle-lsp.nvim",
    requires = { "jbyuki/ntangle-ts.nvim", "neovim/nvim-lspconfig" }
  },
  ["sqls.nvim"] = { "nanotee/sqls.nvim", after = "nvim-lspconfig" }
}

M.theme_plugins = {
  ["feline.nvim"] = { "feline-nvim/feline.nvim" },
  ["barbar"] = { "romgrk/barbar.nvim" },
  ["lush.nvim"] = { "rktjmp/lush.nvim" },
}

M.check_require_exists = function(fname)
  local res = pcall(require, fname)
  return res
  -- local f=io.open(name,"r")
  -- if f ~= nil then io.close(f) return true else return false end
end

M.check_path_exists = function(path)
  path = path:gsub("~", os.getenv { "HOME" })
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
  for str in string.gmatch(env_name, "{[^" .. sep .. "]+}") do
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
    M.mapping_plugins,
    M.buffer_plugins,
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
    for name, plugin in pairs(plugin_set) do
      -- print(vim.inspect(plugin_item))
      if type(plugin) == "string" then
        plugin = { plugin }
      end

      local plugin_config = plugin.config or M.plugin_config(name)

      if plugin_config ~= nil then
        plugin.config = plugin_config
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
