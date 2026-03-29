local M = {
  url = "https://www.unicode.org/Public/UNIDATA/UnicodeData.txt",
  data_dir = vim.fn.stdpath("data") .. "/site/unicode",
  cache_dir = vim.fn.stdpath("cache") .. "/unicode",
  use_cache = true,
  fuzzy_color = 4,
  complete_name = false,
  show_preview_window = false,
  convert_digraph_subset = nil,
  extra_info = { [0xfeff] = "(Byte Order Mark: BOM)" },
}

function M.setup(opts)
  M = vim.tbl_deep_extend("force", M, opts or {})
end

function M.data_file()
  return M.data_dir .. "/UnicodeData.txt"
end

function M.data_cache_file()
  return M.cache_dir .. "/UnicodeData.lua"
end

function M.table_cache_file()
  return M.cache_dir .. "/UnicodeTable.txt"
end

function M.old_vim_cache_file()
  return M.cache_dir .. "/UnicodeData.vim"
end

return M
