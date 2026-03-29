local edit_buffer = require("commands.colors.edit_buffer")
local inspector = require("commands.colors.inspector")
local visual = require("commands.colors.visual")
local colorscheme_export = require("commands.colorscheme_export")

local M = {}

function M.setup()
  local cmd = vim.api.nvim_create_user_command

  -- Open highlight editor (empty or with group names as args)
  cmd("HlEdit", function(opts)
    if opts.args ~= "" then
      local groups = {}
      for name in opts.args:gmatch("%S+") do
        table.insert(groups, { name = name })
      end
      edit_buffer.open(groups)
    else
      edit_buffer.open()
    end
  end, {
    nargs = "*",
    desc = "Open highlight editor",
    complete = function(lead)
      local all_hls = vim.api.nvim_get_hl(0, {})
      local names = vim.tbl_keys(all_hls)
      table.sort(names)
      if lead == "" then
        return names
      end
      return vim.tbl_filter(function(n)
        return n:lower():find(lead:lower(), 1, true)
      end, names)
    end,
  })

  -- Open telescope highlight picker
  cmd("HlPick", function()
    local ok, _ = pcall(require, "telescope")
    if ok then
      require("telescope").extensions.highlights.all()
    else
      vim.notify("Telescope not available", vim.log.levels.WARN)
    end
  end, { desc = "Pick highlights with telescope" })

  -- Save edit buffer to colorscheme files
  cmd("HlSave", function()
    local bufnr = edit_buffer.get_bufnr()
    if not bufnr then
      vim.notify("No highlight editor buffer open", vim.log.levels.WARN)
      return
    end
    local persistence = require("commands.colors.persistence")
    local ok, err = pcall(persistence.save, bufnr)
    if ok then
      vim.bo[bufnr].modified = false
      vim.notify("Highlights saved to colorscheme files", vim.log.levels.INFO)
    else
      vim.notify("Failed to save: " .. tostring(err), vim.log.levels.ERROR)
    end
  end, { desc = "Save highlight editor to colorscheme files" })

  -- Re-apply all highlights from edit buffer
  cmd("HlRefresh", function()
    edit_buffer.apply_all()
  end, { desc = "Re-apply all highlights from editor buffer" })

  -- Find highlight usage in open buffers
  cmd("HlInspect", function(opts)
    if opts.args == "" then
      vim.notify("Usage: :HlInspect <HighlightGroup>", vim.log.levels.WARN)
      return
    end
    inspector.find_usage(opts.args)
  end, {
    nargs = 1,
    desc = "Find highlight group usage in open buffers",
    complete = function(lead)
      local all_hls = vim.api.nvim_get_hl(0, {})
      local names = vim.tbl_keys(all_hls)
      table.sort(names)
      if lead == "" then
        return names
      end
      return vim.tbl_filter(function(n)
        return n:lower():find(lead:lower(), 1, true)
      end, names)
    end,
  })

  -- Visual selection: load highlights from selection into editor
  cmd("HlVisual", function(opts)
    visual.from_visual(opts)
  end, {
    range = true,
    desc = "Load highlights from visual selection into editor",
  })

  -- Colorscheme export (moved from top-level)
  cmd("ColorschemeExport", function(opts)
    colorscheme_export.export({
      colorscheme = opts.args ~= "" and opts.args or nil,
    })
  end, {
    nargs = "?",
    desc = "Export colorscheme to bat theme format",
    complete = function()
      local paths = vim.api.nvim_get_runtime_file("colors/*.{vim,lua}", true)
      local schemes = {}
      for _, path in ipairs(paths) do
        local scheme = path:match("colors/(.*)%..*$")
        if scheme then
          table.insert(schemes, scheme)
        end
      end
      table.sort(schemes)
      return schemes
    end,
  })
end

return M
