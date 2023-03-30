local command_rg = {
  "rg",
  "--color=never",
  "--one-file-system",
  "--ignore",
  "--smart-case",
  "--hidden",
  "--files",
  "--sort",
  "path",
}

local command_fd = { "fd", "--type", "f", "--strip-cwd-prefix" }
local command_vimgrep = {
  "rg",
  "--color=never",
  "--no-heading",
  "--with-filename",
  "--line-number",
  "--hidden",
  "--column",
  "--smart-case",
  "--vimgrep",
  "--sort",
  "path",
}

return {
  rg = command_rg,
  fd = command_fd,
  vimgrep = command_vimgrep,
}
