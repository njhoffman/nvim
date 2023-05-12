local histories = require('telescope.actions.history')

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
        query = 'text',
        project = 'text',
        date = 'text',
      })

      obj._current_tbl = nil
    end,
    reset = function(self)
      self._current_tbl = nil
      self.content = {}
      self.query = ''
      self.index = 1
    end,
    append = function(self, line, picker, no_reset)
      local title = picker.prompt_title

      local project_nvim = require('project_nvim')
      local cwd = picker.cwd or vim.loop.cwd()
      local project_name = project_nvim.get_project_root() or ''
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
            query = picker:_get_prompt(),
            project = project_name,
            picker = title,
            time = vim.fn.reltimestr(time),
            cwd = cwd,
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

return {
  -- get_history = get_history,
  get_history = histories.get_simple_history,
}
