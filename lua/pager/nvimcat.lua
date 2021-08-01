local nvim = vim.api -- luacheck: ignore
local vim = vim -- luacheck: ignore

local cache = {}
-- A local copy of the termguicolors option, used for color output in cat
-- mode.
local colors_24_bit

local color2escape
local doc
-- A neovim highlight namespace to group together all highlights added to
-- buffers by this module.
local namespace

-- Split a 24 bit color number into the three red, green and blue values
local function split_rgb_number(color_number)
  -- The lua implementation of these bit shift operations is taken from
  -- http://nova-fusion.com/2011/03/21/simulate-bitwise-shift-operators-in-lua
  local r = math.floor(color_number / 2 ^ 16)
  local g = math.floor(math.floor(color_number / 2 ^ 8) % 2 ^ 8)
  local b = math.floor(color_number % 2 ^ 8)
  return r, g, b
end

local function hexformat_rgb_numbers(r, g, b) return string.format("#%06x", r * 2 ^ 16 + g * 2 ^ 8 + b) end

-- Compute the escape sequences for a 24 bit color number.
local function color2escape_24bit(color_number, foreground)
  local red, green, blue = split_rgb_number(color_number)
  local escape
  if foreground then
    escape = "38;2;"
  else
    escape = "48;2;"
  end
  return escape .. red .. ";" .. green .. ";" .. blue
end

-- Compute the escape sequences for a 8 bit color number.
local function color2escape_8bit(color_number, foreground)
  local prefix
  if color_number < 8 then
    if foreground then
      prefix = "3"
    else
      prefix = "4"
    end
  elseif color_number < 16 then
    color_number = color_number - 8
    if foreground then
      prefix = "9"
    else
      prefix = "10"
    end
  elseif foreground then
    prefix = "38;5;"
  else
    prefix = "48;5;"
  end
  return prefix .. color_number
end

-- Compute a ansi escape sequences to render a syntax group on the terminal.
local function group2ansi(groupid)
  if cache[groupid] then return cache[groupid] end
  local info = nvim.nvim_get_hl_by_id(groupid, colors_24_bit)
  if info.reverse then info.foreground, info.background = info.background, info.foreground end
  -- Reset all attributes before setting new ones.  The vimscript version did
  -- use sevel explicit reset codes: 22, 24, 25, 27 and 28.  If no foreground
  -- or background color was defined for a syntax item they were reset with
  -- 39 or 49.
  local escape = "\27[0"

  if info.bold then escape = escape .. ";1" end
  if info.italic then escape = escape .. ";3" end
  if info.underline then escape = escape .. ";4" end

  if info.foreground then escape = escape .. ";" .. color2escape(info.foreground, true) end
  if info.background then escape = escape .. ";" .. color2escape(info.background, false) end

  escape = escape .. "m"
  cache[groupid] = escape
  return escape
end

-- Initialize some module level variables for cat mode.
local function init_cat_mode()
  -- Initialize the ansi group to color cache with the "Normal" hl group.
  cache[0] = group2ansi(nvim.nvim_call_function("hlID", { "Normal" }))
  -- Get the value of &termguicolors from neovim.
  colors_24_bit = nvim.nvim_get_option("termguicolors")
  -- Select the correct coloe escaping function.
  if colors_24_bit then
    color2escape = color2escape_24bit
  else
    color2escape = color2escape_8bit
  end
end

-- Call the highlight function to write the highlighted version of all buffers
-- to stdout and quit nvim.
local function cat_mode()
  init_cat_mode()
  highlight()
  -- We can not use nvim_list_bufs() as a file might appear on the command
  -- line twice.  In this case we want to behave like cat(1) and display the
  -- file twice.
  for _ = 2, nvim.nvim_call_function("argc", {}) do
    nvim.nvim_command("next")
    highlight()
  end
  nvim.nvim_command("quitall!")
end

local function highlight()
  -- Detect an empty buffer, see :help line2byte().  We can not use
  -- nvim_buf_get_lines as the table will contain one empty string for both an
  -- empty file and a file with just one empty line.
  if nvim.nvim_buf_line_count(0) == 1 and nvim.nvim_call_function("line2byte", { 2 }) == -1 then
    return
  elseif check_escape_sequences() then
    for _, line in ipairs(nvim.nvim_buf_get_lines(0, 0, -1, false)) do io.write(line, "\n") end
    return
  end
  local conceallevel = nvim.nvim_win_get_option(0, "conceallevel")
  local syntax_id_conceal = nvim.nvim_call_function("hlID", { "Conceal" })
  local syntax_id_whitespace = nvim.nvim_call_function("hlID", { "Whitespace" })
  local syntax_id_non_text = nvim.nvim_call_function("hlID", { "NonText" })
  local list = nvim.nvim_win_get_option(0, "list")
  local listchars = list and parse_listchars(get_listchars()) or {}
  local last_syntax_id = -1
  local last_conceal_id = -1
  local linecount = nvim.nvim_buf_line_count(0)
  for lnum, line in ipairs(nvim.nvim_buf_get_lines(0, 0, -1, false)) do
    local outline = ""
    local skip_next_char = false
    for cnum = 1, line:len() do
      local conceal_info = nvim.nvim_call_function("synconcealed", { lnum, cnum })
      local conceal = conceal_info[1] == 1
      local replace = conceal_info[2]
      local conceal_id = conceal_info[3]
      if skip_next_char then
        skip_next_char = false
      elseif conceal and last_conceal_id == conceal_id then -- luacheck: ignore
        -- skip this char
      else
        local syntax_id, append
        if conceal then
          syntax_id = syntax_id_conceal
          if replace == "" and conceallevel == 1 then replace = " " end
          append = replace
          last_conceal_id = conceal_id
        else
          append = line:sub(cnum, cnum)
          if list and string.find(" \194", append, 1, true) ~= nil then
            syntax_id = syntax_id_whitespace
            if append == " " then
              if line:find("^ +$", cnum) ~= nil then
                append = listchars.trail or listchars.space or append
              else
                append = listchars.space or append
              end
            elseif append == "\194" and line:sub(cnum + 1, cnum + 1) == "\160" then
              -- Utf8 non breaking space is "\194\160", neovim represents all
              -- files as utf8 internally, regardless of the actual encoding.
              -- See :help 'encoding'.
              append = listchars.nbsp or "\194\160"
              skip_next_char = true
            end
          else
            syntax_id = nvim.nvim_call_function("synID", { lnum, cnum, true })
          end
        end
        if syntax_id ~= last_syntax_id then
          outline = outline .. group2ansi(syntax_id)
          last_syntax_id = syntax_id
        end
        outline = outline .. append
      end
    end
    -- append a eol listchar if &list is set
    if list and listchars.eol ~= nil then
      syntax_id = syntax_id_non_text
      if syntax_id ~= last_syntax_id then
        outline = outline .. group2ansi(syntax_id)
        last_syntax_id = syntax_id
      end
      outline = outline .. listchars.eol
    end
    -- Write the whole line and a newline char.  If this was the last line
    -- also reset the terminal attributes.
    io.write(outline, lnum == linecount and cache[0] or "", "\n")
  end
end

-- Fix the runtimepath.  All user nvim folders are replaced by corresponding
-- nvimpager folders.
local function fix_runtime_path()
  local runtimepath = nvim.nvim_list_runtime_paths()
  -- Remove the custom nvimpager entry that was added on the command line.
  runtimepath[#runtimepath] = nil
  local new
  for _, name in ipairs({ "config", "data" }) do
    local original = nvim.nvim_call_function("stdpath", { name })
    new = original .. "pager"
    runtimepath = replace_prefix(runtimepath, original, new)
  end
  runtimepath = table.concat(runtimepath, ",")
  nvim.nvim_set_option("packpath", runtimepath)
  runtimepath = os.getenv("RUNTIME") .. "," .. runtimepath
  nvim.nvim_set_option("runtimepath", runtimepath)
  new = new .. "/rplugin.vim"
  nvim.nvim_command("let $NVIM_RPLUGIN_MANIFEST = '" .. new .. "'")
end

-- Create an iterator that tokenizes the given input string into ansi escape
-- sequences.
--
-- Lua patterns for string.gmatch
local function tokenize(input_string)
  -- The empty input string is a special case where we return one single
  -- token.
  if input_string == "" then return string.gmatch("", "") end
  -- we keep track of the position in the input with a local variable so that
  -- our "next" function does not need to rely on the second argument.
  -- Especially if a token appears twice in the input that might be of
  -- importance.
  local position = 1
  local function next(input)
    -- If the position we are currently tokenizing is beyond the input string
    -- return nil => stop tokenizing.
    if input:len() < position then return nil end

    -- If we are on the last character and it is a semicolon, return an empty
    -- token and move position beyond the input to stop on the next call.
    -- This is hard to handle properly in the tokenizer below.
    if input:len() == position and input:sub(-1) == ";" then
      position = position + 1
      return ""
    end

    -- first check for the special sequences "38;" "48;"
    local init = input:sub(position, position + 2)
    if init == "38;" or init == "48;" then
      -- Try to match an 8 bit or a 24 bit color sequence
      local patterns = { "([34])8;5;(%d+);?", "([34])8;2;(%d+);(%d+);(%d+);?" }
      for _, pattern in ipairs(patterns) do
        local start, stop, token, c1, c2, c3 = input:find(pattern, position)
        if start == position then
          position = stop + 1
          return token == "3" and "foreground" or "background", c1, c2, c3
        end
      end
      -- If no valid special sequence was found we fall through to the normal
      -- tokenization.
    end

    -- handle all other tokens, we expect a simple number followed by either a
    -- semicolon or the end of the string, or the end of the input string
    -- directly.
    local oldpos = position
    local next_pos = input:find(";", position)
    if next_pos == nil then
      -- no further semicolon was found, we reached the end of the input
      -- string, the next call to this function will return nil
      position = input:len() + 1
      return input:sub(oldpos, -1)
    else
      position = next_pos
      -- We only skip the semicolon if it was not at the end of the input
      -- string.
      if next_pos < input:len() then position = next_pos + 1 end
      return input:sub(oldpos, next_pos - 1)
    end
  end

  return next, input_string, nil
end

local state = {
  -- The line and column where the currently described state starts
  line = 1,
  column = 1,
}

function state.clear(self)
  self.foreground = ""
  self.background = ""
  self.ctermfg = ""
  self.ctermbg = ""
  for _, k in pairs(attributes) do self[k] = false end
end

local function stage1()
  fix_runtime_path()
  -- Don't remember file names and positions
  nvim.nvim_set_option("shada", "")
  -- prevent messages when opening files (especially for the cat version)
  nvim.nvim_set_option("shortmess", nvim.nvim_get_option("shortmess") .. "F")
  -- Define autocmd group for nvimpager.
  nvim.nvim_command("augroup NvimPager")
  nvim.nvim_command("  autocmd!")
  nvim.nvim_command("augroup END")
  doc = detect_parent_process()
  if doc == "git" then
    -- We disable modelines for this buffer as they could disturb the git
    -- highlighting in diffs.
    nvim.nvim_buf_set_option(0, "modeline", false)
    nvim.nvim_set_option("modelines", 0)
  end
  -- Theoretically these options only affect the pager mode so they could also
  -- be set in stage2() but that would overwrite user settings from the init
  -- file.
  nvim.nvim_set_option("mouse", "a")
  nvim.nvim_set_option("laststatus", 0)
end

-- Set up autocomands to start the correct mode after startup or for each
-- file.  This function assumes that in "cat mode" we are called with
-- --headless and hence do not have a user interface.  This also means that
-- this function can only be called with -c or later as the user interface
-- would not be available in --cmd.
local function stage2()
  detect_filetype()
  local mode, events
  if #nvim.nvim_list_uis() == 0 then
    mode, events = "cat", "VimEnter"
  else
    if nvimpager.maps then set_maps() end
    mode, events = "pager", "VimEnter,BufWinEnter"
  end
  -- The "nested" in these autocomands enables nested executions of
  -- autocomands inside the *_mode() functions.  See :h autocmd-nested, for
  -- compatibility with nvim < 0.4 we use "nested" and not "++nested".
  nvim.nvim_command("autocmd NvimPager " .. events .. " * nested lua nvimpager." .. mode .. "_mode()")
end

local nvimpager = {
  -- user facing options
  maps = true, -- if the default mappings should be defined
  -- exported functions
  cat_mode = cat_mode,
  pager_mode = pager_mode,
  stage1 = stage1,
  stage2 = stage2,
  -- functions only exported for tests
  _testable = {
    color2escape_24bit = color2escape_24bit,
    color2escape_8bit = color2escape_8bit,
    detect_parent_process = detect_parent_process,
    group2ansi = group2ansi,
    hexformat_rgb_numbers = hexformat_rgb_numbers,
    init_cat_mode = init_cat_mode,
    replace_prefix = replace_prefix,
    split_predifined_terminal_color = split_predifined_terminal_color,
    split_rgb_number = split_rgb_number,
    state = state,
    tokenize = tokenize,
  },
}

return nvimpager
