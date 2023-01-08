vim.import("commands.format")
local cmd = vim.api.nvim_create_user_command

cmd("ClosePopups", function(cmd_props)
  local n = 0
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local config = vim.api.nvim_win_get_config(win)
    if config.relative ~= "" then
      n = n + 1
      vim.api.nvim_win_close(win, false)
    end
  end
  print("Closed " .. n .. " popup windows")
end, { desc = "Format buffer using lsp" })

cmd("LuaGetPaths", function(cmd_props)
  for match in (vim.o.packpath .. ","):gmatch("(.-)" .. ",") do
    print(match)
  end
end, { desc = "Get LSP o.packpath runtime directories" })

-- cmd("LogFiles", function(cmd_props)
--   for match in (vim.o.packpath .. ","):gmatch("(.-)" .. ",") do
--
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
