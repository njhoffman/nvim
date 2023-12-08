local strings = require('plenary.strings')
local entry_display = require('telescope.pickers.entry_display')
-- local parse_line = require('telescope._extensions.undo.parser_graph')
local parse_line = require('telescope._extensions.undo.parser_plain')

local display_line = function(undo, fields, opts)
  return function(_, state)
    local displayer = entry_display.create({
      separator = '  ',
      items = {
        { width = 6 },
        { remaining = true },
      },
    })
    -- local width = vim.api.nvim_win_get_width(state.results_win)
    local node_part = (fields.prefix and fields.prefix or '') .. fields.node .. (fields.suffix and fields.suffix or '')
    local line_parts = {
      ['$ID'] = undo.seq,
      ['$NODE'] = node_part,
      ['$STAT_ADDED'] = fields.diff_added or '  ',
      ['$STAT_DELETED'] = fields.diff_deleted or '  ',
      ['$TIME'] = fields.formatted_time,
    }
    local line_center = opts.entry_format_center
    local line_right = opts.entry_format_right
    for key, value in pairs(line_parts) do
      line_center = line_center:gsub(key, value)
      line_right = line_right:gsub(key, value)
    end
    -- return displayer({
    --   { strings.align_str(entry[1], widths[1], true), 'Keyword' },
    --   { entry[2] },
    --   { strings.align_str(entry[3], width - widths[1] - widths[2] - 7, true), 'Comment' },
    -- })
    return displayer({
      { line_center, 'TelescopeNormal' },
      { line_right, 'Comment' },
    })
  end
end

local order = require('telescope.config').values.sorting_strategy
local entry_maker = function(opts)
  -- TODO: if no curhead add now node to show current state
  return function(undo)
    -- TODO: show a table instead of a list
    if #undo.additions + #undo.deletions == 0 then
      -- skip empty changes, vim has these sometimes...
      return nil
    end
    local fields = parse_line(undo, order, opts)
    return {
      value = undo,
      display = display_line(undo, fields, opts),
      ordinal = undo.ordinal,
    }
  end
end
local setup = function(opts)
  opts = opts or {}
  opts.entry_maker = entry_maker
  return entry_maker(opts)
end

return setup
