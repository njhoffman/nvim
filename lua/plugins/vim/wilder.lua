vim.cmd("source " .. vim.fn.stdpath "config" .. "/lua/plugins/vim/wilder.vim")

-- local is_plugin_installed = require"helpers".is_plugin_installed
-- local nvim_exec = vim.api.nvim_exec
-- if not is_plugin_installed("wilder.nvim") then return end

-- nvim_exec([[
--   call wilder#enable_cmdline_enter()
--   set wildcharm=<Tab>
--    cmap <expr> <Tab> wilder#in_context() ? wilder#next() : "\<Tab>"
--    cmap <expr> <S-Tab> wilder#in_context() ? wilder#previous() : "\<S-Tab>"
--   " cmap <expr> <C-n> wilder#in_context() ? wilder#next() : "\<C-n>"
--   " cmap <expr> <C-p> wilder#in_context() ? wilder#previous() : "\<C-p>"
--   " only / and ? are enabled by default
--   call wilder#set_option('modes', ['/', '?', ':', 'substitute'])
-- ]], false)

-- if is_plugin_installed("vim-devicons") then
--   nvim_exec([[
--   " popup menu
--   " call wilder#set_option('renderer', wilder#popupmenu_renderer({ 'highlighter': wilder#basic_highlighter(), 'left': [ wilder#popupmenu_devicons() ] }))
--   call wilder#set_option('renderer', wilder#popupmenu_renderer({ 'highlighter': wilder#basic_highlighter(), 'left': [ wilder#popupmenu_devicons({ 'get_icoN': wilder#devicons_get_icon_from_nvim_web_devicons() }) ] }))
--   " history pipeline
--   call wilder#set_option('pipeline', [ wilder#branch([ wilder#check({_, x -> empty(x)}), wilder#history(), wilder#result({ 'draw': [{_, x -> '  ' . x}] }) ], wilder#cmdline_pipeline(), wilder#search_pipeline()) ])
--   ]], false)
-- else
--   nvim_exec([[
--   " popup menu
--   call wilder#set_option('renderer', wilder#popupmenu_renderer({ 'highlighter': wilder#basic_highlighter() }))
--   " history pipeline
--   call wilder#set_option('pipeline', [ wilder#branch([ wilder#check({ _, x -> empty(x) }), wilder#history() ], wilder#cmdline_pipeline(), wilder#search_pipeline()) ])
--   ]], false)
-- end

-- function _G.check_back_space()
--   local col = vim.api.nvim_win_get_cursor(0)[2]
--   return (col == 0 or vim.api.nvim_get_current_line():sub(col, col):match("%s")) and true
-- end

-- local function t(str) return vim.api.nvim_replace_termcodes(str, true, true, true) end

-- function _G.smart_tab() return vim.fn.pumvisible() == 1 and t "<C-n>" or t "<Tab>" end

-- vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.smart_tab()", { expr = true, noremap = true })

-- vim.api.nvim_set_keymap("c", "<C-n>", "<Tab>", { expr = true, noremap = true })
-- vim.api.nvim_set_keymap("c", "<C-p>", "<S-Tab>", { expr = true, noremap = true })

-- " How about a nice statusline?
-- lua << EOF
-- function _G.statusline()
--     local filepath = '%f'
--     local align_section = '%='
--     local percentage_through_file = '%p%%'
--     return string.format(
--         '%s%s%s',
--         filepath,
--         align_section,
--         percentage_through_file
--     )
-- end
-- EOF

-- set statusline=%!v:lua.statusline()
-- nvim_exec([[
-- inoremap <silent> <expr> <Tab>
--     \ pumvisible() ? "\<C-n>" :
--     \ v:lua.check_back_space() ? "\<Tab>" :
--     \ completion#trigger_completion()
-- ]], false)

-- vim.cmd("source " .. vim.fn.stdpath "config" .. "/lua/nvim-wilder/wild.vim")

-- vim.call("wilder#enable_cmdline_enter")
-- vim.fn["wilder#set_option"]("modes", { "/", "?", ":" })
-- vim.cmd [[set wildcharm=<Tab>]]
-- vim.cmd [[cmap <expr> <Tab> wilder#in_context() ? wilder#next() : "\<Tab>"]]
-- vim.cmd [[cmap <expr> <S-Tab> wilder#in_context() ? wilder#previous() : "\<S-Tab>"]]

-- -- local highlighters = vim.fn["wilder#basic_highlighter"]()
-- local highlighters = { vim.fn["wilder#pcre2_highlighter"](), vim.fn["wilder#basic_highlighter"]() }

-- vim.fn["wilder#set_option"]("pipeline", {
--   vim.fn["wilder#branch"](vim.fn["wilder#cmdline_pipeline"](), vim.fn["wilder#search_pipeline"]()),
-- })

-- vim.fn["wilder#set_option"]("renderer", vim.fn["wilder#wildmenu_renderer"]({ highlighter = highlighters }))

-- -- vim.fn["wilder#set_option"]("pipeline", {
-- --   vim.fn["wilder#branch"](vim.fn["wilder#cmdline_pipeline"]({ fuzzy = 1 }),
-- --                           vim.fn["wilder#search_pipeline"]({ pattern = "fuzzy" })),
-- -- })

-- -- call wilder#set_option('pipeline', [
-- --       \   wilder#branch(
-- --       \     wilder#cmdline_pipeline(),
-- --       \     wilder#search_pipeline(),
-- --       \   ),
-- --       \ ])

-- -- vim.fn["wilder#set_option"]("renderer", vim.fn["wilder#renderer_mux"]({
-- --   ":" = vim.fn["wilder#popupmenu_renderer"]{ highlighter = highlighters },
-- --   "/" = vim.fn["wilder#wildmenu_renderer"]{ highlighter = highlighters }
-- -- }))

-- -- vim.cmd [=[
-- --    call wilder#set_option('pipeline', [
-- --         \   wilder#branch(
-- --         \     wilder#python_file_finder_pipeline({
-- --         \       'file_command': {_, arg -> stridx(arg, '.') != -1 ? ['fd', '-tf', '-H'] : ['fd', '-tf']},
-- --         \       'dir_command': ['fdfind', '-td'],
-- --         \       'filters': ['cpsm_filter'],
-- --         \       'cache_timestamp': {-> 1},
-- --         \     }),
-- --         \     wilder#cmdline_pipeline({
-- --         \       'fuzzy': 1,
-- --         \       'fuzzy_filter': wilder#python_cpsm_filter(),
-- --         \       'set_pcre2_pattern': 0,
-- --         \     }),
-- --         \     wilder#python_search_pipeline({
-- --         \       'pattern': wilder#python_fuzzy_pattern({
-- --         \         'start_at_boundary': 0,
-- --         \       }),
-- --         \     }),
-- --         \   ),
-- --         \ ])
-- -- ]=]

-- 		:set wildmode=full
-- <	Complete first full match, next match, etc.  (the default) >
-- 		:set wildmode=longest,full
-- <	Complete longest common string, then each full match >
-- 		:set wildmode=list:full
-- <	List all matches and complete each full match >
-- 		:set wildmode=list,full
-- <	List all matches without completing, then each full match >
-- 		:set wildmode=longest,list
-- <	Complete longest common string, then list alternatives.
-- 	Examples: >
-- 		:set wildmode=full
-- <	Complete first full match, next match, etc.  (the default) >
-- 		:set wildmode=longest,full
-- <	Complete longest common string, then each full match >
-- 		:set wildmode=list:full
-- <	List all matches and complete each full match >
-- 		:set wildmode=list,full
-- <	List all matches without completing, then each full match >
-- 		:set wildmode=longest,list
-- <	Complete longest common string, then list alternatives.
