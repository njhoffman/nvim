-- to replace an existing notification just use the same id.
-- you can also use the return value of the notify function as id.
for i = 1, 10 do
  vim.defer_fn(function()
    vim.notify("Hello " .. i, "info", { id = "test" })
  end, i * 500)
end

-- Simple LSP Progress ~
vim.api.nvim_create_autocmd("LspProgress", {
  ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
  callback = function(ev)
    local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
    vim.notify(vim.lsp.status(), "info", {
      id = "lsp_progress",
      title = "LSP Progress",
      opts = function(notif)
        notif.icon = ev.data.params.value.kind == "end" and " "
          or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
      end,
    })
  end,
})
-- Advanced LSP Progress ~
---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
local progress = vim.defaulttable()
vim.api.nvim_create_autocmd("LspProgress", {
  ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
    if not client or type(value) ~= "table" then
      return
    end
    local p = progress[client.id]

    for i = 1, #p + 1 do
      if i == #p + 1 or p[i].token == ev.data.params.token then
        p[i] = {
          token = ev.data.params.token,
          msg = ("[%3d%%] %s%s"):format(
            value.kind == "end" and 100 or value.percentage or 100,
            value.title or "",
            value.message and (" **%s**"):format(value.message) or ""
          ),
          done = value.kind == "end",
        }
        break
      end
    end

    local msg = {} ---@type string[]
    progress[client.id] = vim.tbl_filter(function(v)
      return table.insert(msg, v.msg) or not v.done
    end, p)

    local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
    vim.notify(table.concat(msg, "\n"), "info", {
      id = "lsp_progress",
      title = client.name,
      opts = function(notif)
        notif.icon = #progress[client.id] == 0 and " "
          or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
      end,
    })
  end,
})( -- lazy.nvim
  {
    "folke/snacks.nvim",
    ---@type snacks.Config
    opts = {
      notifier = {
        -- your notifier configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      },
    },
  }
)

---@class snacks.notifier.Config
---@field enabled? boolean
---@field keep? fun(notif: snacks.notifier.Notif): boolean # global keep function
---@field filter? fun(notif: snacks.notifier.Notif): boolean # filter our unwanted notifications (return false to hide)
local default_cfg = {
  timeout = 3000, -- default timeout in ms
  width = { min = 40, max = 0.4 },
  height = { min = 1, max = 0.6 },
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
  -- %d is replaced with the number of lines.
  -- only works for styles with a border
  ---@type string|boolean
  more_format = " ↓ %d lines ",
  refresh = 50, -- refresh at most every 50ms
}

-- NOTIFICATION                             *snacks-notifier-styles-notification*
local notif = {
  border = "rounded",
  zindex = 100,
  ft = "markdown",
  wo = {
    winblend = 5,
    wrap = false,
    conceallevel = 2,
    colorcolumn = "",
  },
  bo = { filetype = "snacks_notif" },
}

-- NOTIFICATION_HISTORY             *snacks-notifier-styles-notification_history*
local notif_history = {
  border = "rounded",
  zindex = 100,
  width = 0.6,
  height = 0.6,
  minimal = false,
  title = " Notification History ",
  title_pos = "center",
  ft = "markdown",
  bo = { filetype = "snacks_notif_history", modifiable = false },
  wo = { winhighlight = "Normal:SnacksNotifierHistory" },
  keys = { q = "close" },
}
---@alias snacks.notifier.style snacks.notifier.render|"compact"|"fancy"|"minimal"
-- Notification options
---@class snacks.notifier.Notif.opts
---@field id? number|string
---@field msg? string
---@field level? number|snacks.notifier.level
---@field title? string
---@field icon? string
---@field timeout? number|boolean timeout in ms. Set to 0|false to keep until manually closed
---@field ft? string
---@field keep? fun(notif: snacks.notifier.Notif): boolean
---@field style? snacks.notifier.style
---@field opts? fun(notif: snacks.notifier.Notif) -- dynamic opts
---@field hl? snacks.notifier.hl -- highlight overrides
---@field history? boolean
---@class snacks.notifier.Notif: snacks.notifier.Notif.opts
---@field id number|string
---@field msg string
---@field win? snacks.win
---@field icon string
---@field level snacks.notifier.level
---@field timeout number
---@field dirty? boolean
---@field added number timestamp with nano precision
---@field updated number timestamp with nano precision
---@field shown? number timestamp with nano precision
---@field hidden? number timestamp with nano precision
---@field layout? { top?: number, width: number, height: number }
---@alias snacks.notifier.render fun(buf: number, notif: snacks.notifier.Notif, ctx: snacks.notifier.ctx)
---@class snacks.notifier.hl
---@field title string
---@field icon string
---@field border string
---@field footer string
---@field msg string
---@class snacks.notifier.ctx
---@field opts snacks.win.Config
---@field notifier snacks.notifier.Class
---@field hl snacks.notifier.hl
---@field ns number
---@class snacks.notifier.history
---@field filter? snacks.notifier.level|fun(notif: snacks.notifier.Notif): boolean
---@field sort? string[] # sort fields, default: {"added"}
---@field reverse? boolean
---@alias snacks.notifier.level "trace"|"debug"|"info"|"warn"|"error"
---@type fun(msg: string, level?: snacks.notifier.level|number, opts?: snacks.notifier.Notif.opts): number|string
Snacks.notifier()
---@param opts? snacks.notifier.history
Snacks.notifier.get_history(opts)
---@param id? number|string
Snacks.notifier.hide(id)
---@param msg string
---@param level? snacks.notifier.level|number
---@param opts? snacks.notifier.Notif.opts
Snacks.notifier.notify(msg, level, opts)
---@param opts? snacks.notifier.history
Snacks.notifier.show_history(opts)
