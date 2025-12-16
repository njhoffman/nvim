-- Spidercode ftplugin: Set up tree-sitter indentation for injected languages

-- Set reasonable defaults
vim.bo.shiftwidth = 2
vim.bo.tabstop = 2
vim.bo.expandtab = true

-- PSL (Percent Substitution Language) highlighting using matchadd
-- This works alongside treesitter without conflict
local function setup_psl_highlights()
  local hl = vim.api.nvim_set_hl
  hl(0, "pslMultiline", { fg = "#b48ead", default = true })
  hl(0, "pslDirective", { fg = "#b48ead", default = true })
  hl(0, "pslNegative", { fg = "#bf616a", default = true })
  hl(0, "pslPositive", { fg = "#a3be8c", default = true })
  hl(0, "pslImport", { fg = "#81a1c1", default = true })
  hl(0, "pslVariable", { fg = "#ebcb8b", default = true })

  -- Link treesitter's @keyword.directive to pslDirective for %spidercode% tags
  hl(0, "@keyword.directive.spidercode", { link = "pslDirective" })

  -- Higher priority = takes precedence (pslVariable is lowest so specific patterns win)
  -- Exclude MULTILINE and spidercode from pslVariable using negative lookahead
  vim.fn.matchadd("pslVariable", [[%\(MULTILINE\|spidercode\)\@![a-zA-Z_][a-zA-Z0-9_]*%]], 10)
  vim.fn.matchadd("pslNegative", [[%![^!]\+!%]], 11)
  vim.fn.matchadd("pslPositive", [[%?[^?]\+?%]], 11)
  -- Import: match opening %import and closing % separately so embedded vars get pslVariable
  vim.fn.matchadd("pslImport", [[%import ]], 11)
  vim.fn.matchadd("pslImport", [[\.\w\+\zs%\ze\($\|%\|<\)]], 11)
  vim.fn.matchadd("pslMultiline", [[^%MULTILINE%$]], 12)
end

vim.schedule(setup_psl_highlights)

-- Helper: Get the language for a given line number
local function get_line_lang(bufnr, lnum, parser, root)
  local line = vim.fn.getline(lnum)
  if line:match("^%%spidercode%%$") then
    return "tag"
  end

  local row = lnum - 1
  local node = root:named_descendant_for_range(row, 0, row, 0)
  while node do
    local node_type = node:type()
    if node_type == "code_content" then
      return "javascript"
    elseif node_type == "text_content" then
      return "html"
    end
    node = node:parent()
  end
  return "spidercode"
end

-- Helper: Find previous HTML line (skipping spidercode blocks entirely)
local function find_prev_html_line(bufnr, lnum, parser, root)
  local prev_lnum = lnum - 1
  while prev_lnum >= 1 do
    local lang = get_line_lang(bufnr, prev_lnum, parser, root)
    if lang == "html" then
      return prev_lnum
    end
    prev_lnum = prev_lnum - 1
  end
  return 0
end

-- Helper: Find the first line of the current JavaScript block
local function find_js_block_start(bufnr, lnum, parser, root)
  local start_lnum = lnum
  while start_lnum > 1 do
    local prev_lang = get_line_lang(bufnr, start_lnum - 1, parser, root)
    if prev_lang ~= "javascript" then
      break
    end
    start_lnum = start_lnum - 1
  end
  return start_lnum
end

-- Custom indentexpr that respects injected languages (HTML/JavaScript)
_G.spidercode_indentexpr = function()
  local lnum = vim.v.lnum
  local bufnr = vim.api.nvim_get_current_buf()

  -- Check if current line is a spidercode tag - always indent to 0
  local cur_line = vim.fn.getline(lnum)
  if cur_line:match("^%%spidercode%%$") then
    return 0
  end

  -- Get the spidercode parser to check node types
  local ok, parser = pcall(vim.treesitter.get_parser, bufnr, "spidercode")
  if not ok or not parser then
    return -1
  end

  parser:parse()
  local tree = parser:trees()[1]
  if not tree then
    return -1
  end

  local root = tree:root()
  local lang = get_line_lang(bufnr, lnum, parser, root)
  local sw = vim.bo.shiftwidth

  if lang == "javascript" then
    -- Find the first line of this JS block to determine base indent
    local block_start = find_js_block_start(bufnr, lnum, parser, root)

    -- For first line of JS block, use 0 indent (content starts at column 0)
    if lnum == block_start then
      return 0
    end

    -- Find previous non-blank line within the JS block
    local prev_lnum = vim.fn.prevnonblank(lnum - 1)
    if prev_lnum < block_start then
      return 0
    end

    local prev_line = vim.fn.getline(prev_lnum)
    local prev_indent = vim.fn.indent(prev_lnum)

    -- Simple JavaScript indentation rules
    -- Increase indent after lines ending with { or (
    if prev_line:match("[{(]%s*$") then
      return prev_indent + sw
    end

    -- Decrease indent for lines starting with } or )
    if cur_line:match("^%s*[})]") then
      return math.max(0, prev_indent - sw)
    end

    -- Increase indent after control statements without braces
    if prev_line:match("^%s*if%s*%(.*%)%s*$")
      or prev_line:match("^%s*else%s*$")
      or prev_line:match("^%s*for%s*%(.*%)%s*$")
      or prev_line:match("^%s*while%s*%(.*%)%s*$")
    then
      return prev_indent + sw
    end

    -- Maintain previous indent
    return prev_indent

  elseif lang == "html" then
    -- Check if current line is a closing tag
    local is_closing_tag = cur_line:match("^%s*</%s*(%w+)")
    local closing_tag_name = is_closing_tag

    -- Check if we just exited a spidercode block
    local immediate_prev = vim.fn.prevnonblank(lnum - 1)
    local immediate_prev_line = vim.fn.getline(immediate_prev)
    local after_spidercode = immediate_prev_line:match("^%%spidercode%%$")

    if is_closing_tag then
      -- For closing tags, find the matching opening tag's indent
      -- Search backwards through HTML lines
      local search_lnum = lnum - 1
      local depth = 1
      while search_lnum >= 1 and depth > 0 do
        local search_lang = get_line_lang(bufnr, search_lnum, parser, root)
        if search_lang == "html" then
          local search_line = vim.fn.getline(search_lnum)
          -- Check for closing tag of same name
          if search_line:match("</%s*" .. closing_tag_name .. "%s*>") then
            depth = depth + 1
          end
          -- Check for opening tag of same name
          if search_line:match("<%s*" .. closing_tag_name .. "[%s>]") then
            depth = depth - 1
            if depth == 0 then
              return vim.fn.indent(search_lnum)
            end
          end
        end
        search_lnum = search_lnum - 1
      end
      -- Fallback: use previous HTML line indent
      local prev_html_lnum = find_prev_html_line(bufnr, lnum, parser, root)
      return prev_html_lnum > 0 and vim.fn.indent(prev_html_lnum) or 0
    end

    -- Find previous HTML line (skipping entire spidercode blocks)
    local prev_html_lnum = find_prev_html_line(bufnr, lnum, parser, root)
    if prev_html_lnum == 0 then
      return 0
    end

    local prev_line = vim.fn.getline(prev_html_lnum)
    local prev_indent = vim.fn.indent(prev_html_lnum)

    if after_spidercode then
      -- Just exited a spidercode block, maintain context from before the block
      return prev_indent
    end

    -- Standard HTML indentation logic
    -- Increase indent after opening tags (not self-closing, not with closing on same line)
    if prev_line:match("<%w[^/>]*>%s*$") and not prev_line:match("</%w") then
      return prev_indent + sw
    end

    return prev_indent
  end

  -- Default: maintain previous indent
  return -1
end

-- Defer to ensure it runs after other plugins
vim.schedule(function()
  if vim.bo.filetype == "spidercode" then
    vim.bo.indentexpr = "v:lua.spidercode_indentexpr()"
  end
end)
