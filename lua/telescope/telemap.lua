local commands = require("plugs.config.telescope.commands")
local leaderf = require("plugs.config.telescope.leaderf")
local async = require("plenary.async")

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

local telemap = {
  leaderf = {
    opts = function(user_opts)
      local theme_name = user_opts and user_opts.theme or "dropdown"
      return {
        prompt_title = "Buffers",
        theme = theme_name,
        entry_maker = leaderf.gen_from_buffer_like_leaderf(),
      }
    end,
    cmd = function(opts)
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
    cmd = { "builtin", "fd" },
  },
  builtin_find_files = {
    opts = function(user_opts)
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
    opts = function(user_opts)
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
    end,
  },
}

return telemap
