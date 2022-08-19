local keymap = {}

local mapfiles = {
  "debug",
  "format",
  "git",
  "interface",
  "lsp",
  "markdown",
  "movement",
  "navigation",
  "pickers",
  "search",
  "surround",
  "system",
  "unimpaired",
  "window",
  "zettel"
}

for _, map_name in ipairs(mapfiles) do
  local fname = "mappings.definitions." .. map_name
  local keymap_mod = require(fname)
  map_name = map_name:gsub("^%l", string.upper)
  if map_name == "Lsp" then
    map_name = "LSP"
  end
  keymap[map_name] = keymap_mod
end

return keymap
