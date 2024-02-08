local gen_from_quickfix = function(opts)
  local entry_display = require('telescope.pickers.entry_display')
  opts = opts or { width = 80 }
  local opt_width = opts.width
  if type(opts.width) == 'function' then
    opt_width = opts.width()
  end
  local file_width = math.max(math.floor(opt_width / 2) - 6, math.min(opt_width - 5, 40))

  local displayer = entry_display.create({
    separator = ' ',
    items = {
      { width = file_width },
      { width = 4 },
      { remaing = true },
    },
  })

  local make_display = function(entry)
    local filename = utils.transform_path(opts, entry.filename)
    local fl = string.len(filename)
    if fl > file_width then
      filename = '...' .. filename:sub(fl - file_width + 5)
    end
    local line_info = { entry.lnum, 'TelescopeResultsLineNr' }

    return displayer({
      { filename, 'TabLineSel' },
      line_info,
      entry.text:gsub('^%s+', ''),
    })
  end

  return function(entry)
    local filename = entry.filename or vim.api.nvim_buf_get_name(entry.bufnr)

    return {
      valid = true,

      value = entry,
      ordinal = (not opts.ignore_filename and filename or '') .. ' ' .. entry.text,
      display = make_display,

      bufnr = entry.bufnr,
      filename = filename,
      lnum = entry.lnum,
      col = entry.col,
      text = entry.text,
      start = entry.start,
      finish = entry.finish,
    }
  end
end

return gen_from_quickfix
