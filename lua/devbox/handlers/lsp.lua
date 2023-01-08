local get_lines = function(line_str)
  return vim.lsp.util.trim_empty_lines(vim.split(line_str, "\n"))
end

local buf_handlers = {
  ["textDocument/documentSymbol"] = {
    -- [0].detail, kind, name, range.start.[line|character], range.end.[line|character]
    get_contents = function(result)
      return (result and #result > 0) and result or nil
    end,
    get_summary = function(symbols, load_time)
      return load_time .. " symbol     " .. " " .. #symbols .. " symbols"
    end,
  },
}

local handlers = {
  ["textDocument/completion"] = {
    get_contents = function(result)
      return (result and result.items and #result.items > 0) and result.items or nil
    end,
    get_summary = function(targets, load_time)
      return load_time .. " completion " .. #targets .. " items"
    end,
  },
  ["textDocument/references"] = {
    -- [0].range.start.[line|character], [0].range.end.[line|character]
    get_contents = function(result)
      return (result and #result > 0) and result or nil
    end,
    get_summary = function(targets, load_time)
      return load_time .. " references " .. #targets .. " files"
    end,
  },
  ["textDocument/definition"] = {
    -- [0].target, [0].
    get_contents = function(result)
      return (result and #result > 0) and result or nil
    end,
    get_summary = function(targets, load_time)
      return load_time .. " definition " .. #targets .. " files"
    end,
  },
  ["textDocument/signatureHelp"] = {
    get_contents = function(result)
      return result and result.signatures or nil
    end,
    get_summary = function(signatures, load_time)
      local summary = load_time .. " signature  "
      for _, signature in ipairs(signatures) do
        if signature.documentation then
          summary = summary .. #get_lines(signature.documentation.value) .. " lines" .. " "
        else
          summary = summary .. #signature.label .. " label" .. " "
        end
      end
      return summary
    end,
  },
  ["textDocument/hover"] = {
    get_contents = function(result)
      if result and result.contents and result.contents.value then
        return result.contents.value
      end
      return nil
    end,
    get_summary = function(content, load_time)
      return load_time .. " hover      " .. #get_lines(content) .. " lines"
    end,
  },
  default = {
    get_contents = function(result)
      vim.dbglog(result)
      return nil
    end,
  },
}

return handlers
