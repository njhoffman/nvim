---@class Snacks
---@field bigfile snacks.bigfile
---@field bufdelete snacks.bufdelete
---@field config snacks.config
---@field dashboard snacks.dashboard
---@field debug snacks.debug
---@field git snacks.git
---@field gitbrowse snacks.gitbrowse
---@field lazygit snacks.lazygit
---@field notifier snacks.notifier
---@field notify snacks.notify
---@field quickfile snacks.quickfile
---@field health snacks.health
---@field profiler snacks.profiler
---@field rename snacks.rename
---@field scratch snacks.scratch
---@field statuscolumn snacks.statuscolumn
---@field terminal snacks.terminal
---@field toggle snacks.toggle
---@field util snacks.util
---@field win snacks.win
---@field words snacks.words
---@class snacks.profiler.Config

local profiler_cfg = {
  autocmds = true,
  runtime = vim.env.VIMRUNTIME, ---@type string
  -- thresholds for buttons to be shown as info, warn or error
  -- value is a tuple of [warn, error]
  thresholds = {
    time = { 2, 10 },
    pct = { 10, 20 },
    count = { 10, 100 },
  },
  on_stop = {
    highlights = true, -- highlight entries after stopping the profiler
    pick = true, -- show a picker after stopping the profiler (uses the `on_stop` preset)
  },
  ---@type snacks.profiler.Highlights
  highlights = {
    min_time = 0, -- only highlight entries with time > min_time (in ms)
    max_shade = 20, -- time in ms for the darkest shade
    badges = { "time", "pct", "count", "trace" },
    align = 80,
  },
  pick = {
    picker = "auto", ---@type snacks.profiler.Picker
    ---@type snacks.profiler.Badge.type[]
    badges = { "time", "count", "name" },
    ---@type snacks.profiler.Highlights
    preview = {
      badges = { "time", "pct", "count" },
      align = "right",
    },
  },
  startup = {
    event = "VimEnter", -- stop profiler on this event. Defaults to `VimEnter`
    after = true, -- stop the profiler **after** the event. When false it stops **at** the event
    pattern = nil, -- pattern to match for the autocmd
    pick = true, -- show a picker after starting the profiler (uses the `startup` preset)
  },
  ---@type table<string, snacks.profiler.Pick|fun():snacks.profiler.Pick>
  presets = {
    startup = { min_time = 1, sort = false },
    on_stop = {},
    filter_by_plugin = function()
      return { filter = { def_plugin = vim.fn.input("Filter by plugin: ") } }
    end,
  },
  ---@type string[]
  globals = {
    -- "vim",
    -- "vim.api",
    -- "vim.keymap",
    -- "Snacks.dashboard.Dashboard",
  },
  -- filter modules by pattern.
  -- longest patterns are matched first
  filter_mod = {
    default = true, -- default value for unmatched patterns
    ["^vim%."] = false,
    ["mason-core.functional"] = false,
    ["mason-core.functional.data"] = false,
    ["mason-core.optional"] = false,
    ["which-key.state"] = false,
  },
  filter_fn = {
    default = true,
    ["^.*%._[^%.]*$"] = false,
    ["trouble.filter.is"] = false,
    ["trouble.item.__index"] = false,
    ["which-key.node.__index"] = false,
    ["smear_cursor.draw.wo"] = false,
    ["^ibl%.utils%."] = false,
  },
  icons = {
    time = " ",
    pct = " ",
    count = " ",
    require = "󰋺 ",
    modname = "󰆼 ",
    plugin = " ",
    autocmd = "⚡",
    file = " ",
    fn = "󰊕 ",
    status = "󰈸 ",
  },
}

local debug_cfg = {
  -- Snacks.debug()
  -- ---@type fun(...)
  -- Snacks.debug()

  -- Snacks.debug.backtrace()
  -- Show a notification with a pretty backtrace
  -- ---@param msg? string|string[]
  -- ---@param opts? snacks.notify.Opts
  -- Snacks.debug.backtrace(msg, opts)

  -- Snacks.debug.inspect()
  -- Show a notification with a pretty printed dump of the object(s) with lua treesitter highlighting and the location of the caller

  -- Snacks.debug.inspect(...)

  -- Snacks.debug.log()
  -- Log a message to the file ./debug.log.
  -- a timestamp will be added to every message.
  -- accepts multiple arguments and pretty prints them.
  -- if the argument is not a string, it will be printed using vim.inspect.
  -- if the message is smaller than 120 characters, it will be printed on a single line.
  -- Snacks.debug.log("Hello", { foo = "bar" }, 42)
  -- -- 2024-11-08 08:56:52 Hello { foo = "bar" } 42
  -- Snacks.debug.log(...)

  -- Snacks.debug.profile()
  -- Very simple function to profile a lua function.
  -- flush: set to true to use jit.flush in every iteration.
  -- count: defaults to 100
  -- ---@param fn fun()
  -- ---@param opts? {count?: number, flush?: boolean, title?: string}
  -- Snacks.debug.profile(fn, opts)

  -- Snacks.debug.run()
  -- Run the current buffer or a range of lines. Shows the output of print inlined with the code. Any error will be shown as a diagnostic.
  -- ---@param opts? {name?:string, buf?:number, print?:boolean}
  -- Snacks.debug.run(opts)

  -- Snacks.debug.stats()
  -- ---@param opts? {min?: number, show?:boolean}
  -- ---@return {summary:table<string, snacks.debug.Stat>, trace:snacks.debug.Stat[], traces:snacks.debug.Trace[]}
  -- Snacks.debug.stats(opts)

  -- Snacks.debug.trace()
  -- ---@param name string?
  -- Snacks.debug.trace(name)

  -- Snacks.debug.tracemod()
  -- ---@param modname string
  -- ---@param mod? table
  -- ---@param suffix? string
  -- Snacks.debug.tracemod(modname, mod, suffix)
}

local notifier_cfg = {
  ---@class snacks.notifier.Config
  ---@field keep? fun(notif: snacks.notifier.Notif): boolean # global keep function
  timeout = 3000, -- default timeout in ms
  width = 0.6,
  height = 0.6,
  -- editor margin to keep free. tabline and statusline are taken into account automatically
  margin = { top = 0, right = 1, bottom = 0 },
  padding = true, -- add 1 cell of left/right padding to the notification window
  sort = { "level", "added" }, -- sort by level and time
  -- minimum log level to display. TRACE is the lowest
  -- all notifications are stored in history
  level = vim.log.levels.TRACE,
  icons = {
    error = " ",
    warn = " ",
    info = " ",
    debug = " ",
    trace = " ",
  },
  keep = function(notif)
    return vim.fn.getcmdpos() > 0
  end,
  ---@type snacks.notifier.style
  style = "compact",
  top_down = true, -- place notifications from top to bottom
  date_format = "%R", -- time format for notifications
  -- format for footer when more lines are available
  -- `%d` is replaced with the number of lines.
  -- only works for styles with a border
  ---@type string|boolean
  more_format = " ↓ %d lines ",
  refresh = 50, -- refresh at most every 50ms
  -- Snacks.notifier()
  -- ---@type fun(msg: string, level?: snacks.notifier.level|number, opts?: snacks.notifier.Notif.opts): number|string
  -- Snacks.notifier()
  -- Snacks.notifier.get_history()
  -- ---@param opts? snacks.notifier.history
  -- Snacks.notifier.get_history(opts)
  -- Snacks.notifier.hide()
  -- ---@param id? number|string
  -- Snacks.notifier.hide(id)
  -- Snacks.notifier.notify()
  -- ---@param msg string
  -- ---@param level? snacks.notifier.level|number
  -- ---@param opts? snacks.notifier.Notif.opts
  -- Snacks.notifier.notify(msg, level, opts)
  -- Snacks.notifier.show_history()
  -- ---@param opts? snacks.notifier.history
  -- Snacks.notifier.show_history(opts)

  -- Snacks.notify()
  -- ---@type fun(msg: string|string[], opts?: snacks.notify.Opts)
  -- Snacks.notify()
  -- Snacks.notify.error()
  -- ---@param msg string|string[]
  -- ---@param opts? snacks.notify.Opts
  -- Snacks.notify.error(msg, opts)
  -- Snacks.notify.info()
  -- ---@param msg string|string[]
  -- ---@param opts? snacks.notify.Opts
  -- Snacks.notify.info(msg, opts)
  -- Snacks.notify.notify()
  -- ---@param msg string|string[]
  -- ---@param opts? snacks.notify.Opts
  -- Snacks.notify.notify(msg, opts)
  -- Snacks.notify.warn()
  -- ---@param msg string|string[]
  -- ---@param opts? snacks.notify.Opts
  -- Snacks.notify.warn(msg, opts)
}

local scratch_cfg = {
  position = "bottom", -- float
  height = 0.4,
  width = 0.4,
  bo = { buftype = "", buflisted = false, bufhidden = "hide", swapfile = false },
  minimal = false,
  noautocmd = false,
  -- position = "right",
  zindex = 50,
  wo = { winhighlight = "NormalFloat:Normal" },
  border = "rounded",
  title_pos = "center",
  footer_pos = "center",
  -- Snacks.scratch(),
  ---@type fun(opts?: snacks.scratch.Config): snacks.win
  -- Snacks.scratch()
  -- Snacks.scratch.list()
  -- Return a list of scratch buffers sorted by mtime.
  -- ---@return snacks.scratch.File[]
  -- Snacks.scratch.list()
  -- Snacks.scratch.open()
  -- Open a scratch buffer with the given options. If a window is already open with the same buffer, it will be closed instead.
  -- ---@param opts? snacks.scratch.Config
  -- Snacks.scratch.open(opts)
  -- Select a scratch buffer from a list of scratch buffers.
  -- Snacks.scratch.select()
}
local toggle_cfg = {
  ---@class snacks.toggle.Config
  ---@field icon? string|{ enabled: string, disabled: string }
  ---@field color? string|{ enabled: string, disabled: string }
  map = vim.keymap.set, -- keymap.set function to use
  which_key = true, -- integrate with which-key to show enabled/disabled icons and colors
  notify = true, -- show a notification when toggling
  -- icons for enabled/disabled states
  icon = {
    enabled = " ",
    disabled = " ",
  },
  -- colors for enabled/disabled states
  color = {
    enabled = "green",
    disabled = "yellow",
  },
  ---@class snacks.toggle
  ---@field opts snacks.toggle.Opts
  -- Snacks.toggle()
  -- ---@type fun(... :snacks.toggle.Opts): snacks.toggle
  -- Snacks.toggle()
  -- Snacks.toggle.diagnostics()
  -- ---@param opts? snacks.toggle.Config
  -- Snacks.toggle.diagnostics(opts)
  -- Snacks.toggle.inlay_hints()
  -- ---@param opts? snacks.toggle.Config
  -- Snacks.toggle.inlay_hints(opts)
  -- Snacks.toggle.line_number()
  -- ---@param opts? snacks.toggle.Config
  -- Snacks.toggle.line_number(opts)
  -- Snacks.toggle.new()
  -- ---@param ... snacks.toggle.Opts
  -- ---@return snacks.toggle
  -- Snacks.toggle.new(...)
  -- Snacks.toggle.option()
  -- ---@param option string
  -- ---@param opts? snacks.toggle.Config | {on?: unknown, off?: unknown}
  -- Snacks.toggle.option(option, opts)
  -- Snacks.toggle.profiler()
  -- Snacks.toggle.profiler()
  -- Snacks.toggle.profiler_highlights()
  -- Snacks.toggle.profiler_highlights()
  -- Snacks.toggle.treesitter()
  -- ---@param opts? snacks.toggle.Config
}

local cfg = {
  bigfile = { enabled = true },
  dashboard = { enabled = false },
  debug = { enabled = true },
  profiler = { enabled = true },
  notifier = { enabled = false, timeout = 3000 },
  quickfile = { enabled = false },
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
  scratch = {
    enabled = true,
    ft = function()
      if vim.bo.buftype == "" and vim.bo.filetype ~= "" then
        return vim.bo.filetype
      end
      return "markdown"
    end,
    ---@type string|string[]?
    icon = nil, -- `icon|{icon, icon_hl}`. defaults to the filetype icon
    root = vim.fn.stdpath("data") .. "/scratch",
    autowrite = true, -- automatically write when the buffer is hidden
    -- unique key for the scratch file is based on:
    -- * name * ft * vim.v.count1 (useful for keymaps) * cwd (optional
    win_by_ft = {
      lua = {
        keys = {
          q = "close",
          ["<M-{>"] = "close",
          ["source"] = {
            "<cr>",
            function(self)
              local name = "scratch."
                .. vim.fn.fnamemodify(vim.api.nvim_buf_get_name(self.buf), ":e")
              Snacks.debug.run({ buf = self.buf, name = name })
            end,
            desc = "Source buffer",
            mode = { "n", "x" },
          },
        },
      },
    },
    position = "bottom", -- float
    height = 0.4,
    width = 0.4,
  },
  statuscolumn = { enabled = false },
  toggle = { enabled = true },
  words = {
    enabled = false,
    debounce = 200, -- time in ms to wait before updating
    notify_jump = false, -- show a notification when jumping
    notify_end = true, -- show a notification when reaching the end
    foldopen = true, -- open folds after jumping
    jumplist = true, -- set jump point before jumping
    modes = { "n", "i", "c" }, -- modes to show references
  },
  styles = {
    notification = {
      wo = { wrap = true }, -- Wrap notifications
    },
  },
}
require("snacks").setup(cfg)

-- -- Toggle the profiler
-- Snacks.toggle.profiler():map("<leader>pp")
-- -- Toggle the profiler highlights
-- Snacks.toggle.profiler_highlights():map("<leader>ph")

-- vim.keymap.set("<leader>ps", function()
--   Snacks.profiler.scratch()
-- end, { desc = "Profiler Scratch Bufer" })
vim.keymap.set("n", "<leader><", function()
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
