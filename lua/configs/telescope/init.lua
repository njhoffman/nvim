local telescope = require("telescope")
local logger = require("logger").init("telescope")

local launcher = require("configs.telescope.launcher")
telescope.run = launcher

local internal = require("telescope.builtin.__internal")
internal.reloader = require("configs.telescope.reloader")

local commands = require("configs.telescope.commands")
local mappings = require("configs.telescope.mappings")
local pickers = require("configs.telescope.pickers")
local extensions = require("configs.telescope.extensions")

local horizontal_preview_width = function(_, cols, _)
  if cols > 200 then
    return math.floor(cols * 0.6)
  else
    return math.floor(cols * 0.5)
  end
end

local basecfg = {
  scrolling_limit = 20000,
  debug = false,
  enable_timing = true,
  debounce = 50,
  wrap_results = false,
  selection_caret = "▌ ", -- ▶  ┃ ▌󰒆 ▇
  multi_icon = "┃", --  '◆ 󰒆 ',
  prompt_prefix = " 🔍 ", -- " 🔍 ",'   '

  hl_result_eol = true,
  cycle_layout_list = { "flex", "horizontal", "vertical", "bottom_pane", "center" },
  git_worktrees = {
    {
      toplevel = vim.env.HOME,
      gitdir = vim.env.HOME .. "/.cfg",
    },
  },
  file_ignore_patterns = { "^.git/" },

  set_env = {
    DFT_DISPLAY = "inline",
    LESS = "",
    DELTA_PAGER = "/usr/bin/cat",
  },

  layout_config = {
    prompt_position = "top",
    preview_cutoff = 30,
    width = function(_, cols, _)
      return math.floor(0.90 * cols)
    end,
    height = function(_, _, rows)
      return math.floor(0.95 * rows)
    end,
    horizontal = {
      preview_cutoff = 120,
      preview_width = horizontal_preview_width,
    },
    vertical = {
      width = 0.85,
      height = 0.95,
      preview_height = 0.4,
    },
    bottom_pane = {
      preview_cutoff = 120,
    },
    flex = {
      horizontal = {
        mirror = false,
      },
      vertical = {
        mirror = true,
      },
    },
  },
  preview = {
    hide_on_startup = vim.o.columns < 80,
    filesize_limit = 25,
    timeout = 1500,
    filesize_hook = function(filepath, bufnr, opts)
      local path = require("plenary.path"):new(filepath)
      local height = vim.api.nvim_win_get_height(opts.winid) * 3 / 2
      local lines = vim.split(path:head(height), "[\r]?\n")
      vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
      vim.api.nvim_set_option_value("ft", opts.ft, { buf = bufnr })
    end,
    timeout_hook = function(filepath, bufnr, opts)
      local path = require("plenary.path"):new(filepath)
      local height = vim.api.nvim_win_get_height(opts.winid) * 3 / 2
      local lines = vim.split(path:head(height), "[\r]?\n")
      vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
    end,
  },
  cache_picker = {
    num_pickers = 10,
    limit_entries = 10000,
  },
  history = {
    handler = require("telescope._extensions.pickers_history.handler").get_history,
    path = vim.fn.stdpath("data") .. "/databases/telescope_history.sqlite3",
    limit = 2000,
  },
  on_complete = {
    require("configs.telescope.on_complete"),
  },
  vimgrep_arguments = commands.vimgrep,
  find_command = commands.rg,
  selection_strategy = "reset",
  sorting_strategy = "ascending",
  scroll_strategy = "cycle",
  color_devicons = true,
  use_less = true,
  mappings = mappings.main,
  path_display = { "smart" },
  generic_sorter = require("mini.fuzzy").get_telescope_sorter,
  file_sorter = require("mini.fuzzy").get_telescope_sorter,
  include_extensions = true,
}

vim.api.nvim_create_augroup("Hacks", { clear = true })
vim.api.nvim_create_autocmd("VimEnter", {
  pattern = "*",
  callback = function()
    local defaults = vim.tbl_deep_extend("force", basecfg, require("telescope._layouts.default"))
    local telescope_config = {
      defaults = defaults,
      pickers = pickers,
      extensions = extensions.get(),
    }
    if telescope_config.debug then
      logger:info("pre-layout: ", vim.inspect(telescope_config.defaults.layout_config))
    end

    telescope.setup(telescope_config)

    if telescope_config.debug then
      logger:info("post-layout: ", vim.inspect(require("telescope.config").values.layout_config))
    end

    extensions.load()
  end,
  desc = "Create startup time notification when vim is finished loading",
})

vim.api.nvim_create_autocmd("VimResized", {
  pattern = "*",
  callback = function()
    if require("telescope.config").values.debug then
      logger:info("size: " .. vim.o.columns .. "x" .. vim.o.lines)
    end
  end,
  desc = "Create startup time notification when vim is finished loading",
})
