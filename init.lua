-- require('internals').init()

require("globals")

local _shell = vim.o.shell or "/bin/sh"

vim.cmd("set shell=/bin/sh")

vim.import("configs.noice")
-- https://github.com/stevearc/quicker.nvim
vim.import("quickfix")

require("utils.lazy").setup({ cache = true, reload = false, lazy = false })
-- qfSeparator, qfLineNr, qfFilename

for _, mod_name in ipairs({
  "project",
  "keymaps",
  "commands",
  "abbreviations",
  "autocommands",
  "devbox",
  "runner",
  "stats",
  "devdocs2.setup",
  -- 'configs.cinnamon',
  "tracker.setup",
  "tmux.setup",
  "configs.registers",
  "configs.smoothcursor",
  -- 'configs.nvim-scrollbar',
  -- 'configs.neoscroll',
  "action-hints.setup",
  -- 'winsep.setup',
  -- 'better_escape-setup',
  "early-retirement.setup",
  "oldfiles",
  "tail",
  "configs.mini-comment",
  "hover.setup",
  -- "NeoComposer._setup",
  "configs.feline",
  "configs.definition-or-references",
  "baleia.setup",
  -- "demicolon.setup",
}) do
  vim.import(mod_name)
end

vim.defer_fn(function()
  -- require("modeman")
  vim.import("alt").setup()
  vim.import("live-command.setup")
  vim.import("sidebar").setup()
  vim.import("histories").setup()
  -- vim.import("scrollview.setup")

  vim.import("format_cmdline").setup()

  -- 'lab.setup',
  local llm_config = require("llm-config")
  vim.import("llm").setup(llm_config)
  -- local neoai_cfg = require("neoai.options")
  -- vim.import("neoai").setup(neoai_cfg)

  vim.import("configs.recall")

  -- vim.api.nvim_create_autocmd("FileType", {
  --   pattern = "zsh",
  --   callback = function(args)
  --     vim.treesitter.language.register("bash", { "zsh" })
  --     vim.treesitter.start(args.buf, "bash")
  --     vim.bo[args.buf].syntax = "on"
  --   end,
  -- })
  -- require("nvim-treesitter.parsers").filetype_to_parsername.zsh = "bash"
  --   local link_pattern = 9 -- from :Inspect!
  --   local query = vim.treesitter.query.get('vimdoc', 'highlights')
  --   query.query:disable_pattern(link_pattern)
  --   local tree = vim.treesitter.get_parser():parse()[1]
  --   local query = vim.treesitter.query.get('vimdoc', 'highlights')
  --   query.query:disable_capture("variable.parameter")
  --   vim.treesitter.get_parser():parse()

  -- for id, node, metadata, match in query:iter_captures(tree:root(), bufnr, first, last) do
  --   local name = query.captures[id] -- name of the capture in the query
  --   -- typically useful info about the node:
  --   local type = node:type() -- type of the captured node
  --   local row1, col1, row2, col2 = node:range() -- range of the capture
  --   -- ... use the info here ...
  -- end
  -- syn match zshGlobParam /.\{-})/ contained containedin=zshSubstQuoted

  -- require"nvim-treesitter.parsers".filetype_to_parsername.zsh = "bash"
  --   require("nvim-treesitter.parsers").get_parser_configs().zsh = { install_info = {} }
  --   require("nvim-treesitter.parsers").get_parser_configs().bash.used_by = { "PKGBUILD" }
  --   require("nvim-treesitter.parsers").get_parser_configs().bash.used_by = { "PKGBUILD" }
  -- local ft_to_lang = require('nvim-treesitter.parsers').ft_to_lang
  -- require('nvim-treesitter.parsers').ft_to_lang = function(ft)
  --     if ft == 'zsh' then
  --         return 'bash'
  --     end
  --     return ft_to_lang(ft)
  -- end
  -- require('internals').setup()
  if vim.g.started_by_firenvim then
    vim.api.nvim_set_keymap("n", "<C-z>", "<Cmd>call firenvim#hide_frame()<CR>", {})
    vim.api.nvim_set_keymap("n", "<Esc><Esc>", "<Cmd>call firenvim#focus_page()<CR>", {})

    vim.api.nvim_create_autocmd({ "BufEnter" }, {
      pattern = "github.com_*.txt",
      command = "set filetype=markdown",
    })
  end
end, 100)

vim.defer_fn(function()
  vim.import("configs.telescope")
  -- vim.import("garbage-day").setup({
  --   notifications = true,
  --   -- excluded_lsp_clients = { "copilot", "dev-tools" },
  --   -- aggressive_mode = false,
  --   -- aggresive_mode_ignore = {
  --   --   filetype = { "", "markdown", "text", "org", "tex", "asciidoc", "rst" },
  --   --   buftype = { "nofile" },
  --   -- },
  --   -- filetype = { "", "markdown", "text", "org", "tex", "asciidoc", "rst" },
  --   -- buftype = { "nofile" },
  --   excluded_lsp_clients = { "copilot", "marksman", "lua_ls", "pyright" },
  --   -- grace_period = (60 * 15), -- seconds
  --   -- notifications = false,
  --   -- retries = 3, -- times
  --   -- timeout = 1000, -- ms
  --   -- wakeup_delay = 0, -- ms
  -- })

  vim.api.nvim_set_keymap("x", "<F10>", "<Cmd>=vim.fn.getpos('v')<CR>", {})
  -- vim.api.nvim_set_keymap("n", "<F10>", "<Cmd>Telescope tester script<CR>", {})
end, 500)
-- require("notifications.recipes.progress").config()
