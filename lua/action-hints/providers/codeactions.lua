local utils = require("action-hints.utils")
local display = require("action-hints.display")
local state = require("action-hints.state")

local function codeactions(config)
  local options = config or {}
  -- Mark-indexed range ({row, col}, 1-based rows, 0-based cols) of the active selection.
  -- Empty lines report col 1 (or 0 for linewise), so clamp to keep vim.range.mark in bounds.
  local function range_from_selection(mode)
    local region = vim.fn.getregionpos(vim.fn.getpos("v"), vim.fn.getpos("."), {
      type = mode,
      eol = false,
    })
    local first, last = region[1][1], region[#region][2]
    return {
      ["start"] = { first[2], math.max(first[3] - 1, 0) },
      ["end"] = { last[2], math.max(last[3] - 1, 0) },
    }
  end

  if not utils.supports_method("codeActionProvider") then
    return
  end

  if state.is_cleared == false then
    display.clear_virtual_text()
    state.is_cleared = true
  end

  local bufnr = vim.api.nvim_get_current_buf()
  local context = { diagnostics = vim.diagnostic.get(bufnr) }
  -- context.only = opts.action_kinds

  local params
  local mode = vim.api.nvim_get_mode().mode
  if options.range then
    assert(type(options.range) == "table", "codeaction range must be a table")
    local start = assert(options.range.start, "range must have a `start` property")
    local end_ = assert(options.range["end"], "range must have a `end` property")
    params = vim.lsp.util.make_given_range_params(start, end_, 0, "utf-8")
  elseif mode == "v" or mode == "V" then
    local range = range_from_selection(mode)
    params = vim.lsp.util.make_given_range_params(range.start, range["end"], 0, "utf-8")
  else
    params = vim.lsp.util.make_range_params(0, "utf-8")
  end

  params.context = context

  vim.lsp.buf_request_all(bufnr, "textDocument/codeAction", params, function(responses, _, _)
    if not responses then
      state.available.codeactions = false
      state.stats.counts.codeactions = state.stats.counts.codeactions + 1
      state.current.codeactions = 0
      return
    end

    local results = {}
    for client_id, response in pairs(responses) do
      -- [1] = { arguments = { title = "Cycle Case" }, command = "NULL_LS_CODE_ACTION", title = "Cycle Case" },
      for _, result in ipairs(response.result or {}) do
        table.insert(results, result)
      end
    end

    if vim.tbl_count(results) > 0 then
      state.available.codeactions = true
      state.current.codeactions = vim.tbl_count(results)
      state.stats.counts.codeactions = state.stats.counts.codeactions + 1
      display.update_virtual_text(config)
      return
    end
    state.available.codeactions = false
    state.current.codeactions = 0
  end)
end

return codeactions
