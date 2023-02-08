local File = {}
local KeyValue = require("logger.formatters.key_value")

setmetatable(File, {
  __call = function(cls, ...)
    return cls:new(...)
  end,
})

local RotatingFile = {}

setmetatable(RotatingFile, {
  __call = function(cls, ...)
    return cls:new(...)
  end,
})

function RotatingFile:new(level, path, opts)
  opts = opts or {}

  local file = {}

  file.level = level
  file.sink = File(level, path, opts)
  file.path = path
  file.max_size = opts.max_size
  file.max_age = opts.max_age
  file.time_format = opts.time_format or "%F-%H:%M:%S"

  file.uv = opts.uv or vim.loop

  RotatingFile.__index = RotatingFile
  setmetatable(file, RotatingFile)

  return file
end

function RotatingFile:write(entry)
  local stat = self.uv.fs_stat(self.path)
  if stat then
    local cu_time = os.time()
    if
      (self.max_size and stat.size >= self.max_size)
      or (self.max_age and cu_time >= stat.birthtime.sec + self.max_age)
    then
      cu_time = os.date(self.time_format, cu_time)

      local parts = { self.path:match("(.*)%.(.*)$") }
      local archive_file
      if #parts == 2 then
        archive_file = string.format("%s-%s.%s", parts[1], cu_time, parts[2])
      else
        archive_file = string.format("%s-%s", self.path, cu_time)
      end
      self.uv.fs_rename(self.path, archive_file)
    end
  end

  self.sink:write(entry)
end

local Console = {}

local KeyValue = require("logger.formatters.key_value")

setmetatable(Console, {
  __call = function(cls, ...)
    return cls:new(...)
  end,
})

function Console:new(level, opts)
  opts = opts or {}

  local console = {}

  console.level = level
  console.async = opts.async or true
  console.processors = opts.processors or {}
  console.formatter = opts.formatter or KeyValue()

  Console.__index = Console
  setmetatable(console, Console)

  return console
end

function Console:write(entry)
  local message = entry.msg

  local function impl()
    vim.api.nvim_echo(message, true, {})
  end

  if type(message) == "string" then
    message = { { message, nil } }
  end

  if not self.async and not vim.in_fast_event() then
    return impl()
  end

  vim.schedule(impl)
end

function File:new(level, path, opts)
  opts = opts or {}

  local file = {}

  file.level = level
  file.path = path
  file.processors = opts.processors or {}
  file.formatter = opts.formatter or KeyValue()
  file.iolib = opts.iolib or io

  File.__index = File
  setmetatable(file, File)

  return file
end

function File:write(entry)
  local fp = assert(self.iolib.open(self.path, "a"))

  fp:write(entry.msg)
  fp:write("\n")
  fp:close()
end

local M = {
  Console = Console,
  File = File,
  RotatingFile = RotatingFile,
}

return M
