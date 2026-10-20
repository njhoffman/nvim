-- Guards against reintroducing deprecated or removed Neovim APIs (TODO item 1).
-- Scans config Lua sources as text; comments are ignored.

local root = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h:h:h")
local dirs = { "lua", "after", "plugin", "ftplugin" }

-- { lua pattern, replacement hint }
local deprecated = {
  { "%f[%w_]vim%.loop[^%w_]", "vim.uv" },
  { "nvim_buf_[gs]et_option%(", "nvim_get_option_value / nvim_set_option_value with { buf = }" },
  { "nvim_win_[gs]et_option%(", "nvim_get_option_value / nvim_set_option_value with { win = }" },
  { "nvim_[gs]et_option%(", 'nvim_*_option_value with { scope = "global" }' },
  { "nvim_err_writeln", "nvim_echo({ { msg } }, true, { err = true })" },
  { "nvim_buf_add_highlight", 'require("utils.hl").add_highlight' },
  { "nvim_get_hl_by_name", "nvim_get_hl(0, { name = ... })" },
  { "nvim_get_hl_by_id", "nvim_get_hl(0, { id = ... })" },
  { "nvim_exec%(", "nvim_exec2" },
  { "%f[%w_]vim%.tbl_flatten", "vim.iter(t):flatten(math.huge):totable()" },
  { "%f[%w_]vim%.tbl_islist", "vim.islist" },
  { "%f[%w_]vim%.F%.if_nil", "vim.nonnil" },
  { "%f[%w_]vim%.highlight%.", "vim.hl" },
  { "%f[%w_]vim%.region%(", "vim.fn.getregionpos" },
  { "get_active_clients", "vim.lsp.get_clients" },
  { "buf_get_clients", "vim.lsp.get_clients({ bufnr = })" },
  { "lsp%.buf%.formatting", "vim.lsp.buf.format" },
  { "lsp%.start_client%(", "vim.lsp.start" },
  { "jump_to_location", "vim.lsp.util.show_document" },
  { "diagnostic%.goto_next", "vim.diagnostic.jump({ count = 1, float = true })" },
  { "diagnostic%.goto_prev", "vim.diagnostic.jump({ count = -1, float = true })" },
  { "diagnostic%.disable%(", "vim.diagnostic.enable(false, filter)" },
  { "diagnostic%.is_disabled", "vim.diagnostic.is_enabled" },
  { "query%.get_node_text%(", "vim.treesitter.get_node_text" },
  { "require%(%s*[\"']nvim%-treesitter%.ts_utils[\"']%s*%)", "vim.treesitter APIs" },
  { "%f[%w_]vim%.validate%s*%(?%s*{", "vim.validate(name, value, validator, optional)" },
  { "client%.supports_method%(", "client:supports_method(...)" },
}

local function strip_comment(line)
  local trimmed = line:match("^%s*(.*)$")
  if trimmed:sub(1, 2) == "--" then
    return ""
  end
  -- drop a trailing comment that starts outside a string literal
  local in_str
  for i = 1, #line do
    local c = line:sub(i, i)
    if in_str then
      if c == "\\" then
        i = i + 1
      elseif c == in_str then
        in_str = nil
      end
    elseif c == '"' or c == "'" then
      in_str = c
    elseif line:sub(i, i + 1) == "--" then
      return line:sub(1, i - 1)
    end
  end
  return line
end

local function lua_files()
  local files = {}
  for _, dir in ipairs(dirs) do
    vim.list_extend(files, vim.fn.globpath(root .. "/" .. dir, "**/*.lua", false, true))
  end
  return files
end

describe("deprecated Neovim APIs", function()
  it("finds config sources to scan", function()
    assert.is_true(#lua_files() > 100)
  end)

  it("are not used in config sources", function()
    local hits = {}
    local in_block_comment = false
    for _, file in ipairs(lua_files()) do
      local lnum = 0
      in_block_comment = false
      for line in io.lines(file) do
        lnum = lnum + 1
        if in_block_comment then
          if line:find("%]=*%]") then
            in_block_comment = false
          end
        elseif line:match("^%s*%-%-%[=*%[") and not line:find("%]=*%]") then
          in_block_comment = true
        else
          local code = strip_comment(line)
          for _, entry in ipairs(deprecated) do
            if code:find(entry[1]) then
              table.insert(
                hits,
                ("%s:%d uses %s -> %s"):format(file:sub(#root + 2), lnum, entry[1], entry[2])
              )
            end
          end
        end
      end
    end
    assert.are.same({}, hits)
  end)
end)
