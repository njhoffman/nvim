local help = require("devbox.handlers.help")
local man = require("devbox.handlers.man")
local dict = require("devbox.handlers.dict")
-- local devboxgh = require("devhints.devbox-gh")

local term_handler = function(name)
  return function(start_time)
    local results = vim.fn.expand("<" .. name .. ">")
    local load_time = vim.fn.reltimestr(vim.fn.reltime(start_time))
    local line = load_time .. " " .. name .. " " .. results
    return { summary = line, hl = "Function" }
  end
end

local ext_methods = {
  { "cword", term_handler("cword") },
  { "cexpr", term_handler("cexpr") },
  { "cfile", term_handler("cfile") },
  { "cWORD", term_handler("cWORD") },
  { "man", man.handler },
  { "help", help.handler },
  -- { "help", dict.handler },
}

local lsp_methods = {
  { "hover", "textDocument/hover" },
  { "signature", "textDocument/signatureHelp" },
  { "definition", "textDocument/definition" },
  { "references", "textDocument/references" },
  { "completion", "textDocument/completion" },
  -- { "implements", "textDocument/implementation" },
  -- { "declaration", "textDocument/declaration" },
  -- { "code-action", "textDocument/codeAction" },
  -- { "code-lens ", "textDocument/codeLens" },
}

return {
  lsp = lsp_methods,
  ext = ext_methods,
}
