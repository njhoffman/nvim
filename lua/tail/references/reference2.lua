local Neotail = {
  bufnr = 0,
  filesize = 0,
  active = false,
  timer = nil,
}

function Neotail:new()
  local newInstance = {}
  setmetatable(newInstance, self)
  self.__index = self
  newInstance.bufnr = vim.api.nvim_buf_get_number('%')
  newInstance.filesize = vim.api.nvim_eval('getfsize(expand("%"))')
  newInstance.active = false
  newInstance.timer = nil
  return newInstance
end

function Neotail:loop()
  local ok, _ = pcall(function()
    if not self.active or self.bufnr ~= vim.api.nvim_buf_get_number('%') or vim.bo.modified then
      return
    end
    local filesize = vim.api.nvim_eval('getfsize(expand("%"))')
    if filesize ~= self.filesize then
      local follow = vim.api.nvim_eval('line("$") == line(".")')
      local saveView
      if not follow then
        saveView = vim.fn.winsaveview()
      end
      vim.api.nvim_command('edit')
      if follow then
        vim.api.nvim_command('normal! GG')
      else
        vim.fn.winrestview(saveView)
      end
      self.filesize = filesize
    end
  end)
  if not ok then
    self:stop()
    error('fail in neotail_loop')
  end
end

function Neotail:start()
  if not self.active or not self.timer then
    self.timer = vim.uv.new_timer()
    self.timer:start(
      0,
      g.neotail_loop_period,
      vim.schedule_wrap(function()
        self:loop()
      end)
    )
  end
  self.active = true
end

function Neotail:stop()
  if self.timer then
    self.timer:stop()
    self.timer:close()
  end
  self.timer = nil
  self.active = false
end

local function neotail_start()
  if not vim.b.neotail then
    vim.b.neotail = Neotail:new()
    vim.cmd([[autocmd BufEnter <buffer> lua neotail_start()]])
    vim.cmd([[autocmd BufLeave <buffer> lua neotail_stop()]])
  end
  vim.b.neotail:start()
end

local function neotail_stop()
  if vim.b.neotail then
    vim.b.neotail:stop()
  end
end

_G.neotail_start = neotail_start
_G.neotail_stop = neotail_stop
