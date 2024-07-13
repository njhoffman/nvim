-- fd --type=file --full-path './doc/' --extension='.txt' --extension='.md'
-- fd --list-details --type=file --full-path './doc/*tags'

local index = function(plugin)
  local Config = require('lazy.core.config')
  local Util = require('lazy.core.util')
  if Config.options.readme.skip_if_doc_exists and vim.uv.fs_stat(plugin.dir .. '/doc') then
    return {}
  end

  local files = {}

  for _, file in ipairs(Config.options.readme.files) do
    vim.list_extend(files, vim.fn.expand(plugin.dir .. '/' .. file, false, true))
  end

  ---@type table<string,{file:string, tag:string, line:string}>
  local tags = {}
  for _, file in ipairs(files) do
    file = Util.norm(file)
    if vim.uv.fs_stat(file) then
      local rel_file = file:sub(#plugin.dir + 1)
      local tag_filename = plugin.name
        .. vim.fn.fnamemodify(rel_file, ':h'):gsub('%W+', '-'):gsub('^%-$', '')
      local lines = vim.split(Util.read_file(file), '\n')
      for _, line in ipairs(lines) do
        local title = line:match('^#+%s*(.*)')
        if title then
          local tag = tag_filename .. '-' .. title:lower():gsub('%W+', '-')
          tag = tag:gsub('%-+', '-'):gsub('%-$', '')
          line = line:gsub('([%[%]/])', '\\%1')
          tags[tag] = { tag = tag, line = line, file = tag_filename .. '.md' }
        end
      end
      table.insert(lines, [[<!-- vim: set ft=markdown: -->]])
      Util.write_file(
        Config.options.readme.root .. '/doc/' .. tag_filename .. '.md',
        table.concat(lines, '\n')
      )
    end
  end
  return tags
end

local update = function()
  local Config = require('lazy.core.config')
  local Util = require('lazy.core.util')
  if Config.plugins['lazy.nvim'] then
    vim.cmd.helptags(Config.plugins['lazy.nvim'].dir .. '/doc')
  end
  if Config.options.readme.enabled == false then
    return
  end

  local docs = Config.options.readme.root .. '/doc'
  vim.fn.mkdir(docs, 'p')

  Util.ls(docs, function(path, name, type)
    if type == 'file' and name:sub(-2) == 'md' then
      vim.uv.fs_unlink(path)
    end
  end)
  ---@type {file:string, tag:string, line:string}[]
  local tags = {}
  for _, plugin in pairs(Config.plugins) do
    for key, tag in pairs(index(plugin)) do
      tags[key] = tag
    end
  end
  local lines = { [[!_TAG_FILE_ENCODING	utf-8	//]] }
  Util.foreach(tags, function(_, tag)
    table.insert(lines, ('%s\t%s\t/%s'):format(tag.tag, tag.file, tag.line))
  end, { case_sensitive = true })
  Util.write_file(docs .. '/tags', table.concat(lines, '\n'))
end

local old_update = function()
  -- :helptags $VIMRUNTIME/doc
  local logger = require('logger').init('helptags')
  local lazy_util = package.loaded['lazy.util']
  local lazy_config = package.loaded['lazy.core.config']
  local docs_path = vim.g.docs_path and vim.fs.joinpath(vim.g.docs_path, 'doc')
    or vim.fs.joinpath(vim.fs.dirname(lazy_config.options.readme.root), 'docs', 'doc')
  vim.fn.mkdir(docs_path, 'p')
  lazy_util.ls(docs_path, function(path, _, _)
    if type == 'file' then
      logger:debug('rm ' .. path)
      vim.uv.fs_unlink(path)
    end
  end)
  for _, plugin in pairs(lazy_config.plugins) do
    local docs = vim.fs.joinpath(plugin.dir, 'doc')
    if lazy_util.file_exists(docs) then
      lazy_util.ls(docs, function(path, name, type)
        if type ~= 'file' then
          return
        end
        if name == 'tags' then
          logger:debug('rm tags ' .. path)
          vim.uv.fs_unlink(path)
        elseif name:sub(-4) == '.txt' then
          local dest = vim.fs.joinpath(docs_path, name)
          logger:debug('copy ' .. path .. ' => ' .. dest)
          vim.uv.fs_copyfile(path, dest)
        end
      end)
    end
  end
  -- TODO: handle it
  local ok, res = pcall(vim.cmd.helptags, docs_path)
  vim.dbglog('gen helptags', docs_path, res)
end

vim.api.nvim_create_autocmd('User', {
  group = vim.api.nvim_create_augroup('LazyHelp', { clear = true }),
  pattern = { 'LazyInstall*', 'LazyUpdate*', 'LazySync*', 'LazyRestore*' },
  callback = function()
    old_update()
  end,
})

-- Ensure appending docs' cache into rtp
--
-- vim.g.docs_path = vim.fs.joinpath(vim.fn.stdpath('cache'), 'where-ever-you-like')
-- vim.opt.rtp:append(vim.g.docs_path)
