local strings = require("plenary.strings")
local entry_display = require("telescope.pickers.entry_display")
local telescope_utils = require("telescope.previewers.utils")

local topics_entry_maker = function(widths)
  local displayer = entry_display.create({
    separator = "  ",
    items = {
      { width = widths[1] },
      { width = widths[2] },
      { remaining = true },
    },
  })
  return function(entry)
    -- NOTE: the width calculating logic is not exact, but approx enough
    local function make_display(_, state)
      local width = vim.api.nvim_win_get_width(state.results_win)
      return displayer({
        { strings.align_str(entry[1], widths[1], true), "Keyword" },
        { entry[2] },
        { strings.align_str(entry[3], width - widths[1] - widths[2] - 7, true), "Comment" },
      })
    end

    return {
      value = entry,
      display = make_display,
      ordinal = string.format("%s %s", entry[1], entry[2]),
    }
  end
end

local categories_entry_maker = function(entry)
  local displayer = entry_display.create({
    separator = " ",
    items = {
      { width = 3 },
      { remaining = true },
    },
  })

  local function make_display()
    return displayer({
      { entry[1], "TelescopeResultsClass" },
      { entry[2] },
    })
  end

  return {
    value = entry,
    display = make_display,
    ordinal = string.format("%s", entry[2]),
  }
end

local preview_topic = function(filetype)
  return function(self, entry, status)
    local bufnr = self.state.bufnr
    -- local title, subtitle, linecnt, lines = entry.value[1], entry.value[2], entry.value[3], entry.value[4]
    vim.api.nvim_buf_set_lines(bufnr, 0, 1, false, entry.value[4])
    vim.schedule(function()
      -- telescope_utils.highlighter(bufnr, 'markdown')
      local winid = vim.fn.bufwinid(bufnr)
      vim.bo[bufnr].ft = "markdown"
      vim.wo[winid].conceallevel = 3
      vim.wo[winid].scroll = 0
      vim.wo[winid].sidescrolloff = 0
    end)
  end
end

return {
  categories_entry_maker = categories_entry_maker,
  topics_entry_maker = topics_entry_maker,
  preview_topic = preview_topic,
}
