local api = vim.api
local aucmd = api.nvim_create_autocmd
local user_cmd = api.nvim_create_user_command
local logger = require('reactive.logger')

local M = {
  listeners_initialized = nil,
}

-- stylua: ignore
local opfunc_list = {
  ['cx'] = 'v:lua.require"substitute.exchange".operator_callback',
  ['X']  = 'v:lua.require"substitute.exchange".operator_callback',
  ['S']  = 'v:lua.require"substitute".operator_callback',
  ['gc'] = 'v:lua.MiniComment.operator',
  ['s']  = 'v:lua.MiniSurround.add',
}

---@param line string
---@return string[]
local function parse_cmd(line)
  local cmd_parts = vim.split(vim.trim(line), '%s+')

  if cmd_parts[1]:find('Reactive') then
    table.remove(cmd_parts, 1)
  end

  if line:sub(-1) == ' ' then
    table.insert(cmd_parts, '')
  end

  return cmd_parts
end

M.commands = {
  -- todo:
  -- health = function() end,
  enable = function(preset)
    require('reactive.state'):enable_preset(preset)
  end,
  toggle = function(preset)
    require('reactive.state'):toggle_preset(preset)
  end,
  disable = function(preset)
    require('reactive.state'):disable_preset(preset)
  end,
}

M.cached_presets = {}

function M:init()
  local Highlight = require('reactive.highlight')
  local Snapshot = require('reactive.snapshot')

  local function init_listeners()
    if self.listeners_initialized then
      return
    end
    self.listeners_initialized = true

    local group = api.nvim_create_augroup('reactive.nvim', { clear = true })
    local virtual_op = vim.v.operator
    local current_mode = vim.fn.mode()
    local last_mode = nil
    local last_op = nil
    local last_opfunc = nil

    aucmd('ModeChanged', {
      group = group,
      pattern = '*:*',
      desc = 'Reactive: watches for mode changes to update highlights and run callbacks',
      callback = function(opts)
        local op = vim.v.operator
        local op_func = Snapshot.current_opfunc
        local from, to = unpack(vim.split(opts.match, ':'))
        if last_mode ~= to or last_op ~= op or last_opfunc ~= op_func then
          logger.debug(
            'ModeChanged  '
              .. from
              .. ':'
              .. to
              .. string.rep(' ', 5 - (#from + #to))
              .. (op and #op > 0 and (" '" .. tostring(op) .. "'") or '    ')
              .. (op_func and #op_func > 0 and (' [' .. tostring(op_func) .. ']') or '    ')
            -- .. (virtual_op and #virtual_op > 0 and (' "' .. tostring(virtual_op) .. '"') or '    ')
          )
          -- virtual_op = vim.v.operator
          Snapshot:set_modes(from, to)
          Highlight:apply(Snapshot:gen({ callbacks = true }))
          last_mode = to
          last_op = op
          last_opfunc = op_func
        end
      end,
    })

    vim.api.nvim_create_autocmd('User', {
      pattern = 'WhichKeyMode_*',
      desc = 'reactive watches for pseudo-mode changes from which-key to update highlights and run callbacks',
      callback = function(opts)
        local _, new_mode, keys = unpack(vim.split(opts.match, '_'))
        virtual_op = keys and #keys > 0 and keys:sub(1, 1)
        if last_mode ~= new_mode or last_op ~= virtual_op then
          logger.debug(
            'WhichKeyMode '
              .. current_mode
              .. ':'
              .. (new_mode and new_mode or ' ')
              .. string.rep(' ', 5 - (#current_mode + (new_mode and #new_mode or 0)))
              .. (virtual_op and #virtual_op > 0 and (" '" .. tostring(virtual_op) .. "'") or ' ')
              .. (keys and ' - ' .. keys or '')
          )
          -- vim.api.nvim_exec_autocmds('ModeChanged', { pattern = current_mode .. ':' .. new_mode })
          Snapshot:set_modes(current_mode, new_mode)
          current_mode = new_mode
          Highlight:apply(Snapshot:gen({ callbacks = true, virtual_op = virtual_op }))
          last_mode = new_mode
          last_op = virtual_op
        end
      end,
    })

    -- We need BufWinEnter event to successfully handle cases where you open a window
    -- then through telescope go to another one and then go back through Ctrl + o
    aucmd({ 'WinEnter', 'BufWinEnter', 'WinLeave' }, {
      group = group,
      desc = 'Reactive: applies active/inactive window highlights',
      callback = function(opts)
        Highlight:apply(Snapshot:gen({
          inactive_win = opts.event == 'WinLeave',
        }))
      end,
    })

    aucmd('ColorSchemePre', {
      group = group,
      desc = 'Reactive: removes cached highlights',
      callback = function()
        Snapshot:clear_cache()
      end,
    })
  end

  local function clear_listeners()
    if not self.listeners_initialized then
      return
    end
    self.listeners_initialized = nil

    vim.api.nvim_del_augroup_by_name('reactive.nvim')

    for hl in pairs(Snapshot.cache.applied_hl) do
      vim.cmd('highlight clear ' .. hl)
    end

    Snapshot:clear_cache()
  end

  local function toggle_listeners()
    if self.listeners_initialized then
      clear_listeners()
    else
      init_listeners()
    end
  end

  init_listeners()

  user_cmd('ReactiveStart', init_listeners, {})
  user_cmd('ReactiveStop', clear_listeners, {})
  user_cmd('ReactiveToggle', toggle_listeners, {})
  user_cmd('Reactive', function(opts)
    local cmd, val = unpack(vim.split(vim.trim(opts.args), '%s+'))

    if not self.commands[cmd] then
      vim.notify("reactive.nvim: There's no such a command: " .. cmd, vim.log.levels.ERROR)
    elseif not require('reactive.state').presets[val] then
      vim.notify("reactive.nvim: There's no such a preset: " .. val, vim.log.levels.ERROR)
    else
      self.commands[cmd](val)

      Highlight:apply(Snapshot:gen())
    end
  end, {
    complete = function(_, line)
      local cmd = parse_cmd(line)

      if #cmd == 1 then
        -- we only do this once
        if cmd[1] == '' then
          local State = require('reactive.state')
          local Util = require('reactive.util')

          self.cached_presets.toggle = {}
          self.cached_presets.enable = {}
          self.cached_presets.disable = {}

          Util.each(State.presets, function(name, preset)
            table.insert(self.cached_presets.toggle, name)

            if preset.lazy == true then
              table.insert(self.cached_presets.enable, name)
            else
              table.insert(self.cached_presets.disable, name)
            end
          end)
        end

        return vim.tbl_keys(M.commands)
      end

      if #cmd > 1 and M.commands[cmd[1]] then
        return self.cached_presets[cmd[1]]
      end
    end,
    nargs = '?',
  })
end

return M
