local M = {}

local config = {
  ignore_words = {
    '^buf$',
    '^history$',
    '^h$',
    '^q$',
    '^qa$',
    '^w$',
    '^wq$',
    '^wa$',
    '^wqa$',
    '^q!$',
    '^qa!$',
    '^w!$',
    '^wq!$',
    '^wa!$',
    '^wqa!$',
  },
}

function M.set(user_conf)
  if user_conf == nil then
    return config
  end
  if type(user_conf) ~= 'table' then
    error('Configuration error')
  end
  config = vim.tbl_deep_extend('force', config, user_conf or {})
  return config
end

local function clean(ignore_words)
  for index, value in ipairs(ignore_words) do
    vim.fn.histdel(':', value)
  end
end

function M.setup(user_conf)
  local c = config.set(user_conf)
  local group_name = 'history_ignore'
  vim.api.nvim_create_augroup(group_name, { clear = true })

  vim.api.nvim_create_autocmd({ 'CmdlineEnter' }, {
    group = group_name,
    pattern = '*',
    callback = function()
      vim.schedule(function()
        clean(c.ignore_words)
      end)
    end,
    once = false,
  })
end

return M
