local config = {
  id = 'llm-history', -- only mandatory if you edit a file by hand. IT'S YOUR JOB TO KEEP THESE UNIQUE!
  name = 'LLM History',
  type = 'sqlite', -- type of database driver
  filename = 'llm-history.sqlite',
  path = vim.fn.stdpath('data'),
}
config.url = vim.loop.fs_realpath(config.path .. '/' .. config.filename)

require('dbee').setup({
  sources = {
    require('dbee.sources').MemorySource:new({ config }),
    require('dbee.sources').EnvSource:new('DBEE_CONNECTIONS'),
    require('dbee.sources').FileSource:new(vim.fn.stdpath('cache') .. '/dbee/persistence.json'),
  },
})
