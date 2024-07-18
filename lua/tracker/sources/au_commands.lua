local base_source = require("tracker.sources._base")
local all_scopes = { g = "global", b = "buffer" }

local get_autocmds = function(scopes)
  return function(self)
    if not vim.islist(scopes) then
      scopes = vim.tbl_keys(scopes)
    end
    local aucmds = vim.api.nvim_get_autocmds({
      -- group = "MyGroup", event = {"BufEnter"}, pattern = {"*.c"}
    })
    local results = {}
    for _, scope in ipairs(scopes) do
      local build_opts = { extra = { scope = scope } }
      local scoped_aucmds = {}
      for _, aucmd in ipairs(aucmds) do
        if scope == "b" and aucmd.buflocal then
          table.insert(scoped_aucmds, aucmd)
        elseif scope == "g" and not aucmd.buflocal then
          table.insert(scoped_aucmds, aucmd)
        end
      end
      self:_build_results(results, scoped_aucmds, build_opts)
    end
    return results.items, results.columns
  end
end

local init_source = function(scopes)
  scopes = type(scopes) == "table" and scopes
    or type(scopes) == "string" and { scopes }
    or all_scopes
  vim.dbglog("SCOPES", scopes)
  return vim.tbl_extend("force", base_source, {
    name = "au_commands",
    label = "auto commands",
    icon = "",
    fields = {
      "group_name",
      "pattern",
      "event",
      "command",
      --[[ 'callback', ]]
      "buffer",
    },
    -- desc_fields = { 'group_name', 'pattern', 'event' },
    -- output = output_au_cmds(queue, opts),
    get = get_autocmds(scopes),
  })
end

return init_source
