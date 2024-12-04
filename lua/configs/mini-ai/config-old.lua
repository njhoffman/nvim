local cache

-- Jump between text objects
local function user_textobject_id(ai_type)
  -- Get from user single character textobject identifier
  local needs_help_msg = true
  vim.defer_fn(function()
    if not needs_help_msg then
      return
    end
    local msg = string.format("Enter `%s` textobject identifier (single character) ", ai_type)
    vim.notify(msg)
  end, 1000)
  local ok, char = pcall(vim.fn.getcharstr)
  needs_help_msg = false

  -- Terminate if couldn't get input (like with <C-c>) or it is `<Esc>`
  if not ok or char == "\27" then
    return nil
  end

  if char:find("^[%w%p%s]$") == nil then
    vim.notify("Input must be single character: alphanumeric, punctuation, or space.")
    return nil
  end

  return char
end

local function jump_textobject(prev_next, left_right, ai_type)
  cache = {}

  local ok, ai = pcall(require, "mini.ai")
  if not ok then
    vim.notify("No mini-ai found")
  end
  -- Get user input
  local tobj_id = user_textobject_id("a")
  if tobj_id == nil then
    return
  end

  -- Jump!
  ai.move_cursor(
    left_right,
    ai_type,
    tobj_id,
    { n_times = vim.v.count1, search_method = prev_next }
  )
end

local ai = require("mini.ai")

local opts = {
  -- TODO: investigate notification errors
  silent = true,
  mappings = {
    -- Main textobject prefixes
    around = "a",
    inside = "i",
    -- Next/last variants
    around_next = "an",
    inside_next = "in",
    around_last = "aN",
    inside_last = "iN",
    -- Move cursor to corresponding edge of `a` textobject
    goto_left = "g[",
    goto_right = "g]",
  },
  n_lines = 500,
  search_method = "cover_or_nearest",
  custom_textobjects = {
    -- Make `|` select both edges in non-balanced way
    ["|"] = ai.gen_spec.pair("|", "|", { type = "non-balanced" }),
    ["b"] = { { "%b()", "%b[]", "%b{}" }, "^.%s*().-()%s*.$" },
    ["o"] = ai.gen_spec.treesitter({
      a = { "@block.outer", "@conditional.outer", "@loop.outer" },
      i = { "@block.inner", "@conditional.inner", "@loop.inner" },
    }, { desc = "block/conditional/loop" }),
    ["A"] = ai.gen_spec.treesitter(
      { a = "@attribute.outer", i = "@attribute.inner" },
      { desc = "attribute" }
    ),
    ["f"] = ai.gen_spec.treesitter(
      { a = "@function.outer", i = "@function.inner" },
      { desc = "function" }
    ),
    ["C"] = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, { desc = "class" }),
    ["c"] = ai.gen_spec.treesitter(
      { a = "@conditional.outer", i = "@conditional.inner" },
      { desc = "conditional" }
    ),
    ["t"] = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
    -- a/ i/
    ["x"] = ai.gen_spec.treesitter(
      { a = "@comment.outer", i = "@comment.inner" },
      { desc = "comment" }
    ),
    ["l"] = function(type)
      -- L = ai.gen_ai_spec.line(),
      if vim.api.nvim_get_current_line() == "" then
        return
      end
      vim.cmd.normal({ type == "i" and "^" or "0", bang = true })
      local from_line, from_col = unpack(vim.api.nvim_win_get_cursor(0))
      local from = { line = from_line, col = from_col + 1 }
      vim.cmd.normal({ type == "i" and "g_" or "$", bang = true })
      local to_line, to_col = unpack(vim.api.nvim_win_get_cursor(0))
      local to = { line = to_line, col = to_col + 1 }
      return { from = from, to = to }
    end,
    ["g"] = function(ai_type)
      -- entire buffer
      if ai_type == "i" then
        local first_non_blank = vim.fn.nextnonblank(1)
        local final_non_blank = vim.fn.prevnonblank(vim.fn.line("$"))
        local from = { line = first_non_blank, col = 1 }
        local to =
          { line = final_non_blank, col = math.max(vim.fn.getline(final_non_blank):len(), 1) }
        return { from = from, to = to }
      elseif ai_type == "a" then
        local from = { line = 1, col = 1 }
        local to = { line = vim.fn.line("$"), col = math.max(vim.fn.getline("$"):len(), 1) }
        return { from = from, to = to }
      end
    end,
    -- local gen_ai_spec = MiniExtras.gen_ai_spec
    -- e = gen_ai_spec.buffer(),
    -- D = gen_ai_spec.diagnostic(),
    -- L = gen_ai_spec.line(),
    -- N = gen_ai_spec.number(),
    -- i = ai.gen_ai_spec.indent(),
  },
}

local setup_keymaps = function()
  -- Move cursor to corresponding edge of `a` textobject
  local gen_action = function(seq)
    local edge = ({ ["["] = "left", ["]"] = "right" })[seq:sub(1, 1)]
    local ai_type = seq:sub(2, 2)
    local prev_next = ({ ["N"] = "prev", ["n"] = "next" })[seq:sub(3, 3)]
    vim.keymap.set({ "n", "v" }, seq, function()
      jump_textobject(prev_next, edge, ai_type)
    end, {
      expr = true,
      remap = true,
      desc = string.format("  jump to %s edge of %s `%s` text object", edge, ai_type, prev_next),
    })
  end

  gen_action("[an")
  gen_action("]an")
  gen_action("[aN")
  gen_action("]aN")
  gen_action("[in")
  gen_action("]in")
  gen_action("[iN")
  gen_action("]iN")

-- stylua: ignore
  local i = {
    [' ']    = '  inside whitespace',
    ['"']    = '  inside quote "',
    ["'"]    = "  inside s-quote '",
    ['`']    = '  inside apostrophe `',
    ['(']    = '  inside (',
    [')']    = '  inside ) including white-space',
    ['>']    = '  inside > including white-space',
    ['<lt>'] = '  inside <',
    [']']    = '  inside ] including white-space',
    ['[']    = '  inside [',
    ['}']    = '  inside } including white-space',
    ['{']    = '  inside {',
    ['?']    = '  inside user prompt',
    [';']    = '  inside argument',
    _        = '  inside underscore',
    A        = '  inside attribute',
    b        = '  inside balanced: ), ], }',
    c        = '  inside conditional',
    C        = '  inside class',
    g        = '  inside entire buffer',
    f        = '  inside function',
    l        = '  inside line',
    L        = '  inside loop',
    o        = '  inside block, conditional, loop',
    q        = '  inside quote: `, ", \'',
    t        = '  inside tag',
    x        = '  inside comment',
  }

  local a = vim.deepcopy(i)
  for k, v in pairs(a) do
    a[k] = v:gsub("inside", "around"):gsub(" including.*", "")
  end

  -- local ic = vim.deepcopy(i)
  -- local ac = vim.deepcopy(a)
  -- for key, name in pairs({ n = 'Next', l = 'Last' }) do
  --   i[key] = vim.tbl_extend('force', { name = '  inside ' .. name .. ' textobject' }, ic)
  --   a[key] = vim.tbl_extend('force', { name = '  around ' .. name .. ' textobject' }, ac)
  -- end
  require("which-key").register({
    i = i,
    a = a,
  }, { mode = { "v", "o" } })
end

return { opts = opts, setup_keymaps = setup_keymaps }
