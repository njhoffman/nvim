local help = require('devbox.handlers.help')
local man = require('devbox.handlers.man')
local dict = require('devbox.handlers.dict')
local syntax = require('devbox.handlers.syntax')
-- local lsp = require('devbox.handlers.lsp')
-- local devboxgh = require("devhints.devbox-gh")

local term_handler = function(expr)
  return function(done, provider)
    local content = vim.fn.expand('<' .. expr .. '>')
    local summary = expr .. ' ' .. content
    done(provider, {
      summary = summary,
      content = content,
      name = provider.name,
      hl = 'Function',
    })
  end
end

local providers = {
  { 'cword', term_handler('cword') },
  { 'cexpr', term_handler('cexpr') },
  { 'cfile', term_handler('cfile') },
  { 'cWORD', term_handler('cWORD') },
  { 'syn', syntax.handler },
  -- { 'hover', lsp.method('textDocument/hover') },
  -- { 'man', man.handler },
  -- { 'help', help.handler },
  -- { "help", dict.handler },
  --   -- { "signature", "textDocument/signatureHelp" },
  --   -- { "definition", "textDocument/definition" },
  --   -- { "references", "textDocument/references" },
  --   -- { "completion", "textDocument/completion" },
  --   -- { "codeaction", "textDocument/codeAction" },
  --   -- semanticTokens,executeCommand,typeDefinition,
}
return providers
