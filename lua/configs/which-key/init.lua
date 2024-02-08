-- u = { name = " 󰕌 Undo" },
-- o = { name = "  Options" },
-- p = { name = " 󰏗 Packages" },
-- c = { name = "  Code Action" },
-- i = { name = " 󱡴 Inspect" },

-- stylua: ignore
local config = {
  plugins = {
    registers = false,
    -- marks = true,
    -- spelling = {
    --   enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
    --   suggestions = 20, -- how many suggestions should be shown in the list?
    -- },
    presets = false,
    -- presets = {
    --   operators = true, -- adds help for operators like d, y, ...
    --   motions = true, -- adds help for motions
    --   text_objects = true, -- help for text objects triggered after entering an operator
    --   windows = true, -- default bindings on <c-w>
    --   nav = true, -- misc bindings to work with windows
    --   z = true, -- bindings for folds, spelling and others prefixed with z
    --   g = true, -- bindings for prefixed with g
    --   mouse = false,
    --   extra = false
    -- },
  },
  presets = {
    -- spelling
    --   { trigger = 'z=', mode = 'n', label = 'give spelling suggestions' },
    -- marks
    --   { trigger = "'", mode = "n", label = "μ,Ξ_Δ to the first CHAR on the line with mark μ" },
    --   { trigger = "`", mode = "n", label = "μ,Ξ_Δ to the mark μ" },
    --   { trigger = "g`", mode = "n", label = "μ,Ξ_like |'| but without changing the jumplist" },
    --   { trigger = "g'", mode = "n", label = "μ,Ξ_like |`| but without changing the jumplist" },
    --   ['^'] = 'Last position of cursor in insert mode',
    --   ['.'] = 'Last change in current buffer',
    --   ['"'] = 'Last exited current buffer',
    --   ['0'] = 'In last file edited',
    --   ["'"] = 'Back to line in current buffer where jumped from',
    --   ['`'] = 'Back to position in current buffer where jumped from',
    --   ['['] = 'To beginning of previously changed or yanked text',
    --   [']'] = 'To end of previously changed or yanked text',
    --   ['<lt>'] = 'To beginning of last visual selection',
    --   ['>'] = 'To end of last visual selection',
    -- registers
      -- { trigger = '"', mode = 'n', label = 'λ_use λ for next delete, yank or put' },
      -- { trigger = '@', mode = 'n', label = 'α,Ψ_execute the contents of register α N times' },
      -- { trigger = '<c-r>', mode = 'i', label = "λ_insert a register's content" },
      -- { trigger = '<c-r>', mode = 'c', label = "λ_insert a register's content or Δobject as if typed", },
    operators = function()
      return {
        d = 'Delete',
        c = 'Change',
        y = 'Yank (copy)',
        ['g~'] = 'Toggle case',
        ['gu'] = 'Lowercase',
        ['gU'] = 'Uppercase',
        ['>'] = 'Indent right',
        ['<lt>'] = 'Indent left',
        ['zf'] = 'Create fold',
        ['!'] = 'Filter through external program',
        ['v'] = 'Visual Character Mode',
        --- ["V"] = "Visual Line Mode",
        -- ['c'] = 'ξ,ΛΨ_(change) delete text, start insert',
        -- ['d'] = 'ξ,ΛΨ_delete text',
        -- ['y'] = 'ξ,Λ_yank text',
        -- ['!'] = 'ξζ,Ψ_filter text through the ζ command',
        -- ['='] = "ξ,Ψ_filter lines through 'equalprg'",
        -- ['g~'] = 'ξ,Ψ_swap case for text',
        -- ['gU'] = 'ξ,Ψ_make text uppercase',
        -- ['gu'] = 'ξ,Ψ_make text lowercase',
        -- ['gq'] = 'ξ,Ψ_format text',
        -- ['gw'] = 'ξ,Ψ_format text, keep Δ',
        -- ['g?'] = 'ξ,Ψ_encode with Rot13',
        -- ['g@'] = "ξ_call 'operatorfunc'",
        -- ['zf'] = 'ξ_create a fold for text',
        -- ['<LT>'] = "ξ,Ψ_shift lines one 'shiftwidth' leftwards",
        -- ['>'] = "ξ,Ψ_shift lines one 'shiftwidth' rightwards",
        -- -- ["V"] = "Visual Line Mode",
      }
    end,
    motions = {
      ['h'] = 'Left',
      ['j'] = 'Down',
      ['k'] = 'Up',
      ['l'] = 'Right',
      ['w'] = 'Next word',
      ['%'] = "Matching character: '()', '{}', '[]'",
      ['b'] = 'Previous word',
      ['e'] = 'Next end of word',
      ['ge'] ='Previous end of word',
      ['0'] = 'Start of line',
      ['^'] = 'Start of line (non-blank)',
      ['$'] = 'End of line',
      ['f'] = 'Move to next char',
      ['F'] = 'Move to previous char',
      ['t'] = 'Move before next char',
      ['T'] = 'Move before previous char',
      ['gg'] = 'First line',
      ['G'] = 'Last line',
      ['{'] = 'Previous empty line',
      ['}'] = 'Next empty line',
    },
    -- 'motions',
    'text_objects',
    'windows',
    'nav',
    'z',
    'g',
  },
  ignore_missing = false,
  -- autokey replacements
  --   ['<M-g>'] = '<C-g>',
  --   ['<M-G>'] = '<C-G>',
  triggers = 'auto', -- automatically setup triggers
  triggers_blacklist = {
    -- n = { 'v' },
    i = { 'j', 'k' },
    v = { 'j', 'k' },
  },
  operators = {
    gc = 'comments',
    S = 'substitute',
    c = "Change",
    -- s = 'surround',
    -- ["g@"] = "operatorfunc",

    --
    -- |c|	c	change
    -- |d|	d	delete
    -- |y|	y	yank into register (does not change the text)
    -- |~|	~	swap case (only if 'tildeop' is set)
    -- |g~|	g~	swap case
    -- |gu|	gu	make lowercase
    -- |gU|	gU	make uppercase
    -- |!|	!	filter through an external program
    -- |=|	=	filter through 'equalprg' or C-indenting if empty
    -- |gq|	gq	text formatting
    -- |gw|	gw	text formatting with no cursor movement
    -- |g?|	g?	ROT13 encoding
    -- |g@|	g@	call function set with the 'operatorfunc' option
    -- |zf|	zf	define a fold
    -- |>|	>	shift right
    -- |<|	<	shift left
    },
  triggers_nowait = {
    -- 'c',
    -- 'y',
    -- marks
    '`',
    "'",
    'g`',
    "g'",
    -- registers
    -- '"',
    -- '<c-r>',
    -- spelling
    'z=',
  },
  key_labels = {
    ['telescope'] = ' ',
    ['Telescope'] = ' ',
    ['operator']  = '',
    ['<CR>']      = '↵',
    ['<BS>']      = '⌫',
    ['<Tab>']     = '󰌒',
    ['<Esc>']     = '⎋',
    -- ['<space>']   = '󱁐',
    ['<PageDown>']    = '<PgDown>',
    ['<PageUp>']      = '<PgUp>',
    ['<M-Bslash>']     = '<M-\\>',
    ['<C-Bslash>']     = '<C-\\>',
    ['<space>']       = 'SPC',
    ['<M-Space>']     = 'M-SPC',
    ['<C-Space>']     = 'C-SPC',
    ['<M-C-Space>']   = 'M-C-SPC',
    ['<M-C-S-Down>']  = '<C-M-J>',
    ['<M-C-S-Up>']    = '<C-M-K>',
    ['<M-C-S-Left>']  = '<C-M-H>',
    ['<M-C-S-Right>'] = '<C-M-L>',
    ['<C-S-Down>']    = '<C-M-j>',
    ['<C-S-Up>']      = '<C-M-k>',
    ['<C-S-Left>']    = '<C-M-h>',
    ['<C-S-Right>']   = '<C-M-l>',
  },
  hidden = {
    '<silent>',
    '<cmd>',
    '<Cmd>',
    '<CR>',
    '^call',
    '^lua',
    '^:',
    '^ ',
    'require',
    'escope',
    'erator',
    '"',
  },
  ignored = {
    '<2-LeftMouse>',
    '<ScrollWheelDown>',
    '<ScrollWheelUp>'
  },
  popup_mappings = {
    scroll_down = '<C-S-Down>', -- binding to scroll down inside the popup
    scroll_up = '<C-S-Up>', -- binding to scroll up inside the popup
    page_down = '<M-f>', -- binding to scroll down inside the popup
    page_up = '<M-b>', -- binding to scroll up inside the popup
  },
  show_help = true, -- show a help message in the command line for using WhichKey,
  popup_user_mappings = {
    ['<M-C-_>'] = function(key, mode)
      require('telescope.builtin').keymaps {
        modes = { mode },
        lhs_filter = function(lhs)
          return vim.startswith(lhs, key)
        end,
      }
    end,
  },
  window = {
    winblend = 20,
    -- border = "rounded", -- none, single, double, shadow
    -- border = { '╭', '─', '╮', '│', '│', '_', '│', '│' },
    border = { '╭', '─', '─', '', '│', '_', '│', '│' },
    position = 'bottom', -- bottom, top
    margin = { 1, 0, 0, 0.7 }, -- extra window margin [top, right, bottom, left]
    padding = { 0, 0, 0, 0 }, -- extra window padding [top, right, bottom, left]
  },
  layout = {
    height = {
      min = 4,
      max = function() return tonumber(vim.o.lines) - 5 end,
    }, -- min and max height of the columns
    width = {
      max = function()
        return math.min(80, math.floor(tonumber(vim.o.columns * 0.4) or 80))
      end,
      min = 40,
    }, -- min and max width of the columns
    spacing = 3, -- spacing between columns
    align = 'center', -- left, center, right
  },
  other_layouts = {
    {
      name = 'bottom',
      layout = {
        height = { min = 10, max = 40 }, -- min and max height of the columns
        width = { min = 20, max = 40 }, -- min and max width of the columns
        spacing = 1, -- spacing between columns
        align = 'right', -- left, center, right
      },
      window = {
        winblend = 20,
        margin = { 5, 5, 5, 70 }, -- extra window margin [top, right, bottom, left]
        padding = { 0, 0, 0, 0 }, -- extra window padding [top, right, bottom, left]
        border = 'rounded', -- none, single, double, shadow
        position = 'bottom', -- bottom, top
      },
    }
  },
  icons = {
    breadcrumb = '»', -- symbol used in the command line area that shows your active key combo
    separator = '➜', -- symbol used between a key and it's label
    group = '+', -- symbol prepended to a group
  },
  hooks = {
    list_pre = function(items)
      vim.dbglog('list_items', #items)
      return items
    end,
    list_post = function(text)
      vim.dbglog('list_post', vim.tbl_keys(text))
      return text
    end,
    breadcrumbs = function(breadcrumbs, cmd_line, results)
      vim.dbglog('breadcrumbs', breadcrumbs, cmd_line, vim.tbl_keys(results))
      return breadcrumbs
    end
  },
  mode_highlights = {}, -- separator, group, desc float value, border, mode
  debug = true,
  vimade_fade = true,
}

require('which-key').setup(config)

require('which-key').register({ ['<C-Q>'] = { name = '+Test' }, { mode = 'n' } })
_G._wk_timing = function()
  local state = require('which-key.view').state
  local lineout = ''
  if state.timing.show_n > 0 then
    lineout = lineout .. string.format('**show**   `%.4f` %2d', state.timing.show_average, state.timing.show_n)
  end
  if state.timing.keys_n > 0 then
    lineout = lineout ~= '' and lineout .. '\n' or lineout
    lineout = lineout .. string.format('**keys**   `%.4f` %2d', state.timing.keys_average, state.timing.keys_n)
  end
  if lineout ~= '' then
    vim.notify(lineout, vim.log.levels.INFO, {
      filetype = 'markdown',
    })
  end
end

-- :WhichKey " show all mappings
-- :WhichKey <leader> " show all <leader> mappings
-- :WhichKey <leader> v " show all <leader> mappings for VISUAL mode
-- :WhichKey '' v " show ALL mappings for VISUAL mode
--

-- hotkeys
-- n-0 n-9 tabtree
-- csn dsn ysn
