local config = require("hover.config")
local state = require("hover.state")
local ui_dimensions = require("hover.ui.dimensions")
local npcall = vim.F.npcall

local focus_or_close_hover = function()
  local find_window_by_var = function(name, value)
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      if npcall(vim.api.nvim_win_get_var, win, name) == value then
        return win
      end
    end
  end

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

local get_styled_content = function(_lines, width)
  vim.api.nvim_set_option_value("modifiable", true, { buf = state.bufnr })
  vim.api.nvim_buf_set_lines(state.bufnr, 0, -1, true, {})

  local lines = vim.lsp.util.stylize_markdown(state.bufnr, _lines, {
    max_width = width,
  })
  vim.api.nvim_set_option_value("modifiable", false, { buf = state.bufnr })
  return lines
end

local is_resize_finished = function(dims)
  return (dims.new_w == dims.old_w and dims.new_h == dims.old_h)
    or not state.winnr
    or not vim.api.nvim_win_is_valid(state.winnr)
end

local function resize_window(dims)
  vim.defer_fn(function()
    local inc = {
      w = dims.new_w > dims.old_w and 1 or dims.new_w < dims.old_w and -1 or 0,
      h = dims.new_h > dims.old_h and 1 or dims.new_h < dims.old_h and -1 or 0,
    }
    dims.old_w = dims.old_w + inc.w
    dims.old_h = dims.old_h + inc.h

    if not is_resize_finished(dims) then
      vim.api.nvim_win_set_config(state.winnr, { width = dims.old_w, height = dims.old_h })
      resize_window(dims)
    end
    vim.api.nvim_set_option_value("scrolloff", math.floor(dims.new_h / 2), { win = state.winnr })
  end, 1)
end

local get_max_size = function()
  return {
    w = ui_dimensions.get_max_width(config.get().max_width),
    h = ui_dimensions.get_max_height(config.get().max_height),
  }
end

local set_filetype = function(ft)
  if vim.api.nvim_get_option_value("filetype", { buf = state.bufnr }) ~= ft then
    vim.api.nvim_set_option_value("filetype", ft, { buf = state.bufnr })
  end
end

local load_hover = function(provider_id, result, opts)
  local ft = result and result.filetype or "markdown"
  if type(state.ft_bufnr[ft]) == "nil" or not vim.api.nvim_buf_is_valid(state.ft_bufnr[ft]) then
    state.ft_bufnr[ft] = vim.api.nvim_create_buf(false, true)
    -- if vim.api.nvim_buf_get_name(state.ft_bufnr[ft]) ~= ':hover' then
    --   vim.api.nvim_buf_set_name(state.ft_bufnr[ft], ':hover')
    -- end
  end
  state.bufnr = state.ft_bufnr[ft]

  vim.api.nvim_set_option_value("winbar", "...", { win = state.winnr })
  if result and type(result) == "table" and result.lines then
    -- lines = result.lines
    local max = get_max_size()
    local dims = ui_dimensions.get_dimensions(result.lines, max, provider_id)
    get_styled_content(result.lines, state.width - 1) -- 1 for scrollbar
    resize_window(dims)

    vim.api.nvim_win_set_buf(state.winnr, state.bufnr)
    set_filetype(result.filetype)
  end
end

local create_window = function(width, height, opts)
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
    focusable = false,
    bufpos = { 0, 0 },
    row = vim.api.nvim_win_get_height(0) - 1,
    col = vim.api.nvim_win_get_width(0),
    anchor = "SE",
    zindex = 2,
    style = "minimal",
    -- title = "Hover",
    -- titlepos = 'Center'
  })

  -- Setup keymaps
  require("hover.aucommands").create(state.winnr, opts)
  require("hover.keymaps").assign_open_keymaps(opts)

  vim.api.nvim_set_option_value("winbar", "...", { win = state.winnr })

  vim.api.nvim_win_set_buf(state.winnr, state.bufnr)
  vim.api.nvim_set_option_value("winblend", 20, { win = state.winnr })
  vim.api.nvim_set_option_value("wrap", false, { win = state.winnr })
  vim.api.nvim_set_option_value("scroll", 0, { win = state.winnr })
  vim.api.nvim_set_option_value("scrolloff", math.floor(height / 2), { win = state.winnr })
  vim.api.nvim_set_option_value("sidescrolloff", 0, { win = state.winnr })
  -- vim.api.nvim_set_option_value('modifiable', false, { buf = state.bufnr })
  -- vim.api.nvim_set_option_value('readonly', true, { buf = state.bufnr })
  vim.api.nvim_set_option_value("swapfile", false, { buf = state.bufnr })
end

local function create_hover(provider_id, result, opts)
  if type(result) ~= "table" or type(result.lines) ~= "table" then
    return
  end

  if state.winnr and vim.api.nvim_win_is_valid(state.winnr) then
    return load_hover(provider_id, result, opts)
  end

  local curr_provider = nil
  for _, p in ipairs(state.providers) do
    if p.id == provider_id then
      curr_provider = p
    end
  end

  local ft = result.filetype or "markdown"
  if type(state.ft_bufnr[ft]) == "nil" or not vim.api.nvim_buf_is_valid(state.ft_bufnr[ft]) then
    state.ft_bufnr[ft] = vim.api.nvim_create_buf(false, true)
  end
  state.bufnr = state.ft_bufnr[ft]

  -- lines = result.lines
  local max = get_max_size()
  local width, height = ui_dimensions.get_dimensions(result.lines, max, provider_id)
  if curr_provider then
    curr_provider._dimensions = { width = width, height = height }
  end

  get_styled_content(result.lines, state.width)
  create_window(state.width, state.height, opts)
  set_filetype(result.filetype)
end

return {
  load_hover = load_hover,
  create_hover = create_hover,
  resize_window = resize_window,
  focus_or_close_hover = focus_or_close_hover,
}
