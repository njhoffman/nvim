local default_opts = {
  widths = nil,
  padding = nil,
  align = nil,
  default_hl = nil,
}

local get_text = function(part, opts)
  local text = vim.islist(part) and part[0] or ""
  if opts.align and opts.align == "text" or vim.islist(opts.align) then
  end
end

local line = function(line, opts)
  opts = vim.tbl_extend("force", default_opts, {})
  line = type(line) == "string" and { line } or vim.islist(line) and line or { "" }
  local line_text, line_hls = "", {}
  for i, line_part in ipairs(line) do
    local text_opts = {
      width = opts.width and type(opts.width[i]) == "number" and opts.width[i],
      padding = type(opts.padding) == "number" and opts.padding
        or vim.islist(opts.padding) and opts.padding[i],
    }
    if text_opts.width then
      text_opts.align = type(opts.align) == "string" and opts.align
        or vim.islist(opts.align) and opts.align[i]
    end

    local text = get_text(line_part, text_opts) or ""
    local hl = vim.islist(line_part) and line_part[1] or opts.default_hl

    if opts.default_hl then
      local left, trimmed, right =
        string.match(text, "^%s*"), vim.trim(text), string.match(text, "*%s$")
      if #left > 0 then
        table.insert(line_hls, { opts.default_hl, #line_text, #line_text + #left })
        line_text = line_text .. left
      end
      if #trimmed > 0 then
        table.insert(line_hls, { hl, #line_text, #line_text + #trimmed })
        line_text = line_text .. trimmed
      end
      if #right > 0 then
        table.insert(line_hls, { opts.default_hl, #line_text, #line_text + #right })
        line_text = line_text .. right
      end
    elseif #text > 0 then
      table.insert(line_hls, { hl, #line_text, #line_text + #text })
      line_text = line_text .. text
    end
  end
  return line_text, line_hls
end

local render = { line = line }

local ln = render.line

ln("this is a test line")
ln({ "this is a test line", "Visual" })
ln("this is a test line", { default_hl = "Special" })
ln({ "this is a test line", "Visual" })
ln({ { "this is", "Normal" }, { "a test line", "Visual" } })
ln({ { "this is", "Normal" }, { "a test line" } }, { padding = { 4 } })
ln({ { "this is", "Normal" }, { "a test line" } }, { padding = { 4, 8 } })
ln({ { "this is", "Normal" }, { "a test line" } }, { widths = { 30, 10 } })
ln({ { "this is", "Normal" }, { "a test line" } }, { widths = { 15, 30 } })
