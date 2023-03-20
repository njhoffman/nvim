local M = {}

function M.get_key_cmd(mode, lhs)
  local keys = vim.api.nvim_get_keymap(mode)
  local old_val = nil
  for _, key in ipairs(keys) do
    if key.lhs == lhs then
      old_val = key
    end
  end
  return old_val
end

function M.validate(sections)
  return sections and true or false
end

return M
