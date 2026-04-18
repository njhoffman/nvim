#!/bin/bash

mkdir -p ~/.config/nvim/lua/glyph_guard

cat > ~/.config/nvim/glyphs.json << 'EOF'
{
  "sep_right": { "codepoint": "U+E0B0" },
  "branch": { "codepoint": "U+E0A0" },
  "check": { "codepoint": "U+2713" }
}
EOF

cat > ~/.config/nvim/lua/glyph_guard/init.lua << 'EOF'
local M = {}

local defaults = {
  registry_path = vim.fn.stdpath("config") .. "/glyphs.json",
  detect = { pua = true, non_ascii = false },
  filetypes = { "lua", "sh", "bash", "zsh" },
  extensions = { ".lua", ".sh", ".zsh" },
  scan = { ignore = {} },
  ui = { highlight = "WarningMsg", auto_open_qf = "on_results" },
  write = { behavior = "notify" },
  progress = { enabled = true },
}

function M.setup(opts)
  local config = vim.tbl_deep_extend("force", defaults, opts or {})
  local registry = require("glyph_guard.registry").load(config.registry_path)
  require("glyph_guard.commands").register(config, registry)
end

return M
EOF

cat > ~/.config/nvim/lua/glyph_guard/registry.lua << 'EOF'
local M = {}

local function normalize(str)
  local hex = str:match("^U%+([0-9A-Fa-f]+)$")
  if not hex then return nil end
  return tonumber(hex, 16)
end

function M.load(path)
  local ok, lines = pcall(vim.fn.readfile, path)
  if not ok then return { by_codepoint = {} } end

  local ok2, data = pcall(vim.fn.json_decode, table.concat(lines, "\n"))
  if not ok2 then return { by_codepoint = {} } end

  local map = {}
  for name, entry in pairs(data) do
    local cp = normalize(entry.codepoint)
    if cp then map[cp] = name end
  end

  return { by_codepoint = map }
end

return M
EOF

cat > ~/.config/nvim/lua/glyph_guard/registry.lua << 'EOF'
local M = {}

local function normalize(str)
  local hex = str:match("^U%+([0-9A-Fa-f]+)$")
  if not hex then return nil end
  return tonumber(hex, 16)
end

function M.load(path)
  local ok, lines = pcall(vim.fn.readfile, path)
  if not ok then return { by_codepoint = {} } end

  local ok2, data = pcall(vim.fn.json_decode, table.concat(lines, "\n"))
  if not ok2 then return { by_codepoint = {} } end

  local map = {}
  for name, entry in pairs(data) do
    local cp = normalize(entry.codepoint)
    if cp then map[cp] = name end
  end

  return { by_codepoint = map }
end

return M
EOF

cat > ~/.config/nvim/lua/glyph_guard/scanner.lua << 'EOF'
 local M = {}

 local function utf8_iter(str)
   local i, len = 1, #str
   return function()
     if i > len then return nil end
     local start = i
     local b1 = str:byte(i)
     local cp, size = b1, 1

     if b1 < 0x80 then
       cp = b1
     elseif b1 < 0xE0 then
       local b2 = str:byte(i+1)
       cp = (b1 % 0x20) * 0x40 + (b2 % 0x40)
       size = 2
     elseif b1 < 0xF0 then
       local b2 = str:byte(i+1)
       local b3 = str:byte(i+2)
       cp = (b1 % 0x10) * 0x1000 + (b2 % 0x40) * 0x40 + (b3 % 0x40)
       size = 3
     else
       local b2 = str:byte(i+1)
       local b3 = str:byte(i+2)
       local b4 = str:byte(i+3)
       cp = (b1 % 0x08) * 0x40000 + (b2 % 0x40) * 0x1000 + (b3 % 0x40) * 0x40 + (b4 % 0x40)
       size = 4
     end

     i = i + size
     return start, cp, size
   end
 end

 local function is_pua(cp)
   return cp >= 0xE000 and cp <= 0xF8FF
 end

 local function should(cp, cfg)
   return (cfg.detect.pua and is_pua(cp))
       or (cfg.detect.non_ascii and cp > 127)
 end

 local function is_escaped(line, idx)
   local s = math.max(1, idx - 10)
   return line:sub(s, idx-1):match("\\u%{%x+$") ~= nil                                                                                                                                                                                                                        ▀
 end


     local function scan_lines(lines, file, bufnr, cfg, reg)
       local out = {}
       for i, line in ipairs(lines) do
         for idx, cp, size in utf8_iter(line) do
           if should(cp, cfg) and not is_escaped(line, idx) then
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
             })
           end
         end
       end
       return out
     end



 function M.scan_buffer(bufnr, cfg, reg)
   local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
   return scan_lines(lines, vim.api.nvim_buf_get_name(bufnr), bufnr, cfg, reg)
 end

 function M.scan_file(path, cfg, reg)
   local ok, lines = pcall(vim.fn.readfile, path)
   if not ok then return {} end
   return scan_lines(lines, path, nil, cfg, reg)
 end

 function M.scan_paths(paths, cfg, reg)
   local files, findings = {}, {}
   for _, p in ipairs(paths) do
     if vim.fn.isdirectory(p) == 1 then
       for _, f in ipairs(vim.fn.globpath(p, "**/*", true, true)) do
         table.insert(files, f)
       end
     else
       table.insert(files, p)
     end
   end

   for _, f in ipairs(files) do
     for _, e in ipairs(cfg.extensions) do
       if f:sub(-#e) == e then
         for _, r in ipairs(M.scan_file(f, cfg, reg)) do
           table.insert(findings, r)
         end
       end
     end
   end

   return findings
 end

 return M
EOF

##
