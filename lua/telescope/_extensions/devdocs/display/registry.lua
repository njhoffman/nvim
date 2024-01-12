-- db_size = 120369, filetypes = "javascript", mtime = 1541374679, name = "Sinon.JS",
-- release = "6.3.5", slug = "sinon~6", type = "sinon", version = "6"
local utils = require('telescope._extensions.devdocs.utils')
local entry_display = require('telescope.pickers.entry_display')

local max_widths = { name = 24, version = 16, db_size = 12 }

local create_displayer = function(widths, state)
  local winwidth = vim.api.nvim_win_get_width(state.results_win) - #state.selection_caret - 2
  local used_width = 0
  local get_width = function(name)
    local width = math.min(widths[name], max_widths[name] or widths[name])
    used_width = used_width + width
    return width
  end
  return entry_display.create({
    separator = ' ',
    items = {
      { width = get_width('name'), right_justify = true },
      { width = get_width('version') },
      { width = get_width('db_size'), right_justify = true },
      { width = winwidth - used_width, right_justify = true },
    },
  })
end

--     Sinon.JS v6.3.5
local create_entry_maker = function(entries)
  local widths = utils.get_widths(entries)
  local displayer

  local entry_maker = function(entry)
    local m_date = os.date('%Y-%m-%d', entry.mtime)
    return {
      value = entry,
      display = function(_, state)
        if displayer == nil then
          displayer = create_displayer(widths, state)
        end
        return displayer({
          { entry.name, 'TelescopeDevdocsRegName' },
          { entry.version or '', 'TelescopeDevdocsRegVersion' },
          { utils.human_size(entry.db_size), 'TelescopeDevdocsRegSize' },
          { m_date, 'TelescopeDevdocsRegModified' },
        })
      end,
      ordinal = string.format('[%s] %s', entry.slug, entry.name),
    }
  end
  return entry_maker
end

return create_entry_maker
