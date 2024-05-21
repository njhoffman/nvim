local full_opts = {
  on_open = function()
    vim.api.nvim_buf_set_var(0, 'miniindentscope_disable', true)
    vim.api.nvim_buf_set_var(0, 'indent_blankline_enabled', false)
  end,
  on_close = function()
    vim.api.nvim_buf_set_var(0, 'miniindentscope_disable', false)
    vim.api.nvim_buf_set_var(0, 'indent_blankline_enabled', true)
    vim.api.nvim_win_set_option(0, 'cursorline', true)
  end,
  window = {
    backdrop = 0.85, -- shade the backdrop of the Zen window. Set to 1 to keep the same as Normal
    width = 120, -- width of the Zen window
    height = 1, -- height of the Zen window
    options = {
      signcolumn = 'no', -- disable signcolumn
      number = false, -- disable number column
      relativenumber = false, -- disable relative numbers
      cursorline = false, -- disable cursorline
      cursorcolumn = false, -- disable cursor column
      foldcolumn = '0', -- disable fold column
      list = false, -- disable whitespace characters
    },
  },
  plugins = {
    options = {
      enabled = true,
      ruler = false, -- disables the ruler text in the cmd line area
      showcmd = false, -- disables the command in the last line of the screen
    },
    gitsigns = { enabled = true },
    tmux = { enabled = true },
    alacritty = {
      enabled = false,
      font = '9', -- font size
    },
    twilight = { enabled = false }, -- enable to start Twilight when zen mode opens
  },
}

local min_opts =
  vim.tbl_deep_extend('force', full_opts, { plugins = { tmux = { enabled = false } } })

-- vim.keymap.set('n', '<CR>', function()
--   if vim.bo.filetype ~= 'noice' then
--     require('zen-mode').toggle(min_opts)
--   end
-- end, { nowait = true })
--
-- vim.keymap.set('n', '<S-CR>', function()
--   if vim.bo.filetype ~= 'noice' then
--     require('zen-mode').toggle(full_opts)
--   end
-- end, { nowait = true })

-- vim.cmd("nnoremap <CR> :ZenMode<CR>")
-- require("zen-mode").toggle(
--   {
--     window = {
--       width = .85 -- width will be 85% of the editor width
--     }
--   }
-- )

-- function M.tmux(state, disable, opts)
--   if not vim.env.TMUX then
--     return
--   end
--   if disable then
--     local function get_tmux_opt(option)
--       local option_scope = "-w"
--       local option_raw = vim.fn.system([[tmux show -w ]] .. option)
--       if option_raw == "" then
--         option_scope = "-g"
--         option_raw = vim.fn.system([[tmux show -g ]] .. option)
--       end
--       local opt = vim.split(vim.trim(option_raw), " ")[2]
--       return opt, option_scope
--     end
--     state.status, state.scope = get_tmux_opt("status")
--     state.pane = get_tmux_opt("pane-border-status")
--
--     vim.fn.system([[tmux set -w pane-border-status off]])
--     if state.scope == "-w" then
--       vim.fn.system([[tmux set -w status off]])
--     else
--       vim.fn.system([[tmux set -g status off]])
--     end
--     vim.fn.system([[tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z]])
--   else
--     if type(state.pane) == "string" then
--       vim.fn.system(string.format([[tmux set -w pane-border-status %s]], state.pane))
--     else
--       vim.fn.system([[tmux set -uw pane-border-status]])
--     end
--     if state.scope == "-w" then
--       vim.fn.system(string.format([[tmux set -w status %s]], state.status))
--     else
--       vim.fn.system(string.format([[tmux set -g status %s]], state.status))
--     end
--     vim.fn.system([[tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z]])
--   end
-- end
