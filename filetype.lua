-- Set .aliases or any variant as "bash".
vim.filetype.add({ pattern = { ["%.*aliases.*"] = "bash" } })

-- Set .zprofile or any variant as "bash".
vim.filetype.add({ pattern = { ["%.*zprofile.*"] = "bash" } })

-- Set .env or any variant as "dotenv" except we want .env.example files to be
-- treated differently so it's easier to know we are editing an example file.
-- This has less syntax highlighting and comes up with a different explorer
-- icon so it's easier to know it's not the "real" env file.
vim.filetype.add({
  pattern = {
    ["%.env.*"] = "dotenv",
    ["%.env.*.example"] = { "conf", { priority = 1 } },
  },
})

-- Ensure all .env files and variants are syntax highlighted as shell scripts.
-- This goes along with the filetype addition above. We do this to avoid using
-- bash or sh so the BashLSP linter and formatter doesn't affect env files
-- since that can create a lot of unwanted false positives and side effects.
vim.treesitter.language.register("bash", "dotenv")

-- Set git config variarts as "git_config".
vim.filetype.add({ pattern = { [".*/git/config.*"] = "git_config" } })

-- Set requirements-lock.txt or any variant as "requirements".
vim.filetype.add({ pattern = { ["requirements.*.txt"] = "requirements" } })

-- Spidercode: HTML files containing %spidercode% blocks use the spidercode parser.
-- This is necessary because the HTML parser breaks on '<' characters in JavaScript.

-- Register the spidercode parser early so it's available when files are opened
local spidercode_parser_path = vim.fn.stdpath("config") .. "/tree-sitter-spidercode/parser/spidercode.so"
if vim.fn.filereadable(spidercode_parser_path) == 1 then
  vim.treesitter.language.add("spidercode", { path = spidercode_parser_path })

  -- Ensure injections are properly processed for spidercode files
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "spidercode",
    callback = function(ctx)
      vim.treesitter.start(ctx.buf, "spidercode")
      local parser = vim.treesitter.get_parser(ctx.buf)
      if parser then
        parser:invalidate()
        parser:parse(true)
      end

      -- Use tree-sitter indentation which respects injected languages
      vim.bo[ctx.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
  })
end

vim.filetype.add({
  pattern = {
    [".*%.html"] = {
      priority = -1,
      function(path, bufnr)
        local content = vim.api.nvim_buf_get_lines(bufnr, 0, 50, false)
        for _, line in ipairs(content) do
          if line:match("^%%spidercode%%$") then
            return "spidercode"
          end
        end
        return nil -- Fall back to default HTML detection
      end,
    },
  },
})
