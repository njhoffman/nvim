local path = "fzf"
local results = require("man").read_page(path)
vim.dbg(results)

-- local page = get_page(path)

-- -- Called when a man:// buffer is opened.
-- function M.read_page(ref)
--   local sect, name = extract_sect_and_name_ref(ref)
--   local path = verify_exists(sect, name)
--   sect = extract_sect_and_name_path(path)
--   local page = get_page(path)
--   vim.b.man_sect = sect
--   put_page(page)
-- end
--

-- local filename = "/home/nicholas/.local/state/nvim/lazy/readme/doc/which-key.nvim.md"
-- local cmd = "/## 🔥 Plugins"
-- -- local cmd = "/### Presets"
-- -- local cmd = "/### \\[vim-plug\\](https:\\/\\/github.com\\/junegunn\\/vim-plug)"
-- -- local cmd = "/*os.tmpname()*"
-- -- local cmd = "/*os.rename()*"
--
-- cmd = string.gsub(cmd, "^/", "")
-- cmd = string.gsub(cmd, "[%-]", "%%-")
-- cmd = string.gsub(cmd, "[%(]", "%%(")
-- cmd = string.gsub(cmd, "[%)]", "%%)")
-- cmd = string.gsub(cmd, "[%*]", "%%*")
--
-- local lines = {}
-- local inside_match = false
-- local file = io.open(filename)
-- for line in file:lines() do
--   if inside_match then
--     inside_match = true
--   else
--     inside_match = string.match(line, cmd)
--   end
--
--   if inside_match then
--     table.insert(lines, line)
--   end
-- end
--
-- vim.dbglog(lines)
