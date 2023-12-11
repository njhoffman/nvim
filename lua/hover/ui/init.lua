local config = require('hover.config').get()
local state = require('hover.state')
local ui_title = require('hover.ui.title')
local ui_dimensions = require('hover.ui.dimensions')
local npcall = vim.F.npcall

local function show_hover(provider_id, result, opts)
  local _, winnr = vim.lsp.util.open_floating_preview(result.lines, result.filetype, opts)
  ui_title.add_title()
end

local function get_styled_content(_lines, width)
  vim.api.nvim_buf_set_option(state.bufnr, 'modifiable', true)
  vim.api.nvim_buf_set_lines(state.bufnr, 0, -1, true, {})

  local lines = vim.lsp.util.stylize_markdown(state.bufnr, _lines, {
    max_width = width,
  })
  vim.api.nvim_buf_set_option(state.bufnr, 'modifiable', false)
  return lines
end

local function create_window(width, height)
  -- vim.lsp.util.open_floating_preview(lines, result.filetype, {})
  -- [ ["+", "MyCorner"], ["x", "MyBorder"] ]
  state.winnr = vim.api.nvim_open_win(0, false, {
    -- ⌜⌟⌜⌝ ┘｢｣  ┒┑┓┏┌┍┎ 🭼 🭿 └ ┕ ┖ ┗   ⎡ ⎣ ⎤ ⎦ ˨   ◝ ◟ ◞ ╰ 「」ꜚ﹁ ⇱ ﹂｢｣ ╮ ╯╰ ╭ 𛲖─ ━ ━ ─ ＿ ⎽⎯🭻▁
    -- border = { "↖", "─", "╮", "│", "╯", "─", "╰", "│" },
    -- border = { "↖", "─", "╮", "│", "│", "_", "│", "│" },
    border = { '╭', '─', '╮', '│', '│', '_', '│', '│' },
    relative = 'win',
    height = height,
    width = width,
    focusable = true,
    bufpos = { 0, 0 },
    row = vim.api.nvim_win_get_height(0) - 1,
    col = vim.api.nvim_win_get_width(0),
    anchor = 'SE',
    zindex = 2,
    style = 'minimal',
    -- title = "Hover",
    -- titlepos = 'Center'
  })
  vim.api.nvim_win_set_option(state.winnr, 'winblend', 20)
end

local function load_hover(provider_id, result)
  local ft = result.filetype or 'markdown'
  vim.dbglog('🪚 load_hover= ' .. provider_id)
  if type(state.ft_bufnr[ft]) == 'nil' or not vim.api.nvim_buf_is_valid(state.ft_bufnr[ft]) then
    state.ft_bufnr[ft] = vim.api.nvim_create_buf(false, true)
    -- if vim.api.nvim_buf_get_name(state.ft_bufnr[ft]) ~= ':hover' then
    --   vim.api.nvim_buf_set_name(state.ft_bufnr[ft], ':hover')
    -- end
  end
  state.bufnr = state.ft_bufnr[ft]

  local max = {
    w = ui_dimensions.get_max_width(config.max_width),
    h = ui_dimensions.get_max_height(config.max_height),
  }

  local scrolloff = ui_dimensions.get_max_height('50%')
  if scrolloff > 7 then
    scrolloff = 7
  end
  vim.api.nvim_set_option_value('scrolloff', scrolloff, {})

  vim.api.nvim_win_set_option(state.winnr, 'winbar', '...')
  if result and type(result) == 'table' and result.lines then
    -- lines = result.lines
    ui_dimensions.get_dimensions(result.lines, max, provider_id)
    get_styled_content(result.lines, state.width)
    vim.api.nvim_win_set_config(state.winnr, { width = state.width, height = state.height })
    vim.api.nvim_win_set_buf(state.winnr, state.bufnr)
    if vim.api.nvim_buf_get_option(state.bufnr, 'filetype') ~= result.filetype then
      vim.api.nvim_buf_set_option(state.bufnr, 'filetype', result.filetype)
    end
  end
end

local function show_hover_new(provider_id, result, opts)
  vim.dbglog('🪚 hover_new')
  if not result or not result.lines then
    return
  end

  local curr_provider = nil
  for _, p in ipairs(state.providers) do
    if p.id == provider_id then
      curr_provider = p
    end
  end

  local ft = result.filetype or 'markdown'
  if type(state.ft_bufnr[ft]) == 'nil' or not vim.api.nvim_buf_is_valid(state.ft_bufnr[ft]) then
    state.ft_bufnr[ft] = vim.api.nvim_create_buf(false, true)
    -- if vim.api.nvim_buf_get_name(state.ft_bufnr[ft]) ~= ':hover' then
    --   vim.api.nvim_buf_set_name(state.ft_bufnr[ft], ':hover')
    -- end
  end
  state.bufnr = state.ft_bufnr[ft]

  local max = {
    w = ui_dimensions.get_max_width(config.max_width),
    h = ui_dimensions.get_max_height(config.max_height),
  }

  -- lines get reduced when stylized to markdown
  local scrolloff = ui_dimensions.get_max_height('50%')
  if scrolloff > 7 then
    scrolloff = 7
  end
  vim.api.nvim_set_option_value('scrolloff', scrolloff, {})

  -- lines = result.lines
  local width, height = ui_dimensions.get_dimensions(result.lines, max, provider_id)
  if curr_provider then
    curr_provider._dimensions = { width = width, height = height }
  end
  get_styled_content(result.lines, state.width)

  create_window(state.width, state.height)

  -- Setup keymaps
  require('hover.aucommands').open(state.winnr, opts)
  require('hover.keymaps').assign_open_keymaps(opts)

  -- local new_lines = style_content(lines, result.filetype, state.width)
  -- local new_lines = get_styled_content(lines, state.width)
  -- local _, new_height = get_dimensions(lines, max, config)

  vim.api.nvim_win_set_option(state.winnr, 'winbar', '...')

  vim.api.nvim_win_set_buf(state.winnr, state.bufnr)
  vim.api.nvim_set_option_value('wrap', false, { win = state.winnr })
  -- vim.api.nvim_set_option_value('modifiable', false, { buf = state.bufnr })
  -- vim.api.nvim_set_option_value('readonly', true, { buf = state.bufnr })
  vim.api.nvim_set_option_value('swapfile', false, { buf = state.bufnr })

  -- get_dimensions(lines, max, config, provider_id)

  if vim.api.nvim_buf_get_option(state.bufnr, 'filetype') ~= result.filetype then
    vim.api.nvim_buf_set_option(state.bufnr, 'filetype', result.filetype)
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
  if npcall(vim.api.nvim_win_get_var, state.winnr, 'hover') then
    vim.api.nvim_command('wincmd p')
    return true
  end
  local win = find_window_by_var('hover', state.bufnr)
  if win and vim.api.nvim_win_is_valid(win) and vim.fn.pumvisible() == 0 then
    -- focus and return the existing buf, win
    vim.api.nvim_set_current_win(win)
    vim.api.nvim_command('stopinsert')
    return true
  end
  return false
end

return {
  focus_or_close_hover = focus_or_close_hover,
  find_window_by_var = find_window_by_var,
  load_hover = load_hover,
  show_hover = show_hover,
  show_hover_new = show_hover_new,
  add_title = ui_title.add_title,
}
