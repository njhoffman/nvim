local theme = require("telescope._layouts.alternative-theme")
local tel_theme = theme.telescope

local main = tel_theme.main

local prompt = tel_theme.prompt

-- https://github.com/benlubas/.dotfiles/tree/main/nvim/lua/benlubas

-- local ivy = require("benlubas.telescope.layouts.ivy")
-- local spelling = require("benlubas.telescope.layouts.spelling")

-- vim.keymap.set("n", "<leader>ss", function()
--   require("telescope.builtin").spell_suggest({ create_layout = spelling })
-- end, { desc = "spell suggest" })
-- vim.keymap.set("n", "<leader><leader>s", ":Telescope symbols<CR>", { desc = "open symbol picker" })
-- vim.keymap.set("n", "<leader>mx", function()
--   require("benlubas.telescope.tmux").tmux_sessionizer_picker({ create_layout = ivy })
-- end, { desc = "tmux-sessionizer but telescope" })

-- vim.keymap.set("n", "<leader>tx", function()
--   require("benlubas.telescope.tmux").tmux_sessions_picker({ create_layout = ivy })
-- end, { desc = "Pick between all existing tmux sessions" })
-- vim.keymap.set("n", "<leader>*", function()
--   require("telescope.builtin").grep_string({
--     search = vim.fn.expand("<cword>"),
--     create_layout = require("benlubas.telescope.layouts.default"),
--     prompt_prefix = '"' .. vim.fn.expand("<cword>") .. '" > ',
--   })
-- end, { desc = "grep for word under cursor" })
-- vim.keymap.set("v", "<leader>*", function()
--   require("telescope.builtin").grep_string({ search = vim.getVisualSelection() })
-- end, { desc = "grep for highlighted text" })

-- require("benlubas.hydra.telescope")

---Define a custom layout for telescope. It's basically a vertical layout with better borders and
---resizing.
---@param picker any
---@return unknown
return function(picker)
  local Layout = require("nui.layout")
  local Popup = require("nui.popup")
  local TSLayout = require("telescope.pickers.layout")

  local border = {
    results = {
      top_left = "",
      top = "",
      top_right = "",
      right = "█",
      bottom_right = "▀",
      bottom = "▀",
      bottom_left = "▀",
      left = "█",
    },
    prompt = {
      top_left = "▄",
      top = "▄",
      top_right = "▄",
      right = "█",
      bottom_right = "▀",
      bottom = "▀",
      bottom_left = "▀",
      left = "█",
    },
    preview = {
      top_left = "▄",
      top = "▄",
      top_right = "▄",
      right = "█",
      bottom_right = "",
      bottom = "",
      bottom_left = "",
      left = "█",
    },
  }

  local results = Popup({
    focusable = false,
    border = {
      style = border.results,
      text = {
        top = picker.results_title,
        top_align = "center",
      },
    },
    win_options = {
      winhighlight = "Normal:TelescopeResultsNormal,FloatBorder:TelescopeResultsBorder",
    },
  })

  local prompt = Popup({
    enter = true,
    border = {
      style = border.prompt,
    },
    win_options = {
      winhighlight = "Normal:TelescopePromptNormal,FloatBorder:TelescopePromptBorder",
    },
  })

  local preview = Popup({
    focusable = false,
    border = {
      style = border.preview,
      text = {
        top = picker.prompt_title,
        top_align = "center",
      },
    },
    win_options = {
      winhighlight = "Normal:TelescopePreviewNormal,FloatBorder:TelescopePreviewBorder,FloatTitle:TelescopePreviewTitle",
    },
  })

  local box = Layout.Box({
    Layout.Box(preview, { grow = 5 }),
    Layout.Box(prompt, { size = 3 }),
    Layout.Box(results, { grow = 6 }),
  }, { dir = "col" })

  local function prepare_layout_parts(layout)
    layout.results = TSLayout.Window(results) ---@diagnostic disable-line: param-type-mismatch
    layout.prompt = TSLayout.Window(prompt) ---@diagnostic disable-line: param-type-mismatch
    layout.preview = TSLayout.Window(preview) ---@diagnostic disable-line: param-type-mismatch
  end

  local layout = Layout({
    relative = "editor",
    position = {
      row = 2,
      col = "50%",
    },
    size = {
      height = "65%",
      width = "70%",
    },
  }, box)

  layout.picker = picker
  prepare_layout_parts(layout)

  local layout_update = layout.update
  function layout:update()
    prepare_layout_parts(layout)
    layout_update(self)
  end

  return TSLayout(layout)
end
