-- modules.markdown.codeblocks: yank every fenced code block in a Markdown buffer: yiC without
-- the fences, yaC with them (and the language). Normal-mode mappings rather than text objects,
-- since the blocks are not one contiguous region; yic/yac (nvim-various-textobjs) yank the block
-- under the cursor.
-- Attached from after/ftplugin/markdown.lua.
local M = {}

--- Remove the indent shared by all non-blank lines (fences nested in list items).
--- @param lines string[]
--- @return string[]
local function dedent(lines)
  local min
  for _, line in ipairs(lines) do
    if line:find("%S") then
      local indent = #line:match("^%s*")
      min = (not min or indent < min) and indent or min
    end
  end
  if not min or min == 0 then
    return lines
  end
  local out = {}
  for i, line in ipairs(lines) do
    out[i] = line:sub(min + 1)
  end
  return out
end

--- Rows [srow, last) a node covers. Nodes end at the next line's indent (column 0, or the list
--- item's indent), or mid-line at EOF when the buffer has no trailing newline.
--- @param buf integer
--- @param node TSNode
--- @return integer srow, integer last
local function rows(buf, node)
  local srow, _, erow, ecol = node:range()
  local tail = erow < vim.api.nvim_buf_line_count(buf)
      and vim.api.nvim_buf_get_text(buf, erow, 0, erow, ecol, {})[1]
    or ""
  return srow, tail:find("%S") and erow + 1 or erow
end

--- Each non-empty fenced code block, in buffer order. Inner is the contents only; outer adds
--- the opening fence with its info string (language) and the closing fence.
--- @param buf integer
--- @param outer boolean|nil
--- @return string[][]|nil blocks, string|nil err
function M.blocks(buf, outer)
  local ok, parser = pcall(vim.treesitter.get_parser, buf, "markdown")
  if not ok or not parser then
    return nil, "no markdown treesitter parser"
  end
  local root = parser:parse()[1]:root()
  local query = vim.treesitter.query.parse("markdown", "(fenced_code_block) @block")
  local blocks = {}
  for _, node in query:iter_captures(root, buf, 0, -1) do
    for child in node:iter_children() do
      if child:type() == "code_fence_content" then
        local srow, last = rows(buf, outer and node or child)
        local lines = vim.api.nvim_buf_get_lines(buf, srow, last, false)
        if #lines > 0 then
          table.insert(blocks, dedent(lines))
        end
      end
    end
  end
  return blocks
end

--- Join the blocks with one blank line between them.
--- @param blocks string[][]
--- @return string[]
function M.join(blocks)
  local out = {}
  for i, block in ipairs(blocks) do
    if i > 1 then
      table.insert(out, "")
    end
    vim.list_extend(out, block)
  end
  return out
end

--- Yank all fenced code blocks (linewise) into the unnamed, 0 and + registers.
--- @param buf integer|nil
--- @param outer boolean|nil include the fences (and language) of each block
--- @return integer count of blocks yanked
function M.yank_all(buf, outer)
  buf = (buf == nil or buf == 0) and vim.api.nvim_get_current_buf() or buf
  local blocks, err = M.blocks(buf, outer)
  if not blocks then
    vim.notify("markdown.codeblocks: " .. err, vim.log.levels.WARN)
    return 0
  end
  if #blocks == 0 then
    vim.notify("No code blocks to yank", vim.log.levels.WARN)
    return 0
  end
  local lines = M.join(blocks)
  vim.fn.setreg('"', lines, "l")
  vim.fn.setreg("0", lines, "l")
  -- the clipboard provider may be missing (headless, ssh without forwarding)
  pcall(vim.fn.setreg, "+", lines, "l")
  vim.notify(
    ("Yanked %d code block%s (%d lines)"):format(#blocks, #blocks == 1 and "" or "s", #lines)
  )
  return #blocks
end

--- @param buf integer
function M.attach(buf)
  vim.keymap.set("n", "yiC", function()
    M.yank_all(buf)
  end, { buffer = buf, desc = "Yank all code blocks (without fences)" })
  vim.keymap.set("n", "yaC", function()
    M.yank_all(buf, true)
  end, { buffer = buf, desc = "Yank all code blocks (with fences)" })
end

return M
