--- LSP clients component.
--- Shows attached LSP client names.
---@module "bars.components.lsp_clients"

local M = {}

local function set_hl(group)
  if type(group) ~= "string" or group == "" then
    return ""
  end
  return string.format("%%#%s#", group)
end

---@type table<string, { icon?: string, name?: string, hl?: string }>
local name_map = {
  lua_ls = { icon = " ", name = "LuaLS", hl = "BarsFt5" },
  html = { icon = " ", name = "HTML", hl = "BarsFt2" },
  emmet_language_server = { icon = "󱡴 ", name = "Emmet", hl = "BarsFt4" },
  cssls = { icon = " ", name = "CSS" },
  ts_ls = { icon = " ", name = "TS" },
  jsonls = { icon = " ", name = "JSON" },
  pyright = { icon = " ", name = "Pyright" },
  rust_analyzer = { icon = " ", name = "Rust" },
  gopls = { icon = " ", name = "Go" },
  bashls = { icon = " ", name = "Bash" },
  yamlls = { icon = " ", name = "YAML" },
  clangd = { icon = " ", name = "Clangd" },
}

---@type { icon: string, hl: string }
local default_entry = { icon = "󰒋 ", hl = "BarsFt0" }

--- Returns the attached LSP client names for the statusline.
---@param buffer integer
---@param window integer
---@return string
M.value = function(buffer, window)
  ---|fS

  local clients = vim.lsp.get_clients({ bufnr = buffer })

  if #clients == 0 then
    return ""
  end

  local output = ""

  for c, client in ipairs(clients) do
    local name = client.name or ""
    local entry = name_map[name]

    if entry then
      local hl = set_hl(entry.hl or default_entry.hl)
      local icon = entry.icon or default_entry.icon
      local display = entry.name or name

      output = output .. (c > 1 and "" or " ") .. hl .. icon .. display .. " "
    else
      local hl = set_hl(default_entry.hl)

      output = output .. (c > 1 and "" or " ") .. hl .. default_entry.icon .. name .. " "
    end
  end

  return output

  ---|fE
end

return M
