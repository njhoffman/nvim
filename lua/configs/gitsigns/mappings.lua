--   blame = '<function 3>',
--   blame_line = '<function 4>',
--   change_base = '<function 5>',
--   diffthis = '<function 6>',
--   get_actions = '<function 7>',
--   get_hunks = '<function 8>',
--   nav_hunk = '<function 9>',
--   next_hunk = '<function 10>',
--   prev_hunk = '<function 11>',
--   preview_hunk = '<function 12>',
--   preview_hunk_inline = '<function 13>',
--   refresh = '<function 14>',
--   reset_base = '<function 15>',
--   reset_buffer = '<function 16>',
--   reset_buffer_index = '<function 17>',
--   reset_hunk = '<function 18>',
--   select_hunk = '<function 19>',
--   setloclist = '<function 20>',
--   setqflist = '<function 21>',
--   show = '<function 22>',
--   stage_buffer = '<function 23>',
--   stage_hunk = '<function 24>',
--   toggle_current_line_blame = '<function 25>',
--   toggle_deleted = '<function 26>',
--   toggle_linehl = '<function 27>',
--   toggle_numhl = '<function 28>',
--   toggle_signs = '<function 29>',
--   toggle_word_diff = '<function 30>',
--   undo_stage_hunk = '<function 31>'

local setup_mappings = function(bufnr)
  local gs = package.loaded.gitsigns
  local function map(mode, l, r, opts)
    local default_opts = { noremap = true, silent = true, buffer = opts.bufnr }
    mode = type(mode) == "table" and mode or mode == "ox" and { "o", "x" } or { mode }
    opts = vim.tbl_deep_extend("force", default_opts, opts or {})
    require("mapper").map(mode, l, r, opts)
    -- vim.keymap.set(mode, l, r, opts)
  end

  local fns = {
    prev = function()
      if vim.wo.diff then
        vim.cmd.normal({ "[h", bang = true })
      else
        gs.nav_hunk("prev")
      end
    end,
    next = function()
      if vim.wo.diff then
        vim.cmd.normal({ "]h", bang = true })
      else
        gs.nav_hunk("next")
      end
    end,
    stage_selected = function()
      gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end,
    diffthis = function()
      gs.diffthis("~")
    end,
    blame_line = function()
      gs.blame_line({ full = true })
    end,
    qflist_all = function()
      gs.setqflist("all")
    end,
    toggle_blame = function(...)
      gs.toggle_current_line_blame(...)
    end,
    reset_index = function()
      gs.reset_buffer_index()
    end,
  }

  local p = function(key)
    return "<leader>g" .. key
  end

  -- stylua: ignore
  local maps = {
    { "n",  "]h",    fns.next_hunk,          "Goto Next Hunk" },
    { "n",  "[h",    fns.prev_hunk,          "Goto Previous Hunk" },
    { "ox", "ih",    gs.select_hunk,         "Select Hunk textobject" },
    { "n",  p("b"),  fns.blame_line,         "Blame Line" },
    { "n",  p("c"),  gs.change_base,         "Change Base Commit/Revision" },
    { "n",  p("d"),  gs.diffthis,            "Diff This" },
    { "n",  p("D"),  fns.diffthis,           "Diff This ~" },
    { "n",  p("!"),  fns.reset_index,        "Reset Buffer Index (git reset)" },
    { "n",  p("p"),  gs.preview_hunk,        "Preview Hunk" },
    { "n",  p("P"),  gs.preview_hunk_inline, "Preview Hunk Inline" },
    { "n",  p("q"),  gs.setqflist,           "Set QF List" },
    { "n",  p("Q"),  fns.qflist_all,         "Set QF List All" },
    { "n",  p("r"),  gs.reset_hunk,          "Reset Hunk" },
    { "v",  p("r"),  fns.reset_selected,     "Reset Selected Hunks" },
    { "n",  p("R"),  gs.reset_buffer,        "Reset Buffer Hunks" },
    { "n",  p("s"),  gs.stage_hunk,          "Stage Hunk" },
    { "v",  p("s"),  fns.stage_selected,     "Stage Selected Hunk" },
    { "n",  p("S"),  gs.stage_buffer,        "Stage Buffer Hunks" },
    { "n",  p("u"),  gs.undo_stage_hunk,     "Undo Stage Hunk" },
    { "n",  p("tb"), fns.toggle_blame,       "Toggle Current Line Blame" },
    { "n",  p("th"), gs.toggle_linehl,       "Toggle Line Highlight" },
    { "n",  p("tn"), gs.toggle_numhl,        "Toggle Number Highlight" },
    { "n",  p("ts"), gs.toggle_signs,        "Toggle Signs Visibility" },
    { "n",  p("tw"), gs.toggle_word_diff,    "Toggle Word Diff" },
    { "n",  p("tx"), gs.toggle_deleted,      "Toggle Show Deleted Signs" },
  }

  -- map({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>", { desc = "Stage Hunk" })
  -- map({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>", { desc = "Reset Hunk" })

  map("n", "]h", function()
    if vim.wo.diff then
      vim.cmd.normal({ "]h", bang = true })
    else
      gs.nav_hunk("next")
    end
  end, { desc = "Next Hunk" })

  map("n", "[h", function()
    if vim.wo.diff then
      vim.cmd.normal({ "[h", bang = true })
    else
      gs.nav_hunk("prev")
    end
  end, { desc = "Previous Hunk" })

  local pfx = "<leader>g"
  map("n", pfx .. "p", gs.preview_hunk, { desc = "Preview Hunk" })
  map("n", pfx .. "P", gs.preview_hunk_inline, { desc = "Preview Hunk Inline" })

  map("n", pfx .. "s", gs.stage_hunk, { desc = "Stage Hunk" })
  map("n", pfx .. "S", gs.stage_buffer, { desc = "Stage Buffer Hunks" })
  map("v", pfx .. "s", function()
    gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
  end, { desc = "Stage Selected Hunk" })
  map("n", pfx .. "u", gs.undo_stage_hunk, { desc = "Undo Stage Hunk" })

  map("n", pfx .. "r", gs.reset_hunk, { desc = "Reset Hunk" })
  map("n", pfx .. "R", gs.reset_buffer, { desc = "Reset Buffer Hunks" })
  map("n", pfx .. "I", gs.reset_buffer_index, { desc = "Reset Buffer Index (git reset)" })
  map("v", pfx .. "r", function()
    gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
  end, { desc = "Reset Selected Hunk" })

  map("n", pfx .. "d", gs.diffthis, { desc = "Diff This" })
  map("n", pfx .. "D", function()
    gs.diffthis("~")
  end, { desc = "Diff This ~" })

  map("n", pfx .. "q", gs.setqflist, { desc = "Set QF List" })
  map("n", pfx .. "Q", function()
    gs.setqflist("all")
  end, { desc = "Set QF List All" })

  map("n", pfx .. "b", function()
    gs.blame_line({ full = true })
  end, { desc = "Blame Line" })
  map("n", pfx .. "B", gs.toggle_current_line_blame, { desc = "Toggle Current Line Blame" })

  map("n", pfx .. "c", gs.change_base, { desc = "Change Base Commit/Revision" })
  map("n", pfx .. "s", gs.toggle_signs, { desc = "Toggle Signs Visibility" })
  map("n", pfx .. "l", gs.toggle_linehl, { desc = "Toggle Line Highlight" })
  map("n", pfx .. "n", gs.toggle_numhl, { desc = "Toggle Number Highlight" })
  map("n", pfx .. "w", gs.toggle_word_diff, { desc = "Toggle Word Diff" })
  map("n", pfx .. "x", gs.toggle_deleted, { desc = "Toggle Show Deleted Signs" })

  -- Text object
  map({ "o", "x" }, "ih", gs.select_hunk, { desc = "Select Hunk textobject" })

  -- map("n", "]h", gs.next_hunk, "Next Hunk")
  -- map("n", "[h", gs.prev_hunk, "Prev Hunk")
  --     -- Actions
  --     -- Text object
  --     map({'o', 'x'}, 'ih', gitsigns.select_hunk)
  -- Navigation
  -- map("n", "]h", "&diff ? ']h' : '<cmd>Gitsigns next_hunk<CR>'", { expr = true, desc = "Next Hunk"})
  -- map("n", "[h", "&diff ? '[
  -- h' : '<cmd>Gitsigns prev_hunk<CR>'", { expr = true, desc = "Previous Hunk"})})
end

return setup_mappings
