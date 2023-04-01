local help = require("devbox.handlers.help")
local man = require("devbox.handlers.man")
local dict = require("devbox.handlers.dict")
local syntax = require("devbox.handlers.syntax")
-- local devboxgh = require("devhints.devbox-gh")

local term_handler = function(name)
  return function(start_time, timing)
    local results = vim.fn.expand("<" .. name .. ">")
    ---@diagnostic disable-next-line: missing-parameter
    local load_time = vim.fn.reltimestr(vim.fn.reltime(start_time))
    timing.total = timing.total + (load_time * 100000)
    timing.n = timing.n + 1
    local line = load_time .. " " .. name .. " " .. results
    return { summary = line, hl = "Function" }
  end
end

local ext_methods = {
  { "cword", term_handler("cword") },
  { "cexpr", term_handler("cexpr") },
  { "cfile", term_handler("cfile") },
  { "cWORD", term_handler("cWORD") },
  { "syn", syntax.handler },
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
  -- { "codeaction", "textDocument/codeAction" },
  -- semanticTokens,executeCommand,typeDefinition,
}

return {
  lsp = lsp_methods,
  ext = ext_methods,
}
