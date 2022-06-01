local M = {
  registers = {
    cmd   = "<cmd>Registers<cr>",
    short = "view registers",
    long  = "view registers",
  },
  whichkey = {
    cmd   = "<cmd>WhichKey<cr>",
    short = "toggle whichkey",
    long  = "toggle whichkey",
  },
  nvim_tree = {
    cmd   = "<cmd>NvimTreeToggle<cr>",
    short = "toggle nvim-tree",
    long  = "toggle nvim-tree",
  },
  mundo1 = {
    cmd   = "<cmd>MundoToggle<cr>",
    short = "toggle mundo",
    long  = "toggle mundo",
  },
  term1 = {
    cmd   = "<cmd>FloatermToggle<cr>",
    short = "toggle floaterm",
    long  = "toggle floaterm",
  },
  treesitter = {
    cmd   = "<cmd>TSPlaygroundToggle<cr>",
    short = "toggle treesitter",
    long  = "toggle treesitter",
  },
  aerial = {
    cmd   = "<cmd>AerialToggle!right<cr>",
    short = "toggle aerial",
    long  = "toggle aerial",
  },
  aerial_float = {
    cmd   = "<cmd>AerialToggle!float<cr>",
    short = "toggle aerial float",
    long  = "toggle aerial float",
  },
  mundo2 = {
    cmd   = "<cmd>MundoToggle<cr>",
    short = "toggle mundo",
    long  = "toggle mundo",
  },
  conceal_clear = {
    cmd   = "<cmd>set conceallevel=0<cr>",
    short = "clear conceal",
    long  = "clear conceal",
  },
  conceal_0 = {
    cmd   = "<cmd>set conceallevel=0<cr>",
    short = "set conceal 0",
    long  = "set conceal 0",
  },
  conceal_1 = {
    cmd   = "<cmd>set conceallevel=1<cr>",
    short = "set conceal 1",
    long  = "set conceal 1",
  },
  conceal_2 = {
    cmd   = "<cmd>set conceallevel=2<cr>",
    short = "set conceal 2",
    long  = "set conceal 2",
  },
  conceal_3 = {
    cmd   = "<cmd>set conceallevel=3<cr>",
    short = "set conceal 3",
    long  = "set conceal 3",
  },
  ts_highlights = {
    cmd = "<cmd>TSHighlightCapturesUnderCursor<cr>",
    short = "ts highlight cursor",
    long = "ts highlight cursor"
  },
  list_definitions = {
    short = "list ts definitions",
    long  = "list ts definitions",
  }, -- virtual
  toc_definitions = { short = "toc ts definitions", long = "toc ts definitions" } -- virtual
}
return M
