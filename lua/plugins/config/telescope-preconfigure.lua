local get_theme = function(theme)
  local winwidth = vim.api.nvim_win_get_width(0)

  local themes = {
    dropdown = require("telescope.themes").get_dropdown({
      winblend = 20,
      -- layout_config = { width = 0.5 },
      -- results_height = 15,
      previewer = false,
    }),
    ivy = require("telescope.themes").get_ivy({
      winblend = 20,
      layout_config = { height = 15 },
      preview = { hide_on_startup = winwidth < 120 },
    }),
    cursor = require("telescope.themes").get_cursor({
      winblend = 20,
      layout_config = { height = 15 },
    }),
  }
  return themes[theme]
end

local get_definition = function(cmd)
  local telescopes = {
    fd = {
      -- prompt_prefix = "Files>",
      theme = "ivy",
    },
  }
  return telescopes[cmd]
end

local modify_options = function(path, cmd, opts)
  local def = get_definition(cmd)
  if def then
    opts = vim.tbl_extend("force", def, opts)
  end
  if opts.theme then
    opts = vim.tbl_extend("force", get_theme(opts.theme), opts)
  end

  if path == "builtin" and cmd == "live_grep" then
    if opts.grep_open_files then
      local bufnrs = vim.tbl_filter(function(b)
        if 1 ~= vim.fn.buflisted(b) then
          return false
        end
        if not vim.api.nvim_buf_is_loaded(b) then
          return false
        end
        return true
      end, vim.api.nvim_list_bufs())
      opts.results_title = "(" .. #bufnrs .. " Buffers)"
    else
      opts.results_title = (opts.cwd or vim.fn.getcwd()):gsub(vim.fn.getenv("HOME"), "~")
    end
  elseif path == "builtin" and (cmd == "find_files" or cmd == "fd" or cmd == "live_grep") then
    opts.results_title = (opts.cwd or vim.fn.getcwd()):gsub(vim.fn.getenv("HOME"), "~")
  end
  return opts
end

local function run(modulePath, command, opts)
  local extensions = require("telescope").extensions
  local builtin = require("telescope.builtin")

  opts = modify_options(modulePath, command, opts or {})
  if modulePath == "builtin" and type(builtin[command]) == "function" then
    builtin[command](opts)
  elseif type(extensions[modulePath]) == "table" then
    extensions[modulePath][command](opts)
  else
    vim.notify('Telescope module: "' .. modulePath .. '" not found', 4)
  end
end

_G.TelescopeLoad = run

return { run = run, get_theme = get_theme }
