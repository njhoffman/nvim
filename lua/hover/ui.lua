local providers = require("hover.providers").providers
local is_enabled = require("hover.providers").is_enabled
local state = require("hover.state")
local npcall = vim.F.npcall

local function get_title(active_provider_id)
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
  return title_str, width
end

local function add_title(winnr, active_provider_id)
  local title_str, width = get_title(active_provider_id)
  if string.len(vim.trim(title_str)) > 0 then
    local win_height = vim.api.nvim_win_get_height(winnr)
    vim.api.nvim_win_set_height(winnr, win_height)
  end
  if width > state.width then
    vim.api.nvim_win_set_width(state.winnr, width + 1)
    state.width = width + 1
  end
  vim.wo[winnr].winbar = title_str or "..."
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
  add_title(winnr, provider_id)
end

local function get_styled_content(_lines, width)
  local lines = vim.lsp.util.stylize_markdown(state.bufnr, _lines, {
    max_width = width,
  })
  return lines
end

local function style_content(_lines, filetype, width)
  local lines = get_styled_content(_lines, width)
  vim.api.nvim_buf_set_option(state.bufnr, "filetype", filetype)
  vim.api.nvim_buf_set_lines(state.bufnr, 0, #lines, false, lines)
end

local function get_dimensions(lines, max, config, provider_id)
  local height = #lines
  local width = 0

  local _, title_width = get_title(provider_id)

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

  state.width = title_width > width and title_width or width
  state.height = height
  return state.width, state.height
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
  local ft = result.filetype or "markdown"
  if type(state.ft_bufnr[ft]) == "nil" or not vim.api.nvim_buf_is_valid(state.ft_bufnr[ft]) then
    state.ft_bufnr[ft] = vim.api.nvim_create_buf(false, true)
  end

  state.bufnr = state.ft_bufnr[ft]

  local lines = {}
  if result and type(result) == "table" and result.lines then
    -- lines = result.lines
    get_dimensions(result.lines, max, config, provider_id)
    lines = get_styled_content(result.lines, state.width)
  end

  if lines and #lines > 0 then
    if state.winnr and vim.api.nvim_win_is_valid(state.winnr) then
      -- local new_lines = get_styled_content(lines, state.width)
      -- get_dimensions(new_lines, max, config, provider_id)
      -- local new_lines = vim.api.nvim_buf_get_lines(state.bufnr, 0, -1, false)
      -- local _, new_height = get_dimensions(new_lines, max, config)

      vim.api.nvim_win_set_config(state.winnr, { width = state.width, height = state.height })
      vim.api.nvim_win_set_buf(state.winnr, state.bufnr)
      vim.api.nvim_win_set_option(state.winnr, "winbar", "...")
    else
      create_window(state.width, state.height)

      -- Setup keymaps
      require("hover.aucommands").open(state.winnr, opts)
      -- require("hover.keymaps").open(opts)

      -- local new_lines = style_content(lines, result.filetype, state.width)
      -- local new_lines = get_styled_content(lines, state.width)
      -- local _, new_height = get_dimensions(lines, max, config)

      vim.api.nvim_win_set_option(state.winnr, "winbar", "...")

      vim.api.nvim_win_set_buf(state.winnr, state.bufnr)
      vim.api.nvim_set_option_value("wrap", true, { buf = state.bufnr })
      -- vim.api.nvim_set_option_value("modifiable", false, { buf = state.bufnr })
      vim.api.nvim_set_option_value("readonly", false, { buf = state.bufnr })
      vim.api.nvim_set_option_value("swapfile", false, { buf = state.bufnr })

      -- get_dimensions(lines, max, config, provider_id)
    end
  end

  vim.api.nvim_set_option_value("wrap", true, { buf = state.bufnr })
  -- vim.api.nvim_set_option_value("modifiable", false, { buf = state.bufnr })
  vim.api.nvim_set_option_value("readonly", false, { buf = state.bufnr })
  vim.api.nvim_set_option_value("swapfile", false, { buf = state.bufnr })

  if vim.fn.empty(state.next_job) == 0 then
    state.next_job()
  end

  add_title(state.winnr, provider_id)
  if vim.api.nvim_buf_get_option(state.bufnr, "filetype") ~= result.filetype then
    vim.api.nvim_buf_set_option(state.bufnr, "filetype", result.filetype)
  end
end

local function find_window_by_var(name, value)
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if npcall(vim.api.nvim_win_get_var, win, name) == value then
      return win
    end
  end
end

local function focus_or_close_hover()
  -- Go back to previous window if we are in a focusable one
  if npcall(vim.api.nvim_win_get_var, state.winnr, "hover") then
    vim.api.nvim_command("wincmd p")
    return true
  end
  local win = find_window_by_var("hover", state.bufnr)
  if win and vim.api.nvim_win_is_valid(win) and vim.fn.pumvisible() == 0 then
    -- focus and return the existing buf, win
    vim.api.nvim_set_current_win(win)
    vim.api.nvim_command("stopinsert")
    return true
  end
  return false
end

return {
  focus_or_close_hover = focus_or_close_hover,
  find_window_by_var = find_window_by_var,
  show_hover = show_hover,
  show_hover_new = show_hover_new,
}
