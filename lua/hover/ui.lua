local providers = require("hover.providers").providers
local is_enabled = require("hover.providers").is_enabled
local state = require("hover.state")

local function add_title(winnr, active_provider_id)
  local title = {}
  local width = 0
  for _, p in ipairs(providers) do
    if is_enabled(p) then
      local hl = p.id == active_provider_id and "TabLineSel" or "TabLineFill"
      title[#title + 1] = string.format("%%#%s# %s ", hl, p.name)
      title[#title + 1] = "%#Normal# "
      width = width + #p.name + 3
    end
  end
  local title_str = table.concat(title, "")
  if string.len(vim.trim(title_str)) > 0 then
    local win_height = vim.api.nvim_win_get_height(winnr)
    vim.api.nvim_win_set_height(winnr, win_height + 1)
  end
  vim.wo[winnr].winbar = title_str
  if width > state.width then
    vim.api.nvim_win_set_width(state.winnr, width)
    state.width = width
  end
end

local function get_max_height(num)
  if string.find(tostring(num), "%%") then
    local pct = string.match(tostring(num), "([0-9]+)%%")
    local currheight = vim.api.nvim_win_get_height(0)
    return math.floor(currheight * pct / 100)
  end
  return num
end

local function get_max_width(num)
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

local function style_content(lines, filetype, width)
  if not filetype or filetype == "help-markdown" then
    vim.api.nvim_buf_set_option(state.bufnr, "filetype", "help")
    vim.lsp.util.stylize_markdown(state.bufnr, lines, {
      max_width = width,
    })
  else
    vim.api.nvim_buf_set_option(state.bufnr, "filetype", filetype)
    vim.api.nvim_buf_set_lines(state.bufnr, 0, #lines, false, lines)
  end
end

local function get_dimensions(lines, max, config)
  local height = #lines
  local width = 0

  if height > max.h then
    height = max.h
  elseif height < 1 then
    height = config.min_height
  end

  for _, line in ipairs(lines) do
    if #line > width then
      width = #line
    end
  end
  if width > max.w then
    width = max.w
  elseif width < config.min_width then
    width = config.min_width
  end
  state.width = width
  state.height = height
  return width, height
end

local function create_window(width, height)
  -- vim.lsp.util.open_floating_preview(lines, result.filetype, {})
  -- [ ["+", "MyCorner"], ["x", "MyBorder"] ]
  state.winnr = vim.api.nvim_open_win(0, false, {
    -- ⌜⌟⌜⌝ ┘｢｣  ┒┑┓┏┌┍┎ 🭼 🭿 └ ┕ ┖ ┗   ⎡ ⎣ ⎤ ⎦ ˨   ◝ ◟ ◞ ╰ 「」ꜚ﹁ ⇱ ﹂｢｣ ╮ ╯╰ ╭ 𛲖─ ━ ━ ─ ＿ ⎽⎯🭻▁
    -- border = { "↖", "─", "╮", "│", "╯", "─", "╰", "│" },
    -- border = { "↖", "─", "╮", "│", "│", "_", "│", "│" },
    border = { "╭", "─", "╮", "│", "│", "_", "│", "│" },
    relative = "win",
    height = height,
    width = width,
    focusable = true,
    bufpos = { 0, 0 },
    row = vim.api.nvim_win_get_height(0) + 1,
    col = vim.api.nvim_win_get_width(0),
    anchor = "SE",
    zindex = 2,
    style = "minimal",
    -- title = "Hover",
    -- titlepos = 'Center'
  })
  vim.api.nvim_win_set_option(state.winnr, "winblend", 20)
end

local function show_hover_new(provider_id, config, result, opts)
  if not result then
    return
  end

  local max = {
    w = get_max_width(config.max_width),
    h = get_max_height(config.max_height),
  }

  -- lines get reduced when stylized to markdown
  local scrolloff = get_max_height("50%")
  if scrolloff > 7 then
    scrolloff = 7
  end
  vim.api.nvim_set_option_value("scrolloff", scrolloff, {})

  local lines = {}
  if result and type(result) == "table" and result.lines then
    lines = result.lines
  end

  if state.winnr and vim.api.nvim_win_is_valid(state.winnr) then
    vim.wo[state.winnr].winbar = "Loading..."
    state.bufnr = vim.api.nvim_create_buf(false, true)

    local width, _ = get_dimensions(lines, max, config)
    style_content(lines, result.filetype, width)

    local new_lines = vim.api.nvim_buf_get_lines(state.bufnr, 0, -1, false)
    local _, new_height = get_dimensions(new_lines, max, config)

    vim.api.nvim_win_set_config(state.winnr, { width = width, height = new_height })
    vim.api.nvim_win_set_buf(state.winnr, state.bufnr)
    vim.api.nvim_set_option_value("wrap", true, { buf = state.bufnr })
  else
    local width, height = get_dimensions(lines, max, config)
    state.bufnr = vim.api.nvim_create_buf(false, true)

    create_window(width, height)

    -- Setup keymaps
    require("hover.aucommands").init(state.winnr, opts)
    require("hover.keymaps").init(state.winnr, opts)

    style_content(lines, result.filetype, width)

    -- vim.api.nvim_buf_set_option(bufnr, "modifiable", false)
    vim.api.nvim_win_set_buf(state.winnr, state.bufnr)
    vim.api.nvim_set_option_value("wrap", true, { buf = state.bufnr })
    vim.api.nvim_set_keymap("n", "<M-NL>", "<cmd>lua print('HELLO')<cr>", {})
  end
  if config.title then
    add_title(state.winnr, provider_id)
  end
end

return {
  show_hover = show_hover,
  show_hover_new = show_hover_new,
}
