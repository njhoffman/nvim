local configs = {}

local version = 1

configs.js = string.format([[
{
	"version": %d,
	"preprocessors": ["lab.esbuild"],
	"runner": "lab.node"
}
]], version)

configs.py = string.format([[
{
	"version": %d,
	"preprocessors": [],
	"runner": "lab.python"
}
]], version)

configs.lua = string.format([[
{
	"version": %d,
	"preprocessors": [],
	"runner": "lab.lua"
}
]], version)


return configs
