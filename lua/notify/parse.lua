-- handles tables in notification message that either contain body highlights or objects to inspect
-- returns plain string and table of lines each containing arrays of { Content, HLName? }

-- todo: better version of this where it scans table and ensures never more than two elements
local has_body_highlights = function(msg)
  return type(msg[1]) == 'table' and type(msg[1][1]) == 'table' and type(msg[1][1][1]) == 'string'
end

local handle_body_highlights = function(orig_msg)
  local msg = ''
  local body_highlights = {}
  for n, line in ipairs(orig_msg) do
    if n > 1 then
      msg = msg .. '\n'
    end
    local line_msg = ''
    for _, v in ipairs(line) do
      line_msg = line_msg .. v[1]
      if v[2] then
        table.insert(body_highlights, { v[2], n - 1, #line_msg - #v[1], #line_msg })
      end
    end
    msg = msg .. line_msg
  end
  return msg, body_highlights
end

local parse_message = function(orig_msg, orig_opts)
  local opts = orig_opts or {}
  local msg = orig_msg or ''
  if type(msg) == 'table' then
    if vim.tbl_islist(orig_msg) then
      if type(orig_msg[1]) == 'string' then
        msg = vim.fn.join(orig_msg, '\n')
      elseif has_body_highlights(orig_msg) then
        msg, opts.body_highlights = handle_body_highlights(orig_msg)
      else
        opts.filetype = orig_opts.filetype or 'lua'
        msg = vim.inspect(orig_msg)
      end
    else
      opts.filetype = orig_opts.filetype or 'lua'
      msg = vim.inspect(orig_msg)
    end
  end
  return msg, opts
end

return parse_message
