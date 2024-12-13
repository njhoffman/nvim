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
local gen_ai_spec = require("mini.extra").gen_ai_spec

local opts = {
  -- TODO: investigate notification errors
  silent = false,
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
  -- - `'cover'` - use only covering match. Don't use either previous or next; report that there is no textobject found.
  -- - `'cover_or_next'` (default) - use covering match. If not found, use next.
  -- - `'cover_or_prev'` - use covering match. If not found, use previous.
  -- - `'cover_or_nearest'` - use covering match. If not found, use nearest.
  -- - `'next'` - use next match.
  -- - `'prev'` - use previous match.
  -- - `'nearest'` - use nearest match.
  search_method = "cover_or_nearest",
  --   comment.outer
  --   number.inner
  --   assignment.inner  assignment.outer
  --   assignment.lhs    assignment.rhs
  -- B block.inner       block.outer
  --   call.inner        call.outer
  -- c conditional.inner conditional.outer
  -- f function.inner    function.outer
  -- L loop.inner        loop.outer
  -- a parameter.inner   parameter.outer
  --   return.inner      return.outer

  custom_textobjects = {
    -- -- Imitate word ignoring digits and punctuation (only for Latin alphabet):
    -- --   { '()()%f[%w]%w+()[ \t]*()' }
    -- -- Word with camel case support (also supports only Latin alphabet):
    -- --   { { '%u[%l%d]+%f[^%l%d]',  '%f[%S][%l%d]+%f[^%l%d]',
    -- --       '%f[%P][%l%d]+%f[^%l%d]', '^[%l%d]+%f[^%l%d]' }, '^().*()$' }
    -- -- Number: { '%f[%d]%d+' }
    -- -- Date in 'YYYY-MM-DD' format: { '()%d%d%d%d%-%d%d%-%d%d()' }
    -- -- Lua block string: { '%[%[().-()%]%]' }
    -- -- Tweak argument to be recognized only inside `()` between `;`
    -- --    a = gen_spec.argument({ brackets = { '%b()' }, separator = ';' }),
    -- -- Tweak function call to not detect dot in function name
    -- --    f = gen_spec.function_call({ name_pattern = '[%w_]' }),
    -- N = gen_ai_spec.number(),
    -- i = ai.gen_ai_spec.indent(),
    ["*"] = ai.gen_spec.pair("*", "*", { type = "greedy" }),
    ["_"] = ai.gen_spec.pair("_", "_", { type = "greedy" }),
    ["|"] = ai.gen_spec.pair("|", "|", { type = "non-balanced" }),
    [";"] = ai.gen_spec.treesitter(
      { a = "@parameter.outer", i = "@parameter.inner" },
      { desc = "  argument" }
    ),
    ["a"] = ai.gen_spec.treesitter(
      { a = "@parameter.outer", i = "@parameter.inner" },
      { desc = "  argument" }
    ),
    ["A"] = ai.gen_spec.treesitter(
      { a = "@attribute.outer", i = "@attribute.inner" },
      { desc = "  attribute" }
    ),
    --      { { '%b()', '%b[]', '%b{}' }, '^.().*().$' }
    ["b"] = { { "%b()", "%b[]", "%b{}" }, "^.%s*().-()%s*.$" },
    ["B"] = ai.gen_spec.treesitter(
      { a = "@block.outer", i = "@block.inner" },
      { desc = "  block" }
    ),
    ["c"] = ai.gen_spec.treesitter(
      { a = "@conditional.outer", i = "@conditional.inner" },
      { desc = "  conditional" }
    ),
    ["C"] = ai.gen_spec.treesitter(
      { a = "@class.outer", i = "@class.inner" },
      { desc = "  class" }
    ),
    ["d"] = gen_ai_spec.diagnostic(),
    ["f"] = ai.gen_spec.treesitter(
      { a = "@function.outer", i = "@function.inner" },
      { desc = "  function" }
    ),
    ["g"] = gen_ai_spec.buffer(),
    ["l"] = gen_ai_spec.line(),
    ["L"] = ai.gen_spec.treesitter(
      { a = "@loop.outer", i = "@loop.inner" },
      { desc = "  loop" }
    ),
    ["o"] = ai.gen_spec.treesitter({
      a = { "@block.outer", "@conditional.outer", "@loop.outer" },
      i = { "@block.inner", "@conditional.inner", "@loop.inner" },
    }, { desc = "  block/conditional/loop" }),
    ["t"] = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
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
    ['*']    = '  inside asterisk *',
    ['|']    = '  inside pipe |',
    ['_']    = '  inside underscore a',
    [';']    = '  inside argument',
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
    ['a']    = '  inside argument',
    ['A']    = '  inside attribute',
    ['b']    = '  inside balanced: ), ], }',
    ['B']    = '  inside block',
    ['c']    = '  inside conditional',
    ['C']    = '  inside class',
    ['d']    = '  inside diagnostic',
    ['g']    = '  inside entire buffer',
    ['f']    = '  inside function',
    ['l']    = '  inside line',
    ['L']    = '  inside loop',
    ['o']    = '  inside block, conditional, loop',
    ['q']    = '  inside quote: `, ", \'',
    ['t']    = '  inside tag',
    -- ['x']    = '  inside comment',
  }

  local a = vim.deepcopy(i)
  for k, v in pairs(a) do
    a[k] = v:gsub("inside", "around"):gsub(" including.*", "")
  end

  -- local ic = vim.deepcopy(i)
  -- local ac = vim.deepcopy(a)
  -- for key, name in pairs({ n = "next", N = "last" }) do
  --   i[key] = vim.tbl_extend("force", { desc = "  inside " .. name .. " textobject" }, ic)
  --   a[key] = vim.tbl_extend("force", { desc = "  around " .. name .. " textobject" }, ac)
  -- end

  for k, v in pairs(i) do
    require("mapper").vmap({ "v", "o" }, "i" .. k, { desc = v })
  end

  for k, v in pairs(a) do
    require("mapper").vmap({ "v", "o" }, "a" .. k, { desc = v })
  end
end

return { opts = opts, setup_keymaps = setup_keymaps }
