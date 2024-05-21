-- https://github.com/folke/flash.nvim/discussions/79

local lib = require('movement.flash.nav')
local Flash = lambda.reqidx('flash')

--  'gt' - go to definition
-- 'gT' - go to type definition
-- 'gr' - references
-- 'gd' - go to declaration

local jump_def_restore = function()
  local prev_timeout = vim.opt.timeout
  vim.opt.timeout = false
  Flash.jump({
    action = function(match, state)
      state:hide()

      local row, col = unpack(vim.api.nvim_win_get_cursor(0))

      vim.api.nvim_set_current_win(match.win)
      vim.api.nvim_win_set_cursor(match.win, match.pos)

      local key = vim.api.nvim_replace_termcodes('<Ignore>' .. 'g', true, true, true)

      vim.api.nvim_feedkeys(key, 'i', false)

      vim.schedule(function()
        vim.api.nvim_win_set_cursor(match.win, { row, col })
        vim.opt.timeout = prev_timeout
        require('flash.jump').restore_remote(state)
      end)
    end,
    search = {
      max_length = 2,
    },
    label = {
      before = { 0, 2 },
      after = false,
    },
  })
end

local jump_hover = function()
  Flash.jump({ mode = 'hover' })
end

local jump_references = function() end

local jump_diag_lspsaga = function()
  vim.cmd.Lspsaga('show_cursor_diagnostics')
end

local jump_diag_wtf_ai = function()
  lib.flash_diagnostics({
    action = function()
      require('wtf').ai()
    end,
  })
end

local search_diag_and_back = function()
  Flash.jump({
    mode = 'search_diagnostics',
    search = { mode = 'fuzzy' },
    action = lib.there_and_back(lsp_utils.diag_line),
  })
end

local search_diag_wtf = function()
  lib.flash_diagnostics({
    action = function()
      require('wtf').search()
    end,
  })
end

local jump_diag_code_action = function()
  lib.flash_diagnostics({
    action = require('actions-preview').code_actions,
  })
end

--stylua: ignore
return {
  jump_definition       = jump_def_restore,
  jump_hover            = jump_hover,
  jump_references       = lib.flash_references,
  jump_diag_lspsaga     = jump_diag_lspsaga,
  jump_diag_wtf_ai      = jump_diag_wtf_ai,
  jump_diag_code_action = jump_diag_code_action,
  search_diag_and_back  = search_diag_and_back,
  search_diag_wtf       = search_diag_wtf,
}
