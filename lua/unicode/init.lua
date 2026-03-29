local config = require("unicode.config")
local data = require("unicode.data")
local names = require("unicode.names")
local digraph_mod = require("unicode.digraph")
local search = require("unicode.search")
local display = require("unicode.display")
local completion = require("unicode.completion")
local unicode_table = require("unicode.table")
local download = require("unicode.download")

local M = {}

-- Re-export public API
M.setup = config.setup
M.find_unicode_by = search.find_unicode_by
M.find_digraph_by = search.find_digraph_by
M.get_html_entity = search.get_html_entity
M.digraph = digraph_mod.digraph
M.complete_unicode = completion.complete_unicode
M.complete_digraph = completion.complete_digraph
M.complete_html_entity = completion.complete_html_entity
M.print_unicode_table = unicode_table.print_unicode_table
M.download = download.download

--- Get the unicode name for a decimal codepoint.
--- @param dec number
--- @return string
function M.get_unicode_name(dec)
  return names.resolve(dec, data.get())
end

--- Get a vim regex pattern for a codepoint.
--- @param val number Decimal codepoint
--- @return string
function M.regex(val)
  if not val or val == 0 then
    return ""
  end
  local hexl = #string.format("%X", val)
  if val <= 0xFFFF then
    return string.format("\\%%u%0" .. hexl .. "x", val)
  else
    return string.format("\\%%U%0" .. hexl .. "x", val)
  end
end

--- Build the unicode cache file.
function M.mk_cache()
  if not config.use_cache then
    return
  end
  local cache_file = config.data_cache_file()
  if vim.fn.filereadable(cache_file) == 1 then
    vim.notify("UnicodePlugin: Cache already exists", vim.log.levels.WARN)
    return
  end
  data.clear()
  data.load()
  if vim.fn.filereadable(cache_file) == 1 and vim.fn.getfsize(cache_file) > 100 then
    vim.notify("UnicodePlugin: Cache successfully created", vim.log.levels.WARN)
  else
    vim.notify("UnicodePlugin: Something went wrong when trying to create the cache file", vim.log.levels.WARN)
  end
end

--- Interactive search for unicode characters.
--- @param match string Search pattern
--- @return number|nil Selected decimal codepoint
function M.search(match)
  local uni = search.find_unicode_by(match)
  local format = { "% 4S\t", "U+%04X Dec:%06d\t", " %s" }

  display.reset_width()

  if #uni > 1 then
    vim.api.nvim_echo({ { "\n", "" } }, false, {})
    for i, item in ipairs(uni) do
      local dig = item.dig or ""
      local html = item.html or ""
      local width = #tostring(#uni)
      display.screen_output(
        match,
        string.format("%*d", width, i),
        string.format(format[1], item.glyph),
        string.format(format[2] .. format[3], item.dec, item.dec, item.name),
        dig ~= "" and string.format(" %s", dig) or nil,
        html ~= "" and string.format(" %s", html) or nil,
        item.info ~= "" and string.format(" %s", item.info) or nil
      )
    end
    vim.api.nvim_echo({ { "\n", "" } }, false, {})
    local input = vim.fn.trim(vim.fn.input("Please choose: "))
    if input == "" then
      return nil
    end
    local num = tonumber(input)
    if not num or num < 1 or num > #uni then
      vim.api.nvim_echo({ { "\ninvalid number selected, aborting...", "" } }, false, {})
      return nil
    end
    return uni[num].dec
  elseif #uni == 1 then
    return uni[1].dec
  end
  return nil
end

--- Get unicode character info under cursor (the :UnicodeName command).
--- @param register string|nil Register to store result in
--- @param type_filter string|nil One of "d" (digraph), "r" (regex), "n" (name), "h" (html), "v" (value)
function M.get_uni_char(register, type_filter)
  if register and (#register > 1 or not register:match("[a-zA-Z0-9+*/]")) then
    vim.notify("UnicodePlugin: No valid register specified", vim.log.levels.WARN)
    return
  end

  local type_char = ""
  local typelist = nil

  if register and register == "/" then
    type_char = "r"
    typelist = {}
  end

  if type_filter and type_filter ~= "" then
    local valid = type_filter:match("^[dDrRnNhHvV]")
    if not valid then
      vim.notify("UnicodePlugin: No item (digraph/html/name/regex/value) specified", vim.log.levels.WARN)
      return
    end
    type_char = type_filter:sub(1, 1):lower()
    typelist = {}
  end

  local uni_dict = data.get()
  if vim.tbl_isempty(uni_dict) then
    vim.notify(
      "UnicodePlugin: Can't determine char under cursor, " .. config.data_file() .. " not found",
      vim.log.levels.WARN
    )
    return
  end

  local nerds = require("unicode.nerd_chars")
  local msg = {}

  -- Get char under cursor using :normal! ga
  local ga_output = vim.api.nvim_exec2("normal! ga", { output = true })
  local a = (ga_output.output or ""):gsub("\n", "")

  if a == "NUL" then
    msg[#msg + 1] = "'NUL' U+0000 NULL"
  else
    -- Split on "Oct(al) \d+, Digr .." boundaries
    local items = vim.split(a, "Oct%a*%s+%d+,?%s*D?i?g?r?%s*.?.?%s*")
    -- Simpler: just parse the ga output directly
    -- Format: <char> decimal, Hex hex, Oct octal[, Digr xy]
    for match_str in a:gmatch("<([^>]+)>%s+(%d+)") do
      -- This is complex; let's use the simpler approach from the original
    end

    -- Parse ga output: each char section has format like "<X> DEC, Hex HEX, Oct OCT"
    local sections = {}
    for section in a:gmatch("[^,]+") do
      section = vim.trim(section)
      if section:match("^<") or section:match("^%d+$") then
        sections[#sections + 1] = section
      end
    end

    -- Actually, let's use the same approach as the original: parse the full ga output
    local pattern = "<([^>]*)>%s+(%d+)"
    for glyph, dec_str in a:gmatch(pattern) do
      local dec = tonumber(dec_str)
      if dec then
        local dig = digraph_mod.get_chars(dec)
        local name = names.resolve(dec, uni_dict)
        local html = search.get_html_entity(dec, true)
        local nerd = nerds[dec] or ""
        local hexl = #string.format("%X", dec)
        local pat = "/" .. M.regex(dec)
        local str = dec <= 0xFFFF and string.format('\"\\u%04x\"', dec)
          or string.format('\"\\U%0' .. hexl .. 'x\"', dec)
        local info = config.extra_info[dec] or ""

        -- Append trailing space to non-empty values
        name = name ~= "" and name .. " " or ""
        dig = dig ~= "" and dig .. " " or ""
        html = html ~= "" and html .. " " or ""
        nerd = nerd ~= "" and nerd .. " " or ""
        info = info ~= "" and info .. " " or ""
        pat = pat ~= "" and pat .. " " or ""
        str = str ~= "" and str .. " " or ""

        local line = string.format(
          "'%s' U+%04X Dec:%d %s%s%s%s%s%s%s",
          glyph,
          dec,
          dec,
          name,
          dig,
          html,
          info,
          pat,
          str,
          nerd
        )
        msg[#msg + 1] = line

        if typelist then
          if type_char == "v" then
            typelist[#typelist + 1] = tostring(dec)
          elseif type_char == "d" then
            typelist[#typelist + 1] = dig:gsub("[()]", ""):gsub("%s+$", "")
          elseif type_char == "r" then
            typelist[#typelist + 1] = pat:match("%S+") or ""
          elseif type_char == "h" then
            typelist[#typelist + 1] = html:gsub("%s+$", "")
          else
            typelist[#typelist + 1] = name:gsub("%s+$", "")
          end
        end
      end
    end
  end

  -- Store in register if specified
  if register then
    if typelist then
      vim.fn.setreg(register, table.concat(typelist, ""))
    else
      vim.fn.setreg(register, table.concat(msg, "\n"))
    end
  end

  -- Display output
  display.reset_width()
  for _, val in ipairs(msg) do
    local glyph_part = val:match("^('[^']*')")
    local rest = val:match("^'[^']*'(.*)")
    if glyph_part and rest then
      display.screen_output(nil, glyph_part, rest)
    end
  end
end

--- Print digraphs matching a pattern.
--- @param match string Search pattern
--- @param bang boolean If true, show names
function M.print_digraphs(match, bang)
  local digraphs = search.find_digraph_by(match)
  display.reset_width()

  for _, item in ipairs(digraphs) do
    local dig = (item.dig or ""):gsub("^.", ""):gsub(".$", "")
    display.screen_output(nil, item.glyph, string.format(" %s %s ", dig, item.dec))
    if bang then
      display.screen_output(match, string.format(" (%s)", item.name))
    end
  end
end

--- Print unicode characters matching a pattern.
--- @param match string Search pattern
--- @param bang boolean If true, show numbered list for selection
function M.print_unicode(match, bang)
  local uni = search.find_unicode_by(match)
  local format = { "% 4S\t", "U+%04X Dec:%06d\t", " %s" }

  display.reset_width()

  for i, item in ipairs(uni) do
    local dig = item.dig or ""
    local html = item.html or ""
    local width = #tostring(#uni)
    display.screen_output(
      match,
      bang and string.format("%*d", width, i) or "",
      string.format(format[1], item.glyph),
      string.format(format[2] .. format[3], item.dec, item.dec, item.name),
      dig ~= "" and string.format(" %s", dig) or nil,
      html ~= "" and string.format(" %s", html) or nil,
      item.info ~= "" and string.format(" %s", item.info) or nil
    )
  end

  -- Interactive insertion when bang mode is active
  if bang and not vim.bo.readonly and vim.bo.modifiable then
    local input = vim.fn.trim(vim.fn.input("Enter one or more numbers of character(s) to insert: "))
    local result = ""
    local rejected = {}
    for num_str in input:gmatch("%d+") do
      local num = tonumber(num_str)
      if not num or num < 1 or num > #uni then
        rejected[#rejected + 1] = num_str
      else
        result = result .. uni[num].glyph
      end
    end
    if #rejected > 0 then
      vim.api.nvim_echo({ { "\ninvalid numbers skipped: " .. table.concat(rejected, ", "), "" } }, false, {})
    end
    if result ~= "" then
      vim.cmd("normal! a" .. result .. [[\<Esc>]])
    end
  end
end

--- Create a new digraph from a unicode name.
--- @param arg string Format: "{char1}{char2} {pattern}"
function M.mk_digraph_new(arg)
  local chars, charname = arg:match("^(%S%S)%s+(.+%S)%s*$")
  if not chars then
    vim.api.nvim_err_writeln("Usage: DigraphNew {char1}{char2} {Unicode name}")
    return
  end

  -- Check if charname is a hex codepoint
  if charname:match("^%x+$") and tonumber(charname, 16) < 0xF0000 and charname ~= "0" then
    local value = tonumber(charname, 16)
    vim.cmd(string.format(":dig %s %d", chars, value))
    local unichars = search.find_unicode_by(string.format("0x%X", value))
    if #unichars == 1 then
      local u = unichars[1]
      vim.api.nvim_echo(
        { { string.format("Digraph %s == %s U+%04X %s", chars, u.glyph, u.dec, u.name), "" } },
        false,
        {}
      )
      digraph_mod.clear_dict()
      return
    end
  else
    local search_names = {}
    -- Test for perl-style short charname (script: name)
    local thescript, thename = charname:match("^(%S.-%S)%s*:%s*(%S.*%S)%s*$")
    if thescript and thename then
      local thecase = thename:match("%u") and "capital" or "small"
      search_names[#search_names + 1] = string.format("%s %s letter %s", thescript, thecase, thename)
      search_names[#search_names + 1] = string.format("%s letter %s", thescript, thename)
    else
      search_names[#search_names + 1] = charname
    end

    for _, name in ipairs(search_names) do
      local unichars = search.find_unicode_by("^" .. name)
      if #unichars == 1 then
        local u = unichars[1]
        vim.cmd(string.format(":dig %s %d", chars, u.dec))
        vim.api.nvim_echo(
          { { string.format("Digraph %s == %s U+%04X %s", chars, u.glyph, u.dec, u.name), "" } },
          false,
          {}
        )
        digraph_mod.clear_dict()
        return
      elseif #unichars > 1 then
        local names_list = {}
        for _, u in ipairs(unichars) do
          names_list[#names_list + 1] = '"' .. u.name .. '"'
        end
        vim.api.nvim_err_writeln(
          "Unicode name ambiguous: " .. charname .. " matches " .. table.concat(names_list, ",")
        )
        return
      end
    end
    vim.api.nvim_err_writeln("Unicode name not found: " .. charname)
  end
end

-- Toggle completion name display
local function toggle_unicode_completion()
  config.complete_name = not config.complete_name
  vim.api.nvim_echo(
    { { "Unicode Completion Names " .. (config.complete_name and "ON" or "OFF"), "" } },
    false,
    {}
  )
end

-- Command completion helper
local function un_complete_list(arg_lead, cmd_line, _)
  local parts = vim.split(cmd_line, "%s+")
  if #parts < 2 then
    return vim.split("abcdefghijklmnopqrstuvwxyz0123456789\\+*", "")
  else
    local items = { "digraph", "regex", "name", "html", "value" }
    return vim.tbl_filter(function(v)
      return v:find(arg_lead, 1, true) == 1
    end, items)
  end
end

--- Register all commands and keymaps.
function M.register()
  -- Commands
  vim.api.nvim_create_user_command("UnicodeName", function(opts)
    M.get_uni_char(unpack(opts.fargs))
  end, {
    nargs = "*",
    complete = un_complete_list,
  })

  vim.api.nvim_create_user_command("Digraphs", function(opts)
    M.print_digraphs(opts.args, opts.bang)
  end, { nargs = "?", bang = true })

  vim.api.nvim_create_user_command("UnicodeSearch", function(opts)
    M.print_unicode(opts.args, opts.bang)
  end, { nargs = 1, bang = true })

  vim.api.nvim_create_user_command("UnicodeTable", function(opts)
    M.print_unicode_table(opts.bang)
  end, { bang = true, bar = true })

  vim.api.nvim_create_user_command("DigraphNew", function(opts)
    M.mk_digraph_new(opts.args)
  end, { nargs = 1 })

  vim.api.nvim_create_user_command("UnicodeCache", function()
    M.mk_cache()
  end, {})

  vim.api.nvim_create_user_command("UnicodeDownload", function(opts)
    M.download(true, opts.bang)
  end, { bang = true })

  -- Deprecated aliases
  vim.api.nvim_create_user_command("SearchUnicode", function(opts)
    M.print_unicode(opts.args, false)
  end, { nargs = 1 })

  vim.api.nvim_create_user_command("DownloadUnicode", function()
    M.download(true)
  end, {})

  -- Keymaps (Plug mappings)
  local map = require("mapper").map

  map("n", "<Plug>(MakeDigraph)", function()
    vim.o.operatorfunc = "v:lua.require'unicode.digraph'.get_digraph"
    return "g@"
  end, { expr = true, desc = "Make digraph (operator)" })

  map("v", "<Plug>(MakeDigraph)", function()
    digraph_mod.get_digraph(vim.fn.visualmode(), true)
  end, { desc = "Make digraph from selection" })

  map("n", "<Plug>(UnicodeGA)", function()
    vim.cmd("UnicodeName")
  end, { desc = "Show unicode name for char under cursor" })

  map("i", "<Plug>(DigraphComplete)", function()
    return completion.complete_digraph()
  end, { expr = true, desc = "Complete digraph" })

  map("i", "<Plug>(UnicodeComplete)", function()
    return completion.complete_unicode()
  end, { expr = true, desc = "Complete unicode character" })

  map("i", "<Plug>(HTMLEntityComplete)", function()
    return completion.complete_html_entity()
  end, { expr = true, desc = "Complete HTML entity" })

  map("i", "<Plug>(UnicodeFuzzy)", function()
    -- Use Telescope instead of fzf
    local ok = pcall(require, "telescope")
    if ok then
      vim.cmd("Telescope unicode")
    else
      vim.notify("UnicodePlugin: Telescope is not installed", vim.log.levels.WARN)
    end
  end, { desc = "Fuzzy search unicode characters" })

  map("n", "<Plug>(UnicodeSwapCompleteName)", function()
    toggle_unicode_completion()
  end, { desc = "Toggle unicode completion name display" })
end

-- Auto-register on require
M.register()

return M
