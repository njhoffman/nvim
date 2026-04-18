local custom_actions = {
  toggle_preview_wrap = function(picker)
    if picker.preview.win:valid() then
      vim.dbglog(picker.preview.win.wo)
    end
  end,
}
local picker_cfg = {
  prompt = " ",
  win = {
    input = {
      keys = {
        ["<Esc>"] = "close",
        ["<M-/>"] = { "toggle_preview", mode = { "i", "n" } },
        ["<M-?>"] = { "toggle_help_list", mode = { "i", "n" } },
        ["<c-f>"] = { "list_scroll_down", mode = { "i", "n" } },
        ["<c-b>"] = { "list_scroll_up", mode = { "i", "n" } },
        ["<M-b>"] = { "preview_scroll_up", mode = { "i", "n" } },
        ["<M-f>"] = { "preview_scroll_down", mode = { "i", "n" } },
        ["<M-P>"] = { "select_and_prev", mode = { "i", "n" } },
        ["<M-n>"] = { "select_and_next", mode = { "i", "n" } },
        ["<M-a>"] = { "select_all", mode = { "n", "i" } },
        ["<C-G>"] = { "list_scroll_top", mode = { "n", "i" } },
        ["<C-Space>"] = { "toggle_live", mode = { "i", "n" } },
        ["<C-Tab>"] = { "cycle_win", mode = { "i", "n" } },
        ["<M-C-H>"] = { "layout_left", mode = { "n", "i" } },
        ["<M-C-L>"] = { "layout_right", mode = { "n", "i" } },
        ["<M-NL>"] = { "layout_bottom", mode = { "n", "i" } },
        ["<M-C-K>"] = { "layout_top", mode = { "n", "i" } },
        ["<M-C-O>"] = { "toggle_maximize", mode = { "i", "n" } },
        ["<C-u>"] = { "<c-s-w>", mode = { "i" }, expr = true, desc = "delete word" },
      },
      b = {
        minipairs_disable = true,
      },
    },
    list = {
      keys = {
        ["<M-C-H>"] = { "layout_left" },
        ["<M-C-L>"] = { "layout_right" },
        ["<M-NL>"] = { "layout_bottom" },
        ["<M-C-K>"] = { "layout_top" },
        ["<M-C-O>"] = { "toggle_maximize" },
        ["<c-f>"] = "list_scroll_down",
        ["<c-b>"] = "list_scroll_up",
        ["<M-/>"] = "toggle_preview",
        ["<M-?>"] = "toggle_help_list",
      },
      wo = {
        conceallevel = 2,
        concealcursor = "nvc",
      },
    },
    preview = {
      keys = {
        ["<Esc>"] = "cancel",
      },
    },
  },
}

return picker_cfg
