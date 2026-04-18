local previewers = require("telescope.previewers")

local function get_anon_function_name(func_ref)
  local Path = require("plenary.path")
  local info = debug.getinfo(func_ref)
  local fname
  -- if fn defined in string (ie loadstring) source is string
  -- if fn defined in file, source is file name prefixed with a `@´
  local path = Path:new((info.source:gsub("@", "")))
  if not path:exists() then
    return "<anonymous>"
  end
  for i, line in ipairs(path:readlines()) do
    if i == info.linedefined then
      fname = line
      break
    end
  end

  -- test if assignment or named function, otherwise anon
  if (fname:match("=") == nil) and (fname:match("function %S+%(") == nil) then
    return "<anonymous>"
  else
    local patterns = {
      { "function", "" }, -- remove function
      { "local", "" }, -- remove local
      { "[%s=]", "" }, -- remove whitespace and =
      { [=[%[["']]=], "" }, -- remove left-hand bracket of table assignment
      { [=[["']%]]=], "" }, -- remove right-ahnd bracket of table assignment
      { "%((.+)%)", "" }, -- remove function arguments
      { "(.+)%.", "" }, -- remove TABLE. prefix if available
    }
    for _, tbl in ipairs(patterns) do
      fname = (fname:gsub(tbl[1], tbl[2])) -- make sure only string is returned
    end
    -- not sure if this can happen, catch all just in case
    if fname == nil or fname == "" then
      return "<anonymous>"
    end
    return fname
  end
end

local normalize_html = function(str)
  local symbol_map = {
    ["&lt;"] = "<",
    ["&gt;"] = ">",
    ["&amp;"] = "&",
    ["&quot;"] = '"',
    ["&apos;"] = "'",
    ["&nbsp;"] = " ",
    ["&copy;"] = "©",
    ["&ndash;"] = "–",
  }

  for key, value in pairs(symbol_map) do
    str = str:gsub(key, value)
  end

  return str
end

local to_yaml = function(entry)
  local lines = {}

  for key, value in pairs(entry) do
    if type(value) == "function" then
      get_anon_function_name(value)
    end
    value = tostring(value)

    if key == "attribution" then
      value = normalize_html(value)
      value = value:gsub("<a.*>(.*)</a>", "%1")
      value = value:gsub("<br>", "")
      value = value:gsub("\n *", " ")
    end
    if key == "links" then
      value = vim.fn.json_encode(value)
    end
    table.insert(lines, key .. ": " .. value)
  end
  return table.concat(lines, "\n")
end
local keymaps_previewer = previewers.new_buffer_previewer({
  title = "Keymaps",
  define_preview = function(self, entry)
    local bufnr = self.state.bufnr
    local transpiled = to_yaml(entry.value)
    local lines = vim.split(transpiled, "\n")
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
    vim.bo[bufnr].ft = "yaml"

    require("telescope.previewers.utils").highlighter(bufnr, "yaml")
  end,
})

return keymaps_previewer
