local config = {}

local defaults = {
  -- global defaults, line defaults?
  panel_defaults = {
    style = 'default',
    spacing = 5,
    label_highlight = "MoreMsg",
    value_highlight = "Constant",
  },
  popup_defaults = {
    position = { row = '90%', col = "100%"},
    enter = false,
    focusable = false,
    zindex = 50,
    relative = "editor",
    border = {
      highlight = "FloatBorder",
      padding = {
        top = 1,
        bottom = 1,
        left = 1,
        right = 1,
      },
      style = "rounded",
      text = {
        top = "InfoWindow",
        top_align = "center",
      },
    },
    -- buf_options = {
    --   modifiable = false,
    --   readonly = true,
    -- },
    win_options = {
      winblend = 50,
      winhighlight = "Normal:Normal",
    },
  }

}
local test_infopanels = function(args)
  local funcs = args.funcs
  local infopanels = args.infopanels

  -- vim.tbl_deep_extend("keep", if_nil(config.values[name], {}), if_nil(default_val, {}))
  local lines = {
  startup = { "Startup Time", funcs.get_startup_time },
  rss = { "Memory (RSS)", funcs.get_memory_rss, { timer = 10 } },
  vsz = { "Memory (VSZ)", funcs.get_memory_vsz , { timer = 10 } },
  filetype = { "Filetype", vim.api.nvim_eval('&filetype'), { timer = 10 } },
  augroups = { "AuGroups", funcs.get_augroups, { timer = 10 } },
  aucommands = { "AuCommands", funcs.get_aucommands, { timer = 10 } },

  -- -- string.format('Changes              %4d', env_counts.changes),
  -- string.format('Commands             %4d', env_counts.commands),
  -- string.format('Functions            %4d', env_counts.functions),
  -- string.format('Highlights           %4d', env_counts.highlights),
  -- -- string.format('History              %4d', env_counts.history_commands),
  -- -- string.format('Menus                %4d', env_counts.menus),
  -- string.format('Messages             %4d', env_counts.messages),
  -- string.format('Scriptnames          %4d', env_counts.scriptnames),
  -- -- string.format('Options              %4d', env_counts.options),
  -- string.format('Syntax Items         %4d', env_counts.syntax_items),
  -- string.format('Variables            %4d', env_counts.variables),
  -- string.format('Packer Lines         %4s', env_counts.packer_lines),
  -- string.format('Plugins Size         %4s', env_counts.plugins_size),
  }


  local if_nil = vim.F.if_nil

  local panel1 = {
    name = 'Buffer',
    popup = {},
    lines = { lines.filetype, lines.augroups, lines.aucommands }
  }
  panel1 = vim.tbl_deep_extend("keep", panel1, defaults.panel_defaults)
  panel1.popup = vim.tbl_deep_extend("keep", panel1.popup, defaults.popup_defaults)

  local panel2 = {
    name = 'Processes',
    popup = {},
    lines = { lines.startup, lines.rss, lines.vsz }
  }
  panel2 = vim.tbl_deep_extend("keep", panel2, defaults.panel_defaults)
  panel2.popup = vim.tbl_deep_extend("keep", panel2.popup, defaults.popup_defaults)

  local panels = { panel1, panel2 }

  local results = infopanels.setup(panels)
  return results
end

local load = function(method, args, desc)
  local ok, ret = pcall(method, args)
  if not ok then
    local title = desc .. " - " .. " failed"
    -- vim.cmd("echom 'ERROR - " .. title .. "'")
    -- vim.dbg({ ret }, { title = title })
    error(title)
  end
  return ret
end

local infopanels = load(require, 'infopanels', "require infopanels")
local funcs = load(require, 'infopanels.funcs', "require funcs")
local results = load(test_infopanels, { infopanels = infopanels, funcs = funcs }, "test_infopanels")


results[1].open()
-- vim.dbg(vim.inspect(results[1]))
-- lua vim.lsp.util.set_qflist({ { text = "one"}, { text = "two"}, { text = "three" } })

-- bufnr	buffer number; must be the number of a valid
-- buffer
-- filename	name of a file; only used when "bufnr" is not
-- present or it is invalid.
-- module	name of a module; if given it will be used in
-- quickfix error window instead of the filename
-- lnum	line number in the file
-- pattern	search pattern used to locate the error
-- col		column number
-- vcol	when non-zero: "col" is visual column
-- when zero: "col" is byte index
-- nr		error number
-- text	description of the error
-- type	single-character error type, 'E', 'W', etc.
-- valid	recognized error message
