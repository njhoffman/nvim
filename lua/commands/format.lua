local state = { timer = nil }
local ns_id = vim.api.nvim_create_namespace("commands/format")

-- local function throttle(func, delay)
--   if state.timer then
--     return
--   end
--   state.timer = vim.fn.timer_start(delay, function()
--     -- local args = { ... }
--     pcall(vim.schedule_wrap(function()
--       func(config)
--     end))
--     vim.fn.timer_stop(state.timer)
--     state.timer = nil
--   end)
-- end

-- vim.api.nvim_create_user_command("PasteChar", function()
--   local txt = vim.g
-- end, { desc = "Paste primary buffer charwise (strip line endings)" })
-- vim.api.nvim_create_user_command( "PasteLinewise"
-- )

local checked_checkbox = "%[[xX]%]"
local unchecked_checkbox = "%[ %]"

local bullet_prefix = "^%s*[%-%*%+] "
local numbered_prefix = "^%s*%d+%. "

local line_contains_unchecked = function(line)
  return line:find(unchecked_checkbox)
end

local line_contains_checked = function(line)
  return line:find(checked_checkbox)
end

local line_with_checkbox = function(line)
  return line:find(bullet_prefix .. checked_checkbox)
    or line:find(bullet_prefix .. unchecked_checkbox)
    or line:find(numbered_prefix .. checked_checkbox)
    or line:find(numbered_prefix .. unchecked_checkbox)
end

local checkbox = {
  check = function(line)
    return line:gsub(unchecked_checkbox, "[x]", 1)
  end,
  uncheck = function(line)
    return line:gsub(checked_checkbox, "[ ]", 1)
  end,
  make_checkbox = function(line)
    if line:match("^%s*[%-%*%+]%s") then
      -- "- xxx" / "* xxx" / "+ xxx" -> "- [ ] xxx" etc.
      return line:gsub("^(%s*[%-%*%+] )(.*)", "%1[ ] %2", 1)
    elseif line:match("^%s*%d+%.%s") then
      -- "1. xxx" -> "1. [ ] xxx"
      return line:gsub("^(%s*%d+%. )(.*)", "%1[ ] %2", 1)
    else
      -- "xxx" -> "- [ ] xxx"
      return line:gsub("(%S+)", "- [ ] %1", 1)
    end
  end,
}

local toggle_checkbox = function()
  local bufnr = vim.api.nvim_buf_get_number(0) --
  local cursor = vim.api.nvim_win_get_cursor(0)
  local start_line = cursor[1] - 1
  local current_line = vim.api.nvim_buf_get_lines(bufnr, start_line, start_line + 1, false)[1] or ""

  -- If the line contains a checked checkbox then uncheck it.
  -- Otherwise, if it contains an unchecked checkbox, check it.
  local new_line = ""

  if not line_with_checkbox(current_line) then
    new_line = checkbox.make_checkbox(current_line)
  elseif line_contains_unchecked(current_line) then
    new_line = checkbox.check(current_line)
  elseif line_contains_checked(current_line) then
    new_line = checkbox.uncheck(current_line)
  end

  vim.api.nvim_buf_set_lines(bufnr, start_line, start_line + 1, false, { new_line })
  vim.api.nvim_win_set_cursor(0, cursor)
end

local truncate_log = function()
  local ext = vim.fn.expand("%:e")
  if ext ~= "log" then
    vim.notify("Not truncating log, wrong extension: " .. ext)
  else
    local file = vim.fn.expand("%:p")
    local cmd = { "truncate", "--size", "0", file }
    vim.fn.jobstart(cmd, {
      on_exit = function(_, code)
        if code == 0 then
          vim.notify("truncated: " .. file)
          vim.api.nvim_command("edit")
        else
          vim.notify("Code: " .. code .. " - problem truncating file: " .. file, 4)
        end
      end,
    })
  end
end

-- local slow_format_filetypes = {}
-- require("conform").setup({
--   format_on_save = function(bufnr)
--     if slow_format_filetypes[vim.bo[bufnr].filetype] then
--       return
--     end
--     local function on_format(err)
--       if err and err:match("timeout$") then
--         slow_format_filetypes[vim.bo[bufnr].filetype] = true
--       end
--     end
--
--     return { timeout_ms = 200, lsp_fallback = true }, on_format
--   end,
--
--   format_after_save = function(bufnr)
--     if not slow_format_filetypes[vim.bo[bufnr].filetype] then
--       return
--     end
--     return { lsp_fallback = true }
--   end,
-- })

-- Autoformat with extra features
-- If you want more complex logic than the basic format_on_save option allows, you can use a function instead.
--
-- -- if format_on_save is a function, it will be called during BufWritePre
-- require("conform").setup({
--   format_on_save = function(bufnr)
--     -- Disable autoformat on certain filetypes
--     local ignore_filetypes = { "sql", "java" }
--     if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
--       return
--     end
--     -- Disable with a global or buffer-local variable
--     if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
--       return
--     end
--     -- Disable autoformat for files in a certain path
--     local bufname = vim.api.nvim_buf_get_name(bufnr)
--     if bufname:match("/node_modules/") then
--       return
--     end
--     -- ...additional logic...
--     return { timeout_ms = 500, lsp_fallback = true }
--   end,
-- })
--
-- -- There is a similar affordance for format_after_save, which uses BufWritePost.
-- -- This is good for formatters that are too slow to run synchronously.
-- require("conform").setup({
--   format_after_save = function(bufnr)
--     if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
--       return
--     end
--     -- ...additional logic...
--     return { lsp_fallback = true }
--   end,
-- })

-- vim.api.nvim_create_user_command('Format', function(args)
--   local range = nil
--   if args.count ~= -1 then
--     local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
--     range = {
--       start = { args.line1, 0 },
--       ['end'] = { args.line2, end_line:len() },
--     }
--   end
--   require('conform').format({ async = true, lsp_fallback = true, range = range })
-- end, { range = true })

local function trim_space(opts, preview_ns, preview_buf)
  opts = opts or {}
  local line1 = opts.line1 or 1
  local line2 = opts.line2 or vim.api.nvim_buf_line_count(0)
  local buf = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(buf, line1 - 1, line2, false)
  local new_lines = {}
  local preview_buf_line = 0

  for i, line in ipairs(lines) do
    local startidx, endidx = string.find(line, "%s+$")

    if startidx ~= nil then
      -- Highlight the match if in command preview mode
      if preview_ns ~= nil then
        vim.api.nvim_buf_add_highlight(
          buf,
          preview_ns,
          "Substitute",
          line1 + i - 2,
          startidx - 1,
          endidx
        )

        -- Add lines and highlight to the preview buffer
        -- if inccommand=split
        if preview_buf ~= nil then
          local prefix = string.format("|%d| ", line1 + i - 1)

          vim.api.nvim_buf_set_lines(
            preview_buf,
            preview_buf_line,
            preview_buf_line,
            0,
            { prefix .. line }
          )
          vim.api.nvim_buf_add_highlight(
            preview_buf,
            preview_ns,
            "Substitute",
            preview_buf_line,
            #prefix + startidx - 1,
            #prefix + endidx
          )

          preview_buf_line = preview_buf_line + 1
        end
      end
    end

    if not preview_ns then
      new_lines[#new_lines + 1] = string.gsub(line, "%s+$", "")
    end
  end

  -- Don't make any changes to the buffer if previewing
  if not preview_ns then
    vim.api.nvim_buf_set_lines(buf, line1 - 1, line2, 0, new_lines)
  end

  -- When called as a preview callback, return the value of the
  -- preview type
  if preview_ns ~= nil then
    return 2
  end
end

local function delete_spaces_ahead()
  local line = vim.api.nvim_get_current_line()
  local col = vim.fn.col(".")
  local new_line = line:sub(1, col - 1) .. line:sub(col):gsub("^%s+", "")
  vim.api.nvim_set_current_line(new_line)
end

-- Find comment start index in a line
local function get_comment_start_index(line, comment_marker)
  if comment_marker and comment_marker ~= "" then
    local start_idx = line:find("%s+" .. vim.pesc(comment_marker), 1)
    return start_idx
  end
  return nil
end

-- Function to toggle a character before comments and trailing whitespace
local function toggle_last_char(char)
  -- Get the current line number and the current line content
  local line_num = vim.fn.line(".")
  local line = vim.fn.getline(line_num):gsub("%s+$", "") -- Remove trailing whitespace

  -- Get the comment string for current buffer
  local commentstring = vim.bo.commentstring

  -- Extract the comment marker (before %s)
  local comment_marker = commentstring:match("^(.-)%%s")

  -- Find the position of the comment start
  local comment_start = get_comment_start_index(line, comment_marker)

  -- Determine where to insert the character (before the comment or end of line)
  local insert_pos = comment_start or (#line + 1)

  -- Check if the character is already present at the insert position
  local new_line
  if line:sub(insert_pos - 1, insert_pos - 1) == char then
    -- Character is present at insert position, remove it (toggle off)
    new_line = line:sub(1, insert_pos - 2) .. line:sub(insert_pos)
  else
    -- Character is not present, add it (toggle on)
    new_line = line:sub(1, insert_pos - 1) .. char .. line:sub(insert_pos)
  end

  -- Set the modified line back to the buffer
  vim.fn.setline(line_num, new_line)
end

local end_char_strip = function()
  local end_chars = { ",", ";", ")", "'", '"', "|", "\\", ".", "}" }
end

local end_char_toggle = function()
  local input = vim.fn.getchar()
  if type(input) == "number" then
    local char = vim.fn.nr2char(input)
    -- Handle special keys
    if char == "\27" then -- ESC key
      return
    end
    toggle_last_char(char)
  end
end

local function delete_special()
  if vim.api.nvim_get_current_line():match("^%s*$") then
    return '"_dd'
  else
    return "dd"
  end
end

-- vim.keymap.set("n", "dd", delete_special, { noremap = true, expr = true })

local function delete_special_v()
  local l, _ = unpack(vim.api.nvim_win_get_cursor(0))
  for _, line in ipairs(vim.api.nvim_buf_get_lines(0, l - 1, l, true)) do
    if line:match("^%s*$") then
      return '"_d'
    end
  end
  return "d"
end

-- vim.keymap.set("v", "d", delete_special_v, { noremap = true, expr = true })
--
return {
  -- format = format,
  trim_space = trim_space,
  truncate_log = truncate_log,
  end_char_strip = end_char_strip,
  end_char_toggle = end_char_toggle,
  toggle_checkbox = toggle_checkbox,
  delete_spaces_ahead = delete_spaces_ahead,
}

-- return {
--   "stevearc/conform.nvim",
--   event = { "BufWritePre" },
--   cmd = { "ConformInfo" },
--   keys = {
--     {
--       -- Customize or remove this keymap to your liking
--       "<leader>f",
--       function()
--         require("conform").format({ async = true, lsp_fallback = true })
--       end,
--       mode = "",
--       desc = "Format buffer",
--     },
--   },
--   -- Everything in opts will be passed to setup()
--   opts = {
--     -- Define your formatters
--     formatters_by_ft = {
--       lua = { "stylua" },
--       python = { "isort", "black" },
--       javascript = { { "prettierd", "prettier" } },
--     },
--     -- Set up format-on-save
--     format_on_save = { timeout_ms = 500, lsp_fallback = true },
--     -- Customize formatters
--     formatters = {
--       shfmt = {
--         prepend_args = { "-i", "2" },
--       },
--     },
--   },
--   init = function()
--     -- If you want the formatexpr, here is the place to set it
--     vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
--   end,
-- }
--
--
