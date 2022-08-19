local util = require "utils"
local opts = { noremap = true, silent = true, nowait = true }

local M = {}

M.hover_handler = function(_, result, ctx, config)
  config = config or {}
  config.focus_id = ctx.method
  config.max_width = config.max_width or 80

  if (result.contents ~= nil) then
    local markdown_lines = util.convert_input_to_markdown_lines(result.contents)
    markdown_lines = util.trim_empty_lines(markdown_lines)
    if vim.tbl_isempty(markdown_lines) then
      vim.notify("No information available", "debug")
      return
    end
    return util.open_floating_preview(markdown_lines, "markdown", config)
  end
end

-- show help, man page, or lsp info for item under cursor
M.show_documentation = function(word)
  local cword = word or vim.fn.expand("<cexpr>")
  local res = M.show_help(cword)
  vim.dbg(cword, res)
  -- if res == nil or res == "" then
  --   vim.lsp.buf.hover({
  --     border = "single",
  --   })
  -- end
end

-- show help or man page
M.show_help = function(word)
  local cword = word or vim.fn.expand("<cexpr>")
  local filetype = vim.bo.filetype
  if vim.tbl_contains({ "vim", "help" }, filetype) then
    return vim.cmd("h " .. cword)
  elseif vim.tbl_contains({ "man" }, filetype) then
    return vim.cmd("Man " .. cword)
  end
end

_G.LspDiagnosticsShowPopup = function()
  return vim.diagnostic.open_float(0, { scope = "cursor" })
end

-- Show diagnostics in a pop-up window on hover
_G.LspDiagnosticsPopupHandler = function()
  local current_cursor = vim.api.nvim_win_get_cursor(0)
  local last_popup_cursor = vim.w.lsp_diagnostics_last_cursor or { nil, nil }

  -- Show the popup diagnostics window,
  -- but only once for the current cursor location (unless moved afterwards).
  if not (current_cursor[1] == last_popup_cursor[1] and current_cursor[2] == last_popup_cursor[2]) then
    vim.w.lsp_diagnostics_last_cursor = current_cursor
    local _, winnr = _G.LspDiagnosticsShowPopup()
    if winnr ~= nil then
      -- opacity/alpha for diagnostics
      vim.api.nvim_win_set_option(winnr, "winblend", 20)
    end
  end
end

_G.PeekDefinition = function(lsp_request_method)
  local params = vim.lsp.util.make_position_params()
  local definition_callback = function(_, result, ctx, config)
    -- This handler previews the jump location instead of actually jumping to it
    -- see $VIMRUNTIME/lua/vim/lsp/handlers.lua, function location_handler
    if result == nil or vim.tbl_isempty(result) then
      print("PeekDefinition: " .. "cannot find the definition.")
      return nil
    end
    --- either Location | LocationLink
    --- https://microsoft.github.io/language-server-protocol/specification#location
    local def_result = result[1]

    -- Peek defintion. Currently, use quickui but a better alternative should be found.
    -- vim.lsp.util.preview_location(result[1])
    local def_uri = def_result.uri or def_result.targetUri
    local def_range = def_result.range or def_result.targetSelectionRange
    vim.fn['quickui#preview#open'](vim.uri_to_fname(def_uri), {
      cursor = def_range.start.line + 1,
      number = 1, -- show line number
      persist = 0,
    })
  end
  -- Asynchronous request doesn't work very smoothly, so we use synchronous one with timeout;
  -- return vim.lsp.buf_request(0, 'textDocument/definition', params, definition_callback)
  lsp_request_method = lsp_request_method or 'textDocument/definition'
  local results, err = vim.lsp.buf_request_sync(0, lsp_request_method, params, 1000)
  if results then
    for client_id, result in pairs(results) do
      definition_callback(client_id, result.result)
    end
  else
    print("PeekDefinition: " .. err)
  end
end

vim.cmd [[
  command! -nargs=0 PeekDefinition      :lua _G.PeekDefinition()
  command! -nargs=0 PreviewDefinition   :PeekDefinition
  " Preview definition.
  nmap <leader>K     <cmd>PeekDefinition<CR>
  nmap <silent> gp   <cmd>lua _G.PeekDefinition()<CR>
  " Preview type definition.
  nmap <silent> gT   <cmd>lua _G.PeekDefinition('textDocument/typeDefinition')<CR>
]]

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

M.attach_signature = function(_, bufnr)
  local lsp_sig = require('lsp.signature')
  require "lsp_signature".on_attach(lsp_sig.cfg, bufnr)
end

M.attach_keymaps = function(_, bufnr)
  local function keymap(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end

  -- keymap("n", "<C-]>", "gd tags or definitions or help or man, opts)
  -- keymap("n", "<C-S-]>", "cyle references, diagnostics, gotofiles", opts)


  keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
  keymap("n", "gy", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
  keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
  if vim.fn.exists(':Telescope') then
    keymap("n", "<leader>gi", "<cmd>Telescope lsp_implementations<CR>", opts)
    keymap("n", "<leader><gh>", ":Telescope help_tags<cr>", opts)
    -- buf_set_keymap('n', 'gr', '<cmd>Telescope lsp_references<CR>', opts)
    -- buf_set_keymap('n', 'gd', '<cmd>Telescope lsp_definitions<CR>', opts)
    -- buf_set_keymap('n', 'gi', '<cmd>Telescope lsp_implementations<CR>', opts)
    -- buf_set_keymap('n', 'gt', '<cmd>Telescope lsp_type_definitions<CR>', opts)
  end

  keymap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev({ enable_popup = false })<CR>", opts)
  keymap("n", "]d", "<cmd>lua vim.diagnostic.goto_next({ enable_popup = false })<CR>", opts)
  keymap("n", "[g", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
  keymap("n", "]g", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
  keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  keymap("n", "K", ":lua require('lsp.handlers').show_documentation()<cr>", opts)
  keymap("n", "gh", ":lua require('lsp.handlers').show_help()<cr>", opts)
  keymap("n", "<leader>gr", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  keymap("n", "gR", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  keymap("n", "<leader>lwd", "<cmd>Telescope lsp_workspace_diagnostics<CR>", opts)
  keymap("n", "<leader>ld", "<cmd>lua vim.diagnostic.show_line_diagnostics()<CR>", opts)
  keymap("n", "<leader>lq", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
  -- keymap("n", "<leader>q", "<cmd>Telescope lsp_code_actions<CR>", opts)
  keymap("n", "<leader>la", "<cmd>Telescope lsp_code_actions<CR>", opts)
  keymap("n", "<leader>k", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
  keymap("n", "ff", "<cmd>lua vim.lsp.buf.format()<CR>", opts)
  keymap("n", "ca", "<cmd>CodeActionMenu<cr>", opts)

  -- actions
  keymap("n", "<leader>lc", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
  keymap("n", "<leader>lwa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
  keymap("n", "<leader>lwr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
  keymap("n", "<leader>lwl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
  keymap("n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
end

M.attach_formatting = function(client, bufnr)
  if client.supports_method "textDocument/formatting" then
    -- vim.api.nvim_exec(
    --   [[
    --   augroup LspAutocommands
    --   autocmd! * <buffer>
    --   autocmd BufWritePre <buffer> lua local pos = vim.api.nvim_win_get_cursor(0); vim.lsp.buf.format(); vim.cmd("$g/^$/d"); vim.api.nvim_win_set_cursor(0, pos)
    --   augroup END
    --   ]],
    --   true
    -- )
    vim.api.nvim_exec(
      [[
      augroup LspAutocommands
      autocmd! * <buffer>
      autocmd BufWritePre <buffer> lua vim.lsp.buf.format()
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
