local diagnostic_config = {
  log_level = vim.lsp.log.levels.WARN,
  signs_priority = 6,
  underline = false,
  jump = {
    on_jump = function()
      vim.diagnostic.open_float()
    end,
    wrap = true,
  },
  severity_sort = true,
}

local default_scopes = {
  cursor = true,
  line = true,
  buffer = true,
  workspace = true,
}

local omit_scopes = function(scopes_to_omit)
  local scopes = vim.deepcopy(default_scopes)
  for _, scope in ipairs(scopes_to_omit) do
    scopes[scope] = false
  end
  return scopes
end

local default_handler = function(opts, float_opts)
  local diag_opts = diagnostic_config or {}
  float_opts = float_opts or {}

  require("lsp.ui.float").setup(opts or {})
  vim.diagnostic.config(diag_opts)
  local scopes = omit_scopes({ "workspace", "buffer" })
  return {
    scopes = scopes,
    show = function(show_opts)
      show_opts = show_opts or {}
      vim.diagnostic.open_float(nil, vim.tbl_extend("force", float_opts, {
        severity = show_opts.severity and { min = show_opts.severity } or nil,
      }))
    end,
    hide = function() end,
  }
end

local lines_handler = function(opts)
  local lines_defaults = {
    only_current_line = false,
    highlight_whole_line = false,
    symbol_arrow = "──── ",
  }
  opts = vim.tbl_deep_extend("force", lines_defaults, opts or {})
  local scopes = omit_scopes({ "workspace", "buffer" })
  require("lsp.lsp_lines").setup(opts)
  return {
    scopes = scopes,
    show = function(show_opts)
      show_opts = show_opts or {}
      vim.diagnostic.config({
        virtual_text = false,
        virtual_lines = opts,
      })
    end,
    hide = function()
      vim.diagnostic.config({
        virtual_lines = false,
        virtual_text = true,
      })
    end,
  }
end

local quickfix_handler = function(opts)
  local quickfix_defaults = {
    debug = false,
    buf_clients_only = true,
    debounce_ms = 150,
    level = vim.diagnostic.severity.HINT,
    title = "LSP Diagnostics",
  }
  opts = vim.tbl_deep_extend("force", quickfix_defaults, opts or {})
  local scopes = omit_scopes({ "cursor", "line" })
  require("quickfix").setup(opts)
  return {
    scopes = scopes,
    show = function(show_opts)
      show_opts = show_opts or {}
      local qf_opts = { title = opts.title }
      if show_opts.severity then
        qf_opts.severity = { min = show_opts.severity }
      end
      vim.diagnostic.setqflist(qf_opts)
    end,
    hide = function()
      vim.cmd("cclose")
    end,
  }
end

local inline_handler = function(opts)
  local inline_defaults = {
    preset = "modern",
    transparent_bg = false,
    options = {
      show_source = { enabled = false, if_many = false },
      show_all_diags_on_cursorline = false,
      multilines = { enabled = false },
      enable_on_insert = false,
      overflow = { mode = "wrap" },
      severity = {
        vim.diagnostic.severity.ERROR,
        vim.diagnostic.severity.WARN,
        vim.diagnostic.severity.INFO,
        vim.diagnostic.severity.HINT,
      },
    },
  }
  opts = vim.tbl_deep_extend("force", inline_defaults, opts or {})
  local scopes = omit_scopes({ "workspace" })
  require("tiny-inline-diagnostic").setup(opts)
  return {
    scopes = scopes,
    show = function(show_opts)
      show_opts = show_opts or {}
      if show_opts.severity then
        require("tiny-inline-diagnostic").change_severities({ show_opts.severity })
      else
        require("tiny-inline-diagnostic").reset()
      end
      require("tiny-inline-diagnostic").enable()
      vim.diagnostic.config({ virtual_text = false })
    end,
    hide = function()
      require("tiny-inline-diagnostic").disable()
      vim.diagnostic.config({ virtual_text = true })
    end,
  }
end

local configured_handlers = {
  lines = lines_handler,
  default = default_handler,
  inline = inline_handler,
  quickfix = quickfix_handler,
}

local default_handlers = {
  cursor = "default",
  line = "default",
  buffer = "quickfix",
  workspace = "quickfix",
}

local config = {
  handlers = configured_handlers,
  scopes = default_handlers,
}

require("diagnostics").setup(config)
