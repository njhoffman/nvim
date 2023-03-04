local cmp = require("cmp")
-- local cmp_mappings = require("plugs.config.nvim-cmp-mapping")
local compare = require("cmp.config.compare")
local feedkeys = require("cmp.utils.feedkeys")
local keymap = require("cmp.utils.keymap")

local sources = require("plugs.config.nvim-cmp.sources")

local ELLIPSIS_CHAR = "…"
local MAX_LABEL_WIDTH = 30
local MIN_LABEL_WIDTH = 20

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
local has_words_before = function(cmdline)
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  if cmdline then
    col = col + 1
  end
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local setupConfig = {
  experimental = {
    native_menu = false,
    ghost_text = {
      hl_group = "CmpGhostText",
    },
  },
  -- preselect = cmp.types.cmp.PreselectMode.Item, -- cmp.PreselectMode.None/Item,
  completion = {
    -- completeopt = "noinsert,noselect",
    completeopt = "menu,menuone,noselect", --noinsert,noselect
    -- get_trigger_characters = function(trigger_characters)
    --   local new_trigger_characters = {}
    --   for _, char in ipairs(trigger_characters) do
    --     if char ~= ">" then
    --       table.insert(new_trigger_characters, char)
    --     end
    --   end
    --   return new_trigger_characters
    -- end,
    -- keyword_length = 1,
    -- autocomplete = {
    --   cmp.types.cmp.TriggerEvent.TextChanged,
    --  },
  },
  enabled = function()
    local in_prompt = vim.api.nvim_buf_get_option(0, "buftype") == "prompt"
    if in_prompt then -- this will disable cmp in the Telescope window (taken from the default config)
      return false
    end
    local context = require("cmp.config.context")
    local in_parameter = context.in_treesitter_capture("punctuation.bracket") == true
      or context.in_syntax_group("luaParen")
    local in_comment = context.in_treesitter_capture("comment") == true or context.in_syntax_group("Comment")
    return not (in_comment or in_parameter)
  end,
  mapping = cmp.mapping.preset.insert({
    ["<C-x><C-o>"] = cmp.mapping.complete({}),
    ["<C-x><C-s>"] = cmp.mapping.complete({
      config = {
        sources = {
          {
            name = "luasnip",
          },
        },
      },
    }),
    ["<C-p>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item({
          behavior = cmp.SelectBehavior.Insert,
        })
      else
        -- fallback()
        cmp.complete()
      end
    end, {
      "i",
    }),
    ["<C-n>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item({
          behavior = cmp.SelectBehavior.Insert,
        })
      else
        cmp.complete()
        -- fallback()
      end
    end, {
      "i",
    }),
    ["<C-f>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        for _ = 1, 5 do
          cmp.mapping.select_next_item({
            behavior = cmp.SelectBehavior.Select,
          })(nil)
        end
      end
    end, {
      "i",
    }),
    ["<C-B>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        for _ = 1, 5 do
          cmp.mapping.select_prev_item({
            behavior = cmp.SelectBehavior.Select,
          })(nil)
        end
      end
    end, {
      "i",
    }),
    ["<Down>"] = cmp.mapping(cmp.mapping.scroll_docs(1), {
      "i",
    }),
    ["<Up>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), {
      "i",
    }),
    ["<C-D>"] = cmp.mapping(cmp.mapping.abort(), {
      "i",
    }),
  }),
  view = {
    entries = {
      name = "custom", -- can be "custom", "wildmenu" or "native"
      selection_order = "top_down", -- near_cursor, top_down
    },
  },
  window = {
    completion = cmp.config.window.bordered({
      --   border = { '┌', '─', '┐', '│', '┘', '─', '└', '│' },
      --   winhighlight = 'Normal:CmpPmenu,FloatBorder:CmpPmenuBorder,CursorLine:PmenuSel,Search:None',
      winhighlight = "Normal:Normal,FloatBorder:Comment,CursorLine:Visual,Search:None",
      -- max_width = 40,
    }),
    documentation = cmp.config.window.bordered({
      winhighlight = "Normal:Normal,FloatBorder:Comment,CursorLine:Visual,Search:None",
      -- max_height = math.floor(WIDE_HEIGHT * (WIDE_HEIGHT / vim.o.lines)),
      -- max_width = math.floor((WIDE_HEIGHT * 2) * (vim.o.columns / (WIDE_HEIGHT * 2 * 16 / 9))),
    }),
  },
  formatting = {
    fields = {
      "menu",
      "abbr",
      "kind",
    },
    -- offset, exact, score, recently_used, locality, kind, sort_text, length, order
    format = function(entry, vim_item)
      local label = vim_item.abbr
      local truncated_label = vim.fn.strcharpart(label, 0, MAX_LABEL_WIDTH)
      if truncated_label ~= label then
        vim_item.abbr = truncated_label .. ELLIPSIS_CHAR
      elseif string.len(label) < MIN_LABEL_WIDTH then
        local padding = string.rep(" ", MIN_LABEL_WIDTH - string.len(label))
        vim_item.abbr = label .. padding
      end

      vim_item.dup = ({
        nvim_lua = 0,
      })[entry.source.name] or 1
      vim_item.menu = sources.names[entry.source.name] .. " "
      vim_item.kind = " " .. sources.symbols[vim_item.kind]
      return vim_item
    end,
  },
  sorting = {
    priority_weight = 2,
    comparators = {
      compare.offset,
      compare.exact,
      compare.score,
      -- require("cmp_fuzzy_path.compare"),
      -- require("cmp_fuzzy_buffer.compare"),
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
  sources = cmp.config.sources(sources.definitions),
}

cmp.setup(setupConfig)

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline("/", {
  mapping = cmp.mapping.preset.cmdline(),
  -- sources = cmp.config.sources({
  --   {
  --     name = "fuzzy_path",
  --     group_index = 2,
  --   },
  --   {
  --     name = "fuzzy_buffer",
  --     group_index = 2,
  --   },
  -- }),
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline({

    ["<Down>"] = cmp.mapping(cmp.mapping.scroll_docs(1), {
      "c",
    }),
    ["<Up>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), {
      "c",
    }),
    ["<C-D>"] = cmp.mapping(cmp.mapping.abort(), {
      "c",
    }),
    ["<C-n>"] = {
      c = function(fallback)
        if cmp.visible() then
          cmp.select_next_item({
            -- behavior = cmp.SelectBehavior.Insert,
          })
        else
          cmp.complete()
        end
      end,
    },
    ["<C-p>"] = {
      c = function(fallback)
        if cmp.visible() and cmp.get_selected_entry() then
          cmp.select_prev_item({
            -- behavior = cmp.SelectBehavior.Insert,
          })
        else
          -- cmp.mapping.complete({
          --   config = { sources = { { name = "cmdline_history" } } },
          -- })
          feedkeys.call(keymap.t("<Up>"), "c")
        end
      end,
    },
    ["<C-f>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        for _ = 1, 5 do
          cmp.mapping.select_next_item({
            behavior = cmp.SelectBehavior.Select,
          })(nil)
        end
      end
    end, {
      "c",
    }),
    ["<C-B>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        for _ = 1, 5 do
          cmp.mapping.select_prev_item({
            behavior = cmp.SelectBehavior.Select,
          })(nil)
        end
      end
    end, {
      "c",
    }),
  }),
  sources = cmp.config.sources({
    {
      name = "cmdline",
      priority = 50,
    },
    {
      name = "fuzzy_path",
      priority = 30,
    },
  }),
})

-- local opt = require("utils.core").opt
-- opt("omnifunc", false)

-- cmp.setup.filetype({ "markdown", "help" }, {
--   window = {
--     documentation = cmp.config.disable,
--   },
-- })
--

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
