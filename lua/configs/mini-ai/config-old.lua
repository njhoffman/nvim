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
local extra_ai = require("mini.extra").gen_ai_spec
local ts = ai.gen_spec.treesitter
local pair = ai.gen_spec.pair

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
    -- TODO: after select first with search_method, search next
    goto_left = "g[",
    goto_right = "g]",
  },
  n_lines = 2000,
  -- cover_or_next    next
  -- cover_or_prev    cover prev
  -- cover_or_nearest nearest
  search_method = "cover_or_nearest",
  --   assignment.inner  assignment.outer
  --   assignment.lhs    assignment.rhs
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
    ["$"] = pair("$", "$", { type = "balanced" }),
    ["*"] = pair("*", "*", { type = "greedy" }),
    ["_"] = pair("_", "_", { type = "greedy" }),
    ["|"] = pair("|", "|", { type = "non-balanced" }),
    [";"] = ts({ a = "@parameter.outer", i = "@parameter.inner" }),
    ["a"] = ts({ a = "@parameter.outer", i = "@parameter.inner" }),
    ["A"] = ts({ a = "@attribute.outer", i = "@attribute.inner" }),
    ["b"] = { { "%b()", "%b[]", "%b{}" }, "^.%s*().-()%s*.$" },
    ["B"] = ts({ a = "@block.outer", i = "@block.inner" }),
    ["C"] = ts({ a = "@conditional.outer", i = "@conditional.inner" }),
    ["d"] = extra_ai.diagnostic(),
    ["D"] = extra_ai.number(),
    ["f"] = ts({ a = "@function.outer", i = "@function.inner" }),
    ["g"] = extra_ai.buffer(),
    ["k"] = ts({
      i = { "@key.inner", "@assignment.lhs" },
      a = { "@key.inner", "@assignment.lhs" },
    }),
    ["i"] = extra_ai.indent(),
    ["l"] = extra_ai.line(),
    ["L"] = ts({ a = "@loop.outer", i = "@loop.inner" }),
    ["o"] = ts({
      a = { "@block.outer", "@conditional.outer", "@loop.outer" },
      i = { "@block.inner", "@conditional.inner", "@loop.inner" },
    }),
    ["p"] = {
      {
        "\n%s*\n()().-()\n%s*\n()[%s]*", -- normal paragraphs
        "^()().-()\n%s*\n[%s]*()", -- paragraph at start of file
        "\n%s*\n()().-()()$", -- paragraph at end of file
      },
    },
    -- line (same key as visual line in my mappings)

    ["q"] = { { "%b''", '%b""', "%b``" }, "^.().*().$" },
    ["s"] = ts({
      a = { "@function.outer", "@class.outer", "@testitem.outer" },
      i = { "@function.inner", "@class.inner", "@testitem.inner" },
    }),
    ["t"] = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
    ["v"] = ts({
      i = { "@value.inner", "@assignment.rhs" },
      a = { "@value.inner", "@assignment.rhs" },
    }),
    ["w"] = { "()()%f[%w_][%w_]+()[ \t]*()" },
    ["W"] = { { "()()%f[%w%p][%w%p]+()[ \t]*()" } },
    ["x"] = ts({ a = "@comment.outer", i = "@comment.inner" }),
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

  -- gen_action("[an")
  -- gen_action("]an")
  -- gen_action("[aN")
  -- gen_action("]aN")
  -- gen_action("[in")
  -- gen_action("]in")
  -- gen_action("[iN")
  -- gen_action("]iN")

-- stylua: ignore
  local i = {
    ['*']    = '  inner asterisk *',
    ['|']    = '  inner pipe |',
    ['_']    = '  inner underscore a',
    [';']    = '  inner argument',
    [' ']    = '  inner whitespace',
    ['"']    = '  inner quote "',
    ["'"]    = "  inner s-quote '",
    ['`']    = '  inner apostrophe `',
    ['$']    = '  inner $',
    ['(']    = '  inner (',
    [')']    = '  inner ) with white-space',
    ['>']    = '  inner > with white-space',
    ['<lt>'] = '  inner <',
    [']']    = '  inner ] with white-space',
    ['[']    = '  inner [',
    ['}']    = '  inner } with white-space',
    ['{']    = '  inner {',
    ['?']    = '  inner user prompt',
    ['a']    = '  inner argument',
    ['A']    = '  inner attribute',
    ['b']    = '  inner balanced: ), ], }',
    ['B']    = '  inner block',
    -- ['c']    = '  inner class',
    ['c']    = '  inner chunk',
    ['C']    = '  inner conditional',
    ['d']    = '  inner diagnostic',
    ['f']    = '  inner function',
    ['g']    = '  inner entire buffer',
    ['k']    = "  inner key from kv pair",
    ['l']    = '  inner line',
    ['L']    = '  inner loop',
    ['i']    = '  inner indent',
    ['o']    = '  inner block, conditional, loop',
    ['p']    = '  inner paragraph',
    ['q']    = '  inner quote: `, \"", \'',
    ['s']    = '  inner scope',
    ['t']    = '  inner tag',
    ['x']    = '  inner comment',
    ['v']    = "  inner value from kv pair",
    ['w']    = "  inner word",
    ['W']    = "  inner WORD"
  }

  local a = vim.deepcopy(i)
  for k, v in pairs(a) do
    a[k] = v:gsub("inside", "around"):gsub(" including.*", "")
  end

  local ic = vim.deepcopy(i, true)
  local ac = vim.deepcopy(a, true)
  for key, name in pairs({ n = "next", N = "last" }) do
    i[key] = vim.tbl_extend("force", { desc = "  inside " .. name .. " textobject" }, ic)
    a[key] = vim.tbl_extend("force", { desc = "  around " .. name .. " textobject" }, ac)
  end

  for k, v in pairs(i) do
    require("mapper").vmap({ "v", "o" }, "i" .. k, { desc = v })
    -- iNw   inside last word
    -- inw   inside next word
    -- g[w   jump to left edge of word
    -- g]w   jump to right edge of word
  end

  for k, v in pairs(a) do
    require("mapper").vmap({ "v", "o" }, "a" .. k, { desc = v })
  end
end

return { opts = opts, setup_keymaps = setup_keymaps }
