-- -- luacheck: globals vim
-- local M = {}
-- local SEVERITIES = null_ls_helpers.diagnostics.severities
-- local diagnostics_by_line_results = function(content, match_regex, name)
--   local result = {}
--   for line_number = 1, #content do
--     match_regex(function(regex, message, severity)
--       local line = content[line_number]
--       local start_byte, end_byte = regex:match_str(line)
--
--       if start_byte ~= nil then
--         table.insert(result, {
--           message = message,
--           severity = severity,
--           row = line_number,
--           col = start_byte + 1,
--           end_row = line_number,
--           end_col = end_byte + 1,
--           source = name,
--         })
--       end
--     end)
--   end
--   return result
-- end
--
-- local diagnostics_by_line = function(options)
--   return {
--     method = null_ls.methods.DIAGNOSTICS,
--     name = options.name,
--     filetypes = {},
--     disabled_filetypes = options.disabled_filetypes,
--     generator = {
--       async = true,
--       fn = function(params, done)
--         return done(diagnostics_by_line_results(params.content, options.fn, options.name))
--       end,
--     },
--   }
-- end
--
-- local REGEX_TODO = vim.regex('TODO')
-- local REGEX_FIXME = vim.regex('FIXME')
--
-- -- lua: .editorconfig, .stylua.toml,  .lua-format, .luacheckrc

local null_helpers = require('null-ls.helpers')
local null_methods = require('null-ls.methods')
local FORMATTING = null_methods.internal.FORMATTING
local strip_invalid_endings = null_helpers.make_builtin({
  name = 'strip_invalid_endings',
  meta = {
    description = 'Removes invalid commas at the end of lines',
  },
  method = FORMATTING,
  filetypes = { 'lua' },
  generator_opts = {
    command = 'awk',
    args = { '{ sub(/,[, ]+$/, ","); print }' },
    to_stdin = true,
  },

  factory = null_helpers.formatter_factory,
})

return {
  formatting = {
    strip_invalid_endings,
  },
}
