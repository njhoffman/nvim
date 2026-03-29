-- https://www.reddit.com/r/neovim/comments/1j55o9c/share_your_custom_toggles_using_snacks_toggle/
local profiler_cfg = require("configs.snacks.profiler")
local toggle_cfg = require("configs.snacks.toggle")
local scratch_cfg = require("configs.snacks.scratch")
local notifier_cfg = require("configs.snacks.notifier")
local styles_cfg = require("configs.snacks.styles")
local picker_cfg = require("configs.snacks.picker")

local cfg = {
  notifier = { enabled = false },
  -- notifier = notifier_cfg,
  profiler = profiler_cfg,
  scratch = scratch_cfg,
  styles = styles_cfg,
  toggle = toggle_cfg,
  picker = picker_cfg,

  bigfile = { enabled = true },
  dashboard = { enabled = false },
  debug = { enabled = true },
  input = { enabled = true },
  quickfile = { enabled = false },
  statuscolumn = { enabled = false },

  scroll = {
    enabled = false,
    animate = {
      duration = { step = 15, total = 250 },
      easing = "linear",
    },
    -- what buffers to animate
    filter = function(buf)
      return vim.g.snacks_scroll ~= false
        and vim.b[buf].snacks_scroll ~= false
        and vim.bo[buf].buftype ~= "terminal"
    end,
  },
  words = {
    enabled = false,
    debounce = 200, -- time in ms to wait before updating
    notify_jump = false, -- show a notification when jumping
    notify_end = true, -- show a notification when reaching the end
    foldopen = true, -- open folds after jumping
    jumplist = true, -- set jump point before jumping
    modes = { "n", "i", "c" }, -- modes to show references
  },
}

local runner_cfg = {
  run_key = "<C-CR>",
  output_switch_key = "<Tab>",
  sources = {
    python = { { "python3" }, extension = "py" },
    javascript = { { "deno" }, extension = "js" },
    typescript = { { "deno" }, extension = "ts" },
    cs = { "dotnet-script" },
    rust = {
      function(filepath, bin_path)
        return { "rustc", filepath, "-o", bin_path }
      end,
      extension = "rs",
      binary = true,
    },
    c = {
      function(filepath, bin_path)
        return { "gcc", filepath, "-o", bin_path }
      end,
      extension = "c",
      binary = true,
    },
    cpp = {
      function(filepath, bin_path)
        return { "g++", filepath, "-o", bin_path }
      end,
      extension = "cpp",
      binary = true,
    },
  },
}

require("snacks").setup(cfg)
require("configs.snacks.scratch-runner").setup(runner_cfg)

-- Profiling Neovim Startup
if vim.env.PROF then
  -- example for lazy.nvim
  -- change this to the correct path for your plugin manager
  local snacks = vim.fn.stdpath("data") .. "/lazy/snacks.nvim"
  vim.opt.rtp:append(snacks)
  require("snacks.profiler").startup({
    startup = {
      event = "VimEnter", -- stop profiler on this event. Defaults to `VimEnter`
      -- event = "UIEnter",
      -- event = "VeryLazy",
    },
  })
end

-- -- Toggle the profiler
Snacks.toggle.profiler():map("<leader>iP")
-- -- Toggle the profiler highlights
Snacks.toggle.profiler_highlights():map("<leader>iH")

local map = require("mapper").map
map("n", "<leader>iS", function()
  Snacks.profiler.scratch()
end, { desc = "Profiler Scratch Bufer" })

map("n", "<leader><", function()
  Snacks.scratch()
end, { desc = "Toggle scratch buffer" })

--     desc = "Neovim News",
--     function()
--       Snacks.win({
--         file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
--         width = 0.6,
--         height = 0.6,
--         wo = {
--           spell = false,
--           wrap = false,
--           signcolumn = "yes",
--           statuscolumn = " ",
--           conceallevel = 3,
--         },
--       })
--     end,
--   }
-- },

-- { "<leader>.",  function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
-- { "<leader>S",  function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },

-- keys = {
--   { "<leader>.", function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
--   { "<leader>S", function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
--   { "<leader>n", function() Snacks.notifier.show_history() end, desc = "Notification History" },
--   { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
--   { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename File" },
--   { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git Browse" },
--   { "<leader>gb", function() Snacks.git.blame_line() end, desc = "Git Blame Line" },
--   { "<leader>gf", function() Snacks.lazygit.log_file() end, desc = "Lazygit Current File History" },
--   { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
--   { "<leader>gl", function() Snacks.lazygit.log() end, desc = "Lazygit Log (cwd)" },
--   { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
--   { "<c-/>", function() Snacks.terminal() end, desc = "Toggle Terminal" },
--   { "<c-_>", function() Snacks.terminal() end, desc = "which_key_ignore" },
--   { "]]", function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" } },
--   { "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },
--   { "<leader>N", desc = "Neovim News", function() Snacks.win({ file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1], width = 0.6, height = 0.6, wo = { spell = false, wrap = false, signcolumn = "yes", statuscolumn = " ", conceallevel = 3 } }) end },
-- },

-- Highlight                 Group                 Default      Group  Description
-- SnacksNormal              NormalFloat           Normal       for    the         float window
-- SnacksWinBar              Title                 Title        of     the         window
-- SnacksBackdrop            none                  Backdrop
-- SnacksNormalNC            NormalFloat           Normal       for    non-current windows
-- SnacksWinBarNC            SnacksWinBar          Title        for    non-current windows
-- SnacksScratchKey          DiagnosticVirtualText Keymap       help   in          the   footer
-- SnacksScratchDesc         DiagnosticInfo        Keymap       help   desc        in    the footer
-- SnacksNotifierInfo        none                  Notification window for         Info
-- SnacksNotifierWarn        none                  Notification window for         Warn
-- SnacksNotifierDebug       none                  Notification window for         Debug
-- SnacksNotifierError       none                  Notification window for         Error
-- SnacksNotifierTrace       none                  Notification window for         Trace
-- SnacksNotifierIconInfo    none                  Icon         for    Info        notification
-- SnacksNotifierIconWarn    none                  Icon         for    Warn        notification
-- SnacksNotifierIconDebug   none                  Icon         for    Debug       notification
-- SnacksNotifierIconError   none                  Icon         for    Error       notification
-- SnacksNotifierIconTrace   none                  Icon         for    Trace       notification
-- SnacksNotifierTitleInfo   none                  Title        for    Info        notification
-- SnacksNotifierTitleWarn   none                  Title        for    Warn        notification
-- SnacksNotifierTitleDebug  none                  Title        for    Debug       notification
-- SnacksNotifierTitleError  none                  Title        for    Error       notification
-- SnacksNotifierTitleTrace  none                  Title        for    Trace       notification
-- SnacksNotifierBorderInfo  none                  Border       for    Info        notification
-- SnacksNotifierBorderWarn  none                  Border       for    Warn        notification
-- SnacksNotifierBorderDebug none                  Border       for    Debug       notification
-- SnacksNotifierBorderError none                  Border       for    Error       notification
-- SnacksNotifierBorderTrace none                  Border       for    Trace       notification
-- SnacksNotifierFooterInfo  DiagnosticInfo        Footer       for    Info        notification
-- SnacksNotifierFooterWarn  DiagnosticWarn        Footer       for    Warn        notification
-- SnacksNotifierFooterDebug DiagnosticHint        Footer       for    Debug       notification
-- SnacksNotifierFooterError DiagnosticError       Footer       for    Error       notification
-- SnacksNotifierFooterTrace DiagnosticHint        Footer       for    Trace       notification
-- SnacksDashboardNormal     Normal                Normal       for    the         dashboard
-- SnacksDashboardDesc       Special               Description  text   in          dashboard
-- SnacksDashboardFile       Special               Dashboard    file   items
-- SnacksDashboardDir        NonText               Directory    items
-- SnacksDashboardFooter     Title                 Dashboard    footer text
-- SnacksDashboardHeader     Title                 Dashboard    header text
-- SnacksDashboardIcon       Special               Dashboard    icons
-- SnacksDashboardKey        Number                Keybind      text
-- SnacksDashboardTerminal   SnacksDashboardNormal Terminal     text
-- SnacksDashboardSpecial    Special               Special      elements
-- SnacksDashboardTitle      Title                 Title        text
