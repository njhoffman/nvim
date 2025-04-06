-- https://github.com/svermeulen/vim-subversive
-- https://github.com/tpope/vim-abolish

local default_values = {
  on_substitute = nil,
  yank_substituted_text = false,
  preserve_cursor_position = false,
  modifiers = nil,
  highlight_substituted_text = {
    enabled = true,
    timer = 500,
  },
  range = {
    prefix = "s",
    prompt_current_text = false,
    confirm = false,
    complete_word = false,
    subject = nil,
    range = nil,
    group_substituted_text = false,
    suffix = "",
    auto_apply = false,
    cursor_position = "end",
  },
  exchange = {
    motion = nil,
    use_esc_to_cancel = true,
    preserve_cursor_position = false,
  },
}
-- ["x]S			Delete [count] lines [into register x] and start insert.  Synonym for "cc" |linewise|.
-- replace:  Siw replaces the current word with "+" register
-- exchange: Sxiw (move) Sxiw (or .)
--           cxw (move) cxw (or .)
--           (visual) X (move) (visual) X

require("substitute").setup({
  -- on_substitute = require("tiny-glimmer.support.substitute").substitute_cb,
  -- on_substitute = require("yanky.integration").substitute(),
  -- highlight_substituted_text = { timer = 400 },
  on_substitute = function(event)
    require("tiny-glimmer.support.substitute").substitute_cb({ register = vim.v.register })
    require("yanky.integration").substitute()(event)
    -- local yanky = require("yanky")
    -- local is_visual = require("substitute.utils").is_visual(event.vmode)
    -- yanky.init_ring("p", event.register, event.count, is_visual)
    -- return require("tiny-glimmer.support.substitute").substitute_cb(event)

    -- require("tiny-glimmer.support.substitute").substitute_cb({ register = vim.v.register })
    -- return require("mini.operators").replace()
  end,
  highlight_substituted_text = {
    enabled = false,
  },
  range = { prefix = "S" },
  yank_substituted_text = false,
  exchange = {
    preserve_cursor_position = false,
  },
})

local function setup_keymaps()
  local sub = require("substitute")
  local subrange = require("substitute.range")
  local subex = require("substitute.exchange")
  local map = require("mapper").map
  local subop = function(...)
    require("reactive").set_opfunc("S")
    sub.operator(...)
  end
  -- TODO: make Subs command desc
  -- :Subs/orig/replace/g
  -- :%S/{,un}nec{ce,ces,e}sar{y,ily}/{}nec{es}sar{}/g

  -- modifiers={ register = "a", expand = "<cword>", last_search = true, motion = "iw" }
  -- If you want to trim text but only if you substitute text in a charwise motion, you can use:
  -- modifiers = function(state)
  --   if state.vmode == 'char' then
  --     return { 'trim' }
  --   end

  -- If you always want to reindent text when making a linewise substitution, you can use:
  -- require('substitute').operator({
  --   modifiers = function(state)
  --     if state.vmode == 'line' then
  --       return { 'reindent' }
  --     end
  --   end,
  -- })
  local mods = {} --  { prefix = "S" }
-- modifiers = function(state)
  -- return state.vmode == "char" and { "trim" } or { "linewise" }
  -- end,

  -- stylua: ignore start
  map('n', 'S',   sub.operator,   { noremap = true, desc = ' substitute operator' })
  map("x", "S",   sub.visual,     { noremap = true, desc = " substitute visual"   })
  map("x", "p",   sub.visual,     { noremap = true, desc = " substitute visual"   })
  map("x", "P",   sub.visual,     { noremap = true, desc = " substitute visual"   })
  map("n", "SS",  sub.line,       { noremap = true, desc = " substitute line"     })
  map("n", "S^",  sub.line,       { noremap = true, desc = " substitute line"     })
  map("n", "S$",  sub.eol,        { noremap = true, desc = " substitute eol"      })
  map("n", "Sx",  subex.operator, { noremap = true, desc = " substitute exchange  operator" })
  map("n", "Sxc", subex.cancel,   { noremap = true, desc = " substitute exchange  cancel"   })
  map("n", "Sxl", subex.line,     { noremap = true, desc = " substitute exchange  line"     })
  map("n", "cxc", subex.cancel,   { noremap = true, desc = " substitute exchange  cancel"   })
  map("n", "cxl", subex.line,     { noremap = true, desc = " substitute exchange  line"     })
  map("n", "cx",  subex.operator, { noremap = true, desc = " substitute exchange  operator" })
  map("n", "X",   subex.operator, { noremap = true, desc = " substitute exchange  operator" })
  map("x", "cx",  subex.visual,   { noremap = true, desc = " substitute exchange  visual"   })
  map("x", "X",   subex.visual,   { noremap = true, desc = " substitute exchange  visual"   })

  map("n", "<leader>S", function()
    subrange.operator(mods)
  end, { noremap = true, desc = "  substitute range operator" })

  map("x", "<leader>S", function()
    subrange.visual(mods)
  end, { noremap = true, desc = "  substitute range visual" })

  map("n", "<leader>Sw", function()
    subrange.word(mods)
  end, { noremap = true, desc = "  substitute range word" })
  -- require('substitute.range').operator({ subject = { motion='iw' }, range = { motion = 'ap' } })

  -- vim.keymap.set('x', ';', exchange.visual, { noremap = true })
  -- map('n', 'xw', function() substitute.operator({ motion='iw' }) end)
  -- map('n', 'xW', function() substitute.operator({ motion='iW' }) end)
  -- map('n', 'xp', function() substitute.operator({ motion='ab' }) end)
  -- map('n', 'xb', function() substitute.operator({ motion='ib' }) end)
  -- map('n', 'xq', function() substitute.operator({ motion='iq' }) end)
  -- ["<Leader>sr"] = {range.operator, "SubRange: <motion><motion>"},
  -- ["sr"] = {F.ithunk(range.operator, {subject = {motion = "iw"}}), "SubRange: <word><motion>"},
  -- ["sS"] = {F.ithunk(range.operator, {confirm = true}), "SubRange: <motion><motion> [y/N]"},
  -- ["s;"] = {
  -- F.ithunk(range.operator, {subject = {motion = "iw"}, range = {motion = "ie"}}),
  -- "SubRange: <word><file>",
  -- },
  -- map('n', '<space>xw', function() exchange.operator({ motion='iw' }) end)
  -- map('n', '<space>xW', function() exchange.operator({ motion='iW' }) end)
  -- map('n', '<space>xp', function() exchange.operator({ motion='ap' }) end)
  -- map('n', '<space>xb', function() exchange.operator({ motion='ib' }) end)
  -- map('n', '<space>xq', function() exchange.operator({ motion='iq' }) end)
  -- map("n", "<leader>S", function()
  -- ["ss"] = {sub.visual, "Substitute: visual"},
  -- ["X"] = {exchange.visual, "SubExchange: selection"},
  -- ["sr"] = {range.visual, "SubRange: <motion>"},
  -- ["s;"] = {F.ithunk(range.visual, {range = {motion = "ie"}}), "SubRange: global"},
  -- "cp",
  -- '  <Cmd>lua require("substitute").operator()<CR>',
  --    mode = { "n" }, desc = "Replace operator text with yanked text",
  -- "cpp",
  -- '  <Cmd>lua require("substitute").operator({ motion = "iw" })<CR>',
  --    mode = { "n" }, desc = "Replace operator text with yanked text",
  --  "P",
  --  '  <Cmd>lua require("substitute").visual()<CR>',
  --     mode = { "x" }, desc = "Replace visual text with yanked text",
  -- "<Leader>c",
  -- '  <Cmd>lua require("substitute.range").operator()<CR>',
  --    mode = { "n" }, desc = "Substitute operator text within the range",
  -- "<Leader>c",
  -- '  <Cmd>lua require("substitute.range").visual()<CR>',
  --    mode = { "x" }, desc = "Substitute visual text within the range",
  -- "<Leader>C",
  -- '  <Cmd>lua require("substitute.range").visual({ range = "%" })<CR>',
  --    mode = { "x" }, desc = "Substitute visual text in the entire buffer",
  -- "<Leader>co",
  -- '  <Cmd>lua require("substitute.range").operator({ subject = { motion = "iw" } })<CR>',
  --    mode = { "n" }, desc = "Substitute cursor word within the range",
  -- "<Leader>cc",
  -- '  <Cmd>lua require("substitute.range").operator({ subject = { motion = "iw" }, range = "%" })<CR>',
  --    mode = { "n" }, desc = "Substitute cursor word in the entire buffer",
  -- "cx",
  -- '  <Cmd>lua require("substitute.exchange").operator()<CR>',
  --    mode = { "n" }, desc = "Swap operator text",
  -- "cxx",
  -- '  <Cmd>lua require("substitute.exchange").operator({ motion = "iw" })<CR>',
  --    mode = { "n" }, desc = "Swap cursor word",
  -- "X",
  -- '  <Cmd>lua require("substitute.exchange").visual()<CR>',
  --    mode = { "x" }, desc = "Swap visual text",
  -- "cxc",
  -- '  <Cmd>lua require("substitute.exchange").cancel()<CR>',
  --    mode = { "n" }, desc = "Cancel swapping text",
end

setup_keymaps()
