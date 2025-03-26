-- https://raw.githubusercontent.com/smjonas/live-command.nvim/main/README.md
-- commands = {
-- Norm = { cmd = "norm" },
-- Glive = { cmd = "g" },
-- Dlive = { cmd = "d" },
-- Qlive = {
-- cmd = "norm",
-- -- This will transform ":5Qlive a" into ":norm 5@a"
-- args = function(opts)
-- local reg = opts.fargs and opts.fargs[1] or "q"
-- local count = opts.fargs and opts.fargs[2] or (opts.count == -1 and "" or opts.count)
-- return count .. "@" .. reg
-- end,
-- range = "",
-- },
local old_commands = {
  Norm = { cmd = "norm", hl_range = { kind = "visible" } },
  G = { cmd = "g", hl_range = { 1, -1, kind = "absolute" } },
  D = { cmd = "d", hl_range = { 1, -1, kind = "absolute" } },
  -- :5Reg a (preview macros) -> :norm 5@a
  Reg = {
    cmd = "norm",
    -- args = function(opts)
    --   return (opts.count == -1 and '' or opts.count) .. '@' .. opts.args
    -- end,
    -- range = '',
  },
  LSubvert = { cmd = "Subvert" },
  -- :S/txt/repl/g
  -- Sub = { cmd = '%s', hl_range = { kind = 'visible' } },
  S = { cmd = "s", hl_range = { kind = "visible" } },
}

-- `:'<,'>Preview norm A;`
-- :Norm 5@a
-- :'<,'>Preview norm daw
-- :LiveCommand log
-- :LiveCommand diagnose

local commands = {
  Norm = { cmd = "norm" },
  -- G = { cmd = "g" },
  -- V = { cmd = "v" },
}

-- Transforms ":5Reg a" into ":norm 5@a"
local function get_command_string(cmd)
  local get_range_string = require("live-command").get_range_string
  local args = (cmd.count == -1 and "" or cmd.count) .. "@" .. cmd.args
  return get_range_string(cmd) .. "norm " .. args
end

vim.api.nvim_create_user_command("Reg", function(cmd)
  vim.cmd(get_command_string(cmd))
end, {
  nargs = "?",
  range = true,
  preview = function(cmd, preview_ns, preview_buf)
    local cmd_to_preview = get_command_string(cmd)
    return require("live-command").preview_callback(cmd_to_preview, preview_ns, preview_buf)
  end,
})

require("live-command").setup({
  commands = commands,
  enable_highlighting = true,
  inline_highlighting = true,
  hl_groups = {
    insertion = "DiffAdd",
    deletion = "DiffDelete",
    change = "DiffChange",
  },
  debug = true,
})
