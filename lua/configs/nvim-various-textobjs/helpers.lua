local various_textobjs = require("various-textobjs")

local inner_chunk = function()
  local chunkHelper = require("hlchunk.utils.chunkHelper")
  local CHUNK_RANGE_RET = chunkHelper.CHUNK_RANGE_RET
  local pos = vim.api.nvim_win_get_cursor(0)
  local retcode, cur_chunk_range = chunkHelper.get_chunk_range({
    pos = { bufnr = 0, row = pos[1] - 1, col = pos[2] },
    use_treesitter = true,
  })
  if retcode ~= CHUNK_RANGE_RET.OK then
    return
  end
  local s_row = cur_chunk_range.start + 1
  local e_row = cur_chunk_range.finish + 1
  local ctrl_v = vim.api.nvim_replace_termcodes("<C-v>", true, true, true)
  local cur_mode = vim.fn.mode()
  if cur_mode == "v" or cur_mode == "V" or cur_mode == ctrl_v then
    vim.cmd("normal! " .. cur_mode)
  end

  vim.api.nvim_win_set_cursor(0, { s_row, 0 })
  vim.cmd("normal! V")
  vim.api.nvim_win_set_cursor(0, { e_row, 0 })
end

local yank_surround_indent = function()
  local startPos = vim.api.nvim_win_get_cursor(0)

  -- identify start- and end-border
  require("various-textobjs").indentation("outer", "outer")
  local indentationFound = vim.fn.mode():find("V")
  if not indentationFound then
    return
  end
  vim.cmd.normal({ "V", bang = true }) -- leave visual mode so the '< '> marks are set

  -- copy them into the + register
  local startLn = vim.api.nvim_buf_get_mark(0, "<")[1] - 1
  local endLn = vim.api.nvim_buf_get_mark(0, ">")[1] - 1
  local startLine = vim.api.nvim_buf_get_lines(0, startLn, startLn + 1, false)[1]
  local endLine = vim.api.nvim_buf_get_lines(0, endLn, endLn + 1, false)[1]
  vim.fn.setreg("+", startLine .. "\n" .. endLine .. "\n")

  -- highlight yanked text
  local ns = vim.api.nvim_create_namespace("ysii")
  require("utils.hl").add_highlight(0, ns, "IncSearch", startLn, 0, -1)
  require("utils.hl").add_highlight(0, ns, "IncSearch", endLn, 0, -1)
  vim.defer_fn(function()
    vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
  end, 1000)

  -- restore cursor position
  vim.api.nvim_win_set_cursor(0, startPos)
end

local delete_surround_indent = function()
  -- select inner indentation
  various_textobjs.indentation("inner", "inner")

  -- Plugin only switches to visual mode when a textobj has been found
  local notOnIndentedLine = vim.fn.mode():find("V") == nil
  if notOnIndentedLine then
    return
  end

  -- Dedent indentation
  vim.fn.normal({ "<", bang = true })

  -- Delete surrounding lines
  local endBorderLn = vim.api.nvim_buf_get_mark(0, ">")[1] + 1
  local startBorderLn = vim.api.nvim_buf_get_mark(0, "<")[1] - 1
  vim.cmd(tostring(endBorderLn) .. " delete") -- delete end first so line index is not shifted
  vim.cmd(tostring(startBorderLn) .. " delete")
end
local function openURL(url)
  local opener
  if vim.fn.has("macunix") == 1 then
    opener = "open"
  elseif vim.fn.has("linux") == 1 then
    opener = "xdg-open"
  elseif vim.fn.has("win64") == 1 or vim.fn.has("win32") == 1 then
    opener = "start"
  end
  local openCommand = string.format("%s '%s' >/dev/null 2>&1", opener, url)
  vim.fn.system(openCommand)
end

local url_opener = function()
  require("various-textobjs").url()
  local foundURL = vim.fn.mode():find("v")
  if foundURL then
    vim.fn.normal('"zy')
    local url = vim.fn.getreg("z")
    openURL(url)
  else
    -- find all URLs in buffer
    local urlPattern = require("various-textobjs.charwise-textobjs").urlPattern
    local bufText = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
    local urls = {}
    for url in bufText:gmatch(urlPattern) do
      table.insert(urls, url)
    end
    if #urls == 0 then
      return
    end

    -- select one, use a plugin like dressing.nvim for nicer UI for
    -- `vim.ui.select`
    vim.ui.select(urls, { prompt = "Select URL:" }, function(choice)
      if choice then
        openURL(choice)
      end
    end)
  end
end

return {
  inner_chunk = inner_chunk,
  delete_surround_indent = delete_surround_indent,
  yank_surround_indent = yank_surround_indent,
  url_opener = url_opener,
}
