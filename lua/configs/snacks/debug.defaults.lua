_G.dd = function(...)
  Snacks.debug.inspect(...)
end
_G.bt = function()
  Snacks.debug.backtrace()
end
vim.print = _G.dd
-- - Add a global `dd(...)` you can use anywhere to quickly show a
--     notification with a pretty printed dump of the object(s)
--     with lua treesitter highlighting
-- - Add a global `bt()` to show a notification with a pretty
--     backtrace.
-- - Override Neovim’s `vim.print`, which is also used by `:= {something = 123}`

---@class snacks.debug.cmd
---@field cmd string|string[]
---@field level? snacks.notifier.level
---@field title? string
---@field args? string[]
---@field cwd? string
---@field group? boolean
---@field notify? boolean
---@field footer? string
---@field header? string
---@field props? table<string, string>
---@alias snacks.debug.Trace {name: string, time: number, [number]:snacks.debug.Trace}
---@alias snacks.debug.Stat {name:string, time:number, count?:number, depth?:number}

---@type fun(...)
Snacks.debug()

-- Show a notification with a pretty backtrace
---@param msg? string|string[]
---@param opts? snacks.notify.Opts
Snacks.debug.backtrace(msg, opts)

---@param opts snacks.debug.cmd
Snacks.debug.cmd(opts)

-- Show a notification with a pretty printed dump of the object(s) with lua treesitter highlighting and the location of the caller
Snacks.debug.inspect(...)
-- Log a message to the file `./debug.log`. - a timestamp will be added to every
-- message. - accepts multiple arguments and pretty prints them. - if the argument
--   is not a string, it will be printed using `vim.inspect`. - if the message is
--   smaller than 120 characters, it will be printed on a single line.
Snacks.debug.log("Hello", { foo = "bar" }, 42)
Snacks.debug.log(...)

Snacks.debug.metrics()

-- Very simple function to profile a lua function. **flush**set to `true` to use
---@param fn fun()
---@param opts? {count?: number, flush?: boolean, title?: string}
Snacks.debug.profile(fn, opts)

-- Run the current buffer or a range of lines. Shows the output of `print` inlined
-- with the code. Any error will be shown as a diagnostic.
---@param opts? {name?:string, buf?:number, print?:boolean}
Snacks.debug.run(opts)

Snacks.debug.size(bytes)

---@param opts? {min?: number, show?:boolean}
---@return {summary:table<string, snacks.debug.Stat>, trace:snacks.debug.Stat[], traces:snacks.debug.Trace[]}
Snacks.debug.stats(opts)

---@param name string?
Snacks.debug.trace(name)

---@param modname string
---@param mod? table
---@param suffix? string
Snacks.debug.tracemod(modname, mod, suffix)
