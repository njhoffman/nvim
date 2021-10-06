--[[
     /  /\         /__/\         /  /\         /  /\          ___        ___          /__/\
    /  /:/         \  \:\       /  /:/_       /  /::\        /__/\      /  /\        |  |::\
   /  /:/           \__\:\     /  /:/ /\     /  /:/\:\       \  \:\    /  /:/        |  |:|:\
  /  /:/  ___   ___ /  /::\   /  /:/ /:/_   /  /:/  \:\       \  \:\  /__/::\      __|__|:|\:\
 /__/:/  /  /\ /__/\  /:/\:\ /__/:/ /:/ /\ /__/:/ \__\:\  ___  \__\:\ \__\/\:\__  /__/::::| \:\
 \  \:\ /  /:/ \  \:\/:/__\/ \  \:\/:/ /:/ \  \:\ /  /:/ /__/\ |  |:|    \  \:\/\ \  \:\~~\__\/
  \  \:\  /:/   \  \::/       \  \::/ /:/   \  \:\  /:/  \  \:\|  |:|     \__\::/  \  \:\
   \  \:\/:/     \  \:\        \  \:\/:/     \  \:\/:/    \  \:\__|:|     /__/:/    \  \:\
    \  \::/       \  \:\        \  \::/       \  \::/      \__\::::/      \__\/      \  \:\
     \__\/         \__\/         \__\/         \__\/           ~~~~                   \__\/

--]] local profiles = {
  nick = {
    "$HOME/.config/nvim-profiles/nick",
    { url = false, plugins = "packer", preconfigure = "packer:start" },
    -- { preconfigure = "packer:start", config = "PackerSync" },
  },
  development = { "$HOME/.config/nvim-profiles/development", { url = false, config = "PackerSync" } },
  doom_nvim = {
    "$HOME/.config/nvim-profiles/doom-nvim",
    -- "https://github.com/NTBBloodbath/doom-nvim",
    { url = false, plugins = "packer", preconfigure = "doom-nvim" },
  },
  starvim = { "$HOME/.config/nvim-profiles/StarVim", { url = false, preconfigure = "starvim" } },
  lunarvim = { "$HOME/.config/nvim-profiles/LunarVim", { url = false, preconfigure = "lunarvim" } },

  nv_ide = { "$HOME/.config/nvim-profiles/nv-ide", { url = false, preconfigure = "nv-ide" } },
  vapournvim = { "$HOME/.config/nvim-profiles/VapourNvim", { url = false, preconfigure = "vapournvim" } },
  --
  -- preconfigure = "{packer|paq-nvim}:{start|opt}:<branch> | doom-nvim | lunarvim | nv-ide | vapournvim | lvim",
}
--
return "nick", profiles
--
--[[
  <name_of_config> = { <path_to_config>, {
    plugins = "packer", -- Where to install plugins under site/pack
      preconfigure = "packer:opt" -- Whether or not to preconfigure a plugin manager for you
  }
}
--]]
-- You can tweak this file as you see fit, although we recommend reading the next section to actually know what you're doing.
-- wrench Configuration
-- Cheovim has a fair amount of configuration that may not become apparent right off the bat. Here's the things that you can change:

-- local profiles = {
-- 	my_config = { "/my/path", {
-- 			url = false,
-- 			setup = function()
-- 				os.remove("some_important_file")
-- 			end,
-- 			config = "PackerSync",
-- 			preconfigure = "{packer|paq-nvim}:{start|opt}:<branch> |
-- 				doom-nvim | lunarvim | nv-ide | vapournvim | lvim",
-- 		}
-- 	}
-- }
