-- some shorthands...
local types = require("luasnip.util.types")

-- Every unspecified option will be set to the default.
local opts = {
  history = true,
  update_events = "TextChanged,TextChangedI",
  delete_check_events = "TextChanged",
  ext_opts = {
    [types.choiceNode] = {
      active = {
        virt_text = { { " ", "TSTextReference" } },
      },
    },
    [types.insertNode] = {
      active = {
        virt_text = { { " ", "TSEmphasis" } },
      },
    },
  },
  ext_base_prio = 300,
  ext_prio_increase = 1,
  enable_autosnippets = true,
  cut_selection_keys = false,
  -- cut_selection_keys = '<Tab>',
  ft_func = require("luasnip.extras.filetype_functions").from_pos_or_filetype,
}

vim.cmd([[command! LuaSnipEdit :lua require("luasnip.loaders.from_lua").edit_snippet_files()]]) --}}}
require("mapper").map("n", "<Leader><CR>", "<cmd>LuaSnipEdit<cr>", { desc = "Edit LuaSnip snippets" })

vim.schedule(function()
  require("luasnip.loaders.from_vscode").lazy_load()
  require("luasnip.loaders.from_lua").lazy_load({
    paths = vim.fn.stdpath("config") .. "/lua/snippets/",
  })
  require("luasnip.loaders.from_snipmate").lazy_load() -- honza/vim-snippets
end)

vim.schedule(function()
  local ls = require("luasnip")
  ls.setup(opts)
  ls.filetype_extend("all", { "_" })
  ls.filetype_extend("lua", { "c" })
  ls.filetype_set("cpp", { "c" })
  -- eg. treesitter for getting the current filetype by setting ft_func to
  -- unlink active snippet on mode change to prevent accidental jumps and frustration
  vim.api.nvim_create_autocmd("ModeChanged", {
    group = vim.api.nvim_create_augroup("UnlinkLuaSnipSnippetOnModeChange", {
      clear = true,
    }),
    pattern = { "s:n", "i:*" },
    desc = "Forget the current snippet when leaving the insert mode",
    callback = function(evt)
      if ls.session and ls.session.current_nodes[evt.buf] and not ls.session.jump_active then
        ls.unlink_current()
      end
    end,
  })
end)

--
-- require("plugins.config.luasnip-snips")
