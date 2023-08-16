-- https://raw.githubusercontent.com/t-troebst/perfanno.nvim/master/README.md

-- sudo apt-get install linux-tools-common linux-tools-generic linux-tools-`uname -r`
-- perf record --call-graph dwarf {program} => perf.data
-- node --perf-basic-prof-only-functions => perf.log

-- Load profiling data
-- :PerfLoadFlat loads flat perf data. Obviously you will not be able to find callers of functions in this mode.
-- :PerfLoadCallGraph loads full call graph perf data. This may take a while.
-- :PerfLoadFlameGraph loads data from a perf.log file in flamegraph format.
-- Control how annotations are displayed
-- :PerfPickEvent chooses a different event from the perf data to display. For example, you could use this to switch between cpu cycles, branch mispredictions, and cache misses.
-- :PerfCycleFormat allows you to toggle between the stored formats, by default this toggles between percentages and absolute counts.
-- Annotate
-- :PerfAnnotate annotates all currently open buffers.
-- :PerfToggleAnnotations toggles annotations in all buffers.
-- :PerfAnnotateSelection annotates code only in a given selection. Line highlights are shown relative to the total counts in that selection and if the current format is in percent, then the displayed percentages are also relative.
-- :PerfAnnotateFunction does the same as :PerfAnnotateSelection but selects the function that contains the cursor via treesitter.
-- If there is more than one event that was loaded, then you will be asked to pick one before annotations can be displayed.
-- Find hot lines
-- :PerfHottestLines opens a telescope finder with the hottest lines according to the current annotations.
-- :PerfHottestCallersSelection opens a telescope finder with the hottest lines that lead directly to the currently selected lines.
-- :PerfHottestCallersFunction works just like :PerfHottestCallersSelection but selects the function that contains the cursor via treesitter.

local util = require("perfanno.util")
local bgcolor = vim.fn.synIDattr(vim.fn.hlID("Normal"), "bg", "gui")

require("perfanno").setup({
  -- List of highlights that will be used to highlight hot lines (or nil to disable highlighting)
  -- line_highlights = util.make_bg_highlights(bgcolor, "#CC3300", 10),
  -- vt_highlight = util.make_fg_highlight("#CC3300"),

  -- Annotation formats that can be cycled between via :PerfCycleFormat
  --   "percent" controls whether percentages or absolute counts should be displayed
  --   "format" is the format string that will be used to display counts / percentages
  --   "minimum" is the minimum value below which lines will not be annotated
  -- Note: this also controls what shows up in the telescope finders
  formats = {
    { percent = true, format = "%.2f%%", minimum = 0.5 },
    { percent = false, format = "%d", minimum = 1 },
  },

  -- Automatically annotate files after :PerfLoadFlat and :PerfLoadCallGraph
  annotate_after_load = true,
  -- Automatically annoate newly opened buffers if information is available
  annotate_on_open = true,

  -- Options for telescope-based hottest line finders
  telescope = {
    -- Enable if possible, otherwise the plugin will fall back to vim.ui.select
    enabled = pcall(require, "telescope"),
    -- Annotate inside of the preview window
    annotate = true,
  },

  -- Node type patterns used to find the function that surrounds the cursor
  ts_function_patterns = {
    -- These should work for most languages (at least those used with perf)
    default = {
      "function",
      "method",
    },
    -- Otherwise you can add patterns for specific languages like:
    -- weirdlang = {
    --     "weirdfunc",
    -- }
  },
})

local telescope = require("telescope")
local actions = telescope.extensions.perfanno.actions
telescope.setup({
  extensions = {
    perfanno = {
      -- Special mappings in the telescope finders
      mappings = {
        ["i"] = {
          -- Find hottest callers of selected entry
          ["<C-h>"] = actions.hottest_callers,
          -- Find hottest callees of selected entry
          ["<C-l>"] = actions.hottest_callees,
        },

        ["n"] = {
          ["gu"] = actions.hottest_callers,
          ["gd"] = actions.hottest_callees,
        },
      },
    },
  },
})

local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

keymap("n", "<LEADER>plf", ":PerfLoadFlat<CR>", opts)
keymap("n", "<LEADER>plg", ":PerfLoadCallGraph<CR>", opts)
keymap("n", "<LEADER>plo", ":PerfLoadFlameGraph<CR>", opts)

keymap("n", "<LEADER>pe", ":PerfPickEvent<CR>", opts)

keymap("n", "<LEADER>pa", ":PerfAnnotate<CR>", opts)
keymap("n", "<LEADER>pf", ":PerfAnnotateFunction<CR>", opts)
keymap("v", "<LEADER>pa", ":PerfAnnotateSelection<CR>", opts)

keymap("n", "<LEADER>pt", ":PerfToggleAnnotations<CR>", opts)

keymap("n", "<LEADER>ph", ":PerfHottestLines<CR>", opts)
keymap("n", "<LEADER>ps", ":PerfHottestSymbols<CR>", opts)
keymap("n", "<LEADER>pc", ":PerfHottestCallersFunction<CR>", opts)
keymap("v", "<LEADER>pc", ":PerfHottestCallersSelection<CR>", opts)
