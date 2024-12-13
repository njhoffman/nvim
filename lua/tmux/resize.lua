local layout = require("tmux.layout")
local keymaps = require("tmux.keymaps")
local nvim = require("tmux.wrapper.nvim")
local options = require("tmux.configuration.options")
local tmux = require("tmux.wrapper.tmux")

--return true if there is no other nvim window in the direction of @border
local function is_only_window(border)
  if border == "h" or border == "l" then
    --check for other horizontal window
    return (nvim.winnr("1h") == nvim.winnr("1l"))
  else
    --check for other vertical window
    return (nvim.winnr("1j") == nvim.winnr("1k"))
  end
end

local function is_tmux_target(border)
  if not tmux.is_tmux then
    return false
  end
  return not layout.is_border(border) or is_only_window(border)
end

local state = {
  timer = nil,
  augroup_id = nil,
  last_resize = nil,
  aucmd_id = nil,
}
state.augroup_id = vim.api.nvim_create_augroup("tmux-resize", {
  clear = true,
})

local M = {}
function M.setup()
  if options.resize.enable_default_keybindings then
    keymaps.register("n", {
      ["<A-h>"] = [[<cmd>lua require'tmux'.resize_left()<cr>]],
      ["<A-j>"] = [[<cmd>lua require'tmux'.resize_bottom()<cr>]],
      ["<A-k>"] = [[<cmd>lua require'tmux'.resize_top()<cr>]],
      ["<A-l>"] = [[<cmd>lua require'tmux'.resize_right()<cr>]],
    })
  end
end

function M.disable_animation()
  local timer_delay = 1000
  if state.aucmd_id == nil then
    state.aucmd_id = vim.api.nvim_create_autocmd("WinResized", {
      group = state.augroup_id,
      buffer = vim.api.nvim_get_current_buf(),
      callback = function()
        state.last_resize = vim.fn.reltime()
      end,
    })
  end
  if vim.g.minianimate_disable ~= true then
    -- vim.dbglog("-- disable animation")
    vim.g.minianimate_disable = true
    if state.timer == nil or not state.timer:is_active() then
      state.timer = vim.loop.new_timer()
      state.timer:start(100, timer_delay, function()
        vim.schedule(function()
          if
            state.last_resize ~= nil
            and vim.fn.reltimefloat(vim.fn.reltime(state.last_resize)) > (timer_delay / 1000)
          then
            vim.g.minianimate_disable = false
            state.aucmd_id = vim.api.nvim_del_autocmd(state.aucmd_id)
            state.last_resize = nil
            state.timer:stop()
            state.timer:close()
            state.timer = nil
            -- vim.dbglog("++ enable animation")
          end
        end)
      end)
    end
  end
end

function M.get_horizontal_state()
  local state = {
    curr_win = vim.fn.winnr(),
    left_win = vim.fn.winnr("h"),
    right_win = vim.fn.winnr("l"),
    left_tmux = is_tmux_target("h"),
    right_tmux = is_tmux_target("l"),
    step_size = options.resize.resize_step_x,
    -- left_border = nvim.is_nvim_border("h"),
    -- right_border = nvim.is_nvim_border("l"),
  }
  state = vim.tbl_deep_extend("force", state, {
    left_split = state.curr_win ~= state.left_win,
    right_split = state.curr_win ~= state.right_win,
  })
  return state
end

function M.to_left()
  M.disable_animation()
  local state = M.get_horizontal_state()
  if state.left_split then
    vim.fn.win_move_separator(state.left_win, -state.step_size)
  elseif state.right_split then
    vim.fn.win_move_separator(state.curr_win, -state.step_size)
  elseif state.left_tmux then
    tmux.resize("h", state.step_size)
  elseif state.right_tmux then
    tmux.resize("l", state.step_size)
  else
    nvim.resize("x", "-", state.step_size)
  end
end

function M.to_right()
  M.disable_animation()
  local state = M.get_horizontal_state()
  if state.left_split then
    vim.fn.win_move_separator(state.left_win, state.step_size)
  elseif state.right_split then
    vim.fn.win_move_separator(state.curr_win, state.step_size)
  elseif state.left_tmux then
    tmux.resize("l", state.step_size)
  elseif state.right_tmux then
    tmux.resize("h", state.step_size)
  else
    nvim.resize("x", "+", state.step_size)
  end
end

function M.get_vertical_state()
  local state = {
    curr_win = vim.fn.winnr(),
    down_win = vim.fn.winnr("j"),
    up_win = vim.fn.winnr("k"),
    down_tmux = is_tmux_target("j"),
    up_tmux = is_tmux_target("k"),
    step_size = options.resize.resize_step_y,
    -- down_border = nvim.is_nvim_border("h"),
    -- up_border = nvim.is_nvim_border("l"),
  }
  state = vim.tbl_deep_extend("force", state, {
    down_split = state.curr_win ~= state.down_win,
    up_split = state.curr_win ~= state.up_win,
  })
  return state
end

function M.to_bottom()
  vim.g.minianimate_disable = true
  local state = M.get_vertical_state()
  if state.top_split then
    vim.fn.win_move_separator(state.top_win, state.step_size)
  elseif state.bottom_split then
    vim.fn.win_move_separator(state.curr_win, state.step_size)
  elseif state.top_tmux then
    tmux.resize("j", state.step_size)
  elseif state.bottom_tmux then
    tmux.resize("k", state.step_size)
  else
    nvim.resize("y", "-", state.step_size)
  end
  vim.g.minianimate_disable = false
end

function M.to_top()
  vim.g.minianimate_disable = true
  local state = M.get_vertical_state()
  if state.top_split then
    vim.fn.win_move_separator(state.top_win, state.step_size)
  elseif state.bottom_split then
    vim.fn.win_move_separator(state.curr_win, state.step_size)
  elseif state.top_tmux then
    tmux.resize("j", state.step_size)
  elseif state.bottom_tmux then
    tmux.resize("k", state.step_size)
  else
    nvim.resize("y", "+", state.step_size)
  end
  vim.g.minianimate_disable = false
end

return M
