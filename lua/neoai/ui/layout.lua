local Layout = require("nui.layout")
local Popup = require("nui.popup")

local get_component_heights = function(output_height_percentage)
  local lines_height = vim.api.nvim_get_option("lines")
  local statusline_height = vim.o.laststatus == 0 and 0 or 1 -- height of the statusline if present
  local cmdline_height = vim.o.cmdheight -- height of the cmdline if present
  local tabline_height = vim.o.showtabline == 0 and 0 or 1 -- height of the tabline if present
  local total_height = lines_height
  local used_height = statusline_height + cmdline_height + tabline_height
  local layout_height = total_height - used_height
  local output_height = math.floor(layout_height * output_height_percentage / 100)
  local prompt_height = layout_height - output_height
  local starting_row = tabline_height == 0 and 0 or 1

  return {
    starting_row = starting_row,
    layout = layout_height,
    output = output_height,
    prompt = prompt_height,
  }
end

local create_components = function(state, config, current_model)
  local cfg = config.options.ui
  state.output_popup = Popup({
    enter = false,
    focusable = true,
    zindex = 50,
    position = "50%",
    border = {
      style = "rounded",
      text = {
        top = " " .. cfg.output_popup_text .. " ",
        top_align = "center",
        bottom = current_model.model .. " (" .. current_model.name.name .. ") ",
        bottom_align = "right",
      },
    },
    buf_options = {
      modifiable = false,
      readonly = true,
      syntax = "pandoc",
      -- filetype = "markdown.neoai-output",
      filetype = "markdown",
      buftype = "nofile",
      bufhidden = "hide",
      swapfile = false,
      -- buflisted = false
    },
    -- win_options = {
    -- 	winblend = 10,
    -- 	winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
    -- },
    win_options = {
      wrap = true,
    },
  })

  state.input_popup = Popup({
    enter = true,
    focusable = true,
    zindex = 50,
    position = "50%",
    border = {
      style = "rounded",
      padding = {
        left = 1,
        right = 1,
      },
      text = {
        top = #cfg.input_popup_text > 0 and " " .. config.options.ui.input_popup_text .. " " or "",
        top_align = "center",
      },
    },
    buf_options = {
      modifiable = true,
      readonly = false,
      filetype = "neoai-input",
    },
    win_options = {
      winblend = 0,
      winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
      wrap = true,
    },
  })

  local component_heights = get_component_heights(config.options.ui.output_popup_height)
  state.layout = Layout(
    {
      relative = "editor",
      position = {
        row = component_heights.starting_row,
        col = "100%",
      },
      size = {
        width = config.options.ui.width .. "%",
        height = component_heights.layout,
      },
    },
    Layout.Box({
      Layout.Box(state.output_popup, { size = component_heights.output }),
      Layout.Box(state.input_popup, { size = component_heights.prompt }),
    }, { dir = "col" })
  )
end

return { create_components = create_components }
