local base_source = require("tracker.sources._base")

local all_scopes = { g = "global", b = "buffer" }
local all_modes = {
  n = "normal",
  i = "insert",
  o = "operator",
  v = "visual",
  s = "search",
  c = "command",
  t = "terminal",
}

local get_keymaps = function(scopes, modes)
  return function(self)
    if not vim.islist(scopes) then
      scopes = vim.tbl_keys(scopes)
    end
    if not vim.islist(modes) then
      modes = vim.tbl_keys(modes)
    end
    local results = {}
    for _, scope in ipairs(scopes) do
      for _, mode in ipairs(modes) do
        local build_opts = { extra = { scope = scope } }
        if scope == "b" then
          local buffers = vim.api.nvim_list_bufs()
          for _, bufnr in ipairs(buffers) do
            local keymaps = vim.api.nvim_buf_get_keymap(bufnr, mode)
            build_opts.extra.bufnr = bufnr
            self:_build_results(results, keymaps, build_opts)
          end
        else
          local keymaps = vim.api.nvim_get_keymap(mode)
          self:_build_results(results, keymaps, build_opts)
        end
      end
    end
    return results.items, results.columns
  end
end

local init_source = function(scopes, modes)
  scopes = type(scopes) == "table" and scopes
    or type(scopes) == "string" and { scopes }
    or vim.tbl_keys(all_scopes)
  modes = type(modes) == "table" and modes or type(modes) == "string" and { modes } or all_modes
  local prefix = (scopes and #scopes > 0 and vim.fn.join(scopes, "") or "")
    .. (modes and #modes > 0 and "_" .. vim.fn.join(modes, "") or "")

  return vim.tbl_extend("force", base_source, {
    name = #prefix > 0 and "keys_" .. prefix or "keys",
    interval = 2000,
    get = get_keymaps(scopes or all_scopes, modes or all_modes),
    fields = { "mode", "scope", "bufnr", "lhs", "rhs", "callback" },
    icon = "",
  })
end

return init_source
