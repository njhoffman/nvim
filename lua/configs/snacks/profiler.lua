-- stylua: ignore
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
    picker = "snacks", -- snacks, trouble, fzf-lua
    badges = { "time", "count", "name" },
    preview = {
      badges = { "time", "count" },
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
    on_stop = {
      min_time = 1,
      structure = true,
      -- loc = "def", -- def, ref
      -- max_shade = 20
      -- filter = {}
      sort = "time", -- time, count, false
      -- "name" fully qualified name of the function
      -- "def" definition
      -- "ref" reference (caller)
      -- "require" require
      -- "autocmd" autocmd
      -- "modname" module name of the called function
      -- "def_file" file of the definition
      -- "def_modname" module name of the definition
      -- "def_plugin" plugin that defines the function
      -- "ref_file" file of the reference
      -- "ref_modname" module name of the reference
      -- "ref_plugin" plugin that references the function
      group = 'name',
      -- name? string|boolean fully qualified name of the function
      -- def? string|boolean location of the definition
      -- ref? string|boolean location of the reference (caller)
      -- require? string|boolean special case for require
      -- autocmd? string|boolean special case for autocmd
      -- modname? string|boolean module name
      -- def_file? string|boolean file of the definition
      -- def_modname? string|boolean module name of the definition
      -- def_plugin? string|boolean plugin that defines the function
      -- ref_file? string|boolean file of the reference
      -- ref_modname? string|boolean module name of the reference
      -- ref_plugin? string|boolean plugin that references the function
    },
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
  -- filter modules by pattern. longest patterns are matched first
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
    time    = " ",
    pct     = " ",
    count   = " ",
    require = "󰋺 ",
    modname = "󰆼 ",
    plugin  = " ",
    autocmd = "⚡",
    file    = " ",
    fn      = "󰊕 ",
    status  = "󰈸 ",
  },
}

return profiler_cfg
