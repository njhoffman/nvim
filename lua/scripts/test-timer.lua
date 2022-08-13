local devicons = require('devicons')

local files = {
  "apm.csv",
  "apps.env",
  "cpbooster-config.json",
  "filebot.psm",
  "monero-wallet-cli.log",
  "nohup.out",
  "snippets.json",
  "test.lua",
  "unicode_table.txt",
}
-- for _, file in ipairs(files) do
--   devicons.get_icon(file)
-- end
-- vim.dbgtime('test')
-- vim.fn.timer_start(3000, function()
--   vim.dbgtime('test')
-- end)
--
local stdin = io.stdin:lines()
local stdout = io.write
for line in stdin do
  stdout(line)
end
