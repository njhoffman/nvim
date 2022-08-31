local output = require('devhints.output')

local filetypes = {
  bash = "bash.md",
  go = "go.md",
  js = { "nodejs.md", "nodejs-fs.md" },
  lua = "lua.md",
  sh = "bash.md",
}

local output_all_titles = function()
  local titles = output.all_titles()
  for _, title in ipairs(titles.parsed) do
    vim.dbglog(title)
  end
  -- for _, title in ipairs(titles.unparsed) do
  --   vim.dbglog(title)
  -- end
end
-- output_all_titles()

output.outline("bash.md")
