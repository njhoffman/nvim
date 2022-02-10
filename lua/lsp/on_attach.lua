local api = vim.api
local M = {}

local show_documentation = function(bufnr)
  local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")

  -- " Use K to show documentation in preview window
  -- nnoremap <silent> K :call <SID>show_documentation()<CR>

  -- function! s:show_documentation()
  --   if (&filetype == 'lua')
  --     let s:word = expand('<cWORD>')
  --     echo s:word
  --     if (stridx(s:word, 'vim.api.') >= 0 || stridx(s:word, 'api.') >= 0)
  --       execute 'h ' . expand('<cword>')
  --     else
  --       call CocAction('doHover')
  --     endif
  --   elseif (index(['vim','help'], &filetype) >= 0)
  --     execute 'h '.expand('<cword>')
  --   else
  --     call CocAction('doHover')
  --   endif
  -- endfunction
end

M.custom_attach = function(client, bufnr)
  local function buf_set_keymap(...)
    api.nvim_buf_set_keymap(bufnr, ...)
  end

  -- lsp_status.on_attach(client)
  require "lsp_signature".on_attach(
    {
      bind = true, -- This is mandatory, otherwise border config won't get registered.
      handler_opts = {border = "rounded"}
    },
    bufnr
  )
  -- Mappings.

  local opts = {noremap = true, silent = true}
  buf_set_keymap("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
  buf_set_keymap("n", "<C-]>", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
  buf_set_keymap("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
  buf_set_keymap("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  buf_set_keymap("n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
  buf_set_keymap("n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
  buf_set_keymap("n", "<space>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
  buf_set_keymap("n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
  buf_set_keymap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
  buf_set_keymap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
  buf_set_keymap("n", "<space>q", "<cmd>lua vim.diagnostic.setqflist({open = true})<CR>", opts)
  buf_set_keymap("n", "<space>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)

  vim.cmd([[
    autocmd CursorHold <buffer> lua require('config.lsp').show_line_diagnostics()
  ]])

  -- Set some key bindings conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting_sync()<CR>", opts)
  end
  if client.resolved_capabilities.document_range_formatting then
    buf_set_keymap("x", "<space>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR><ESC>", opts)
  end

  -- The blow command will highlight the current variable and its usages in the buffer.
  if client.resolved_capabilities.document_highlight then
    vim.cmd(
      [[
      hi link LspReferenceRead Visual
      hi link LspReferenceText Visual
      hi link LspReferenceWrite Visual
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]]
    )
  end

  if client.resolved_capabilities.document_formatting then
    buf_set_keymap("n", "<Leader>aa", "<cmd>lua vim.lsp.buf.formatting()<cr>", {})
    vim.api.nvim_command([[augroup Format]])
    vim.api.nvim_command([[autocmd! * <buffer>]])
    vim.api.nvim_command([[autocmd BufWritePost <buffer> lua vim.lsp.buf.formatting_sync(nil, 500)]])
    -- vim.cmd([[ autocmd BufWritePre * :lua vim.lsp.buf.formatting_sync(nil, 500) ]])
    vim.api.nvim_command([[augroup END]])
    -- if client.name ~= "tsserver" then end
    vim.notify(string.format("+Formatting %s", client.name), "debug")
  end

  vim.api.nvim_command("setlocal omnifunc=v:lua.vim.lsp.omnifunc")
  local msg = string.format("LSP server %s started", client.name)
  vim.notify(msg, "trace", {title = "nvim lsp-config"})
end

return M
