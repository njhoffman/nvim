local stats_list = vim.import("stats.list")

local Popup = vim.import("nui.popup")
local event = vim.import("nui.utils.autocmd").event

local popup = Popup({
  position = { row = "90%", col = "100%" },
  size = {
    width = 25,
    height = 20,
  },
  enter = false,
  focusable = false,
  zindex = 50,
  relative = "editor",
  border = {
    highlight = "FloatBorder",
    padding = {
      top = 1,
      bottom = 1,
      left = 1,
      right = 1,
    },

    style = "rounded",
    text = {
      top = "InfoWindow",
      top_align = "center",
    },
  },
  buf_options = {
    -- modifiable = false,
    -- readonly = true,
  },
  win_options = {
    winblend = 50,
    winhighlight = "Normal:Normal",
  },
})


-- mount/open the component
popup:mount()

-- unmount component when cursor leaves buffer
popup:on(event.BufLeave, function()
  popup:unmount()
end)

local select_items = stats_list.get_items()

-- set content
vim.api.nvim_buf_set_lines(popup.bufnr, 0, 1, false, select_items)


-- -- vim.ui.select(select_items, {},
-- --   function(selected)
-- --     selected = selected or ''
-- --     print('SELECTED ' .. selected)
-- --   end
-- -- )
-- -- print(vim.ins;pect(env_counts))
