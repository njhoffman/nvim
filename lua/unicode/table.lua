local config = require("unicode.config")
local data = require("unicode.data")
local digraph = require("unicode.digraph")
local search = require("unicode.search")
local cache = require("unicode.cache")

local M = {}

--- Find or create a window for the unicode table buffer.
--- @param name string Buffer name
local function find_window(name)
  local win = vim.fn.bufwinnr("^" .. name .. "$")
  if win ~= -1 then
    vim.cmd("noautocmd noswapfile " .. win .. "wincmd w")
  else
    vim.cmd("noautocmd noswapfile sp " .. name)
  end
end

--- Apply post-load settings to the unicode table buffer.
local function afterload()
  vim.cmd("runtime syntax/unicode.vim")
  vim.api.nvim_win_set_cursor(0, { 1, 0 })
end

--- Display the full Unicode table in a buffer.
--- @param force boolean If true, regenerate even if cache exists
function M.print_unicode_table(force)
  local buffer_name = "UnicodeTable.txt"
  local cache_file = config.table_cache_file()

  -- Use cached file if available
  if config.use_cache and vim.fn.filereadable(cache_file) == 1 and not force then
    find_window(buffer_name)
    vim.cmd("noautocmd noswapfile :e " .. cache_file)
    afterload()
    return
  end

  local uni_dict = data.get()
  local output = {
    string.format("%-7s%-8s%-18s%-57s%s", "Char", "Codept", "Html", "Name (Digraph)", "Link"),
  }

  -- Build entries
  local keys = {}
  for k in pairs(uni_dict) do
    keys[#keys + 1] = k
  end
  table.sort(keys)

  for _, value in ipairs(keys) do
    local name = uni_dict[value]
    local dig = digraph.get_chars(value)
    local html = search.get_html_entity(value, false)
    local codep = string.format("U+%04X", value)

    -- Ensure trailing space on name
    if name:sub(-1) ~= " " then
      name = name .. " "
    end

    output[#output + 1] = string.format(
      "%-7s%-8s%-18s%-57shttps://unicode-table.com/en/%04X/",
      vim.fn.strtrans(vim.fn.nr2char(value)),
      codep,
      html,
      name .. dig,
      value
    )
  end

  -- Display in buffer
  find_window(buffer_name)
  vim.bo.modifiable = true
  vim.bo.swapfile = false
  vim.bo.buftype = "nofile"
  vim.wo.foldcolumn = "0"
  vim.bo.buflisted = false
  vim.bo.bufhidden = "wipe"
  vim.wo.wrap = false

  vim.api.nvim_buf_set_lines(0, 0, -1, false, output)

  -- Sort by codepoint (skip header line)
  vim.cmd("2,$sort x /^.\\{,8}U+/")
  vim.bo.modified = false

  -- Write table cache
  if config.use_cache then
    local dir = vim.fn.fnamemodify(cache_file, ":h")
    if vim.fn.isdirectory(dir) == 0 then
      pcall(vim.fn.mkdir, dir, "p")
    end
    vim.fn.writefile(vim.fn.getline(1, "$"), cache_file)
  end

  afterload()
end

return M
