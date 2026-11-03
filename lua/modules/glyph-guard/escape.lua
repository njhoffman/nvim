local M = {}

local function fmt_lua(cp)
  return string.format("\\u{%04X}", cp)
end

local function fmt_shell(cp)
  if cp <= 0xFFFF then
    return string.format("$'\\u%04X'", cp)
  end
  return string.format("$'\\U%08X'", cp)
end

function M.lang_of(ft)
  if ft == "sh" or ft == "bash" or ft == "zsh" then
    return "shell"
  end
  return "lua"
end

function M.format(cp, lang)
  if lang == "shell" then
    return fmt_shell(cp)
  end
  return fmt_lua(cp)
end

function M.replacement(f, lang)
  if lang == "shell" and f.quote then
    return f.quote .. fmt_shell(f.cp) .. f.quote, false
  elseif lang == "shell" then
    return fmt_lua(f.cp), true
  end
  return fmt_lua(f.cp), false
end

return M
