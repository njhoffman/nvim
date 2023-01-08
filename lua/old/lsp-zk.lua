local function setup_zk(config)
  local zk = require("zk")
  local util = require("zk.util")
  local commands = require("zk.commands")

  zk.setup({
    picker = "telescope",
    lsp = {
      config = config,
    },
  })

  local function make_edit_fn(defaults, picker_options)
    return function(options)
      options = vim.tbl_extend("force", defaults, options or {})
      zk.edit(options, picker_options)
    end
  end

  local function make_new_fn(defaults)
    return function(options)
      options = vim.tbl_extend("force", defaults, options or {})
      zk.new(options)
    end
  end

  commands.add("ZkOrphans", make_edit_fn({ orphan = true }, { title = "Zk Orphans" }))
  commands.add("ZkRecents", make_edit_fn({ createdAfter = "2 weeks ago" }, { title = "Zk Recents" }))
  commands.add("ZkLiveGrep", function(options)
    options = options or {}
    local notebook_path = options.notebook_path or util.resolve_notebook_path(0)
    local notebook_root = util.notebook_root(notebook_path)
    if notebook_root then
      require("telescope.builtin").live_grep({ cwd = notebook_root, prompt_title = "Zk Live Grep" })
    else
      vim.notify("No notebook found", vim.log.levels.ERROR)
    end
  end)

  commands.add("ZkNewDaily", make_new_fn({ dir = "journal/daily" }))
  commands.add("ZkNewHealth", make_new_fn({ dir = "journal/health" }))

  commands.add("ZkDaily", make_edit_fn({ hrefs = { "journal/daily" }, sort = { "created" } }, { title = "Zk Daily" }))
  commands.add(
    "ZkHealth",
    make_edit_fn({ hrefs = { "journal/health" }, sort = { "created" } }, { title = "Zk Health" })
  )

  vim.api.nvim_set_keymap("n", "<Leader>zc", "<cmd>ZkNew<CR>", { noremap = true })
  vim.api.nvim_set_keymap("x", "<Leader>zc", ":'<,'>ZkNewFromTitleSelection<CR>", { noremap = true })
  vim.api.nvim_set_keymap("x", "<Leader>zC", ":'<,'>ZkNewFromContentSelection<CR>", { noremap = true })
  vim.api.nvim_set_keymap("n", "<leader>zn", "<cmd>ZkNotes { sort = { 'modified' } }<CR>", { noremap = true })
  vim.api.nvim_set_keymap("n", "<leader>zg", "<cmd>ZkLiveGrep<CR>", { noremap = true })
  vim.api.nvim_set_keymap(
    "n",
    "<leader>zf",
    "<cmd>ZkNotes { sort = { 'modified' }, match = vim.fn.input('Search: ') }<CR>",
    { noremap = true }
  )
  vim.api.nvim_set_keymap("n", "<Leader>zb", "<cmd>ZkBacklinks<CR>", { noremap = true })
  vim.api.nvim_set_keymap("n", "<Leader>zl", "<cmd>ZkLinks<CR>", { noremap = true })
  vim.api.nvim_set_keymap("n", "<Leader>zt", "<cmd>ZkTags<CR>", { noremap = true })
  vim.api.nvim_set_keymap("x", "<Leader>zm", ":'<,'>ZkMatch<CR>", { noremap = true })

  require("telescope").load_extension("zk")
end

return { setup_zk = setup_zk }
