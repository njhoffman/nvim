local format = require('commands.format')
local ui = require('commands.ui')
local help = require('commands.help')
local debug = require('commands.debug')
local paste = require('commands.paste')
local system = require('commands.system')
require('commands.inspect')

local cmd = vim.api.nvim_create_user_command
local bufcmd = vim.api.nvim_buf_create_user_command

-- -- Mapping for dd that doesn't yank an empty line into your default register:
-- keymap.set("n", "dd", function()
--   if vim.api.nvim_get_current_line():match("^%s*$") then
--     return '"_dd'
--   else
--     return "dd"
--   end
-- end, { expr = true })

--
-- -- greatest remap ever
-- keymap.set("x", "p", "P")
--
-- -- using delete without yank
-- keymap.set({ "n", "v" }, "<leader>d", "\"_d", { desc = "Delete without yank" })

-- Create the user command
cmd('TrimTrailingWhitespace', format.trim_space, {
  nargs = '?',
  range = '%',
  addr = 'lines',
  preview = format.trim_space,
  desc = 'Trims trailing whitespace in the current buffer.',
})
cmd('TruncateLog', format.truncate_log, { desc = 'Truncate log ' })
cmd('Format', format.format, { nargs = '*', desc = 'Format buffer using lsp' })
cmd('CloseMulti', ui.close_multi, { desc = 'Close tabpage, window, or buffer in that order' })
cmd('CloseMultiNoPrompt', ui.close_multi_no_prompt, { desc = 'Close tabpage, window, or buffer in that order' })
cmd('ClosePopups', ui.close_popups, { desc = 'Format buffer using lsp' })
cmd('GetPaths', debug.get_paths, { desc = 'Get path collections (rtpaths, o.packpath, etc)' })
cmd('Trash', system.trash_file, { desc = 'Send file to system trash' })
cmd('Delete', system.trash_file, { desc = 'Send file to system trash' })
-- cmd("TrashRecover", system.trash_file, { desc = "Send file to system trash" })

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'lua',
  callback = function()
    bufcmd(0, 'Help', help.get_help_cursor, { desc = 'Jump to helpfile under cursor' })
    vim.keymap.set('n', 'gH', '<cmd>Help<cr>', {
      desc = 'open help item under cursor',
      buffer = 0,
    })
  end,
  desc = 'Create lua help utility functions',
})

-- cmd(
--   "PasteNoYank",
--   paste.visual_paste_without_yank,
--   { desc = "Paste to visual selection buffer without overwriting register" }
-- )
-- vim.keymap.set("v", "p", paste.visual_paste_without_yank, { noremap = true, silent = true })

-- vim.keymap.set('n', '<M-l>', ui.check_resize_split('l'), { noremap = true })
-- vim.keymap.set('n', '<M-h>', ui.check_resize_split('h'), { noremap = true })
-- vim.keymap.set('n', '<M-j>', ui.check_resize_split('j'), { noremap = true })
-- vim.keymap.set('n', '<M-k>', ui.check_resize_split('k'), { noremap = true })

-- vim.fn.feedkeys(vim.api.nvim_replace_termcodes('...',true,true,true))
-- TODO: c-s-d , c-s-f, c-s-h,l,j,k, c-s-|, c-s-+
vim.keymap.set('n', '<C-S-Right>', ui.check_nav_split('l'), { noremap = true })
vim.keymap.set('n', '<C-S-Left>', ui.check_nav_split('h'), { noremap = true })
vim.keymap.set('n', '<C-S-Down>', ui.check_nav_split('j'), { noremap = true })
vim.keymap.set('n', '<C-S-Up>', ui.check_nav_split('k'), { noremap = true })

-- {
--     name = "LvimCacheReset",
--     fn = function()
--       require("lvim.utils.hooks").reset_cache()
--     end,
--   },
--   {
--     name = "LvimReload",
--     fn = function()
--       require("lvim.config"):reload()
--     end,
--   },

-- vim.g.scriptpath,vim.g.loaded_remote_plugins,script_path,scripts_dir
-- vim.o.argv, vim.o.packpath, vim.o.runtimepath, undodir, viewdir, directory, backupdir, helpfile,
-- -- nvim --cmd "set rtp+=." lua/NeovimConf.lua

-- cmd("LogFiles", function(cmd_props)
--
--     -- logfiles["auth"]="/var/log/auth.log"
--     -- logfiles["boot"]="/var/log/boot.log"
--     -- logfiles["dmesg"]="/var/log/dmesg"
--     -- logfiles["kern"]="/var/log/kern.log"
--     -- logfiles["mpd"]="$HOME/.mpd/mpd.log"
--     -- logfiles["postgresql"]="/var/log/postgresql/postgresql-12-main.log"
--     -- logfiles["syslog"]="/var/log/syslog"
--     -- logfiles["nvim-dap"]="$HOME/.cache/nvim/dap.log"
--     -- logfiles["nvim-packer"]="$HOME/.cache/nvim/packer.nvim.log"
--     -- logfiles["nvim-telescope"]="$HOME/.cache/nvim/telescope.log"
--     -- logfiles["nvim-lsp-installer"]="$HOME/.cache/nvim/lsp-installer.log"
--     -- logfiles["nvim-inspect"]="$HOME/.local/share/nvim/inspect.log"
--     -- logfiles["nvim"]="$HOME/.local/share/nvim/nvim.log"
--     -- logfiles["nvim-efm"]="$HOME/.local/share/nvim/lsp-efm.log"
--     -- logfiles["nvim-lsp"]="$HOME/.local/state/nvim/lsp.log"
--   end
-- end, { desc = "Open a pre-configured log file for display" })
--
-- cmd_props
-- • args:  (string)  The args passed to the command, if any |<args>|
-- • fargs: (table)   The args split by unescaped whitespace (when more than one argument is allowed), if any |<f-args>|
-- • bang:  (boolean) "true" if the command was executed with a ! modifier |<bang>|
-- • line1: (number)  The starting line of the command range |<line1>|
-- • line2: (number)  The final line of the command range |<line2>|
-- • range: (number)  The number of items in the command range: 0, 1, or 2 |<range>|
-- • count: (number)  Any count supplied |<count>|
-- • reg:   (string)  The optional register, if specified |<reg>|
-- • mods:  (string)  Command modifiers, if any |<mods>|
-- • smods: (table)   Command modifiers in a structured format. Has the same structure as the "mods" key of |nvim_parse_cmd()|.
--
