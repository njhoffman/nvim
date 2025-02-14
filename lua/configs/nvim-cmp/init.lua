local cmp = require("cmp")
local types = require("cmp.types")

local debug_flag = false
local WIDE_HEIGHT = 60
local WIN_HIGHLIGHT =
  "Normal:CmpNormal,FloatBorder:CmpFloatBorder,CursorLine:CmpCursorLine,Search:None"
-- winhighlight = table.concat({
--   "Normal:Normal",
--   "FloatBorder:SuggestWidgetBorder",
--   "CursorLine:Normal",
--   "Search:None", --[[ , ]]
-- }, ","),

local sources = require("configs.nvim-cmp.sources")
local mapping_cmdline = require("configs.nvim-cmp.keys-cmd")
local mapping_main = require("configs.nvim-cmp.keys-main")
local formatting = require("configs.nvim-cmp.formatting")
local sorting = require("configs.nvim-cmp.sorting")

require("configs.nvim-cmp.icons").setup_highlights()

local is_not_comment = function()
  local context = require("cmp.config.context")
  return not context.in_treesitter_capture("comment") and not context.in_syntax_group("Comment")
end

local is_not_buftype = function()
  local prompt = vim.bo.buftype == "prompt"
  return not prompt
end

local is_not_filetype = function()
  local ft = vim.bo.filetype
  local exclude_ft = {
    "neorepl",
    "neoai-input",
  }
  for _, v in pairs(exclude_ft) do
    if ft == v then
      return false
    end
  end
  return true
end

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0
    and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local is_not_luasnip = function()
  ---@diagnostic disable-next-line: param-type-mismatch
  return not vim.fn.expand("%:p"):find(".*/nvim/lua/snippets/.*%.lua")
end

local is_enabled = function()
  local disabled = {
    IncRename = true,
  }

  -- enabled = function()
  -- local buftype = vim.bo.buftype
  --
  -- if buftype == 'prompt' or buftype == 'nofile' then
  -- return false
  -- end
  --
  -- return true
  -- end
  -- Get first word of cmdline
  local cmd = vim.fn.getcmdline():match("%S+")
  -- Return true if cmd isn't disabled else call/return cmp.close(), which returns false
  return is_not_comment()
      and is_not_buftype()
      and is_not_filetype()
      and is_not_luasnip()
      and vim.fn.reg_recording() == ""
      and vim.fn.reg_executing() == ""
      and not disabled[cmd]
    or cmp.close()
end

local cfg = {
  preselect = types.cmp.PreselectMode.Item,
  -- preselect = cmp.PreselectMode.None,
  autocomplete = {
    cmp.TriggerEvent.TextChanged,
    cmp.TriggerEvent.InsertEnter,
  },
  enabled = is_enabled,

  --stylua: ignore start
  performance = {
    debounce                = 60, --60  This is the interval used to group up completions from different sources for filtering and displaying.
    throttle                = 30, --30 This is used to delay filtering and displaying completions.
    filtering_context_budget = 3,
    confirm_resolve_timeout = 80,
    max_view_entries        = 400,
    async_budget            = 1,
    fetching_timeout        = 500,
    trigger_debounce        = 300,
  },
  matching = {
    -- disallow_fuzzy_matching = false,
    -- disallow_fullfuzzy_matching = false,
    -- disallow_partial_fuzzy_matching = true,
    -- disallow_partial_matching = false,
    -- disallow_prefix_unmatching = false,
    -- disallow_symbol_nonprefix_matching = true,
  },
  completion = {
    keyword_length = 0,
    -- keyword_pattern = [[\%(-\?\d\+\%(\.\d\+\)\?\|\h\w*\%(-\w*\)*\)]],
    completeopt = 'menu,menuone,noinsert,noselect',
    -- completeopt = "menuone,noselect,preview", -- menu, menuone,noselect
    -- completeopt = 'menuone,preview,noselect,noinsert',
  },
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  sorting = sorting,
  -- experimental = { ghost_text = { hl_group = 'CmpGhostText', }, },
  formatting = formatting,
  window = {
    completion = cmp.config.window.bordered({
      winhighlight = WIN_HIGHLIGHT,
      scrollbar = true,
      winblend = 10,
      col_offset = -3,
      side_padding = 0,
    }),
    documentation = cmp.config.window.bordered({
      max_height = math.floor(WIDE_HEIGHT * (WIDE_HEIGHT / vim.o.lines)),
        max_width = math.floor((WIDE_HEIGHT * 2) * (vim.o.columns / (WIDE_HEIGHT * 2 * 16 / 9))),
      winhighlight = WIN_HIGHLIGHT,
      scrollbar = true,
      winblend = 10,
    }),
  },
  confirm_opts = {
    behavior = cmp.ConfirmBehavior.Replace,
    select = true,
  },
  mapping = cmp.mapping.preset.insert(mapping_main), --mapping_main,
  sources = cmp.config.sources(sources.main[1], sources.main[2]),
  view = {
    entries = {
      name = 'custom',
      selection_order = "near_cursor",
      vertical_positioning = "auto", -- above, below, auto
      follow_cursor = false,
    },
    docs = {
      auto_open = true,
    },
  },
  confirmation = { default_behavior = cmp.ConfirmBehavior.Replace },
}

-- local setup_cmp = function()
-- local debug = require('cmp.utils.debug')
-- local log = function(...)
--   if debug_flag then
--     local data = {}
--     for _, v in ipairs({ ... }) do
--       if not vim.tbl_contains({ 'string', 'number', 'boolean' }, type(v)) then
--         v = vim.inspect(v)
--       end
--       table.insert(data, v)
--     end
--   end
-- end
-- vim.tbl_deep_extend('force', debug, { log = log })

cmp.setup(cfg)

cmp.setup.cmdline(":", {
  -- completion = { autocomplete = false },
  -- matching = { disallow_symbol_nonprefix_matching = false },
  mapping = mapping_cmdline,
  -- mapping = cmp.mapping.preset.cmdline(),
  -- mapping = cmp.mapping.preset.cmdline(mapping_cmdline),
  sources = cmp.config.sources(sources.cmdline[1], sources.cmdline[2]),
  -- enabled = function()
  --   -- Set of commands where cmp will be disabled
  --   local disabled = { IncRename = true }
  --   -- Get first word of cmdline
  --   local cmd = vim.fn.getcmdline():match("%S+")
  --   -- Return true if cmd isn't disabled
  --   -- else call/return cmp.close(), which returns false
  --   return not disabled[cmd] or cmp.close()
  -- end,
})
-- cmp.setup.cmdline(':', {
--   sources = cmp.config.sources({
--     { name = 'path' }
--   }, {
--       {
--         name = 'cmdline',
--         option = {
--           ignore_cmds = { 'Man', '!' }
--         }
--       }
--     })
-- })

cmp.setup.cmdline({ "/", "?" }, {
  -- completion = { autocomplete = false },
  enabled = true,
  mapping = mapping_cmdline,
  -- matching = { disallow_symbol_nonprefix_matching = false },
  -- mapping = cmp.mapping.preset.cmdline(mapping_sets),
  -- mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources(sources.cmdsearch),
})

-- cmp.setup.filetype('gitcommit', { sources = cmp.config.sources(sources.gitcommit) })
-- local defaultPlusZsh = vim.deepcopy(sources.main)
-- table.insert(defaultPlusZsh, { name = 'zsh' })
-- cmp.setup.filetype({ 'sh', 'make' }, {
--   sources = cmp.config.sources(defaultPlusZsh),
--   -- disable useless `\[` suggestions at end of line
--   enabled = function()
--     local col = vim.fn.col('.') - 1
--     local charBefore = vim.api.nvim_get_current_line():sub(col, col)
--     return charBefore ~= '\\'
--   end,
-- })
--
-- LUA
-- disable annoying --#region suggestions
cmp.setup.filetype("lua", {
  enabled = function()
    local line = vim.api.nvim_get_current_line()
    return is_enabled() and not (line:find("%s%-%-?$") or line:find("^%-%-?$"))
  end,
})
-- cmp.setup.cmdline(':', {
--   mapping = cmp.mapping.preset.cmdline(),
--   sources = cmp.config.sources({
--     { name = 'path' },
--   }, {
--     { name = 'cmdline_history' },
--     {
--       name = 'cmdline',
--       option = {
--         ignore_cmds = { 'Man', '!' },
--       },
--     },
--   }),
-- })
-- cmp.setup.cmdline('/', {
--   mapping = cmp.mapping.preset.cmdline(),
--   sources = {
--     { name = 'buffer' },
--     -- { name = 'cmdline_history' },
--     -- { name = 'rg', keyword_length = 4 },  -- slow
--     {
--       name = 'fuzzy_buffer',
--       option = { max_matches = 5, max_buffer_lines = 4000, min_match_length = 4 },
--     },
--   },
-- })

local function toggle_autocomplete()
  local current_setting = cmp.get_config().completion.autocomplete
  if current_setting and #current_setting > 0 then
    cmp.setup({ completion = { autocomplete = false } })
    vim.notify("Autocomplete disabled")
  else
    cmp.setup({ completion = { autocomplete = { cmp.TriggerEvent.TextChanged } } })
    vim.notify("Autocomplete enabled")
  end
end

vim.api.nvim_create_user_command(
  "CmpToggle",
  toggle_autocomplete,
  { desc = "Toggle nvim-cmp autocomplete" }
)
-- cmp.event:on('menu_opened', function(event)
--   local win = event.window.entries_win
-- end)

local pairs_integration = function()
  local kind = cmp.lsp.CompletionItemKind

  local function ls_name_from_event(event)
    return event.entry.source.source.client.config.name
  end

  -- Add parenthesis on completion confirmation
  cmp.event:on("confirm_done", function(event)
    local ok, ls_name = pcall(ls_name_from_event, event)
    local server_blacklist = { "rust-analyzer", "lua_ls", "typst_lsp" }
    if ok and vim.tbl_contains(server_blacklist, ls_name) then
      return
    end

    local completion_kind = event.entry:get_completion_item().kind
    if vim.tbl_contains({ kind.Function, kind.Method }, completion_kind) then
      local left = vim.api.nvim_replace_termcodes("<Left>", true, true, true)
      vim.api.nvim_feedkeys("()" .. left, "n", false)
    end
  end)
end

pairs_integration()

-- only appear if characters before cursor
-- api.nvim_create_autocmd(
--   {"TextChangedI", "TextChangedP"},
--   {
--     callback = function()
--       local line = vim.api.nvim_get_current_line()
--       local cursor = vim.api.nvim_win_get_cursor(0)[2]
--
--       local current = string.sub(line, cursor, cursor + 1)
--       if current == "." or current == "," or current == " " then
--         require('cmp').close()
--       end
--
--       local before_line = string.sub(line, 1, cursor + 1)
--       local after_line = string.sub(line, cursor + 1, -1)
--       if not string.match(before_line, '^%s+$') then
--         if after_line == "" or string.match(before_line, " $") or string.match(before_line, "%.$") then
--           require('cmp').complete()
--         end
--       end
--   end,
--   pattern = "*"
-- })
