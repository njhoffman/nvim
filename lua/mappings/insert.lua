local map = require("utils.core").map

local insert_map = {
  ["<c-s>"] = { "<esc><cmd>w<cr>", "Quick save" },
  ["||"] = { "enable table mode" },
  ["__"] = { "disable table mode" },
  ["<C-u>"] = { "<C-g>u<C-u>", "which_key_ignore" }, -- Make <C-u> undo-friendly
  ["<C-w>"] = { "<C-g>u<C-w>", "which_key_ignore" }, -- Make <C-w> undo-friendly
};

local insert_opts = { mode = "i", buffer = nil, silent = true, noremap = true, nowait = true }

map("i", "jk", [[col('.') == 1 ? '<esc>' : '<esc>l']], { expr = true })

require("which-key").register(insert_map, insert_opts)
