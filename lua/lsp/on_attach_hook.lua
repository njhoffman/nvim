local config = require("config")
local lsp_signature = require("lsp_signature")
local aerial = require('aerial')
local lsp_status = require("lsp-status")
local f = require("utils.functional")
local helpers = require("helpers")
local logger = require("logger").initLogger("lsp")

local function documentFormat(client)
	if client.resolved_capabilities.document_formatting then
		vim.cmd([[augroup Format]])
		vim.cmd([[autocmd! * <buffer>]])
		vim.api.nvim_command([[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync(nil, 2000)]])
		-- vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.format_sync(nil, 500)]]
		-- vim.cmd([[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting()]])
		-- vim.cmd [[autocmd BufWritePost <buffer> lua require'lsp.formatters'.format()]]
		vim.cmd([[augroup END]])
		-- print("Formatting supported %s", client.name)
	elseif client.resolved_capabilities.document_range_formatting then
		vim.api.nvim_command([[autocmd BufWritePre <buffer> lua vim.lsp.buf.range_formatting()]])
		-- vim.api.nvim_command[[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()]]
		-- utils.keymap({"n", "<Leader>aa", "<cmd>lua vim.lsp.buf.formatting()<cr>", {}})
		--   buf_set_keymap("n", "ff", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
	end
	vim.api.nvim_command("noautocmd :update")
end

local function documentCodeAction(client)
	if client.resolved_capabilities.code_action then
		vim.cmd([[augroup CodeAction]])
		vim.cmd([[autocmd! * <buffer>]])
		vim.cmd([[autocmd CursorHold * lua require'plugins.configs.nvim-lightbulb']])
		vim.cmd([[augroup END]])
	end
end

local function documentHighlight(client)
	-- Set autocommands conditional on server_capabilities
	if client.resolved_capabilities.document_highlight then
		vim.api.nvim_exec(
			[[
    hi LspReferenceRead cterm=bold ctermbg=red guibg=#464646
    hi LspReferenceText cterm=bold ctermbg=red guibg=#464646
    hi LspReferenceWrite cterm=bold ctermbg=red guibg=#464646
    augroup lsp_document_highlight
    autocmd! * <buffer>
    autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
    autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
    augroup END
      ]],
			false
		)
	end
end

local function documentHoverDiagnostic()
	-- Set autocommands conditional on server_capabilities
	-- lua vim.lsp.diagnostic.show_line_diagnostics({focusable = false})
	if config.LSP.hover_diagnostic == "popup" then
		vim.api.nvim_exec(
			[[
    augroup lsp_diagnostic
    autocmd! * <buffer>
    autocmd CursorHold * lua require"lspsaga.diagnostic".show_line_diagnostics()
    autocmd CursorHoldI * silent! lua require"lspsaga.diagnostic".signature_help()
    augroup END
      ]],
			false
		)
	elseif config.LSP.hover_diagnostic == "virtual" then
		vim.api.nvim_exec(
			[[
    augroup lsp_diagnostic
    autocmd! * <buffer>
    autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()
    autocmd CursorHoldI * silent! lua vim.lsp.buf.signature_help()
    augroup END
      ]],
			false
		)
	end
	-- imApi.nvim_command [[autocmd CursorHold <buffer> lua vim.lsp.util.show_line_diagnostics()]]
	-- vimApi.nvim_command [[autocmd CursorMoved <buffer> lua vim.lsp.util.show_line_diagnostics()]]
end

local function documentSignature()
	lsp_signature.on_attach({
		bind = true, -- This is mandatory, otherwise border config won't get registered.
		-- -- If you want to hook lspsaga or other signature handler, pls set to false
		-- doc_lines = 2, -- will show two lines of comment/doc(if there are more than two lines in doc, will be truncated);
		-- -- set to 0 if you DO NOT want any API comments be shown
		-- -- This setting only take effect in insert mode, it does not affect signature help in normal
		-- -- mode, 10 by default

		-- floating_window = true, -- show hint in a floating window, set to false for virtual text only mode
		-- fix_pos = false, -- set to true, the floating window will not auto-close until finish all parameters
		-- hint_enable = true, -- virtual hint enable
		-- hint_prefix = "🐼 ", -- Panda for parameter
		-- hint_scheme = "String",
		-- use_lspsaga = false, -- set to true if you want to use lspsaga popup
		-- hi_parameter = "Search", -- how your parameter will be highlight
		-- max_height = 12, -- max height of signature floating_window, if content is more than max_height, you can scroll down
		-- -- to view the hiding contents
		-- max_width = 120, -- max_width of signature floating_window, line will be wrapped if exceed max_width
		handler_opts = {
			border = "single", -- double, single, shadow, none
		},
		-- extra_trigger_chars = {}, -- Array of extra characters that will trigger signature completion, e.g., {"(", ","}
	})
end

local function reduce_capabilities(client)
	local capabilities = client.resolved_capabilities
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
	local capabilities = client.resolved_capabilities
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
	local capabilities = client.resolved_capabilities
    -- {
    --   resolved_capabilities = {
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

local M = {}

function M.common_on_attach(client, bufnr)

  -- local capabilities_count = count_capabilities(client)
  -- local title_msg = "'" .. client.name .. "' attached to " .. bufnr .. " (" .. capabilities_count .. " capabilties)"
  -- logger:info(title_msg)
  -- logger:debug(inspect(client.resolved_capabilities))
  -- local verbosity = 2
  -- log_capabilities(client, verbosity)

	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  aerial.on_attach(client, bufnr)
	-- documentHoverDiagnostic()
	-- documentSignature()
	documentFormat(client)
	-- documentCodeAction(client)

	if config.LSP.highlight_word == nil or config.LSP.highlight_word == true then
		documentHighlight(client)
	end

	lsp_status.on_attach(client)
end

return M
