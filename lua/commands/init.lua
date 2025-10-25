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
local colorscheme_export = require("commands.colorscheme_export")

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

cmd("ColorschemeExport", function(opts)
  colorscheme_export.export({
    colorscheme = opts.args ~= "" and opts.args or nil,
  })
end, {
  nargs = "?",
  desc = "󰏘 export colorscheme to bat theme format",
  complete = function(_, _, _)
    -- Get available colorschemes for completion
    local paths = vim.api.nvim_get_runtime_file("colors/*.{vim,lua}", true)
    local schemes = {}
    for _, path in ipairs(paths) do
      local scheme = path:match("colors/(.*)%..*$")
      if scheme then
        table.insert(schemes, scheme)
      end
    end
    table.sort(schemes)
    return schemes
  end,
})

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
