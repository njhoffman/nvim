local task_list = { task_cfg }
local task_cfg_example = {
  -- These have special "global" meaning:
  id = 'specific.task.id', -- ID is optional, but can be useful for specifying dependencies
  name = 'Task', -- task's name
  dependencies = { -- list of task ids to run before this one
    'setup.some.stuff',
    'setup.some.more.stuff',
  },
  after = 'cleanup.task.id', -- task id to run after this one is finished
  evaluate = 'task', -- run this config in "task" mode immedialtely after loading
  children = { -- nesting is also supported
    {
      name = '...',
      -- ... other config fields
    },
  },
}

local default = {
  -- common:
  name = 'Task', -- task's name
  scope = 'global', -- usually project or global
  group = 'go', --  language group (use vim filetype names for best icon experience)
  presentation = { 'menuhidden' }, -- various presentation options (only "menuhidden" supported for now)
  dependencies = { 'project.go.Run', 'global.go.Generate' }, -- list of task id's to run before this one
  after = 'global.sh.After Task', -- task id to run after this one is finished
  env = { a = 'b' }, -- map of environment variables
  cwd = '$HOME', -- current working directory
  args = { '--arg1', '--arg2' }, -- list of task's arguments
  pattern = 'vim regex', -- regex pattern to decide if a background task has finished (entered running state)
  -- task with this field is considered a long running task.
  -- If this task is specified as a dependency somewhere, it's considered as finished when this matches.
  -- task specific:
  command = 'go run ${workspaceDirectory}/main.go', -- command to run in task mode
  -- debug specific:
  type = 'delve', -- type of debug adapter
  request = 'launch',
  program = '${workspaceDirectory}/main.go',
  port = '9876',
  -- + extra dap-specific parameters (see: https://github.com/mfussenegger/nvim-dap)
  -- database specific:
  databases = { -- list of databases
    {
      name = 'My-DB',
      url = 'postgres://postgres:mypassword@localhost:5432/my-db',
    },
    {
      -- ...
    },
  },
  queries = { -- list of queries per database type (see: dadbod-ui table helpers)
    postgresql = {
      List = 'select * from {table} order by id asc',
      Count = 'select count(*) from {table}',
    },
  },
}
-- require('dbee').setup()
