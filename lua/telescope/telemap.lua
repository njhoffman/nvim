local leaderf = require("plugs.config.telescope.leaderf")

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
      local directory = vim.fn.expand("%:h") == "" and os.getenv("HOME") or vim.fn.expand("%:h")
      return {
        results_title = (user_opts.cwd or vim.fn.getcwd()):gsub(vim.fn.getenv("HOME"), "~"),
        cwd = directory,
      }
    end,
    cmd = { "builtin", "fd" },
  },
  builtin_find_files = {
    opts = function(user_opts)
      return {
        results_title = (user_opts.cwd or vim.fn.getcwd()):gsub(vim.fn.getenv("HOME"), "~"),
      }
    end,
  },
  builtin_fd = {
    opts = function(user_opts)
      return {
        results_title = (user_opts.cwd or vim.fn.getcwd()):gsub(vim.fn.getenv("HOME"), "~"),
      }
    end,
  },
  builtin_live_grep = {
    opts = function(user_opts)
      local map_opts = {}
      if user_opts.grep_open_files then
        local bufnrs = vim.tbl_filter(function(b)
          if 1 ~= vim.fn.buflisted(b) then
            return false
          end
          if not vim.api.nvim_buf_is_loaded(b) then
            return false
          end
          return true
        end, vim.api.nvim_list_bufs())
        map_opts.results_title = "(" .. #bufnrs .. " Buffers)"
      end
      return map_opts
    end,
  },
}

return telemap
