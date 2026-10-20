local logger = require('gitops.utils.logger')
local M = {}

M.lsp_format_async = function()
  if type(vim.lsp.buf.format) == 'function' then
    vim.lsp.buf.format({ async = true })
  end
end

M.lsp_format = function()
  if type(vim.lsp.buf.format) == 'function' then
    vim.lsp.buf.format()
  elseif type(vim.lsp.buf.formatting_sync) == 'function' then
    vim.lsp.buf.formatting_sync()
  end
end

M.get_repo = function(bufnr)
  bufnr = bufnr or vim.fn.bufnr()
  local ok, gitsigns = pcall(vim.api.nvim_buf_get_var, bufnr, 'gitsigns_status_dict')
  if ok == true then
    return {
      worktree = gitsigns.root,
      gitdir = gitsigns.gitdir,
    }
  else
    logger.warn('get_repo failed: ' .. vim.inspect({ bufnr, gitsigns }))
    return {}
  end
end

M.split_string = function(inputstr, sep)
  if sep == nil then
    sep = '%s'
  end
  local t = {}
  for str in string.gmatch(inputstr, '([^' .. sep .. ']+)') do
    table.insert(t, str)
  end
  return t
end

---@param text string
---@param max_length number
---@return string
M.truncate_text = function(text, max_length)
  if vim.api.nvim_strwidth(text) > max_length then
    return string.sub(text, 1, max_length - 1) .. '…'
  end

  return text
end

---@param text string
---@param align "'left'" | "'center'" | "'right'"
---@param line_length number
---@param gap_char string
---@return string
M.align_text = function(text, align, line_length, gap_char)
  local gap_length = line_length - vim.api.nvim_strwidth(text)

  local gap_left = ''
  local gap_right = ''

  if align == 'left' then
    gap_right = string.rep(gap_char, gap_length)
  elseif align == 'center' then
    gap_left = string.rep(gap_char, math.ceil(gap_length / 2))
    gap_right = string.rep(gap_char, math.floor(gap_length / 2))
  elseif align == 'right' then
    gap_left = string.rep(gap_char, gap_length)
  end

  return gap_left .. text .. gap_right
end

M.get_widths = function(part_lines)
  local widths = {}
  for _, line in ipairs(part_lines) do
    if vim.islist(line) then
      for n, part in ipairs(line) do
        if type(widths[n]) == 'nil' then
          widths[n] = 0
        end
        if type(part) == 'string' and #part > widths[n] then
          widths[n] = #part
        end
      end
    else
      for key, part in pairs(line) do
        if type(widths[key]) == 'nil' then
          widths[key] = 0
        end
        if type(part) == 'string' and #part > widths[key] then
          widths[key] = #part
        end
      end
    end
  end
  return widths
end

M.escape_chars = function(x)
  return (
    x:gsub('%%', '%%%%')
      :gsub('^%^', '%%^')
      :gsub('%$$', '%%$')
      :gsub('%(', '%%(')
      :gsub('%)', '%%)')
      :gsub('%.', '%%.')
      :gsub('%[', '%%[')
      :gsub('%]', '%%]')
      :gsub('%*', '%%*')
      :gsub('%+', '%%+')
      :gsub('%-', '%%-')
      :gsub('%?', '%%?')
  )
end

return M
