local commands = require("configs.telescope.commands")
local leaderf = require("configs.telescope.leaderf")
local make_entry = require("telescope.make_entry")

local get_cwd = function(user_opts)
  return (user_opts.cwd or vim.fn.getcwd()):gsub(vim.fn.getenv("HOME"), "~")
end

local file_count = function(cwd)
  local cmd = vim.fn.copy(commands.rg) or { "rg" }
  table.insert(cmd, cwd or vim.fn.getcwd() or vim.fn.getenv("HOME"))
  local output = vim.fn.system(cmd)
  local lines = vim.tbl_filter(function(line)
    return #line > 0
  end, vim.split(output, "\n"))
  return #lines
end

local get_help_word = function()
  local word = vim.fn.expand("<cWORD>") or ""
  local args_pattern = "%([^)]*%)?.*"
  local vim_pattern = "vim%.api%."
  word = string.gsub(word, args_pattern, "()")
  word = string.gsub(word, vim_pattern, "")
  return word
end

local grep_options = function(user_opts)
  if user_opts.grep_open_files then
    local bufnrs = vim.tbl_filter(function(b)
      if 1 ~= vim.fn.buflisted(b) then
        return false
      end
      if user_opts.grep_only_loaded and not vim.api.nvim_buf_is_loaded(b) then
        return false
      end
      return true
    end, vim.api.nvim_list_bufs())
    user_opts.results_title = "Buffers (" .. #bufnrs .. ")"
    user_opts.prompt_title = "Live Grep Buffers"
  else
    local count = file_count(user_opts.cwd or vim.fn.getcwd())
    user_opts.results_title = get_cwd(user_opts) .. " (" .. count .. ")"
    user_opts.prompt_title = user_opts.cwd and "Live Grep CWD" or "Live Grep Project"
  end
  return user_opts
end

local telemap = {
  leaderf = {
    opts = function(user_opts)
      local theme_name = user_opts and user_opts.theme or "dropdown"
      return {
        prompt_title = "Buffers",
        theme = theme_name,
        entry_maker = leaderf.gen_from_buffer(),
      }
    end,
    fun = function(opts)
      require("telescope.builtin").buffers(opts)
    end,
  },
  fd_cwd = {
    opts = function(user_opts)
      local directory = vim.api.nvim_buf_get_name(0):match("(.*" .. "/" .. ")")
      user_opts.cwd = directory
      return {
        results_title = get_cwd(user_opts),
        cwd = directory,
      }
    end,
    fun = { "builtin", "fd" },
  },
  projects_projects = {
    opts = {
      cache_picker = {
        disabled = true,
      },
    },
  },
  builtin_diagnostics = {
    opts = function(user_opts)
      user_opts = user_opts or {}
      if user_opts.bufnr == true or type(user_opts.bufnr) == "number" then
        user_opts.bufnr = 0
      end
      local gen_opts = {
        line_width = 0.7,
        no_sign = false,
        cwd = user_opts.cwd,
        path_display = user_opts.path_display or {
          tail = true,
          truncate = true,
        },
      }
      if user_opts.bufnr == 0 then
        gen_opts.path_display = "hidden"
      end
      return {
        bufnr = user_opts.bufnr,
        entry_maker = user_opts.entry_maker or make_entry.gen_from_diagnostics(gen_opts),
      }
    end,
  },
  find_pickers_find_pickers = {
    opts = {
      cache_picker = {
        disabled = true,
      },
    },
  },
  builtin_help_tags = {
    opts = function(user_opts)
      local opts = user_opts or {}
      opts.theme = opts.theme or "dropdown_preview"
      if opts.cursor then
        local match, word = require("utils.helptags").search_cursor_word()
        if match then
          opts.default_text = word
        end
      end
      return opts
    end,
  },
  builtin_find_files = {
    opts = function(user_opts)
      local opts = user_opts or {}
      opts.theme = opts.theme or "flex"
      return {
        results_title = get_cwd(user_opts),
      }
    end,
  },
  builtin_fd = {
    opts = function(user_opts)
      return {
        results_title = get_cwd(user_opts),
      }
    end,
  },
  builtin_live_grep = {
    opts = grep_options,
  },
  egrepify_egrepify = {
    opts = grep_options,
  },
  messages_messages = {
    opts = {
      theme = "ivy",
    },
  },
  notify_notify = {
    opts = {
      theme = "ivy",
    },
  },
}

return telemap
