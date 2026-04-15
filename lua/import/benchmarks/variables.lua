local util = require("import.util")

local ignored = {
  buffer = {},
  window = { "matchup_match_id_list", "matchup_hi_time", "match_pulse_time" },
  global = {},
}

local get_global_variables = function()
  vim.cmd([[
      let temp_reg = @" | redir @" | silent! execute ":let g:" | redir END
      let w:output = copy(@") | let @" = temp_reg " let w:output_len=len(split(output, "\n"))
      let w:output=split(w:output, "\n")
  ]])
  local globals = vim.api.nvim_eval("w:output")
  vim.w.output = ""
  local output = {}
  for _, line in pairs(globals) do
    local pos = vim.fn.match(line, "\\W\\+")
    local key = string.sub(line, 1, pos)
    local var = string.sub(line, pos)
    output[key] = var
  end
  return output
end

local provider = {
  name = "variables",
  diff = function(prev, next)
    local deltas = {}
    for mode, keys in pairs(prev) do
      deltas[mode] = util.diff(keys, next[mode])
    end
    return deltas
  end,
  summary = function(var_groups)
    local out = ""
    local abbrevs = { buffer = "b", window = "w", global = "g" }
    for var_group, delta in pairs(var_groups) do
      if #delta.added > 0 then
        out = table.concat({ out, " ", #delta.added, abbrevs[var_group] })
      end
      -- if #delta.removed > 0 then
      --   out = table.concat({ out, "/-", #delta.removed, abbrevs[var_group] })
      -- end
    end
    return string.format("%10s", out)
  end,

  report = function(path, delta)
    local out = ""
    for _, added in ipairs(delta.added or {}) do
      out = out .. "\n" .. " + var add " .. path .. " " .. added.event .. " " .. added.pattern
    end
    for _, removed in ipairs(delta.removed or {}) do
      out = out .. "\n" .. " - var rem "
        or {} .. path .. " " .. removed.event .. " " .. removed.pattern
    end

    local summary = ""
    if delta and delta.added and #delta.added > 0 then
      summary = path
        .. "  +"
        .. (#delta.added > 0 and #delta.added)
        .. ":-"
        .. #delta.removed
        .. " items for variables"
    end
    return summary .. out
  end,

  get = function(data)
    local var_groups = data
      or {
        buffer = vim.fn.getbufvar(0, ""),
        global = get_global_variables(),
        window = vim.fn.getwinvar(0, ""),
      }
    local var_table = {}
    for var_group, vars in pairs(var_groups) do
      if type(vars) == "table" then
        var_table[var_group] = {}
        for key, var in pairs(vars) do
          local hash = table.concat({ var_group, key, tostring(var) })
          var_table[var_group][tostring(util.get_crc(hash))] = key
        end
      end
    end

    return var_table
  end,
}

return provider
