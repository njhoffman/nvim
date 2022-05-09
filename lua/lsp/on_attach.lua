local api = vim.api
local M = {}

local function reduce_capabilities(client)
  local capabilities = client.server_capabilities
  -- @param filter = table {"hover"}
  local reduce = function(filter)
    local result = {}
    for k, _ in pairs(capabilities) do
      table.insert(
        result,
        f.map(function(v)
          return { v = capabilities[v] }
        end)(f.filter(f.contains(k))(filter))
      )
    end
    return f.flatten(result)
  end
  return reduce({})
end

local function count_capabilities(client)
  local capabilities = client.server_capabilities
  local count = 0
  for k, _ in pairs(capabilities) do
    if _ == true then
      count = count + 1
    end
  end
  -- print(vim.inspect(count))
  return count
end

local function log_capabilities(client, verbosity)
  local capabilities = client.server_capabilities
  -- {
  --   server_capabilities = {
  --   call_hierarchy                     = false,
  --   code_action                        = {      codeActionKinds = { "", "quickfix", "refactor.rewrite", "refactor.extract" },      resolveProvider = false    },
  --   code_lens                          = false,
  --   code_lens_resolve                  = false,
  --   completion                         = true,
  --   declaration                        = false,
  --   document_formatting                = false,
  --   document_highlight                 = true,
  --   document_range_formatting          = false,
  --   document_symbol                    = true,
  --   execute_command                    = true,
  --   find_references                    = true,
  --   goto_definition                    = true,
  --   hover                              = true,
  --   implementation                     = false,
  --   rename                             = true,
  --   signature_help                     = true,
  --   signature_help_trigger_characters  = { "(", "," },
  --   text_document_did_change           = 2,
  --   text_document_open_close           = true,
  --   text_document_save                 = false,
  --   text_document_save_include_text    = false,
  --   text_document_will_save            = false,
  --   text_document_will_save_wait_until = false,
  --   type_definition                    = true,
  --   workspace_folder_properties        = {      changeNotifications = false,      supported = false    },
  --   workspace_symbol                   = true,
  -- }}

  local capability_map = {
    call_hierarchy = "call",
    code_lens = "clens",
    code_lens_resolve = "clens-res",
    completion = "comp",
    declaration = "dec",
    document_formatting = "doc-form",
    document_highlight = "doc-hl",
    document_range_formatting = "doc-range",
    execute_command = "exec",
    find_references = "find",
    goto_definition = "goto",
    hover = "hover",
    implementation = "impl",
    rename = "ren",
    signature_help = "sig",
    signature_help_trigger_characters = "sig-char",
    text_document_did_change = "td-change",
    text_document_open_close = "td-open",
    text_document_save = "td-save",
    text_document_save_include_text = "td-savetxt",
    text_document_will_save = "td-willsave",
    text_document_will_save_wait_until = "td-willsaveuntil",
    type_definition = "type",
    workspace_symbol = "ws-symbol",
    workspace_folder_changeNotifications = "ws-change",
    workspace_folder_supported = "ws-folder",
  }

  local desc = ""
  local count = 0
  local append_desc = function(key)
    count = count + 1
    if verbosity == 3 then
      -- each key on own line
      desc = desc .. key .. " : " .. capabilities[key] .. "\n  "
    elseif verbosity == 2 then
      -- each set key on own line
      if capabilities[key] then
        desc = desc .. key .. "\n  "
      end
    elseif verbosity == 1 then
      -- abbreviations of only set
      if capabilities[key] then
        desc = desc .. key .. " "
      end
    else
      -- short abbreviations of only set
      if capabilities[key] then
        desc = desc .. capability_map[key] .. " "
      end
    end
  end

  if verbosity >= 2 then desc = count_capabilities(client) .. " capabilities" .. desc .. "\n  " end

  for k, _ in pairs(capability_map) do
    if k == "signature_help_trigger_characters" then
      if capabilities[k] ~= {} then
        append_desc(k)
      end
    elseif k == "workspace_folder_changeNotifications" then
      if capabilities["workspace_folder_properties"]["changeNotifications"] == true then
        append_desc("ws-change")
      end
    elseif k == "workspace_folder_supported" then
      if capabilities["workspace_folder_properties"]["supported"] == true then
        append_desc("ws-folder")
      end
    else
      append_desc(k)
    end
  end

  logger:info(desc)
  -- vim.notify(log_capabilities(client), "info", { title = title_msg })
end


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
  buf_set_keymap("n", "<leader>lwa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
  buf_set_keymap("n", "<leader>lwr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
  buf_set_keymap("n", "<leader>lwl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
  buf_set_keymap("n", "<leader>lrn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
  buf_set_keymap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
  buf_set_keymap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
  buf_set_keymap("n", "<leader>lq", "<cmd>lua vim.diagnostic.setqflist({open = true})<CR>", opts)
  buf_set_keymap("n", "<leader>lca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)

  vim.cmd([[
    autocmd CursorHold <buffer> lua require('config.lsp').show_line_diagnostics()
  ]])

  -- Set some key bindings conditional on server capabilities
  if client.server_capabilities.documentFormattingProvider then
    buf_set_keymap("n", "<leader>F", "<cmd>lua vim.lsp.buf.format()<CR>", opts)
  end
  if client.server_capabilities.document_range_formatting then
    buf_set_keymap("x", "<leader>F", "<cmd>lua vim.lsp.buf.range_formatting()<CR><ESC>", opts)
  end

  -- The blow command will highlight the current variable and its usages in the buffer.
  if client.server_capabilities.documentHighlight then
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

  local has_formatting = "false"
  if client.server_capabilities.documentFormattingProvider then
    buf_set_keymap("n", "<Leader>aa", "<cmd>lua vim.lsp.buf.formatting()<cr>", {})
    vim.api.nvim_command([[augroup Format]])
    vim.api.nvim_command([[autocmd! * <buffer>]])
    vim.api.nvim_command([[autocmd BufWritePost <buffer> lua vim.lsp.buf.format(nil, 500)]])
    -- vim.cmd([[ autocmd BufWritePre * :lua vim.lsp.buf.format(nil, 500) ]])
    vim.api.nvim_command([[augroup END]])
    -- if client.name ~= "tsserver" then end
    has_formatting = "true"
  end

  vim.api.nvim_command("setlocal omnifunc=v:lua.vim.lsp.omnifunc")
  local msg = string.format("LSP server %s started: %s", client.name, has_formatting)
  vim.notify(msg, "trace", {title = "nvim lsp-config"})
end

return M
