-- vim.ui.input(opts, on_confirm)
-- vim.ui.select(items, opts, on_choice)
--   opts.prompt = opts.prompt or "Select one of:"
--   opts.format_item = opts.format_item or tostring
local defaults = {
  input = {
    -- Set to false to disable the vim.ui.input implementation
    enabled = true,
    -- Default prompt string
    default_prompt = "➤ ",
    -- When true, <Esc> will close the modal
    insert_only = true,
    -- These are passed to nvim_open_win
    anchor = "SW",
    border = "rounded",
    -- 'editor' and 'win' will default to being centered
    relative = "cursor",
    -- These can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
    prefer_width = 40,
    width = nil,
    -- min_width and max_width can be a list of mixed types.
    -- min_width = {20, 0.2} means "the greater of 20 columns or 20% of total"
    max_width = {140, 0.9},
    min_width = {20, 0.2},
    -- Window transparency (0-100)
    winblend = 10,
    -- Change default highlight groups (see :help winhl)
    winhighlight = "",
    override = function(conf)
      -- This is the config that will be passed to nvim_open_win.
      -- Change values here to customize the layout
      return conf
    end,
    -- see :help dressing_get_config
    get_config = nil
  },
  select = {
    -- Set to false to disable the vim.ui.select implementation
    enabled = true,
    -- Priority list of preferred vim.select implementations
    backend = {"telescope", "fzf_lua", "fzf", "builtin", "nui"},
    -- Options for telescope selector
    telescope = {
      -- can be 'dropdown', 'cursor', or 'ivy'
      -- or you can use a configuration directly:
      -- theme = require('telescope.themes').get_ivy({...})
      theme = "dropdown"
    },
    -- Options for fzf selector
    fzf = {
      window = {
        width = 0.5,
        height = 0.4
      }
    },
    -- Options for fzf_lua selector
    fzf_lua = {
      winopts = {
        width = 0.5,
        height = 0.4
      }
    },
    -- Options for nui Menu
    nui = {
      position = "50%",
      size = nil,
      relative = "editor",
      border = {
        style = "rounded"
      },
      max_width = 80,
      max_height = 40
    },
    -- Options for built-in selector
    builtin = {
      -- These are passed to nvim_open_win
      anchor = "NW",
      border = "rounded",
      -- 'editor' and 'win' will default to being centered
      relative = "editor",
      -- Window transparency (0-100)
      winblend = 10,
      -- Change default highlight groups (see :help winhl)
      winhighlight = "",
      -- These can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
      -- the min_ and max_ options can be a list of mixed types.
      -- max_width = {140, 0.8} means "the lesser of 140 columns or 80% of total"
      width = nil,
      max_width = {140, 0.8},
      min_width = {40, 0.2},
      height = nil,
      max_height = 0.9,
      min_height = {10, 0.2},
      override = function(conf)
        -- This is the config that will be passed to nvim_open_win.
        -- Change values here to customize the layout
        return conf
      end
    },
    -- Used to override format_item. See :help dressing-format
    format_item_override = {},
    -- see :help dressing_get_config
    get_config = nil
  }
}

require("dressing").setup(defaults)

local M = {}
M.test_input = function(cb)
  local opts = {
    prompt = "Enter an input: ",
    default = "placeholder text"
  }
  local choices
  vim.ui.input(
    opts,
    function(x)
      print("Entered ", x)
      if cb then
        cb(x)
      end
    end
  )
end

local test_select = function(backend, backend_opt, cb)
  local items = {
    {name = "Item 1"},
    {name = "Item 2"},
    {name = "Item 3"}
  }
  local opts = {
    format_item = function(entry)
      return entry.name
    end
  }
  local selected
  opts.prompt = opts.prompt or "Title Test"
  backend.select( backend_opt, items, opts,
    function(item)
      selected = item
      if selected then
        print("made selection with " .. backend .. " - " .. selected.name)
      end
      if cb then cb(selected) end
    end
  )
end

_G.test_select = function(cb)
  cb = cb or function(sel)
      print("Selected " .. sel)
    end
  test_select("telescope", cb)
end

_G.test_select_telescope = function(cb)
  local backend = require("dressing.select.telescope")
  test_select(backend, defaults.select["telescope"], cb)
end

_G.test_select_nui = function(cb)
  local backend = require("dressing.select.nui")
  test_select(backend, defaults.select["nui"], cb)
end

_G.test_select_builtin = function(cb)
  local backend = require("dressing.select.builtin")
  test_select(backend, defaults.select["builtin"], cb)
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
