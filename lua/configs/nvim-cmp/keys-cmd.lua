local cmp_types = require('cmp.types.cmp')
local cmp = require('cmp')
local keymap = require('cmp.utils.keymap')
local preserve_mapping_verticality = false
local types = require('cmp.types')

local cmp_mapping = require('cmp.config.mapping')

local function get_source_code(f)
  local t = debug.getinfo(f)
  if t.linedefined < 0 then
    print('source', t.source)
    return
  end
  local name = t.source:gsub('^@', '')
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
  return table.concat(text, '\n')
end

local feedkeys = require('cmp.utils.feedkeys')

local send_enter = function()
  local enter_key = vim.api.nvim_replace_termcodes('<CR>', true, true, true)
  vim.api.nvim_feedkeys(enter_key, 'n', false)
end
local has_chars_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0
    and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('.%+') == nil
end

local has_chars_after = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col + 1, col + 1):match('.%+')
    == nil
end

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0
    and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

local last_history_cmd = ''
local cmdline = {
  ['<C-e>'] = {
    c = function()
      if cmp.visible() then
        cmp.abort()
      else
        cmp.complete()
      end
    end,
  },

  -- ['<C-y>'] = cmp_mapping({
  --   i = cmp_mapping.confirm({ behavior = ConfirmBehavior.Replace, select = false }),
  -- }),
  ['<C-y>'] = {
    c = function(fallback)
      if cmp.visible() then
        cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
      else
        fallback()
      end
    end,
  },
  ['<C-F>'] = {
    c = cmp.mapping.select_next_item({
      count = 6,
      behavior = cmp.SelectBehavior.Select,
      preserve_mapping_verticality = true,
    }),
  },
  ['<C-B>'] = {
    c = cmp.mapping.select_prev_item({
      count = 6,
      behavior = cmp.SelectBehavior.Select,
      preserve_mapping_verticality = true,
    }),
  },
  ['<C-n>'] = {
    c = function()
      local cmdline = vim.fn.getcmdline() or ''
      local cmdpos = vim.fn.getcmdpos()
      if cmdpos == 1 or last_history_cmd == cmdline then
        feedkeys.call(keymap.t('<Down>'), 'c')
        vim.schedule(function()
          last_history_cmd = vim.fn.getcmdline() or ''
        end)
      elseif cmp.visible() then
        cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
      else
        cmp.complete()
      end
    end,
  },

  -- :his[tory] [{name}] [{first}][, [{last}]]
  -- :history / 6,12
  -- 		List the contents of history {name} which can be:
  -- 		c[md]	 or :		command-line history
  -- 		s[earch] or / or ?	search string history
  -- 		e[xpr]	 or =		expression register history
  -- 		i[nput]	 or @		input line history
  -- 		d[ebug]	 or >		debug command history
  -- 		a[ll]			all of the above
  ['<C-p>'] = {
    c = function()
      local cmdline = vim.fn.getcmdline() or ''
      local cmdpos = vim.fn.getcmdpos()
      if cmdpos == 1 or last_history_cmd == cmdline then
        feedkeys.call(keymap.t('<Up>'), 'c')
        vim.schedule(function()
          last_history_cmd = vim.fn.getcmdline() or ''
        end)
      elseif cmp.visible() then
        cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
      else
        cmp.complete()
      end
    end,
  },
  ['<M-p>'] = {
    c = function()
      feedkeys.call(keymap.t('<Up>'), 'c')
    end,
  },
  ['<M-n>'] = {
    c = function()
      feedkeys.call(keymap.t('<Down>'), 'c')
    end,
  },
  ["<M-'>"] = {
    c = function(fallback)
      if cmp.visible() then
        cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })
      elseif type(fallback) == 'function' then
        fallback()
      end
    end,
  },
  -- ['<CR>'] = cmp_mapping(function(fallback)
  --   if cmp.visible() then
  --     return cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
  --   end
  --   -- if type(fallback) == 'function' then
  --   --   fallback() -- if not exited early, always fallback
  --   -- end
  -- end, { 'c' }),
  ['<CR>'] = cmp_mapping(function(fallback)
    local opts = {
      confirm_opts = { behavior = types.cmp.ConfirmBehavior.Replace, select = false },
    }
    if cmp.visible() then
      local confirm_opts = vim.deepcopy(opts.confirm_opts) -- avoid mutating the original opts below
      -- local is_insert_mode = function()
      --   return vim.api.nvim_get_mode().mode:sub(1, 1) == 'i'
      -- end
      -- if is_insert_mode() then -- prevent overwriting brackets
      --   confirm_opts.behavior = types.cmp.ConfirmBehavior.Insert
      -- end
      -- local entry = cmp.get_selected_entry()
      -- local is_copilot = entry and entry.source.name == 'copilot'
      -- if is_copilot then
      --   confirm_opts.behavior = ConfirmBehavior.Replace
      --   confirm_opts.select = true
      -- end
      if cmp.confirm(confirm_opts) then
        return -- success, exit early
      end
    end
    fallback() -- if not exited early, always fallback
  end, { 'c' }),
  ['<Tab>'] = cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.select_next_item()
    else
      fallback()
    end
  end, { 'c' }),

  ['<S-Tab>'] = cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.select_prev_item()
    else
      fallback()
    end
  end, { 'c' }),
  -- --   feedkeys.call(keymap.t('<Up>'), 'c')
  --      cmp.mapping.complete({ config = { sources = { { name = "cmdline_history" } } } })
  -- --   cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
}
return cmdline
