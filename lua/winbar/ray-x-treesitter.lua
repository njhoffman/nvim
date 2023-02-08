-- stylua: ignore start
local ts_ensure_installed = { "go", "css", "html", "javascript", "typescript", "jsdoc", "json", "c", "java", "toml", "tsx", "lua", "cpp", "python", "rust", "jsonc", "yaml", "sql", "vue", "vim", "org"}
-- stylua: ignore end

function textsubjects()
  require("nvim-treesitter.configs").setup({

    textsubjects = {
      enable = true,
      prev_selection = ",",
      keymaps = {
        ["."] = "textsubjects-smart",
        -- [";"] = "textsubjects-container-outer",
        -- ["i;"] = "textsubjects-container-inner",
      },
    },
  })
end

local treesitter_context = function(width)
  if not packer_plugins["nvim-treesitter"] or packer_plugins["nvim-treesitter"].loaded == false then
    return " "
  end
  local type_patterns = {
    "class",
    "function",
    "method",
    "interface",
    "type_spec",
    "table",
    "if_statement",
    "for_statement",
    "for_in_statement",
    "call_expression",
    "comment",
  }

  if vim.o.ft == "json" then
    type_patterns = { "object", "pair" }
  end

  local f = require("nvim-treesitter").statusline({
    indicator_size = width,
    type_patterns = type_patterns,
  })
  local context = string.format("%s", f) -- convert to string, it may be a empty ts node

  if context == "vim.NIL" then
    return " "
  end

  return " " .. context
end
vim.api.nvim_create_autocmd({ "FileType" }, {
  group = vim.api.nvim_create_augroup("SyntaxFtAuGroup", {}),
  callback = function()
    local ft = vim.o.ft
    if vim.tbl_contains(ts_ensure_installed, ft) then
      return
    end
    -- in case ts not installed

    local fsize = vim.fn.getfsize(vim.fn.expand("%:p:f")) or 1
    if fsize < 100000 then
      vim.cmd("syntax on")
    end
  end,
})

return {
  context = treesitter_context,
}
