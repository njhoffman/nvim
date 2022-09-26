local cmp = require("cmp")

local cmp_mappings = require("plugins.config.nvim-cmp-mapping")
local compare = require("cmp.config.compare")
local types = require("cmp.types")
local sources = require("plugins.config.nvim-cmp-sources")

local sort_under = function(entry1, entry2)
  local _, entry1_under = entry1.completion_item.label:find("^_+")
  local _, entry2_under = entry2.completion_item.label:find("^_+")
  entry1_under = entry1_under or 0
  entry2_under = entry2_under or 0
  if entry1_under > entry2_under then
    return false
  elseif entry1_under < entry2_under then
    return true
  end
end

-- TODO: filetype specific spelling
-- vim.opt.spell = true
-- vim.opt.spelllang = { 'en_us' }
vim.opt.dictionary:append("/usr/share/dict/words")

local cmp_helper = {
  -- Deprioritize items starting with underscores (private or protected)
  deprioritize_underscore = function(lhs, rhs)
    local l = (lhs.completion_item.label:find("^_+")) and 1 or 0
    local r = (rhs.completion_item.label:find("^_+")) and 1 or 0
    if l ~= r then
      return l < r
    end
  end,
  -- Prioritize items that ends with "= ..." (usually for argument completion).
  prioritize_argument = function(lhs, rhs)
    local l = (lhs.completion_item.label:find("=$")) and 1 or 0
    local r = (rhs.completion_item.label:find("=$")) and 1 or 0
    if l ~= r then
      return l > r
    end
  end,
}

local setupConfig = {
  enabled = function()
    -- disable inside comments and telescope window
    local in_prompt = vim.api.nvim_buf_get_option(0, "buftype") == "prompt"
    if in_prompt then
      return false
    end
    local context = require("cmp.config.context")
    return not (context.in_treesitter_capture("comment") == true or context.in_syntax_group("Comment"))
  end,
  experimental = {
    native_menu = false,
    ghost_text = true,
  },
  -- preselect = types.cmp.PreselectMode.None, -- cmp.PreselectMode.None/Item,
  preselect = types.cmp.PreselectMode.Item, -- cmp.PreselectMode.None/Item,
  completion = {
    get_trigger_characters = function(trigger_characters)
      local new_trigger_characters = {}
      for _, char in ipairs(trigger_characters) do
        if char ~= ">" then
          table.insert(new_trigger_characters, char)
        end
      end
      return new_trigger_characters
    end,
  },
  -- completion = {
  --   -- completeopt = "menu,menuone,noinsert", --noinsert,noselect
  --   keyword_length = 1,
  --   autocomplete = {
  --     types.cmp.TriggerEvent.TextChanged,
  --   },
  -- },
  mapping = cmp.mapping.preset.insert(cmp_mappings()),
  view = {
    entries = {
      name = "custom", -- can be "custom", "wildmenu" or "native"
      selection_order = "top_down", -- near_cursor, top_down
    },
  },
  window = {
    documentation = cmp.config.window.bordered({
      winhighlight = "Normal:Normal,FloatBorder:Comment,CursorLine:Visual,Search:None",
      --   max_height = math.floor(WIDE_HEIGHT * (WIDE_HEIGHT / vim.o.lines)),
      --   max_width = math.floor((WIDE_HEIGHT * 2) * (vim.o.columns / (WIDE_HEIGHT * 2 * 16 / 9))),
    }),
    completion = cmp.config.window.bordered({
      --   border = { '┌', '─', '┐', '│', '┘', '─', '└', '│' },
      --   winhighlight = 'Normal:CmpPmenu,FloatBorder:CmpPmenuBorder,CursorLine:PmenuSel,Search:None',
      winhighlight = "Normal:Normal,FloatBorder:Comment,CursorLine:Visual,Search:None",
      -- max_width = 80,
    }),
  },
  formatting = {
    fields = { "kind", "abbr", "menu" },
    -- offset, exact, score, recently_used, locality, kind, sort_text, length, order
    format = function(entry, vim_item)
      local max_len = 50
      if string.len(vim_item.abbr) > max_len then
        vim_item.abbr = string.sub(vim_item.abbr, 1, max_len - 2) .. "··"
      end
      vim_item.dup = ({
        nvim_lua = 0,
      })[entry.source.name] or 1
      vim_item.menu = sources.names[entry.source.name]
      vim_item.kind = sources.symbols[vim_item.kind]
      return vim_item
    end,
  },
  sorting = {
    priority_weight = 2,
    comparators = {
      compare.offset,
      compare.exact,
      compare.score,
      require("cmp_fuzzy_path.compare"),
      require("cmp_fuzzy_buffer.compare"),
      sort_under,
      function(...)
        return cmp_helper.prioritize_argument(...)
      end,
      compare.recently_used,
      compare.kind,
      compare.sort_text,
      compare.length,
      compare.order,
    },
  },
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  -- {
  --   name           = "treesitter",
  --   priority       = 3,
  --   keyword_length = 3,
  --   max_item_count = 10,
  --   -- keyword_pattern = [[\k\+]],
  --   -- keyword_pattern = [[\!\@<!\w*]]
  --   -- keyword_pattern = [=[[^[:blank:]].*]=],
  --   get_bufnrs     = function()
  --     return { vim.api.nvim_get_current_buf() }
  --   end
  -- },
  sources = cmp.config.sources(sources.definitions),
}

cmp.setup(setupConfig)

-- Set configuration for specific filetype.
cmp.setup.filetype("gitcommit", {
  sources = cmp.config.sources({
    { name = "git" }, -- You can specify the `cmp_git` source if you were installed it.
  }, {
    { name = "fuzzy_buffer" },
  }),
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline("/", {
  mapping = cmp.mapping.preset.cmdline(cmp_mappings()),
  sources = cmp.config.sources({
    { name = "cmdline_history" },
    { name = "nvim_lsp_document_symbol" },
    { name = "fuzzy_buffer" },
    -- { name = "buffer", option = { keyword_pattern = [=[[^[:blank:]].*]=] } },
  }),
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(cmp_mappings()),
  sources = cmp.config.sources({
    { name = "cmdline", priority = 100 },
    { name = "cmdline_history", priority = 50 },
    { name = "fuzzy_path", priority = 30 },
  }),
})

cmp.setup.filetype({ "markdown", "help" }, {
  window = {
    documentation = cmp.config.disable,
  },
})

-- for _, cmd_type in ipairs({':', '/', '?', '@'}) do
--   cmp.setup.cmdline(cmd_type, {
--     sources = {
--       { name = 'cmdline_history' },
--     },
--   })
-- end
-- vim.cmd([[
--   augroup NvimCmp
--   au!
--   au FileType TelescopePrompt lua require('cmp').setup.buffer { enabled = false }
--   augroup END
-- ]])

return cmp
