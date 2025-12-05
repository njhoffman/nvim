-- Extract and save default Neovim keymaps

local M = {}

-- Get all keymaps for all modes
local function get_all_keymaps()
  local modes = {
    n = "Normal",
    v = "Visual",
    x = "Visual Block",
    s = "Select",
    o = "Operator-pending",
    i = "Insert",
    c = "Command-line",
    t = "Terminal",
    l = "Lang-Arg",
    ["!"] = "Insert + Command-line",
    [""] = "Normal + Visual + Select + Operator-pending",
  }

  local all_maps = {}

  for mode, mode_name in pairs(modes) do
    local maps = vim.api.nvim_get_keymap(mode)
    all_maps[mode] = {
      name = mode_name,
      mappings = {},
    }

    for _, map in ipairs(maps) do
      table.insert(all_maps[mode].mappings, {
        lhs = map.lhs,
        rhs = map.rhs or "",
        desc = map.desc or "",
        callback = map.callback and "<function>" or nil,
        noremap = map.noremap == 1,
        silent = map.silent == 1,
        expr = map.expr == 1,
        nowait = map.nowait == 1,
        script = map.script == 1,
        sid = map.sid,
      })
    end

    -- Sort by lhs
    table.sort(all_maps[mode].mappings, function(a, b)
      return a.lhs < b.lhs
    end)
  end

  return all_maps
end

-- Format keymaps as Lua table
local function format_as_lua(keymaps)
  local lines = { "-- Neovim Keymaps Dump", "-- Generated: " .. os.date("%Y-%m-%d %H:%M:%S"), "", "return {" }

  local mode_order = { "n", "v", "x", "s", "o", "i", "c", "t", "l", "!", "" }

  for _, mode in ipairs(mode_order) do
    local mode_data = keymaps[mode]
    if mode_data and #mode_data.mappings > 0 then
      table.insert(lines, string.format('  ["%s"] = { -- %s', mode, mode_data.name))
      table.insert(lines, "    mappings = {")

      for _, map in ipairs(mode_data.mappings) do
        table.insert(lines, "      {")
        table.insert(lines, string.format('        lhs = %q,', map.lhs))
        if map.rhs ~= "" then
          table.insert(lines, string.format('        rhs = %q,', map.rhs))
        end
        if map.callback then
          table.insert(lines, string.format('        callback = %s,', map.callback))
        end
        if map.desc ~= "" then
          table.insert(lines, string.format('        desc = %q,', map.desc))
        end
        if map.noremap then
          table.insert(lines, "        noremap = true,")
        end
        if map.silent then
          table.insert(lines, "        silent = true,")
        end
        if map.expr then
          table.insert(lines, "        expr = true,")
        end
        if map.nowait then
          table.insert(lines, "        nowait = true,")
        end
        if map.script then
          table.insert(lines, "        script = true,")
        end
        if map.sid then
          table.insert(lines, string.format("        sid = %d,", map.sid))
        end
        table.insert(lines, "      },")
      end

      table.insert(lines, "    },")
      table.insert(lines, "  },")
    end
  end

  table.insert(lines, "}")
  return table.concat(lines, "\n")
end

-- Format keymaps as markdown
local function format_as_markdown(keymaps)
  local lines = {
    "# Neovim Keymaps Dump",
    "",
    "**Generated:** " .. os.date("%Y-%m-%d %H:%M:%S"),
    "",
    "---",
    "",
  }

  local mode_order = { "n", "v", "x", "s", "o", "i", "c", "t", "l", "!", "" }

  for _, mode in ipairs(mode_order) do
    local mode_data = keymaps[mode]
    if mode_data and #mode_data.mappings > 0 then
      table.insert(lines, string.format("## %s Mode (`%s`)", mode_data.name, mode))
      table.insert(lines, "")
      table.insert(lines, "| Key | Mapping | Description | Flags |")
      table.insert(lines, "|-----|---------|-------------|-------|")

      for _, map in ipairs(mode_data.mappings) do
        local flags = {}
        if map.noremap then
          table.insert(flags, "noremap")
        end
        if map.silent then
          table.insert(flags, "silent")
        end
        if map.expr then
          table.insert(flags, "expr")
        end
        if map.nowait then
          table.insert(flags, "nowait")
        end

        local rhs = map.rhs ~= "" and map.rhs or (map.callback and "<function>" or "")
        local desc = map.desc ~= "" and map.desc or "-"
        local flags_str = #flags > 0 and table.concat(flags, ", ") or "-"

        -- Escape pipes in the values
        rhs = rhs:gsub("|", "\\|")
        desc = desc:gsub("|", "\\|")

        table.insert(
          lines,
          string.format("| `%s` | `%s` | %s | %s |", map.lhs, rhs, desc, flags_str)
        )
      end

      table.insert(lines, "")
    end
  end

  return table.concat(lines, "\n")
end

-- Save keymaps to file
M.save_keymaps = function(opts)
  opts = opts or {}
  local format = opts.format or "lua" -- lua, markdown, or both
  local output_dir = opts.output_dir or vim.fn.stdpath("config") .. "/doc"

  -- Ensure output directory exists
  vim.fn.mkdir(output_dir, "p")

  local keymaps = get_all_keymaps()
  local saved_files = {}

  if format == "lua" or format == "both" then
    local lua_content = format_as_lua(keymaps)
    local lua_file = output_dir .. "/keymaps_dump.lua"
    local file = io.open(lua_file, "w")
    if file then
      file:write(lua_content)
      file:close()
      table.insert(saved_files, lua_file)
    end
  end

  if format == "markdown" or format == "both" then
    local md_content = format_as_markdown(keymaps)
    local md_file = output_dir .. "/keymaps_dump.md"
    local file = io.open(md_file, "w")
    if file then
      file:write(md_content)
      file:close()
      table.insert(saved_files, md_file)
    end
  end

  if #saved_files > 0 then
    vim.notify(
      "Keymaps saved to:\n" .. table.concat(saved_files, "\n"),
      vim.log.levels.INFO,
      { title = "Keymap Dump" }
    )
    -- Open the first file
    vim.cmd.edit(saved_files[1])
  end

  return saved_files
end

-- Create user commands
vim.api.nvim_create_user_command("KeymapsDump", function(opts)
  local format = "both"
  if opts.args and opts.args ~= "" then
    format = opts.args
  end
  M.save_keymaps({ format = format })
end, {
  nargs = "?",
  complete = function()
    return { "lua", "markdown", "both" }
  end,
  desc = "Dump all current keymaps to file(s) in doc/ directory",
})

vim.api.nvim_create_user_command("KeymapsDumpClean", function()
  vim.notify(
    [[To dump TRULY DEFAULT Neovim keymaps (without any config):

Run this command in your terminal:

  nvim --clean -c "source <(curl -s https://raw.githubusercontent.com/neovim/neovim/master/runtime/defaults.vim)" \
    -c "lua dofile(vim.fn.stdpath('config') .. '/lua/commands/default_keymaps.lua').save_keymaps()" \
    -c "qa!"

Or manually:
  1. nvim --clean
  2. :lua dofile(vim.fn.stdpath('config') .. '/lua/commands/default_keymaps.lua').save_keymaps()
  3. Check doc/keymaps_dump.lua and doc/keymaps_dump.md]],
    vim.log.levels.INFO,
    { title = "Clean Keymap Dump" }
  )
end, {
  desc = "Show instructions for dumping default Neovim keymaps without config",
})

return M
