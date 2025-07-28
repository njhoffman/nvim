local set_option = vim.api.nvim_set_option_value
local logger = require("logger").init("autocmd-win")
local augroup = vim.api.nvim_create_augroup("AutocmdWindows", { clear = true })

-- Indent wrapped lines based on indent settings except for ignored filetypes
---@alias option_scope "global" | "local" | nil
---@param scope option_scope
local function set_breakindentopt(scope)
  local indent
  if vim.api.nvim_get_option_value("expandtab", { scope = scope }) then
    indent = vim.api.nvim_get_option_value("shiftwidth", { scope = scope })
  else
    indent = vim.api.nvim_get_option_value("tabstop", { scope = scope })
  end

  local indent_min = 20
  local indentopt = "shift:" .. indent .. "," .. "min:" .. indent_min

  logger:debug("set breakindentopt to " .. indentopt)
  vim.api.nvim_set_option_value("breakindentopt", indentopt, { scope = scope })
end

-- This autocmd implicitly rely on `vim-sleuth` to trigger
vim.api.nvim_create_autocmd({ "OptionSet" }, {
  group = augroup,
  pattern = { "expandtab", "shiftwidth", "tabstop" },
  desc = "Set 'breakindentopt' based on indent settings",
  callback = function(args)
    local ignored_filetypes = { "text", "markdown", "org", "codecompanion" }

    local is_ignored_filetype = vim.tbl_contains(ignored_filetypes, vim.bo[args.buf].filetype)
    ---@type option_scope
    local scope = vim.v.option_type
    if vim.v.option_command == "set" and not is_ignored_filetype then
      scope = nil
    end

    if scope == "local" and is_ignored_filetype then
    else
      set_breakindentopt(scope)
    end
  end,
})

local line_numbers = function(ev)
  local winid = vim.fn.bufwinid(ev.buf)
  if winid > -1 and vim.api.nvim_win_is_valid(winid) then
    local always_off = {
      filetypes = {},
      buftypes = { "nofile", "quickfix", "prompt", "help" },
    }

    local entering = ev.event == "BufEnter" or ev.event == "FocusGained"

    local num_enabled = not vim.g.zen_mode_active
      and not vim.bo.modifiable
      and not vim.bo.readonly
      and not vim.tbl_contains(always_off.buftypes, vim.bo.buftype)
      and not vim.tbl_contains(always_off.filetypes, vim.bo.filetype)

    if entering and num_enabled then
      vim.cmd([[set relativenumber number]])
    elseif not entering then
      vim.cmd([[set norelativenumber nonumber]])
    end
  end
end

local enable_list = function()
  vim.w.list_enabled = vim.wo.list
  vim.wo.list = false
end

local disable_list = function()
  if vim.w.list_enabled ~= nil then
    vim.wo.list = vim.w.list_enabled
  end
end

local handle_special = function()
  vim.defer_fn(function()
    -- no list chars in special buffers
    if vim.bo.buftype ~= "" and vim.bo.ft ~= "query" then
      disable_list()
    end
  end, 1)
end

local highlight_yank = function()
  if vim.v.event.operator == "y" then
    -- Highlight the yanked area
    vim.highlight.on_yank({
      hlgroup = "Visual", -- IncRename
      on_visual = true,
      on_macro = true,
      timeout = 150,
    })
  end
end

local goto_last_pos = function(bufnr, event)
  local options = {
    open_folds = 1,
    ignore = {
      buftypes = { "quickfix", "nofile", "help" },
      filetypes = { "gitcommit", "gitrebase", "svn", "hgcommit" },
    },
  }

  -- scroll to line if included in startup args
  if vim.v.vim_did_enter == 0 then
    local last_arg = vim.v.argv[#vim.v.argv]
    if last_arg:match("^%+%d+$") then
      return vim.api.nvim_command("keepjumps normal " .. last_arg:gsub("%+", "") .. "G")
    end
  end

  local winid = vim.fn.bufwinid(bufnr)

  --     local line, col = unpack(vim.api.nvim_buf_get_mark(bufnr, '"'))
  local pos = {
    exit_line = vim.fn.line([['"]], winid),
    exit_col = vim.fn.col([['"]], winid),

    buf_last = vim.fn.line("$", winid),
    win_first = vim.fn.line("w0", winid),
    win_last = vim.fn.line("w$", winid),
    end_line = vim.api.nvim_buf_line_count(bufnr),
  }
  pos.end_col = #vim.api.nvim_buf_get_lines(bufnr, pos.end_line - 1, pos.end_line, true)[1]

  local buf = {
    name = vim.api.nvim_buf_get_name(bufnr),
    type = vim.api.nvim_get_option_value("buftype", { buf = bufnr }),
    ft = vim.api.nvim_get_option_value("filetype", { buf = bufnr }),
  }

  if
    vim.tbl_contains(options.ignore.buftypes, buf.type)
    or vim.tbl_contains(options.ignore.filetypes, buf.ft)
  then
    return logger:debug(
      "restore skip (" .. bufnr .. ") - " .. buf.name .. " " .. buf.type .. " " .. buf.ft
    )
  end

  local scroll_cmd = nil
  -- if the last line is set and the less than the last line in the buffer
  if pos.exit_line > 0 and pos.exit_line <= pos.buf_last then
    if pos.win_last == pos.buf_last then
      scroll_cmd = [[keepjumps normal! g`"]]
    elseif pos.buf_last - pos.exit_line > ((pos.win_last - pos.win_first) / 2) - 1 then
      -- vim.api.nvim_command([[keepjumps normal! g`"zz]])
      scroll_cmd = [[keepjumps normal! g`"]]
    else
      scroll_cmd = [[keepjumps normal! G'"<c-e>]]
    end
  end
  if scroll_cmd then
    vim.api.nvim_command(scroll_cmd)
    logger:debug(event .. ": scroll " .. scroll_cmd)
  end

  if
    pos.exit_line < pos.end_line or (pos.exit_line == pos.end_line and pos.exit_col <= pos.end_col)
  then
    logger:debug(event .. ": restore (" .. bufnr .. ") " .. pos.exit_line .. ":" .. pos.exit_col)
    vim.api.nvim_win_set_cursor(winid, { pos.exit_line, pos.exit_col })
  end

  -- if vim.fn.foldclosed(vim.fn.line(".")) ~= -1 and options.open_folds == 1 then
  --   vim.api.nvim_command([[normal! zvzz]])
  -- end
  --  -- vim.api.nvim_command('keepjumps normal ' .. pos[2] .. 'G')
  --  -- vim.api.nvim_command('keepjumps normal ' .. pos[3] .. 'l')
end

local restore_cursor = function(opts)
  -- last selected position  '< and '>  last position before jump  '' ``
  -- last exited position    '" `"      last change position       '. `.
  -- last insert position    '^ `^      last affected text area    '[ and ']
  vim.api.nvim_create_autocmd("BufRead", {
    group = augroup,
    buffer = opts.buf,
    callback = function()
      goto_last_pos(opts.buf, opts.event)
    end,
  })
end

return {
  enable_list = enable_list,
  disable_list = disable_list,
  highlight_yank = highlight_yank,
  restore_cursor = restore_cursor,
  handle_special = handle_special,
  line_numbers = line_numbers,
}
