local utils = {}
function utils.display_termcodes(str)
  return str:gsub(string.char(9), "<TAB>"):gsub("", "<C-F>"):gsub(" ", "<Space>")
end

function utils.__warn_no_selection(name)
  vim.notify(name, {
    msg = "Nothing currently selected",
    level = "WARN",
  })
end

return utils
