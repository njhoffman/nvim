local get_lines = function(line_str)
  return vim.lsp.util.trim_empty_lines(vim.split(line_str, '\n'))
end

-- local buf_handlers = {
--   ['textDocument/documentSymbol'] = {
--     -- [0].detail, kind, name, range.start.[line|character], range.end.[line|character]
--     get_contents = function(result)
--       return (result and #result > 0) and result or nil
--     end,
--     get_summary = function(symbols, load_time)
--       return load_time .. ' symbol     ' .. ' ' .. #symbols .. ' symbols'
--     end,
--   },
-- }
--
local handlers = {
  --   ['textDocument/completion'] = {
  --     get_contents = function(result)
  --       return (result and result.items and #result.items > 0) and result.items or nil
  --     end,
  --     get_summary = function(targets, load_time)
  --       return load_time .. ' completion ' .. #targets .. ' items'
  --     end,
  --   },
  --   ['textDocument/codeAction'] = {
  --     -- { originSelectionRange, targetRange, targetSelectionRange, targetUri }
  --     -- range { end = { character, line }, start = { character, line } }
  --     get_contents = function(results)
  --       return (results and #results > 0) and results or nil
  --     end,
  --     get_summary = function(targets, load_time)
  --       return load_time .. ' codeaction ' .. #targets .. ' commands'
  --     end,
  --   },
  --   ['textDocument/references'] = {
  --     get_contents = function(_result)
  --       local result = _result and _result.result or _result
  --       local filepath = vim.api.nvim_buf_get_name(0)
  --       local lnum = vim.api.nvim_win_get_cursor(0)[1]
  --       if result and _result.context then
  --         local results = vim.lsp.util.locations_to_items(result, vim.lsp.get_client_by_id(_result.context.client_id).offset_encoding)
  --         local locations = vim.tbl_filter(function(v)
  --           -- Remove current line from result
  --           return not (v.filename == filepath and v.lnum == lnum)
  --         end, vim.F.if_nil(results, {}))
  --         return (locations and #locations > 0) and locations or nil
  --       end
  --     end,
  --     get_summary = function(targets, load_time)
  --       -- { filename, col, lnum, text }
  --       return load_time .. ' references ' .. #targets .. ' locations'
  --     end,
  --   },
  --   ['textDocument/definition'] = {
  --     -- { originSelectionRange, targetRange, targetSelectionRange, targetUri }
  --     -- range { end = { character, line }, start = { character, line } }
  --     get_contents = function(result)
  --       return (result and #result > 0) and result or nil
  --     end,
  --     get_summary = function(targets, load_time)
  --       return load_time .. ' definition ' .. #targets .. ' locations'
  --     end,
  --   },
  --   ['textDocument/signatureHelp'] = {
  --     get_contents = function(result)
  --       return result and result.signatures or nil
  --     end,
  --     get_summary = function(signatures, load_time)
  --       local summary = load_time .. ' signature  '
  --       for _, signature in ipairs(signatures) do
  --         if signature.documentation then
  --           summary = summary .. #get_lines(signature.documentation.value) .. ' lines' .. ' '
  --         else
  --           summary = summary .. #signature.label .. ' label' .. ' '
  --         end
  --       end
  --       return summary
  --     end,
  --   },
  ['textDocument/hover'] = {
    get_contents = function(result)
      vim.dbglog('hover', result)
      if result and result.contents and result.contents.value then
        return result.contents.value
      end
      return nil
    end,
    get_summary = function(content, load_time)
      return load_time .. ' hover      ' .. #get_lines(content) .. ' lines'
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
