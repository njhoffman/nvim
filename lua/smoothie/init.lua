---@class Smoothie
---@field config SmoothieConfig
---@field state SmoothieState
---@field benchmark SmoothieBenchmark
local M = {}

---@class SmoothieConfig
---@field enabled boolean Enable smooth scrolling
---@field update_interval number Time between updates (ms)
---@field speed_constant_factor number Constant term of velocity curve
---@field speed_linear_factor number Linear term of velocity curve
---@field speed_exponentiation_factor number Exponent of power function
---@field break_on_reverse boolean Stop immediately on reverse direction
---@field redraw_at_finish boolean Force redraw when animation finishes
---@field hide_cursor boolean Hide cursor during scrolling (Neovim only)
---@field minimum_speed number Minimum scrolling speed (lines/sec)
---@field benchmark_enabled boolean Enable benchmarking
---@field use_visual_lines boolean Account for wrapped lines and visual decorations

---@class SmoothieState
---@field target_displacement number Lines remaining to scroll
---@field subline_position number Fractional line position
---@field timer_id number|nil Timer ID for animation
---@field cursor_movement boolean Is this a cursor movement (vs scroll)
---@field ctrl_f_invoked boolean Was Ctrl-F pressed
---@field scrolloffset number Current scrolloff value
---@field target_view table|nil Saved view state

-- Default configuration
M.config = {
  enabled = true,
  update_interval = 20,
  speed_constant_factor = 10,
  speed_linear_factor = 8,
  speed_exponentiation_factor = 0.9,
  break_on_reverse = true,
  redraw_at_finish = false,
  hide_cursor = true,
  minimum_speed = 0.9,
  benchmark_enabled = false,
  use_visual_lines = false,
}

-- Animation state
M.state = {
  target_displacement = 0,
  subline_position = 0.0,
  timer_id = nil,
  cursor_movement = false,
  ctrl_f_invoked = false,
  scrolloffset = 0,
  target_view = nil,
  target_winid = nil,
}

-- Load benchmarking module
M.benchmark = require("smoothie.benchmark")

---Run a function in the target window context if one is set, otherwise in current window.
---@param fn function
---@return any
local function in_target_win(fn)
  local winid = M.state.target_winid
  if winid and vim.api.nvim_win_is_valid(winid) then
    return vim.api.nvim_win_call(winid, fn)
  else
    return fn()
  end
end

---Setup smoothie with user configuration
---@param opts SmoothieConfig|nil
function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})

  -- Create highlight group for hidden cursor
  if M.config.hide_cursor then
    vim.api.nvim_set_hl(0, "SmoothieHiddenCursor", { reverse = true, blend = 100 })
    vim.api.nvim_create_autocmd("ColorScheme", {
      pattern = "*",
      callback = function()
        vim.api.nvim_set_hl(0, "SmoothieHiddenCursor", { reverse = true, blend = 100 })
      end,
    })
  end

  -- Setup autocommands
  M.setup_autocommands()
end

---Setup autocommands for leave events
function M.setup_autocommands()
  local augroup = vim.api.nvim_create_augroup("SmoothieLua", { clear = true })

  vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
    group = augroup,
    callback = function()
      if M.state.target_view then
        M.stop_moving()
      end
    end,
  })
end

---Hide cursor during scrolling
local function hide_cursor()
  if vim.opt.termguicolors:get() then
    if not vim.o.guicursor:find("SmoothieHiddenCursor") then
      M.state.saved_guicursor = vim.o.guicursor
      vim.opt.guicursor = "a:SmoothieHiddenCursor"
    end
  end
end

---Restore cursor after scrolling
local function unhide_cursor()
  if vim.o.guicursor == "a:SmoothieHiddenCursor" and M.state.saved_guicursor then
    vim.opt.guicursor = M.state.saved_guicursor
    M.state.saved_guicursor = nil
  end
end

---Execute command while preserving scroll and scrolloff
---@param command string
local function execute_preserving_scroll(command)
  local saved_scroll = vim.o.scroll
  local saved_scrolloff = vim.o.scrolloff

  if saved_scrolloff > 0 then
    vim.o.scrolloff = 0
  end

  vim.cmd(command)

  vim.o.scroll = saved_scroll
  if saved_scrolloff > 0 then
    vim.o.scrolloff = saved_scrolloff
  end
end

---Scroll window up by one line
---@return boolean true if cannot move higher
local function step_up()
  local line = vim.fn.line(".")

  if line > 1 or (M.config.use_visual_lines and vim.fn.winline() > 1) then
    if M.state.cursor_movement or (M.state.scrolloffset > 0 and vim.fn.line("$") - line < M.state.scrolloffset) then
      -- Use visual line movement if enabled
      if M.config.use_visual_lines then
        vim.cmd("normal! gk")
      else
        vim.cmd("normal! k")
      end
      return false
    end

    execute_preserving_scroll("normal! 1\x15") -- Ctrl-U
    return false
  else
    return true
  end
end

---Scroll window down by one line
---@return boolean true if cannot move lower
local function step_down()
  local initial_winline = vim.fn.winline()
  local line = vim.fn.line(".")
  local last_line = vim.fn.line("$")
  local at_bottom = line >= last_line

  -- When using visual lines, check screen position instead of line number
  if M.config.use_visual_lines then
    at_bottom = at_bottom and vim.fn.winline() >= vim.fn.winheight(0)
  end

  if not at_bottom then
    if M.state.cursor_movement or (M.state.scrolloffset > 0 and line < M.state.scrolloffset) then
      -- Use visual line movement if enabled
      if M.config.use_visual_lines then
        vim.cmd("normal! gj")
      else
        vim.cmd("normal! j")
      end
      return false
    end

    -- Handle folds (workaround for Neovim issue #13080)
    if not M.config.use_visual_lines then
      local fold_end = vim.fn.foldclosedend(".")
      if fold_end ~= -1 then
        vim.fn.cursor(fold_end, vim.fn.col("."))
      end
    end

    execute_preserving_scroll("normal! 1\x04") -- Ctrl-D

    if M.state.ctrl_f_invoked and vim.fn.winline() > initial_winline then
      execute_preserving_scroll("normal! \x05") -- Ctrl-E
    end

    return false
  else
    return true
  end
end

---Step many lines (negative = up, positive = down)
---@param lines number
---@return boolean true if hit buffer boundary
local function step_many(lines)
  local remaining = lines

  while remaining ~= 0 do
    if remaining < 0 then
      if step_up() then
        return true
      end
      remaining = remaining + 1
    elseif remaining > 0 then
      if step_down() then
        return true
      end
      remaining = remaining - 1
    end
  end

  return false
end

---Calculate scroll velocity
---@return number velocity in lines per second
local function compute_velocity()
  local displacement = M.state.target_displacement - M.state.subline_position
  local absolute_speed = M.config.speed_constant_factor
    + M.config.speed_linear_factor * math.pow(math.abs(displacement), M.config.speed_exponentiation_factor)

  if M.state.target_displacement < 0 then
    return -absolute_speed
  else
    return absolute_speed
  end
end

---Animation tick callback (inner, runs in target window context)
local function movement_tick_inner()
  -- Benchmark: record frame
  if M.config.benchmark_enabled then
    M.benchmark.record_frame()
  end

  if M.state.target_displacement == 0 then
    M.stop_moving()
    return
  end

  local velocity = compute_velocity()
  local subline_step_size = M.state.subline_position + (M.config.update_interval / 1000.0 * velocity)
  local step_size = math.floor(subline_step_size)

  -- Clamp to prevent overshooting
  if math.abs(step_size) > math.abs(M.state.target_displacement) then
    step_size = M.state.target_displacement
  end

  if step_many(step_size) then
    -- Hit buffer boundary
    M.stop_moving()
  else
    M.state.target_displacement = M.state.target_displacement - step_size
    M.state.subline_position = subline_step_size - step_size
  end

  if step_size ~= 0 and M.state.cursor_movement then
    vim.cmd("redraw")
  end
end

---Animation tick callback (dispatches to target window if set)
local function movement_tick()
  -- If target window became invalid, stop
  if M.state.target_winid and not vim.api.nvim_win_is_valid(M.state.target_winid) then
    M.stop_moving()
    return
  end
  in_target_win(movement_tick_inner)
end

---Start smooth scrolling animation
function M.start_moving()
  -- Calculate scrolloffset
  if vim.o.scrolloff > 0 then
    M.state.scrolloffset = math.min(vim.o.scrolloff, math.floor((vim.o.lines - 2) / 2))
  else
    M.state.scrolloffset = 0
  end

  -- Hide cursor if enabled
  if M.config.hide_cursor then
    hide_cursor()
  end

  -- Save view state
  M.state.target_view = in_target_win(vim.fn.winsaveview)

  -- Start timer if not already running
  if not M.state.timer_id then
    -- Benchmark: start operation
    if M.config.benchmark_enabled then
      M.benchmark.start_op(
        M.state.cursor_movement and "cursor" or "scroll",
        M.state.target_displacement
      )
    end

    vim.cmd("doautocmd User ScrollStart")

    M.state.timer_id = vim.fn.timer_start(M.config.update_interval, movement_tick, { ["repeat"] = -1 })
  end
end

---Stop smooth scrolling animation
function M.stop_moving()
  -- Benchmark: end operation
  if M.config.benchmark_enabled then
    M.benchmark.end_op()
  end

  M.state.target_displacement = 0
  M.state.subline_position = 0.0

  if vim.o.scrolloff > 0 then
    M.state.scrolloffset = math.min(vim.o.scrolloff, math.floor((vim.o.lines - 2) / 2))
  else
    M.state.scrolloffset = 0
  end

  M.state.target_view = nil
  M.state.target_winid = nil

  if M.state.timer_id then
    vim.fn.timer_stop(M.state.timer_id)
    M.state.timer_id = nil
  end

  if M.config.redraw_at_finish then
    vim.cmd("mode")
  end

  if M.config.hide_cursor then
    unhide_cursor()
  end

  vim.cmd("doautocmd User ScrollStop")
end

---Update scroll target
---@param lines number lines to scroll (negative = up)
local function update_target(lines)
  if M.config.break_on_reverse and M.state.target_displacement * lines < 0 then
    M.stop_moving()
  else
    if M.state.cursor_movement then
      M.stop_moving()
    end

    M.state.target_displacement = M.state.target_displacement + lines
    M.start_moving()
  end
end

---Calculate screen lines between two lines (fold-aware)
---@param from number
---@param to number
---@return number
local function calculate_screen_lines(from, to)
  local from_line = from
  local to_line = to

  -- Handle folds
  local from_fold = vim.fn.foldclosed(from_line)
  if from_fold ~= -1 then
    from_line = from_fold
  end

  local to_fold = vim.fn.foldclosed(to_line)
  if to_fold ~= -1 then
    to_line = to_fold
  end

  if from_line == to_line then
    return 0
  end

  local lines = 0
  local current = from_line

  while current ~= to_line do
    if current < to_line then
      lines = lines + 1
      local fold_end = vim.fn.foldclosedend(current)
      if fold_end ~= -1 then
        current = fold_end
      end
      current = current + 1
    else
      lines = lines - 1
      local fold_start = vim.fn.foldclosed(current)
      if fold_start ~= -1 then
        current = fold_start
      end
      current = current - 1
    end
  end

  return lines
end

---Smooth scroll downwards (Ctrl-D)
---@param window_id number|nil Optional window ID to scroll (defaults to current window)
function M.downwards(window_id)
  M.state.target_winid = window_id
  in_target_win(function()
    if vim.fn.line(".") >= vim.fn.line("$") then
      M.state.target_winid = nil
      return
    end

    if not M.config.enabled then
      vim.cmd("normal! \x04") -- Ctrl-D
      M.state.target_winid = nil
      return
    end

    M.state.ctrl_f_invoked = false

    if vim.v.count > 0 then
      vim.o.scroll = vim.v.count
    end

    update_target(vim.o.scroll)
  end)
end

---Smooth scroll upwards (Ctrl-U)
---@param window_id number|nil Optional window ID to scroll (defaults to current window)
function M.upwards(window_id)
  M.state.target_winid = window_id
  in_target_win(function()
    if vim.fn.winline() <= 1 then
      M.state.target_winid = nil
      return
    end

    if not M.config.enabled then
      vim.cmd("normal! \x15") -- Ctrl-U
      M.state.target_winid = nil
      return
    end

    M.state.ctrl_f_invoked = false

    if vim.v.count > 0 then
      vim.o.scroll = vim.v.count
    end

    update_target(-vim.o.scroll)
  end)
end

---Smooth scroll forwards (Ctrl-F / Page Down)
---@param window_id number|nil Optional window ID to scroll (defaults to current window)
function M.forwards(window_id)
  M.state.target_winid = window_id
  in_target_win(function()
    if vim.fn.line(".") >= vim.fn.line("$") then
      M.state.target_winid = nil
      return
    end

    if not M.config.enabled then
      vim.cmd("normal! \x06") -- Ctrl-F
      M.state.target_winid = nil
      return
    end

    M.state.ctrl_f_invoked = true
    update_target(vim.fn.winheight(0) * math.max(vim.v.count, 1))
  end)
end

---Smooth scroll backwards (Ctrl-B / Page Up)
---@param window_id number|nil Optional window ID to scroll (defaults to current window)
function M.backwards(window_id)
  M.state.target_winid = window_id
  in_target_win(function()
    if vim.fn.winline() <= 1 then
      M.state.target_winid = nil
      return
    end

    if not M.config.enabled then
      vim.cmd("normal! \x02") -- Ctrl-B
      M.state.target_winid = nil
      return
    end

    M.state.ctrl_f_invoked = false
    update_target(-vim.fn.winheight(0) * math.max(vim.v.count, 1))
  end)
end

---Smooth cursor movement (gg, G, -)
---@param movement string Movement type ('gg', 'G', '-')
function M.cursor_movement(movement)
  local movements = {
    gg = {
      target_expr = "vim.v.count1",
      startofline = vim.o.startofline,
      jump_command = true,
    },
    G = {
      target_expr = "vim.v.count > 0 and vim.v.count or vim.fn.line('$')",
      startofline = vim.o.startofline,
      jump_command = true,
    },
    ["-"] = {
      target_expr = "vim.fn.line('.') - vim.v.count1",
      startofline = true,
      jump_command = false,
    },
  }

  local props = movements[movement]
  if not props then
    return
  end

  M.state.cursor_movement = true
  M.state.ctrl_f_invoked = false

  -- Disable in operator-pending mode
  local mode = vim.fn.mode(true)
  if not M.config.enabled or (mode:match("o") and mode:match("no")) then
    vim.cmd("normal! " .. (mode == "no" and "V" or "") .. vim.v.count .. movement)
    M.state.cursor_movement = false
    return
  end

  -- Calculate target line
  local target = loadstring("return " .. props.target_expr)()
  target = math.min(target, vim.fn.line("$"))

  local target_fold = vim.fn.foldclosed(target)
  if target_fold ~= -1 then
    target = target_fold
  end

  if vim.fn.foldclosed(".") == target then
    M.state.cursor_movement = false
    return
  end

  -- Add to jump list if this is a jump command
  if props.jump_command then
    vim.cmd("normal! m'")
  end

  -- Start animation
  local current_line = vim.fn.line(".")
  local screen_lines = calculate_screen_lines(current_line, target)

  -- Early exit if already at target
  if screen_lines == 0 then
    M.state.cursor_movement = false
    return
  end

  update_target(screen_lines)

  -- Wait for animation to complete with timeout
  local max_iterations = 10000 -- Prevent infinite loops
  local iterations = 0
  local last_line = vim.fn.line(".")
  local stuck_count = 0

  while vim.fn.line(".") ~= target and iterations < max_iterations do
    vim.cmd("sleep " .. M.config.update_interval .. "m")
    iterations = iterations + 1

    -- Detect if animation is stuck
    local curr_line = vim.fn.line(".")
    if curr_line == last_line then
      stuck_count = stuck_count + 1
      -- If stuck for more than 50 iterations, break out
      if stuck_count > 50 then
        M.stop_moving()
        break
      end
    else
      stuck_count = 0
      last_line = curr_line
    end

    -- Check if we've stopped moving (no active timer)
    if not M.state.timer_id then
      break
    end
  end

  M.state.cursor_movement = false

  -- Move to first non-blank if startofline is set
  if props.startofline then
    local line_text = vim.fn.getline(".")
    local first_nonblank = line_text:match("^%s*()%S") or 1
    vim.fn.cursor(vim.fn.line("."), first_nonblank)
  end
end

---Stop any active scrolling
function M.stop()
  if M.state.target_view then
    M.stop_moving()
  end
end

return M
