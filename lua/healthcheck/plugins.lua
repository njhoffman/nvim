
local function length(T)
	local count = 0
	for _ in pairs(T) do count = count + 1 end
	return count
end

function M.stats()
	-- local whichkeys = Mapper.whichkey_dump()
	-- local conflicts = Mapper.whichkey_conflicts()
	-- local duplicates = Mapper.whichkey_duplicates()

  local plugin_stats = require('plugins.pluginmap').stats

	local stats = {
		plugins = {
			total = length(_G.packer_plugins)
		}
	}
	print("                     total")
	print("---------------------------------------------------------------------")
	print(("plugins             %4d"):format(stats.plugins.total))

  -- ["auto-session"] = {
  --   config = { "\27LJ\2\n<\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0!plugins.configs.auto-session\frequire\0" },
  --   loaded = true,
  --   path = "/home/nicholas/.local/share/nvim/site/pack/packer/start/auto-session",
  --   url = "https://github.com/rmagatti/auto-session"
  -- },

end

return M
