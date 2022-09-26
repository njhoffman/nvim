local generate = require("telescope._extensions.devhints.generate")


local output_all_titles = function()
  local titles = generate.get_categories()
  for _, title in ipairs(titles.parsed) do
    vim.dbglog(title)
  end
  -- for _, title in ipairs(titles.unparsed) do
  --   vim.dbglog(title)
  -- end
end
-- output_all_titles
generate.get_topics("bash")
