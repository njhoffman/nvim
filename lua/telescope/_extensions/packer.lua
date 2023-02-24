local has_telescope, telescope = pcall(require, "telescope")
if not has_telescope then
  error("This plugin requires nvim-telescope/telescope.nvim")
end

local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local sorters = require("telescope.sorters")
local previewers = require("telescope.previewers")
local themes = require("telescope.themes")

local entry_display = require("telescope.pickers.entry_display")
local results = require("telescope._extensions.packer.plugin_list")
local mappings = require("telescope._extensions.packer.mappings")

-- set column width to length of longest entry
local plugin_name_width = 0
for _, plugin in ipairs(results) do
  plugin_name_width = #plugin.name > plugin_name_width and #plugin.name or plugin_name_width
end

local user_opts
local setup = function(opts)
  opts = opts or {}
  if opts.theme and opts.theme ~= "" then
    user_opts = themes["get_" .. opts.theme](opts)
  else
    user_opts = opts
  end
end

local plugins = function(opts)
  opts = vim.tbl_deep_extend("force", user_opts, opts or {})

  local displayer = entry_display.create({
    separator = "",
    items = {
      { width = plugin_name_width + 1 },
      { remaining = true },
    },
  })

  local make_display = function(entry)
    local hl = entry.directory == "start" and "Operator" or "Number"
    return displayer({
      { entry.name, hl, "Normal" }, -- TODO: parameter 2 intended to be override for matcher hl-group
      { entry.description, "Comment" },
    })
  end

  pickers
    .new(opts, {
      prompt_title = "Plugins",
      finder = finders.new_table({
        results = results,
        entry_maker = function(entry)
          return {
            value = entry,
            display = make_display,
            ordinal = entry.directory .. " " .. entry.name,

            directory = entry.directory,
            name = entry.name,
            description = entry.description,
            readme = entry.readme,
            path = entry.path,

            preview_command = function(entry, bufnr)
              local readme = {}
              if entry.readme ~= nil then
                readme = vim.fn.readfile(entry.readme)
                vim.api.nvim_buf_set_option(bufnr, "filetype", "markdown")
              end
              vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, readme)
            end,
          }
        end,
      }),
      sorter = sorters.get_generic_fuzzy_sorter(),
      previewer = previewers.display_content.new(opts),
      attach_mappings = mappings,
      previewer = previewers.display_content.new(opts),
    })
    :find()
end

return telescope.register_extension({
  setup = setup,
  exports = {
    packer = plugins,
  },
})
