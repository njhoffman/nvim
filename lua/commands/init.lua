local format = require("commands.format")
local buffer = require("commands.buffer")
local tips = require("commands.tips")
local help = require("commands.help")
local debug = require("commands.debug")
-- local paste = require('commands.paste')
local reload = require("commands.reload")
local system = require("commands.system")
local ansi = require("commands.ansi")
local quickclose = require("commands.quickclose")

local map = require("mapper").map

local cmd = vim.api.nvim_create_user_command
local bufcmd = vim.api.nvim_buf_create_user_command

require("commands.ui").setup()
quickclose.setup()

-- TODO: resume visual selection after switching
vim.api.nvim_create_user_command("Vblock", function()
  vim.o.virtualedit = vim.o.virtualedit == "block" and "none" or "block"
  vim.notify("virtualedit: " .. vim.o.virtualedit)
  -- onemore, block, insert, all, none
end, { desc = "toggle virtualedit modes", range = true })

map(
  "n",
  "<M-C-V>",
  ":Vblock<CR>",
  { noremap = true, silent = true, desc = "toggle virtualedit block" }
)
map(
  "x",
  "<M-C-V>",
  ":Vblock<CR>",
  { noremap = true, silent = true, desc = "toggle virtualedit block" }
)

--   
cmd(
  "Tip",
  tips.get_tip,
  { nargs = "*", complete = tips.complete, desc = " get a random neovim tip" }
)

cmd("Reload", reload(), { nargs = "*", desc = " reload /  make basic" })
cmd(
  "Reload2",
  reload({ siblings = true }),
  { nargs = "*", desc = " reload /  make siblings" }
)
cmd(
  "Reload3",
  reload({ siblings = true, extended = true }),
  { nargs = "*", desc = " reload /  make extended" }
)

map("n", "<leader>iR", ":Reload<cr>", { noremap = true, silent = true })

cmd("TruncateLog", format.truncate_log, { desc = "Truncate log " })
-- cmd('Format', format.format, { nargs = '*', desc = 'Format buffer using lsp' })
cmd("ToggleCheckbox", format.toggle_checkbox, { desc = "Toggle checkbox" })
cmd("GetPaths", debug.get_paths, { desc = "Get path collections (rtpaths, o.packpath, etc)" })
cmd("Trash", system.trash_file, { desc = "Send file to system trash" })
cmd("Delete", system.trash_file, { desc = "Send file to system trash" })
cmd("YankPath", system.yank_path, { desc = "Yank current file path" })
cmd("YankCwd", system.yank_cwd, { desc = "Yank current project directory" })
-- cmd("TrashRecover", system.trash_file, { desc = "Send file to system trash" })

vim.api.nvim_create_autocmd("FileType", {
  pattern = "lua",
  callback = function()
    bufcmd(0, "Help", help.get_help_cursor, { desc = "Jump to helpfile under cursor" })
    vim.keymap.set("n", "gH", "<cmd>Help<cr>", {
      desc = "open help item under cursor",
      buffer = 0,
    })
  end,
  desc = "Create lua help utility functions",
})

-- TODO: handle special [-] and [ ]
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.keymap.set("n", "<CR>", function()
      local line = vim.api.nvim_get_current_line()
      -- only if line has a checkbox, otherwise normal enter behavior
      if line:match("%s*[-*+]%s*%[[ xX]%]") then
        format.toggle_checkbox()
      else
        vim.api.nvim_feedkeys("o", "n", false)
      end
    end, { buffer = true, desc = "Toggle checkbox or normal enter" })
  end,
})

cmd("HelpExport", help.export_help_files, { desc = "export local help files" })
cmd("HelpNew", help.edit_new_helpfile, { desc = "edit new local helpfile" })

-- map("n", "<leader>$", format.end_char_strip, { desc = "ﲖ strip end characters" })
map("n", "<leader>a", format.end_char_toggle, { desc = "ﲖ toggle end character", nowait = true })

cmd("TrimTrailingWhitespace", format.trim_space, {
  nargs = "?",
  range = "%",
  addr = "lines",
  preview = format.trim_space,
  desc = "ﲖ trims trailing whitespace in the current buffer",
})

cmd("Google", function(o)
  -- local escaped = require('socket.url').escape(o.args)
  local escaped = vim.uri_encode(o.args)
  local url = ("https://www.google.com/search?q=%s"):format(escaped)
  vim.ui.open(url)
end, { nargs = 1, desc = "search in google" })

cmd("Reddit", function(o)
  -- local escaped = require('socket.url').escape(o.args)
  local escaped = vim.uri_encode(o.args)
  local url = ("https://www.google.com/search?q=site:reddit.com%20%s"):format(escaped)
  vim.ui.open(url)
end, { nargs = 1, desc = "search in reddit" })

local web_query = function(engine)
  local engines = {
    google = { prompt = " Google: ", url = "https://www.google.com/search?q=" },
  }

  local selected = engines[engine or "google"]
  local input = vim.fn.input(selected.prompt)
  local response = not (input == nil or input == "")

  -- Start off with the current buf type. This will add lua for lua files ruby for rb files and so on.
  local query = vim.bo.filetype
  if response then
    query = query .. " " .. input
  else
    query = query .. " " .. vim.fn.expand("<cword>")
  end

  os.execute([[open ']] .. selected.url .. query .. "'")
end

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
-- cmd(
--   "PasteNoYank",
--   paste.visual_paste_without_yank,
--   { desc = "Paste to visual selection buffer without overwriting register" }
-- )
-- vim.keymap.set("v", "p", paste.visual_paste_without_yank, { noremap = true, silent = true })

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
