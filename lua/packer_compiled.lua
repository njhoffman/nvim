-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

  local time
  local profile_info
  local should_profile = false
  if should_profile then
    local hrtime = vim.loop.hrtime
    profile_info = {}
    time = function(chunk, start)
      if start then
        profile_info[chunk] = hrtime()
      else
        profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
      end
    end
  else
    time = function(chunk, start) end
  end
  
local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end

  _G._packer = _G._packer or {}
  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/home/nicholas/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/home/nicholas/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/home/nicholas/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/home/nicholas/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/home/nicholas/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s), name, _G.packer_plugins[name])
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  ["DAPInstall.nvim"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/DAPInstall.nvim",
    url = "https://github.com/Pocco81/DAPInstall.nvim"
  },
  ["JABS.nvim"] = {
    config = { "\27LJ\2\n4\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\25plugins.configs.jabs\frequire\0" },
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/JABS.nvim",
    url = "https://github.com/matbme/JABS.nvim"
  },
  ["Nvim-Switch-Buffer"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/Nvim-Switch-Buffer",
    url = "https://github.com/Yohannfra/Nvim-Switch-Buffer"
  },
  ["Telegraph.nvim"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/Telegraph.nvim",
    url = "https://github.com/WaylonWalker/Telegraph.nvim"
  },
  ["TrueZen.nvim"] = {
    config = { "\27LJ\2\n7\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\28plugins.configs.truezen\frequire\0" },
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/TrueZen.nvim",
    url = "https://github.com/Pocco81/TrueZen.nvim"
  },
  ["aerial.nvim"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/aerial.nvim",
    url = "https://github.com/stevearc/aerial.nvim"
  },
  ["alpha-nvim"] = {
    config = { "\27LJ\2\n:\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\31plugins.configs.alpha-nvim\frequire\0" },
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/alpha-nvim",
    url = "https://github.com/goolord/alpha-nvim"
  },
  ["ansible-vim"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/ansible-vim",
    url = "https://github.com/pearofducks/ansible-vim"
  },
  ["asyncrun.vim"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/asyncrun.vim",
    url = "https://github.com/skywind3000/asyncrun.vim"
  },
  ["asynctasks.vim"] = {
    config = { "\27LJ\2\n:\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\31plugins.configs.asynctasks\frequire\0" },
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/asynctasks.vim",
    url = "https://github.com/skywind3000/asynctasks.vim"
  },
  ["auto-session"] = {
    config = { "\27LJ\2\n<\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0!plugins.configs.auto-session\frequire\0" },
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/auto-session",
    url = "https://github.com/rmagatti/auto-session"
  },
  ["barbar.nvim"] = {
    config = { "\27LJ\2\n6\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\27plugins.configs.barbar\frequire\0" },
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/barbar.nvim",
    url = "https://github.com/romgrk/barbar.nvim"
  },
  ["bat.vim"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/bat.vim",
    url = "https://github.com/jamespwilliams/bat.vim"
  },
  ["bats.vim"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/bats.vim",
    url = "https://github.com/aliou/bats.vim"
  },
  ["betterlua.vim"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/betterlua.vim",
    url = "https://github.com/euclidianace/betterlua.vim"
  },
  ["calendar-vim"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/calendar-vim",
    url = "https://github.com/renerocksai/calendar-vim"
  },
  ["cheat.sh-vim"] = {
    config = { "\27LJ\2\n<\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0!plugins.configs.cheat_sh-vim\frequire\0" },
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/cheat.sh-vim",
    url = "https://github.com/dbeniamine/cheat.sh-vim"
  },
  ["cheatsheet.nvim"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/cheatsheet.nvim",
    url = "https://github.com/sudormrfbin/cheatsheet.nvim"
  },
  ["clever-f.vim"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/clever-f.vim",
    url = "https://github.com/rhysd/clever-f.vim"
  },
  ["cmd-parser.nvim"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/cmd-parser.nvim",
    url = "https://github.com/winston0410/cmd-parser.nvim"
  },
  ["cmp-buffer"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/cmp-buffer",
    url = "https://github.com/hrsh7th/cmp-buffer"
  },
  ["cmp-calc"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/cmp-calc",
    url = "https://github.com/hrsh7th/cmp-calc"
  },
  ["cmp-cmdline"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/cmp-cmdline",
    url = "https://github.com/hrsh7th/cmp-cmdline"
  },
  ["cmp-emoji"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/cmp-emoji",
    url = "https://github.com/hrsh7th/cmp-emoji"
  },
  ["cmp-git"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/cmp-git",
    url = "https://github.com/petertriho/cmp-git"
  },
  ["cmp-npm"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/cmp-npm",
    url = "https://github.com/David-Kunz/cmp-npm"
  },
  ["cmp-nvim-lsp"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp",
    url = "https://github.com/hrsh7th/cmp-nvim-lsp"
  },
  ["cmp-nvim-lua"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/cmp-nvim-lua",
    url = "https://github.com/hrsh7th/cmp-nvim-lua"
  },
  ["cmp-pandoc-references"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/cmp-pandoc-references",
    url = "https://github.com/jc-doyle/cmp-pandoc-references"
  },
  ["cmp-path"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/cmp-path",
    url = "https://github.com/hrsh7th/cmp-path"
  },
  ["cmp-spell"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/cmp-spell",
    url = "https://github.com/f3fora/cmp-spell"
  },
  ["cmp-tabnine"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/cmp-tabnine",
    url = "https://github.com/tzachar/cmp-tabnine"
  },
  ["cmp-treesitter"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/cmp-treesitter",
    url = "https://github.com/ray-x/cmp-treesitter"
  },
  ["cmp-under-comparator"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/cmp-under-comparator",
    url = "https://github.com/lukas-reineke/cmp-under-comparator"
  },
  ["cmp-vimwiki-tags"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/cmp-vimwiki-tags",
    url = "https://github.com/pontusk/cmp-vimwiki-tags"
  },
  ["cmp-vsnip"] = {
    after = { "friendly-snippets", "vs-snippets" },
    after_files = { "/home/nicholas/.local/share/nvim/site/pack/packer/opt/cmp-vsnip/after/plugin/cmp_vsnip.vim" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/opt/cmp-vsnip",
    url = "https://github.com/hrsh7th/cmp-vsnip"
  },
  ["cmp-zsh"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/cmp-zsh",
    url = "https://github.com/tamago324/cmp-zsh"
  },
  ["conflict-marker.vim"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/conflict-marker.vim",
    url = "https://github.com/rhysd/conflict-marker.vim"
  },
  core = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/core",
    url = "https://github.com/ido-nvim/core"
  },
  ["dash.nvim"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/dash.nvim",
    url = "https://github.com/jbyuki/dash.nvim"
  },
  ["dial.nvim"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/dial.nvim",
    url = "https://github.com/monaqa/dial.nvim"
  },
  ["diffview.nvim"] = {
    config = { "\27LJ\2\n8\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\29plugins.configs.diffview\frequire\0" },
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/diffview.nvim",
    url = "https://github.com/sindrets/diffview.nvim"
  },
  ["dockerfile.vim"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/dockerfile.vim",
    url = "https://github.com/ekalinin/dockerfile.vim"
  },
  ["doom-one.vim"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/doom-one.vim",
    url = "https://github.com/romgrk/doom-one.vim"
  },
  ["dressing.nvim"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/dressing.nvim",
    url = "https://github.com/stevearc/dressing.nvim"
  },
  ["editorconfig-vim"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/editorconfig-vim",
    url = "https://github.com/editorconfig/editorconfig-vim"
  },
  ["feline.nvim"] = {
    config = { "\27LJ\2\n›\3\0\0\3\0\f\0$6\0\0\0009\0\1\0'\2\2\0B\0\2\0016\0\3\0'\2\4\0B\0\2\0016\0\0\0009\0\1\0'\2\5\0B\0\2\0016\0\0\0009\0\1\0'\2\6\0B\0\2\0016\0\0\0009\0\1\0'\2\a\0B\0\2\0016\0\0\0009\0\1\0'\2\b\0B\0\2\0016\0\0\0009\0\1\0'\2\t\0B\0\2\0016\0\0\0009\0\1\0'\2\n\0B\0\2\0016\0\0\0009\0\1\0'\2\v\0B\0\2\1K\0\1\0#hi link diffIndexFile DiffText\30hi link diffFile DiffText hi link diffNewFile DiffAdd\30hi link diffLine DiffText#hi link diffChanged DiffChange#hi link diffRemoved DiffDelete\30hi link diffAdded DiffAdd\27plugins.configs.feline\frequire\26colorscheme nord-nick\bcmd\bvim\0" },
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/feline.nvim",
    url = "https://github.com/famiu/feline.nvim"
  },
  ["float-preview.nvim"] = {
    config = { "\27LJ\2\n=\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\"plugins.configs.float-preview\frequire\0" },
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/float-preview.nvim",
    url = "https://github.com/ncm2/float-preview.nvim"
  },
  ["friendly-snippets"] = {
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/opt/friendly-snippets",
    url = "https://github.com/rafamadriz/friendly-snippets"
  },
  fzf = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/fzf",
    url = "https://github.com/junegunn/fzf"
  },
  ["fzf-floaterm"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/fzf-floaterm",
    url = "https://github.com/voldikss/fzf-floaterm"
  },
  ["fzf-lua"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/fzf-lua",
    url = "https://github.com/ibhagwan/fzf-lua"
  },
  ["fzf-preview.vim"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/fzf-preview.vim",
    url = "https://github.com/yuki-yano/fzf-preview.vim"
  },
  ["fzf.vim"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/fzf.vim",
    url = "https://github.com/junegunn/fzf.vim"
  },
  ["fzy-lua-native"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/fzy-lua-native",
    url = "https://github.com/romgrk/fzy-lua-native"
  },
  ["github-notifications.nvim"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/github-notifications.nvim",
    url = "https://github.com/rlch/github-notifications.nvim"
  },
  ["gitsigns.nvim"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/opt/gitsigns.nvim",
    url = "https://github.com/lewis6991/gitsigns.nvim"
  },
  ["glow.nvim"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/glow.nvim",
    url = "https://github.com/npxbr/glow.nvim"
  },
  ["hop.nvim"] = {
    config = { "\27LJ\2\nU\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\1\tkeys\28etovxqpdygfblzhckisuran\nsetup\bhop\frequire\0" },
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/hop.nvim",
    url = "https://github.com/phaazon/hop.nvim"
  },
  ["i3-vim-syntax"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/i3-vim-syntax",
    url = "https://github.com/potatoesmaster/i3-vim-syntax"
  },
  ["id3.vim"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/id3.vim",
    url = "https://github.com/AndrewRadev/id3.vim"
  },
  ["iswap.nvim"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/iswap.nvim",
    url = "https://github.com/mizlan/iswap.nvim"
  },
  ["json5.vim"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/json5.vim",
    url = "https://github.com/gutenye/json5.vim"
  },
  ["jsonc.vim"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/jsonc.vim",
    url = "https://github.com/neoclide/jsonc.vim"
  },
  kommentary = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/kommentary",
    url = "https://github.com/b3nj5m1n/kommentary"
  },
  ["lsp-colors.nvim"] = {
    config = { "\27LJ\2\n:\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\31plugins.configs.lsp-colors\frequire\0" },
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/lsp-colors.nvim",
    url = "https://github.com/folke/lsp-colors.nvim"
  },
  ["lsp_extensions.nvim"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/lsp_extensions.nvim",
    url = "https://github.com/nvim-lua/lsp_extensions.nvim"
  },
  ["lsp_signature.nvim"] = {
    config = { "\27LJ\2\n=\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\"plugins.configs.lsp_signature\frequire\0" },
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/lsp_signature.nvim",
    url = "https://github.com/ray-x/lsp_signature.nvim"
  },
  ["lspsaga.nvim"] = {
    config = { "\27LJ\2\n7\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\28plugins.configs.lspsaga\frequire\0" },
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/lspsaga.nvim",
    url = "https://github.com/glepnir/lspsaga.nvim"
  },
  ["lua-dev.nvim"] = {
    config = { "\27LJ\2\n7\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\28plugins.configs.lua-dev\frequire\0" },
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/lua-dev.nvim",
    url = "https://github.com/folke/lua-dev.nvim"
  },
  ["lush.nvim"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/lush.nvim",
    url = "https://github.com/rktjmp/lush.nvim"
  },
  ["markdown-preview.nvim"] = {
    config = { "\27LJ\2\n@\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0%plugins.configs.markdown-preview\frequire\0" },
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/markdown-preview.nvim",
    url = "https://github.com/iamcco/markdown-preview.nvim"
  },
  ["marks.nvim"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/marks.nvim",
    url = "https://github.com/chentau/marks.nvim"
  },
  mkdx = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/mkdx",
    url = "https://github.com/SidOfc/mkdx"
  },
  ["neuron.nvim"] = {
    config = { "\27LJ\2\n6\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\27plugins.configs.neuron\frequire\0" },
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/neuron.nvim",
    url = "https://github.com/oberblastmeister/neuron.nvim"
  },
  ["nginx.vim"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/nginx.vim",
    url = "https://github.com/chr4/nginx.vim"
  },
  ["nnn.nvim"] = {
    config = { "\27LJ\2\nÞ\5\0\0\5\1 \00086\0\0\0'\2\1\0B\0\2\0029\0\2\0004\1\b\0005\2\3\0009\3\4\0>\3\2\2>\2\1\0015\2\5\0009\3\6\0>\3\2\2>\2\2\0015\2\a\0009\3\b\0>\3\2\2>\2\3\0015\2\t\0009\3\n\0>\3\2\2>\2\4\0015\2\v\0009\3\f\0>\3\2\2>\2\5\0015\2\r\0009\3\14\0>\3\2\2>\2\6\0015\2\15\0009\3\16\0>\3\2\2>\2\a\0017\1\17\0005\1\19\0005\2\18\0=\2\20\0015\2\21\0005\3\22\0=\3\23\2=\2\24\0015\2\25\0005\3\26\0=\3\27\2=\2\28\0014\2\0\0=\2\17\0015\2\29\0=\2\30\0016\2\0\0'\4\1\0B\2\2\0029\2\31\2-\4\0\0B\2\2\1K\0\1\0\1\0\nsetup\14windownav\1\0\2\nright\v<C-w>l\tleft\v<C-w>h\14auto_open\14ft_ignore\1\2\0\0\14gitcommit\1\0\1\nempty\1\vpicker\nstyle\1\0\5\vborder\frounded\fyoffset\4\0€€€ÿ\3\vheight\4š³æÌ\t™³¦ÿ\3\nwidth\4Í™³æ\fÌ™³ÿ\3\fxoffset\4\0€€€ÿ\3\1\0\2\fsession\5\bcmd\29tmux new-session nnn -Pp\rexplorer\1\0\1\15auto_close\1\1\0\5\bcmd\vnnn -G\fsession\5\ttabs\2\nwidth\3\24\tside\ftopleft\rmappings\21populate_cmdline\1\2\0\0\n<C-e>\15cd_to_path\1\2\0\0\n<C-w>\22copy_to_clipboard\1\2\0\0\n<C-y>\20open_in_preview\1\2\0\0\n<C-p>\19open_in_vsplit\1\2\0\0\n<C-v>\18open_in_split\1\2\0\0\n<C-s>\16open_in_tab\1\2\0\0\n<C-t>\fbuiltin\bnnn\frequire\0" },
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/nnn.nvim",
    url = "https://github.com/luukvbaal/nnn.nvim"
  },
  ["ntangle-lsp.nvim"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/ntangle-lsp.nvim",
    url = "https://github.com/jbyuki/ntangle-lsp.nvim"
  },
  ["ntangle-ts.nvim"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/ntangle-ts.nvim",
    url = "https://github.com/jbyuki/ntangle-ts.nvim"
  },
  ["ntangle.nvim"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/ntangle.nvim",
    url = "https://github.com/jbyuki/ntangle.nvim"
  },
  ["nui.nvim"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/nui.nvim",
    url = "https://github.com/MunifTanjim/nui.nvim"
  },
  ["null-ls.nvim"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/null-ls.nvim",
    url = "https://github.com/jose-elias-alvarez/null-ls.nvim"
  },
  ["nvim-autopairs"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/nvim-autopairs",
    url = "https://github.com/windwp/nvim-autopairs"
  },
  ["nvim-bqf"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/nvim-bqf",
    url = "https://github.com/kevinhwang91/nvim-bqf"
  },
  ["nvim-bufdel"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/nvim-bufdel",
    url = "https://github.com/ojroques/nvim-bufdel"
  },
  ["nvim-cmp"] = {
    after = { "cmp-vsnip" },
    loaded = true,
    only_config = true
  },
  ["nvim-code-action-menu"] = {
    commands = { "CodeActionMenu" },
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/opt/nvim-code-action-menu",
    url = "https://github.com/weilbith/nvim-code-action-menu"
  },
  ["nvim-dap"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/nvim-dap",
    url = "https://github.com/mfussenegger/nvim-dap"
  },
  ["nvim-dap-python"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/nvim-dap-python",
    url = "https://github.com/mfussenegger/nvim-dap-python"
  },
  ["nvim-dap-ui"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/nvim-dap-ui",
    url = "https://github.com/rcarriga/nvim-dap-ui"
  },
  ["nvim-dap-virtual-text"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/nvim-dap-virtual-text",
    url = "https://github.com/theHamsta/nvim-dap-virtual-text"
  },
  ["nvim-fzf"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/nvim-fzf",
    url = "https://github.com/vijaymarupudi/nvim-fzf"
  },
  ["nvim-hlslens"] = {
    config = { "\27LJ\2\n<\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0!plugins.configs.nvim_hlslens\frequire\0" },
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/nvim-hlslens",
    url = "https://github.com/kevinhwang91/nvim-hlslens"
  },
  ["nvim-lightbulb"] = {
    config = { "\27LJ\2\n>\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0#plugins.configs.nvim-lightbulb\frequire\0" },
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/nvim-lightbulb",
    url = "https://github.com/kosayoda/nvim-lightbulb"
  },
  ["nvim-lsp-installer"] = {
    config = { "\27LJ\2\n;\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0 plugins.configs.lsp-install\frequire\0" },
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/nvim-lsp-installer",
    url = "https://github.com/williamboman/nvim-lsp-installer"
  },
  ["nvim-lsp-ts-utils"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/nvim-lsp-ts-utils",
    url = "https://github.com/jose-elias-alvarez/nvim-lsp-ts-utils"
  },
  ["nvim-lspconfig"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/nvim-lspconfig",
    url = "https://github.com/neovim/nvim-lspconfig"
  },
  ["nvim-luapad"] = {
    config = { "\27LJ\2\n;\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0 plugins.configs.nvim-luapad\frequire\0" },
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/nvim-luapad",
    url = "https://github.com/rafcamlet/nvim-luapad"
  },
  ["nvim-mapper"] = {
    config = { "\27LJ\2\n=\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\16nvim-mapper\frequire\0" },
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/nvim-mapper",
    url = "https://github.com/lazytanuki/nvim-mapper"
  },
  ["nvim-neoclip.lua"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/nvim-neoclip.lua",
    url = "https://github.com/AckslD/nvim-neoclip.lua"
  },
  ["nvim-notify"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/nvim-notify",
    url = "https://github.com/rcarriga/nvim-notify"
  },
  ["nvim-projectconfig"] = {
    config = { "\27LJ\2\n”\2\0\0\3\0\6\0\n6\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\0016\0\3\0009\0\4\0'\2\5\0B\0\2\1K\0\1\0±\1          augroup NvimProjectConfig\n          autocmd!\n          autocmd DirChanged * lua require('nvim-projectconfig').load_project_config()\n          augroup end\n        \bcmd\bvim\24load_project_config\23nvim-projectconfig\frequire\0" },
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/nvim-projectconfig",
    url = "https://github.com/windwp/nvim-projectconfig"
  },
  ["nvim-remote-containers"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/nvim-remote-containers",
    url = "https://github.com/jamestthompson3/nvim-remote-containers"
  },
  ["nvim-spotify"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/nvim-spotify",
    url = "https://github.com/KadoBOT/nvim-spotify"
  },
  ["nvim-startup.lua"] = {
    config = { "\27LJ\2\n<\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0!plugins.configs.nvim_startup\frequire\0" },
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/nvim-startup.lua",
    url = "https://github.com/henriquehbr/nvim-startup.lua"
  },
  ["nvim-tree.lua"] = {
    config = { "\27LJ\2\n9\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\30plugins.configs.nvim_tree\frequire\0" },
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/nvim-tree.lua",
    url = "https://github.com/kyazdani42/nvim-tree.lua"
  },
  ["nvim-treesitter"] = {
    config = { "\27LJ\2\n:\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\31plugins.configs.treesitter\frequire\0" },
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/nvim-treesitter",
    url = "https://github.com/nvim-treesitter/nvim-treesitter"
  },
  ["nvim-treesitter-context"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/nvim-treesitter-context",
    url = "https://github.com/romgrk/nvim-treesitter-context"
  },
  ["nvim-treesitter-pairs"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/nvim-treesitter-pairs",
    url = "https://github.com/theHamsta/nvim-treesitter-pairs"
  },
  ["nvim-treesitter-refactor"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/nvim-treesitter-refactor",
    url = "https://github.com/nvim-treesitter/nvim-treesitter-refactor"
  },
  ["nvim-treesitter-textobjects"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/nvim-treesitter-textobjects",
    url = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects"
  },
  ["nvim-treesitter-textsubjects"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/nvim-treesitter-textsubjects",
    url = "https://github.com/RRethy/nvim-treesitter-textsubjects"
  },
  ["nvim-ts-autotag"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/nvim-ts-autotag",
    url = "https://github.com/windwp/nvim-ts-autotag"
  },
  ["nvim-ts-context-commentstring"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/nvim-ts-context-commentstring",
    url = "https://github.com/JoosepAlviste/nvim-ts-context-commentstring"
  },
  ["nvim-ts-rainbow"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/nvim-ts-rainbow",
    url = "https://github.com/p00f/nvim-ts-rainbow"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/nvim-web-devicons",
    url = "https://github.com/kyazdani42/nvim-web-devicons"
  },
  ["octo.nvim"] = {
    config = { "\27LJ\2\n4\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\25plugins.configs.octo\frequire\0" },
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/octo.nvim",
    url = "https://github.com/pwntester/octo.nvim"
  },
  ["one-small-step-for-vimkind"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/one-small-step-for-vimkind",
    url = "https://github.com/jbyuki/one-small-step-for-vimkind"
  },
  ["package-info.nvim"] = {
    config = { "\27LJ\2\n<\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0!plugins.configs.package-info\frequire\0" },
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/package-info.nvim",
    url = "https://github.com/vuki656/package-info.nvim"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/packer.nvim",
    url = "https://github.com/wbthomason/packer.nvim"
  },
  ["pgsql.vim"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/pgsql.vim",
    url = "https://github.com/lifepillar/pgsql.vim"
  },
  ["php.vim"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/php.vim",
    url = "https://github.com/stanangeloff/php.vim"
  },
  playground = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/playground",
    url = "https://github.com/nvim-treesitter/playground"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/plenary.nvim",
    url = "https://github.com/nvim-lua/plenary.nvim"
  },
  ["popup.nvim"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/popup.nvim",
    url = "https://github.com/nvim-lua/popup.nvim"
  },
  ["project.nvim"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/project.nvim",
    url = "https://github.com/ahmedkhalf/project.nvim"
  },
  ["quickmath.nvim"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/quickmath.nvim",
    url = "https://github.com/jbyuki/quickmath.nvim"
  },
  ["range-highlight.nvim"] = {
    config = { "\27LJ\2\n?\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0$plugins.configs.range-highlight\frequire\0" },
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/range-highlight.nvim",
    url = "https://github.com/winston0410/range-highlight.nvim"
  },
  ["registers.nvim"] = {
    config = { "\27LJ\2\n9\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\30plugins.configs.registers\frequire\0" },
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/registers.nvim",
    url = "https://github.com/tversteeg/registers.nvim"
  },
  ["requirements.txt.vim"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/requirements.txt.vim",
    url = "https://github.com/raimon49/requirements.txt.vim"
  },
  ["rest.nvim"] = {
    config = { "\27LJ\2\n9\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\30plugins.configs.rest-nvim\frequire\0" },
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/rest.nvim",
    url = "https://github.com/NTBBloodbath/rest.nvim"
  },
  ["scss-syntax.vim"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/scss-syntax.vim",
    url = "https://github.com/cakebaker/scss-syntax.vim"
  },
  ["session-lens"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/session-lens",
    url = "https://github.com/rmagatti/session-lens"
  },
  slimux = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/slimux",
    url = "https://github.com/njhoffman/slimux"
  },
  sniprun = {
    config = { "\27LJ\2\n7\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\28plugins.configs.sniprun\frequire\0" },
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/sniprun",
    url = "https://github.com/michaelb/sniprun"
  },
  ["specs.nvim"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/specs.nvim",
    url = "https://github.com/edluffy/specs.nvim"
  },
  ["splitjoin.vim"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/splitjoin.vim",
    url = "https://github.com/andrewradev/splitjoin.vim"
  },
  ["sqlite.lua"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/sqlite.lua",
    url = "https://github.com/tami5/sqlite.lua"
  },
  ["sqls.nvim"] = {
    config = { "\27LJ\2\nH\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\1\vpicker\fdefault\nsetup\tsqls\frequire\0" },
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/sqls.nvim",
    url = "https://github.com/nanotee/sqls.nvim"
  },
  ["stabilize.nvim"] = {
    config = { "\27LJ\2\n·\1\0\0\4\0\n\0\0145\0\0\0005\1\2\0005\2\1\0=\2\3\0015\2\4\0=\2\5\1=\1\6\0006\1\a\0'\3\b\0B\1\2\0029\1\t\1\18\3\0\0B\1\2\1K\0\1\0\nsetup\14stabilize\frequire\vignore\fbuftype\1\4\0\0\rterminal\rquickfix\floclist\rfiletype\1\0\0\1\5\0\0\thelp\tlist\fTrouble\vnotify\1\0\1\nforce\2\0" },
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/stabilize.nvim",
    url = "https://github.com/luukvbaal/stabilize.nvim"
  },
  ["startuptime.vim"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/startuptime.vim",
    url = "https://github.com/tweekmonster/startuptime.vim"
  },
  ["suda.vim"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/suda.vim",
    url = "https://github.com/lambdalisue/suda.vim"
  },
  ["tabout.nvim"] = {
    config = { "\27LJ\2\n6\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\27plugins.configs.tabout\frequire\0" },
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/tabout.nvim",
    url = "https://github.com/abecodes/tabout.nvim"
  },
  tabular = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/tabular",
    url = "https://github.com/godlygeek/tabular"
  },
  tagbar = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/tagbar",
    url = "https://github.com/preservim/tagbar"
  },
  taskwiki = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/taskwiki",
    url = "https://github.com/tools-life/taskwiki"
  },
  ["telekasten.nvim"] = {
    config = { "\27LJ\2\nþ\4\0\0\a\0\23\0-6\0\0\0009\0\1\0009\0\2\0'\2\3\0B\0\2\0026\1\4\0'\3\5\0B\1\2\0029\1\6\0015\3\a\0=\0\b\3\18\4\0\0'\5\t\0'\6\n\0&\4\6\4=\4\v\3\18\4\0\0'\5\t\0'\6\f\0&\4\6\4=\4\r\3\18\4\0\0'\5\t\0'\6\14\0&\4\6\4=\4\14\3\18\4\0\0'\5\t\0'\6\15\0&\4\6\4=\4\16\3\18\4\0\0'\5\t\0'\6\17\0&\4\6\4=\4\18\3\18\4\0\0'\5\t\0'\6\19\0&\4\6\4=\4\20\0035\4\21\0=\4\22\3B\1\2\1K\0\1\0\18calendar_opts\1\0\3\vweeknm\3\4\20calendar_monday\3\1\18calendar_mark\rleft-fit\24template_new_weekly\24templates/weekly.md\23template_new_daily\23templates/daily.md\22template_new_note\26templates/new_note.md\14templates\rweeklies\vweekly\fdailies\ndaily\6/\thome\1\0\a weeklies_create_nonexisting\2\17image_subdir\bimg\23plug_into_calendar\2\21image_link_style\rmarkdown\14extension\b.md\31follow_creates_nonexisting\2\31dailies_create_nonexisting\2\nsetup\15telekasten\frequire\19~/zettelkasten\vexpand\afn\bvim\0" },
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/telekasten.nvim",
    url = "https://github.com/renerocksai/telekasten.nvim"
  },
  ["telescope-arecibo.nvim"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/telescope-arecibo.nvim",
    url = "https://github.com/nvim-telescope/telescope-arecibo.nvim"
  },
  ["telescope-asynctasks.nvim"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/telescope-asynctasks.nvim",
    url = "https://github.com/GustavoKatel/telescope-asynctasks.nvim"
  },
  ["telescope-bookmarks.nvim"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/telescope-bookmarks.nvim",
    url = "https://github.com/dhruvmanila/telescope-bookmarks.nvim"
  },
  ["telescope-dap.nvim"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/telescope-dap.nvim",
    url = "https://github.com/nvim-telescope/telescope-dap.nvim"
  },
  ["telescope-extensions"] = {
    config = { "\27LJ\2\n\v\0\0\1\0\0\0\1K\0\1\0\0" },
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/telescope-extensions",
    url = "https://github.com//home/nicholas/git/telescope-extensions"
  },
  ["telescope-file-browser.nvim"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/telescope-file-browser.nvim",
    url = "https://github.com/nvim-telescope/telescope-file-browser.nvim"
  },
  ["telescope-frecency.nvim"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/telescope-frecency.nvim",
    url = "https://github.com/nvim-telescope/telescope-frecency.nvim"
  },
  ["telescope-fzf-native.nvim"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/telescope-fzf-native.nvim",
    url = "https://github.com/nvim-telescope/telescope-fzf-native.nvim"
  },
  ["telescope-ghq.nvim"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/telescope-ghq.nvim",
    url = "https://github.com/nvim-telescope/telescope-ghq.nvim"
  },
  ["telescope-github.nvim"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/telescope-github.nvim",
    url = "https://github.com/nvim-telescope/telescope-github.nvim"
  },
  ["telescope-heading.nvim"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/telescope-heading.nvim",
    url = "https://github.com/crispgm/telescope-heading.nvim"
  },
  ["telescope-hop.nvim"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/telescope-hop.nvim",
    url = "https://github.com/nvim-telescope/telescope-hop.nvim"
  },
  ["telescope-kubectl.nvim"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/telescope-kubectl.nvim",
    url = "https://github.com/frenchtoasters/telescope-kubectl.nvim"
  },
  ["telescope-lsp-handlers.nvim"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/telescope-lsp-handlers.nvim",
    url = "https://github.com/gbrlsnchs/telescope-lsp-handlers.nvim"
  },
  ["telescope-media-files.nvim"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/telescope-media-files.nvim",
    url = "https://github.com/nvim-telescope/telescope-media-files.nvim"
  },
  ["telescope-node-modules.nvim"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/telescope-node-modules.nvim",
    url = "https://github.com/nvim-telescope/telescope-node-modules.nvim"
  },
  ["telescope-npm.nvim"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/telescope-npm.nvim",
    url = "https://github.com/elianiva/telescope-npm.nvim"
  },
  ["telescope-packer.nvim"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/telescope-packer.nvim",
    url = "https://github.com/nvim-telescope/telescope-packer.nvim"
  },
  ["telescope-repo.nvim"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/telescope-repo.nvim",
    url = "https://github.com/cljoly/telescope-repo.nvim"
  },
  ["telescope-rg.nvim"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/telescope-rg.nvim",
    url = "https://github.com/nvim-telescope/telescope-rg.nvim"
  },
  ["telescope-symbols.nvim"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/telescope-symbols.nvim",
    url = "https://github.com/nvim-telescope/telescope-symbols.nvim"
  },
  ["telescope-tmux.nvim"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/telescope-tmux.nvim",
    url = "https://github.com/camgraff/telescope-tmux.nvim"
  },
  ["telescope-ui-select.nvim"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/telescope-ui-select.nvim",
    url = "https://github.com/nvim-telescope/telescope-ui-select.nvim"
  },
  ["telescope-vimwiki.nvim"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/telescope-vimwiki.nvim",
    url = "https://github.com/ElPiloto/telescope-vimwiki.nvim"
  },
  ["telescope-z.nvim"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/telescope-z.nvim",
    url = "https://github.com/nvim-telescope/telescope-z.nvim"
  },
  ["telescope.nvim"] = {
    config = { "\27LJ\2\ng\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0016\0\0\0'\2\2\0B\0\2\1K\0\1\0&plugins.configs.telescope-pickers\30plugins.configs.telescope\frequire\0" },
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/telescope.nvim",
    url = "https://github.com/nvim-telescope/telescope.nvim"
  },
  ["tmux.vim"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/tmux.vim",
    url = "https://github.com/ericpruitt/tmux.vim"
  },
  ["todo-comments.nvim"] = {
    config = { "\27LJ\2\n=\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\"plugins.configs.todo_comments\frequire\0" },
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/todo-comments.nvim",
    url = "https://github.com/folke/todo-comments.nvim"
  },
  ["tree-sitter-ntangle"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/tree-sitter-ntangle",
    url = "https://github.com/jbyuki/tree-sitter-ntangle"
  },
  ["trouble.nvim"] = {
    config = { "\27LJ\2\n7\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\28plugins.configs.trouble\frequire\0" },
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/trouble.nvim",
    url = "https://github.com/folke/trouble.nvim"
  },
  ["twilight.nvim"] = {
    config = { "\27LJ\2\n8\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\29plugins.configs.twilight\frequire\0" },
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/twilight.nvim",
    url = "https://github.com/folke/twilight.nvim"
  },
  ["vim-HiLinkTrace"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/vim-HiLinkTrace",
    url = "https://github.com/gerw/vim-HiLinkTrace"
  },
  ["vim-alias"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/vim-alias",
    url = "https://github.com/Konfekt/vim-alias"
  },
  ["vim-apm"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/vim-apm",
    url = "https://github.com/ThePrimeagen/vim-apm"
  },
  ["vim-bbye"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/vim-bbye",
    url = "https://github.com/moll/vim-bbye"
  },
  ["vim-bling"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/vim-bling",
    url = "https://github.com/ivyl/vim-bling"
  },
  ["vim-camelsnek"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/vim-camelsnek",
    url = "https://github.com/nicwest/vim-camelsnek"
  },
  ["vim-checkbox"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/vim-checkbox",
    url = "https://github.com/jkramer/vim-checkbox"
  },
  ["vim-cool"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/vim-cool",
    url = "https://github.com/romainl/vim-cool"
  },
  ["vim-cpp-enhanced-highlight"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/vim-cpp-enhanced-highlight",
    url = "https://github.com/octol/vim-cpp-enhanced-highlight"
  },
  ["vim-dadbod"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/vim-dadbod",
    url = "https://github.com/tpope/vim-dadbod"
  },
  ["vim-dadbod-completion"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/vim-dadbod-completion",
    url = "https://github.com/kristijanhusak/vim-dadbod-completion"
  },
  ["vim-dadbod-ui"] = {
    config = { "\27LJ\2\n_\0\0\2\0\4\0\t6\0\0\0009\0\1\0)\1\1\0=\1\2\0006\0\0\0009\0\1\0)\1\1\0=\1\3\0K\0\1\0\25db_ui_use_nerd_fonts\29db_ui_show_database_icon\6g\bvim\0" },
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/vim-dadbod-ui",
    url = "https://github.com/kristijanhusak/vim-dadbod-ui"
  },
  ["vim-devicons"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/vim-devicons",
    url = "https://github.com/ryanoasis/vim-devicons"
  },
  ["vim-easy-align"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/vim-easy-align",
    url = "https://github.com/junegunn/vim-easy-align"
  },
  ["vim-eunuch"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/vim-eunuch",
    url = "https://github.com/tpope/vim-eunuch"
  },
  ["vim-floaterm"] = {
    config = { "\27LJ\2\n<\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0!plugins.configs.vim-floaterm\frequire\0" },
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/vim-floaterm",
    url = "https://github.com/voldikss/vim-floaterm"
  },
  ["vim-flog"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/vim-flog",
    url = "https://github.com/rbong/vim-flog"
  },
  ["vim-fugitive"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/vim-fugitive",
    url = "https://github.com/tpope/vim-fugitive"
  },
  ["vim-git"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/vim-git",
    url = "https://github.com/tpope/vim-git"
  },
  ["vim-gitignore"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/vim-gitignore",
    url = "https://github.com/gisphm/vim-gitignore"
  },
  ["vim-glsl"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/vim-glsl",
    url = "https://github.com/tikhomirov/vim-glsl"
  },
  ["vim-graphql"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/vim-graphql",
    url = "https://github.com/jparise/vim-graphql"
  },
  ["vim-hexokinase"] = {
    config = { "\27LJ\2\n>\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0#plugins.configs.vim_hexokinase\frequire\0" },
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/vim-hexokinase",
    url = "https://github.com/RRethy/vim-hexokinase"
  },
  ["vim-jinja2-syntax"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/vim-jinja2-syntax",
    url = "https://github.com/glench/vim-jinja2-syntax"
  },
  ["vim-jq"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/vim-jq",
    url = "https://github.com/bfrg/vim-jq"
  },
  ["vim-js"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/vim-js",
    url = "https://github.com/yuezk/vim-js"
  },
  ["vim-json"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/vim-json",
    url = "https://github.com/elzr/vim-json"
  },
  ["vim-jsx-pretty"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/vim-jsx-pretty",
    url = "https://github.com/maxmellon/vim-jsx-pretty"
  },
  ["vim-kubernetes"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/vim-kubernetes",
    url = "https://github.com/andrewstuart/vim-kubernetes"
  },
  ["vim-liquid"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/vim-liquid",
    url = "https://github.com/njhoffman/vim-liquid"
  },
  ["vim-log-highlighting"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/vim-log-highlighting",
    url = "https://github.com/mtdl9/vim-log-highlighting"
  },
  ["vim-lua"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/vim-lua",
    url = "https://github.com/tbastos/vim-lua"
  },
  ["vim-man"] = {
    config = { "\27LJ\2\n\v\0\0\1\0\0\0\1K\0\1\0\0" },
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/vim-man",
    url = "https://github.com//home/nicholas/git/vim-man"
  },
  ["vim-matchup"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/vim-matchup",
    url = "https://github.com/andymass/vim-matchup"
  },
  ["vim-mundo"] = {
    config = { "\27LJ\2\n9\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\30plugins.configs.vim_mundo\frequire\0" },
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/vim-mundo",
    url = "https://github.com/simnalamburt/vim-mundo"
  },
  ["vim-nix"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/vim-nix",
    url = "https://github.com/lnl7/vim-nix"
  },
  ["vim-node"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/vim-node",
    url = "https://github.com/moll/vim-node"
  },
  ["vim-pandoc-syntax"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/vim-pandoc-syntax",
    url = "https://github.com/vim-pandoc/vim-pandoc-syntax"
  },
  ["vim-pastebins"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/vim-pastebins",
    url = "https://github.com/sefeng211/vim-pastebins"
  },
  ["vim-plugin-AnsiEsc"] = {
    config = { "\27LJ\2\nB\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0'plugins.configs.vim_plugin_AnsiEsc\frequire\0" },
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/vim-plugin-AnsiEsc",
    url = "https://github.com/joeysino/vim-plugin-AnsiEsc"
  },
  ["vim-printer"] = {
    config = { "\27LJ\2\n¡\1\0\0\3\0\4\0\t6\0\0\0009\0\1\0'\2\2\0B\0\2\0016\0\0\0009\0\1\0'\2\3\0B\0\2\1K\0\1\0;let g:vim_printer_print_above_keybinding = '<leader>?';let g:vim_printer_print_below_keybinding = '<leader>/'\bcmd\bvim\0" },
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/vim-printer",
    url = "https://github.com/meain/vim-printer"
  },
  ["vim-profiler"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/vim-profiler",
    url = "https://github.com/bchretien/vim-profiler"
  },
  ["vim-puppet"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/vim-puppet",
    url = "https://github.com/rodjek/vim-puppet"
  },
  ["vim-qf"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/vim-qf",
    url = "https://github.com/romainl/vim-qf"
  },
  ["vim-qf-history"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/vim-qf-history",
    url = "https://github.com/bfrg/vim-qf-history"
  },
  ["vim-renamer"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/vim-renamer",
    url = "https://github.com/qpkorr/vim-renamer"
  },
  ["vim-repeat"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/vim-repeat",
    url = "https://github.com/tpope/vim-repeat"
  },
  ["vim-rhubarb"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/vim-rhubarb",
    url = "https://github.com/tpope/vim-rhubarb"
  },
  ["vim-ripple"] = {
    config = { "\27LJ\2\n:\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\31plugins.configs.vim-ripple\frequire\0" },
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/vim-ripple",
    url = "https://github.com/urbainvaes/vim-ripple"
  },
  ["vim-sayonara"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/vim-sayonara",
    url = "https://github.com/mhinz/vim-sayonara"
  },
  ["vim-scriptease"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/vim-scriptease",
    url = "https://github.com/tpope/vim-scriptease"
  },
  ["vim-searchsavvy"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/vim-searchsavvy",
    url = "https://github.com/idbrii/vim-searchsavvy"
  },
  ["vim-smoothie"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/vim-smoothie",
    url = "https://github.com/psliwka/vim-smoothie"
  },
  ["vim-sort-motion"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/vim-sort-motion",
    url = "https://github.com/christoomey/vim-sort-motion"
  },
  ["vim-symlink"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/vim-symlink",
    url = "https://github.com/aymericbeaumet/vim-symlink"
  },
  ["vim-systemd-syntax"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/vim-systemd-syntax",
    url = "https://github.com/wgwoods/vim-systemd-syntax"
  },
  ["vim-table-mode"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/vim-table-mode",
    url = "https://github.com/dhruvasagar/vim-table-mode"
  },
  ["vim-taskwarrior"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/vim-taskwarrior",
    url = "https://github.com/farseer90718/vim-taskwarrior"
  },
  ["vim-terraform"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/vim-terraform",
    url = "https://github.com/hashivim/vim-terraform"
  },
  ["vim-test"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/vim-test",
    url = "https://github.com/vim-test/vim-test"
  },
  ["vim-vsnip"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/vim-vsnip",
    url = "https://github.com/hrsh7th/vim-vsnip"
  },
  ["vim-wakatime"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/vim-wakatime",
    url = "https://github.com/wakatime/vim-wakatime"
  },
  ["vim-wordmotion"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/vim-wordmotion",
    url = "https://github.com/chaoren/vim-wordmotion"
  },
  ["vim-yoink"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/vim-yoink",
    url = "https://github.com/svermeulen/vim-yoink"
  },
  vimade = {
    config = { "\27LJ\2\n6\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\27plugins.configs.vimade\frequire\0" },
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/vimade",
    url = "https://github.com/TaDaa/vimade"
  },
  vimux = {
    config = { "\27LJ\2\n5\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\26plugins.configs.vimux\frequire\0" },
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/vimux",
    url = "https://github.com/preservim/vimux"
  },
  vimwiki = {
    config = { "\27LJ\2\nx\0\0\3\0\5\0\t6\0\0\0009\0\1\0)\1\0\0=\1\2\0006\0\0\0009\0\3\0'\2\4\0B\0\2\1K\0\1\0004let g:vimwiki_key_mappings = { 'all_maps': 0, }\bcmd\23vimwiki_global_ext\6g\bvim\0" },
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/vimwiki",
    url = "https://github.com/vimwiki/vimwiki"
  },
  ["vs-snippets"] = {
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/opt/vs-snippets",
    url = "https://github.com/kitagry/vs-snippets"
  },
  ["which-key.nvim"] = {
    config = { "\27LJ\2\n9\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\30plugins.configs.which_key\frequire\0" },
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/which-key.nvim",
    url = "https://github.com/folke/which-key.nvim"
  },
  ["wilder.nvim"] = {
    config = { "\27LJ\2\n6\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\27plugins.configs.wilder\frequire\0" },
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/wilder.nvim",
    url = "https://github.com/gelguy/wilder.nvim"
  },
  ["yank-history"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/yank-history",
    url = "https://github.com/yazgoo/yank-history"
  },
  ["yats.vim"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/yats.vim",
    url = "https://github.com/herringtondarkholme/yats.vim"
  },
  ["zinit-vim-syntax"] = {
    loaded = true,
    path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/zinit-vim-syntax",
    url = "https://github.com/zdharma-continuum/zinit-vim-syntax"
  }
}

time([[Defining packer_plugins]], false)
-- Config for: cheat.sh-vim
time([[Config for cheat.sh-vim]], true)
try_loadstring("\27LJ\2\n<\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0!plugins.configs.cheat_sh-vim\frequire\0", "config", "cheat.sh-vim")
time([[Config for cheat.sh-vim]], false)
-- Config for: vim-ripple
time([[Config for vim-ripple]], true)
try_loadstring("\27LJ\2\n:\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\31plugins.configs.vim-ripple\frequire\0", "config", "vim-ripple")
time([[Config for vim-ripple]], false)
-- Config for: todo-comments.nvim
time([[Config for todo-comments.nvim]], true)
try_loadstring("\27LJ\2\n=\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\"plugins.configs.todo_comments\frequire\0", "config", "todo-comments.nvim")
time([[Config for todo-comments.nvim]], false)
-- Config for: telescope-extensions
time([[Config for telescope-extensions]], true)
try_loadstring("\27LJ\2\n\v\0\0\1\0\0\0\1K\0\1\0\0", "config", "telescope-extensions")
time([[Config for telescope-extensions]], false)
-- Config for: nvim-tree.lua
time([[Config for nvim-tree.lua]], true)
try_loadstring("\27LJ\2\n9\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\30plugins.configs.nvim_tree\frequire\0", "config", "nvim-tree.lua")
time([[Config for nvim-tree.lua]], false)
-- Config for: rest.nvim
time([[Config for rest.nvim]], true)
try_loadstring("\27LJ\2\n9\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\30plugins.configs.rest-nvim\frequire\0", "config", "rest.nvim")
time([[Config for rest.nvim]], false)
-- Config for: vim-floaterm
time([[Config for vim-floaterm]], true)
try_loadstring("\27LJ\2\n<\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0!plugins.configs.vim-floaterm\frequire\0", "config", "vim-floaterm")
time([[Config for vim-floaterm]], false)
-- Config for: which-key.nvim
time([[Config for which-key.nvim]], true)
try_loadstring("\27LJ\2\n9\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\30plugins.configs.which_key\frequire\0", "config", "which-key.nvim")
time([[Config for which-key.nvim]], false)
-- Config for: registers.nvim
time([[Config for registers.nvim]], true)
try_loadstring("\27LJ\2\n9\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\30plugins.configs.registers\frequire\0", "config", "registers.nvim")
time([[Config for registers.nvim]], false)
-- Config for: sniprun
time([[Config for sniprun]], true)
try_loadstring("\27LJ\2\n7\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\28plugins.configs.sniprun\frequire\0", "config", "sniprun")
time([[Config for sniprun]], false)
-- Config for: barbar.nvim
time([[Config for barbar.nvim]], true)
try_loadstring("\27LJ\2\n6\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\27plugins.configs.barbar\frequire\0", "config", "barbar.nvim")
time([[Config for barbar.nvim]], false)
-- Config for: asynctasks.vim
time([[Config for asynctasks.vim]], true)
try_loadstring("\27LJ\2\n:\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\31plugins.configs.asynctasks\frequire\0", "config", "asynctasks.vim")
time([[Config for asynctasks.vim]], false)
-- Config for: nnn.nvim
time([[Config for nnn.nvim]], true)
try_loadstring("\27LJ\2\nÞ\5\0\0\5\1 \00086\0\0\0'\2\1\0B\0\2\0029\0\2\0004\1\b\0005\2\3\0009\3\4\0>\3\2\2>\2\1\0015\2\5\0009\3\6\0>\3\2\2>\2\2\0015\2\a\0009\3\b\0>\3\2\2>\2\3\0015\2\t\0009\3\n\0>\3\2\2>\2\4\0015\2\v\0009\3\f\0>\3\2\2>\2\5\0015\2\r\0009\3\14\0>\3\2\2>\2\6\0015\2\15\0009\3\16\0>\3\2\2>\2\a\0017\1\17\0005\1\19\0005\2\18\0=\2\20\0015\2\21\0005\3\22\0=\3\23\2=\2\24\0015\2\25\0005\3\26\0=\3\27\2=\2\28\0014\2\0\0=\2\17\0015\2\29\0=\2\30\0016\2\0\0'\4\1\0B\2\2\0029\2\31\2-\4\0\0B\2\2\1K\0\1\0\1\0\nsetup\14windownav\1\0\2\nright\v<C-w>l\tleft\v<C-w>h\14auto_open\14ft_ignore\1\2\0\0\14gitcommit\1\0\1\nempty\1\vpicker\nstyle\1\0\5\vborder\frounded\fyoffset\4\0€€€ÿ\3\vheight\4š³æÌ\t™³¦ÿ\3\nwidth\4Í™³æ\fÌ™³ÿ\3\fxoffset\4\0€€€ÿ\3\1\0\2\fsession\5\bcmd\29tmux new-session nnn -Pp\rexplorer\1\0\1\15auto_close\1\1\0\5\bcmd\vnnn -G\fsession\5\ttabs\2\nwidth\3\24\tside\ftopleft\rmappings\21populate_cmdline\1\2\0\0\n<C-e>\15cd_to_path\1\2\0\0\n<C-w>\22copy_to_clipboard\1\2\0\0\n<C-y>\20open_in_preview\1\2\0\0\n<C-p>\19open_in_vsplit\1\2\0\0\n<C-v>\18open_in_split\1\2\0\0\n<C-s>\16open_in_tab\1\2\0\0\n<C-t>\fbuiltin\bnnn\frequire\0", "config", "nnn.nvim")
time([[Config for nnn.nvim]], false)
-- Config for: diffview.nvim
time([[Config for diffview.nvim]], true)
try_loadstring("\27LJ\2\n8\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\29plugins.configs.diffview\frequire\0", "config", "diffview.nvim")
time([[Config for diffview.nvim]], false)
-- Config for: vim-printer
time([[Config for vim-printer]], true)
try_loadstring("\27LJ\2\n¡\1\0\0\3\0\4\0\t6\0\0\0009\0\1\0'\2\2\0B\0\2\0016\0\0\0009\0\1\0'\2\3\0B\0\2\1K\0\1\0;let g:vim_printer_print_above_keybinding = '<leader>?';let g:vim_printer_print_below_keybinding = '<leader>/'\bcmd\bvim\0", "config", "vim-printer")
time([[Config for vim-printer]], false)
-- Config for: vimux
time([[Config for vimux]], true)
try_loadstring("\27LJ\2\n5\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\26plugins.configs.vimux\frequire\0", "config", "vimux")
time([[Config for vimux]], false)
-- Config for: twilight.nvim
time([[Config for twilight.nvim]], true)
try_loadstring("\27LJ\2\n8\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\29plugins.configs.twilight\frequire\0", "config", "twilight.nvim")
time([[Config for twilight.nvim]], false)
-- Config for: neuron.nvim
time([[Config for neuron.nvim]], true)
try_loadstring("\27LJ\2\n6\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\27plugins.configs.neuron\frequire\0", "config", "neuron.nvim")
time([[Config for neuron.nvim]], false)
-- Config for: auto-session
time([[Config for auto-session]], true)
try_loadstring("\27LJ\2\n<\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0!plugins.configs.auto-session\frequire\0", "config", "auto-session")
time([[Config for auto-session]], false)
-- Config for: alpha-nvim
time([[Config for alpha-nvim]], true)
try_loadstring("\27LJ\2\n:\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\31plugins.configs.alpha-nvim\frequire\0", "config", "alpha-nvim")
time([[Config for alpha-nvim]], false)
-- Config for: range-highlight.nvim
time([[Config for range-highlight.nvim]], true)
try_loadstring("\27LJ\2\n?\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0$plugins.configs.range-highlight\frequire\0", "config", "range-highlight.nvim")
time([[Config for range-highlight.nvim]], false)
-- Config for: vim-dadbod-ui
time([[Config for vim-dadbod-ui]], true)
try_loadstring("\27LJ\2\n_\0\0\2\0\4\0\t6\0\0\0009\0\1\0)\1\1\0=\1\2\0006\0\0\0009\0\1\0)\1\1\0=\1\3\0K\0\1\0\25db_ui_use_nerd_fonts\29db_ui_show_database_icon\6g\bvim\0", "config", "vim-dadbod-ui")
time([[Config for vim-dadbod-ui]], false)
-- Config for: nvim-luapad
time([[Config for nvim-luapad]], true)
try_loadstring("\27LJ\2\n;\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0 plugins.configs.nvim-luapad\frequire\0", "config", "nvim-luapad")
time([[Config for nvim-luapad]], false)
-- Config for: vim-plugin-AnsiEsc
time([[Config for vim-plugin-AnsiEsc]], true)
try_loadstring("\27LJ\2\nB\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0'plugins.configs.vim_plugin_AnsiEsc\frequire\0", "config", "vim-plugin-AnsiEsc")
time([[Config for vim-plugin-AnsiEsc]], false)
-- Config for: TrueZen.nvim
time([[Config for TrueZen.nvim]], true)
try_loadstring("\27LJ\2\n7\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\28plugins.configs.truezen\frequire\0", "config", "TrueZen.nvim")
time([[Config for TrueZen.nvim]], false)
-- Config for: tabout.nvim
time([[Config for tabout.nvim]], true)
try_loadstring("\27LJ\2\n6\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\27plugins.configs.tabout\frequire\0", "config", "tabout.nvim")
time([[Config for tabout.nvim]], false)
-- Config for: feline.nvim
time([[Config for feline.nvim]], true)
try_loadstring("\27LJ\2\n›\3\0\0\3\0\f\0$6\0\0\0009\0\1\0'\2\2\0B\0\2\0016\0\3\0'\2\4\0B\0\2\0016\0\0\0009\0\1\0'\2\5\0B\0\2\0016\0\0\0009\0\1\0'\2\6\0B\0\2\0016\0\0\0009\0\1\0'\2\a\0B\0\2\0016\0\0\0009\0\1\0'\2\b\0B\0\2\0016\0\0\0009\0\1\0'\2\t\0B\0\2\0016\0\0\0009\0\1\0'\2\n\0B\0\2\0016\0\0\0009\0\1\0'\2\v\0B\0\2\1K\0\1\0#hi link diffIndexFile DiffText\30hi link diffFile DiffText hi link diffNewFile DiffAdd\30hi link diffLine DiffText#hi link diffChanged DiffChange#hi link diffRemoved DiffDelete\30hi link diffAdded DiffAdd\27plugins.configs.feline\frequire\26colorscheme nord-nick\bcmd\bvim\0", "config", "feline.nvim")
time([[Config for feline.nvim]], false)
-- Config for: markdown-preview.nvim
time([[Config for markdown-preview.nvim]], true)
try_loadstring("\27LJ\2\n@\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0%plugins.configs.markdown-preview\frequire\0", "config", "markdown-preview.nvim")
time([[Config for markdown-preview.nvim]], false)
-- Config for: vim-mundo
time([[Config for vim-mundo]], true)
try_loadstring("\27LJ\2\n9\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\30plugins.configs.vim_mundo\frequire\0", "config", "vim-mundo")
time([[Config for vim-mundo]], false)
-- Config for: float-preview.nvim
time([[Config for float-preview.nvim]], true)
try_loadstring("\27LJ\2\n=\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\"plugins.configs.float-preview\frequire\0", "config", "float-preview.nvim")
time([[Config for float-preview.nvim]], false)
-- Config for: lua-dev.nvim
time([[Config for lua-dev.nvim]], true)
try_loadstring("\27LJ\2\n7\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\28plugins.configs.lua-dev\frequire\0", "config", "lua-dev.nvim")
time([[Config for lua-dev.nvim]], false)
-- Config for: nvim-lsp-installer
time([[Config for nvim-lsp-installer]], true)
try_loadstring("\27LJ\2\n;\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0 plugins.configs.lsp-install\frequire\0", "config", "nvim-lsp-installer")
time([[Config for nvim-lsp-installer]], false)
-- Config for: JABS.nvim
time([[Config for JABS.nvim]], true)
try_loadstring("\27LJ\2\n4\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\25plugins.configs.jabs\frequire\0", "config", "JABS.nvim")
time([[Config for JABS.nvim]], false)
-- Config for: nvim-treesitter
time([[Config for nvim-treesitter]], true)
try_loadstring("\27LJ\2\n:\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\31plugins.configs.treesitter\frequire\0", "config", "nvim-treesitter")
time([[Config for nvim-treesitter]], false)
-- Config for: stabilize.nvim
time([[Config for stabilize.nvim]], true)
try_loadstring("\27LJ\2\n·\1\0\0\4\0\n\0\0145\0\0\0005\1\2\0005\2\1\0=\2\3\0015\2\4\0=\2\5\1=\1\6\0006\1\a\0'\3\b\0B\1\2\0029\1\t\1\18\3\0\0B\1\2\1K\0\1\0\nsetup\14stabilize\frequire\vignore\fbuftype\1\4\0\0\rterminal\rquickfix\floclist\rfiletype\1\0\0\1\5\0\0\thelp\tlist\fTrouble\vnotify\1\0\1\nforce\2\0", "config", "stabilize.nvim")
time([[Config for stabilize.nvim]], false)
-- Config for: package-info.nvim
time([[Config for package-info.nvim]], true)
try_loadstring("\27LJ\2\n<\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0!plugins.configs.package-info\frequire\0", "config", "package-info.nvim")
time([[Config for package-info.nvim]], false)
-- Config for: lsp_signature.nvim
time([[Config for lsp_signature.nvim]], true)
try_loadstring("\27LJ\2\n=\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\"plugins.configs.lsp_signature\frequire\0", "config", "lsp_signature.nvim")
time([[Config for lsp_signature.nvim]], false)
-- Config for: sqls.nvim
time([[Config for sqls.nvim]], true)
try_loadstring("\27LJ\2\nH\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\1\vpicker\fdefault\nsetup\tsqls\frequire\0", "config", "sqls.nvim")
time([[Config for sqls.nvim]], false)
-- Config for: telekasten.nvim
time([[Config for telekasten.nvim]], true)
try_loadstring("\27LJ\2\nþ\4\0\0\a\0\23\0-6\0\0\0009\0\1\0009\0\2\0'\2\3\0B\0\2\0026\1\4\0'\3\5\0B\1\2\0029\1\6\0015\3\a\0=\0\b\3\18\4\0\0'\5\t\0'\6\n\0&\4\6\4=\4\v\3\18\4\0\0'\5\t\0'\6\f\0&\4\6\4=\4\r\3\18\4\0\0'\5\t\0'\6\14\0&\4\6\4=\4\14\3\18\4\0\0'\5\t\0'\6\15\0&\4\6\4=\4\16\3\18\4\0\0'\5\t\0'\6\17\0&\4\6\4=\4\18\3\18\4\0\0'\5\t\0'\6\19\0&\4\6\4=\4\20\0035\4\21\0=\4\22\3B\1\2\1K\0\1\0\18calendar_opts\1\0\3\vweeknm\3\4\20calendar_monday\3\1\18calendar_mark\rleft-fit\24template_new_weekly\24templates/weekly.md\23template_new_daily\23templates/daily.md\22template_new_note\26templates/new_note.md\14templates\rweeklies\vweekly\fdailies\ndaily\6/\thome\1\0\a weeklies_create_nonexisting\2\17image_subdir\bimg\23plug_into_calendar\2\21image_link_style\rmarkdown\14extension\b.md\31follow_creates_nonexisting\2\31dailies_create_nonexisting\2\nsetup\15telekasten\frequire\19~/zettelkasten\vexpand\afn\bvim\0", "config", "telekasten.nvim")
time([[Config for telekasten.nvim]], false)
-- Config for: nvim-cmp
time([[Config for nvim-cmp]], true)
try_loadstring("\27LJ\2\n8\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\29plugins.configs.nvim-cmp\frequire\0", "config", "nvim-cmp")
time([[Config for nvim-cmp]], false)
-- Config for: octo.nvim
time([[Config for octo.nvim]], true)
try_loadstring("\27LJ\2\n4\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\25plugins.configs.octo\frequire\0", "config", "octo.nvim")
time([[Config for octo.nvim]], false)
-- Config for: lsp-colors.nvim
time([[Config for lsp-colors.nvim]], true)
try_loadstring("\27LJ\2\n:\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\31plugins.configs.lsp-colors\frequire\0", "config", "lsp-colors.nvim")
time([[Config for lsp-colors.nvim]], false)
-- Config for: nvim-lightbulb
time([[Config for nvim-lightbulb]], true)
try_loadstring("\27LJ\2\n>\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0#plugins.configs.nvim-lightbulb\frequire\0", "config", "nvim-lightbulb")
time([[Config for nvim-lightbulb]], false)
-- Config for: vim-man
time([[Config for vim-man]], true)
try_loadstring("\27LJ\2\n\v\0\0\1\0\0\0\1K\0\1\0\0", "config", "vim-man")
time([[Config for vim-man]], false)
-- Config for: wilder.nvim
time([[Config for wilder.nvim]], true)
try_loadstring("\27LJ\2\n6\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\27plugins.configs.wilder\frequire\0", "config", "wilder.nvim")
time([[Config for wilder.nvim]], false)
-- Config for: nvim-mapper
time([[Config for nvim-mapper]], true)
try_loadstring("\27LJ\2\n=\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\16nvim-mapper\frequire\0", "config", "nvim-mapper")
time([[Config for nvim-mapper]], false)
-- Config for: nvim-hlslens
time([[Config for nvim-hlslens]], true)
try_loadstring("\27LJ\2\n<\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0!plugins.configs.nvim_hlslens\frequire\0", "config", "nvim-hlslens")
time([[Config for nvim-hlslens]], false)
-- Config for: vimade
time([[Config for vimade]], true)
try_loadstring("\27LJ\2\n6\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\27plugins.configs.vimade\frequire\0", "config", "vimade")
time([[Config for vimade]], false)
-- Config for: hop.nvim
time([[Config for hop.nvim]], true)
try_loadstring("\27LJ\2\nU\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\1\tkeys\28etovxqpdygfblzhckisuran\nsetup\bhop\frequire\0", "config", "hop.nvim")
time([[Config for hop.nvim]], false)
-- Config for: nvim-projectconfig
time([[Config for nvim-projectconfig]], true)
try_loadstring("\27LJ\2\n”\2\0\0\3\0\6\0\n6\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\0016\0\3\0009\0\4\0'\2\5\0B\0\2\1K\0\1\0±\1          augroup NvimProjectConfig\n          autocmd!\n          autocmd DirChanged * lua require('nvim-projectconfig').load_project_config()\n          augroup end\n        \bcmd\bvim\24load_project_config\23nvim-projectconfig\frequire\0", "config", "nvim-projectconfig")
time([[Config for nvim-projectconfig]], false)
-- Config for: telescope.nvim
time([[Config for telescope.nvim]], true)
try_loadstring("\27LJ\2\ng\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0016\0\0\0'\2\2\0B\0\2\1K\0\1\0&plugins.configs.telescope-pickers\30plugins.configs.telescope\frequire\0", "config", "telescope.nvim")
time([[Config for telescope.nvim]], false)
-- Config for: lspsaga.nvim
time([[Config for lspsaga.nvim]], true)
try_loadstring("\27LJ\2\n7\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\28plugins.configs.lspsaga\frequire\0", "config", "lspsaga.nvim")
time([[Config for lspsaga.nvim]], false)
-- Config for: vimwiki
time([[Config for vimwiki]], true)
try_loadstring("\27LJ\2\nx\0\0\3\0\5\0\t6\0\0\0009\0\1\0)\1\0\0=\1\2\0006\0\0\0009\0\3\0'\2\4\0B\0\2\1K\0\1\0004let g:vimwiki_key_mappings = { 'all_maps': 0, }\bcmd\23vimwiki_global_ext\6g\bvim\0", "config", "vimwiki")
time([[Config for vimwiki]], false)
-- Config for: nvim-startup.lua
time([[Config for nvim-startup.lua]], true)
try_loadstring("\27LJ\2\n<\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0!plugins.configs.nvim_startup\frequire\0", "config", "nvim-startup.lua")
time([[Config for nvim-startup.lua]], false)
-- Config for: vim-hexokinase
time([[Config for vim-hexokinase]], true)
try_loadstring("\27LJ\2\n>\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0#plugins.configs.vim_hexokinase\frequire\0", "config", "vim-hexokinase")
time([[Config for vim-hexokinase]], false)
-- Config for: trouble.nvim
time([[Config for trouble.nvim]], true)
try_loadstring("\27LJ\2\n7\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\28plugins.configs.trouble\frequire\0", "config", "trouble.nvim")
time([[Config for trouble.nvim]], false)
-- Load plugins in order defined by `after`
time([[Sequenced loading]], true)
vim.cmd [[ packadd cmp-vsnip ]]
vim.cmd [[ packadd friendly-snippets ]]
vim.cmd [[ packadd vs-snippets ]]
time([[Sequenced loading]], false)

-- Command lazy-loads
time([[Defining lazy-load commands]], true)
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file CodeActionMenu lua require("packer.load")({'nvim-code-action-menu'}, { cmd = "CodeActionMenu", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
time([[Defining lazy-load commands]], false)

vim.cmd [[augroup packer_load_aucmds]]
vim.cmd [[au!]]
  -- Event lazy-loads
time([[Defining lazy-load event autocommands]], true)
vim.cmd [[au VimEnter * ++once lua require("packer.load")({'gitsigns.nvim'}, { event = "VimEnter *" }, _G.packer_plugins)]]
time([[Defining lazy-load event autocommands]], false)
vim.cmd("augroup END")
if should_profile then save_profiles(1) end

end)

if not no_errors then
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
