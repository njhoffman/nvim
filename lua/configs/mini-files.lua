local ai_assistant = {}

ai_assistant.add_file_path_to_chat = function(file_path, chat)
  for _, ref in ipairs(chat.refs) do
    if ref.path == file_path then
      return print("Already added")
    end
  end

  local ref = {
    id = "<file>" .. file_path .. "</file>",
    path = file_path,
    source = "codecompanion.strategies.chat.slash_commands.file",
    opts = { pinned = true },
  }
  chat.references:add(ref)
end

ai_assistant.list_file_paths = function(path)
  local stat = vim.uv.fs_stat(path)

  if stat == nil then
    return print("Path does not exist")
  end

  if stat.type == "directory" then
    local paths = {}
    for item in vim.fs.dir(path, { depth = 1 }) do
      local item_path = vim.fs.joinpath(path, item)
      local item_stat = vim.uv.fs_stat(item_path)
      if item_stat ~= nil and item_stat.type == "file" then
        paths[#paths + 1] = item_path
      end
    end
    return paths
  end

  if stat.type == "file" then
    return { path }
  end

  return {}
end

local add_path_to_codecompanion_chat = function()
  local path = MiniFiles.get_fs_entry().path
  if path == nil then
    return vim.notify("Cursor is not on valid entry")
  end

  local file_paths = ai_assistant.list_file_paths(path)

  if #file_paths == 0 then
    return print("No files found")
  end

  local codecompanion = require("codecompanion")
  local chat = codecompanion.last_chat()
  if chat == nil then --if no chat, create one
    chat = codecompanion.chat()
  end

  for _, file_path in ipairs(file_paths) do
    ai_assistant.add_file_path_to_chat(file_path, chat)
  end
end

local cfg = {
  options = {
    use_as_default_explorer = false,
  },
  mappings = {
    close = "<M-{>",
    -- close = 'q',
    go_in = "",
    -- go_in = 'l',
    go_in_plus = "L",
    go_out = "",
    -- go_out = 'h',
    go_out_plus = "H",
    reset = "<esc>",
    -- reset = '<BS>',
    -- reveal_cwd = '@',
    -- show_help = '<M-C-_>',
    show_help = "<M-/>",
    -- synchronize = '=',
    -- trim_left = '<',
    -- trim_right = '>',
  },
}

local minifiles_toggle = function()
  if not MiniFiles.close() then
    MiniFiles.open()
  end
end

vim.api.nvim_create_user_command(
  "MiniFiles",
  minifiles_toggle,
  { desc = "toggle minifiles file manager" }
)

vim.api.nvim_create_autocmd("User", {
  pattern = "MiniFilesBufferCreate",
  callback = function(args)
    local b = args.data.buf_id
    vim.keymap.set(
      "n",
      "ga",
      add_path_to_codecompanion_chat,
      { buffer = b, desc = "Add to CodeCompanion" }
    )
  end,
})

-- --stylua: ignore start
-- buf_map('n', mappings.close,       MiniFiles.close,       'Close')
-- buf_map('n', mappings.go_in,       go_in_with_count,      'Go in entry')
-- buf_map('n', mappings.go_in_plus,  go_in_plus,            'Go in entry plus')
-- buf_map('n', mappings.go_out,      go_out_with_count,     'Go out of directory')
-- buf_map('n', mappings.go_out_plus, go_out_plus,           'Go out of directory plus')
-- buf_map('n', mappings.reset,       MiniFiles.reset,       'Reset')
-- buf_map('n', mappings.reveal_cwd,  MiniFiles.reveal_cwd,  'Reveal cwd')
-- buf_map('n', mappings.show_help,   MiniFiles.show_help,   'Show Help')
-- buf_map('n', mappings.synchronize, MiniFiles.synchronize, 'Synchronize')
-- buf_map('n', mappings.trim_left,   MiniFiles.trim_left,   'Trim branch left')
-- buf_map('n', mappings.trim_right,  MiniFiles.trim_right,  'Trim branch right')
--

-- vim.api.nvim_create_autocmd('User', {
--   pattern = 'MiniFilesWindowOpen',
--   callback = function(args)
--     local win_id = args.data.win_id
--
--     -- Customize window-local settings
--     vim.wo[win_id].winblend = 50
--     vim.api.nvim_win_set_config(win_id, { border = 'double' })
--   end,
-- })
-- set cwd
-- local files_set_cwd = function(path)
--   -- Works only if cursor is on the valid file system entry
--   local cur_entry_path = MiniFiles.get_fs_entry().path
--   local cur_directory = vim.fs.dirname(cur_entry_path)
--   vim.fn.chdir(cur_directory)
-- end
--
-- vim.api.nvim_create_autocmd('User', {
--   pattern = 'MiniFilesBufferCreate',
--   callback = function(args)
--     vim.keymap.set('n', 'g~', files_set_cwd, { buffer = args.data.buf_id })
--   end,
-- })

require("mini.files").setup(cfg)
