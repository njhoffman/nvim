local cmp = require("cmp")
local compare = require("cmp.config.compare")

-- TODO: Add completion delay
-- TODO: Map C-n to lsp_complete
-- TODO: Prevent word replace unless selected (or map escape)
-- TODO: C-f/C-b when popup on command line
-- TODO: Fix tab/s-tab

if not cmp then
  return
end
--  local after_line = string.sub(line, cursor + 1, -1)
local lsp_symbols = {
  Text = " ",
  Method = " ",
  Function = " ",
  Constructor = " ",
  Field = "ﴲ ",
  Variable = " ",
  Class = " ",
  Interface = "ﰮ ",
  Module = " ",
  Property = "襁 ",
  Unit = " ",
  Value = " ",
  Enum = "練 ",
  Keyword = " ",
  Snippet = " ",
  Color = " ",
  File = " ",
  Reference = " ",
  Folder = " ",
  EnumMember = " ",
  Constant = "ﲀ ",
  Struct = "ﳤ ",
  Event = " ",
  Operator = " ",
  TypeParameter = " "
}

-- TODO: filetype specific spelling
-- vim.opt.spell = true
-- vim.opt.spelllang = { 'en_us' }

vim.opt.dictionary:append("/usr/share/dict/words")

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
  local col = vim.fn.col(".") - 1
  if col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
    return true
  else
    return false
  end
end

cmp.setup(
  {
    -- preselect = cmp.PreselectMode.None,
    completion = {
      completeopt = "menuone,noinsert,noselect"
      -- completeopt = "noselect,menuone,preview"
      -- completeopt = "menu,menuone,noselect"
      -- completeopt = 'menu,menuone,noinsert',
    },
    mapping = {
      -- inoremap <C-x><C-s> <Cmd>lua vimrc.cmp.snippet()<CR>
      ["<C-x><C-o>"] = cmp.mapping.complete(),
      ["<C-x><C-s>"] = cmp.mapping.complete({config = {sources = {{name = "vsnip"}}}}),
      ["<C-n>"] = function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        else
          -- fallback()
          cmp.mapping.complete()
        end
      end,
      ["<C-p>"] = function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        else
          -- fallback()
          cmp.mapping.complete()
        end
      end,
      ["<PageUp>"] = cmp.mapping.scroll_docs(-4),
      ["<PageDown>"] = cmp.mapping.scroll_docs(4),
      ["<c-b>"] = function(fallback)
        for i = 1, 10 do
          cmp.mapping.select_prev_item()(nil)
        end
      end,
      ["<c-f>"] = function(fallback)
        for i = 1, 10 do
          cmp.mapping.select_next_item()(nil)
        end
      end,
      -- ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.abort(),
      ["<Tab>"] = function(fallback)
        if vim.fn.pumvisible() == 1 then
          return t("<C-n>")
        elseif vim.fn.call("vsnip#available", {1}) == 1 then
          return t("<Plug>(vsnip-expand-or-jump)")
        elseif check_back_space() then
          return t("<Tab>")
        else
          return cmp.mapping.complete()
        end
      end,
      ["<S-Tab>"] = function(fallback)
        if vim.fn.pumvisible() == 1 then
          return t("<C-p>")
        elseif vim.fn.call("vsnip#jumpable", {-1}) == 1 then
          return t("<Plug>(vsnip-jump-prev)")
        else
          -- If <S-Tab> is not working in your terminal, change it to <C-h>
          return t("<S-Tab>")
        end
      end
    },
    formatting = {
      --   format = lspkind.cmp_format({
      --     with_text = true,
      --     menu = ({
      format = function(entry, item)
        item.kind = lsp_symbols[item.kind] .. " " .. item.kind
        item.menu =
          ({
          buffer = "[Buffer]",
          calc = "[Calc]",
          cmp_rg = "[RG]",
          cmp_git = "[Git]",
          cmp_tabnine = "[Tab9]",
          dictionary = "[Dictionary]",
          emoji = "[Emoji]",
          look = "[Look]",
          luasnip = "[LuaSnip]",
          npm = "[npm]",
          nvim_lsp = "[LSP]",
          nvim_lua = "[NvimLua]",
          path = "[Path]",
          spell = "[Spell]",
          treesitter = "[treesitter]",
          ["vimwiki-tags"] = "[Vimwiki]",
          vsnip = "[VSnip]",
          ["vim-dadbod-completion"] = "[DB]",
          zsh = "[ZSH]"
        })[entry.source.name]
        return item
      end
    },
    sorting = {
      priority_weight = 2,
      comparators = {
        compare.offset,
        compare.exact,
        compare.score,
        compare.kind,
        compare.sort_text,
        compare.length,
        compare.order
      }
    },
    snippet = {
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
      end
    },
    sources = cmp.config.sources(
      {
        -- { name = "cmp_tabnine" },
        {name = "nvim_lua", priority = 7},
        {name = "nvim_lsp", priority = 8},
        {name = "vim-dadbod-completion", priority = 5},
        {name = "path", priority = 5},
        {name = "vsnip", priority = 4},
        {name = "calc", priority = 4},
        {
          name = "tmux",
          priority = 3,
          options = {
            all_panes = false,
            label = "[tmux]",
            trigger_characters = {"."},
            trigger_characters_ft = {} -- { filetype = { '.' } }
          }
        },
        {name = "spell", priority = 3},
        {name = "cmp_git", priority = 3},
        -- { name = "zsh" },
        {name = "pandoc_references", priority = 3},
        {name = "emoji", priority = 2},
        {name = "treesitter", priority = 1},
        {name = "vimwiki-tags", priority = 1},
        {name = "npm", keyword_length = 1}
        -- { name = "nvim_lua" },
        -- { name = "rg" },
        -- { name = "dictionary", keyword_length = 2, },
        -- { name = "neorg" },
      },
      {
        name = "buffer",
        priority = 1
        -- get_bufnrs = function()
        --   return vim.api.nvim_get_current_buffer()
        --   -- return vim.api.nvim_list_bufs() -- use all buffers
        -- end
      }
    )
  }
)

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline("/", {{{name = "buffer"}}})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {sources = cmp.config.sources({{name = "path"}}, {{name = "cmdline"}})})

require("cmp-npm").setup({ignore = {}, only_semantic_versions = false})

-- cmp-vimwiki-tags
-- I use this shell script to launch Vimwiki. It opens the Vimwiki directory and then immediately opens either the file with the name of the first argument (which will create that file if it does not exist), or the index file in case of no arguments. If you pass more than one argument it will add them as tags to the top of the file.
-- function note_fn() {
--   if [[ "$1" == "" ]]; then
--     cd "$vimwiki_path" && nvim -c "e index.md" .
--   elif [[ "$2" == "" ]]; then
--     cd "$vimwiki_path" && nvim -c "e $1.md" .
--   else
--     tags=":"
--     for tag in "${@:2}"; do
--       tags="$tags$tag:"
--     done
--     cd "$vimwiki_path" && nvim -c "e $1.md | execute 'normal ggO$tags'" .
--   fi
-- }
-- alias note=note_fn

-- In order to show completions defined in your zshrc you can setup cmp zsh like this. Note: This feature is experimental. If you enable it and don't get any results try disabling it.
-- require'cmp_zsh'.setup {
--   zshrc = true -- Source the zshrc (adding all custom completions)
-- }
-- Alternatively you can use this trick (if sourcing your zshrc is very slow): Add the directory of the complete function to $FPATH in ~/.zshenv.
-- # completions
-- if [ -d $HOME/.zsh/comp ]; then
--     export FPATH="$HOME/.zsh/comp:$FPATH"
-- fi

local tabnine = require("cmp_tabnine.config")
tabnine:setup(
  {
    max_lines = 1000,
    max_num_results = 20,
    sort = true,
    run_on_every_keystroke = true,
    snippet_placeholder = ".."
  }
)
-- Setup lspconfig.
-- local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
-- require('lspconfig')[%YOUR_LSP_SERVER%].setup {
--   capabilities = capabilities
-- }

-- vim.cmd([[ autocmd FileType sql,mysql,plsql lua require('cmp').setup.buffer({ sources = {{ name = 'vim-dadbod-completion' }, { name = 'nvim_lsp' } } }) ]])

-- vim.cmd(
--     [[autocmd FileType sql,mysql,pgsql,plsql lua require('cmp').setup.buffer({ sources = {{ name = 'vim-dadbod-completion' }, { name = "nvim_lsp" "}} })]])
-- vim.cmd([[let g:completion_chain_complete_list = { 'sql': [  {'complete_items': ['vim-dadbod-completion']}, ], }]])
-- " Source is automatically added, you just need to include it in the chain complete list
-- let g:completion_chain_complete_list = {
--     \   'sql': [
--     \    {'complete_items': ['vim-dadbod-completion']},
--     \   ],
--     \ }
-- " Make sure `substring` is part of this list. Other items are optional for this completion source
-- let g:completion_matching_strategy_list = ['exact', 'substring']
-- " Useful if there's a lot of camel case items
-- let g:completion_matching_ignore_case = 1

vim.cmd(
  [[
  augroup NvimCmp
  au!
  au FileType TelescopePrompt lua require('cmp').setup.buffer { enabled = false }
  augroup END
]]
)

require("cmp_git").setup(
  {
    -- defaults
    filetypes = {"gitcommit"},
    remotes = {"upstream", "origin"}, -- in order of most to least prioritized
    git = {
      commits = {
        sort_by = function(commit) -- nil, "sha", "title", "description", "author_name", "author_email", "commit_timestamp", or custom function
          return string.format("%010d", commit.diff)
        end,
        limit = 100,
        filter_fn = function(trigger_char, commit)
          return string.format("%s %s %s", trigger_char, commit.sha, commit.title)
        end
      }
    },
    github = {
      issues = {
        filter = "all", -- assigned, created, mentioned, subscribed, all, repos
        limit = 100,
        state = "open", -- open, closed, all
        sort_by = function(issue) -- nil, "number", "title", "body", or custom function
          return string.format("%010d", os.difftime(os.time(), utils.parse_github_date(issue.updatedAt)))
        end,
        filter_fn = function(trigger_char, issue)
          return string.format("%s %s %s", trigger_char, issue.number, issue.title)
        end
      },
      mentions = {
        limit = 100,
        sort_by = nil, -- nil, "login", or custom function
        filter_fn = function(trigger_char, mention)
          return string.format("%s %s %s", trigger_char, mention.username)
        end
      },
      pull_requests = {
        limit = 100,
        state = "open", -- open, closed, merged, all
        sort_by = function(pr) -- nil, "number", "title", "body", or custom function
          return string.format("%010d", os.difftime(os.time(), utils.parse_github_date(pr.updatedAt)))
        end,
        filter_fn = function(trigger_char, pr)
          return string.format("%s %s %s", trigger_char, pr.number, pr.title)
        end
      }
    },
    gitlab = {
      issues = {
        limit = 100,
        state = "opened", -- opened, closed, all
        sort_by = function(issue) -- nil, "iid", "title", "description", or custom function
          return string.format("%010d", os.difftime(os.time(), utils.parse_gitlab_date(issue.updated_at)))
        end,
        filter_fn = function(trigger_char, issue)
          return string.format("%s %s %s", trigger_char, issue.iid, issue.title)
        end
      },
      mentions = {
        limit = 100,
        sort_by = nil, -- nil, "username", "name", or custom function
        filter_fn = function(trigger_char, mention)
          return string.format("%s %s", trigger_char, mention.username)
        end
      },
      merge_requests = {
        limit = 100,
        state = "opened", -- opened, closed, locked, merged
        sort_by = function(mr) -- nil, "iid", "title", "description", or custom function
          return string.format("%010d", os.difftime(os.time(), utils.parse_gitlab_date(mr.updated_at)))
        end,
        filter_fn = function(trigger_char, mr)
          return string.format("%s %s %s", trigger_char, mr.iid, mr.title)
        end
      }
    },
    trigger_actions = {
      {
        debug_name = "git_commits",
        trigger_character = ":",
        action = function(sources, trigger_char, callback, params, git_info)
          return sources.git:get_commits(callback, params, trigger_char)
        end
      },
      {
        debug_name = "gitlab_issues",
        trigger_character = "#",
        action = function(sources, trigger_char, callback, params, git_info)
          return sources.gitlab:get_issues(callback, git_info, trigger_char)
        end
      },
      {
        debug_name = "gitlab_mentions",
        trigger_character = "@",
        action = function(sources, trigger_char, callback, params, git_info)
          return sources.gitlab:get_mentions(callback, git_info, trigger_char)
        end
      },
      {
        debug_name = "gitlab_mrs",
        trigger_character = "!",
        action = function(sources, trigger_char, callback, params, git_info)
          return sources.gitlab:get_merge_requests(callback, git_info, trigger_char)
        end
      },
      {
        debug_name = "github_issues_and_pr",
        trigger_character = "#",
        action = function(sources, trigger_char, callback, params, git_info)
          return sources.github:get_issues_and_prs(callback, git_info, trigger_char)
        end
      },
      {
        debug_name = "github_mentions",
        trigger_character = "@",
        action = function(sources, trigger_char, callback, params, git_info)
          return sources.github:get_mentions(callback, git_info, trigger_char)
        end
      }
    }
  }
)

-- custom behavior: only show if something behind cursor and nothing inf ront
-- autocmd TextChangedI,TextChangedP * call s:on_complete_check()

-- function! s:on_complete_check() abort
-- lua <<EOF
--  local line = vim.api.nvim_get_current_line()
--  local cursor = vim.api.nvim_win_get_cursor(0)[2]

--  local current = string.sub(line, cursor, cursor + 1)
--  if current == "." or current == "," or current == " " then
--     require('cmp').close()
--  end

--  local before_line = string.sub(line, 1, cursor + 1)
--  local after_line = string.sub(line, cursor + 1, -1)
--  if not string.match(before_line, '^%s+$') then
--     if after_line == "" or string.match(before_line, " $") or string.match(before_line, "%.$") then
--         require('cmp').complete()
--     end
--  end
-- EOF
-- endfunction

-- local tabnine = require("cmp_tabnine.config")
-- tabnine:setup(
--   {
--     max_lines = 1000,
--     max_num_results = 20,
--     sort = true,
--     run_on_every_keystroke = true
--   }
-- )
--   mapping = {
--     ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
--     ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
--     ['<Down>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
--     ['<Up>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
--     ['<C-d>'] = cmp.mapping.scroll_docs(-4),
--     ['<C-f>'] = cmp.mapping.scroll_docs(4),
--     ['<C-Space>'] = cmp.mapping.complete(),
--     ['<C-e>'] = cmp.mapping.close(),
--     ['<CR>'] = cmp.mapping.confirm({
--       behavior = cmp.ConfirmBehavior.Replace,
--       select = true,
--     })
--   },
--     -- mapping = {
--     --   ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
--     --   ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
--     --   ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
--     --   ['<C-y>'] = cmp.config.disable, -- If you want to remove the default `<C-y>` mapping, You can specify `cmp.config.disable` value.
--     --   ['<C-e>'] = cmp.mapping({
--     --     i = cmp.mapping.abort(),
--     --     c = cmp.mapping.close(),
--     --   }),
--     --   ['<CR>'] = cmp.mapping.confirm({ select = true }),
--     -- },
--     sources = cmp.config.sources({
--       { name = 'nvim_lsp' },
--       { name = 'vsnip' }, -- For vsnip users.
--       -- { name = 'luasnip' }, -- For luasnip users.
--       -- { name = 'ultisnips' }, -- For ultisnips users.
--       -- { name = 'snippy' }, -- For snippy users.
--     }, {
--       { name = 'buffer' },
--     })
--   })

--   -- Use buffer source for `/`.
--   cmp.setup.cmdline('/', {
--     sources = {
--       { name = 'buffer' }
--     }
--   })

--   -- Use cmdline & path source for ':'.
--   cmp.setup.cmdline(':', {
--     sources = cmp.config.sources({
--       { name = 'path' }
--     }, {
--       { name = 'cmdline' }
--     })
--   })

--   -- Setup lspconfig.
--   -- local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
--   -- require('lspconfig')[%YOUR_LSP_SERVER%].setup {
--   --   capabilities = capabilities
--   -- }
