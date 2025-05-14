local styles = {
  normal = {
    { fg = "#005678", bg = "#001018" },
    { fg = "#4056a7", bg = "#100018" },
    { fg = "#806d9c", bg = "#180010" },
  },
  error = {
    { fg = "#7a0000", bg = "#200610" },
    { fg = "#f35336", bg = "#201410" },
  },
}
local cfg = {
  -- enable = false,
  -- style = {},
  -- notify = false,
  -- priority = 0,
  exclude_filetypes = {
    aerial = true,
    dashboard = true,
    markdown = true,
  },
  line_num = {
    enable = false,
    -- style = "#806d9c",
    -- priority = 10,
    -- use_treesitter = false,
  },
  indent = {
    enable = false,
    -- style = { vim.api.nvim_get_hl(0, { name = "Whitespace" }) },
    -- priority = 10,
    -- use_treesitter = false,
    -- chars = { "│" },
    -- ahead_lines = 5,
    -- delay = 100,
    -- filter_list = {},
  },
  blank = {
    enable = false,
    -- priority = 9,
    -- chars = { "․" },
  },
  chunk = {
    enable = true,
    priority = 10,
    use_treesitter = true,
    chars = {
      horizontal_line = "─",
      vertical_line = "│",
      left_top = "┌",
      left_bottom = "└",
      right_arrow = "─",
    },
    style = { styles.normal[1], styles.error[1] },
    textobject = "ic",
    max_file_size = 1024 * 1024,
    error_sign = true,
    -- animation related
    duration = 200,
    delay = 200,
  },
}

require("hlchunk").setup(cfg)
