local codecomplete_share = function()
  local Path = require("plenary.path")
  local oil = require("oil")
  local cc = require("codecompanion")
  local fmt = string.format
  local cur_dir = oil.get_current_dir()
  local fullpath = cur_dir .. oil.get_cursor_entry().name
  local path = Path:new(fullpath)
  local ok, content = pcall(function()
    return Path.new(fullpath):read()
  end)

  local relpath = path:make_relative()
  local ft = vim.filetype.match({ filename = fullpath })
  local description = fmt(
    [[%s %s:

```%s
%s
```]],
    "Here is the content of the file",
    "located at `" .. relpath .. "`",
    ft,
    content
  )
  local id = "<file>" .. relpath .. "</file>"
  cc.last_chat():add_message({
    role = require("codecompanion.config").config.constants.USER_ROLE,
    content = description,
  }, { reference = id, visible = false })
  cc.last_chat().references:add({
    id = id,
    path = relpath,
    source = "codecompanion.strategies.chat.slash_commands.file",
  })
  vim.notify(relpath .. " added to codecompanion")
end

-- Declare a global function to retrieve the current directory
function _G.get_oil_winbar()
  local bufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
  local dir = require("oil").get_current_dir(bufnr)
  if dir then
    return vim.fn.fnamemodify(dir, ":~")
  else
    -- If there is no current directory (e.g. over ssh), just show the buffer name
    return vim.api.nvim_buf_get_name(0)
  end
end

local cfg = {
  default_file_explorer = false, -- allow other plugins or netrw to handle directory opening
  -- constrain_cursor = "editable", -- Set to `false` to disable, or "name" to keep it on the file names
  -- watch_for_changes = false,
  columns = {
    "size",
    "icon",
  }, -- "permissions", "size", "mtime"
  win_options = {
    --     wrap = false,
    --     signcolumn = "no",
    --     cursorcolumn = false,
    --     foldcolumn = "0",
    --     spell = false,
    --     list = false,
    --     conceallevel = 3,
    --     concealcursor = "nvic",
    relativenumber = false,
    number = false,
    -- winbar = "%!v:lua.get_oil_winbar()",
  },
  view_options = { show_hidden = true },
  keymaps_help = { border = "rounded" },
  float = {
    -- padding = 2,
    max_width = 80,
    -- max_height = 0.9,
    -- border = 'rounded',
    win_options = {
      winblend = 20,
    },
    override = function(conf)
      return conf
    end,
  },
  keymaps = {
    ["<M-/>"] = "actions.show_help",
    ["<CR>"] = "actions.select",
    -- ["<C-s>"] = "actions.select_vsplit",
    -- ["<C-h>"] = "actions.select_split",
    -- ["<C-t>"] = "actions.select_tab",
    -- ["<C-p>"] = "actions.preview",
    ["q"] = "actions.close",
    ["<esc>"] = "actions.close",
    ["<C-y>"] = "actions.copy_entry_path",
    ["<M-{>"] = "actions.close",
    -- ["<C-c>"] = "actions.close",
    ["<C-h>"] = "actions.parent",
    ["<C-l>"] = "actions.select",
    ["<BS>"] = "actions.parent",
    -- ["-"] = "actions.parent",
    -- ["_"] = "actions.open_cwd",
    -- ["`"] = "actions.cd",
    -- ["~"] = "actions.tcd",
    -- ["gs"] = "actions.change_sort",
    -- ["gx"] = "actions.open_external",
    -- ["g."] = "actions.toggle_hidden",
    -- ["g\\"] = "actions.toggle_trash",
    ["g?"] = "actions.show_help",
    ["ga"] = {
      desc = "share file with code companion",
      callback = codecomplete_share,
    },
    ["gv"] = {
      desc = "Toggle file detail view",
      callback = function()
        detail = not detail
        if detail then
          require("oil").set_columns({ "icon", "permissions", "size", "mtime" })
        else
          require("oil").set_columns({ "icon" })
        end
      end,
    },
    -- -- Mappings can be a string
    -- ["~"] = "<cmd>edit $HOME<CR>",
    -- -- You can pass additional opts to vim.keymap.set by using a table with the mapping as the first element.
    -- ["<leader>ff"] = {
    --     function()
    --         require("telescope.builtin").find_files({
    --             cwd = require("oil").get_current_dir()
    --         })
    --     end,
    --     mode = "n",
    --     nowait = true,
    --     desc = "Find files in the current directory"
    -- },
    -- -- Mappings that are a string starting with "actions." will be one of the built-in actions, documented below.
    -- ["`"] = "actions.tcd",
    -- -- Some actions have parameters. These are passed in via the `opts` key.
    -- ["<leader>:"] = {
    --     "actions.open_cmdline",
    --     opts = {
    --         shorten_path = true,
    --         modify = ":h",
    --     },
    --     desc = "Open the command line with the current directory as an argument",
    -- },
  },
}
require("oil").setup(cfg)

-- select                                                            *actions.select*
--     Open the entry under the cursor
--       {close}      `boolean` Close the original oil buffer once selection is made
--       {horizontal} `boolean` Open the buffer in a horizontal split
--       {split}      `"aboveleft"|"belowright"|"topleft"|"botright"` Split modifier
--       {tab}        `boolean` Open the buffer in a new tab
--       {vertical}   `boolean` Open the buffer in a vertical split
--
-- send_to_qflist                                            *actions.send_to_qflist*
--     Sends files in the current oil directory to the quickfix list, replacing the previous entries.
--       {action} `"r"|"a"` Replace or add to current quickfix list (see |setqflist-action|)
--       {only_matching_search} `boolean` Whether to only add the files that matches the last search. This option only applies when search highlighting is active
--       {target} `"qflist"|"loclist"` The target list to send files to

-- save({opts}, {cb})                                                      *oil.save*
--     Save all changes
--       {opts} `nil|table` {confirm} `nil|boolean` Show confirmation when true, never when false, respect skip_confirm_for_simple_edits if nil
--       {cb}   `nil|fun(err: nil|string)` Called when mutations complete.
--     Note: If you provide your own callback function, there will be no notification for errors.
