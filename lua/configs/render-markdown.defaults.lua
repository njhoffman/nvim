local default_cfg = {
  -- Whether markdown should be rendered by default.
  enabled = true,
  -- Vim modes that will show a rendered view of the markdown file, :h mode(), for all enabled
  -- components. Individual components can be enabled for other modes. Remaining modes will be
  -- unaffected by this plugin.
  -- n no nov noV noCTRL- niI niR niV nt ntT
  -- v vs V Vs CTRL-V CTRL-V
  -- s S CTRL-S
  -- i ic ix R Rc Rx Rv Rvc Rvx
  -- c cr cv cvr
  -- r rm r?
  -- t !
  render_modes = { "n", "c", "t" },
  -- Maximum file size (in MB) that this plugin will attempt to render.
  -- Any file larger than this will effectively be ignored.
  max_file_size = 10.0,
  -- Milliseconds that must pass before updating marks, updates occur.
  -- within the context of the visible window, not the entire buffer.
  debounce = 100,
  -- Pre configured settings that will attempt to mimic various target user experiences.
  -- Any user provided settings will take precedence.
  -- | obsidian | mimic Obsidian UI                                          |
  -- | lazy     | will attempt to stay up to date with LazyVim configuration |
  -- | none     | does nothing                                               |
  preset = "none",
  -- The level of logs to write to file: vim.fn.stdpath('state') .. '/render-markdown.log'.
  -- Only intended to be used for plugin development / debugging.
  log_level = "error",
  -- Print runtime of main update method.
  -- Only intended to be used for plugin development / debugging.
  log_runtime = false,
  -- Filetypes this plugin will run on.
  file_types = { "markdown" },
  -- Takes buffer as input, if it returns true this plugin will not attach to the buffer
  ignore = function()
    return false
  end,
  -- Additional events that will trigger this plugin's render loop.
  change_events = {},
  injections = {
    -- Out of the box language injections for known filetypes that allow markdown to be interpreted
    -- in specified locations, see :h treesitter-language-injections.
    -- Set enabled to false in order to disable.

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
  anti_conceal = {
    -- This enables hiding any added text on the line the cursor is on.
    enabled = true,
    -- Which elements to always show, ignoring anti conceal behavior. Values can either be
    -- booleans to fix the behavior or string lists representing modes where anti conceal
    -- behavior will be ignored. Valid values are:
    --   head_icon, head_background, head_border, code_language, code_background, code_border,
    --   dash, bullet, check_icon, check_scope, quote, table_border, callout, link, sign
    ignore = {
      code_background = true,
      sign = true,
    },
    -- Number of lines above cursor to show.
    above = 0,
    -- Number of lines below cursor to show.
    below = 0,
  },
  padding = {
    -- Highlight to use when adding whitespace, should match background.
    highlight = "Normal",
  },
  latex = {
    -- Turn on / off latex rendering.
    enabled = true,
    -- Additional modes to render latex.
    render_modes = false,
    -- Executable used to convert latex formula to rendered unicode.
    converter = "latex2text",
    -- Highlight for latex blocks.
    highlight = "RenderMarkdownMath",
    -- Determines where latex formula is rendered relative to block.
    -- | above | above latex block |
    -- | below | below latex block |
    position = "above",
    -- Number of empty lines above latex blocks.
    top_pad = 0,
    -- Number of empty lines below latex blocks.
    bottom_pad = 0,
  },
  on = {
    -- Called when plugin initially attaches to a buffer.
    attach = function() end,
    -- Called before adding marks to the buffer for the first time.
    initial = function() end,
    -- Called after plugin renders a buffer.
    render = function() end,
    -- Called after plugin clears a buffer.
    clear = function() end,
  },
  completions = {
    -- Settings for blink.cmp completions source
    blink = { enabled = false },
    -- Settings for coq_nvim completions source
    coq = { enabled = false },
    -- Settings for in-process language server completions
    lsp = { enabled = false },
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
  heading = {
    -- Useful context to have when evaluating values.
    -- | level    | the number of '#' in the heading marker         |
    -- | sections | for each level how deeply nested the heading is |

    -- Turn on / off heading icon & background rendering.
    enabled = true,
    -- Additional modes to render headings.
    render_modes = false,
    -- Turn on / off atx heading rendering.
    atx = true,
    -- Turn on / off setext heading rendering.
    setext = true,
    -- Turn on / off any sign column related rendering.
    sign = true,
    -- Replaces '#+' of 'atx_h._marker'.
    -- Output is evaluated depending on the type.
    -- | function | `value(context)`              |
    -- | string[] | `cycle(value, context.level)` |
    icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
    -- Determines how icons fill the available space.
    -- | right   | '#'s are concealed and icon is appended to right side                          |
    -- | inline  | '#'s are concealed and icon is inlined on left side                            |
    -- | overlay | icon is left padded with spaces and inserted on left hiding any additional '#' |
    position = "overlay",
    -- Added to the sign column if enabled.
    -- Output is evaluated by `cycle(value, context.level)`.
    signs = { "󰫎 " },
    -- Width of the heading background.
    -- | block | width of the heading text |
    -- | full  | full width of the window  |
    -- Can also be a list of the above values evaluated by `clamp(value, context.level)`.
    width = "full",
    -- Amount of margin to add to the left of headings.
    -- Margin available space is computed after accounting for padding.
    -- If a float < 1 is provided it is treated as a percentage of available window space.
    -- Can also be a list of numbers evaluated by `clamp(value, context.level)`.
    left_margin = 0,
    -- Amount of padding to add to the left of headings.
    -- Output is evaluated using the same logic as 'left_margin'.
    left_pad = 0,
    -- Amount of padding to add to the right of headings when width is 'block'.
    -- Output is evaluated using the same logic as 'left_margin'.
    right_pad = 0,
    -- Minimum width to use for headings when width is 'block'.
    -- Can also be a list of integers evaluated by `clamp(value, context.level)`.
    min_width = 0,
    -- Determines if a border is added above and below headings.
    -- Can also be a list of booleans evaluated by `clamp(value, context.level)`.
    border = false,
    -- Always use virtual lines for heading borders instead of attempting to use empty lines.
    border_virtual = false,
    -- Highlight the start of the border using the foreground highlight.
    border_prefix = false,
    -- Used above heading for border.
    above = "▄",
    -- Used below heading for border.
    below = "▀",
    -- Highlight for the heading icon and extends through the entire line.
    -- Output is evaluated by `clamp(value, context.level)`.
    backgrounds = {
      "RenderMarkdownH1Bg",
      "RenderMarkdownH2Bg",
      "RenderMarkdownH3Bg",
      "RenderMarkdownH4Bg",
      "RenderMarkdownH5Bg",
      "RenderMarkdownH6Bg",
    },
    -- Highlight for the heading and sign icons.
    -- Output is evaluated using the same logic as 'backgrounds'.
    foregrounds = {
      "RenderMarkdownH1",
      "RenderMarkdownH2",
      "RenderMarkdownH3",
      "RenderMarkdownH4",
      "RenderMarkdownH5",
      "RenderMarkdownH6",
    },
    -- Define custom heading patterns which allow you to override various properties based on
    -- the contents of a heading.
    -- The key is for healthcheck and to allow users to change its values, value type below.
    -- | pattern    | matched against the heading text @see :h lua-patterns |
    -- | icon       | optional override for the icon                        |
    -- | background | optional override for the background                  |
    -- | foreground | optional override for the foreground                  |
    custom = {},
  },
  paragraph = {
    -- Turn on / off paragraph rendering
    enabled = true,
    -- Amount of margin to add to the left of paragraphs
    -- If a floating point value < 1 is provided it is treated as a percentage of the available window space
    left_margin = 0,
    -- Minimum width to use for paragraphs
    min_width = 0,
  },
  code = {
    -- Turn on / off code block & inline code rendering.
    enabled = true,
    -- Additional modes to render code blocks.
    render_modes = false,
    -- Turn on / off any sign column related rendering.
    sign = true,
    -- Determines how code blocks & inline code are rendered.
    -- | none     | disables all rendering                                                    |
    -- | normal   | highlight group to code blocks & inline code, adds padding to code blocks |
    -- | language | language icon to sign column if enabled and icon + name above code blocks |
    -- | full     | normal + language                                                         |
    style = "full",
    -- Determines where language icon is rendered.
    -- | right | right side of code block |
    -- | left  | left side of code block  |
    position = "left",
    -- Amount of padding to add around the language.
    -- If a float < 1 is provided it is treated as a percentage of available window space.
    language_pad = 0,
    -- Whether to include the language icon above code blocks.
    language_icon = true,
    -- Whether to include the language name above code blocks.
    language_name = true,
    -- A list of language names for which background highlighting will be disabled.
    -- Likely because that language has background highlights itself.
    -- Use a boolean to make behavior apply to all languages.
    -- Borders above & below blocks will continue to be rendered.
    disable_background = { "diff" },
    -- Width of the code block background.
    -- | block | width of the code block  |
    -- | full  | full width of the window |
    width = "full",
    -- Amount of margin to add to the left of code blocks.
    -- If a float < 1 is provided it is treated as a percentage of available window space.
    -- Margin available space is computed after accounting for padding.
    left_margin = 0,
    -- Amount of padding to add to the left of code blocks.
    -- If a float < 1 is provided it is treated as a percentage of available window space.
    left_pad = 0,
    -- Amount of padding to add to the right of code blocks when width is 'block'.
    -- If a float < 1 is provided it is treated as a percentage of available window space.
    right_pad = 0,
    -- Minimum width to use for code blocks when width is 'block'.
    min_width = 0,
    -- Determines how the top / bottom of code block are rendered.
    -- | none  | do not render a border                               |
    -- | thick | use the same highlight as the code body              |
    -- | thin  | when lines are empty overlay the above & below icons |
    -- | hide  | conceal lines unless language name or icon is added  |
    border = "hide",
    -- Used above code blocks for thin border.
    above = "▄",
    -- Used below code blocks for thin border.
    below = "▀",
    -- Icon to add to the left of inline code.
    inline_left = "",
    -- Icon to add to the right of inline code.
    inline_right = "",
    -- Padding to add to the left & right of inline code.
    inline_pad = 0,
    -- Highlight for code blocks.
    highlight = "RenderMarkdownCode",
    -- Highlight for language, overrides icon provider value.
    highlight_language = nil,
    -- Highlight for border, use false to add no highlight.
    highlight_border = "RenderMarkdownCodeBorder",
    -- Highlight for language, used if icon provider does not have a value.
    highlight_fallback = "RenderMarkdownCodeFallback",
    -- Highlight for inline code.
    highlight_inline = "RenderMarkdownCodeInline",
  },
  dash = {
    -- Turn on / off thematic break rendering
    enabled = true,
    -- Replaces '---'|'***'|'___'|'* * *' of 'thematic_break'
    -- The icon gets repeated across the window's width
    icon = "─",
    -- Width of the generated line:
    --  <integer>: a hard coded width value
    --  full:      full width of the window
    width = "full",
    -- Highlight for the whole line generated from the icon
    highlight = "RenderMarkdownDash",
  },
  bullet = {
    -- Turn on / off list bullet rendering
    enabled = true,
    -- Replaces '-'|'+'|'*' of 'list_item'
    -- How deeply nested the list is determines the 'level' which is used to index into the list using a cycle
    -- The item number in the list is used to index into the value using a clamp if the value is also a list
    -- If the item is a 'checkbox' a conceal is used to hide the bullet instead
    icons = { "●", "○", "◆", "◇" },
    -- Replaces 'n.'|'n)' of 'list_item'
    -- How deeply nested the list is determines the 'level' which is used to index into the list using a cycle
    -- The item number in the list is used to index into the value using a clamp if the value is also a list
    ordered_icons = {},
    -- Padding to add to the left of bullet point
    left_pad = 0,
    -- Padding to add to the right of bullet point
    right_pad = 0,
    -- Highlight for the bullet icon
    highlight = "RenderMarkdownBullet",
  },
  -- Checkboxes are a special instance of a 'list_item' that start with a 'shortcut_link'
  -- There are two special states for unchecked & checked defined in the markdown grammar
  checkbox = {
    -- Turn on / off checkbox state rendering
    enabled = true,
    -- Determines how icons fill the available space:
    --  inline:  underlying text is concealed resulting in a left aligned icon
    --  overlay: result is left padded with spaces to hide any additional text
    position = "inline",
    unchecked = {
      -- Replaces '[ ]' of 'task_list_marker_unchecked'
      icon = "󰄱 ",
      -- Highlight for the unchecked icon
      highlight = "RenderMarkdownUnchecked",
      -- Highlight for item associated with unchecked checkbox
      scope_highlight = nil,
    },
    checked = {
      -- Replaces '[x]' of 'task_list_marker_checked'
      icon = "󰱒 ",
      -- Highlight for the checked icon
      highlight = "RenderMarkdownChecked",
      -- Highlight for item associated with checked checkbox
      scope_highlight = nil,
    },
    -- Define custom checkbox states, more involved as they are not part of the markdown grammar
    -- As a result this requires neovim >= 0.10.0 since it relies on 'inline' extmarks
    -- Can specify as many additional states as you like following the 'todo' pattern below
    --   The key in this case 'todo' is for healthcheck and to allow users to change its values
    --   'raw':             Matched against the raw text of a 'shortcut_link'
    --   'rendered':        Replaces the 'raw' value when rendering
    --   'highlight':       Highlight for the 'rendered' icon
    --   'scope_highlight': Highlight for item associated with custom checkbox
    custom = {
      todo = {
        raw = "[-]",
        rendered = "󰥔 ",
        highlight = "RenderMarkdownTodo",
        scope_highlight = nil,
      },
    },
  },
  quote = {
    -- Turn on / off block quote & callout rendering
    enabled = true,
    -- Replaces '>' of 'block_quote'
    icon = "▋",
    -- Whether to repeat icon on wrapped lines. Requires neovim >= 0.10. This will obscure text if
    -- not configured correctly with :h 'showbreak', :h 'breakindent' and :h 'breakindentopt'. A
    -- combination of these that is likely to work is showbreak = '  ' (2 spaces), breakindent = true,
    -- breakindentopt = '' (empty string). These values are not validated by this plugin. If you want
    -- to avoid adding these to your main configuration then set them in win_options for this plugin.
    repeat_linebreak = false,
    -- Highlight for the quote icon
    highlight = "RenderMarkdownQuote",
  },
  pipe_table = {
    -- Turn on / off pipe table rendering
    enabled = true,
    -- Pre configured settings largely for setting table border easier
    --  heavy:  use thicker border characters
    --  double: use double line border characters
    --  round:  use round border corners
    --  none:   does nothing
    preset = "none",
    -- Determines how the table as a whole is rendered:
    --  none:   disables all rendering
    --  normal: applies the 'cell' style rendering to each row of the table
    --  full:   normal + a top & bottom line that fill out the table when lengths match
    style = "full",
    -- Determines how individual cells of a table are rendered:
    --  overlay: writes completely over the table, removing conceal behavior and highlights
    --  raw:     replaces only the '|' characters in each row, leaving the cells unmodified
    --  padded:  raw + cells are padded to maximum visual width for each column
    --  trimmed: padded except empty space is subtracted from visual width calculation
    cell = "padded",
    -- Amount of space to put between cell contents and border
    padding = 1,
    -- Minimum column width to use for padded or trimmed cell
    min_width = 0,
        -- Characters used to replace table border
        -- Correspond to top(3), delimiter(3), bottom(3), vertical, & horizontal
        -- stylua: ignore
        border = {
            '┌', '┬', '┐',
            '├', '┼', '┤',
            '└', '┴', '┘',
            '│', '─',
        },
    -- Gets placed in delimiter row for each column, position is based on alignment
    alignment_indicator = "━",
    -- Highlight for table heading, delimiter, and the line above
    head = "RenderMarkdownTableHead",
    -- Highlight for everything else, main table rows and the line below
    row = "RenderMarkdownTableRow",
    -- Highlight for inline padding used to add back concealed space
    filler = "RenderMarkdownTableFill",
  },
  -- Callouts are a special instance of a 'block_quote' that start with a 'shortcut_link'
  -- Can specify as many additional values as you like following the pattern from any below, such as 'note'
  --   The key in this case 'note' is for healthcheck and to allow users to change its values
  --   'raw':        Matched against the raw text of a 'shortcut_link', case insensitive
  --   'rendered':   Replaces the 'raw' value when rendering
  --   'highlight':  Highlight for the 'rendered' text and quote markers
  --   'quote_icon': Optional override for quote.icon value for individual callout
  callout = {
    note = { raw = "[!NOTE]", rendered = "󰋽 Note", highlight = "RenderMarkdownInfo" },
    tip = { raw = "[!TIP]", rendered = "󰌶 Tip", highlight = "RenderMarkdownSuccess" },
    important = {
      raw = "[!IMPORTANT]",
      rendered = "󰅾 Important",
      highlight = "RenderMarkdownHint",
    },
    warning = { raw = "[!WARNING]", rendered = "󰀪 Warning", highlight = "RenderMarkdownWarn" },
    caution = { raw = "[!CAUTION]", rendered = "󰳦 Caution", highlight = "RenderMarkdownError" },
    -- Obsidian: https://help.obsidian.md/Editing+and+formatting/Callouts
    abstract = { raw = "[!ABSTRACT]", rendered = "󰨸 Abstract", highlight = "RenderMarkdownInfo" },
    summary = { raw = "[!SUMMARY]", rendered = "󰨸 Summary", highlight = "RenderMarkdownInfo" },
    tldr = { raw = "[!TLDR]", rendered = "󰨸 Tldr", highlight = "RenderMarkdownInfo" },
    info = { raw = "[!INFO]", rendered = "󰋽 Info", highlight = "RenderMarkdownInfo" },
    todo = { raw = "[!TODO]", rendered = "󰗡 Todo", highlight = "RenderMarkdownInfo" },
    hint = { raw = "[!HINT]", rendered = "󰌶 Hint", highlight = "RenderMarkdownSuccess" },
    success = { raw = "[!SUCCESS]", rendered = "󰄬 Success", highlight = "RenderMarkdownSuccess" },
    check = { raw = "[!CHECK]", rendered = "󰄬 Check", highlight = "RenderMarkdownSuccess" },
    done = { raw = "[!DONE]", rendered = "󰄬 Done", highlight = "RenderMarkdownSuccess" },
    question = { raw = "[!QUESTION]", rendered = "󰘥 Question", highlight = "RenderMarkdownWarn" },
    help = { raw = "[!HELP]", rendered = "󰘥 Help", highlight = "RenderMarkdownWarn" },
    faq = { raw = "[!FAQ]", rendered = "󰘥 Faq", highlight = "RenderMarkdownWarn" },
    attention = {
      raw = "[!ATTENTION]",
      rendered = "󰀪 Attention",
      highlight = "RenderMarkdownWarn",
    },
    failure = { raw = "[!FAILURE]", rendered = "󰅖 Failure", highlight = "RenderMarkdownError" },
    fail = { raw = "[!FAIL]", rendered = "󰅖 Fail", highlight = "RenderMarkdownError" },
    missing = { raw = "[!MISSING]", rendered = "󰅖 Missing", highlight = "RenderMarkdownError" },
    danger = { raw = "[!DANGER]", rendered = "󱐌 Danger", highlight = "RenderMarkdownError" },
    error = { raw = "[!ERROR]", rendered = "󱐌 Error", highlight = "RenderMarkdownError" },
    bug = { raw = "[!BUG]", rendered = "󰨰 Bug", highlight = "RenderMarkdownError" },
    example = { raw = "[!EXAMPLE]", rendered = "󰉹 Example", highlight = "RenderMarkdownHint" },
    quote = { raw = "[!QUOTE]", rendered = "󱆨 Quote", highlight = "RenderMarkdownQuote" },
    cite = { raw = "[!CITE]", rendered = "󱆨 Cite", highlight = "RenderMarkdownQuote" },
  },
  link = {
    -- Turn on / off inline link icon rendering
    enabled = true,
    -- Inlined with 'image' elements
    image = "󰥶 ",
    -- Inlined with 'email_autolink' elements
    email = "󰀓 ",
    -- Fallback icon for 'inline_link' elements
    hyperlink = "󰌹 ",
    -- Applies to the fallback inlined icon
    highlight = "RenderMarkdownLink",
    -- Applies to WikiLink elements
    wiki = { icon = "󱗖 ", highlight = "RenderMarkdownWikiLink" },
    -- Define custom destination patterns so icons can quickly inform you of what a link
    -- contains. Applies to 'inline_link' and wikilink nodes.
    -- Can specify as many additional values as you like following the 'web' pattern below
    --   The key in this case 'web' is for healthcheck and to allow users to change its values
    --   'pattern':   Matched against the destination text see :h lua-pattern
    --   'icon':      Gets inlined before the link text
    --   'highlight': Highlight for the 'icon'
    custom = {
      web = { pattern = "^http[s]?://", icon = "󰖟 ", highlight = "RenderMarkdownLink" },
    },
  },
  sign = {
    -- Turn on / off sign rendering
    enabled = true,
    -- Applies to background of sign text
    highlight = "RenderMarkdownSign",
  },
  -- Mimic org-indent-mode behavior by indenting everything under a heading based on the
  -- level of the heading. Indenting starts from level 2 headings onward.
  indent = {
    -- Turn on / off org-indent-mode
    enabled = false,
    -- Amount of additional padding added for each heading level
    per_level = 2,
    -- Heading levels <= this value will not be indented
    -- Use 0 to begin indenting from the very first level
    skip_level = 1,
    -- Do not indent heading titles, only the body
    skip_heading = false,
  },
  -- Window options to use that change between rendered and raw view
  win_options = {
    -- See :h 'conceallevel'
    conceallevel = {
      -- Used when not being rendered, get user setting
      default = vim.api.nvim_get_option_value("conceallevel", {}),
      -- Used when being rendered, concealed text is completely hidden
      rendered = 3,
    },
    -- See :h 'concealcursor'
    concealcursor = {
      -- Used when not being rendered, get user setting
      default = vim.api.nvim_get_option_value("concealcursor", {}),
      -- Used when being rendered, disable concealing text in all modes
      rendered = "",
    },
  },
  -- More granular configuration mechanism, allows different aspects of buffers
  -- to have their own behavior. Values default to the top level configuration
  -- if no override is provided. Supports the following fields:
  --   enabled, max_file_size, debounce, render_modes, anti_conceal, padding,
  --   heading, paragraph, code, dash, bullet, checkbox, quote, pipe_table,
  --   callout, link, sign, indent, win_options
  overrides = {
    -- Overrides for different buftypes, see :h 'buftype'
    buftype = {
      nofile = {
        padding = { highlight = "NormalFloat" },
        sign = { enabled = false },
      },
    },
    -- Overrides for different filetypes, see :h 'filetype'
    filetype = {},
  },
  -- Mapping from treesitter language to user defined handlers
  -- See 'Custom Handlers' document for more info
  custom_handlers = {},
}
