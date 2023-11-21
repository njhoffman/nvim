local histories = require('telescope.actions.history')
local Path = require('plenary.path')
local escape = function(content)
  return string.format("__ESCAPED__'%s'", content)
end

local unescape = function(content)
  return content:gsub("^__ESCAPED__'(.*)'$", '%1')
end

local get_history = function()
  local has_sqlite, sqlite = pcall(require, 'sqlite')
  if not has_sqlite then
    if type(sqlite) ~= 'string' then
      vim.notify("Coundn't find sqlite.lua. Using simple history", 3)
    else
      vim.notify('Found sqlite.lua: but got the following error: ' .. sqlite, 3)
    end
    return histories.get_simple_history()
  end

  local ensure_content = function(self, picker, cwd)
    if self._current_tbl then
      return
    end
    self._current_tbl = self.data:get({
      where = {
        picker = picker,
        cwd = cwd,
      },
    })
    self.content = {}
    for k, v in ipairs(self._current_tbl) do
      self.content[k] = unescape(v.content)
    end
    self.index = #self.content + 1
  end

  return histories.new({
    init = function(obj)
      obj.db = sqlite.new(obj.path)
      obj.data = obj.db:tbl('history', {
        id = true,
        content = 'text',
        picker = 'text',
        cwd = 'text',
        project = 'text',
        selection_index = 'integer',
        time = 'integer',
      })

      obj._current_tbl = nil
    end,
    reset = function(self)
      self._current_tbl = nil
      self.content = {}
      self.index = 1
    end,
    append = function(self, line, picker, no_reset)
      local title = picker.prompt_title
      local selection_index = picker:get_index(picker:get_selection_row())
      local cwd = picker.cwd or vim.loop.cwd()

      local project_name = require('project_nvim').get_project_root() or vim.loop.cwd()
      if project_name ~= '' then
        project_name = vim.fn.split(project_name, ' ')[1]
        local fileparts = vim.fn.split(project_name, '/')
        project_name = fileparts[#fileparts]
      end

      if line ~= '' then
        ensure_content(self, title, cwd)
        if self.content[#self.content] ~= line then
          table.insert(self.content, line)

          local len = #self.content
          if self.limit and len > self.limit then
            local diff = len - self.limit
            local ids = {}
            for i = 1, diff do
              if self._current_tbl then
                table.insert(ids, self._current_tbl[i].id)
              end
            end
            self.data:remove({ id = ids })
          end

          -- 'dt3' DATETIME NOT NULL DEFAULT (strftime('%Y-%m-%d %H:%M:%f', 'now', 'localtime'))
          local time = vim.fn.reltime()
          local db_entry = {
            content = escape(line),
            picker = title,
            cwd = cwd,
            project = project_name,
            selection_index = selection_index,
            time = os.time(),
          }
          self.data:insert(db_entry)
        end
      end
      if not no_reset then
        self:reset()
      end
    end,
    pre_get = function(self, _, picker)
      local cwd = picker.cwd or vim.loop.cwd()
      ensure_content(self, picker.prompt_title, cwd)
    end,
  })
end

local get_smart_history = function()
  local has_sqlite, sqlite = pcall(require, 'sqlite')
  if not has_sqlite then
    if type(sqlite) ~= 'string' then
      print("Coundn't find sqlite.lua. Using simple history")
    else
      print('Found sqlite.lua: but got the following error: ' .. sqlite)
    end
    return histories.get_simple_history()
  end

  local ensure_content = function(self, picker, cwd)
    if self._current_tbl then
      return
    end
    self._current_tbl = self.data:get({
      where = {
        picker = picker,
        cwd = cwd,
      },
    })
    self.content = {}
    for k, v in ipairs(self._current_tbl) do
      self.content[k] = unescape(v.content)
    end
    self.index = #self.content + 1
  end

  return histories.new({
    init = function(obj)
      obj.db = sqlite.new(obj.path)
      obj.data = obj.db:tbl('history', {
        id = true,
        content = 'text',
        picker = 'text',
        cwd = 'text',
      })

      obj._current_tbl = nil
    end,
    reset = function(self)
      self._current_tbl = nil
      self.content = {}
      self.index = 1
    end,
    append = function(self, line, picker, no_reset)
      local title = picker.prompt_title
      local cwd = picker.cwd or vim.loop.cwd()
      if line ~= '' then
        ensure_content(self, title, cwd)
        if self.content[#self.content] ~= line then
          table.insert(self.content, line)

          local len = #self.content
          if self.limit and len > self.limit then
            local diff = len - self.limit
            local ids = {}
            for i = 1, diff do
              if self._current_tbl then
                table.insert(ids, self._current_tbl[i].id)
              end
            end
            self.data:remove({ id = ids })
          end
          self.data:insert({ content = escape(line), picker = title, cwd = cwd })
        end
      end
      if not no_reset then
        self:reset()
      end
    end,
    pre_get = function(self, _, picker)
      local cwd = picker.cwd or vim.loop.cwd()
      ensure_content(self, picker.prompt_title, cwd)
    end,
  })
end

local uv = vim.loop
local write_async = function(path, txt, flag)
  vim.dbglog('write_async', path, txt, flag)
  uv.fs_open(path, flag, 438, function(open_err, fd)
    assert(not open_err, open_err)
    uv.fs_write(fd, txt, -1, function(write_err)
      assert(not write_err, write_err)
      uv.fs_close(fd, function(close_err)
        assert(not close_err, close_err)
      end)
    end)
  end)
end

local append_async = function(path, txt)
  write_async(path, txt, 'a')
end

local get_simple_history = function()
  return histories.new({
    init = function(obj)
      vim.dbglog('history init', obj)
      local p = Path:new(obj.path)
      if not p:exists() then
        p:touch({ parents = true })
      end

      obj.content = Path:new(obj.path):readlines()
      obj.index = #obj.content
      table.remove(obj.content, obj.index)
    end,
    reset = function(self)
      self.index = #self.content + 1
    end,
    append = function(self, line, _, no_reset)
      if line ~= '' then
        if self.content[#self.content] ~= line then
          table.insert(self.content, line)

          local len = #self.content
          if self.limit and len > self.limit then
            local diff = len - self.limit
            for i = diff, 1, -1 do
              table.remove(self.content, i)
            end
            write_async(self.path, table.concat(self.content, '\n') .. '\n', 'w')
          else
            append_async(self.path, line .. '\n')
          end
        end
      end
      if not no_reset then
        self:reset()
      end
    end,
  })
end

return {
  get_history = get_history,
  get_smart_history = get_smart_history,
  get_simple_history = get_simple_history,
}
