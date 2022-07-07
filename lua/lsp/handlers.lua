local utils = require "utils"
local opts = { noremap = true, silent = true, nowait = true }
local keymap = function(bufnr, ...)
  vim.api.nvim_buf_set_keymap(bufnr, ...)
end
local option = function(bufnr, ...)
  vim.api.nvim_buf_set_option(bufnr, ...)
end

local M = {}

-- show help, man page, or lsp info for item under cursor
M.show_documentation = function(word)
  local cword = word or vim.fn.expand("<cword>")
  local res = M.show_help(cword)
  if res == nil or res == "" then
    vim.lsp.buf.hover({
      border = "single",
    })
  end
end

-- show help or man page
M.show_help = function(word)
  local cword = word or vim.fn.expand("<cword>")
  local filetype = vim.bo.filetype
  if vim.tbl_contains({ "vim", "help" }, filetype) then
    return vim.cmd("h " .. cword)
  elseif vim.tbl_contains({ "man" }, filetype) then
    return vim.cmd("Man " .. cword)
  end
  vim.lsp.buf.hover()
end

M.attach_document_highlight = function(_, result, ctx, config)
  -- Set autocommands conditional on server_capabilities
  vim.api.nvim_exec([[
    augroup lsp_document_highlight
      autocmd! * <buffer>
      autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
      autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
    augroup END
    ]], false)
end


M.attach_code_lens = function(_, ...)
  if client.server_capabilities.code_lens then
    vim.cmd([[
      augroup lsp_codelens
      autocmd! * <buffer>
      autocmd CursorHold,CursorHoldI,InsertLeave <buffer> lua require"lsp-codelens".buf_codelens_refresh()
      augroup END
    ]])
  end
end

local lsp_formatting = function(bufnr)
  local pos = vim.api.nvim_win_get_cursor(0)
  vim.lsp.buf.format(
    {
      bufnr = bufnr
      -- filter = function(clients)
      -- return vim.tbl_filter(function(client) end)
      --     vim.logger:debug(client)
      --     -- if client.name == "sqls" then
      --     --   return false
      --     -- end
      --     return client
      --   end, clients)
      -- end
    }
  )
  vim.api.nvim_win_set_cursor(0, pos)
end

M.attach_formatting = function(client, bufnr)
  if client.supports_method "textDocument/formatting" then
    vim.api.nvim_exec(
      [[
      augroup LspAutocommands
      autocmd! * <buffer>
      autocmd BufWritePre <buffer> lua local pos = vim.api.nvim_win_get_cursor(0); vim.lsp.buf.format(); vim.cmd("$g/^$/d"); vim.api.nvim_win_set_cursor(0, pos)
      augroup END
      ]],
      true
    )
    -- local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

    -- vim.api.nvim_buf_create_user_command(
    --   bufnr,
    --   "LspFormatting",
    --   function()
    --     vim.notify("FORMAT", "debug")
    --     lsp_formatting(bufnr)
    --   end,
    --   {}
    -- )
    -- -- vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }

    -- vim.api.nvim_create_autocmd(
    --   "BufWritePre",
    --   {
    --     group = augroup,
    --     buffer = bufnr,
    --     command = "LspFormatting"
    --   }
    -- )
  end
end

M.attach_code_lens = function(client, bufnr)
  if client.server_capabilities.code_lens then
    vim.cmd [[
      augroup lsp_codelens
      autocmd! * <buffer>
      autocmd CursorHold,CursorHoldI,InsertLeave <buffer> lua require"lsp-codelens".buf_codelens_refresh()
      augroup END
      ]]
  end
end


return M


--
-- :lua print(vim.inspect(vim.tbl_keys(vim.lsp.handlers)))
-- ["$/progress"] = <function 1>,
-- ["callHierarchy/incomingCalls"] = <function 2>,
-- ["callHierarchy/outgoingCalls"] = <function 3>,
-- ["client/registerCapability"] = <function 4>,
-- hover = <function 5>,
-- signature_help = <function 6>,
-- ["textDocument/codeLens"] = <function 7>,
-- ["textDocument/completion"] = <function 8>,
-- ["textDocument/declaration"] = <function 9>,
-- ["textDocument/definition"] = <function 10>,
-- ["textDocument/documentHighlight"] = <function 11>,
-- ["textDocument/documentSymbol"] = <function 12>,
-- ["textDocument/formatting"] = <function 13>,
-- ["textDocument/hover"] = <function 14>,
-- ["textDocument/implementation"] = <function 15>,
-- ["textDocument/publishDiagnostics"] = <function 16>,
-- ["textDocument/rangeFormatting"] = <function 17>,
-- ["textDocument/references"] = <function 18>,
-- ["textDocument/rename"] = <function 19>,
-- ["textDocument/signatureHelp"] = <function 20>,
-- ["textDocument/typeDefinition"] = <function 21>,
-- ["window/logMessage"] = <function 22>,
-- ["window/showMessage"] = <function 23>,
-- ["window/showMessageRequest"] = <function 24>,
-- ["window/workDoneProgress/create"] = <function 25>,
-- ["workspace/applyEdit"] = <function 26>,
-- ["workspace/configuration"] = <function 27>,
-- ["workspace/executeCommand"] = <function 28>,
-- ["workspace/symbol"] = <function 29>,
-- ["workspace/workspaceFolders"] = <function 30>
