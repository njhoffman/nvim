--- Create the "default" (non-tinted) highlight namespace
---
---@param hl_group_name string
---@param hl_def table The highlight definition, see `:h nvim_set_hl`
local function set_default_ns(hl_group_name, hl_def)
  vim.api.nvim_set_hl(__.default_ns, hl_group_name, hl_def)
end

--- Create the "tinted" highlight namespace
---
---@param hl_group_name string
---@param hl_def table # highlight definition, see `:h nvim_set_hl`
local function set_synshade_ns(hl_group_name, hl_def)
  local ignored = hl_group_is_ignored(hl_group_name)
  local hl_group_info = { hl_group_name = hl_group_name }

  if hl_def.fg and not ignored then
    ---@diagnostic disable-next-line
    hl_def.fg = transforms.transform_color(
      hl_group_info,
      colors.get_hex(hl_def.fg),
      state.user_config.transforms
    )
  end

  if hl_def.sp and not ignored then
    ---@diagnostic disable-next-line
    hl_def.sp = transforms.transform_color(
      hl_group_info,
      colors.get_hex(hl_def.sp),
      state.user_config.transforms
    )
  end

  if state.user_config.tint_background_colors and hl_def.bg and not ignored then
    ---@diagnostic disable-next-line
    hl_def.bg = transforms.transform_color(
      hl_group_info,
      colors.get_hex(hl_def.bg),
      state.user_config.transforms
    )
  end

  vim.api.nvim_set_hl(__.synshade_ns, hl_group_name, hl_def)
end

--- Backwards compatibile (for now) method of getting highlights as nvim__get_hl_defs is removed in #22693
---
---@return table<string, any> # highlight definitions
local function get_global_highlights()
  ---@diagnostic disable-next-line: undefined-field
  return vim.api.nvim__get_hl_defs and vim.api.nvim__get_hl_defs(0) or vim.api.nvim_get_hl(0, {})
end

--- Setup color namespaces such that they can be set per-window
local function setup_namespaces()
  if not __.default_ns and not __.synshade_ns then
    __.default_ns = vim.api.nvim_create_namespace("_synshade_norm")
    __.synshade_ns = vim.api.nvim_create_namespace("_synshade_dim")
  end

  for hl_group_name, hl_def in pairs(get_global_highlights()) do
    -- Ensure we only have valid keys copied over
    hl_def = ensure_valid_hl_keys(hl_def)
    set_default_ns(hl_group_name, hl_def)
    set_synshade_ns(hl_group_name, hl_def)
  end
end

--- Ensure the passed table has only valid keys to hand to `nvim_set_hl`
---
---@param hl_def table Value returned by `nvim_get_hl_by_name` with `rgb` colors exported
---@return table # highlight definition with valid `nvim_set_hl` keys only
local function ensure_valid_hl_keys(hl_def)
  return {
    fg = hl_def.fg or hl_def.foreground,
    bg = hl_def.bg or hl_def.background,
    sp = hl_def.sp or hl_def.special,
    blend = hl_def.blend,
    bold = hl_def.bold,
    standout = hl_def.standout,
    underline = hl_def.underline,
    undercurl = hl_def.undercurl,
    underdouble = hl_def.underdouble,
    underdotted = hl_def.underdotted,
    underdashed = hl_def.underdashed,
    strikethrough = hl_def.strikethrough,
    italic = hl_def.italic,
    reverse = hl_def.reverse,
    nocombine = hl_def.nocombine,
    link = hl_def.link,
    default = hl_def.default,
    ctermfg = hl_def.ctermfg,
    ctermbg = hl_def.ctermbg,
    cterm = hl_def.cterm,
  }
end

--- Restore the global highlight namespace in all windows
local function restore_default_highlight_namespaces()
  iterate_all_windows(function(winid, _)
    vim.api.nvim_win_set_hl_ns(winid, 0)
  end)
end

--- Set the synshade highlight namespace in all unfocused windows
local function synshade_unfocused_windows()
  iterate_all_windows(function(winid, _)
    if winid ~= vim.api.nvim_get_current_win() and vim.api.nvim_win_is_valid(winid) then
      vim.api.nvim_win_call(winid, function()
        __.on_unfocus()
      end)
    end
  end)
end

--- Set the highlight namespace for a window
---
---@param winid number window handle
---@param hl_ns_id number namespace handle
local function set_window_hl_ns(winid, hl_ns_id)
  local existing = vim.w[winid].synshade_hl_ns_id
  if existing and existing == hl_ns_id then
    return
  end

  vim.api.nvim_win_set_var(winid, "synshade_hl_ns_id", hl_ns_id)
  vim.api.nvim_win_set_hl_ns(winid, hl_ns_id)
end
--- Refresh highlight namespaces, to be used after new highlight groups are added that need to be tinted
---
---@public
synshade.refresh = function()
  if not state.user_config then
    return
  end

  setup_namespaces()
end

--- Tint the specified window
---
---@public
---@param winid number a valid window handle
synshade.tint = function(winid)
  if not state.user_config or not vim.api.nvim_win_is_valid(winid) then
    return
  end

  set_window_hl_ns(winid, __.synshade_ns)
end

--- Untint the specified window
---
---@public
---@param winid number a valid window handle
synshade.untint = function(winid)
  if not state.user_config or not vim.api.nvim_win_is_valid(winid) then
    return
  end

  set_window_hl_ns(winid, __.default_ns)
end
