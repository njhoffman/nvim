-- SidebarNvimToggle: Open/Close the view
-- SidebarNvimClose: Close if open, otherwise no-op
-- SidebarNvimOpen: Open if closed, otherwise no-op
-- SidebarNvimUpdate: Immediately update the view and the sections
-- SidebarNvimResize size: Resize the view width to size, size is a number
-- SidebarNvimFocus: Move the cursor to the sidebar window
local defaults = {
  disable_default_keybindings = 0,
  bindings = nil,
  open = false,
  side = "left",
  initial_width = 35,
  hide_statusline = false,
  update_interval = 1000,
  sections = { "datetime", "git", "diagnostics" },
  section_separator = { "", "-----", "" },
  section_title_separator = { "" },
  containers = {
    attach_shell = "/bin/sh",
    show_all = true,
    interval = 5000,
  },
  datetime = { format = "%a %b %d, %H:%M", clocks = { { name = "local" } } },
  todos = { ignored_paths = { "~" } },
}

local config = {
  side = "right",
  -- sections = { "datetime", "git", "diagnostics", "todos", "containers", "buffers", "files", "symbols" },
  sections = { "diagnostics", "todos", "buffers", "containers" },
  bindings = {
    ["q"] = function()
      require("sidebar-nvim").close()
    end,
  },
}
require("sidebar-nvim").setup(config)
