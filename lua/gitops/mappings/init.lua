local utils = require('telescope.utils')
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local git_utils = require('gitops.utils.git')
local logger = require('gitops.utils.logger')
local Path = require('plenary.path')

-- Map a key to both insert and normal modes
local function omnimap(map_func, key, handler)
  map_func('i', key, handler)
  map_func('n', key, handler)
end

local transfrom_file = function(opts)
  return opts.current_file and Path:new(opts.current_file):make_relative(opts.cwd) or ''
end

local get_buffer_of_orig = function(selection, opts)
  local value = selection.value .. ':' .. transfrom_file()
  local command = git_utils.init_git_command(opts.bufnr, {
    '--no-pager',
    'show',
    value,
  })

  local content = utils.get_os_command_output(command, opts.cwd)

  local _bufnr = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(_bufnr, 0, -1, false, content)
  vim.api.nvim_buf_set_name(_bufnr, 'Original')
  return _bufnr
end

local vimdiff = function(selection, cmd, opts)
  local ft = vim.bo.filetype
  vim.cmd('diffthis')

  local _bufnr = get_buffer_of_orig(selection)
  vim.cmd(string.format('%s %s', cmd, _bufnr))
  vim.bo.filetype = ft
  vim.cmd('diffthis')

  vim.api.nvim_create_autocmd('WinClosed', {
    buffer = opts.bufnr,
    nested = true,
    once = true,
    callback = function()
      vim.api.nvim_buf_delete(_bufnr, { force = true })
    end,
  })
end

local build_mappings = function(opts)
  return function(_, _) -- prompt_bufnr, map
    --   actions.select_default:replace(actions.git_checkout)
    --   map({ "i", "n" }, "<c-r>m", actions.git_reset_mixed)
    --   map({ "i", "n" }, "<c-r>s", actions.git_reset_soft)
    --   map({ "i", "n" }, "<c-r>h", actions.git_reset_hard)
    --- Checkout a specific file for a given sha
    ---@param prompt_bufnr number: The prompt bufnr
    local git_checkout_current_buffer = function(prompt_bufnr)
      local cwd = action_state.get_current_picker(prompt_bufnr).cwd
      local selection = action_state.get_selected_entry()
      if selection == nil then
        utils.__warn_no_selection('actions.git_checkout_current_buffer')
        return
      end
      actions.close(prompt_bufnr)
      local command = git_utils.init_git_command(opts.bufnr, {
        'checkout',
        selection.value.sha,
        '--',
        selection.current_file,
      })
      utils.get_os_command_output(command, cwd)
      logger.info('checkout (cwd ' .. cwd .. ')\n  ' .. vim.fn.join(command, '\n  '))
      vim.cmd('checktime')
    end

    actions.select_default:replace(git_checkout_current_buffer)

    actions.select_vertical:replace(function(prompt_bufnr)
      actions.close(prompt_bufnr)
      local selection = action_state.get_selected_entry()
      vimdiff(selection, 'leftabove vert sbuffer', opts)
    end)

    actions.select_horizontal:replace(function(prompt_bufnr)
      actions.close(prompt_bufnr)
      local selection = action_state.get_selected_entry()
      vimdiff(selection, 'belowright sbuffer', opts)
    end)

    actions.select_tab:replace(function(prompt_bufnr)
      actions.close(prompt_bufnr)
      local selection = action_state.get_selected_entry()
      vim.cmd('tabedit ' .. transfrom_file(opts))
      vimdiff(selection, 'leftabove vert sbuffer', opts)
    end)
    return true
  end
end

return { build_mappings = build_mappings, omnimap = omnimap }
