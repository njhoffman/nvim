local telescope = require("telescope")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local entry_display = require("telescope.pickers.entry_display")

local default_opts = {
  theme = require("telescope.themes").get_dropdown(),
}

local function build_entry_list()
  local data = require("unicode.data")
  local uni_dict = data.get()
  local results = {}

  for dec, name in pairs(uni_dict) do
    if dec > 0 then
      results[#results + 1] = {
        char = vim.fn.nr2char(dec),
        name = name,
        code = string.format("U+%04X", dec),
        dec = dec,
      }
    end
  end

  table.sort(results, function(a, b)
    return a.dec < b.dec
  end)

  return results
end

local function make_entry_maker(results)
  local displayer = entry_display.create({
    separator_hl = "TelescopeResultsSeparator",
    separator = " ",
    items = {
      { width = 4 },
      { width = 8 },
      { remaining = true },
    },
  })

  local make_display = function(entry)
    return displayer({
      { " " .. entry.value.char .. " ", "TelescopeResultsVariable" },
      { entry.value.code, "Comment" },
      { entry.value.name },
    })
  end

  return function(item)
    return {
      display = make_display,
      value = item,
      ordinal = item.name .. " " .. item.code,
    }
  end
end

local function unicode_picker(opts)
  opts = vim.tbl_deep_extend("force", default_opts, opts or {})

  local results = build_entry_list()

  pickers
    .new(opts.theme, {
      prompt_title = "Unicode Characters",
      finder = finders.new_table({
        results = results,
        entry_maker = make_entry_maker(results),
      }),
      sorter = conf.generic_sorter(opts),
      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(function()
          local selected = action_state.get_selected_entry()
          if selected then
            local char = selected.value.char
            actions.close(prompt_bufnr)
            vim.api.nvim_put({ char }, "c", true, true)
          end
        end)

        -- Copy to register with <C-y>
        map("i", "<C-y>", function()
          local selected = action_state.get_selected_entry()
          if selected then
            local char = selected.value.char
            vim.fn.setreg("+", char)
            vim.notify("Copied: " .. char .. " (" .. selected.value.code .. ")")
          end
        end)

        return true
      end,
    })
    :find()
end

return telescope.register_extension({
  exports = { unicode = unicode_picker },
})
