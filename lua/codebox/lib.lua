local utils = require("codebox.utils")
local mappings = require("codebox.mappings")
local config = require("codebox.config")
local syntax = require("codebox.handlers.syntax")
local lsp = require("codebox.handlers.lsp")
local ui = require("codebox.ui")

local setup_aucmds = function()
  vim.api.nvim_create_augroup("codebox-vanish", { clear = true })
  vim.api.nvim_create_augroup("codebox", { clear = true })

  vim.api.nvim_create_autocmd("WinClosed", {
    callback = function(args)
      ui.remove_win(tonumber(args.match))
    end,
    group = "codebox",
    desc = "Sync codebox floating windows with state",
  })

  vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
      ui.buffer_entered()
    end,
    group = "codebox",
    desc = "Run hook functions when entering codebox buffer",
  })
end

local view_syntax = function(opts)
  local lines = syntax.get_highlights()
  local width = utils.lines_width(lines)
  opts = opts or {}

  if vim.tbl_isempty(lines) then
    utils.logger.debug("Syntax viwer returned no results")
    return
  end
  opts.width = width
  opts.height = #lines
  local cursor_position = { 1, 0 }
  local bufnr = vim.api.nvim_create_buf(false, true)

  vim.api.nvim_buf_set_lines(bufnr, 0, #lines, false, lines)
  vim.api.nvim_buf_set_option(bufnr, "filetype", "markdown")
  vim.api.nvim_set_option_value("concealcursor", "c", { buf = bufnr })
  ui.open_floating_win(bufnr, cursor_position, opts)
end

local setup = function(_conf)
  config.conf = config.setup(_conf) or {}
  utils.logger.debug("non-lib:" .. vim.inspect(config.conf))

  setup_aucmds()

  if config.conf.default_mappings then
    mappings.apply_default_mappings()
  end
  if config.conf.resizing_mappings then
    vim.dbglog("NO", config.conf)
    mappings.apply_resizing_mappings()
  end

  return {
    goto_preview_definition = lsp.request_definition,
    goto_preview_type_definition = lsp.request_type_definition,
    goto_preview_implementation = lsp.request_implementation,
    goto_preview_references = lsp.request_references,
    toggle_dock = ui.toggle_dock,
    close_all_win = ui.close_all_win,
    remove_win = ui.remove_win,
    buffer_entered = ui.buffer_entered,
    dismiss_preview = ui.dismiss_preview,
    view_syntax = view_syntax,
  }
end

return {
  setup = setup,
}
