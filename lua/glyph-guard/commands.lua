local M = {}
local preview_ns = vim.api.nvim_create_namespace("glyph-guard_preview")

local function to_qf(findings)
  local items = {}
  for _, f in ipairs(findings) do
    local text = f.char .. " " .. f.codepoint
    if f.name then
      text = text .. " (" .. f.name .. ")"
    end
    table.insert(items, {
      filename = f.filename,
      lnum = f.lnum,
      col = f.col + 1,
      text = text,
    })
  end
  table.sort(items, function(a, b)
    if a.filename == b.filename then
      if a.lnum == b.lnum then
        return a.col < b.col
      end
      return a.lnum < b.lnum
    end
    return (a.filename or "") < (b.filename or "")
  end)
  return items
end

local function open_qf(cfg, count)
  local mode = cfg.ui.auto_open_qf
  if mode == "always" or (mode == "on_results" and count > 0) then
    vim.cmd("copen")
  end
end

local function write_file(buf, path, cfg)
  local behavior = cfg.write.behavior
  if behavior == "confirm" then
    if vim.fn.confirm("Write " .. path .. "?", "&Yes\n&No", 1) ~= 1 then
      return
    end
  end
  local cmd = behavior == "silent" and "silent write" or "write"
  vim.api.nvim_buf_call(buf, function()
    vim.cmd(cmd)
  end)
  if behavior == "notify" then
    vim.notify("glyph-guard: wrote " .. path)
  end
end

local function filetype_enabled(cfg, ft)
  for _, v in ipairs(cfg.filetypes) do
    if v == ft then
      return true
    end
  end
  return false
end

local function refresh_ui(buf, findings, cfg)
  local ui = require("glyph-guard.ui")
  ui.clear(buf)
  ui.show(findings, buf, cfg)
end

local function clear_preview(buf)
  vim.api.nvim_buf_clear_namespace(buf, preview_ns, 0, -1)
end

function M.register(cfg, reg)
  local scanner = require("glyph-guard.scanner")
  local fixer = require("glyph-guard.fixer")
  local escape = require("glyph-guard.escape")

  vim.api.nvim_create_user_command("GlyphCheck", function(opts)
    local arg = opts.args
    local findings

    if arg == "" then
      local ft = vim.bo[0].filetype
      if not filetype_enabled(cfg, ft) then
        vim.notify("glyph-guard: filetype not enabled: " .. ft)
        return
      end
      clear_preview(0)
      findings = scanner.scan_buffer(0, cfg, reg)
      refresh_ui(0, findings, cfg)
    else
      local path = vim.fn.fnamemodify(vim.fn.expand(arg), ":p")
      if vim.fn.isdirectory(path) == 1 then
        findings = scanner.scan_paths({ path }, cfg, reg)
      else
        local bufnr = vim.fn.bufnr(path)
        if bufnr ~= -1 and vim.api.nvim_buf_is_loaded(bufnr) then
          clear_preview(bufnr)
          findings = scanner.scan_buffer(bufnr, cfg, reg)
          refresh_ui(bufnr, findings, cfg)
        else
          findings = scanner.scan_file(path, cfg, reg)
        end
      end
    end

    local items = to_qf(findings)
    vim.fn.setqflist({}, "r", { title = "GlyphCheck", items = items })

    if #items == 0 then
      vim.notify("glyph-guard: no glyphs found")
    end

    open_qf(cfg, #items)
  end, { nargs = "?", complete = "file" })

  vim.api.nvim_create_user_command("GlyphEscape", function(opts)
    clear_preview(0)
    local findings = scanner.scan_buffer(0, cfg, reg)
    if opts.range == 2 then
      findings = vim.tbl_filter(function(f)
        return f.lnum >= opts.line1 and f.lnum <= opts.line2
      end, findings)
    end
    fixer.apply_buffer(0, findings, cfg)
    local after = scanner.scan_buffer(0, cfg, reg)
    refresh_ui(0, after, cfg)
    vim.fn.setqflist({}, "r", { title = "GlyphEscape", items = to_qf(findings) })
  end, { range = true })

  vim.api.nvim_create_user_command("GlyphPreview", function(opts)
    clear_preview(0)
    if opts.bang then
      return
    end
    local ft = vim.bo[0].filetype
    if not filetype_enabled(cfg, ft) then
      vim.notify("glyph-guard: filetype not enabled: " .. ft)
      return
    end
    local lang = escape.lang_of(ft)
    local findings = scanner.scan_buffer(0, cfg, reg)
    local by_line = {}
    for _, f in ipairs(findings) do
      by_line[f.lnum] = by_line[f.lnum] or {}
      table.insert(by_line[f.lnum], f)
    end
    for lnum, items in pairs(by_line) do
      local parts = {}
      for _, f in ipairs(items) do
        local repl = escape.replacement(f, lang)
        table.insert(parts, repl)
      end
      vim.api.nvim_buf_set_extmark(0, preview_ns, lnum - 1, 0, {
        virt_text = { { "→ " .. table.concat(parts, " "), "Comment" } },
        virt_text_pos = "eol",
      })
    end
    if #findings == 0 then
      vim.notify("glyph-guard: no glyphs to preview")
    end
  end, { bang = true })

  vim.api.nvim_create_user_command("GlyphEscapeQF", function()
    local list = vim.fn.getqflist()
    if #list == 0 then
      vim.notify("glyph-guard: quickfix empty")
      return
    end

    local files = {}
    for _, entry in ipairs(list) do
      local name = entry.filename
      if (not name or name == "") and entry.bufnr and entry.bufnr > 0 then
        name = vim.api.nvim_buf_get_name(entry.bufnr)
      end
      if name and name ~= "" then
        files[name] = true
      end
    end

    local total_files, total = 0, 0
    local progress = cfg.progress and cfg.progress.enabled

    for f in pairs(files) do
      if progress then
        vim.notify("glyph-guard: fixing " .. f)
      end

      local buf = vim.fn.bufadd(f)
      vim.fn.bufload(buf)

      local res = scanner.scan_buffer(buf, cfg, reg)
      total = total + #res
      total_files = total_files + 1

      fixer.apply_buffer(buf, res, cfg)
      write_file(buf, f, cfg)
    end

    vim.notify(string.format("glyph-guard: fixed %d files, %d glyphs", total_files, total))
  end, {})
end

return M
