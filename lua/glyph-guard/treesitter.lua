local M = {}

local QUERIES = {
  lua = "(string) @s",
  bash = "[(string) (raw_string) (ansi_c_string) (translated_string)] @s",
}

local function lang_for(ft)
  if ft == "sh" or ft == "zsh" or ft == "bash" then
    return "bash"
  end
  if ft == "lua" then
    return "lua"
  end
  return nil
end

local function parse_query(lang)
  local ok, q = pcall(vim.treesitter.query.parse, lang, QUERIES[lang])
  if ok then
    return q
  end
  return nil
end

local function node_to_range(node, source)
  local sr, sc, er, ec = node:range()
  local text = vim.treesitter.get_node_text(node, source)
  local quote = text and text:sub(1, 1) or nil
  if quote ~= '"' and quote ~= "'" then
    quote = nil
  end
  return {
    start_row = sr,
    start_col = sc,
    end_row = er,
    end_col = ec,
    quote = quote,
  }
end

function M.collect_buffer_strings(bufnr, ft)
  local lang = lang_for(ft or vim.bo[bufnr].filetype)
  if not lang then
    return nil
  end

  local ok, parser = pcall(vim.treesitter.get_parser, bufnr, lang)
  if not ok or not parser then
    return nil
  end

  local tree = (parser:parse() or {})[1]
  if not tree then
    return nil
  end

  local query = parse_query(lang)
  if not query then
    return nil
  end

  local ranges = {}
  for _, node in query:iter_captures(tree:root(), bufnr) do
    table.insert(ranges, node_to_range(node, bufnr))
  end
  return ranges
end

function M.collect_source_strings(source, ft)
  local lang = lang_for(ft)
  if not lang then
    return nil
  end

  local ok, parser = pcall(vim.treesitter.get_string_parser, source, lang)
  if not ok or not parser then
    return nil
  end

  local tree = (parser:parse() or {})[1]
  if not tree then
    return nil
  end

  local query = parse_query(lang)
  if not query then
    return nil
  end

  local ranges = {}
  for _, node in query:iter_captures(tree:root(), source) do
    table.insert(ranges, node_to_range(node, source))
  end
  return ranges
end

function M.find_range(ranges, row, col)
  if not ranges then
    return nil
  end
  for _, r in ipairs(ranges) do
    if row >= r.start_row and row <= r.end_row then
      local after_start = row > r.start_row or col >= r.start_col
      local before_end = row < r.end_row or col < r.end_col
      if after_start and before_end then
        return r
      end
    end
  end
  return nil
end

return M
