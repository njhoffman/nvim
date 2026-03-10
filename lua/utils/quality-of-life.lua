local M = {}
local u = require("utils.core")
-- selene: allow(mixed_table)
local function normal(cmd)
  vim.cmd.normal({ cmd, bang = true })
end

--------------------------------------------------------------------------------

local commentHrChar = "─"
function M.commentHr()
  local wasOnBlank = vim.api.nvim_get_current_line() == ""
  local indent = vim.fn.indent(".") ---@diagnostic disable-line: param-type-mismatch
  local comStr = vim.bo.commentstring
  local ft = vim.bo.filetype
  local comStrLength = #(comStr:gsub(" ?%%s ?", ""))

  if comStr == "" then
    u.notify("", "No commentstring for this filetype available.", "warn")
    return
  end
  if comStr:find("-") then
    commentHrChar = "-"
  end

  local commentWidth = vim.opt_local.textwidth:get()
  local linelength = commentWidth - indent - comStrLength

  -- the common formatters (black and stylelint) demand extra spaces
  local fullLine
  if ft == "css" then
    fullLine = " " .. commentHrChar:rep(linelength - 2) .. " "
  elseif ft == "python" then
    fullLine = " " .. commentHrChar:rep(linelength - 1)
  else
    fullLine = commentHrChar:rep(linelength)
  end

  -- set HR
  local hr = comStr:gsub(" ?%%s ?", fullLine)
  if ft == "markdown" then
    hr = "---"
  end

  local linesToAppend = { "", hr, "" }
  if wasOnBlank then
    linesToAppend = { hr, "" }
  end

  vim.fn.append(".", linesToAppend) ---@diagnostic disable-line: param-type-mismatch

  -- shorten if it was on blank line, since fn.indent() does not return indent
  -- line would have if it has content
  if wasOnBlank then
    normal("j==")
    local hrIndent = vim.fn.indent(".") ---@diagnostic disable-line: param-type-mismatch

    -- cannot use simply :sub, since it assumes one-byte-size chars
    local hrLine = vim.api.nvim_get_current_line()
    hrLine = hrLine:gsub(commentHrChar, "", hrIndent)
    vim.api.nvim_set_current_line(hrLine)
  else
    normal("jj==")
  end
end

local comments = {
  paste_type = "", -- b, c, l or '' to guess from content
  trim_leading_indent = true,
  indent_token = false,
}

function M.duplicateAsComment()
  local ln, col = unpack(vim.api.nvim_win_get_cursor(0))
  local ln_beg = vim.fn.line("v") or ln
  local ln_end = vim.fn.line(".") or ln
  local lines = ln_beg <= ln_end and ln_end - ln_beg + 1 or ln_beg - ln_end + 1
  if ln_beg > ln_end then
    local tmp = ln_end
    ln_end = ln_beg
    ln_beg = tmp
  end
  local currLines = vim.api.nvim_buf_get_lines(0, ln_beg - 1, ln_end, false)
  local commentedLines = {}
  for _, line in ipairs(currLines) do
    local indent, content = line:match("^(%s*)(.*)")
    if comments.indent_token then
      table.insert(commentedLines, indent .. vim.bo.commentstring:format(content))
    else
      table.insert(commentedLines, vim.bo.commentstring:format(indent .. content))
    end
  end
  vim.api.nvim_buf_set_lines(0, ln_beg - 1, ln_beg - 1, false, commentedLines)
  vim.api.nvim_win_set_cursor(0, { ln_beg + lines, col })
  -- escape visual mode
  local esc = vim.api.nvim_replace_termcodes("<esc>", true, false, true)
  vim.api.nvim_feedkeys(esc, "x", false)
end

function M.pasteAsComment(after_cursor)
  -- get content of paste register
  local clip_reg = vim.o.clipboard:match("unnamedplus") and "+" or "*"
  local clipboard = vim.tbl_deep_extend("force", {}, {
    type = "l",
    reg = clip_reg,
    commented = {},
  }, vim.fn.getreginfo(clip_reg))

  clipboard.type = clipboard.regtype == "v" and #clipboard.commented == 1 and "c"
    or clipboard.regtype:match("") and "b"
    or "l"

  for _, line in ipairs(clipboard.regcontents or {}) do
    local indent, content = line:match("^(%s*)(.*)")
    if comments.indent_token then
      table.insert(clipboard.commented, indent .. vim.bo.commentstring:format(content))
    else
      table.insert(clipboard.commented, vim.bo.commentstring:format(indent .. content))
    end
  end
  -- vim.dbglog("line", #lines, #lines, #lines, after_cursor, vim.fn.getreginfo(clipboard_reg))

  -- local paste_type = comments.force_mode or ""
  vim.api.nvim_put(clipboard.commented, clipboard.type, after_cursor, false)
end

--------------------------------------------------------------------------------
local propTypes = {
  prototypeChain = true,
  top = false,
  enumerables = true,
  nonenumerables = true,
  strings = true,
  symbols = true,
}
function M.openAlfredPref()
  local parentFolder = vim.fn.expand("%:p:h")
  if not parentFolder:find("Alfred%.alfredpreferences") then
    u.notify("", "Not in an Alfred directory.", "warn")
    return
  end
  -- URI seems more reliable than JXA when called via nvim https://www.alfredforum.com/topic/18390-get-currently-edited-workflow-uri/
  local workflowId = parentFolder:match("Alfred%.alfredpreferences/workflows/([^/]+)")
  vim.fn.system({ "open", "alfredpreferences://navigateto/workflows>workflow>" .. workflowId })
  -- in case the right workflow is already open, Alfred is not focused.
  -- Therefore manually focusing in addition to that here as well.
  vim.fn.system({ "open", "-a", "Alfred Preferences" })
end

function M.openNewScope()
  local line = vim.api.nvim_get_current_line()
  local trailChar = line:match(",? *$")
  line = line:gsub(" *,? *$", "") .. " {" -- edit current line
  vim.api.nvim_set_current_line(line)
  local ln = vim.api.nvim_win_get_cursor(0)[1]
  local indent = line:match("^%s*")
  vim.api.nvim_buf_set_lines(0, ln, ln, false, { indent .. "\t", indent .. "}" .. trailChar })
  vim.api.nvim_win_set_cursor(0, { ln + 1, 1 }) -- go line down
  vim.cmd.startinsert({ bang = true })
end

--------------------------------------------------------------------------------

function M.openAtRegex101()
  -- keymaps assume a/ and i/ mapped as regex textobj via treesitter textobj
  -- selene: allow(mixed_table)
  vim.cmd.normal({ '"zya/', bang = false }) -- yank outer regex
  -- selene: allow(mixed_table)
  vim.cmd.normal({ "vi/", bang = false }) -- select inner regex for easy replacement

  -- TODO use treesitter to get pattern and flags
  local regex = vim.fn.getreg("z")
  local pattern = regex:match("/(.*)/")
  local flags = regex:match("/.*/(%l*)")
  local replacement = vim.api.nvim_get_current_line():match('replace ?%(/.*/.*, ?"(.-)"')

  -- https://github.com/firasdib/Regex101/wiki/FAQ#how-to-prefill-the-fields-on-the-interface-via-url
  local url = "https://regex101.com/?regex=" .. pattern .. "&flags=" .. flags
  if replacement then
    url = url .. "&subst=" .. replacement
  end

  vim.fn.system({ "open", url })
end

--------------------------------------------------------------------------------

---Toggles a pin-window
local pinWinNr
---@param width number -- between 0 and 1
---@param height number -- between 0 and 1
function M.pinWin(width, height)
  -- if already open, just close is
  local pinWinOpen = vim.tbl_contains(vim.api.nvim_list_wins(), pinWinNr)
  if pinWinOpen then
    vim.api.nvim_win_close(pinWinNr, true)
    return
  end

  -- create pin window
  local bufnr = 0 -- current buffer
  pinWinNr = vim.api.nvim_open_win(bufnr, false, {
    relative = "win",
    width = math.floor(vim.api.nvim_win_get_width(0) * width),
    height = math.floor(vim.api.nvim_win_get_height(0) * height),
    anchor = "NE",
    row = 0,
    col = vim.api.nvim_win_get_width(0),
    style = "minimal",
    border = u.borderStyle,
    title = "  " .. vim.fs.basename(vim.api.nvim_buf_get_name(bufnr)) .. " ",
    title_pos = "center",
  })
  vim.wo[pinWinNr].scrolloff = 2
  vim.wo[pinWinNr].sidescrolloff = 2
  vim.wo[pinWinNr].signcolumn = "no"
end

--------------------------------------------------------------------------------

function M.selectMake()
  -- GUARD
  local makefile = vim.loop.cwd() .. "/Makefile"
  local fileExists = vim.loop.fs_stat(makefile)
  if not fileExists then
    u.notify("Makefile not found", "warn")
    return
  end

  local recipes = {}
  for line in io.lines(makefile) do
    local recipe = line:match("^[%w_]+")
    if recipe then
      table.insert(recipes, recipe)
    end
  end

  vim.ui.select(recipes, { prompt = " make" }, function(selection)
    if not selection then
      return
    end
    vim.cmd("silent! lmake")
    vim.cmd.lmake(selection)
  end)
end

--------------------------------------------------------------------------------
return M
