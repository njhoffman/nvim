local cmp = require("cmp")
local keymap = require("cmp.utils.keymap")
local preserve_mapping_verticality = false
local types = require("cmp.types")

local mapping = require("cmp.config.mapping")

local get_source_code = function(f)
  local t = debug.getinfo(f)
  if t.linedefined < 0 then
    print("source", t.source)
    return
  end
  local name = t.source:gsub("^@", "")
  local i = 0
  local text = {}
  for line in io.lines(name) do
    i = i + 1
    if i >= t.linedefined then
      text[#text + 1] = line
    end
    if i >= t.lastlinedefined then
      break
    end
  end
  return table.concat(text, "\n")
end

local feedkeys = require("cmp.utils.feedkeys")

local send_enter = function()
  local enter_key = vim.api.nvim_replace_termcodes("<CR>", true, true, true)
  vim.api.nvim_feedkeys(enter_key, "n", false)
end
local has_chars_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0
    and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match(".%+") == nil
end

local has_chars_after = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col + 1, col + 1):match(".%+")
    == nil
end

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0
    and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end
-- :his[tory] [{name}] [{first}][, [{last}]]
-- :history / 6,12
-- 		List the contents of history {name} which can be:
-- 		c[md]	 or :		command-line history
-- 		s[earch] or / or ?	search string history
-- 		e[xpr]	 or =		expression register history
-- 		i[nput]	 or @		input line history
-- 		d[ebug]	 or >		debug command history
-- 		a[ll]			all of the above
-- ['<C-y>'] = cmp_mapping({
--   i = cmp_mapping.confirm({ behavior = ConfirmBehavior.Replace, select = false }),
-- }),

local last_history_cmd = ""

local cmdline = {
  ["<C-e>"] = {
    c = function(fallback)
      if cmp.visible() then
        cmp.abort()
      elseif not cmp.complete() then
        fallback()
      end
    end,
  },

  ["<C-F>"] = {
    c = cmp.mapping.select_next_item({
      count = 6,
      behavior = cmp.SelectBehavior.Select,
      preserve_mapping_verticality = true,
    }),
  },
  ["<C-B>"] = {
    c = cmp.mapping.select_prev_item({
      count = 6,
      behavior = cmp.SelectBehavior.Select,
      preserve_mapping_verticality = true,
    }),
  },
  ["<Esc>"] = {
    c = function(fallback)
      if cmp.get_selected_entry() then
        cmp.abort()
      else
        feedkeys.call(keymap.t("<C-c>"), "c")
      end
      -- fallback()
    end,
  },
  ["<C-n>"] = {
    c = function(fallback)
      local cmdline = vim.fn.getcmdline() or ""
      local cmdpos = vim.fn.getcmdpos()
      -- if cmdpos >= 2 or last_history_cmd == cmdline then
      --   feedkeys.call(keymap.t('<Down>'), 'c')
      --   vim.schedule(function()
      --     last_history_cmd = vim.fn.getcmdline() or ''
      --   end)
      if cmp.visible() then
        cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
      elseif not cmp.complete() then
        fallback()
      end
    end,
  },

  ["<C-p>"] = {
    c = function(fallback)
      local cmdline = vim.fn.getcmdline() or ""
      local cmdpos = vim.fn.getcmdpos()
      -- if cmdpos >= 2 or last_history_cmd == cmdline then
      --   feedkeys.call(keymap.t('<Up>'), 'c')
      --   vim.schedule(function()
      --     last_history_cmd = vim.fn.getcmdline() or ''
      --   end)
      if cmp.visible() then
        cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
      elseif not cmp.complete() then
        fallback()
      end
    end,
  },
  ["<M-P>"] = {
    c = function()
      feedkeys.call(keymap.t("<Up>"), "c")
    end,
  },
  ["<M-n>"] = {
    c = function()
      feedkeys.call(keymap.t("<Down>"), "c")
    end,
  },
  ["<M-'>"] = {
    c = function(fallback)
      if cmp.visible() then
        cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })
      end
      if type(fallback) == "function" then
        fallback()
      end
    end,
  },

  ["<C-Space>"] = {
    c = function(fallback)
      if cmp.visible() then
        cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })
      end
      if type(fallback) == "function" then
        fallback()
      end
    end,
  },

  ["<M-BS>"] = {
    c = function(fallback)
      local cmdpos = vim.fn.getcmdpos()
      if cmdpos < 2 then
        return cmp.close()
      elseif type(fallback) == "function" then
        fallback()
      end
    end,
  },
  ["<C-Y>"] = mapping({
    c = mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
  }),

  ["<CR>"] = mapping(function(fallback)
    local opts = { confirm_opts = { behavior = cmp.ConfirmBehavior.Insert, select = false } }
    if cmp.visible() then
      local confirm_opts = vim.deepcopy(opts.confirm_opts) -- avoid mutating the original opts below
      local is_insert_mode = function()
        return vim.api.nvim_get_mode().mode:sub(1, 1) == "i"
      end
      if is_insert_mode() then -- prevent overwriting brackets
        confirm_opts.behavior = types.cmp.ConfirmBehavior.Insert
      end
      local entry = cmp.get_selected_entry()
      local is_copilot = entry and entry.source.name == "copilot"
      if is_copilot then
        -- confirm_opts.behavior = ConfirmBehavior.Replace
        confirm_opts.select = true
      end
      if cmp.confirm(confirm_opts) then
        return -- success, exit early
      end
    end

    if type(fallback) == "function" then
      fallback() -- if not exited early, always fallback
    end
  end, { "c" }),

  -- ["<S-CR>"] = {
  --   c = function(fallback)
  --     -- if cmp.visible() then
  --     --   cmp.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true })
  --     -- end
  --     fallback()
  --     feedkeys.call(keymap.t("<C-c>"), "c")
  --   end,
  --   -- c = cmp.mapping.confirm({ behavior = types.cmp.ConfirmBehavior.Replace, select = false }),
  -- },
  -- ["<C-CR>"] = {
  --   c = cmp.mapping.confirm({ behavior = types.cmp.ConfirmBehavior.Insert, select = true }),
  -- },

  ["<Tab>"] = cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.select_next_item()
    elseif type(fallback) == "function" then
      fallback() -- if not exited early, always fallback
    end
  end, { "c" }),

  ["<S-Tab>"] = cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.select_prev_item()
    elseif type(fallback) == "function" then
      fallback()
    end
  end, { "c" }),
  -- --   feedkeys.call(keymap.t('<Up>'), 'c') cmp.mapping.complete({ config = { sources = { { name = "cmdline_history" } } } })
  -- --   cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
}
return cmdline
