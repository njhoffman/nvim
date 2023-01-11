local util = require("import.util")

local debuglog = require("debuglog")

local get_buffer_variables = function()
  vim.cmd([[
    let temp_reg = @" | redir @" | silent! execute ":let b:" | redir END
    let output = copy(@") | let @" = temp_reg
    let w:output_buffer=split(output, "\n")
  ]])
  return vim.api.nvim_eval("w:output_buffer")
end

local get_window_variables = function()
  vim.cmd([[
    let temp_reg = @" | redir @" | silent! execute ":let w:" | redir END
    let output = copy(@") | let @" = temp_reg
    let w:output_window=split(output, "\n")
  ]])
  return vim.api.nvim_eval("w:output_window")
end

local get_global_variables = function()
  vim.cmd([[
    let temp_reg = @" | redir @" | silent! execute ":let g:" | redir END
    let output = copy(@") | let @" = temp_reg
    let w:output_global=split(output, "\n")
  ]])
  return vim.api.nvim_eval("w:output_global")
end

local get_predef_variables = function()
  vim.cmd([[
    let temp_reg = @" | redir @" | silent! execute ":let v:" | redir END
    let output = copy(@") | let @" = temp_reg
    let w:output_predef=split(output, "\n")
  ]])
  return vim.api.nvim_eval("w:output_predef")
end

local provider = {
  name = "variables",
  diff = util.diff,
  summary = function(delta)
    local out = ""
    if #delta.added > 0 then
      out = out .. " " .. #delta.added
    end
    -- if #delta.removed > 0 then
    --   out = out .. " +" .. #delta.removed
    -- end
    if #out > 0 then
      out = " " .. out .. " var "
    end
    return string.format("%10s", out)
  end,
  report = function(path, delta)
    local out = ""
    for _, added in ipairs(delta.added) do
      out = out .. "\n" .. " + var add " .. path .. " " .. added.event .. " " .. added.pattern
    end
    for _, removed in ipairs(delta.removed) do
      out = out .. "\n" .. " - var rem " .. path .. " " .. removed.event .. " " .. removed.pattern
    end
    local summary = path .. "  +" .. #delta.added .. ":-" .. #delta.removed .. " lines for autovariables"
    return summary .. out
  end,
  get = function(data)
    local util = require("import.util")
    local vargroups = data
      or {
        buffer = get_buffer_variables(),
        predef = get_predef_variables(),
        global = get_global_variables(),
        window = get_window_variables(),
      }
    local vartable = {}
    for vargroup, vars in pairs(vargroups) do
      vartable[vargroup] = {}
      for _, key in ipairs(vars) do
        local hash = table.concat({
          key.desc or "",
          key.lhs,
          key.rhs or "",
        })
        vartable[mode][tostring(util.get_crc(hash))] = key
      end
    end
    return vartable
  end,
}

provider.get()

-- return provider
