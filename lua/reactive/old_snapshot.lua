function M:gen(opts)
  local State = require('reactive.state')

  self.snapshot = { winhl = {}, hl = {} }

  -- if we're leaving a window, then we just color that window with `inactive` colors, if presented
  if opts and opts.inactive_win then
    State:iterate_presets(function(preset)
      local constraints = {}

      if
        preset.static
        and not vim.tbl_isempty(preset.static)
        and not self:process_constraints(preset.skip, constraints)
      then
        self:form_snapshot(preset.name, {
          winhl = preset.static.winhl and preset.static.winhl.inactive,
          hl = preset.static.hl,
        }, '@static.inactive', constraints)
      end
    end)

    return self.snapshot
  end

  local mode = self.to
  local mode_len = #mode

  -- store scopes of previous iterations
  local scope = {}

  local dropped_presets = {}
  local presets_len = State:count()

  local has_static = false

  Util.iterate_mode_reverse(mode, function(inc_mode, len)
    return State:iterate_presets(function(preset)
      if not preset.modes then
        return
      end

      if presets_len == vim.tbl_count(dropped_presets) then
        -- all presets are dropped, break the loop
        return true
      end

      -- initializing a scope
      if not scope[preset.name] then
        scope[preset.name] = {}
      end

      -- initializing constraints
      if not scope[preset.name].constraints then
        scope[preset.name].constraints = {}
      end

      local inc_mode_config = preset.modes[inc_mode]

      if dropped_presets[preset.name] or not inc_mode_config then
        return
      end

      if len == mode_len then
        if preset.static and not vim.tbl_isempty(preset.static) then
          has_static = true
        end

        -- we check `skip` method/table only on a first iteration
        if self:process_constraints(preset.skip, scope[preset.name].constraints) then
          dropped_presets[preset.name] = true

          return
        end

        self:merge_snapshot(preset.name, inc_mode, inc_mode_config, scope[preset.name].constraints)

        if len > 1 and inc_mode_config.exact then
          if type(inc_mode_config.exact) == 'boolean' then
            dropped_presets[preset.name] = true
          elseif type(inc_mode_config.exact) == 'table' then
            local stop = true

            for _, val in ipairs(shape_fields) do
              if not inc_mode_config.exact[val] then
                stop = false
                scope[preset.name].constraints = inc_mode_config.exact
                break
              end
            end

            if stop then
              dropped_presets[preset.name] = true
            end
          end
        end
      else
        -- we shouldn't mutate original constraints
        local local_constraints = vim.deepcopy(scope[preset.name].constraints)

        if type(inc_mode_config.frozen) == 'table' then
          local stop = true

          -- constraints are coming from the "exact", "frozen" and "skip" flags or absent initially
          -- if frozen + exact + skip constraint flags results in disabling all the possible
          -- shape fields, then we just skip this iteration
          Util.eachi(shape_fields, function(val)
            -- if a current constraint is true, then we shouldn't process this constraint at all
            if local_constraints[val] then
              return
            end
            -- if one of current + merged constraints is false then we shouldn't
            -- skip this iteration
            if not inc_mode_config.frozen[val] then
              stop = false
            else
              local_constraints[val] = true
            end
          end)

          if stop then
            -- just skip this iteration
            return
          end
        elseif inc_mode_config.frozen == true then
          -- if the 'frozen' flag passed as 'true' value, it shouldn't hoist at all
          return
        end

        self:merge_snapshot(preset.name, inc_mode, inc_mode_config, local_constraints)
      end
    end)
  end)

  if has_static or (opts and opts.callbacks) then
    State:iterate_presets(function(preset)
      if preset.static and not vim.tbl_isempty(preset.static) then
        self:form_snapshot(preset.name, {
          winhl = preset.static.winhl and preset.static.winhl.active,
          hl = preset.static.hl,
        }, '@static.active', scope[preset.name] and scope[preset.name].constraints or {})
      end

      if not opts or not opts.callbacks or not preset.modes or dropped_presets[preset.name] then
        return
      end

      if preset.modes[self.from] then
        if preset.modes[self.from].from then
          preset.modes[self.from].from({ from = self.from, to = self.to })
        end

        -- if preset.modes[self.from].on then
        --   preset.modes[self.from].on { from = self.from, to = self.to }
        -- end
      end

      if preset.modes[self.to] then
        if preset.modes[self.to].to then
          preset.modes[self.to].to({ from = self.from, to = self.to })
        end

        -- if preset.modes[self.to].on then
        --   preset.modes[self.to].on { from = self.from, to = self.to }
        -- end
      end
    end)
  end

  self.current_opfunc = nil
  self.current_op = nil

  return self.snapshot
end
---@param preset_name string
---@param inc_mode string
---@param inc_mode_config Reactive.ModeConfig
---@param constraints TriggerConstraints<boolean>
function M:merge_snapshot(preset_name, inc_mode, inc_mode_config, constraints)
  if Util.is_op(inc_mode) and inc_mode_config.operators then
    local op = self:get_op()

    if op and inc_mode_config.operators[op] then
      local opfunc = self:get_opfunc()
      if
        opfunc
        and inc_mode_config.operators[op].opfuncs
        and inc_mode_config.operators[op].opfuncs[opfunc]
      then
        self:form_snapshot(
          preset_name,
          inc_mode_config.operators[op].opfuncs[opfunc],
          ('@mode.%s.@op.g@.%s'):format(inc_mode, opfunc),
          constraints
        )
      end

      self:form({
        preset_name = opts.preset_name,
        highlights = opts.inc_mode_config,
        scope = ('@mode.%s'):format(opts.inc_mode),
        constraints = opts.constraints,
      })

      -- self:form_snapshot(
      --   preset_name,
      --   inc_mode_config.operators[op],
      --   ('@mode.%s.@op.%s'):format(inc_mode, op),
      --   constraints
      -- )
    end
  end

  self:form_snapshot(preset_name, inc_mode_config, ('@mode.%s'):format(inc_mode), constraints)
end
-- local merge_handlers = {
--   winhl = function(highlights, opts)
--     Util.each(highlights, function(hl_group, hl_val)
--       if M.snapshot.winhl[hl_group] then
--         return
--       end
--
--       local key = opts.preset_name .. opts.scope .. hl_group
--       local cached_hl = M.cache.transformed_winhl[key]
--
--       if not cached_hl then
--         local rhs = Util.transform_winhl(hl_group, hl_val, opts.scope)
--         -- collecting all transformed highlights so that we can clear them
--         -- if the "ReactiveDisable" autocmd is fired
--         M.cache.applied_hl[rhs] = true
--         -- since we don't want to transform a highlight group over and over again,
--         -- it's better to cache it once and then extract from the cache
--         M.cache.transformed_winhl[key] = rhs
--
--         M.snapshot.winhl[hl_group] = rhs
--       else
--         M.snapshot.winhl[hl_group] = cached_hl
--       end
--     end)
--   end,
--   hl = function(highlights)
--     for hl, val in pairs(highlights) do
--       if not M.snapshot.hl[hl] then
--         -- collecting all highlights so that we can clear them
--         -- if the "ReactiveDisable" autocmd is fired
--         M.cache.applied_hl[hl] = true
--         M.snapshot.hl[hl] = val
--       end
--     end
--   end,
-- }
