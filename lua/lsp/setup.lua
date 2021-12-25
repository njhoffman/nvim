local config = require("config")

vim.lsp.set_log_level(config.LSP.log_level)
require('vim.lsp.log').set_format_func(vim.inspect)

-- lsp
	require("lsp.ls.bashls")
  require("lsp.ls.dockerls")
  require("lsp.ls.gopls")
  require("lsp.ls.luals")
  require("lsp.ls.vimls")

	-- require("lsp.ls.cssls")
	-- -- require('lsp.ls.clangd') - ccls
	-- -- require('lsp.ls.cmake')
	-- -- require('lsp.ls.cssls')
	-- -- require('lsp.ls.dhall-lsp') - hls
	-- -- require("lsp.ls.flow")
	-- -- require('lsp.ls.graphql')
	-- -- go get github.com/nametake/golangci-lint-langserver
	-- -- require("lsp.ls.golangcilsp")
	-- require("lsp.ls.html")
	-- require("lsp.ls.jsonls")
	-- require('lsp.ls.perlls')
	-- -- require('lsp.ls.phpactor')
	-- -- require('lsp.ls.pyright') -- pyls, pylsp
	-- -- require "lsp.ls.solargraph"
	-- -- require "lsp.ls.rust_analyzer" - rls
	-- require('lsp.ls.sqlls')
	-- -- require('lsp.ls.solargraph')
	-- -- require('lsp.ls.stylelint-lsp')
	-- -- require('lsp.ls.tailwindcss')
	-- -- require('lsp.ls.tflint')
	-- -- require('lsp.ls.terraformls')
	-- require("lsp.ls.tsserver")
	-- require("lsp.ls.yamlls")
	-- require("lsp.ls.zeta_note")

	-- lots of bugs: i.e. filetype registration
	-- require("lsp.ls.efmls")
	-- require("lsp.ls.null-ls")

	-- require("lsp.diagnostics").setup()
	-- require("lsp.formatters").setup()
	-- vim.api.nvim_command("noautocmd :update")

-- map("n", "<leader>tg", ":lua diagnostic_toggle_signs()<CR>")

-- vim.cmd [[nnoremap <buffer><silent> <C-space> :lua vim.lsp.diagnostic.show_line_diagnostics({ border = "single" })<CR>]]
-- vim.cmd [[nnoremap <buffer><silent> ]g :lua vim.lsp.diagnostic.goto_next({ popup_opts = { border = "single" }})<CR>]]
-- vim.cmd [[nnoremap <buffer><silent> [g :lua vim.lsp.diagnostic.goto_prev({ popup_opts = { border = "single" }})<CR>]]

-- Print diagnostics in status line
-- function PrintDiagnostics(opts, bufnr, line_nr, client_id)
--   opts = opts or {}

--   bufnr = bufnr or 0
--   line_nr = line_nr or (vim.api.nvim_win_get_cursor(0)[1] - 1)

--   local line_diagnostics = vim.lsp.diagnostic.get_line_diagnostics(bufnr, line_nr, opts, client_id)
--   if vim.tbl_isempty(line_diagnostics) then return end

--   local diagnostic_message = ""
--   for i, diagnostic in ipairs(line_diagnostics) do
--     diagnostic_message = diagnostic_message .. string.format("%d: %s", i, diagnostic.message or "")
--     print(diagnostic_message)
--     if i ~= #line_diagnostics then
--       diagnostic_message = diagnostic_message .. "\n"
--     end
--   end
--   vim.api.nvim_echo({{diagnostic_message, "Normal"}}, false, {})
-- end
-- vim.cmd [[ autocmd CursorHold * lua PrintDiagnostics() ]]

-- Show line diagnostics automatically in hover window
-- -- You will likely want to reduce updatetime which affects CursorHold
-- -- note: this setting is global and should be set only once
-- vim.o.updatetime = 250
-- vim.cmd [[autocmd CursorHold,CursorHoldI * lua vim.lsp.diagnostic.show_line_diagnostics({focusable=false})]]
-- For diagnostics for specific cursor position (Neovim 0.6+)
-- vim.cmd [[autocmd CursorHold,CursorHoldI * lua vim.lsp.diagnostic.show_position_diagnostics({focusable=false})]]

-- Go-to definition in a split window
-- local function goto_definition(split_cmd)
--   local util = vim.lsp.util
--   local log = require("vim.lsp.log")
--   local api = vim.api

--   -- note, this handler style is for neovim 0.5.1/0.6, if on 0.5, call with function(_, method, result)
--   local handler = function(_, result, ctx)
--     if result == nil or vim.tbl_isempty(result) then
--       local _ = log.info() and log.info(ctx.method, "No location found")
--       return nil
--     end

--     if split_cmd then
--       vim.cmd(split_cmd)
--     end

--     if vim.tbl_islist(result) then
--       util.jump_to_location(result[1])

--       if #result > 1 then
--         util.set_qflist(util.locations_to_items(result))
--         api.nvim_command("copen")
--         api.nvim_command("wincmd p")
--       end
--     else
--       util.jump_to_location(result)
--     end
--   end

--   return handler
-- end

-- vim.lsp.handlers["textDocument/definition"] = goto_definition('split')

-- Highlight line number instead of having icons in sign column
-- See the properties of the signs with sign list.

-- vim.cmd [[
-- highlight LspDiagnosticsLineNrError guibg=#51202A guifg=#FF0000 gui=bold
-- highlight LspDiagnosticsLineNrWarning guibg=#51412A guifg=#FFA500 gui=bold
-- highlight LspDiagnosticsLineNrInformation guibg=#1E535D guifg=#00FFFF gui=bold
-- highlight LspDiagnosticsLineNrHint guibg=#1E205D guifg=#0000FF gui=bold

-- sign define DiagnosticSignError text= texthl=LspDiagnosticsSignError linehl= numhl=LspDiagnosticsLineNrError
-- sign define DiagnosticSignWarn text= texthl=LspDiagnosticsSignWarning linehl= numhl=LspDiagnosticsLineNrWarning
-- sign define DiagnosticSignInfo text= texthl=LspDiagnosticsSignInformation linehl= numhl=LspDiagnosticsLineNrInformation
-- sign define DiagnosticSignHint text= texthl=LspDiagnosticsSignHint linehl= numhl=LspDiagnosticsLineNrHint
-- ]]
