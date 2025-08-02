-- end of line toggling functions

-- Buffer
local file_pattern = {
  "*.css",
  "*.fish",
  "*.html",
  "*.json",
  "*.lua",
  "*.md",
  "*.rb",
  "*.sass",
  "*.scss",
  "*.sh",
  "*.ts",
  "Dockerfile",
  "docker-compose.yaml",
  "*.cpp",
}

local remove_eol_comments = function(comment_syntax, lines)
  if not lines then
    local cur_pos = vim.api.nvim_win_get_cursor(0)
    vim.api.nvim_command("%s/" .. comment_syntax .. ".*//g")
    vim.api.nvim_win_set_cursor(0, cur_pos)
    return ""
  else
    for i, line in ipairs(lines) do
      lines[i] = line:gsub(comment_syntax .. ".*", "")
    end
    return lines
  end
end

local remove_eol_comments_ft = function(lines)
  local ft = vim.bo.filetype
  if ft == "javascript" or ft == "c" or ft == "cpp" then
    remove_eol_comments("//", lines)
  elseif ft == "lua" then
    remove_eol_comments("--", lines)
  elseif ft == "python" then
    remove_eol_comments("#", lines)
  else
    print("Unrecognized filetype.")
  end
end

local get_current_lines = function()
  local cursor = vim.api.nvim_win_get_cursor(0)

  -- local current_line = vim.fn.trim(
  --   remove_eol_comments_ft(vim.api.nvim_buf_get_lines(0, cursor[1] - 1, cursor[1], true)[1])
  -- ) or ''
  local current_line = vim.fn.trim(
    remove_eol_comments_ft(vim.api.nvim_buf_get_lines(0, cursor[1] - 1, cursor[1], true)[1]) or ""
  )
end

local get_last_char = function(chars, opts)
  return function()
    opts = opts or {}
    chars = type(chars) == "string" and { chars } or (type(chars) == "table" and chars) or {}
    local key = type(chars) == "table" and chars[1] or chars
    local mode = opts.mode or (vim.tbl_isempty(chars) and "strip") or "toggle"

    local last_character = current_line and current_line:sub(-1) or ""
    local to_remove, to_append = "", ""

    if mode == "toggle" then
      to_append = key
      for _, char in ipairs(chars) do
        if char == last_character then
          to_remove = char
          to_append = ""
        end
      end
    elseif mode == "append" then
      to_append = vim.fn.nr2char(vim.fn.getchar())
    elseif mode == "strip" then
      to_remove = last_character
      vim.dbglog("remove", to_remove)
      to_append = ""
    end

    if to_remove ~= "" then
      -- remove last matching of to_remove
      current_line = current_line:sub(1, #current_line - #to_remove)
    end
    current_line = current_line .. to_append
    vim.api.nvim_buf_set_lines(0, cursor[1] - 1, cursor[1], true, { current_line })
    vim.cmd('silent! normal "0=="')
    vim.api.nvim_win_set_cursor(0, { cursor[1], cursor[2] })
  end
end

local trail_chars = { ",", ";", ")", "'", '"', "|", "\\", ".", "}" }

-- -- strip last character
-- vim.keymap.set("n", "<leader>$", get_last_char(), { desc = "ﲖ strip end characters" })
-- -- append provided end character
-- vim.keymap.set( "n", "<leader>A", get_last_char(_, { mode = "append" }), { desc = "ﲖ append end character" })
-- -- toggle provided end character
-- vim.keymap.set('n', '<leader>a', get_last_char(_, { mode = 'toggle' }), { desc = 'ﲖ toggle ' .. char .. ' end character', })
-- -- toggle common end characters
-- vim.keymap.set( "n", "<leader>a", get_last_char(trail_chars), { desc = 'ﲖ toggle end characters: ,;)"|\\.}' })
