require("ui").setup({
  popupmenu = {
    enable = false,
    winconfig = {},
    tooltip = nil,
    styles = {
      default = {
        padding_left = " ",
        padding_right = " ",
        icon = nil,
        text = nil,
        normal_hl = nil,
        select_hl = "CursorLine",
        icon_hl = nil,
      },
      example = {
        condition = function()
          return true
        end,
        icon = "I ",
      },
    },
  },
  cmdline = {
    enable = false,
    styles = {
      default = {
        cursor = "Cursor",
        filetype = "vim",
        icon = { { "I ", "@comment" } },
        offset = 0,
        title = nil,
        winhl = "",
      },
      example = {
        condition = function()
          return true
        end,
        cursor = "@comment",
      },
    },
  },
  message = {
    enable = false,
    wrap_notify = true,
    respect_replace_last = true,
    message_winconfig = {},
    list_winconfig = {},
    confirm_winconfig = {},
    history_winconfig = {},
    ignore = function()
      return false
    end,
    showcmd = {
      max_width = 10,
      modifier = nil,
    },
    msg_styles = {
      default = {
        duration = 500,
        modifier = nil,
        decorations = {
          icon = { { "I " } },
        },
      },
      example = {
        condition = function()
          return true
        end,
        decorations = {
          icon = { { "B " } },
        },
      },
    },
    is_list = function()
      return false
    end,
    list_styles = {
      default = {
        modifier = nil,
        row = nil,
        col = nil,
        width = nil,
        height = nil,
        winhl = nil,
      },
      example = {
        condition = function()
          return true
        end,
        border = "rounded",
      },
    },
    confirm_styles = {
      default = {
        modifier = nil,
        row = nil,
        col = nil,
        width = nil,
        height = nil,
        winhl = nil,
      },
      example = {
        condition = function()
          return true
        end,
        border = "rounded",
      },
    },
  },
})
