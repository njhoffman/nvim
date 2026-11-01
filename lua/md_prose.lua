-- md_prose: consistent hard wrapping in Markdown. Typing wraps at 'textwidth' (also on lines
-- that were already too long), and J reflows the joined paragraph with gw so it stays wrapped;
-- prettierd reflows whole files on save (configs/conform.lua). Attached from
-- after/ftplugin/markdown.lua, which runs after the runtime ftplugin re-adds 'l'.
local M = {}

-- Treesitter nodes where J must not reflow (code, tables, headings, front matter, HTML)
local NO_REFLOW = {
  fenced_code_block = true,
  indented_code_block = true,
  pipe_table = true,
  atx_heading = true,
  setext_heading = true,
  html_block = true,
  minus_metadata = true,
  plus_metadata = true,
}

--- True when the cursor is in prose that gw may reflow.
--- @param buf integer
--- @return boolean
function M.reflowable(buf)
  local has_parser, parser = pcall(vim.treesitter.get_parser, buf, "markdown")
  if has_parser and parser then
    parser:parse()
  end
  local ok, node = pcall(vim.treesitter.get_node, { bufnr = buf, ignore_injections = true })
  if ok and node then
    while node do
      if NO_REFLOW[node:type()] then
        return false
      end
      node = node:parent()
    end
    return true
  end
  local line = vim.api.nvim_get_current_line()
  return not (line:find("^%s*[|#]") or line:find("^%s*```"))
end

--- J that reflows the paragraph afterwards; the cursor stays at the join point.
function M.join()
  local count = vim.v.count > 1 and vim.v.count or ""
  vim.cmd("normal! " .. count .. "J")
  local buf = vim.api.nvim_get_current_buf()
  if vim.bo[buf].textwidth > 0 and M.reflowable(buf) then
    vim.cmd("normal! gwip")
  end
end

--- @param buf integer
function M.attach(buf)
  vim.api.nvim_buf_call(buf, function()
    -- t: wrap while typing; drop l (don't wrap lines that were already too long) and a (auto
    -- reflow, which misfires on lists and code)
    vim.opt_local.formatoptions:append("t")
    vim.opt_local.formatoptions:remove({ "l", "a" })
  end)
  vim.keymap.set("n", "J", M.join, { buffer = buf, desc = "Join lines and reflow the paragraph" })
end

return M
