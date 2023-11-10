-- Only do this when not yet done for this buffer

if vim.b.did_ftplugin then
  return
end

vim.opt.complete:append({ 'kspell' })
vim.g.vim_markdown_conceal = 0
vim.g.vim_markdown_math = 1
vim.g.vim_markdown_frontmatter = 1
vim.g.vim_markdown_toml_frontmatter = 1
vim.g.vim_markdown_json_frontmatter = 1
vim.g.vim_markdown_new_list_item_indent = 2
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
  'javascript',
  'json',
  'lua',
  'python',
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

-- source <sfile>:h/javascript_apathy.vim
