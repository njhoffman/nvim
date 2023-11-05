local sqlite = require('sqlite')

local config = {
  id = 'llm-history', -- only mandatory if you edit a file by hand. IT'S YOUR JOB TO KEEP THESE UNIQUE!
  name = 'LLM History',
  type = 'sqlite', -- type of database driver
  filename = 'llm-history.sqlite',
  path = vim.fn.stdpath('data'),
}
config.url = vim.loop.fs_realpath(config.path .. '/' .. config.filename)

function initialize()
  vim.fn.mkdir(config.path)
  local db = sqlite({
    url = config.url,
  })
  -- sqlite.db:open({uri}, {opts})                               *sqlite.db:open()*
  --     Creates and connect to new sqlite db object, either in memory or via a
  --     {uri}. If it is called on pre-made |sqlite_db| object, than it should open
  --     it. otherwise ignore.
  --
  --     ```lua
  --     -- Open db file at path or environment variable, otherwise open in memory.
  --     local db = sqlite.db:open("./pathto/dbfile" or "$ENV_VARABLE" or nil, {...})
  --     -- reopen connection if closed.
  --     db:open()
  --     -- configure open mode through opts.open_mode = "ro", "rw", "rwc", default "rwc"
  --     -- for more customize behaviour, set opts.open_mode to a list of db.flags
  --     -- see https://sqlite.org/c3ref/open.html#urifilenamesinsqlite3open
  --     ```
  --
end

initialize()
