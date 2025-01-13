local logger = require("logger").init("cmdline")

local preview_commands = {}
-- G, IncRename, Subs, Reg, TrimTrailingWhitespace, Norm, Refactor, S
for key, attrs in pairs(vim.api.nvim_get_commands({ builtin = false })) do
  if attrs.preview then
    table.insert(preview_commands, key)
  end
end

-- manpages info
-- K or CTRL-]               Jump to the manpage for the <cWORD> under the cursor. Takes a count for the section.
-- CTRL-T                    Jump back to the location that the manpage was opened from.
-- gO                        Show the manpage outline. |gO|
-- q                        :quit if invoked as $MANPAGER, otherwise :close.
-- *g:no_man_maps*             Do not create mappings in manpage buffers.
-- *g:ft_man_folding_enable*   Fold manpages with foldmethod=indent foldnestmax=1.
-- *b:man_default_sects*       Comma-separated, ordered list of preferred sections.
-- For example in C one usually wants section 3 or 2: >
--   :let b:man_default_sections = '3,2'
--   *g:man_hardwrap*            Hard-wrap to $MANWIDTH or window width if $MANWIDTH is empty. Enabled by default. Set |FALSE| to enable soft wrapping.
--
-- :vertical Man printf
-- :hide Man printf
-- prevent hard wrapping with groff
-- export MANWIDTH=999

local get_substitute_flags = function(cmdline)
  local flags = vim.fn.matchstr(cmdline, "%(\\[a-zA-Z]\\)")
  -- local new_flags = ''
  -- if flags ~= '' then
  --   for i = 1, #flags do
  --     local flag = string.sub(flags, i, i)
  --     if flag == 'g' then
  --       new_flags = new_flags .. 'c'
  --     elseif flag == 'c' then
  --       new_flags = new_flags .. 'g'
  --     else
  --       new_flags = new_flags .. flag
  --     end
  --   end
  --   new_cmdline = vim.fn.substitute(cmdline, '%(\\[a-zA-Z]\\)', new_flags, '')
  -- else
  --   new_cmdline = cmdline .. 'c'
  -- end
  return flags
end

local function open_cmdline_with_path(path)
  local escaped =
    vim.api.nvim_replace_termcodes(": " .. vim.fn.fnameescape(path) .. "<Home>", true, false, true)
  vim.api.nvim_feedkeys(escaped, "n", false)
end

local open_last_search = function()
  local cmdline = vim.fn.getcmdline() or ""
  local cmdtype = vim.fn.getcmdtype() or ""
  local last_search = vim.fn.getreg("/")
  local fullpath = cmdline .. last_search
  if cmdtype == "/" or cmdtype == "?" then
    -- vim.api.nvim_feedkeys('/' .. fullpath, 'n', true)
    -- local escaped = vim.api.nvim_replace_termcodes(
    --   ': ' .. vim.fn.fnameescape(fullpath) .. '<Home>',
    --   true,
    --   false,
    --   true
    -- )
    local key = vim.api.nvim_replace_termcodes("<cr>", true, false, true)
    vim.api.nvim_feedkeys(key, "n", false)
    -- vim.api.nvim_feedkeys(escaped, 'n', false)
    -- if last_search ~= '' then
    --   vim.fn.setcmdline(fullpath)
    -- end
  else
    local key = vim.api.nvim_replace_termcodes("<C-c>", true, false, true)
    vim.api.nvim_feedkeys(key, "n", false)
    -- vim.api.nvim_feedkeys('/' .. fullpath, 'n', true)
    -- require('flash').jump({ continue = true })
    -- open_cmdline_with_path(fullpath)
  end
end

local toggle = function()
  local cmdline = vim.fn.getcmdline() or ""
  local cmdtype = vim.fn.getcmdtype() or ""
  local new_cmdline = nil
  local subs_prefixes = {
    ":s",
    ":S",
    "%:s",
    "%:substitute",
    "%:S",
    "%:Subvert",
    "%:sm",
    "%:smagic",
    "%:sno",
    "%:snomagic",
  } -- '%:g', '%:v', '%:m',

  local is_search = cmdtype == "/" or cmdtype == "?"
  local is_substitute = false
  for _, pfx in ipairs(subs_prefixes) do
    if string.sub(cmdline, 1, #pfx) == pfx then
      is_substitute = true
      break
    end
  end

  local toggle_inccommand = function()
    local new_inc = vim.o.inccommand == "nosplit" and "split" or "nosplit"
    vim.dbglog(vim.o.inccommand, new_inc)
    vim.api.nvim_set_option_value("inccommand", new_inc, { scope = "global" })
    vim.dbglog("inccommand: " .. vim.o.inccommand)
  end
  if is_search then
    -- TODO: toggle between search and very magic modes
    -- elseif string.sub(cmdline, 1, 3) == 'vim' then
    toggle_inccommand()
  elseif is_substitute then
    toggle_inccommand()
    -- TODO: close command line and re-open it to show notification
  elseif cmdline[1] == "!" then
    new_cmdline = cmdline:sub(2)
  elseif string.sub(cmdline, 1, 3) == "vim" then
    new_cmdline = "lua " .. cmdline
  elseif string.sub(cmdline, 1, 5) == "lua =" then
    new_cmdline = "lua " .. string.sub(cmdline, 6)
  elseif string.sub(cmdline, 1, 4) == "lua " then
    new_cmdline = "lua =" .. string.sub(cmdline, 5)
  elseif string.sub(cmdline, 1, 5) == "echom" then
    new_cmdline = string.sub(cmdline, 6)
  elseif string.sub(cmdline, 1, 4) == "echo" then
    new_cmdline = string.sub(cmdline, 5)
  elseif string.sub(cmdline, 1, 4) == "echo" then
    new_cmdline = string.sub(cmdline, 5)
  end
  if new_cmdline ~= nil then
    if cmdline ~= new_cmdline then
      vim.fn.setcmdline(new_cmdline)
      logger:info("cmdline from: " .. cmdline .. " to: " .. new_cmdline)
    end
  end
end

return { toggle = toggle, open_last_search = open_last_search }
