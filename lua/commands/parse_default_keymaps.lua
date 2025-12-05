-- Parse default keymaps from Neovim's index.txt help file

local M = {}

-- Parse the index.txt file and extract all keybindings
M.parse_index_file = function()
  local index_file = vim.fn.expand("$VIMRUNTIME/doc/index.txt")

  -- Check if file exists
  if vim.fn.filereadable(index_file) == 0 then
    vim.notify("Could not find index.txt at: " .. index_file, vim.log.levels.ERROR)
    return nil
  end

  local lines = vim.fn.readfile(index_file)
  local sections = {}
  local current_section = nil
  local current_subsection = nil
  local current_mapping = nil

  for i, line in ipairs(lines) do
    -- Match section headers like "1. Insert mode" or "2.1 Text objects"
    local section_num, section_name, section_tag = line:match("^(%d+%.%d*)%s+(.-)%s+%*(.-)%*")

    if section_num and section_name then
      -- Clean up section name
      section_name = section_name:gsub("%s+$", ""):gsub("%t+$", "")

      -- Determine if this is a main section or subsection
      if not section_num:match("%.%d") then
        -- Main section (e.g., "1.")
        current_section = {
          number = section_num,
          name = section_name,
          tag = section_tag,
          mappings = {},
          subsections = {},
        }
        table.insert(sections, current_section)
        current_subsection = nil
      else
        -- Subsection (e.g., "2.1")
        if current_section then
          current_subsection = {
            number = section_num,
            name = section_name,
            tag = section_tag,
            mappings = {},
          }
          table.insert(current_section.subsections, current_subsection)
        end
      end
      current_mapping = nil
    elseif line:match("^%-+") or line:match("^Tag%s+Char") or line:match("^%s*$") then
      -- Skip separator lines, header lines, and empty lines
      current_mapping = nil
    else
      -- Try to parse a mapping line: |tag| key description
      local tag, rest = line:match("^|([^|]+)|(.+)")

      if tag and rest then
        -- Parse the rest (key + description)
        -- The format uses tabs to separate key from description
        local parts = vim.split(rest, "\t", { plain = true, trimempty = false })

        -- Filter out empty parts
        local non_empty = {}
        for _, part in ipairs(parts) do
          local trimmed = part:gsub("^%s+", ""):gsub("%s+$", "")
          if trimmed ~= "" then
            table.insert(non_empty, trimmed)
          end
        end

        if #non_empty >= 2 then
          local key = non_empty[1]
          local desc = table.concat(vim.list_slice(non_empty, 2), " ")

          current_mapping = {
            tag = tag,
            key = key,
            description = desc,
          }

          -- Add to current subsection or section
          if current_subsection then
            table.insert(current_subsection.mappings, current_mapping)
          elseif current_section then
            table.insert(current_section.mappings, current_mapping)
          end
        elseif #non_empty == 1 then
          -- Maybe it's all key, description on next line?
          current_mapping = {
            tag = tag,
            key = non_empty[1],
            description = "",
          }

          if current_subsection then
            table.insert(current_subsection.mappings, current_mapping)
          elseif current_section then
            table.insert(current_section.mappings, current_mapping)
          end
        end
      elseif line:match("^%s+") and current_mapping then
        -- Continuation line for description
        local continuation = line:gsub("^%s+", ""):gsub("%s+$", "")
        if continuation ~= "" then
          if current_mapping.description ~= "" then
            current_mapping.description = current_mapping.description .. " " .. continuation
          else
            current_mapping.description = continuation
          end
        end
      else
        -- Line without tag - could be a key without tag
        local match = line:match("^%s+([A-Z<][^%s%t]+)")
        if match and (current_section or current_subsection) then
          -- This might be an entry without a tag (like "CTRL-F not used")
          local parts = vim.split(line, "\t", { plain = true, trimempty = false })
          local non_empty = {}
          for _, part in ipairs(parts) do
            local trimmed = part:gsub("^%s+", ""):gsub("%s+$", "")
            if trimmed ~= "" then
              table.insert(non_empty, trimmed)
            end
          end

          if #non_empty >= 2 then
            current_mapping = {
              tag = "",
              key = non_empty[1],
              description = table.concat(vim.list_slice(non_empty, 2), " "),
            }

            if current_subsection then
              table.insert(current_subsection.mappings, current_mapping)
            elseif current_section then
              table.insert(current_section.mappings, current_mapping)
            end
          end
        else
          current_mapping = nil
        end
      end
    end
  end

  return sections
end

-- Format sections as a Lua table
M.format_as_lua = function(sections)
  local lines = {
    "-- Neovim Default Keymaps (from index.txt)",
    "-- Generated: " .. os.date("%Y-%m-%d %H:%M:%S"),
    "-- Source: $VIMRUNTIME/doc/index.txt",
    "",
    "return {",
  }

  for _, section in ipairs(sections) do
    table.insert(lines, "  {")
    table.insert(lines, string.format('    number = %q,', section.number))
    table.insert(lines, string.format('    name = %q,', section.name))
    table.insert(lines, string.format('    tag = %q,', section.tag))
    table.insert(lines, "    mappings = {")

    for _, mapping in ipairs(section.mappings) do
      table.insert(lines, "      {")
      table.insert(lines, string.format('        tag = %q,', mapping.tag))
      table.insert(lines, string.format('        key = %q,', mapping.key))
      table.insert(lines, string.format('        description = %q,', mapping.description))
      table.insert(lines, "      },")
    end

    table.insert(lines, "    },")

    if #section.subsections > 0 then
      table.insert(lines, "    subsections = {")

      for _, subsection in ipairs(section.subsections) do
        table.insert(lines, "      {")
        table.insert(lines, string.format('        number = %q,', subsection.number))
        table.insert(lines, string.format('        name = %q,', subsection.name))
        table.insert(lines, string.format('        tag = %q,', subsection.tag))
        table.insert(lines, "        mappings = {")

        for _, mapping in ipairs(subsection.mappings) do
          table.insert(lines, "          {")
          table.insert(lines, string.format('            tag = %q,', mapping.tag))
          table.insert(lines, string.format('            key = %q,', mapping.key))
          table.insert(lines, string.format('            description = %q,', mapping.description))
          table.insert(lines, "          },")
        end

        table.insert(lines, "        },")
        table.insert(lines, "      },")
      end

      table.insert(lines, "    },")
    end

    table.insert(lines, "  },")
  end

  table.insert(lines, "}")

  return table.concat(lines, "\n")
end

-- Format sections as Markdown
M.format_as_markdown = function(sections)
  local lines = {
    "# Neovim Default Keymaps",
    "",
    "**Generated:** " .. os.date("%Y-%m-%d %H:%M:%S"),
    "**Source:** `$VIMRUNTIME/doc/index.txt`",
    "",
    "---",
    "",
  }

  for _, section in ipairs(sections) do
    -- Main section header
    table.insert(lines, string.format("## %s %s", section.number, section.name))
    table.insert(lines, "")
    table.insert(lines, string.format("*Reference: |%s|*", section.tag))
    table.insert(lines, "")

    -- Main section mappings
    if #section.mappings > 0 then
      table.insert(lines, "| Tag | Key | Description |")
      table.insert(lines, "|-----|-----|-------------|")

      for _, mapping in ipairs(section.mappings) do
        local key = mapping.key:gsub("|", "\\|")
        local desc = mapping.description:gsub("|", "\\|")
        table.insert(
          lines,
          string.format("| `%s` | `%s` | %s |", mapping.tag, key, desc)
        )
      end

      table.insert(lines, "")
    end

    -- Subsections
    for _, subsection in ipairs(section.subsections) do
      table.insert(lines, string.format("### %s %s", subsection.number, subsection.name))
      table.insert(lines, "")
      table.insert(lines, string.format("*Reference: |%s|*", subsection.tag))
      table.insert(lines, "")

      if #subsection.mappings > 0 then
        table.insert(lines, "| Tag | Key | Description |")
        table.insert(lines, "|-----|-----|-------------|")

        for _, mapping in ipairs(subsection.mappings) do
          local key = mapping.key:gsub("|", "\\|")
          local desc = mapping.description:gsub("|", "\\|")
          table.insert(
            lines,
            string.format("| `%s` | `%s` | %s |", mapping.tag, key, desc)
          )
        end

        table.insert(lines, "")
      end
    end
  end

  return table.concat(lines, "\n")
end

-- Main function to parse and save
M.save_default_keymaps = function(opts)
  opts = opts or {}
  local format = opts.format or "both"
  local output_dir = opts.output_dir or vim.fn.stdpath("config") .. "/doc"

  -- Ensure output directory exists
  vim.fn.mkdir(output_dir, "p")

  -- Parse the index file
  local sections = M.parse_index_file()
  if not sections then
    return
  end

  local saved_files = {}

  -- Save Lua format
  if format == "lua" or format == "both" then
    local lua_content = M.format_as_lua(sections)
    local lua_file = output_dir .. "/default_keymaps.lua"
    local file = io.open(lua_file, "w")
    if file then
      file:write(lua_content)
      file:close()
      table.insert(saved_files, lua_file)
    end
  end

  -- Save Markdown format
  if format == "markdown" or format == "both" then
    local md_content = M.format_as_markdown(sections)
    local md_file = output_dir .. "/default_keymaps.md"
    local file = io.open(md_file, "w")
    if file then
      file:write(md_content)
      file:close()
      table.insert(saved_files, md_file)
    end
  end

  if #saved_files > 0 then
    local count = 0
    for _, section in ipairs(sections) do
      count = count + #section.mappings
      for _, subsection in ipairs(section.subsections) do
        count = count + #subsection.mappings
      end
    end

    vim.notify(
      string.format(
        "Parsed %d mappings from %d sections\nSaved to:\n%s",
        count,
        #sections,
        table.concat(saved_files, "\n")
      ),
      vim.log.levels.INFO,
      { title = "Default Keymaps" }
    )

    -- Open the first file
    vim.cmd.edit(saved_files[1])
  end

  return sections
end

-- Create user command
vim.api.nvim_create_user_command("DefaultKeymaps", function(opts)
  local format = "both"
  if opts.args and opts.args ~= "" then
    format = opts.args
  end
  M.save_default_keymaps({ format = format })
end, {
  nargs = "?",
  complete = function()
    return { "lua", "markdown", "both" }
  end,
  desc = "Parse and save default Neovim keymaps from index.txt",
})

return M
