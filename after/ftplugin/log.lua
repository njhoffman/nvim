-- Log files: tree-sitter highlighting from parser/log.so and queries/log/highlights.scm (grammar in
-- parsers/tree-sitter-log). Without the parser, Neovim's runtime syntax/log.vim still applies.
-- nord-nick sets these @log.* groups itself; the links are a fallback for other colorschemes, and
-- `default` keeps them from overriding it.
local links = {
  ["@log.date"] = "Identifier",
  ["@log.time"] = "Function",
  ["@log.timezone"] = "Identifier",
  ["@log.duration"] = "Operator",
  ["@log.syslog"] = "Statement",
  ["@log.level.error"] = "ErrorMsg",
  ["@log.level.warning"] = "WarningMsg",
  ["@log.level.notice"] = "Exception",
  ["@log.level.info"] = "Repeat",
  ["@log.level.debug"] = "Debug",
  ["@log.level.trace"] = "Comment",
  ["@log.level.success"] = "String",
  ["@log.string"] = "String",
  ["@log.number"] = "Number",
  ["@log.float"] = "Float",
  ["@log.boolean"] = "Boolean",
  ["@log.null"] = "Constant",
  ["@log.url"] = "Underlined",
  ["@log.hash"] = "Label",
  ["@log.path"] = "Conditional",
  ["@log.domain"] = "Label",
  ["@log.reference"] = "Operator",
  ["@log.xml.header"] = "Function",
  ["@log.xml.tag"] = "Identifier",
  ["@log.xml.comment"] = "Comment",
  ["@log.xml.cdata"] = "String",
  ["@log.xml.entity"] = "Special",
  ["@log.separator"] = "Comment",
  ["@log.operator"] = "Operator",
  ["@log.bracket"] = "Comment",
}
for group, link in pairs(links) do
  vim.api.nvim_set_hl(0, group, { link = link, default = true })
end

pcall(vim.treesitter.start, 0, "log")
