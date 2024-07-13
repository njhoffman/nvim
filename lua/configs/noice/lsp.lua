local lsp = {
  progress = {
    enabled = true,
    format = 'lsp_progress',
    format_done = 'lsp_progress_done',
    throttle = 1000 / 30, -- frequency to update lsp progress message
    view = 'mini',
  },
  override = {
    -- require('noice.lsp.override'), 'noice.lsp.format', 'noice.text.markdown'
    ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
    -- vim.lsp.util.convert_input_to_markdown_lines = function(input, contents)
    --     Format = require("noice.lsp.format")
    --     contents = contents or {}
    --     local ret = Format.format_markdown(input)
    --     vim.list_extend(contents, ret)
    --   return contents
    ['vim.lsp.util.stylize_markdown'] = true,
    -- vim.lsp.util.stylize_markdown = function(buf, contents, _opts)
    --     local Markdown = require("noice.text.markdown")
    --     local message = Message("lsp")
    --     Markdown.format(message, text)
    --     message:render(buf, Config.ns)
    --     Markdown.keys(buf)
    --   return vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    ['cmp.entry.get_documentation'] = true,
    -- Hacks.on_module("cmp.entry", function(mod)
    --   mod.get_documentation = function(self)
    --     local item = self:get_completion_item()
    --     if item.documentation then
    --       return Format.format_markdown(item.documentation)
    --     end
    --     return {}
  },
  hover = {
    enabled = true,
    -- view = nil, -- when nil, use defaults from documentation
    -- silent = false,
    opts = {
      focusable = true,
      win_options = {
        scrolloff = 0,
        -- scrollback = 1,
      },
    }, -- merged with defaults from documentation
  },
  signature = {
    enabled = true,
    --   view = nil, -- when nil, use defaults from documentation
    auto_open = {
      enabled = true,
      trigger = true, -- Automatically show signature help when typing a trigger character from the LSP
      luasnip = true, -- Will open signature help when jumping to Luasnip insert nodes
      throttle = 200, -- Debounce lsp signature help request by 50ms
    },
  },
  message = {
    -- Messages shown by lsp servers
    enabled = true,
    view = 'notify',
    opts = {},
  },
  -- defaults for hover and signature help
  documentation = {
    view = 'hover',
    --  opts = { replace = true, render = "plain", format = { "{message}" },
    --          win_options = { concealcursor = "n", conceallevel = 3 }, },
    opts = {
      lang = 'markdown',
      replace = true,
      render = 'plain',
      format = { '{message}' },
      win_options = {
        concealcursor = 'n',
        conceallevel = 3,
        cursorline = false,
      },
    },
  },
}

return lsp
