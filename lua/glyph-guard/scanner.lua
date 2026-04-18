local M = {}
local treesitter = require("glyph-guard.treesitter")
local ignore = require("glyph-guard.ignore")

local function utf8_iter(str)
  local i, len = 1, #str
  return function()
    while i <= len do
      local start = i
      local b1 = str:byte(i)

      if b1 < 0x80 then
        i = i + 1
        return start, b1, 1
      elseif b1 < 0xC2 then
        i = i + 1
      elseif b1 < 0xE0 then
        local b2 = str:byte(i + 1)
        if b2 and b2 >= 0x80 and b2 < 0xC0 then
          local cp = (b1 - 0xC0) * 0x40 + (b2 - 0x80)
          i = i + 2
          return start, cp, 2
        end
        i = i + 1
      elseif b1 < 0xF0 then
        local b2 = str:byte(i + 1)
        local b3 = str:byte(i + 2)
        if b2 and b3 and b2 >= 0x80 and b2 < 0xC0 and b3 >= 0x80 and b3 < 0xC0 then
          local cp = (b1 - 0xE0) * 0x1000 + (b2 - 0x80) * 0x40 + (b3 - 0x80)
          i = i + 3
          return start, cp, 3
        end
        i = i + 1
      elseif b1 < 0xF8 then
        local b2 = str:byte(i + 1)
        local b3 = str:byte(i + 2)
        local b4 = str:byte(i + 3)
        if
          b2
          and b3
          and b4
          and b2 >= 0x80
          and b2 < 0xC0
          and b3 >= 0x80
          and b3 < 0xC0
          and b4 >= 0x80
          and b4 < 0xC0
        then
          local cp = (b1 - 0xF0) * 0x40000
            + (b2 - 0x80) * 0x1000
            + (b3 - 0x80) * 0x40
            + (b4 - 0x80)
          i = i + 4
          return start, cp, 4
        end
        i = i + 1
      else
        i = i + 1
      end
    end
    return nil
  end
end

local function is_pua(cp)
  return cp >= 0xE000 and cp <= 0xF8FF
end

local function should(cp, cfg)
  return (cfg.detect.pua and is_pua(cp)) or (cfg.detect.non_ascii and cp > 127)
end

local function scan_lines(lines, file, bufnr, cfg, reg, ranges)
  local out = {}
  local gated = ranges ~= nil
  for i, line in ipairs(lines) do
    for idx, cp, size in utf8_iter(line) do
      if should(cp, cfg) then
        local range = gated and treesitter.find_range(ranges, i - 1, idx - 1) or nil
        if not gated or range then
          table.insert(out, {
            filename = file,
            bufnr = bufnr,
            lnum = i,
            col = idx - 1,
            cp = cp,
            size = size,
            char = line:sub(idx, idx + size - 1),
            codepoint = string.format("U+%04X", cp),
            name = reg.by_codepoint[cp],
            quote = range and range.quote or nil,
          })
        end
      end
    end
  end
  return out
end

function M.scan_buffer(bufnr, cfg, reg)
  local ft = vim.bo[bufnr].filetype
  local ranges = treesitter.collect_buffer_strings(bufnr, ft)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  return scan_lines(lines, vim.api.nvim_buf_get_name(bufnr), bufnr, cfg, reg, ranges)
end

function M.scan_file(path, cfg, reg)
  local ok, lines = pcall(vim.fn.readfile, path)
  if not ok then
    return {}
  end
  local source = table.concat(lines, "\n")
  local ft = vim.filetype.match({ filename = path }) or ""
  local ranges = treesitter.collect_source_strings(source, ft)
  return scan_lines(lines, path, nil, cfg, reg, ranges)
end

local function collect_files(paths, cfg, is_ignored)
  local files = {}
  for _, p in ipairs(paths) do
    if vim.fn.isdirectory(p) == 1 then
      for _, f in ipairs(vim.fn.globpath(p, "**/*", true, true)) do
        if vim.fn.isdirectory(f) == 0 and not is_ignored(f) then
          table.insert(files, f)
        end
      end
    else
      if not is_ignored(p) then
        table.insert(files, p)
      end
    end
  end
  return files
end

function M.scan_paths(paths, cfg, reg)
  local is_ignored = ignore.matcher(cfg.scan and cfg.scan.ignore or {})
  local files = collect_files(paths, cfg, is_ignored)

  local progress = cfg.progress and cfg.progress.enabled
  local total = #files
  local findings = {}

  for i, f in ipairs(files) do
    for _, e in ipairs(cfg.extensions) do
      if f:sub(-#e) == e then
        for _, r in ipairs(M.scan_file(f, cfg, reg)) do
          table.insert(findings, r)
        end
        break
      end
    end
    if progress and total >= 50 and i % 50 == 0 then
      vim.notify(string.format("glyph-guard: scanned %d/%d files", i, total))
    end
  end

  return findings
end

return M
