-- printf "%b\n\n" "\x1b[7;32mTEST    \x1b[0m"
-- printf "%b\n\n" "\x1b[1;32mTEST \x1b[7;32m    \x1b[0m"

-- # TEST    
-- # TEST     

local bullets = {
  { "◆", "◇", "", "" },
  { "", "", "", "" },
}
-- ◆ ◇ 󰨑 󱓝    󰄯 󰄰  ● ○ 󰻃   󰧞  󰧟 

--       require("render-markdown").setup(opts)
--       Snacks.toggle({
--         name = "Render Markdown",
--         get = function()
--           return require("render-markdown.state").enabled
--         end,
--         set = function(enabled)
--           local m = require("render-markdown")
--           if enabled then
--             m.enable()
--           else
--             m.disable()
--           end
--         end,
--       }):map("<leader>um")

local cfg = {
  -- custom_handlers = {
  --   org = {
  --     parse = require("configs.render-markdown.view-orgmode"),
  --   },
  -- },

  render_modes = { "n", "c", "t", "v", "V", "\22" },
  -- render_modes = true,
  preset = "none", -- obsidian, lazy, none
  -- The level of logs to write to file: vim.fn.stdpath('state') .. '/render-markdown.log'.
  log_level = "info",
  -- Print runtime of main update method.
  debounce = 50,
  log_runtime = false,
  -- Takes buffer as input, if it returns true this plugin will not attach to the buffer
  -- ignore = function()
  --   return false
  -- end,
  win_options = {
    concealcursor = {
      -- Used when not being rendered, get user setting.
      default = vim.o.concealcursor,
      -- Used when being rendered, show concealed text in all modes.
      rendered = "nvc",
    },
    conceallevel = {
      -- Used when being rendered, show concealed text in all modes.
      rendered = 3,
      -- Used when not being rendered, get user setting.
      default = vim.o.conceallevel or 0,
    },
  },
  overrides = {
    filetype = {
      codecompanion = {
        html = {
          tag = {
            buf = { icon = " ", highlight = "CodeCompanionChatIcon" },
            file = { icon = " ", highlight = "CodeCompanionChatIcon" },
            group = { icon = " ", highlight = "CodeCompanionChatIcon" },
            help = { icon = "󰘥 ", highlight = "CodeCompanionChatIcon" },
            image = { icon = " ", highlight = "CodeCompanionChatIcon" },
            symbols = { icon = " ", highlight = "CodeCompanionChatIcon" },
            tool = { icon = "󰯠 ", highlight = "CodeCompanionChatIcon" },
            url = { icon = "󰌹 ", highlight = "CodeCompanionChatIcon" },
          },
        },
      },
    },

    buftype = {
      -- LSP hovers: hide code block lines, and hide markup even in cursorline
      -- Padding breaks code blocks in hover windows
      nofile = {
        code = {
          left_pad = 0,
          right_pad = 0,
          width = "full",
          -- border = "hide",
          style = "normal",
          highlight = "RenderMarkdownCodeNoFile",
          sign = false,
        },
        win_options = {
          concealcursor = {
            rendered = "nvic",
            default = vim.api.nvim_get_option_value("concealcursor", {}),
          },
        },
      },
    },
  },
  patterns = {
    -- Highlight patterns to disable for filetypes, i.e. lines concealed around code blocks
    markdown = {
      disable = true,
      directives = {
        { id = 17, name = "conceal_lines" },
        { id = 18, name = "conceal_lines" },
      },
    },
  },

  injections = {
    -- Out of the box language injections for known filetypes that allow markdown to be interpreted
    -- in specified locations, see :h treesitter-language-injections. Set enabled to false in order to disable.
    gitcommit = {
      enabled = true,
      query = [[
                ((message) @injection.content
                    (#set! injection.combined)
                    (#set! injection.include-children)
                    (#set! injection.language "markdown"))
            ]],
    },
  },

  file_types = {
    "Avante",
    "codecompanion",
    "copilot-chat",
    "markdown",
    -- "norg",
    -- "org",
    "pandoc",
    "quarto",
    "rmd",
    "vimwiki",
  },
  bullet = {
    enabled = true,
    icons = bullets[1],
    ordered_icons = {},
    left_pad = 0,
    right_pad = 0,
    highlight = "RenderMarkdownBullet",
  },
  html = {
    comment = { text = "󰆈" },
  },
  sign = {
    enabled = false,
  },
  code = {
    -- border = "thin", below = "▀"
    sign = false, -- Turn on / off any sign column related rendering.
    position = "right", -- language icon position
    highlight_language = "Comment", -- hl for language, overrides icon provider value.
    width = "block", -- full/block
    right_pad = 2, -- < 1 is percentage (only for block width)
    left_pad = 2,
    language_pad = 2,
    style = "full",
    min_width = 60,
    below = "", --''─',
    above = "", --''─', '-'' '▀', '󱋰'

    -- -- Determines how the top / bottom of code block are rendered.
    -- -- | none  | do not render a border                               |
    -- -- | thick | use the same highlight as the code body              |
    -- -- | thin  | when lines are empty overlay the above & below icons |
    -- -- | hide  | conceal lines unless language name or icon is added  |
    border = "thin",
    -- -- Determines how code blocks & inline code are rendered.
    -- -- | none     | disables all rendering                                                    |
    -- -- | normal   | highlight group to code blocks & inline code, adds padding to code blocks |
    -- -- | language | language icon to sign column if enabled and icon + name above code blocks |
    -- -- | full     | normal + language                                                         |
    -- style = "full",
    -- language_icon = true,            -- Whether to include the language icon above code blocks.
    -- language_name = true,            -- Whether to include the language name above code blocks.
    -- disable_background = { "diff" }, -- language names to render borders but no background
    -- left_margin = 0,                 -- < 1 is percentage
    -- min_width = 0,                   -- < 1 is percentage (only for block width)
    -- above = "▄",                     -- Used above code blocks for thin border.
    -- below = "▀",                     -- Used below code blocks for thin border.
    -- inline_left = "",                -- Icon to add to the left of inline code.
    -- inline_right = "",               -- Icon to add to the right of inline code.
    -- inline_pad = 0,                  -- Padding to add to the left & right of inline code.
    -- highlight = "RenderMarkdownCode",                  -- hl for code blocks.
    -- highlight_border = "RenderMarkdownCodeBorder",     -- hl for border,   use false to add no highlight.
    -- highlight_fallback = "RenderMarkdownCodeFallback", -- hl for language, used if icon provider does not have a value.
    -- highlight_inline = "RenderMarkdownCodeInline",     -- hl for inline code.
  },
  anti_conceal = {
    enabled = false,
    ignore = {
      --  head_icon, head_background, head_border, code_language, code_background, code_border
      --  dash, bullet, check_icon, check_scope, quote, table_border, callout, link, sign
      bullet = true,
      check_icon = true,
      head_icon = true,
      head_background = true,
      head_border = true,
      code_language = true,
      code_background = true,
      code_border = true,
      sign = true,
    },
  },
  checkbox = {
    enabled = true,
    render_modes = false,
    bullet = false,
    left_pad = 0,
    right_pad = 0,
    scope_priority = nil,

    -- Define custom checkbox states, more involved, not part of the markdown grammar.
    -- The key is for healthcheck and to allow users to change its values, value type below.
    -- | raw             | matched against the raw text of a 'shortcut_link'           |
    -- | rendered        | replaces the 'raw' value when rendering                     |
    -- | highlight       | highlight for the 'rendered' icon                           |
    -- | scope_highlight | optional highlight for item associated with custom checkbox |
    unchecked = {
      -- Replaces '[ ]' of 'task_list_marker_unchecked'.
      -- icon = "󰄱 ",
      icon = " ",
      highlight = "RenderMarkdownUnchecked",
      scope_highlight = nil,
    },
    checked = {
      -- Replaces '[x]' of 'task_list_marker_checked'.

      icon = " ",
      -- icon = "󰱒 ",
      highlight = "RenderMarkdownChecked",
      scope_highlight = nil,
    },
    -- unchecked = { icon = '✘ ' },
    -- checked = { icon = '✔ ' },
    -- custom = { todo = { rendered = '◯ ' }
    -- = "󰗠", "󰰄", "", "", "󰔵", "✔", "", "󰗠",
    -- 󱋬  󱋭  󰄱  󰡖  󰄲  󰄳  󰄴  󱤧  󰄵  󰄶  󰘻  󰘼  󰄷  󰄸
    -- 󰘽  󰘾  󰄹  󰱑  󰱒        󰥪  󰄮  󱅶  󰄗  󰄯  󰄰

    custom = {
      important = {
        raw = "[~]",
        rendered = "󰓎 ",
        highlight = "DiagnosticWarn",
      },
      todo = {
        raw = "[-]",
        rendered = "󰥔 ",
        highlight = "RenderMarkdownTodo",
        scope_highlight = nil,
        -- scope_highlight = "@markup.strikethrough",
      },
    },
  },

  pipe_table = {
    enabled = true, -- Enable pipe table rendering
    preset = "round", -- heavy, round, double, none
    style = "full", -- none, normal, full
    -- cell = "padded", -- overlay, raw, padded, trimmed
    cell = "trimmed", -- overlay, raw, padded, trimmed
    min_width = 0, -- Minimum width of pipe tables
    -- above = "▀", -- Used above pipe tables for thin border.
    -- below = "▀", -- Used below pipe tables for thin border.

    -- border = { '╓', '╥', '╖', '╟', '╫', '╢', '╙', '╨', '╜', '║', '─' },
    -- border = {
    --     '┌', '┬', '┐',
    --     '├', '┼', '┤',
    --     '└', '┴', '┘',
    --     '│', '─',
    -- },
    -- Always use virtual lines for table borders instead of attempting to use empty lines.
    -- Will be automatically enabled if indentation module is enabled.
    border_virtual = false,
    -- Gets placed in delimiter row for each column, position is based on alignment.
    alignment_indicator = "━",
    -- Highlight for table heading, delimiter, and the line above.
    head = "RenderMarkdownTableHead",
    -- Highlight for everything else, main table rows and the line below.
    row = "RenderMarkdownTableRow",
    -- Highlight for inline padding used to add back concealed space.
  },
  indent = {
    -- Mimic org-indent-mode behavior by indenting everything under a heading based on the
    -- level of the heading. Indenting starts from level 2 headings onward by default.
    -- Turn on / off org-indent-mode.
    enabled = false,
    -- Additional modes to render indents.
    render_modes = false,
    -- Amount of additional padding added for each heading level.
    per_level = 2,
    -- Heading levels <= this value will not be indented.
    -- Use 0 to begin indenting from the very first level.
    skip_level = 1,
    -- Do not indent heading titles, only the body.
    skip_heading = true,
    -- Prefix added when indenting, one per level.
    icon = "▎",
    -- Applied to icon.
    highlight = "RenderMarkdownIndent",
  },
  completions = {
    lsp = { enabled = true },
    filter = {
      callout = function()
        -- example to exclude obsidian callouts
        -- return value.category ~= 'obsidian'
        return true
      end,
      checkbox = function()
        return true
      end,
    },
  },
  --   󰼎 󰎡 󰎢 󰎣     󰬺 󰎤 󰼏 󰎥 󰎦 󰲠 󰲡 󰬻 󰎧 󰼐 󰎨 󰎩 󰲢 󰲣 󰬼 󰎪 󰼑 󰎫 󰎬 󰲤 󰲥 󰬽 󰎭 󰼒 󰎲 󰎮 󰲦 󰲧 󰬾 󰎱 󰼓 󰎯 󰎰 󰲨 󰲩
  -- 󰬿 󰎳 󰼔 󰎴 󰎵 󰲪 󰲫 󰭀 󰎶 󰼕 󰎷 󰎸 󰲬 󰲭 󰭁 󰎹 󰼖 󰎺 󰎻 󰲮 󰲯 󰭂 󰎼 󰼗 󰎽 󰎾 󰲰 󰲱 󰿩 󰽽 󰿪 󰿫 󰽾 󰿬 󰿭 󰿮 󰎿 󰼘 󰏀 󰏁 󰲲 󰲳
  heading = {
    -- border = "thin", highlight = "RenderMarkdownCode", highlight_inline = "RenderMarkdownCodeInline", min_width = 30
    border_virtual = true, -- Always use virtual lines for heading borders instead of attempting to use empty lines
    -- | right   | '#'s are concealed and icon is appended to right side                          |
    -- | inline  | '#'s are concealed and icon is inlined on left side                            |
    -- | overlay | icon is left padded with spaces and inserted on left hiding any additional '#' |
    position = "inline", -- inline: icons left aligned, overlay: L
    -- -- Replaces '#+' of 'atx_h._marker': function `value(context)` | string[] `cycle(value, context.level)` |
    -- icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },  { '󰼏 ', '󰎨 ' }
    -- atx = true,             -- Turn on / off atx heading rendering.
    -- setext = true,          -- Turn on / off setext heading rendering.
    -- sign = true,            -- Turn on / off any sign column related rendering.
    -- width = 'block',        -- background width block (only text) or full
    -- min_width = 0,          -- Minimum width to use for headings when width is 'block', can be level integers list
    -- border = false,         -- Determines if a border is added above and below headings
    -- border_prefix = false,  -- Highlight the start of the border using the foreground highlight
    -- above = "▄",            -- Used above heading for border
    -- below = "▀",            -- Used below heading for border
    -- signs = { "󰫎 " },       -- sign column if enabled, can use levels
    -- left_margin = 0,        -- < 1 is percentage, can be levels
    -- left_pad = 0,           -- < 1 is percentage, can be levels
    -- right_pad = 0,          --  < 1 is percentage, can be levels (only when width is block)
    -- backgrounds = { "RenderMarkdownH1Bg", "RenderMarkdownH2Bg", "RenderMarkdownH3Bg", "RenderMarkdownH4Bg", "RenderMarkdownH5Bg", "RenderMarkdownH6Bg", },
    -- foregrounds = { "RenderMarkdownH1", "RenderMarkdownH2", "RenderMarkdownH3", "RenderMarkdownH4", "RenderMarkdownH5", "RenderMarkdownH6", },
  },
  -- on = {
  --   attach = function() end,
  --   initial = function() end,
  --   render = function() end,
  --   clear = function() end,
  -- },
}

require("render-markdown").setup(cfg)

--  '[!NOTE]',     '󰋽 Note',      'RenderMarkdownInfo',    'github'   }
--  '[!TIP]',      '󰌶 Tip',       'RenderMarkdownSuccess', 'github'   }
--  '[!IMPORTANT]','󰅾 Important', 'RenderMarkdownHint',    'github'   }
--  '[!WARNING]',  '󰀪 Warning',   'RenderMarkdownWarn',    'github'   }
--  '[!CAUTION]',  '󰳦 Caution',   'RenderMarkdownError',   'github'   }
--  '[!ABSTRACT]', '󰨸 Abstract',  'RenderMarkdownInfo',    'obsidian' }
--  '[!SUMMARY]',  '󰨸 Summary',   'RenderMarkdownInfo',    'obsidian' }
--  '[!TLDR]',     '󰨸 Tldr',      'RenderMarkdownInfo',    'obsidian' }
--  '[!INFO]',     '󰋽 Info',      'RenderMarkdownInfo',    'obsidian' }
--  '[!TODO]',     '󰗡 Todo',      'RenderMarkdownInfo',    'obsidian' }
--  '[!HINT]',     '󰌶 Hint',      'RenderMarkdownSuccess', 'obsidian' }
--  '[!SUCCESS]',  '󰄬 Success',   'RenderMarkdownSuccess', 'obsidian' }
--  '[!CHECK]',    '󰄬 Check',     'RenderMarkdownSuccess', 'obsidian' }
--  '[!DONE]',     '󰄬 Done',      'RenderMarkdownSuccess', 'obsidian' }
--  '[!QUESTION]', '󰘥 Question',  'RenderMarkdownWarn',    'obsidian' }
--  '[!HELP]',     '󰘥 Help',      'RenderMarkdownWarn',    'obsidian' }
--  '[!FAQ]',      '󰘥 Faq',       'RenderMarkdownWarn',    'obsidian' }
--  '[!ATTENTION]','󰀪 Attention', 'RenderMarkdownWarn',    'obsidian' }
--  '[!FAILURE]',  '󰅖 Failure',   'RenderMarkdownError',   'obsidian' }
--  '[!FAIL]',     '󰅖 Fail',      'RenderMarkdownError',   'obsidian' }
--  '[!MISSING]',  '󰅖 Missing',   'RenderMarkdownError',   'obsidian' }
--  '[!DANGER]',   '󱐌 Danger',    'RenderMarkdownError',   'obsidian' }
--  '[!ERROR]',    '󱐌 Error',     'RenderMarkdownError',   'obsidian' }
--  '[!BUG]',      '󰨰 Bug',       'RenderMarkdownError',   'obsidian' }
--  '[!EXAMPLE]',  '󰉹 Example',   'RenderMarkdownHint' ,   'obsidian' }
--  '[!QUOTE]',    '󱆨 Quote',     'RenderMarkdownQuote',   'obsidian' }
--  '[!CITE]',     '󱆨 Cite',      'RenderMarkdownQuote',   'obsidian' }
--
