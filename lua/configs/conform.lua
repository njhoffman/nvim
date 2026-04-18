-- function config.get_lsp_fallback(bufnr)
--   local formatters = require("conform").list_formatters(bufnr)
--   if #formatters > 0 and formatters[1].name == "trim_whitespace" then
--     return "always"
--   else
--     return true

--   end
-- end

-- code_action = { "eslint_d", "gitrebase", "refactoring" },

-- Use the "*" filetype to run formatters on all filetypes.
-- Use the "_" filetype to run formatters on filetypes that don't
-- ["*"]        = { "codespell" },

local formatters_by_ft = {
  asm = { "asmfmt" },
  bash = { "shfmt" },
  zsh = { "shfmt" },
  bzl = { "buildifier" },
  c = { "uncrustify", "clang_format" },
  cpp = { "clang_format" },
  css = { "prettierd" },
  cuda = { "clang_format" },
  fish = { "fish_indent" },
  go = { "goimports", "gofmt", "gofumpt" },
  graphql = { "prettierd" },
  handlebars = { "prettierd" },
  html = { "prettierd" },
  htmlangular = { "prettierd" },
  javascript = { "prettierd_js" },
  javascriptreact = { "prettierd_js" },
  json = { "fixjson", "jq", "prettierd" },
  jsonc = { "fixjson", "jq", "prettierd" },
  json5 = { "fixjson", "jq", "prettierd" },
  just = { "just" },
  lua = { "stylua" },
  markdown = { "cbfmt", "markdownlint", "injected" },
  less = { "prettierd" },
  sass = { "prettierd" },
  nasm = { "asmfmt" },
  yaml = { "prettierd" }, -- yamlfix
  nix = { "nixpkgs_fmt" },
  proto = { "buf", "protolint" },
  python = {
    -- "ruff_fix",
    "ruff_format",
    "ruff_organize_imports",
  },
  rust = { "rustfmt", lsp_format = "fallback" },
  scss = { "prettierd" },
  sh = { "shfmt" },
  -- sh              = { "shfmt", "shellharden" },
  sql = { "sql-formatter" },
  toml = { "taplo", "prettierd_toml" },
  tsx = { "prettierd_js" },
  typescript = { "prettierd_js" },
  typescriptreact = { "prettierd_js" },
  vue = { "prettierd_vue" },
  ["_"] = { "trim_whitespace" },
}

local formatters = {
  beautysh = { command = "beautysh", stdin = false, args = { "--indent-size", "2" } },
  cbfmt = {
    prepend_args = { "--config", os.getenv("HOME") .. "/.config/cbfmt/cbfmt.toml" },
  },
  flake8 = {
    command = "flake8",
    stdin = false,
    args = { "--ignore=e203,e501,e402,f401,f821,w503,w292" },
  },
  -- markdownlint = {
  --   command = "markdownlint",
  --   stdin = false,
  --   args = { "--fix", "--config", linterconfig .. "/markdownlint.yaml", "$filename" },
  -- },
  prettierd = {
    command = "prettierd",
    stdin = false,
    args = { "--print-width", "100" },
  },
  prettierd_toml = {
    command = "prettierd",
    stdin = false,
    args = { "--print-width", "100", "--plugin", "prettier-plugin-toml" },
  },
  prettierd_js = {
    command = "prettierd",
    stdin = false,
    args = { "--print-width", "100", "--plugin", "prettier-plugin-organize-imports" },
  },
  prettierd_vue = {
    command = "prettierd",
    stdin = false,
    args = { "--print-width", "100", "--plugin", "prettier-plugin-organize-imports" },
  },
  prettierd_packagejson = {
    command = "prettierd",
    stdin = false,
    args = { "--print-width", "100", "--plugin", "prettier-plugin-packagejson" },
  },
  shellcheck = {
    command = "shellcheck",
    arg = "--shell=bash --format=diff '$filename' | git apply",
    -- arg = "--shell=bash",
    stdin = false,
  },
  rustfmt = {
    meta = {
      url = "https://github.com/rust-lang/rustfmt",
      description = "a tool for formatting rust code according to style guidelines.",
    },
    command = "rustfmt",
    args = { "--emit=stdout", "--edition=2021" },
  },
  shfmt = { args = { "-i", "2", "-bn", "-ci", "-sr" } },
  injected = {
    ignore_errors = false,
    lang_to_ft = {
      bash = "sh",
    },
    lang_to_ext = {
      bash = "sh",
      javascript = "js",
      markdown = "md",
      python = "py",
      typescript = "ts",
    },
  },

  uncrustify = {
    meta = {
      url = "https://github.com/uncrustify/uncrustify",
      description = "a source code beautifier for c, c++, c#, objectivec, d, java, pawn and vala.",
    },
    command = "uncrustify",
    args = function(self, ctx)
      return {
        "-q",
        "-l",
        vim.bo[ctx.buf].filetype:upper(),
        "-c",
        vim.uv.cwd() .. "/src/uncrustify.cfg",
      }
    end,
  },
  yamlfix = {
    -- Change where to find the command
    command = "yamlfix",
    -- Adds environment args to the yamlfix formatter
    env = {
      YAMLFIX_SEQUENCE_STYLE = "block_style",
    },
  },
}

local cfg = {
  log_level = vim.log.levels.DEBUG,
  default_format_opts = {
    timeout_ms = 3000,
    async = false, -- not recommended to change
    quiet = false, -- not recommended to change
    lsp_format = "fallback", -- not recommended to change
  },
  -- notify_on_error = true, -- Custom formatters and overrides for built-in formatters },
  format_on_save = function(bufnr)
    -- Disable with a global or buffer-local variable
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      return
    end
    return { lsp_fallback = true }
  end,
  format_after_save = { lsp_fallback = true },
  formatters_by_ft = formatters_by_ft,
  formatters = formatters,
}

if vim.g.started_by_firenvim then
  cfg.format_on_save = false
  cfg.format_after_save = false
end

require("conform").setup(cfg)

vim.api.nvim_create_user_command("FormatDisable", function(args)
  if args.bang then
    -- FormatDisable! will disable formatting just for this buffer
    vim.b.disable_autoformat = true
  else
    vim.g.disable_autoformat = true
  end
end, {
  desc = "Disable autoformat-on-save",
  bang = true,
})

vim.api.nvim_create_user_command("FormatEnable", function()
  vim.b.disable_autoformat = false
  vim.g.disable_autoformat = false
end, {
  desc = "Re-enable autoformat-on-save",
})

vim.api.nvim_create_user_command("Format", function(args)
  local range = nil
  if args.count ~= -1 then
    local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
    range = {
      start = { args.line1, 0 },
      ["end"] = { args.line2, end_line:len() },
    }
  end
  require("conform").format({ async = true, lsp_fallback = true, range = range })
end, { range = true })

vim.api.nvim_create_user_command("ConformLog", "e " .. vim.fn.stdpath("data") .. "/conform.log", {
  desc = "Open the conform log file",
})

-- run eslint on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.ts", "*.tsx", "*.js", "*.jsx" },
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    local clients = vim.lsp.get_clients({ buf = bufnr })
    for _, client in ipairs(clients) do
      if client.name == "eslint" then
        vim.b.autoformat = false
        vim.cmd("silent! LspEslintFixAll")
        return
      end
    end
  end,
})

-- local event = 'BufWritePost'
-- if format_options.sync then
--   event = 'BufWritePre'
-- end
-- vim.api.nvim_create_autocmd("BufWritePre", {
--   pattern = "*",
--   callback = function(args)
--     -- vim.dbglog("format", args.buf)
--     require("conform").format({ bufnr = args.buf })
--   end,
-- })
