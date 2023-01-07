-- vim.ui.input(opts, on_confirm)
-- vim.ui.select(items, opts, on_choice)
--   opts.prompt = opts.prompt or "Select one of:"
--   opts.format_item = opts.format_item or tostring

local defaults = {
  input = {
    -- Set to false to disable the vim.ui.input implementation
    enabled = true,
    -- Default prompt string
    default_prompt = "Input:",
    -- Can be 'left', 'right', or 'center'
    prompt_align = "left",
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
    max_width = { 180, 0.9 },
    min_width = { 20, 0.2 },
    win_options = {
      -- Window transparency (0-100)
      winblend = 10,
      -- Change default highlight groups (see :help winhl)
      winhighlight = "",
    },
    override = function(conf)
      -- This is the config that will be passed to nvim_open_win.
      -- Change values here to customize the layout
      return conf
    end,
    -- see :help dressing_get_config
    get_config = nil,
  },
  select = {
    -- Set to false to disable the vim.ui.select implementation
    enabled = true,
    -- Priority list of preferred vim.select implementations
    -- backend = { "builtin", "nui", "telescope" },
    backend = { "nui" },
    -- Options for telescope selector
    -- These are passed into the telescope picker directly. Can be used like:
    -- telescope = require('telescope.themes').get_ivy({...})
    telescope = require("telescope.themes").get_dropdown(),
    -- Options for fzf selector
    fzf = {
      window = {
        width = 0.5,
        height = 0.4,
      },
    },
    -- Options for fzf_lua selector
    fzf_lua = {
      winopts = {
        width = 0.5,
        height = 0.4,
      },
    },
    -- Options for nui Menu
    nui = {
      position = "50%",
      relative = "editor",
      border = {
        style = "rounded",
      },
      min_width = 15,
      min_height = 1,
      max_width = 120,
      max_height = 40,
    },
    -- Options for built-in selector
    builtin = {
      -- These are passed to nvim_open_win
      anchor = "NW",
      border = "rounded",
      -- 'editor' and 'win' will default to being centered
      relative = "editor",
      win_options = {
        -- Window transparency (0-100)
        winblend = 10,
        -- Change default highlight groups (see :help winhl)
        winhighlight = "",
      },
      -- These can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
      -- the min_ and max_ options can be a list of mixed types.
      -- max_width = {140, 0.8} means "the lesser of 140 columns or 80% of total"
      width = nil,
      max_width = { 140, 0.8 },
      min_width = { 40, 0.2 },
      height = nil,
      max_height = 0.9,
      min_height = { 10, 0.2 },
      override = function(conf)
        -- This is the config that will be passed to nvim_open_win.
        -- Change values here to customize the layout
        return conf
      end,
    },
    -- Used to override format_item. See :help dressing-format
    format_item_override = {},
    -- see :help dressing_get_config
    get_config = nil,
  },
}

require("dressing").setup(defaults)

vim.ui._test_input = function(cb)
  local opts = {
    prompt = "Enter an input: ",
    default = "placeholder text",
  }
  vim.ui.input(opts, function(x)
    print("Entered ", x)
    if cb then
      cb(x)
    end
  end)
end

local test_select = function(backend_name, cb)
  local backend_opt = defaults.select[backend_name]

  local ok, backend = pcall(require, string.format("dressing.select.%s", backend_name))
  if not ok or not backend.is_supported() then
    vim.notify({ "Error loading backend", backend }, error)
  end

  local items = {
    { name = "Item 1" },
    { name = "Item 2" },
    { name = "Item 3" },
  }
  local opts = {
    format_item = function(entry)
      return entry.name
    end,
  }
  local selected
  opts.prompt = opts.prompt or "Title Test"
  backend.select(backend_opt, items, opts, function(item)
    selected = item
    if selected then
      print("made selection with " .. backend_name .. " - " .. selected.name)
    end
    if cb then
      cb(selected)
    end
  end)
end

vim.ui._test_select_telescope = function(cb)
  test_select("telescope", cb)
end

vim.ui._test_select_nui = function(cb)
  test_select("nui", cb)
end

vim.ui._test_select_builtin = function(cb)
  test_select("builtin", cb)
end

vim.ui._test_select = function(_cb)
  cb = _cb or function(sel)
    print("Selected ", vim.inspect(sel))
  end
  vim.ui._test_select_builtin(cb)
  -- vim.ui._test_select_telescope(cb)
  -- vim.ui._test_select_nui(cb)
end

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
