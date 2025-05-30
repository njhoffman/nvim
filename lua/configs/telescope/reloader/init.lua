local finders = require("telescope.finders")
local previewers = require("telescope.previewers")
local pickers = require("telescope.pickers")
local conf = require("telescope.config").values

local mappings = require("configs.telescope.reloader.mappings")
local data = require("configs.telescope.reloader.data")
local display = require("configs.telescope.reloader.display")
local utils = require("telescope.utils")

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

---Converts a `RegistryEntry` to yaml
---@param entry RegistryEntry
---@return string
local to_yaml = function(entry)
  local lines = {}

  for key, value in pairs(entry) do
    if key == "attribution" then
      value = normalize_html(value)
      value = value:gsub("<a.*>(.*)</a>", "%1")
      value = value:gsub("<br>", "")
      value = value:gsub("\n *", " ")
    end
    if key == "links" then
      value = vim.fn.json_encode(value)
    end
    table.insert(lines, tostring(key) .. ": " .. tostring(value))
  end

  return table.concat(lines, "\n")
end

local previewer = previewers.new_buffer_previewer({
  title = "Package",
  define_preview = function(self, entry)
    local bufnr = self.state.bufnr
    local transpiled = to_yaml(entry.value)
    local lines = vim.split(transpiled, "\n")
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
    vim.bo[bufnr].ft = "yaml"
  end,
})

local reloader = function(opts)
  local reload_list, column_len = data(opts)
  opts.column_len = vim.F.if_nil(opts.column_len, column_len)
  opts.entry_maker = vim.F.if_nil(opts.entry_maker, display(opts, reload_list))

  pickers
    .new(opts, {
      prompt_title = "Packages",
      results_title = "Reloader Packages",
      finder = finders.new_table({ results = reload_list, entry_maker = opts.entry_maker }),
      -- previewer = previewers.vim_buffer.new(opts),
      sorter = conf.generic_sorter(opts),
      attach_mappings = mappings(opts),
      previewer = previewer,
    })
    :find()
end

return reloader
