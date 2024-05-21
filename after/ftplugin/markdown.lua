local init_globals = function()
  -- vim.opt.complete:append({ 'kspell' })
  vim.g.vim_markdown_conceal = 3
  vim.g.vim_markdown_math = 1
  vim.g.vim_markdown_frontmatter = 1
  vim.g.vim_markdown_toml_frontmatter = 1
  vim.g.vim_markdown_json_frontmatter = 1
  vim.g.vim_markdown_new_list_item_indent = 2
  vim.g.vim_markdown_folding_level = 1
  vim.g.vim_markdown_toc_autofit = 1

  -- Fix markdown indentation settings
  vim.g.markdown_recommended_style = 0

  vim.g.markdown_fenced_languages = {
    'awk',
    'bash=sh',
    'c',
    'c++=cpp',
    'cpp',
    'css',
    'go',
    'html',
    'ini=dosini',
    'java',
    'javascript',
    'json',
    'kotlin',
    'lua',
    'python',
    'python3=python',
    'pycon=python',
    'pycon3=python',
    'ruby',
    'rust',
    'sh',
    'shell=sh',
    'sql',
    'terraform',
    'ts=typescript',
    'vim',
    'viml=vim',
    'xml',
    'yaml',
    'zsh',
  }
end

local init_headers = function()
  -- three configurations to cycle:
  --   ft: markdown  syn: markdown  bullets
  --   ft: markdown  syn: pandoc    no-bullets
  --   ft: pandoc    syn: pandoc    no-bullets
  local bufnr = vim.api.nvim_get_current_buf()
  local curr_ft = vim.api.nvim_get_option_value('filetype', { buf = bufnr })
  local curr_syn = vim.api.nvim_get_option_value('syntax', { buf = bufnr })
  -- or vim.api.nvim_get_option_value('filetype', { buf = bufnr })
  if curr_ft == 'pandoc' then
    require('headlines').setup({ markdown = { bullets = { '◉', '○', '✸', '✿' } } })
    vim.api.nvim_set_option_value('filetype', 'markdown', { buf = bufnr })
  else
    require('headlines').setup({ markdown = { bullets = {} } })
    if curr_syn == 'markdown' or curr_syn == '' then
      vim.api.nvim_set_option_value('syntax', 'pandoc', { buf = bufnr })
    else
      vim.api.nvim_set_option_value('filetype', 'pandoc', { buf = bufnr })
    end
  end
end

local init_options = function()
  local ts_ctx = require('treesitter-context')
  ts_ctx.disable()
  local winnr = vim.api.nvim_get_current_win()
  vim.api.nvim_set_option_value('conceallevel', 3, { win = winnr })
end

local toggle_headers = function()
  init_headers()
  init_options()
end

if type(vim.g.markdown_fenced_languages) ~= 'table' then
  init_globals()
end

if vim.b.markdown_init ~= 1 then
  local bufnr = vim.api.nvim_get_current_buf()
  vim.keymap.set(
    'n',
    '<M-^>',
    toggle_headers,
    { desc = 'toggle between markdown bullets/flat headers', buffer = bufnr }
  )

  toggle_headers()
  vim.api.nvim_buf_set_var(bufnr, 'markdown_init', 1)
end

-- local toggle_todo = function()
--   local linenr = vim.api.nvim_win_get_cursor(0)[1]
--   local curline = vim.api.nvim_buf_get_lines(0, linenr - 1, linenr, false)[1]
--
--   if string.find(curline, "%- %[ ]") then
--     vim.cmd('s/\\v-\\s\\[\\s\\]/- [x]')
--     vim.cmd('nohlsearch')
--   elseif string.find(curline, "%- %[x]") then
--     vim.cmd('s/\\v-\\s\\[x\\]/- [ ]')
--     vim.cmd('nohlsearch')
--   end
-- end
--
-- vim.keymap.set('n', '<C-SPACE>', toggle_todo, { buffer = true })
-- vim.keymap.set('i', '<C-t>t', '**<C-R>=strftime("%H:%M")<CR>** ', { buffer = true })
-- vim.keymap.set('i', '<C-t>d', '**<C-R>=strftime("%Y-%m-%d")<CR>** ', { buffer = true })
-- -- follow markdown links
-- keymap('n', '<CR>', ':lua FollowMarkdownLink()<CR>', opts)
-- -- go backwards
-- keymap('n', '<BS>', '<C-o>', opts)
-- -- align tables using Tabular
-- keymap('n', '<leader>a', ':Tabularize /|<CR>', opts)
--
-- -- functions
-- function FollowMarkdownLink()
--   -- get text of current line
--   local txt = vim.api.nvim_get_current_line()
--   -- get markdown link
--   local link = txt:match("%[.*%]%((.*)%)")
--
--   if link ~= nil then
--     -- if the link exists, get current buffer filepath and append markdown link
--     local buf = vim.api.nvim_exec("echo expand('%:p:h').\"/" .. link .. "\"", true)
--     -- check if link has markdown extension
--     local hasExt = string.sub(buf, -2) == 'md'
--     if not hasExt then
--       buf = buf .. '.md'
--     end
--     -- go to that buffer
--     vim.api.nvim_command("edit " .. buf)
--   else
--     print('link doesn\'t exist')
--   end
-- end
-- source <sfile>:h/javascript_apathy.vim
-- local keymap = vim.keymap.set
-- local optl = vim.opt_local
-- local u = require("config.utils")
-- local fn = vim.fn
-- --------------------------------------------------------------------------------
--
-- optl.expandtab = false
-- optl.tabstop = 4 -- less nesting in md
--
-- -- so two trailing spaces highlighted, but not a single trailing space
-- optl.listchars:remove { "trail" }
-- optl.listchars:append { multispace = "·" }
--
-- -- since markdown has rarely indented lines, and also rarely overlength in lines,
-- -- move everything a bit more to the right
-- if vim.bo.buftype == "" then optl.signcolumn = "yes:3" end
--
-- --------------------------------------------------------------------------------
-- -- MARKDOWN-SPECIFIC KEYMAPS
-- keymap("n", "<leader>x", "mzI- [ ] <Esc>`z", { desc = " Add Task", buffer = true })
-- keymap("n", "<D-4>", "mzI- <Esc>`z", { desc = " Add List", buffer = true })
--
-- -- Format Table
-- keymap(
--   "n",
--   "<localleader>f",
--   "vip:!pandoc -t commonmark_x<CR><CR>",
--   { desc = " Format Table under Cursor", buffer = true }
-- )
--
-- -- convert md image to html image
-- keymap("n", "<localleader>i", function()
--   local line = vim.api.nvim_get_current_line()
--   local htmlImage = line:gsub("!%[(.-)%]%((.-)%)", '<img src="%2" alt="%1" width=70%%>')
--   vim.api.nvim_set_current_line(htmlImage)
-- end, { desc = "  MD image to <img>", buffer = true })
--
-- -- searchlink / ddgr
-- keymap({ "n", "x" }, "<localleader>k", function()
--   local query
--   if fn.mode() == "n" then
--     u.normal([["zciw]])
--   else
--     u.normal([["zc]])
--   end
--   query = fn.getreg("z")
--   local jsonResponse = fn.system(("ddgr --num=1 --json '%s'"):format(query))
--   local link = vim.json.decode(jsonResponse)[1].url
--   local mdlink = ("[%s](%s)"):format(query, link)
--   fn.setreg("z", mdlink)
--   u.normal([["zP]])
-- end, { desc = " SearchLink (ddgr)", buffer = true })
--
-- --------------------------------------------------------------------------------
-- -- GUI KEYBINDINGS
--
-- -- cmd+u: markdown link
-- keymap("n", "<D-u>", "mzI- <Esc>`z", { desc = " Bullet List", buffer = true })
--
-- -- cmd+k: markdown link
-- keymap("n", "<D-k>", "bi[<Esc>ea]()<Esc>hp", { desc = "  Link", buffer = true })
-- keymap("x", "<D-k>", "<Esc>`<i[<Esc>`>la]()<Esc>hp", { desc = "  Link", buffer = true })
-- keymap("i", "<D-k>", "[]()<Left><Left><Left>", { desc = "  Link", buffer = true })
--
-- -- cmd+b: bold
-- keymap("n", "<D-b>", "bi__<Esc>ea**<Esc>", { desc = "  Bold", buffer = true })
-- keymap("x", "<D-b>", "<Esc>`<i**<Esc>`>lla**<Esc>", { desc = "  Bold", buffer = true })
-- keymap("i", "<D-b>", "****<Left><Left>", { desc = "  Bold", buffer = true })
--
-- -- cmd+i: italics
-- keymap("n", "<D-i>", "bi*<Esc>ea*<Esc>", { desc = "  Italics", buffer = true })
-- keymap("x", "<D-i>", "<Esc>`<i*<Esc>`>la*<Esc>", { desc = "  Italics", buffer = true })
-- keymap("i", "<D-i>", "**<Left>", { desc = "  Italics", buffer = true })
