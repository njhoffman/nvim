local M = {}

M.plugins = {
  -- ['JABS.nvim'] = {},
  -- ['Nvim-Switch-Buffer'] = {},
  -- ['TrueZen.nvim'] = {},
  -- ['alpha-nvim'] = {},
  -- ['asyncrun.vim'] = {},
  -- ['asynctasks.vim'] = {},
  -- ['auto-session'] = {},
  -- ['barbar.nvim'] = {},
  -- ['bat.vim'] = {},
  -- ['bats.vim'] = {},
  -- ['cheat.sh-vim'] = {},
  -- ['cheatsheet.nvim'] = {},
  -- ['clever-f.vim'] = {},
  -- ['cmd-parser.nvim'] = {},
  -- ['cmp-buffer'] = {},
  -- ['cmp-calc'] = {},
  -- ['cmp-cmdline'] = {},
  -- ['cmp-dictionary'] = {},
  -- ['cmp-emoji'] = {},
  -- ['cmp-git'] = {},
  -- ['cmp-npm'] = {},
  -- ['cmp-nvim-lsp'] = {},
  -- ['cmp-nvim-lsp-document-symbol'] = {},
  -- ['cmp-nvim-lsp-signature-help'] = {},
  -- ['cmp-pandoc-references'] = {},
  -- ['cmp-path'] = {},
  -- ['cmp-rg'] = {},
  -- ['cmp-spell'] = {},
  -- ['cmp-tabnine'] = {},
  -- ['cmp-treesitter'] = {},
  -- ['cmp-under-comparator'] = {},
  -- ['cmp-vimwiki-tags'] = {},
  -- ['cmp-vsnip'] = {},
  -- ['cmp-zsh'] = {},
  -- ['compe-tmux'] = {},
  -- ['conflict-marker.vim'] = {},
  -- ['core'] = {},
  -- ['dial.nvim'] = {},
  -- ['diffview.nvim'] = {},
  -- ['doom-one.vim'] = {},
  -- ['editorconfig-vim'] = {},
  -- ['feline.nvim'] = {},
  -- ['float-preview.nvim'] = {},
  -- ['friendly-snippets'] = {},
  -- ['fzf-floaterm'] = {},
  -- ['fzy-lua-native'] = {},
  -- ['fzy-vim'] = {},
  -- ['gitsigns.nvim'] = {},
  -- ['glow.nvim'] = {},
  -- ['hop.nvim'] = {},
  -- ['i3-vim-syntax'] = {},
  -- ['id3.vim'] = {},
  -- ['impatient.nvim'] = {},
  -- ['iswap.nvim'] = {},
  -- ['jsonc.vim'] = {},
  -- ['kommentary'] = {},
  -- ['lsp-colors.nvim'] = {},
  -- ['lsp-status.nvim'] = {},
  -- ['lsp_extensions.nvim'] = {},
  -- ['lsp_signature.nvim'] = {},
  -- ['lspsaga.nvim'] = {},
  -- ['lua-dev.nvim'] = {},
  -- ['lush.nvim'] = {},
  -- ['markdown-preview.nvim'] = {},
  -- ['mkdx'] = {},
  -- ['neuron-v2.vim'] = {},
  -- ['neuron.nvim'] = {},
  -- ['nnn.nvim'] = {},
  -- ['nui.nvim'] = {},
  -- ['nvim-autopairs'] = {},
  -- ['nvim-bqf'] = {},
  -- ['nvim-bufdel'] = {},
  -- ['nvim-cmp'] = {},
  -- ['nvim-dap'] = {},
  -- ['nvim-dap-python'] = {},
  -- ['nvim-dap-ui'] = {},
  -- ['nvim-dap-virtual-text'] = {},
  -- ['nvim-fzf'] = {},
  -- ['nvim-hlslens'] = {},
  -- ['nvim-lightbulb'] = {},
  -- ['nvim-lsp-installer'] = {},
  -- ['nvim-lsp-ts-utils'] = {},
  -- ['nvim-lspconfig'] = {},
  -- ['nvim-luapad'] = {},
  -- ['nvim-mapper'] = {},
  -- ['nvim-neoclip.lua'] = {},
  -- ['nvim-projectconfig'] = {},
  -- ['nvim-remote-containers'] = {},
  -- ['nvim-startup.lua'] = {},
  -- ['nvim-tree.lua'] = {},
  -- ['nvim-treesitter'] = {},
  -- ['nvim-treesitter-pairs'] = {},
  -- ['nvim-treesitter-refactor'] = {},
  -- ['nvim-treesitter-textobjects'] = {},
  -- ['nvim-treesitter-textsubjects'] = {},
  -- ['nvim-ts-autotag'] = {},
  -- ['nvim-ts-context-commentstring'] = {},
  -- ['nvim-ts-rainbow'] = {},
  -- ['nvim-web-devicons'] = {},
  -- ['octo.nvim'] = {},
  -- ['one-small-step-for-vimkind'] = {},

  -- ['package-info.nvim'] = {},
  -- ['packer.nvim'] = {},
  -- ['pgsql.vim'] = {},
  -- ['php.vim'] = {},
  -- ['playground'] = {},
  -- ['plenary.nvim'] = {},
  -- ['popup.nvim'] = {},
  -- ['project.nvim'] = {},
  -- ['range-highlight.nvim'] = {},
  -- ['registers.nvim'] = {},
  -- ['requirements.txt.vim'] = {},
  -- ['rest.nvim'] = {},
  -- ['scss-syntax.vim'] = {},
  -- ['session-lens'] = {},
  -- ['slimux'] = {},
  -- ['sniprun'] = {},
  -- ['splitjoin.vim'] = {},
  -- ['sqlite.lua'] = {},
  -- ['sqls.nvim'] = {},
  -- ['stabilize.nvim'] = {},
  -- ['startuptime.vim'] = {},
  -- ['suda.vim'] = {},
  -- ['tabout.nvim'] = {},
  -- ['tabular'] = {},
  -- ['tagbar'] = {},
  -- ['taskwiki'] = {},
  -- ['telescope-asynctasks.nvim'] = {},
  -- ['telescope-bookmarks.nvim'] = {},
  -- ['telescope-dap.nvim'] = {},
  -- ['telescope-extensions'] = {},
  -- ['telescope-frecency.nvim'] = {},
  -- ['telescope-fzf-native.nvim'] = {},
  -- ['telescope-fzy-native.nvim'] = {},
  -- ['telescope-ghq.nvim'] = {},
  -- ['telescope-github.nvim'] = {},
  -- ['telescope-lsp-handlers.nvim'] = {},
  -- ['telescope-media-files.nvim'] = {},
  -- ['telescope-packer.nvim'] = {},
  -- ['telescope-symbols.nvim'] = {},
  -- ['telescope-tmux.nvim'] = {},
  -- ['telescope-z.nvim'] = {},
  -- ['telescope.nvim'] = {},
  -- ['tmux.vim'] = {},
  -- ['todo-comments.nvim'] = {},
  -- ['tree-sitter-markdown'] = {},
  -- ['trouble.nvim'] = {},
  -- ['twilight.nvim'] = {},
  -- ['vim-HiLinkTrace'] = {},
  -- ['vim-alias'] = {},
  -- ['vim-apm'] = {},
  -- ['vim-bbye'] = {},
  -- ['vim-camelsnek'] = {},
  -- ['vim-checkbox'] = {},
  -- ['vim-cool'] = {},
  -- ['vim-cpp-enhanced-highlight'] = {},
  -- ['vim-dadbod'] = {},
  -- ['vim-dadbod-completion'] = {},
  -- ['vim-dadbod-ui'] = {},
  -- ['vim-devicons'] = {},
  -- ['vim-docker-tools'] = {},
  -- ['vim-easy-align'] = {},
  -- ['vim-eunuch'] = {},
  -- ['vim-floaterm'] = {},
  -- ['vim-fugitive'] = {},
  -- ['vim-git'] = {},
  -- ['vim-gitignore'] = {},
  -- ['vim-hexokinase'] = {},
  -- ['vim-jq'] = {},
  -- ['vim-js'] = {},
  -- ['vim-json'] = {},
  -- ['vim-jsx-pretty'] = {},
  -- ['vim-kubernetes'] = {},
  -- ['vim-liquid'] = {},
  -- ['vim-log-highlighting'] = {},
  -- ['vim-lua'] = {},
  -- ['vim-mundo'] = {},
  -- ['vim-nix'] = {},
  -- ['vim-node'] = {},
  -- ['vim-pandoc-syntax'] = {},
  -- ['vim-pastebins'] = {},
  -- ['vim-plugin-AnsiEsc'] = {},
  -- ['vim-printer'] = {},
  -- ['vim-profiler'] = {},
  -- ['vim-qf'] = {},
  -- ['vim-qf-history'] = {},
  -- ['vim-renamer'] = {},
  -- ['vim-repeat'] = {},
  -- ['vim-rhubarb'] = {},
  -- ['vim-ripple'] = {},
  -- ['vim-sayonara'] = {},
  -- ['vim-scriptease'] = {},
  -- ['vim-searchsavvy'] = {},
  -- ['vim-sort-motion'] = {},
  -- ['vim-symlink'] = {},
  -- ['vim-systemd-syntax'] = {},
  -- ['vim-table-mode'] = {},
  -- ['vim-taskwarrior'] = {},
  -- ['vim-test'] = {},
  -- ['vim-vsnip'] = {},
  -- ['vim-wakatime'] = {},
  -- ['vimade'] = {},
  -- ['vimux'] = {},
  -- ['vimwiki'] = {},
  -- ['vista.vim'] = {},
  -- ['vs-snippets'] = {},
  -- ['which-key.nvim'] = {},
  -- ['wilder.nvim'] = {},
}

M.search_plugins = {
  ['vim-searchsavy'] = { use = { "idbrii/vim-searchsavvy" } }
}

M.treesitter_plugins = {
  ['tree-sitter-ntangle'] = { use = { "jbyuki/tree-sitter-ntangle" } }
}

M.dap_plugins = {
  ['dap-install'] = { use = "Pocco81/DAPInstall.nvim" },
  ['nvim-dap'] = { use = { "mfussenegger/nvim-dap" } },
  ['nvim-dap-ui'] = { use = { "rcarriga/nvim-dap-ui", requires = { "theHamsta/nvim-dap-virtual-text", "mfussenegger/nvim-dap" } }} ,
  ['one-small-step-for-vimkind'] = { use = { "jbyuki/one-small-step-for-vimkind", requires = "mfussenegger/nvim-dap" } },
  ['nvim-dap-python'] = { use = { "mfussenegger/nvim-dap-python", requires = "mfussenegger/nvim-dap" } },
  ['dash.nvim'] = { use = { "jbyuki/dash.nvim", requires = "jbyuki/ntangle.nvim" }},
  ['Telegraph.nvim'] = { use = { "WaylonWalker/Telegraph.nvim" } }
}

M.picker_plugins = {
  ["fzf.vim"] = { use = { "junegunn/fzf.vim" , requires = { "junegunn/fzf", "ryanoasis/vim-devicons" } } },
  ["fzf-preview.vim"] = { use = { "yuki-yano/fzf-preview.vim", requires = { "junegunn/fzf", dir = "~/.fzf", run = "./install --all" } } },
  ["fzf-lua"] = { use = { "ibhagwan/fzf-lua", requires = { "vijaymarupudi/nvim-fzf", "kyazdani42/nvim-web-devicons" } } },
  ["nvim-spotify"] = { use = {  "KadoBOT/nvim-spotify", requires = 'nvim-telescope/telescope.nvim', run = 'make' } }
}

M.skipped_plugins = {
  ['vista.vim'] = { use = "liuchengxu/vista.vim" },
}

M.motion_plugins = {
  ['vim-matchup'] = { use = "andymass/vim-matchup"},
  ['vim-wordmotion'] = { use = "chaoren/vim-wordmotion"},
  ['vim-smoothie'] = { use = "psliwka/vim-smoothie"},
  ['clever-f'] = { use = "rhysd/clever-f.vim"},
  ['marks.nvim'] = { use = "chentau/marks.nvim" },
}

M.format_plugins = {
  ["kommentary"]      = { use = { "b3nj5m1n/kommentary" }, },
  ['nvim-autopairs']  = { use = { "windwp/nvim-autopairs" } }, -- jiangmiao/auto-pairs
  ["splitjoin.vim"]   = { use = { "andrewradev/splitjoin.vim"} }, -- FooSoft/vim-argwrap
  ["vim-easy-align"]  = { use = { "junegunn/vim-easy-align" } }, -- tommcdo/vim-lion
  ["vim-table-mode"]  = { use = { "dhruvasagar/vim-table-mode"} },
  ['dial.nvim']       = { use = { "monaqa/dial.nvim" } },
  ['iswap.nvim']      = { use = { "mizlan/iswap.nvim" }},
  ['vim-camelsnek']   = { use = { "nicwest/vim-camelsnek" } },
  ['vim-checkbox']    = { use = { "jkramer/vim-checkbox" } },
  ['vim-sort-motion'] = { use = { "christoomey/vim-sort-motion" } },
  ["telekasten.nvim"] = { use = { "renerocksai/telekasten.nvim", requires = { "renerocksai/calendar-vim" } }},
}


M.syntax_plugins = {
  ["BetterLua.vim"]              = { use = "euclidianace/betterlua.vim" },
  ["Dockerfile.vim"]             = { use = "ekalinin/dockerfile.vim" },
  ["ansible-vim"]                = { use = "pearofducks/ansible-vim" },
  ["bat.vim"]                    = { use = "jamespwilliams/bat.vim" },
  ["bats.vim"]                   = { use = "aliou/bats.vim" },
  ["conflict-marker.vim"]        = { use = "rhysd/conflict-marker.vim" },
  ["editorconfig-vim"]           = { use = "editorconfig/editorconfig-vim" },
  ["glow.nvim"]                  = { use = "npxbr/glow.nvim" },
  ["i3-vim-syntax"]              = { use = "potatoesmaster/i3-vim-syntax" },
  ["json5.vim"]                  = { use = "gutenye/json5.vim" },
  ["jsonc.vim"]                  = { use = "neoclide/jsonc.vim" },
  ["mkdx"]                       = { use = "SidOfc/mkdx" },
  ["nginx.vim"]                  = { use = "chr4/nginx.vim" },
  ["pgsql.vim"]                  = { use = "lifepillar/pgsql.vim" },
  ["php.vim"]                    = { use = "stanangeloff/php.vim" },
  ["requirements.txt.vim"]       = { use = "raimon49/requirements.txt.vim" },
  ["scss-syntax.vim"]            = { use = "cakebaker/scss-syntax.vim" },
  ["tabular"]                    = { use = "godlygeek/tabular" },
  ["tmux.vim"]                   = { use = "ericpruitt/tmux.vim" },
  ["vim-cpp-enhanced-highlight"] = { use = "octol/vim-cpp-enhanced-highlight" },
  ["vim-git"]                    = { use = "tpope/vim-git" },
  ["vim-gitignore"]              = { use = "gisphm/vim-gitignore" },
  ["vim-glsl"]                   = { use = "tikhomirov/vim-glsl" },
  ["vim-graphql"]                = { use = "jparise/vim-graphql" },
  ["vim-jinja2-syntax"]          = { use = "glench/vim-jinja2-syntax" },
  ["vim-jq"]                     = { use = "bfrg/vim-jq" },
  ["vim-js"]                     = { use = "yuezk/vim-js" },
  ["vim-json"]                   = { use = "elzr/vim-json" },
  ["vim-jsx-pretty"]             = { use = "maxmellon/vim-jsx-pretty" },
  ["vim-kubernetes"]             = { use = "andrewstuart/vim-kubernetes" },
  ["vim-liquid"]                 = { use = "njhoffman/vim-liquid" },
  ["vim-log-highlighting"]       = { use = "mtdl9/vim-log-highlighting" },
  ["vim-lua"]                    = { use = "tbastos/vim-lua" },
  ["vim-man"]                    = { use = "njhoffman/vim-man" }, -- "vim-utils/vim-man"
  ["vim-nix"]                    = { use = "lnl7/vim-nix" },
  ["vim-node"]                   = { use = "moll/vim-node" },
  ["vim-pandoc-syntax"]          = { use = "vim-pandoc/vim-pandoc-syntax" },
  ["vim-puppet"]                 = { use = "rodjek/vim-puppet" },
  ["vim-systemd-syntax"]         = { use = "wgwoods/vim-systemd-syntax" },
  ["vim-terraform"]              = { use = "hashivim/vim-terraform" },
  ["yats.vim"]                   = { use = "herringtondarkholme/yats.vim" },
  ["zinit-vim-syntax"]           = { use = "zdharma-continuum/zinit-vim-syntax" },
  -- use "plasticboy/vim-markdown"
  -- use "xolox/vim-lua-inspect"
  -- use { "xolox/vim-lua-ftplugin", requires = "xolox/vim-misc" }
  -- use "tpope/vim-liquid"
  -- use "kchmck/vim-coffee-script"
}


M.ui_plugins = {
  ['aerial.nvim']    = { use = 'stevearc/aerial.nvim' },
  ['nvim-notify']    = { use = 'rcarriga/nvim-notify' },
  ['dressing-nvim']  = { use = { 'stevearc/dressing.nvim', requires = 'MunifTanjim/nui.nvim' } },
  ['vim-bling']      = { use = 'ivyl/vim-bling' },
  ['specs.nvim']     = { use = 'edluffy/specs.nvim' },
  ['nvim-scrollbar'] = { use = 'petertriho/nvim-scrollbar' }
}

M.project_plugins = {
  -- VimEnter necessary Otherwise it produces an error when a :Git buffer is open.
  ['gitsigns.nvim'] = { use = { "lewis6991/gitsigns.nvim", requires = { "nvim-lua/plenary.nvim" }, event = "VimEnter" } },
  ["vim-fugitive"]  = { use = "tpope/vim-fugitive" },
  ["vim-rhubarb"]   = { use = "tpope/vim-rhubarb" },
  ['vim-flog']      = { use = 'rbong/vim-flog' },
  ["competitest.nvim"] = { use = {'xeluxee/competitest.nvim', requires = 'MunifTanjim/nui.nvim' }},
  ["cpbooster.vim"] = { use = "searleser97/cpbooster.vim"}
}

M.interface_plugins = {
  ['quickmath-nvim'] = { use = "jbyuki/quickmath.nvim" },
  ['yank-history']   = { use =  "yazgoo/yank-history" },
  ['vim-yoink']      = { use =  "svermeulen/vim-yoink" },
  ["nvim-bqf"]       = { use =  "kevinhwang91/nvim-bqf" },
  ["vim-qf"]         = { use =  "romainl/vim-qf" },
  ["vim-qf-history"] = { use =  "bfrg/vim-qf-history" },
}

M.lsp_plugins = {
  ['fidget.nvim']  = { use = "j-hui/fidget.nvim"  },
  ['null-ls.nvim'] = { use = { "jose-elias-alvarez/null-ls.nvim", requires = "nvim-lua/plenary.nvim" } } ,
  ['jbyuki/ntangle-lsp.nvim'] = { use = { "jbyuki/ntangle-lsp.nvim", requires = { 'jbyuki/ntangle-ts.nvim' ,'neovim/nvim-lspconfig' }}},
}

M.check_require_exists = function(fname)
  local res = pcall(require, fname)
  return res
  -- local f=io.open(name,"r")
  -- if f ~= nil then io.close(f) return true else return false end
end

M.check_path_exists = function(path)
  path = path:gsub("~", os.getenv('HOME'))
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
  for str in string.gmatch(env_name, "([^"..sep.."]+)") do
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
  config_loaded = 0,
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
  end
  return config
end

M.load_plugins = function(use, load_config)
  local env_lazy = os.getenv('NVIM_PLUGINS_LAZY')
  local env_disable = os.getenv('NVIM_PLUGINS_DISABLE')
  local env_skip = os.getenv('NVIM_PLUGINS_SKIP')

  -- local lazy = M.concat_array(env_lazy, load_config.lazy)
  -- local disable = M.concat_array(env_disable, load_config.disable)
  -- local skip = M.concat_array(env_skip, load_config.skip)

  local all_plugins = {
    M.dap_plugins,
    M.ui_plugins,
    M.format_plugins,
    M.lsp_plugins,
    M.motion_plugins,
    M.interface_plugins,
    M.picker_plugins,
    M.project_plugins,
    M.syntax_plugins,
    M.treesitter_plugins,
    M.search_plugins
  }

  for _, plugin_set in pairs(all_plugins) do
    for name, plugin_item in pairs(plugin_set) do
      -- print(vim.inspect(plugin_item))
      local plugin = plugin_item.use
      if type(plugin) == 'string' then plugin = { plugin } end

      local plugin_config = plugin.config or M.plugin_config(name)
      if plugin_config ~= nil then plugin.config = plugin_config end

      if plugin_item.src ~= nil then
        if type(plugin_item.src) ~= "table" then
          plugin_item.src = { plugin_item.src }
        end
        if M.check_path_exists(plugin_item.src[1]) then
          M.stats.local_loaded = M.stats.local_loaded + 1
          plugin = plugin_item.src
        end
      elseif plugin_item.fork ~= nil then
        if type(plugin_item.fork) ~= "table" then
          plugin_item.fork= { plugin_item.fork }
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
