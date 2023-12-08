local keymap = require('mapper').map
local filetypes = require('configs.debugprint.filetypes')

-- vim.dbglog("🪚 [2]: init.lua:7: lua=", lua)
-- vim.dbglog("🪚 lua: ", lua)

local setup_debugprint = function()
  -- stylua: ignore
  local keys = {
    remove         = 'god',
    remove_all     = 'goD',
    variable_below = 'goi',
    variable_above = 'goI',
    operator_below = 'goo',
    operator_above = 'goO',
    message_below  = 'gop',
    message_above  = 'goP',
  }

  keymap('n', keys.remove, function()
    require('debugprint').deleteprints()
  end, {
    label = '󰹝 delete debug',
    desc = '󰹝 delete debug statements in buffer',
  })

  keymap('n', keys.remove_all, function()
    require('debugprint').deleteprints()
  end, {
    label = '󰹝 delete all debug',
    desc = '󰹝 delete all debug statements in project',
  })

  -- Note: setting `expr=true` and returning the value are essential
  keymap({ 'n', 'x' }, keys.variable_below, function()
    return require('debugprint').debugprint({ variable = true })
  end, {
    expr = true,
    label = ' inspect var below',
    desc = ' inspect variable below cursor or await typed expression',
  })

  keymap({ 'n', 'x' }, keys.variable_above, function()
    return require('debugprint').debugprint({ variable = true, above = true })
  end, {
    expr = true,
    label = ' inspect var above',
    desc = ' inspect variable above cursor or await typed expression',
  })

  keymap('n', keys.operator_below, function()
    return require('debugprint').debugprint({ motion = true })
  end, {
    expr = true,
    label = ' inspect operator above',
    desc = ' inspect variable below with operator',
  })

  keymap('n', keys.operator_above, function()
    return require('debugprint').debugprint({ motion = true, above = true })
  end, {
    expr = true,
    label = ' inspect operator above',
    desc = ' inspect variable above with operator',
  })

  keymap('n', keys.message_below, function()
    return require('debugprint').debugprint()
  end, {
    expr = true,
    label = ' print message below',
    desc = ' print custom message below',
  })

  keymap('n', keys.message_above, function()
    return require('debugprint').debugprint({ above = true })
  end, {
    expr = true,
    label = ' print message above',
    desc = ' print custom message above',
  })

  -- local contextprint = require('debugprint.contextprint')
  -- contextprint.setup({ log = {
  --   typescript = 'console.log',
  -- } })
  --
  -- vim.keymap.set('n', 'goc', function()
  --   local tmp = 3
  --   contextprint.add_statement()
  -- end, { expr = true, desc = 'contextprint' })

  -- require('contextprint').setup({
  --     separator_char = "#",  // Global
  --     <filetype> = {
  --         separator = "#", // filetype specific
  --         query = [[ <language specific queries> ]]):format(),
  --         log = function(contents) to return print statement to insert
  --         type_defaults = vim.tbl_extend to change name defaults
  --     }
  -- })
  --
end

local setup_printing_press = function()
  -- local keymap = vim.keymap.set

  -- stylua: ignore start
  local orig = {
    message      = '<leader>lm',
    variable     = '<leader>ll',
    object       = '<leader>lo',
    beep         = '<leader>lb',
    time         = '<leader>l1',
    remove       = '<leader>lr',
    debug        = '<leader>ld',
    assert       = '<leader>la',
    inspect      = '<leader>li',
    inspect_tree = '<leader>lt',
  }

local keys = {
    -- message      = '<leader>fm', -- goi
    message      = 'gom', -- goi
    -- variable     = '<leader>fl', -- goi
    variable     = 'gov', -- goi
    object       = '<leader>fo', -- goi
    -- beep         = '<leader>fb', -- gob
    beep         = 'gob', -- gob
    -- time         = '<leader>f1', -- got
    time         = 'got', -- got
    remove       = '<leader>fr', -- goD
    debug        = '<leader>fd', --
    -- assert       = '<leader>fA', -- goa
    assert       = 'goa', --
  }

  local pp_path = "configs.debugprint.printing-press"

  keymap({ "n", "x" }, keys.message,
    function() require(pp_path).messageLog() end, { desc = " message log" })
  keymap({ "n", "x" }, keys.variable,
    function() require(pp_path).variableLog() end, { desc = " variable log" })
  keymap({ "n", "x" }, keys.object,
    function() require(pp_path).objectLog() end, { desc = " object log" })
  keymap("n", keys.beep,
    function() require(pp_path).beepLog() end, { desc = " beep log" })
  keymap("n", keys.time,
    function() require(pp_path).timeLog() end, { desc = " time log" })
  keymap("n", keys.remove,
    function() require(pp_path).removeLogs() end, { desc = "󰹝 remove log" })
  keymap("n", keys.debug,
    function() require(pp_path).debugLog() end, { desc = " debugger log" })
  keymap("n", keys.assert,
    function() require(pp_path).assertLog() end, { desc = " assert log" })
  -- stylua: ignore end
end

return {
  setup_debugprint = setup_debugprint,
  setup_printing_press = setup_printing_press,
}
