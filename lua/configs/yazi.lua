local cfg = {
  -- enable this if you want to open yazi instead of netrw.
  -- Note that if you enable this, you need to call yazi.setup() to
  -- initialize the plugin. lazy.nvim does this for you in certain cases.
  --
  -- If you are also using neotree, you may prefer not to bring it up when
  -- opening a directory:
  -- {
  --   "nvim-neo-tree/neo-tree.nvim",
  --   opts = {
  --     filesystem = {
  --       hijack_netrw_behavior = "disabled",
  --     },
  --   },
  -- }
  open_for_directories = false,

  -- customize the keymaps that are active when yazi is open and focused. The
  -- defaults are listed below. Note that the keymaps simply hijack input and
  -- they are never sent to yazi, so only try to map keys that are never
  -- needed by yazi.
  --
  -- Also:
  -- - use e.g. `open_file_in_tab = false` to disable a keymap
  -- - you can customize only some of the keymaps (not all of them)
  -- - you can opt out of all keymaps by setting `keymaps = false`
  -- stylua: ignore
  keymaps = {
    show_help                            = "<M-/>",
    open_file_in_vertical_split          = "<c-v>",
    open_file_in_horizontal_split        = "<c-x>",
    open_file_in_tab                     = false,
    grep_in_directory                    = "<c-s>",
    replace_in_directory                 = "<c-g>",
    cycle_open_buffers                   = "<tab>",
    copy_relative_path_to_selected_files = "<c-y>",
    send_to_quickfix_list                = "<c-q>",
    change_working_directory             = "<c-\\>",
  },
}

require("yazi").setup(cfg)
