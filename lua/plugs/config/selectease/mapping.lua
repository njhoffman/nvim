local keymap = {
  select_left = {
    "<M-C-Left>",
    { desc = "select left node", plugin = "SelectEase", category = "Motion" },
  },
  select_right = {
    "<M-C-Right>",
    {
      desc = "select right node",
      plugin = "SelectEase",
      category = "Motion",
    },
  },
  select_up = {
    "<M-C-Up>",
    {
      desc = "select up node",
      plugin = "SelectEase",
      category = "Motion",
    },
  },
  select_down = {
    "<M-C-Down>",
    { desc = "select down node", plugin = "SelectEase", category = "Motion" },
  },
  swap_left = {
    "<M-C-S-Left>",
    {
      desc = "swap left node",
      plugin = "SelectEase",
      category = "Motion",
    },
  },
  swap_right = {
    "<M-C-S-Right>",
    { desc = "swap right node", plugin = "SelectEase", category = "Motion" },
  },
  swap_up = {
    "<M-C-S-Up>",
    {
      desc = "swap up node",
      plugin = "SelectEase",
      category = "Motion",
    },
  },
  swap_down = {
    "<M-C-S-Down>",
    { desc = "swap down node", plugin = "SelectEase", category = "Motion" },
  },
}

return keymap
