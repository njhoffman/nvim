local providers = require("hover.providers").providers

local function is_enabled(provider)
  if type(provider.enabled == "function") then
    return provider.enabled()
  else
    return provider.enabled
  end
end

local function add_title(winnr, active_provider_id)
  local title = {}
  for _, p in ipairs(providers) do
    if is_enabled(p) then
      local hl = p.id == active_provider_id and "TabLineSel" or "TabLineFill"
      title[#title + 1] = string.format("%%#%s# %s ", hl, p.name)
      title[#title + 1] = "%#Normal# "
    end
  end
  local title_str = table.concat(title, "")
  if string.len(vim.trim(title_str)) > 0 then
    local win_height = vim.api.nvim_win_get_height(winnr)
    vim.api.nvim_win_set_height(winnr, win_height + 1)
  end
  vim.wo[winnr].winbar = title_str
end

local get_height = function(num)
  if string.find(tostring(num), "%%") then
    local pct = string.match(tostring(num), "([0-9]+)%%")
    local currheight = vim.api.nvim_win_get_height(0)
    return math.floor(currheight * pct / 100)
  end
  return num
end

local get_width = function(num)
  if string.find(tostring(num), "%%") then
    local pct = string.match(tostring(num), "([0-9]+)%%")
    local currwidth = vim.api.nvim_win_get_width(0)
    return math.floor(currwidth * pct / 100)
  end
  return num
end

local function show_hover(provider_id, config, result, opts)
  local _, winnr = vim.lsp.util.open_floating_preview(result.lines, result.filetype, opts)
  if config.title then
    add_title(winnr, provider_id)
  end
end

local winnr = nil
local function show_hover_new(provider_id, config, result, opts)
  local max = {
    w = get_width("90%"),
    h = get_height("40%"),
  }

  if not result then
    return
  end

  -- lines get reduced when stylized to markdown
  local width = 0
  local scrolloff = get_height("50%")
  if scrolloff > 7 then
    scrolloff = 7
  end
  vim.api.nvim_set_option_value("scrolloff", scrolloff, {})

  if winnr and vim.api.nvim_win_is_valid(winnr) then
    local bufnr = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_option(bufnr, "filetype", "help")
    vim.lsp.util.stylize_markdown(bufnr, result.lines, {
      max_width = width,
    })
    local new_lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local height = #new_lines
    if height > max.h then
      height = max.h
    elseif height < 1 then
      height = 1
    end
    for _, line in ipairs(new_lines) do
      if #line > width then
        width = #line
      end
    end
    if width > max.w then
      width = max.w
    end

    vim.api.nvim_win_set_config(winnr, { width = width, height = height })
    vim.api.nvim_win_set_buf(winnr, bufnr)
    vim.api.nvim_set_option_value("wrap", true, { buf = bufnr })
  else
    local height = #result.lines - 2
    if height > max.h then
      height = max.h
    elseif height < 1 then
      height = 1
    end
    for _, line in ipairs(result.lines) do
      if #line > width then
        width = #line
      end
    end

    winnr = vim.api.nvim_open_win(0, false, {
      relative = "win",
      height = height,
      width = width,
      focusable = true,
      border = "rounded",
      bufpos = { 0, 0 },
      row = vim.api.nvim_win_get_height(0),
      col = vim.api.nvim_win_get_width(0),
      anchor = "SE",
      zindex = 2,
      style = "minimal",
    })
    vim.api.nvim_win_set_option(winnr, "winblend", 20)
    -- Setup keymaps
    require("hover.aucommands").init(winnr)

    local bufnr = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_option(bufnr, "filetype", "help")
    vim.lsp.util.stylize_markdown(bufnr, result.lines, {
      max_width = width,
    })
    -- vim.api.nvim_buf_set_option(bufnr, "modifiable", false)
    vim.api.nvim_win_set_buf(winnr, bufnr)
    vim.api.nvim_set_option_value("wrap", true, { buf = bufnr })
    vim.api.nvim_set_keymap("n", "<M-NL>", "<cmd>lua print('HELLO')<cr>", {})
  end
end

return {
  show_hover = show_hover,
  show_hover_new = show_hover_new,
}
