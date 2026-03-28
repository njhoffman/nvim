require('hover').setup({
  init = function()
    -- LSP providers
    require('hover.providers.lsp-hover')
    require('hover.providers.lsp-signature')
    require('hover.providers.lsp-definition')
    require('hover.providers.lsp-type-definition')

    -- Documentation providers
    require('hover.providers.help')
    require('hover.providers.man')
    require('hover.providers.dictionary')

    -- Code inspection providers
    require('hover.providers.syntax')

    -- External providers
    require('hover.providers.gh')
  end,
  border = 'rounded',
  focusable = false,
  -- cursor_delay = 300,  -- ms before HoverCursor shows (nil = use updatetime/CursorHold)
  -- sticky_delay = 500,  -- ms before HoverSticky refreshes (nil = use updatetime/CursorHold)
  devbox = {
    popup = {
      width = 40,
      position = 'SE', -- SE, SW, NE, NW
    },
  },
})

-- Providers and their priorities:
--   lsp-hover        (500)  - LSP textDocument/hover
--   lsp-signature    (200)  - LSP textDocument/signatureHelp
--   lsp-definition  (1000)  - LSP textDocument/definition (shows source code)
--   lsp-type-definition (1000) - LSP textDocument/typeDefinition
--   help            (1000)  - Neovim help tags (lua filetype only)
--   man              (150)  - Man pages (sh/zsh/bash/tcl/make filetypes)
--   dictionary       (100)  - Online dictionary (md/txt/doc filetypes)
--   syntax           (150)  - Treesitter/syntax highlight info
--   gh               (200)  - GitHub issues (md/txt/doc filetypes, #123 pattern)
--
-- Commands:
--   :Hover [provider]       - One-shot popup, closes on cursor move
--   :HoverCursor [provider] - Shows after CursorHold, hides on move, re-shows on hold
--   :HoverSticky [provider] - Always visible, refreshes on CursorHold
--   :HoverInspect            - Open devbox inspection panel (provider timing, syntax, LSP info)
--   :HoverClose             - Close popup and disable autocommands (only when active)
--
-- Config options:
--   cursor_delay  (number|nil) - ms delay for HoverCursor (nil = use updatetime)
--   sticky_delay  (number|nil) - ms delay for HoverSticky (nil = use updatetime)
--   devbox.popup.width    (number|function) - devbox popup width (default: 40)
--   devbox.popup.position (string|function) - devbox popup corner: SE, SW, NE, NW (default: SE)
