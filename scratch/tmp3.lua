local regex = {
  commentPrefix = '//',
  commentBlockPrefix = '/*',
  jsonObject = '{ : }',
  constDeclaration = '.*%f[%w_]const%f[^%w_]',
}

-- local check_wrong_language = function()
--   local start = vim.fn.getpos("'[")
--   local ending = vim.fn.getpos("']")
--   if start ~= nil and ending ~= nil then
--     local content = vim.fn.join(
--       vim.api.nvim_buf_get_text(0, start[2] - 1, start[3] - 1, ending[2] - 1, ending[3] - 1, {}) or { '' },
--       '\n'
--     )
--     vim.dbglog(content, start, ending)
--     if string.match(content, regex.constDeclaration) then
--       local matchStart, matchEnd = string.find(content, regex.constDeclaration)
--       vim.dbglog('matched', matchStart, matchEnd)
--       vim.notify('You are in lua not javascript!', 3)
--       -- local new_content = vim.fn.split(string.gsub(content, regex.constDeclaration, 'local '), '\n')
--       local new_content =
--         string.sub(content, matchStart, matchEnd - 1)(string.gsub(content, regex.constDeclaration, 'local '), '\n')
--       -- vim.dbglog('new', new_content)
--       -- vim.api.nvim_buf_set_text(0, start[2] - 1, start[3] - 1, ending[2] - 1, ending[3] - 1, new_line_content)
--     end
--   end
-- end
-- check_wrong_language()
--
--
local toRapPrompt = {
  ['to_rap'] = {
    hl_group = 'Title',
  },
}

vim.dbglog(toRapPrompt)
