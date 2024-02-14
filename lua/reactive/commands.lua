local api = vim.api
local aucmd = api.nvim_create_autocmd
local user_cmd = api.nvim_create_user_command
local logger = require('reactive.logger')

local M = {
  listeners_initialized = nil,
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
  local Util = require('reactive.util')
  local function clear_winhighlight_options()
    local windows = vim.api.nvim_list_wins()
    Util.eachi(windows, function(win)
      Util.delete_reactive_winhl(win)
    end)
  end

  local function clear_highlights()
    for hl in pairs(Snapshot.cache.applied_hl) do
      vim.cmd('highlight clear ' .. hl)
    end
  end

  local function init_plugin()
    if self.listeners_initialized then
      return
    end
    self.listeners_initialized = true

    local group = api.nvim_create_augroup('reactive.nvim', { clear = true })
    local virtual_op = vim.v.operator
    local last_mode = vim.fn.mode()
    local last_op = nil
    local last_opfunc = nil

    aucmd('ModeChanged', {
      group = group,
      pattern = '*:*',
      desc = 'Reactive: watches for mode changes to update highlights and run callbacks',
      callback = function(opts)
        local op = virtual_op
        local op_func = Snapshot.get_opfunc()
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
          local snap = Snapshot:gen({ callbacks = true })

          Highlight:apply({
            hl = snap.hl,
            winhl = snap.winhl,
            winid = api.nvim_get_current_win(),
          })
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
        if keys and #keys > 0 then
          -- virtual_op = 'g@' .. keys
          virtual_op = keys
        end
        if last_mode ~= new_mode or last_op ~= virtual_op then
          logger.debug(
            'WhichKeyMode '
              .. last_mode
              .. ':'
              .. (new_mode or ' ')
              .. string.rep(' ', 5 - (#last_mode + (new_mode and #new_mode or 0)))
              .. (virtual_op and #virtual_op > 0 and (" '" .. tostring(virtual_op) .. "'") or ' ')
              .. (keys and ' - ' .. keys or '')
          )

          -- vim.api.nvim_exec_autocmds('ModeChanged', { pattern = current_mode .. ':' .. new_mode })
          --  TODO: or inc_mode_config['o'].operators[virtual_op] then

          Snapshot:set_modes(last_mode, new_mode)
          local snap = Snapshot:gen({
            callbacks = true,
            virtual_op = virtual_op,
          })

          Highlight:apply({
            hl = snap.hl,
            winhl = snap.winhl,
            winid = api.nvim_get_current_win(),
          })
          -- Highlight:apply(Snapshot:gen({ callbacks = true, virtual_op = virtual_op }))
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
        local snap = Snapshot:gen({ inactive_win = opts.event == 'WinLeave' })
        Highlight:apply({
          hl = snap.hl,
          winhl = snap.winhl,
          winid = api.nvim_get_current_win(),
        })
      end,
    })

    aucmd('ColorSchemePre', {
      group = group,
      desc = 'Reactive: removes cached highlights',
      callback = function()
        Snapshot:clear_cache()
        clear_winhighlight_options()
        Highlight:sync()
      end,
    })
  end

  local function stop_plugin()
    if not self.listeners_initialized then
      return
    end
    self.listeners_initialized = nil

    -- clear listeners
    vim.api.nvim_del_augroup_by_name('reactive.nvim')
    Snapshot:clear_cache()
    clear_highlights()
    clear_winhighlight_options()
  end

  local function toggle_listeners()
    if self.listeners_initialized then
      stop_plugin()
    else
      init_plugin()
    end
  end

  init_plugin()

  user_cmd('ReactiveStart', init_plugin, {})
  user_cmd('ReactiveStop', stop_plugin, {})
  user_cmd('ReactiveToggle', toggle_listeners, {})
  user_cmd('Reactive', function(opts)
    local cmd, val = unpack(vim.split(vim.trim(opts.args), '%s+'))

    if not self.commands[cmd] then
      vim.notify("reactive.nvim: There's no such a command: " .. cmd, vim.log.levels.ERROR)
    elseif not require('reactive.state').presets[val] then
      vim.notify("reactive.nvim: There's no such a preset: " .. val, vim.log.levels.ERROR)
    else
      self.commands[cmd](val)
    end
  end, {
    complete = function(_, line)
      local cmd = parse_cmd(line)

      if #cmd == 1 then
        -- we only do this once
        if cmd[1] == '' then
          local State = require('reactive.state')

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
