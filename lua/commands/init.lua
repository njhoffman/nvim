vim.import("commands.format")
local cmd = vim.api.nvim_create_user_command

cmd("ClosePopups", function()
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

local function check_split(orig_key, is_resize)
  local keymap = {
    h = { "-L", "2>" },
    l = { "-R", "2<" },
    k = { "-U", "1-" },
    j = { "-D", "1+" },
  }
  return function()
    local curwin = vim.fn.winnr()
    local testwin = vim.fn.winnr(orig_key)
    local tmuxkey = keymap[orig_key][1]
    local vimkey = keymap[orig_key][2]
    if curwin ~= testwin then
      -- vim.api.nvim_open_win(...) then it returns a window handle,
      -- which you can use as the argument to vim.api.nvim_set_current_win.
      if is_resize then
        vim.cmd("wincmd " .. vimkey)
      else
        vim.cmd("wincmd " .. orig_key)
      end
    elseif not is_resize then
      vim.fn.system("tmux select-pane " .. tmuxkey)
    end
  end
end

-- vim.fn.feedkeys(vim.api.nvim_replace_termcodes('...',true,true,true))
-- TODO: c-s-d , c-s-f, c-s-h,l,j,k, c-s-|, c-s-+
vim.keymap.set("n", "<C-S-Right>", check_split("l"), { noremap = true })
vim.keymap.set("n", "<C-S-Left>", check_split("h"), { noremap = true })
vim.keymap.set("n", "<C-S-Down>", check_split("j"), { noremap = true })
vim.keymap.set("n", "<C-S-Up>", check_split("k"), { noremap = true })
vim.keymap.set("n", "<M-Left>", check_split("l", true), { noremap = true })
vim.keymap.set("n", "<M-Right>", check_split("h", true), { noremap = true })
vim.keymap.set("n", "<M-Down>", check_split("j", true), { noremap = true })
vim.keymap.set("n", "<M-Up>", check_split("k", true), { noremap = true })

local get_splits = function(dirs)
  -- let window_count = winnr('$')
  -- let prev_window = winnr('#')
  local splits = {}
  local curwin = vim.fn.winnr()
  for _, dir in ipairs(dirs) do
    local testwin = vim.fn.winnr(dir)
    testwin = vim.fn.win_getid(testwin)
    if curwin ~= testwin and not vim.tbl_contains(splits, testwin) then
      table.insert(splits, testwin)
    end
  end
  return splits
end

local close_multi = function()
  local tabs = vim.api.nvim_list_tabpages() or {}
  local splits = get_splits({ "l", "h", "j", "k" }) or {}
  if #tabs > 1 then
    vim.cmd("tabclose!")
  elseif #splits > 1 then
    vim.api.nvim_win_close(splits[1], false)
  else
    -- vim.cmd("BufferDelete")
    vim.cmd("BufferDelete")
  end
end

-- vim.g.scriptpath,vim.g.loaded_remote_plugins,script_path,scripts_dir
-- vim.o.argv, vim.o.packpath, vim.o.runtimepath, undodir, viewdir, directory, backupdir, helpfile,
-- -- nvim --cmd "set rtp+=." lua/NeovimConf.lua

local get_scriptnames = function()
  vim.cmd([[
    let scriptnames_output = ''
    redir => scriptnames_output
      silent scriptnames
    redir END

    let scripts = {}
    for line in split(scriptnames_output, "\n")
      if line =~ '\S'
      let nr = matchstr(line, '\d\+')
      let name = substitute(line, '.\+:\s*', '', '')
      let scripts[nr] = name
      endif
    endfor
    let w:scriptnames = scriptnames_output
    unlet scriptnames_output
  ]])
  local scriptnames = vim.api.nvim_eval("w:scriptnames")
  return scriptnames
end
local get_runtime_files = function()
  local rtpaths = vim.api.nvim_list_runtime_paths()
  return vim.fn.sort(rtpaths)
end

local get_paths = function(cmd_props)
  local all_paths = {}
  all_paths.rtpaths = get_runtime_files()
  local opacks = {}
  for match in (vim.o.packpath .. ","):gmatch("(.-)" .. ",") do
    table.insert(opacks, match)
  end
  all_paths.opacks = vim.fn.sort(opacks)
  all_paths.scriptnames = get_scriptnames()

  for key, val in pairs(all_paths) do
    vim.notify(key .. " " .. #val, 3)
  end
  vim.dbglog(vim.dump(all_paths.rtpaths))

  -- vim.ui.select(opacks)
end

cmd("CloseMulti", close_multi, { desc = "Close tabpage, window, or buffer in that order" })
cmd("GetPaths", get_paths, { desc = "Get path collections (rtpaths, o.packpath, etc)" })

local get_runtime_files = function()
  local rtpaths = vim.api.nvim_list_runtime_paths()
  return vim.fn.sort(rtpaths)
end
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
