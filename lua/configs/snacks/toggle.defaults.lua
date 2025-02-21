---@class snacks.toggle.Config
---@field icon? string|{ enabled: string, disabled: string }
---@field color? string|{ enabled: string, disabled: string }
---@field wk_desc? string|{ enabled: string, disabled: string }
---@field map? fun(mode: string|string[], lhs: string, rhs: string|fun(), opts?: vim.keymap.set.Opts)
---@field which_key? boolean
---@field notify? boolean
local toggle_cfg = {
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
  wk_desc = {
    enabled = "Disable ",
    disabled = "Enable ",
  },
}
---@class snacks.toggle.Opts: snacks.toggle.Config
---@field id? string
---@field name string
---@field get fun():boolean
---@field set fun(state:boolean)
---@type fun(... :snacks.toggle.Opts): snacks.toggle.Class
Snacks.toggle()
Snacks.toggle.animate()
---@param opts? snacks.toggle.Config
Snacks.toggle.diagnostics(opts)
Snacks.toggle.dim()
---@param id string
---@return snacks.toggle.Class?
Snacks.toggle.get(id)
Snacks.toggle.indent()
---@param opts? snacks.toggle.Config
Snacks.toggle.inlay_hints(opts)
---@param opts? snacks.toggle.Config
Snacks.toggle.line_number(opts)
---@param ... snacks.toggle.Opts
Snacks.toggle.new(...)
---@param option string
---@param opts? snacks.toggle.Config | {on?: unknown, off?: unknown, global?: boolean}
Snacks.toggle.option(option, opts)
Snacks.toggle.profiler()
Snacks.toggle.profiler_highlights()
Snacks.toggle.scroll()
---@param opts? snacks.toggle.Config
Snacks.toggle.treesitter(opts)
Snacks.toggle.words()
Snacks.toggle.zen()
Snacks.toggle.zoom()
