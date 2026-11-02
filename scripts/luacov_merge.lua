-- Merge luacov stats files (one per spec file when tests run in parallel) into one.
-- Usage: nvim --headless --clean -l scripts/luacov_merge.lua <out> <in>...
-- Stats already in <out> are kept and added to, as luacov itself does when it saves.
-- Loaded with dofile() (no arguments) it returns the module, for tests.
local M = {}

--- Add up hit counts per file and line.
--- @param datasets table[] luacov stats tables: [filename] = { max, max_hits, [line] = hits }
--- @return table merged
function M.merge(datasets)
  local merged = {}
  for _, data in ipairs(datasets) do
    for filename, filedata in pairs(data) do
      local out = merged[filename]
      if not out then
        out = { max = 0, max_hits = 0 }
        merged[filename] = out
      end
      out.max = math.max(out.max, filedata.max or 0)
      for line = 1, filedata.max or 0 do
        local hits = filedata[line]
        if hits then
          out[line] = (out[line] or 0) + hits
          out.max_hits = math.max(out.max_hits, out[line])
        end
      end
    end
  end
  return merged
end

-- nvim -l puts the script in arg[0] and its arguments in arg[1..]; dofile() leaves arg alone
local args = _G.arg
if not (args and args[0] and args[0]:match("luacov_merge%.lua$") and #args >= 2) then
  return M
end

package.path = package.path .. ";/usr/local/share/lua/5.1/?.lua;/usr/local/share/lua/5.1/?/init.lua"
local stats = require("luacov.stats")
local datasets = { stats.load(args[1]) or {} }
for i = 2, #args do
  datasets[#datasets + 1] = stats.load(args[i]) or {}
end
stats.save(args[1], M.merge(datasets))
