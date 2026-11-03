-- ColorschemeExport: Export Neovim colorscheme to bat theme format
-- Converts Neovim highlight definitions to .tmTheme XML format for bat

local M = {}

--- Generate UUID v4
--- @return string UUID
local function generate_uuid()
  local template = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"
  return string.gsub(template, "[xy]", function(c)
    local v = (c == "x") and math.random(0, 0xf) or math.random(8, 0xb)
    return string.format("%x", v)
  end)
end

--- Get highlight group attributes
--- @param group_name string Name of the highlight group
--- @return table Highlight attributes {fg, bg, sp, bold, italic, etc.}
local function get_highlight(group_name)
  local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group_name, link = false })
  if not ok then
    return {}
  end

  local result = {}

  -- Convert numeric colors to hex
  if hl.fg then
    result.fg = string.format("#%06x", hl.fg)
  end
  if hl.bg then
    result.bg = string.format("#%06x", hl.bg)
  end
  if hl.sp then
    result.sp = string.format("#%06x", hl.sp)
  end

  -- Copy style attributes
  result.bold = hl.bold
  result.italic = hl.italic
  result.underline = hl.underline
  result.undercurl = hl.undercurl
  result.strikethrough = hl.strikethrough
  result.reverse = hl.reverse

  return result
end

--- Get all highlight group names
--- @return table List of highlight group names
local function get_all_highlight_groups()
  local groups = {}
  local output = vim.api.nvim_exec2("highlight", { output = true })

  for line in output.output:gmatch("[^\r\n]+") do
    local group = line:match("^([%w_]+)")
    if group then
      table.insert(groups, group)
    end
  end

  return groups
end

--- Map Neovim highlight group to tmTheme scopes
--- Returns comma-separated list of scopes for better coverage
--- @param group_name string Neovim highlight group name
--- @return string|nil Comma-separated tmTheme scope names
local function map_hl_to_scopes(group_name)
  local scope_map = {
    -- Text and variables
    Normal = "text, source",
    Identifier = "variable.other.readwrite, punctuation.definition.variable",

    -- Comments
    Comment = "comment, punctuation.definition.comment",
    SpecialComment = "comment.block.documentation",

    -- Constants
    Constant = "constant",
    String = "string, punctuation.definition.string",
    Character = "constant.character",
    Number = "constant.numeric",
    Boolean = "constant.language.boolean",
    Float = "constant.numeric.float",

    -- Identifiers & Functions
    Function = "entity.name.function, support.function",

    -- Keywords & Statements
    Statement = "keyword",
    Conditional = "keyword.control.conditional",
    Repeat = "keyword.control.repeat, keyword.control.loop",
    Label = "keyword.other.label",
    Operator = "keyword.operator",
    Keyword = "keyword",
    Exception = "keyword.control.exception",

    -- PreProc
    PreProc = "keyword.control.import",
    Include = "keyword.control.import, keyword.control.include",
    Define = "constant.macro, entity.name.constant",
    Macro = "constant.macro",
    PreCondit = "keyword.control.conditional.preprocessor",

    -- Types
    Type = "storage.type, support.type",
    StorageClass = "storage.modifier",
    Structure = "storage.type.struct, keyword.declaration.struct",
    Typedef = "storage.type.typedef",

    -- Special
    Special = "constant.other",
    SpecialChar = "constant.character.escape",
    Tag = "entity.name.tag",
    Delimiter = "punctuation.separator, punctuation.terminator",
    SpecialComment = "comment.block.documentation",
    Debug = "keyword.other.debug",

    -- Errors & Warnings
    Error = "invalid.illegal",
    ErrorMsg = "invalid.illegal, message.error",
    WarningMsg = "markup.warning, message.warning",

    -- Markup
    Title = "markup.heading, entity.name.section",
    Underlined = "markup.underline",
    Bold = "markup.bold",
    Italic = "markup.italic",
    Todo = "markup.todo, keyword.other.todo",

    -- Punctuation
    Delimiter = "punctuation.separator",
  }

  return scope_map[group_name]
end

--- Generate font style string from highlight attributes
--- @param hl table Highlight attributes
--- @return string Font style ("bold", "italic", "bold italic", or empty string)
local function get_font_style(group_name, hl)
  local styles = {}
  if hl.bold then
    table.insert(styles, "bold")
  end
  if hl.italic then
    table.insert(styles, "italic")
  end

  if #styles > 0 then
    return table.concat(styles, " ")
  end
  return ""
end

--- Generate tmTheme XML for bat
--- @param colorscheme_name string Name of the colorscheme
--- @return string XML content in tmTheme format
function M.generate_tmtheme(colorscheme_name)
  math.randomseed(os.time())

  -- Get global UI colors
  local normal = get_highlight("Normal")
  local visual = get_highlight("Visual")
  local cursor_line = get_highlight("CursorLine")
  local cursor = get_highlight("Cursor")
  local error_hl = get_highlight("Error")
  local search = get_highlight("Search")
  local line_nr = get_highlight("LineNr")

  -- Start XML document with correct DTD
  local lines = {
    '<?xml version="1.0" encoding="UTF-8"?>',
    '<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">',
    '<plist version="1.0">',
    "  <dict>",
    "    <key>name</key>",
    "    <string>" .. colorscheme_name .. "</string>",
    "    <key>uuid</key>",
    "    <string>" .. generate_uuid() .. "</string>",
    "    <key>author</key>",
    "    <string>Neovim ColorschemeExport</string>",
    "    <key>colorSpaceName</key>",
    "    <string>sRGB</string>",
    "    <key>semanticClass</key>",
    "    <string>theme.neovim." .. colorscheme_name:lower():gsub("[^%w]", "-") .. "</string>",
    "    <key>settings</key>",
    "    <array>",
    "      <dict>",
    "        <key>settings</key>",
    "        <dict>",
  }

  -- Add global settings (required and optional)
  if normal.bg then
    table.insert(lines, "          <key>background</key>")
    table.insert(lines, "          <string>" .. normal.bg .. "</string>")
  end

  if normal.fg then
    table.insert(lines, "          <key>foreground</key>")
    table.insert(lines, "          <string>" .. normal.fg .. "</string>")
  end

  if cursor.bg or cursor.fg then
    table.insert(lines, "          <key>caret</key>")
    table.insert(lines, "          <string>" .. (cursor.fg or cursor.bg or normal.fg or "#ffffff") .. "</string>")
  end

  if cursor_line.bg then
    table.insert(lines, "          <key>lineHighlight</key>")
    table.insert(lines, "          <string>" .. cursor_line.bg .. "</string>")
  end

  if error_hl.fg then
    table.insert(lines, "          <key>misspelling</key>")
    table.insert(lines, "          <string>" .. error_hl.fg .. "</string>")
  end

  if visual.bg then
    table.insert(lines, "          <key>selection</key>")
    table.insert(lines, "          <string>" .. visual.bg .. "</string>")
  end

  if search.bg then
    table.insert(lines, "          <key>findHighlight</key>")
    table.insert(lines, "          <string>" .. search.bg .. "</string>")
  end

  if line_nr.fg then
    table.insert(lines, "          <key>gutterForeground</key>")
    table.insert(lines, "          <string>" .. line_nr.fg .. "</string>")
  end

  table.insert(lines, "        </dict>")
  table.insert(lines, "      </dict>")

  -- Get all highlight groups and process them
  local groups = get_all_highlight_groups()
  local processed = {}

  for _, group_name in ipairs(groups) do
    local scopes = map_hl_to_scopes(group_name)
    if scopes and not processed[scopes] then
      processed[scopes] = true

      local hl = get_highlight(group_name)

      -- Only add if there's actual color information
      if hl.fg or hl.bg then
        table.insert(lines, "      <dict>")
        table.insert(lines, "        <key>name</key>")
        table.insert(lines, "        <string>" .. group_name .. "</string>")
        table.insert(lines, "        <key>scope</key>")
        table.insert(lines, "        <string>" .. scopes .. "</string>")
        table.insert(lines, "        <key>settings</key>")
        table.insert(lines, "        <dict>")

        if hl.fg then
          table.insert(lines, "          <key>foreground</key>")
          table.insert(lines, "          <string>" .. hl.fg .. "</string>")
        end

        if hl.bg then
          table.insert(lines, "          <key>background</key>")
          table.insert(lines, "          <string>" .. hl.bg .. "</string>")
        end

        -- Always include fontStyle, even if empty
        local font_style = get_font_style(group_name, hl)
        table.insert(lines, "          <key>fontStyle</key>")
        if font_style ~= "" then
          table.insert(lines, "          <string>" .. font_style .. "</string>")
        else
          table.insert(lines, "          <string/>")
        end

        table.insert(lines, "        </dict>")
        table.insert(lines, "      </dict>")
      end
    end
  end

  -- Close XML document
  table.insert(lines, "    </array>")
  table.insert(lines, "  </dict>")
  table.insert(lines, "</plist>")

  return table.concat(lines, "\n")
end

--- Export colorscheme to bat theme format in a new buffer
--- @param opts table Options { colorscheme?: string, filename?: string }
function M.export(opts)
  opts = opts or {}

  -- Get current colorscheme name if not provided
  local colorscheme_name = opts.colorscheme or vim.g.colors_name or "nvim-theme"

  -- Generate tmTheme XML
  local xml_content = M.generate_tmtheme(colorscheme_name)

  -- Create a new scratch buffer
  local bufnr = vim.api.nvim_create_buf(false, true)

  -- Set buffer options
  vim.bo[bufnr].buftype = "nofile"
  vim.bo[bufnr].bufhidden = "hide"
  vim.bo[bufnr].swapfile = false
  vim.bo[bufnr].filetype = "xml"

  -- Set buffer name
  local filename = opts.filename or (colorscheme_name .. ".tmTheme")
  vim.api.nvim_buf_set_name(bufnr, filename)

  -- Split the content into lines
  local lines = vim.split(xml_content, "\n")

  -- Set buffer content
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)

  -- Open buffer in a new window
  vim.cmd("split")
  vim.api.nvim_win_set_buf(0, bufnr)

  -- Notify user
  vim.notify(
    string.format(
      "Exported colorscheme '%s' to bat theme format (%d lines)",
      colorscheme_name,
      #lines
    ),
    vim.log.levels.INFO
  )

  return bufnr
end

return M
