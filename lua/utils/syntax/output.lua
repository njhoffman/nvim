local hl_captures = require("utils.syntax.hl-captures")
local ts_node = require("utils.syntax.ts-node")

local get_node_lines = function(node_results, opts)
  opts = vim.tbl_deep_extend("keep", opts or {}, {
    full_path = false,
    show_range = true,
    include_anonymous = false,
    highlight_node = true,
    hl_group = "TSPlaygroundFocus",
  })

  local lines = { "# Treesitter" }
  local node_under_cursor

  for _, node in ipairs(node_results) do
    node_under_cursor = node[2]
    node = node[1][1]
    local path = opts.full_path and node.full_path or node.path
    vim.list_extend(lines, {
      "* Parser: " .. node.parser,
      string.format("* %s: ", opts.full_path and "Node path" or "Node") .. path,
    })

    if opts.include_anonymous then
      vim.list_extend(lines, {
        " - Anonymous: " .. node.anonymous,
      })
    end

    if opts.show_range then
      vim.list_extend(lines, {
        "* Range: ",
        "  - Start row: " .. node.range.srow,
        "  - End row: " .. node.range.erow,
        "  - Start col: " .. node.range.scol,
        "  - End col: " .. node.range.ecol,
      })
    end
  end

  if not node_under_cursor then
    lines[#lines + 1] = "* Node not found"
  end

  local bufnr = vim.api.nvim_get_current_buf()
  if opts.highlight_node and node_under_cursor then
    local ns = vim.api.nvim_create_namespace("nvim-treesitter-current-node")
    ts_node.highlight_node(node_under_cursor, bufnr, ns, opts.hl_group)
    vim.api.nvim_create_autocmd("CursorMoved", {
      group = vim.api.nvim_create_augroup("TSNodeUnderCursor", {}),
      buffer = bufnr,
      callback = function()
        require("nvim-treesitter-playground.internal").clear_highlights(bufnr, ns)
      end,
      desc = "TSPlayground: clear highlights",
    })
  end
  return lines
end

local get_hl_lines = function(results)
  local lines = {}
  for source, matches in pairs(results) do
    table.insert(lines, "# " .. source)
    for _, match in ipairs(matches) do
      table.insert(lines, match)
    end
    if #lines == 0 then
      table.insert(lines, "* No highlight groups found")
    end
  end

  return lines
end

local output_log = function(lines)
  for _, line in ipairs(lines) do
    -- vim.dbglog(line)
  end
end

local output_window = function(lines)
  return vim.lsp.util.open_floating_preview(lines, "markdown", { border = "single", pad_left = 4, pad_right = 4 })
end

local output_hl = function(opts, results)
  opts = opts or {}
  local hl_res = results or hl_captures.get_highlights()
  local lines = get_hl_lines(hl_res)
  if opts.method == "window" then
    output_window(lines)
  else
    output_log(lines)
  end
end

local output_node = function(opts, results)
  opts = opts or {}
  local node_results = results or ts_node.get_ts_node()
  local lines = ts_node.get_node_lines(node_results)
  if opts.method == "window" then
    output_window(lines)
  else
    output_log(lines)
  end
end

local output = function(opts, ts_results, hl_results)
  opts = opts or {}
  local res = { ts = ts_results or {}, hl = hl_results or {} }
  output_node(opts, res.ts)
  output_hl(opts, res.hl)
end

return {
  output = output,
  get_node_lines = get_node_lines,
  get_hl_lines = get_hl_lines,
}
