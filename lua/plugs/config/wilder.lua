local ok, wilder = pcall(require, "wilder")
if not ok then return end

-- TODO: <Tab> should select first item if none selected
-- TODO: <C-S-P>/<C-S-N> should scroll through command history

wilder.setup(
  {
  -- enable_cmdline_enter = true,
  next_key = "<C-N>",
  previous_key = "<C-P>",
  modes = { ":", "/", "?" },
  accept_key = "<Tab>",
  reject_key = "<S-Tab>"
  -- accept_key = '<Down>',
  -- reject_key = '<Up>',
}
)
vim.cmd(
[[

function! WilderPageDown()
  call wilder#next()
  call wilder#next()
  call wilder#next()
  call wilder#next()
  call wilder#next()
endfunction

function! WilderPageUp()
  call wilder#previous()
  call wilder#previous()
  call wilder#previous()
  call wilder#previous()
  call wilder#previous()
endfunction

cmap <expr> <C-f> wilder#in_context() ? WilderPageDown() : "\<C-f>"
cmap <expr> <C-b> wilder#in_context() ? WilderPageUp() : "\<C-b>"
" cmap <expr> <C-b> wilder#in_context() ? wilder#previous() : "\<C-b>"
" cmap <expr> <C-f> wilder#in_context() ? wilder#next() : "\<C-f>"
]]
)

wilder.set_option(
  "pipeline",
  {
  wilder.branch(
    wilder.cmdline_pipeline(
      {
      fuzzy = 1,
      fuzzy_filter = wilder.lua_fzy_filter()

      -- language = "vim",
      -- fuzzy = 1,
      -- fuzzy_filter = wilder.vim_fuzzy_filter

      -- language = "python",
      -- fuzzy = 2,
      -- fuzzy_filter = wilder.python_fuzzy_pattern()
    }
    ),
    wilder.vim_search_pipeline()
  -- wilder.python_search_pipeline( { pattern = 'fuzzy' })
  )
}
)

-- wilder.set_option(
--   "pipeline",
--   {
--     wilder.branch(
--       wilder.python_file_finder_pipeline(
--         {
--           file_command = function(ctx, arg)
--             if string.find(arg, ".") ~= nil then
--               return {"fd", "-tf", "-H"}
--             else
--               return {"fd", "-tf"}
--             end
--           end,
--           dir_command = {"fd", "-td"}
--           -- Requires cpsm from nixprime/cpsm
--           -- filters = {"cpsm_filter"}
--         }
--       ),
--       wilder.cmdline_pipeline(
--         {
--           fuzzy = 2,
--           fuzzy_filter = wilder.lua_fzy_filter()
--         }
--       ),
--       {
--         wilder.check(
--           function(ctx, x)
--             return x == ""
--           end
--         ),
--         wilder.history()
--       },
--       wilder.python_search_pipeline(
--         {
--           pattern = wilder.python_fuzzy_pattern(
--             {
--               start_at_boundary = 0
--             }
--           )
--         }
--       )
--     )
--   }
-- )

local highlighters = {
  -- wilder.basic_highlighter()
  -- wilder.pcre2_highlighter(),
  wilder.lua_fzy_highlighter()
}

local popupmenu_renderer =
wilder.popupmenu_renderer(
  wilder.popupmenu_border_theme(
    {
    -- empty_message = wilder.popupmenu_empty_message_with_spinner(),
    border = { '╭', '─', '╮',
      '│', '│',
      '│', '', '│' },
    highlighter = highlighters,
    left = {
      " ",
      wilder.popupmenu_devicons()
      -- wilder.popupmenu_buffer_flags(
      --   {
      --     flags = " a + ",
      --     icons = {["+"] = "", a = "", h = ""}
      --   }
      -- )
    },
    right = {
      " ",
      wilder.popupmenu_scrollbar({
        -- thumb_hl = 'PmenuThumb',
        scrollbar_hl = 'PmenuSbar',
        thumb_hl = 'Comment',
        -- Pmenu { fg = "#618cc4", bg = "#090918" },
        -- PmenuSel { fg = "#74efff", bg = "#1a1f2f" },
        -- PmenuSbar { fg = "#717cb4", bg = "#202331" },
        -- PmenuThumb { fg = "#8f93a2", bg = "#84ffff" },
      })
    },
    highlights = {
      border = 'Comment', -- FloatBoarder
      accent = wilder.make_hl("WilderAccent", "Pmenu", { { a = 1 }, { a = 1 }, { foreground = "#f4468f" } })
      -- `default` The default highlight group. - StatusLine
      -- `selected` The highlight group used for a selected candidate. - WildMenu
      -- `error` The highlight group used for the error message. - ErrorMsg
      -- `separator` The highlight group used for the separators.
      -- `accent` The highlight group used for accents. See the `highlighter` option.
      -- `selected_accent` The highlight group used for accents for a selected candidate.
      -- WildMenu, WilderWildmenuSelectedAccent, WilderWildmenuAccent,
      -- WilderPopupMenuSelectedAccent, WilderPopupMenuAccent, WilderAccent
      -- call wilder#set_option('renderer', wilder#popupmenu_renderer(
      --   \ wilder#popupmenu_border_theme({
      --     \   'highlights': {'border': 'FloatBorder'},
      --     \ })))

    }
  }
  )
)

local palette_renderer =
wilder.popupmenu_renderer(
  wilder.popupmenu_palette_theme(
    {
    -- 'single', 'double', 'rounded' or 'solid'
    -- can also be a list of 8 characters, see :h wilder#popupmenu_palette_theme() for more details
    border = "rounded",
    max_height = "75%", -- max height of the palette
    min_height = 0, -- set to the same as 'max_height' for a fixed height window
    prompt_position = "top", -- 'top' or 'bottom' to set the location of the prompt
    reverse = 0 -- set to 1 to reverse the order of the list, use in combination with 'prompt_position'
  }
  )
)

local wildmenu_renderer =
wilder.wildmenu_renderer(
  {
  highlighter = highlighters,
  separator = " · ",
  left = { " ", wilder.wildmenu_spinner(), " " },
  right = { " ", wilder.wildmenu_index() }
}
)

wilder.set_option(
  "renderer",
  wilder.renderer_mux(
    {
    [":"] = popupmenu_renderer,
    -- ["/"] = popupmenu_renderer
    -- substitute = popupmenu_renderer
  }
  )
)

-- wilder.set_option('pipeline', {
--   wilder.branch(
--     wilder.cmdline_pipeline({
--       fuzzy = 1,
--       fuzzy_filter = wilder.lua_fzy_filter(),
--     }),
--     wilder.vim_search_pipeline()
--   )
-- })

-- wilder.set_option('renderer', wilder.renderer_mux({
--   [':'] = wilder.popupmenu_renderer({
--     highlighter = wilder.lua_fzy_highlighter(),
--     left = {
--       ' ',
--       wilder.popupmenu_devicons()
--     },
--     right = {
--       ' ',
--       wilder.popupmenu_scrollbar()
--     },
--   }),
--   ['/'] = wilder.wildmenu_renderer({
--     highlighter = wilder.lua_fzy_highlighter(),
--   }),
-- }))

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
