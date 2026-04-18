local scanner = require("glyph-guard.scanner")

local function make_buf(lines, ft)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  if ft then
    vim.bo[buf].filetype = ft
  end
  return buf
end

local cfg = {
  detect = { pua = true, non_ascii = false },
  filetypes = { "lua" },
  extensions = { ".lua" },
  scan = { ignore = {} },
  progress = { enabled = false },
}

local reg = { by_codepoint = { [0xE0B0] = "sep_right" } }

describe("glyph_guard.scanner", function()
  it("finds PUA codepoints in a buffer", function()
    local buf = make_buf({ 'local x = "\u{E0B0}"' })
    local findings = scanner.scan_buffer(buf, cfg, reg)
    assert.are.equal(1, #findings)
    assert.are.equal(0xE0B0, findings[1].cp)
    assert.are.equal("U+E0B0", findings[1].codepoint)
    assert.are.equal("sep_right", findings[1].name)
    vim.api.nvim_buf_delete(buf, { force = true })
  end)

  it("ignores non-PUA characters when only pua detection is enabled", function()
    local buf = make_buf({ "local x = '\u{2713}'" })
    local findings = scanner.scan_buffer(buf, cfg, reg)
    assert.are.equal(0, #findings)
    vim.api.nvim_buf_delete(buf, { force = true })
  end)

  it("detects non-ascii when enabled", function()
    local buf = make_buf({ "local x = '\u{2713}'" })
    local c = vim.tbl_deep_extend("force", cfg, { detect = { pua = false, non_ascii = true } })
    local findings = scanner.scan_buffer(buf, c, reg)
    assert.is_true(#findings >= 1)
    vim.api.nvim_buf_delete(buf, { force = true })
  end)

  it("survives malformed UTF-8 without crashing", function()
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "abc\xC3\xC3xyz" })
    local ok, findings = pcall(scanner.scan_buffer, buf, cfg, reg)
    assert.is_true(ok)
    assert.are.equal(0, #findings)
    vim.api.nvim_buf_delete(buf, { force = true })
  end)

  it("reports byte columns zero-indexed", function()
    local buf = make_buf({ 'x="\u{E0B0}"' })
    local findings = scanner.scan_buffer(buf, cfg, reg)
    assert.are.equal(3, findings[1].col)
    assert.are.equal(3, findings[1].size)
    vim.api.nvim_buf_delete(buf, { force = true })
  end)
end)
