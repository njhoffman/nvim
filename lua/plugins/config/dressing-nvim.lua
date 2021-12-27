
-- vim.ui.input(opts, on_confirm)
-- vim.ui.select(items, opts, on_choice)
--   opts.prompt = opts.prompt or "Select one of:"
--   opts.format_item = opts.format_item or tostring

local defaults = {
  input = {
    -- Default prompt string
    default_prompt = "➤ ",

    -- These are passed to nvim_open_win
    anchor = "SW",
    relative = "cursor",
    row = 0,
    col = 0,
    border = "rounded",

    -- These can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
    prefer_width = 40,
    max_width = nil,
    min_width = 20,

    -- see :help dressing_get_config
    get_config = nil,
  },
  select = {
    -- Priority list of preferred vim.select implementations
    backend = { "telescope", "fzf", "builtin", "nui" },

    -- Options for telescope selector
    telescope = {
      -- can be 'dropdown', 'cursor', or 'ivy'
      theme = "dropdown",
    },

    -- Options for fzf selector
    fzf = {
      window = {
        width = 0.5,
        height = 0.4,
      },
    },

    -- Options for nui Menu
    nui = {
      position = "50%",
      size = nil,
      relative = "editor",
      border = {
        style = "rounded",
      },
      max_width = 80,
      max_height = 40,
    },

    -- Options for built-in selector
    builtin = {
      -- These are passed to nvim_open_win
      anchor = "NW",
      relative = "cursor",
      row = 0,
      col = 0,
      border = "rounded",

      -- Window options
      winblend = 10,

      -- These can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
      width = nil,
      max_width = 0.8,
      min_width = 40,
      height = nil,
      max_height = 0.9,
      min_height = 10,
    },

    -- see :help dressing_get_config
    get_config = nil,
  },
}

require('dressing').setup(defaults)

local M = {}
M.test_input = function(cb)
  local opts = {
    prompt = 'Enter an input: ',
    default = 'placeholder text'
  }
  local choices
  vim.ui.input(opts, function(x)
    print("Entered ", x)
    if cb then cb(x) end
  end)
end

local test_select = function(backend, backend_opt, cb)
  local items = {
    { name = 'Item 1' },
    { name = 'Item 2' },
    { name = 'Item 3' },
  }
  local opts = {
    format_item = function(entry)
      return entry.name
    end
  }
  local selected
  backend.select(backend_opt, items, opts, function(item)
    selected = item
    if selected then
      print('made selection with ' .. backend .. ' - ' .. selected.name)
    end
    if cb then cb(selected) end
  end)
end

_G.test_select = function(cb)
  cb = cb or function(sel) print('Selected ' .. sel) end
  test_select('telescope', cb)
end

_G.test_select_telescope = function(cb)
  local backend = require("dressing.select.telescope")
  test_select(backend, defaults.select['telescope'], cb)
end

_G.test_select_nui = function(cb)
  local backend = require("dressing.select.nui")
  test_select(backend, defaults.select['nui'], cb)
end

_G.test_select_builtin = function(cb)
  local backend = require("dressing.select.builtin")
  test_select(backend, defaults.select['builtin'], cb)
end

return M

-- For each of the input and select configs, there is an option get_config.
-- This can be a function that accepts the opts parameter that is passed in to vim.select or vim.input.
-- It must return either nil (to no-op) or config values to use in place of the global config values for that module.
-- For example, if you want to use a specific configuration for code actions:
-- require('dressing').setup({
--   select = {
--     get_config = function(opts)
--       if opts.kind == 'codeaction' then
--         return {
--           backend = 'nui',
--           nui = {
--             relative = 'cursor',
--             max_width = 40,
--           }
--         }
--       end
--     end
--   }
-- })
