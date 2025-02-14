local M = {}
-- # Ctrl+A: move the cursor to the beginning of the line.
-- # Ctrl+D: if the line is empty, equivalent to EOF; typically, exit the shell. Otherwise, delete
-- # Ctrl+E: move the cursor to the end of the line.
-- # Ctrl+K: delete the the rest of the line after the cursor.
-- # Ctrl+O: submit the current line and load the next line from history (if any).
-- # Ctrl+P: fetch the previous line from history (like ↑).
-- # Ctrl+T: flip the two characters around the cursor.
-- # Ctrl+U: delete the text from the start of the line to the cursor.
-- # Ctrl+Y: yank the text from the kill ring (paste previously deleted text).

local config = {
  ignore_words = {
    "^buf$",
    "^history$",
    "^h$",
    "^q$",
    "^qa$",
    "^w$",
    "^wq$",
    "^wa$",
    "^wqa$",
    "^q!$",
    "^qa!$",
    "^w!$",
    "^wq!$",
    "^wa!$",
    "^wqa!$",
  },
}

function M.set(user_conf)
  if user_conf == nil then
    return config
  end
  if type(user_conf) ~= "table" then
    error("Configuration error")
  end
  config = vim.tbl_deep_extend("force", config, user_conf or {})
  return config
end

local function clean(ignore_words)
  for index, value in ipairs(ignore_words) do
    vim.fn.histdel(":", value)
  end
end

function M.setup(user_conf)
  local c = config.set(user_conf)
  local group_name = "history_ignore"
  vim.api.nvim_create_augroup(group_name, { clear = true })

  vim.api.nvim_create_autocmd({ "CmdlineEnter" }, {
    group = group_name,
    pattern = "*",
    callback = function()
      vim.schedule(function()
        clean(c.ignore_words)
      end)
    end,
    once = false,
  })
end

return M
