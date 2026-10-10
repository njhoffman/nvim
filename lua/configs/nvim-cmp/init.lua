local cmp = require("cmp")
local types = require("cmp.types")

local WIN_HIGHLIGHT =
  "Normal:CmpNormal,FloatBorder:CmpFloatBorder,CursorLine:CmpCursorLine,Search:None"

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

local is_enabled = function()
  local disabled = { IncRename = true }
  local neostate = package.loaded["neocodeium"] and package.loaded["neocodeium.state"]
  if neostate and neostate.active then
    return false
  end
  local cmd = vim.fn.getcmdline():match("%S+")
  return is_not_comment()
      and is_not_buftype()
      and is_not_filetype()
      and vim.fn.reg_recording() == ""
      and vim.fn.reg_executing() == ""
      and not disabled[cmd]
    or cmp.close()
end

local cfg = {
  preselect = types.cmp.PreselectMode.Item,
  autocomplete = {
    cmp.TriggerEvent.TextChanged,
    cmp.TriggerEvent.InsertEnter,
  },
  enabled = is_enabled,

  --stylua: ignore start
  performance = {
    debounce                = 60,
    throttle                = 30,
    filtering_context_budget = 3,
    confirm_resolve_timeout = 80,
    max_view_entries        = 400,
    async_budget            = 1,
    fetching_timeout        = 500,
    trigger_debounce        = 50,
  },
  matching = {},
  completion = {
    keyword_length = 0,
    completeopt = 'menu,menuone,noinsert,noselect',
  },
  sorting = sorting,
  formatting = formatting,
  window = {
    completion = cmp.config.window.bordered({
      border = { "", "", "", "│", "╯", "─", "╰", "│" },
      winhighlight = WIN_HIGHLIGHT,
      scrollbar = true,
      winblend = 10,
      col_offset = -3,
      side_padding = 0,
    }),
    documentation = cmp.config.window.bordered({
      winhighlight = WIN_HIGHLIGHT,
      border = 'rounded',
      scrollbar = true,
      winblend = 10,
    }),
  },
  confirm_opts = {
    behavior = cmp.ConfirmBehavior.Replace,
    select = true,
  },
  mapping = cmp.mapping.preset.insert(mapping_main),
  sources = cmp.config.sources(sources.main[1], sources.main[2], sources.main[3], sources.filetypes),
  view = {
    entries = {
      name = 'custom',
      selection_order = "near_cursor",
      vertical_positioning = "auto",
      follow_cursor = true,
    },
    docs = { auto_open = true, },
  },
  confirmation = { default_behavior = cmp.ConfirmBehavior.Replace },
}

cmp.setup(cfg)

cmp.setup.cmdline(":", {
  mapping = mapping_cmdline,
  sources = cmp.config.sources(sources.cmdline[1], sources.cmdline[2]),
  window = {
    completion = cmp.config.window.bordered({
      border = { "", "", "", "│", "╯", "─", "╰", "│" },
      winhighlight = WIN_HIGHLIGHT,
      scrollbar = true,
      winblend = 10,
      col_offset = -3,
      side_padding = 0,
      top_padding = 1,
    }),
  },
})

cmp.setup.cmdline({ "/", "?" }, {
  enabled = true,
  mapping = mapping_cmdline,
  sources = cmp.config.sources(sources.cmdsearch),
})

-- disable annoying --#region suggestions in lua buffers
cmp.setup.filetype("lua", {
  enabled = function()
    local line = vim.api.nvim_get_current_line()
    return is_enabled() and not (line:find("%s%-%-?$") or line:find("^%-%-?$"))
  end,
})

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

local pairs_integration = function()
  local kind = cmp.lsp.CompletionItemKind

  local function ls_name_from_event(event)
    return event.entry.source.source.client.config.name
  end

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
