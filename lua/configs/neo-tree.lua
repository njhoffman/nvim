-- https://raw.githubusercontent.com/nvim-neo-tree/neo-tree.nvim/v2.x/README.md

local renderer = require("neo-tree.ui.renderer")

local move_cursor_down = function(state, scroll_padding)
  renderer.focus_node(state, nil, true, 1, scroll_padding)
  vim.cmd("redraw!")
end

local move_cursor_up = function(state, scroll_padding)
  -- local lines = math.floor(vim.o.lines / 3)
  renderer.focus_node(state, nil, true, -1, scroll_padding)
  vim.cmd("redraw!")
end

local move_cursor_page_down = function(state, scroll_padding)
  -- local buf_lines = #(vim.api.nvim_buf_get_lines(state.bufnr) or {})
  -- local lines = math.floor(vim.o.lines / 3)
  local tree = state.tree
  local node = tree:get_node()
  renderer.focus_node(state, nil, true, 12, scroll_padding)
  vim.cmd("redraw!")
end

local move_cursor_page_up = function(state, scroll_padding)
  -- local lines = math.floor(vim.o.lines / 3)
  renderer.focus_node(state, nil, true, -12, scroll_padding)
  vim.cmd("redraw!")
end

local filesystem_commands = {
  avante_add_files = function(state)
    local node = state.tree:get_node()
    local filepath = node:get_id()
    local relative_path = require("avante.utils").relative_path(filepath)

    local sidebar = require("avante").get()

    local open = sidebar:is_open()
    -- ensure avante sidebar is open
    if not open then
      require("avante.api").ask()
      sidebar = require("avante").get()
    end

    sidebar.file_selector:add_selected_file(relative_path)

    -- remove neo tree buffer
    if not open then
      sidebar.file_selector:remove_selected_file("neo-tree filesystem [1]")
    end
  end,
}

local cfg = {
  sources = {
    "filesystem",
    "buffers",
    "git_status",
    -- "document_symbols",
  },
  enable_diagnostics = false,

  window = {
    popup = { -- settings that apply to float position only
      size = {
        height = "80%",
        width = "50%",
      },
      position = "50%", -- 50% means center it
      -- you can also specify border here, if you want a different setting from
      -- the global popup_border_style.
    },
    position = "float",
    -- position = 'right',
    width = 40, -- applies to left and right positions
    -- width = function(state)
    --   return math.min(40, math.floor(vim.o.columns * 0.3))
    -- end,
    auto_expand_width = false,
    mappings = {
      -- ['oa'] = 'avante_add_files',
      ["l"] = "toggle_node",
      ["L"] = "toggle_node",
      ["h"] = "close_node",
      ["H"] = "close_node",
      ["D"] = "delete",
      ["d"] = "show_debug_info",
      ["gP"] = { "toggle_preview", config = { use_float = true } },
      ["A"] = "add_directory", -- also accepts the config.show_path and config.insert_as options.
      ["r"] = "rename",
      ["w"] = "open_with_window_picker",
      ["z"] = "close_all_nodes",
      ["Z"] = "expand_all_nodes",
      -- ["<cr>"] = "open_drop",
      ["c"] = "copy", -- takes text input for destination, also accepts the config.show_path and config.insert_as options
      ["m"] = "move", -- takes text input for destination, also accepts the config.show_path and config.insert_as options
      ["e"] = "toggle_auto_expand_width",
      ["q"] = "close_window",
      ["<M-}>"] = "close_window",
      ["?"] = "show_help",
      ["<M-/>"] = "show_help",
      ["<"] = "prev_source",
      [">"] = "next_source",
      ["<M-b>"] = { "scroll_preview", config = { direction = 10 } },
      ["<M-f>"] = { "scroll_preview", config = { direction = -10 } },
      ["<C-p>"] = "move_cursor_up",
      ["<C-n>"] = "move_cursor_down",
      ["<C-b>"] = "",
      ["<C-f>"] = "",
      -- ["<C-b>"] = "move_cursor_page_up",
      -- ["<C-f>"] = "move_cursor_page_down",
    },
  },
  commands = {
    move_cursor_up = move_cursor_up,
    move_cursor_down = move_cursor_down,
    move_cursor_page_up = move_cursor_page_up,
    move_cursor_page_down = move_cursor_page_down,
    nil_fn = function()
      return false
    end,
  },
  event_handlers = {

    --
    -- {
    --   event = 'file_opened',
    --   handler = function(file_path)
    --     --auto close
    --     require('neo-tree').close_all()
    --   end,
    -- },
    -- {
    --   event = 'neo_tree_buffer_enter',
    --   handler = function()
    --     vim.cmd('highlight! Cursor blend=100')
    --     -- setup keybindings for source switch
    --   end,
    -- },
    -- {
    --   event = 'neo_tree_buffer_leave',
    --   handler = function()
    --     vim.cmd('highlight! Cursor guibg=#5f87af blend=0')
    --     -- remove keybindings
    --   end,
    -- },
    {
      -- auto close
      event = "file_opened",
      handler = function(file_path)
        -- require('neo-tree').close_all()
      end,
    },
    {
      -- show netrw hijacked buffer in buffer list
      event = "neo_tree_buffer_enter",
      handler = function()
        vim.schedule(function()
          vim.cmd("highlight! Cursor blend=100")
          local ok, position = pcall(vim.api.nvim_buf_get_var, 0, "neo_tree_position")
          if ok and position == "current" then
            vim.cmd("setlocal buflisted")
          end
        end)
      end,
    },
    {
      event = "neo_tree_buffer_leave",
      handler = function()
        vim.cmd("highlight! Cursor guibg=#5f87af blend=0")
      end,
    },
  },
  filesystem = {
    commands = filesystem_commands,

    filtered_items = {
      visible = true, -- when true, they will just be displayed differently than normal items
    },
    async_directory_scan = "auto", -- "auto"   means refreshes are async, but it's synchronous when called from the Neotree commands.
    -- "always" means directory scans are always async.
    -- "never"  means directory scans are never async.
    scan_mode = "shallow", -- "shallow": Don't scan into directories to detect possible empty directory a priori
    follow_current_file = {
      enabled = true,
      leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
    },
    hijack_netrw_behavior = "disabled",
    -- "open_default", -- netrw disabled, opening a directory opens neo-tree in whatever position is specified in window.position
    -- "open_current",-- netrw disabled, opening a directory opens within the window like netrw would, regardless of window.position
    -- "disabled",    -- netrw left alone, neo-tree does not handle opening dirs
    -- use_libuv_file_watcher = false, -- This will use the OS level file watchers to detect changes instead of relying on nvim autocmd events.
    use_libuv_file_watcher = true, -- This will use the OS level file watchers to detect changes instead of relying on nvim autocmd events.
    bind_to_cwd = true, -- true creates a 2-way binding between vim's cwd and neo-tree's root
  },
  default_component_configs = {
    container = {
      enable_character_fade = true,
      width = "100%",
      right_padding = 0,
    },
    name = {
      -- trailing_slash = false,
      highlight_opened_files = true, -- Requires `enable_opened_markers = true`.
      -- Take values in { false (no highlight), true (only loaded), "all" (both loaded and unloaded)}.
      -- use_git_status_colors = true,
      -- highlight = 'NeoTreeFileName',
    },
    git_status = {
      symbols = {
        -- added = "✚",
        -- deleted = "✖",
        -- modified = "",
        -- renamed = "󰁕",
        -- untracked = "",
        -- ignored = "",
        -- unstaged = "󰄱",
        unstaged = "ﯰ", --  ﯰ 
        -- staged = "",
        -- conflict = "",
      },
    },
    -- file_size = { enabled = true, required_width = 64 },
    -- type = { enabled = true, required_width = 110 },
    -- last_modified = { enabled = true, required_width = 88 },
    -- created = { enabled = false, required_width = 120 },
    -- symlink_target = { enabled = false },
    icon = {
      -- folder_closed = '',
      -- folder_open = '',
      -- folder_empty = '󰜌 ',
      -- folder_empty_open = '󰜌',
      folder_empty = "",
      folder_empty_open = "",
    },
  },
}
--
require("neo-tree").setup(cfg)

-- require('workspaces').setup({
-- 	hooks = {
-- 		open_pre = { 'NeoTreeClose', 'SessionsStop', 'silent %bdelete!' },
-- 		open = { function() require('sessions').load('.nvim/session', { silent = true }) end, 'Neotree show filesystem' }
-- 	}

--   local api = require("nvim-tree.api")
--   local luv = vim.loop
--   -- Function to recursively add files in a directory to chat references
--   local function traverse_directory(path, chat)
--     local handle, err = luv.fs_scandir(path)
--     if not handle then return print("Error scanning directory: " .. err) end

--     while true do
--       local name, type = luv.fs_scandir_next(handle)
--       if not name then break end

--       local item_path = path .. "/" .. name
--       if type == "file" then
--         -- add the file to references
--         chat.References:add({
--           id = '<file>' .. item_path .. '</file>',
--           path = item_path,
--           source = "codecompanion.strategies.chat.slash_commands.file",
--           opts = {
--             pinned = true
--           }
--         })
--       elseif type == "directory" then
--         -- recursive call for a subdirectory
--         traverse_directory(item_path, chat)
--       end
--     end
--   end

--   -- Attach default mappings
--   api.config.mappings.default_on_attach(bufnr)

--   vim.keymap.set('n', 'ca', function()
--     local node = api.tree.get_node_under_cursor()
--     local path = node.absolute_path
--     local codecompanion = require("codecompanion")
--     local chat = codecompanion.last_chat()
--     -- create chat if none exists
--     if (chat == nil) then
--       chat = codecompanion.chat()
--     end

--     local attr = luv.fs_stat(path)
--     if attr and attr.type == "directory" then
--       -- Recursively traverse the directory
--       traverse_directory(path, chat)
--     else
--       -- if already added, ignore
--       for _, ref in ipairs(chat.refs) do
--         if ref.path == path then
--           return print("Already added")
--         end
--       end
--       chat.References:add({
--         id = '<file>' .. path .. '</file>',
--         path = path,
--         source = "codecompanion.strategies.chat.slash_commands.file",
--         opts = {
--           pinned = true
--         }
--       })
--     end
--   end, { buffer = bufnr, desc = "Add or Pin file to Chat" })
-- end
