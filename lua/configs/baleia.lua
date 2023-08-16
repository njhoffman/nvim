local cfg = {
  name = "BaleiaColors",
  strip_ansi_codes = true,
  line_starts_at = 1,
}

local baleia = require("baleia").setup(cfg)

vim.api.nvim_create_user_command("AnsiColorize", function()
  local bufnr = vim.api.nvim_get_current_buf()
  local lastline = vim.api.nvim_buf_line_count(bufnr)
  -- local lines = { "\x1b[32mHello \x1b[33mworld!", "^[[0m^[[35mplugin/fake.vim^[[0m:^[[0m^[[1m^[[31m" Testing ^[[0m" }
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, lastline, false)
  local new_lines = vim.tbl_map(function(line)
    local new_line = string.gsub(line, "%^%[%[", "\x1b[")
    new_line = string.gsub(new_line, "\\x1b%[", "\x1b[")
    return new_line
  end, lines)
  baleia.buf_set_lines(0, 0, lastline, true, new_lines)
end, {})

-- local new_lines = {  }
-- vim.fn.system('echo -e "\\033[38;5;89mtesting one, two, three\\033[0m"')
-- local new_lines = { '\x1b[32mHello \x1b[33mworld!' }

-- command! BaleiaColorize call s:baleia.once(bufnr('%'))
-- To automatically colorize text added to the quickfix use BufReadPost
--
-- let s:baleia = luaeval("require('baleia').setup { }")
-- autocmd BufReadPost quickfix setlocal modifiable
--   \ | silent call g:baleia.once(bufnr('%'))
--   \ | setlocal nomodifiable
