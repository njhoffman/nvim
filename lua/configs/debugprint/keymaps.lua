local setup_debugprint = function()
  vim.keymap.set('n', 'god', function()
    require('debugprint').deleteprints()
  end, { desc = 'delete all debug statements in buffer' })

  vim.keymap.set('n', 'goD', function()
    require('debugprint').deleteprints()
  end, { desc = 'delete all debug statements in project' })

  -- Note: setting `expr=true` and returning the value are essential
  vim.keymap.set({ 'n', 'v' }, 'goi', function()
    return require('debugprint').debugprint({ variable = true })
  end, { expr = true, desc = ' debug inspect variable below' })

  vim.keymap.set({ 'n', 'v' }, 'goI', function()
    return require('debugprint').debugprint({ variable = true, above = true })
  end, { expr = true, desc = ' debug inspect variable above' })

  vim.keymap.set('n', 'goo', function()
    return require('debugprint').debugprint({ motion = true })
  end, { expr = true, desc = ' debug inspect variable below with operator' })

  vim.keymap.set('n', 'goO', function()
    return require('debugprint').debugprint({ motion = true, above = true })
  end, { expr = true, desc = ' debug inspect variable above with operator' })

  vim.keymap.set('n', 'gop', function()
    return require('debugprint').debugprint()
  end, { expr = true, desc = ' debug print plain line below' })

  vim.keymap.set('n', 'goP', function()
    return require('debugprint').debugprint({ above = true })
  end, { expr = true, desc = ' debug print plain line above' })

  vim.keymap.set('n', 'got', function()
    return require('debugprint').debugprint()
  end, { expr = true, desc = ' print numbered timer below' })

  vim.keymap.set('n', 'goT', function()
    return require('debugprint').debugprint({ above = true })
  end, { expr = true, desc = ' print named timer below' })

  vim.api.nvim_create_user_command('DeleteDebugs', function(opts)
    -- Note: you must set `range=true` and pass through opts for ranges to work
    require('debugprint').deleteprints(opts)
  end, { range = true, desc = ' delete all debug statements' })

  local contextprint = require('debugprint.contextprint')

  contextprint.setup({ log = {
    typescript = 'console.log',
  } })

  vim.keymap.set('n', 'goc', function()
    local tmp = 3
    contextprint.add_statement()
  end, { expr = true, desc = 'contextprint' })

  -- require('contextprint').setup({
  --     separator_char = "#",  // Global
  --     <filetype> = {
  --         separator = "#", // filetype specific
  --         query = [[ <language specific queries> ]],
  --         log = function(contents) to return print statement to insert
  --         type_defaults = vim.tbl_extend to change name defaults
  --     }
  -- })
  --
end

local setup_printing_press = function()
  -- local keymap = vim.keymap.set
  local keymap = require('mapper').map

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
    message      = '<leader>fm', -- goi
    variable     = '<leader>fl', -- goi
    object       = '<leader>fo', -- goi
    beep         = '<leader>fb', -- gob
    time         = '<leader>f1', -- got
    remove       = '<leader>fr', -- goD
    debug        = '<leader>fd', --
    assert       = '<leader>fA', -- goa
    inspect      = '<leader>fi', -- goi
    inspect_tree = '<leader>fI', -- goI
  }

  keymap({ "n", "x" }, keys.message, function() require("configs.debugprint.printing-press").messageLog() end, { desc = " message log" })
  keymap({ "n", "x" }, keys.variable, function() require("configs.debugprint.printing-press").variableLog() end, { desc = " variable log" })
  keymap({ "n", "x" }, keys.object, function() require("configs.debugprint.printing-press").objectLog() end, { desc = " object log" })
  keymap("n", keys.beep, function() require("configs.debugprint.printing-press").beepLog() end, { desc = " beep log" })
  keymap("n", keys.time, function() require("configs.debugprint.printing-press").timeLog() end, { desc = " time log" })
  keymap("n", keys.remove, function() require("configs.debugprint.printing-press").removeLogs() end, { desc = "󰹝 remove log" })
  keymap("n", keys.debug, function() require("configs.debugprint.printing-press").debugLog() end, { desc = " debugger log" })
  keymap("n", keys.assert, function() require("configs.debugprint.printing-press").assertLog() end, { desc = " assert log" })
  -- stylua: ignore end

  keymap('n', keys.inspect, vim.cmd.Inspect, { desc = ' :Inspect' })
  keymap('n', keys.inspect_tree, vim.cmd.InspectTree, { desc = ' :InspectTree' })
end

return { setup_debugprint = setup_debugprint, setup_printing_press = setup_printing_press }
