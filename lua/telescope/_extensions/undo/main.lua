local finders = require('telescope.finders')
local pickers = require('telescope.pickers')
local conf = require('telescope.config').values

local get_previewer = require('telescope._extensions.undo.previewer')
local entry_maker = require('telescope._extensions.undo.entry_maker')
local build_undolist = require('telescope._extensions.undo.generate')

local setup_highlights = function()
  local pfx = 'TelescopeUndo'
  vim.api.nvim_set_hl(0, pfx .. 'ID', { default = true, link = 'Comment' })
  vim.api.nvim_set_hl(0, pfx .. 'Node', { default = true, link = 'TelescopeNormal' })
  vim.api.nvim_set_hl(0, pfx .. 'NodeSaved', { default = true, link = 'TelescopeNormal' })
  vim.api.nvim_set_hl(0, pfx .. 'NodeCurrent', { default = true, link = 'TelescopeNormal' })
  vim.api.nvim_set_hl(0, pfx .. 'Stat', { fg = '#007799', italic = true })
  vim.api.nvim_set_hl(0, pfx .. 'StatAdd', { fg = '#007799', italic = true })
  vim.api.nvim_set_hl(0, pfx .. 'StatDel', { fg = '#007799', italic = true })
  vim.api.nvim_set_hl(0, pfx .. 'Time', { fg = '#007799', italic = true })
  vim.api.nvim_set_hl(0, pfx .. 'Prefix', { fg = '#007799', italic = true })
  -- vim.api.nvim_set_hl(0, 'TelescopeProjectGroupRecent', { link = 'Constant', italic = true })
end

local undo = function(opts)
  if not vim.api.nvim_buf_get_option(0, 'modifiable') then
    print('telescope-undo.nvim: Current buffer is not modifiable.')
    return
  end
  opts = opts or {}
  pickers
    .new(opts, {
      prompt_title = 'Undo History',
      finder = finders.new_table({
        results = build_undolist(opts),
        entry_maker = entry_maker(opts),
      }),
      previewer = get_previewer(opts),
      sorter = conf.generic_sorter(opts),
      attach_mappings = function(prompt_bufnr, map)
        for _, mode in pairs({ 'i', 'n' }) do
          for key, get_action in pairs(opts.mappings[mode] or {}) do
            map(mode, key, get_action(prompt_bufnr))
          end
        end
        -- TODO: provide means to filter for time frames
        return true -- include defaults as well
      end,
    })
    :find()
end

return { undo = undo, setup_highlights = setup_highlights }
