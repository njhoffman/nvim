-- https://raw.githubusercontent.com/johmsalas/text-case.nvim/main/README.md

require('textcase').setup({
  prefix = 'gt', -- ga
})

vim.api.nvim_set_keymap('n', 'gt.', '<cmd>TextCaseOpenTelescope<CR>', { desc = 'Telescope' })
vim.api.nvim_set_keymap('n', 'gtt', '<cmd>TextCaseOpenTelescope<CR>', { desc = 'Telescope' })
vim.api.nvim_set_keymap('v', 'gt.', '<cmd>TextCaseOpenTelescope<CR>', { desc = 'Telescope' })
vim.api.nvim_set_keymap('n', 'gta', '<cmd>TextCaseOpenTelescopeQuickChange<CR>', { desc = 'Telescope Quick Change' })
vim.api.nvim_set_keymap('n', 'gti', '<cmd>TextCaseOpenTelescopeLSPChange<CR>', { desc = 'Telescope LSP Change' })

-- SMART REPLACE: Select block of text, then use "Subs"
-- '<,'>Subs/find text/replace text
-- StepOne              step-one
-- STEP_ONE   StepOne
-- step-one   step_one  step_one

-- Upper case    	 LOREM IPSUM 	 textcase.api.to_constant_case
-- Lower case    	 lorem ipsum 	 textcase.api.to_lower_case
-- Snake case    	 lorem_ipsum 	 textcase.api.to_snake_case
-- Dash case     	 lorem-ipsum 	 textcase.api.to_dash_case
-- Constant case 	 LOREM_IPSUM 	 textcase.api.to_constant_case
-- Dot case      	 lorem.ipsum 	 textcase.api.to_dot_case
-- Camel case    	 loremIpsum  	 textcase.api.to_camel_case
-- Pascal case   	 LoremIpsum  	 textcase.api.to_pascal_case
-- Title case    	 Lorem Ipsum 	 textcase.api.to_title_case
-- Path case     	 lorem/ipsum 	 textcase.api.to_path_case
-- Phrase case   	 Lorem ipsum 	 textcase.api.to_phrase_case

-- nnoremap gau :lua require('textcase').current_word('to_upper_case')<CR>
-- nnoremap gal :lua require('textcase').current_word('to_lower_case')<CR>
-- nnoremap gas :lua require('textcase').current_word('to_snake_case')<CR>
-- nnoremap gad :lua require('textcase').current_word('to_dash_case')<CR>
-- nnoremap gan :lua require('textcase').current_word('to_constant_case')<CR>
-- nnoremap gad :lua require('textcase').current_word('to_dot_case')<CR>
-- nnoremap gaa :lua require('textcase').current_word('to_phrase_case')<CR>
-- nnoremap gac :lua require('textcase').current_word('to_camel_case')<CR>
-- nnoremap gap :lua require('textcase').current_word('to_pascal_case')<CR>
-- nnoremap gat :lua require('textcase').current_word('to_title_case')<CR>
-- nnoremap gaf :lua require('textcase').current_word('to_path_case')<CR>

-- nnoremap gaU :lua require('textcase').lsp_rename('to_upper_case')<CR>
-- nnoremap gaL :lua require('textcase').lsp_rename('to_lower_case')<CR>
-- nnoremap gaS :lua require('textcase').lsp_rename('to_snake_case')<CR>
-- nnoremap gaD :lua require('textcase').lsp_rename('to_dash_case')<CR>
-- nnoremap gaN :lua require('textcase').lsp_rename('to_constant_case')<CR>
-- nnoremap gaD :lua require('textcase').lsp_rename('to_dot_case')<CR>
-- nnoremap gaA :lua require('textcase').lsp_rename('to_phrase_case')<CR>
-- nnoremap gaC :lua require('textcase').lsp_rename('to_camel_case')<CR>
-- nnoremap gaP :lua require('textcase').lsp_rename('to_pascal_case')<CR>
-- nnoremap gaT :lua require('textcase').lsp_rename('to_title_case')<CR>
-- nnoremap gaF :lua require('textcase').lsp_rename('to_path_case')<CR>

-- nnoremap geu :lua require('textcase').operator('to_upper_case')<CR>
-- nnoremap gel :lua require('textcase').operator('to_lower_case')<CR>
-- nnoremap ges :lua require('textcase').operator('to_snake_case')<CR>
-- nnoremap ged :lua require('textcase').operator('to_dash_case')<CR>
-- nnoremap gen :lua require('textcase').operator('to_constant_case')<CR>
-- nnoremap ged :lua require('textcase').operator('to_dot_case')<CR>
-- nnoremap gea :lua require('textcase').operator('to_phrase_case')<CR>
-- nnoremap gec :lua require('textcase').operator('to_camel_case')<CR>
-- nnoremap gep :lua require('textcase').operator('to_pascal_case')<CR>
-- nnoremap get :lua require('textcase').operator('to_title_case')<CR>
-- nnoremap gef :lua require('textcase').operator('to_path_case')<CR>
