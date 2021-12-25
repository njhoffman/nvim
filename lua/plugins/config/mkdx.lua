local H = require "helpers"

vim.cmd("source " .. vim.fn.stdpath "config" .. "/lua/plugins/configs/mkdx.vim")

-- | description                  | modes          | mapping      | Execute                           |                         |
-- | ----                         | ----           | -------      | -------                           |                         |
-- | Prev checkbox state          | normal, visual | [<PREFIX>]-  | `<Plug>(mkdx-checkbox-prev-{n\    | v})`
-- | Next checkbox state          | normal, visual | [<PREFIX>]=  | `<Plug>(mkdx-checkbox-next-{n\    | v})`
-- | Promote header               | normal         | [<PREFIX>][  | `<Plug>(mkdx-promote-header)`     |                         |
-- | Demote header                | normal         | [<PREFIX>]]  | `<Plug>(mkdx-demote-header)`      |                         |
-- | Toggle kbd shortcut          | normal, visual | [<PREFIX>]k  | `<Plug>(mkdx-toggle-to-kbd-{n\    | v})`
-- | Toggle quote                 | normal, visual | [<PREFIX>]'  | `<Plug>(mkdx-toggle-quote-{n\     | v})`
-- | Toggle checkbox item         | normal, visual | [<PREFIX>]t  | `<Plug>(mkdx-toggle-checkbox-{n\  | v})`
-- | Toggle checklist item        | normal, visual | [<PREFIX>]lt | `<Plug>(mkdx-toggle-checklist-{n\ | v})`
-- | Toggle list item             | normal, visual | [<PREFIX>]ll | `<Plug>(mkdx-toggle-list-{n\      | v})`
-- | Wrap link                    | normal, visual | [<PREFIX>]ln | `<Plug>(mkdx-wrap-link-{n\        | v})`
-- | Italicize text               | normal, visual | [<PREFIX>]/  | `<Plug>(mkdx-text-italic-{n\      | v})`
-- | Bolden text                  | normal, visual | [<PREFIX>]b  | `<Plug>(mkdx-text-bold-{n\        | v}))`
-- | Wrap with inline code        | normal, visual | [<PREFIX>]`  | `<Plug>(mkdx-text-inline-code-{n\ | v})`
-- | Wrap with strikethrough      | normal, visual | [<PREFIX>]s  | `<Plug>(mkdx-text-strike-{n\      | v})`
-- | CSV to table                 | visual         | [<PREFIX>]   |                                   | `<Plug>(mkdx-tableize)` |
-- | Jump to header               | normal         | [<PREFIX>]j  | `<Plug>(mkdx-jump-to-header)`     |                         |
-- | Generate / Update TOC        | normal         | [<PREFIX>]i  | `<Plug>(mkdx-gen-or-upd-toc)`     |                         |
-- | Quickfix TOC                 | normal         | [<PREFIX>]I  | `<Plug>(mkdx-quickfix-toc)`       |                         |
-- | Quickfix dead fragment links | normal         | [<PREFIX>]L  | `<Plug>(mkdx-quickfix-links)`     |                         |
-- | o handler                    | normal         | o            | `<Plug>(mkdx-o)`                  |                         |
-- | O handler                    | normal         | O            | `<Plug>(mkdx-shift-o)`            |                         |
-- | Insert fenced code block     | insert         | ```          | `<Plug>(mkdx-fence-backtick)`     |                         |
-- | Insert fenced code block     | insert         | ~~~          | `<Plug>(mkdx-fence-tilde)`        |                         |
-- | Insert kbd shortcut          | insert         | <tab>        | `<Plug>(mkdx-insert-kbd)`         |                         |
-- | enter handler                | insert         | enter        | `<Plug>(mkdx-enter)`              |                         |
-- | shift+enter handler          | insert         | shift+enter  | `<Plug>(mkdx-shift-enter)`        |                         |
-- | ctrl+n handler               | insert         | ctrl+n       | `<Plug>(mkdx-ctrl-n-compl)`       |                         |
-- | ctrl+p handler               | insert         | ctrl+p       | `<Plug>(mkdx-ctrl-p-compl)`       |                         |
-- | # handler                    | insert         | #            | `<Plug>(mkdx-link-compl)`         |                         |
-- | Jump to file                 | normal         | gf           | `<Plug>(mkdx-gf)`                 |                         |
-- | Jump to file                 | visual         | gf           | `<Plug>(mkdx-gf-visual)`          |                         |
-- | Open external file           | normal         | gx           | `<Plug>(mkdx-gx)`                 |                         |
-- | Open external file           | visual         | gx           | `<Plug>(mkdx-gx-visual)`          |                         |

-- | Indent numbered list item   | tab       | `<Plug>(mkdx-indent)`
-- | Unindent numbered list item | shift+tab | `<Plug>(mkdx-unindent)`
-- | Jump to next header         | ]]        | `<Plug>(mkdx-jump-to-next-section)`
-- | Jump to prev header         | [[        | `<Plug>(mkdx-jump-to-prev-section)`
