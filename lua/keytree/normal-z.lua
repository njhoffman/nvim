return {
  tag = "z",
  mappings = {
    {
      tag = "z<CR>",
      key = "z<CR>",
      description = "redraw, cursor line to top of window, cursor on first non-blank",
    },
    {
      tag = "zN<CR>",
      key = "z{height}<CR>",
      description = "redraw, make window {height} lines high",
    },
    {
      tag = "z+",
      key = "z+",
      description = 'cursor on line N (default line below window), otherwise like "z<CR>"',
    },
    {
      tag = "z-",
      key = "z-",
      description = "redraw, cursor line at bottom of window, cursor on first non-blank",
    },
    {
      tag = "z.",
      key = "z.",
      description = "redraw, cursor line to center of window, cursor on first non-blank",
    },
    {
      tag = "z=",
      key = "z=",
      description = "give spelling suggestions",
    },
    {
      tag = "zA",
      key = "zA",
      description = "open a closed fold or close an open fold recursively",
    },
    {
      tag = "zC",
      key = "zC",
      description = "close folds recursively",
    },
    {
      tag = "zD",
      key = "zD",
      description = "delete folds recursively",
    },
    {
      tag = "zE",
      key = "zE",
      description = "eliminate all folds",
    },
    {
      tag = "zF",
      key = "zF",
      description = "create a fold for N lines",
    },
    {
      tag = "zG",
      key = "zG",
      description = "temporarily mark word as correctly spelled",
    },
    {
      tag = "zH",
      key = "zH",
      description = "when 'wrap' off scroll half a screenwidth to the right",
    },
    {
      tag = "zL",
      key = "zL",
      description = "when 'wrap' off scroll half a screenwidth to the left",
    },
    {
      tag = "zM",
      key = "zM",
      description = "set 'foldlevel' to zero",
    },
    {
      tag = "zN",
      key = "zN",
      description = "set 'foldenable'",
    },
    {
      tag = "zO",
      key = "zO",
      description = "open folds recursively",
    },
    {
      tag = "zR",
      key = "zR",
      description = "set 'foldlevel' to the deepest fold",
    },
    {
      tag = "zW",
      key = "zW",
      description = "temporarily mark word as incorrectly spelled",
    },
    {
      tag = "zX",
      key = "zX",
      description = "re-apply 'foldlevel'",
    },
    {
      tag = "z^",
      key = "z^",
      description = 'cursor on line N (default line above window), otherwise like "z-"',
    },
    {
      tag = "za",
      key = "za",
      description = "open a closed fold, close an open fold",
    },
    {
      tag = "zb",
      key = "zb",
      description = "redraw, cursor line at bottom of window",
    },
    {
      tag = "zc",
      key = "zc",
      description = "close a fold",
    },
    {
      tag = "zd",
      key = "zd",
      description = "delete a fold",
    },
    {
      tag = "ze",
      key = "ze",
      description = "when 'wrap' off scroll horizontally to position the cursor at the end (right side) of the screen",
    },
    {
      tag = "zf",
      key = "zf{motion}",
      description = "create a fold for Nmove text",
    },
    {
      tag = "zg",
      key = "zg",
      description = "permanently mark word as correctly spelled",
    },
    {
      tag = "zh",
      key = "zh",
      description = "when 'wrap' off scroll screen N characters to the right",
    },
    {
      tag = "zi",
      key = "zi",
      description = "toggle 'foldenable'",
    },
    {
      tag = "zj",
      key = "zj",
      description = "1  move to the start of the next fold",
    },
    {
      tag = "zk",
      key = "zk",
      description = "1  move to the end of the previous fold",
    },
    {
      tag = "zl",
      key = "zl",
      description = "when 'wrap' off scroll screen N characters to the left",
    },
    {
      tag = "zm",
      key = "zm",
      description = "subtract one from 'foldlevel'",
    },
    {
      tag = "zn",
      key = "zn",
      description = "reset 'foldenable'",
    },
    {
      tag = "zo",
      key = "zo",
      description = "open fold",
    },
    {
      tag = "zp",
      key = "zp",
      description = "paste in block-mode without trailing spaces",
    },
    {
      tag = "zP",
      key = "zP",
      description = "paste in block-mode without trailing spaces",
    },
    {
      tag = "zr",
      key = "zr",
      description = "add one to 'foldlevel'",
    },
    {
      tag = "zs",
      key = "zs",
      description = "when 'wrap' off scroll horizontally to position the cursor at the start (left side) of the screen",
    },
    {
      tag = "zt",
      key = "zt",
      description = "redraw, cursor line at top of window",
    },
    {
      tag = "zuw",
      key = "zuw",
      description = "undo |zw|",
    },
    {
      tag = "zug",
      key = "zug",
      description = "undo |zg|",
    },
    {
      tag = "zuW",
      key = "zuW",
      description = "undo |zW|",
    },
    {
      tag = "zuG",
      key = "zuG",
      description = "undo |zG|",
    },
    {
      tag = "zv",
      key = "zv",
      description = "open enough folds to view the cursor line",
    },
    {
      tag = "zw",
      key = "zw",
      description = "permanently mark word as incorrectly spelled",
    },
    {
      tag = "zx",
      key = "zx",
      description = "re-apply 'foldlevel' and do \"zv\"",
    },
    {
      tag = "zy",
      key = "zy",
      description = "yank without trailing spaces",
    },
    {
      tag = "zz",
      key = "zz",
      description = "redraw, cursor line at center of window",
    },
    {
      tag = "z<Left>",
      key = "z<Left>",
      description = 'same as "zh"',
    },
    {
      tag = "z<Right>",
      key = "z<Right>",
      description = 'same as "zl"',
    },
  },
}
