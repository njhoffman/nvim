local config = {
  -- Enable/disable animations
  animation = true,

  -- Enable/disable auto-hiding the tab bar when there is a single buffer
  auto_hide = false,

  -- Enable/disable current/total tabpages indicator (top right corner)
  tabpages = true,

  -- Enable/disable close button
  closable = true,

  -- Enables/disable clickable tabs
  --  - left-click: go to buffer
  --  - middle-click: delete buffer
  clickable = true,

  -- Excludes buffers from the tabline
  -- exclude_ft = { 'javascript' },
  -- exclude_name = { 'package.json' },

  -- Enable/disable icons
  -- if set to 'numbers', will show buffer index in the tabline
  -- if set to 'both', will show buffer index and icons in the tabline
  icons = true,

  -- If set, the icon color will follow its corresponding buffer
  -- highlight group. By default, the Buffer*Icon group is linked to the
  -- Buffer* group (see Highlighting below). Otherwise, it will take its
  -- default value as defined by devicons.
  icon_custom_colors = false,

  -- Configure icons on the bufferline.
  icon_separator_active = '▎',
  icon_separator_inactive = '▎',
  icon_close_tab = '',
  icon_close_tab_modified = '●',
  icon_pinned = '車',

  -- If true, new buffers will be inserted at the start/end of the list.
  -- Default is to insert after current buffer.
  insert_at_end = false,
  insert_at_start = false,

  -- Sets the maximum padding width with which to surround each tab
  maximum_padding = 1,

  -- Sets the maximum buffer name length.
  maximum_length = 30,

  -- If set, the letters for each buffer in buffer-pick mode will be
  -- assigned based on their name. Otherwise or in case all letters are
  -- already assigned, the behavior is to assign letters in order of
  -- usability (see order below)
  semantic_letters = true,

  -- New buffer letters are assigned in this order. This order is
  -- optimal for the qwerty keyboard layout but might need adjustement
  -- for other layouts.
  letters = 'asdfjkl;ghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP',

  -- Sets the name of unnamed buffers. By default format is "[Buffer X]"
  -- where X is the buffer number. But only a static string is accepted here.
  no_name_title = nil,

  -- exclude_ft
  --   `string[]`  (default: `{}`)
  --   Excludes filetypes from appearing in the tabs.
  --
  --                                                    *barbar-setup.exclude_name*
  -- exclude_name
  --   `string[]`  (default: `{}`)
  --   Excludes buffers matching name from appearing in the tabs.
  --
  --                                                  *barbar-setup.focus_on_close*
  -- focus_on_close
  --   `'left'|'previous'|'right'`  (default: `'left'`)
  --   The algorithm to use for getting the next buffer after closing the current
  --   one:
  --
  --   - `'left'`: focus the buffer to the left of the current buffer.
  --   - `'previous'`: focus the previous buffer.
  --   - `'right'`: focus the buffer to the right of the current buffer.
  --
  --                                                            *barbar-setup.hide*
  -- hide
  --   Sets which elements are hidden in the bufferline. Possible options are:
  --
  --                                                  *barbar-setup.hide.alternate*
  --   hide.alternate
  --     `boolean`  (default: `false`)
  --     Controls the visibility of the |alternate-file|.
  --     |barbar-setup.highlight_alternate| must be `true`.
  --
  --                                                    *barbar-setup.hide.current*
  --   hide.current
  --     `boolean`  (default: `false`)
  --     Controls the visibility of the current buffer.
  --
  --                                                 *barbar-setup.hide.extensions*
  --   hide.extensions
  --     `boolean`  (default: `false`)
  --     Controls the visibility of file extensions.
  --
  --                                                   *barbar-setup.hide.inactive*
  --   hide.inactive
  --     `boolean`  (default: `false`)
  --     Controls visibility of |hidden-buffer|s and |inactive-buffer|s.
  --
  --                                                    *barbar-setup.hide.visible*
  --   hide.visible
  --     `boolean`  (default: `false`)
  --     Controls visibility of |active-buffer|s.
  --     |barbar-setup.highlight_visible| must be `true`.
  --
  --                                             *barbar-setup.highlight_alternate*
  -- highlight_alternate
  --   `boolean`  (default: `false`)
  --   Enables highlighting of alternate buffers.
  --
  --                                   *barbar-setup.highlight_inactive_file_icons*
  -- highlight_inactive_file_icons
  --   `boolean`  (default: `false`)
  --   Enables highlighting the file icons of inactive buffers.
  --
  --                                               *barbar-setup.highlight_visible*
  -- highlight_visible
  --   `boolean`  (default: `true`)
  --   Enables highlighting of visible buffers.
  --
  --                                                           *barbar-setup.icons*
  -- icons
  --   `table`
  --   Controls the icons rendered on each tab. The base options are:
  --
  --                                              *barbar-setup.icons.buffer_index*
  --   icons.buffer_index
  --     `boolean|'superscript'|'subscript'`  (default: `false`)
  --     if `true`, show the index of the buffer with respect to the ordering of
  --     the buffers in the tabline.
  --
  --                                             *barbar-setup.icons.buffer_number*
  --   icons.buffer_number
  --     `boolean|'superscript'|'subscript'`  (default: `false`)
  --     If `true`, show the `bufnr` for the associated buffer.
  --
  --                                                    *barbar-setup.icons.button*
  --   icons.button
  --     `false | string`  (default: `''`)
  --     The button which is clicked to close / save a buffer, or indicate that
  --     it is pinned. Use `false` to disable it.
  --
  --                                               *barbar-setup.icons.diagnostics*
  --   icons.diagnostics
  --     `{[vim.diagnostic.severity]: table}`
  --
  --                                       *barbar-setup.icons.diagnostics.enabled*
  --      icons.diagnostics.enabled
  --        `boolean`  (default: `false`)
  --        Enable showing diagnostics of this |diagnostic-severity| in the
  --        'tabline'.
  --
  --                                       *barbar-setup.icons.diagnostics.icon*
  --      icons.diagnostics.icon
  --        `boolean`  (defaults: `' '`, `'󰌶 '`, `' '`, and `' '`)
  --        The icon which accompanies the number of diagnostics.
  --
  --     Example that disables the error icon, but still shows the count:
  --       require'barbar'.setup {icons = {diagnostics = {
  --           [vim.diagnostic.severity.ERROR] = {enabled = true, icon = ''},
  --       }}}
  --
  --                                                  *barbar-setup.icons.gitsigns*
  --   icons.gitsigns
  --     `table`  (default:
  --                     {
  --                       added = {enabled = false, icon = '+'},
  --                       changed = {enabled = false, icon = '~'},
  --                       deleted = {enabled = false, icon = '-'},
  --                     }
  --             )
  --
  --                                          *barbar-setup.icons.gitsigns.enabled*
  --     icons.gitsigns.enabled
  --       `boolean`  (default: `true`)
  --       Enables showing git changes of this type.
  --       Requires |gitsigns.nvim|.
  --
  --                                             *barbar-setup.icons.gitsigns.icon*
  --     icons.gitsigns.icon
  --       `boolean`  (default: `'+'`, `'-'`, `'~'`)
  --        The icon which accompanies the number of git status.
  --
  --     Example that disables the "added" icon, but still shows the count:
  --       require'barbar'.setup {icons = {git = {
  --         added = {enabled = true, icon = ''},
  --       }}}
  --
  --                                                  *barbar-setup.icons.filename*
  --   icons.filename
  --     `boolean`  (default: `true`)
  --     If `true`, show the name of the file.
  --
  --                                    *barbar-setup.icons.filetype.custom_colors*
  --   icons.filetype.custom_colors
  --     `boolean`  (default: `false`)
  --     If `true`, the `Buffer<status>Icon` color will be used for icon colors.
  --
  --                                          *barbar-setup.icons.filetype.enabled*
  --   icons.filetype.enabled
  --     `boolean`  (default: `true`)
  --     Filetype `true`, show the `devicons` for the associated buffer's
  --     `filetype`.
  --
  --                                            *barbar-setup.icons.separator.left*
  --   icons.separator.left
  --     `string`  (default: `'▎'`)
  --     The left separator between buffers in the tabline.
  --
  --                                           *barbar-setup.icons.separator.right*
  --   icons.separator.right
  --     `string`  (default: `''`)
  --     The right separator between buffers in the tabline.
  --
  --   Example:
  --     -- Show the file icon, a left separator, and ERROR/WARN diagnostics
  --     require'barbar'.setup {icons = {
  --       buffer_index = false,
  --       buffer_number = false,
  --       button = '',
  --       diagnostics = {{enabled = true}, {enabled = true}},
  --       filetype = {enabled = true},
  --       separator = {left = '▎'},
  --     }}
  --
  --
  --   You can also customize icons of 'modified' and pinned buffers:
  --                                            *barbar-setup.icons.separator_at_end*
  --   icons.separator_at_end
  --     `boolean`  (default: `true`)
  --     If true, add an additional separator at the end of the buffer list.
  --     Can be used to create a visual separation when the inactive buffer
  --     background color is the same as the fill region background color.
  --
  --                                                  *barbar-setup.icons.modified*
  --   icons.modified
  --     `table`  (default: `{button = '●'}`)
  --     The icons which should be used for a 'modified' buffer.
  --     Supports all the base options (e.g. `buffer_index`, `filetype.enabled`,
  --     etc)
  --
  --                                                    *barbar-setup.icons.pinned*
  --   icons.pinned
  --     `table`  (default:
  --                     {
  --                       button = false,
  --                       filename = false,
  --                       separator = {right = ' '},
  --                     }
  --             )
  --     The icons which should be used for a pinned buffer.
  --     Supports all the base options (e.g. `buffer_index`, `filetype.enabled`,
  --     etc)
  --
  --   Example:
  --     require'barbar'.setup {icons = {
  --       modified = {separator = '⋄'},
  --       pinned = {button = '', filename = true},
  --     }}
  --
  --
  --   You can also customize icons based on the visibility of a buffer:
  --
  --                                                 *barbar-setup.icons.alternate*
  --   icons.alternate
  --     `table`
  --     The icons which should be used for the |alternate-file|.
  --     Supports all the base options (e.g. `buffer_index`, `filetype.enabled`,
  --     etc) as well as `modified` and `pinned`.
  --
  --                                                   *barbar-setup.icons.current*
  --   icons.current
  --     `table`
  --     The icons which should be used for current buffer.
  --     Supports all the base options (e.g. `buffer_index`, `filetype.enabled`,
  --     etc) as well as `modified` and `pinned`.
  --
  --                                                  *barbar-setup.icons.inactive*
  --   icons.inactive
  --     `table`  (default: `{separator = {left = '▎', right = ''}}`)
  --     The icons which should be used for |hidden-buffer|s and |inactive-buffer|s.
  --     Supports all the base options (e.g. `buffer_index`, `filetype.enabled`,
  --     etc) as well as `modified` and `pinned`.
  --
  --                                                   *barbar-setup.icons.visible*
  --   icons.visible
  --     `table`
  --     The icons which should be used for |active-buffer|s.
  --     Supports all the base options (e.g. `buffer_index`, `filetype.enabled`,
  --     etc) as well as `modified` and `pinned`.
  --
  --   Example:
  --     -- Enable file icons for alternate buffers.
  --     -- Enable buffer indices for current buffers.
  --     -- Override the button for inactive buffers.
  --     -- Disable buffer numbers for visible, modified buffers.
  --     require'barbar'.setup {icons = {
  --       alternate = {filetype = {enabled = false}},
  --       current = {buffer_index = true},
  --       inactive = {button = '×'},
  --       visible = {modified = {buffer_number = false}},
  --     }}
  --
  --   icons.preset
  --     `'default'|'powerline'|'slanted'`  (default: `'default'`)
  --     Base all |barbar-setup.icons| configuration off of this set of defaults.
  --
  --     - `'default'`: the classic |barbar.nvim| look.
  --     - `'powerline'`: like <https://github.com/powerline/powerline>
  --     - `'slanted'`: like old Google Chrome tabs
  --
  --                                                 *barbar-setup.insert_at_start*
  -- insert_at_start
  --   `boolean`  (default: `false`)
  --   If `true`, new buffers appear at the start of the list. Default is to open
  --   after the current buffer.
  --
  --   Has priority over |barbar-setup.insert_at_end|
  --
  --                                                   *barbar-setup.insert_at_end*
  -- insert_at_end
  --   `boolean`   (default: `false`)
  --   If `true`, new buffers appear at the end of the list. Default is to open
  --   after the current buffer.
  --
  --                                                         *barbar-setup.letters*
  -- letters
  --   `string`  (default: `'asdfjkl;ghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP'`)
  --   New buffer letters are assigned in this order.
  --
  --   This order is optimal for the QWERTY keyboard layout but might need
  --   adjustment for other layouts.
  --
  --                                                 *barbar-setup.maximum_padding*
  -- maximum_padding
  --   `int`  (default: `4`)
  --   Sets the maximum padding width with which to surround each tab.
  --
  --                                                  *barbar-setup.maximum_length*
  -- maximum_length
  --   `int`  (default: 30)
  --   Sets the maximum buffer name length.
  --
  --                                                  *barbar-setup.minimum_length*
  -- minimum_length
  --   `int`  (default: 0)
  --   Sets the minimum buffer name length.
  --
  --                                                 *barbar-setup.minimum_padding*
  -- minimum_padding
  --   `int`  (default: `1`)
  --   Sets the minimum padding width with which to surround each tab.
  --
  --                                                   *barbar-setup.no_name_title*
  -- no_name_title
  --   `string`  (default: `nil`)
  --   Sets the name of unnamed buffers.
  --
  --   By default format is `'[Buffer X]'` where `X` is the buffer number. However,
  --   only a static string is accepted here.
  --
  --                                                *barbar-setup.semantic_letters*
  -- semantic_letters
  --   `boolean`  (default: `true`)
  --   If `true`, the letters for each buffer in buffer-pick mode will be
  --   assigned based on their name.
  --
  --   Otherwise (or in case all letters are already assigned), the behavior is to
  --   assign letters in the order of provided to |barbar-setup.letters|.
  --
  --                                               *barbar-setup.sidebar_filetypes*
  -- sidebar_filetypes
  --   `{[string]: true|table}`  (default `{}`)
  --   Control which 'filetype's will cause barbar to add an offset.
  --
  --                                         *barbar-setup.sidebar_filetypes.event*
  --   sidebar_filetypes.event
  --     `string`  (default: `'BufWinLeave'`)
  --     The |{event}| which is |autocmd-execute|d when the sidebar closes.
  --
  --                                          *barbar-setup.sidebar_filetypes.text*
  --   sidebar_filetypes.text
  --     `string`  (default: `nil`)
  --     The text which will fill the offset.
}

require('barbar').setup({ auto_hide = true })

-- mini.sessions
--  vim.opt.sessionoptions:append 'globals'
--  require'mini.sessions'.setup {
--    hooks = {
--      pre = {
--        write = function() vim.api.nvim_exec_autocmds('User', {pattern = 'SessionSavePre'}) end,
--      },
--    },
--  }
--

vim.opt.sessionoptions:append('globals')
vim.api.nvim_create_user_command('Mksession', function(attr)
  vim.api.nvim_exec_autocmds('User', { pattern = 'SessionSavePre' })

  -- Neovim 0.8<=
  vim.cmd.mksession({ bang = attr.bang, args = attr.fargs })

  -- Neovim 0.7>=
  vim.api.nvim_command('mksession ' .. (attr.bang and '!' or '') .. attr.args)
end, { bang = true, complete = 'file', nargs = '?' })
