-- local ok, cmp = pcall(require, "plugins.config.nvim-cmp")

local utils = {}
utils.find = function(array, key, val)
  for i, v in ipairs(array) do
    vim.dbglog(i, v)
    if v[key] == val then
      return v
    end
  end
end

local keys = {
  {
    buffer = 0,
    expr = 0,
    lhs = "<Plug>SnipRunOperator",
    lnum = 0,
    mode = "n",
    noremap = 0,
    nowait = 0,
    rhs = ":set opfunc=SnipRunOperator<CR>g@",
    script = 0,
    sid = -8,
    silent = 1
  },
  {
    buffer = 0,
    expr = 0,
    lhs = "<Plug>SnipRun",
    lnum = 0,
    mode = "n",
    noremap = 0,
    nowait = 0,
    rhs = ":lua require'sniprun'.run()<CR>",
    script = 0,
    sid = -8,
    silent = 1
  },
  {
    buffer = 0,
    expr = 0,
    lhs = "<C-L>",
    lnum = 0,
    mode = "n",
    noremap = 1,
    nowait = 0,
    rhs = "<C-W>l",
    script = 0,
    sid = -8,
    silent = 0
  }
}

vim.dbg(utils.find(keys, "lhs", "gF"))
