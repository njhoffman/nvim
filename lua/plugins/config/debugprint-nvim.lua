local opts = {
  create_keymaps = true, -- Creates default keymappings - see above
  move_to_debugline = false, -- When adding a debug line, moves the cursor to that line
  display_counter = true, -- Whether to display/include the monotonically increasing counter in each debug message added
  display_snippet = true, -- Whether to include a snppet of the line above/below in plain debug lines
  filetypes = {
    -- "bash",
    -- "c",
    -- "cpp",
    -- "dart", "go", "java",
    -- "javascript",
    -- "lua",
    -- "make",
    -- "python",
    -- "ruby",
    -- "rust",
    -- "sh",
    -- "typescript",
    -- "vim",
    -- "zsh",
  },
  ignore_treesitter = false, --Never use treesitter to find a variable under the cursor, always prompt for it - overrides the same setting on debugprint() if set to true
  print_tag = "DBG", --	The string inserted into each print statement, which can be used to uniquely identify statements inserted by debugprint.
}

require("debugprint").setup(opts)
-- print('DEBUGPRINT[4]: debugprint-nvim.lua:28: opts=' .. vim.inspect(opts))
vim.keymap.set("n", "g?d", function()
  require("debugprint").deleteprints()
end)

vim.keymap.set("n", "<Leader>dv", function()
  -- Note: setting `expr=true` and returning the value are essential
  return require("debugprint").debugprint({ variable = true })
end, { expr = true })

vim.keymap.set("n", "<Leader>dV", function()
  -- Note: setting `expr=true` and returning the value are essential
  return require("debugprint").debugprint({ variable = true, above = true })
end, { expr = true })

-- vim.api.nvim_create_user_command("DeleteDebugs", function(opts)
--   -- Note: you must set `range=true` and pass through opts for ranges to work
--   M.deleteprints(opts)
-- end, { range = true })

-- local my_fileformat = {
--   left = 'vim.dbglog(")',
--   right = '")',
--   mid_var = "${",
--   right_var = '}"',
-- }
--
-- require("debugprint").setup({ filetypes = { my_fileformat, another_of_my_fileformats, ... } })

-- Mode             	 Default Keymap      Purpose                                                                                                                           	 Equivalent Lua Function
-- Normal           	 g?p                 Insert a 'plain' debug line appropriate to the filetype just below the current line                                               	 require('debugprint').debugprint()
-- Normal           	 g?P                 The same, but above the current line                                                                                              	 require('debugprint').debugprint({above = true})
-- Normal           	 g?v                 Insert a variable debugging line below the current line. If the cursor is on a variable name, use that, otherwise prompt for one. 	 require('debugprint').debugprint({variable = true})
-- Normal           	 g?V                 The same, but above the current line                                                                                              	 require('debugprint').debugprint({above = true, variable = true})
-- Normal           	 None by default     Always prompt for a variable name, and insert a debugging line just below the current line which outputs it                       	 require('debugprint').debugprint({ignore_treesitter = true, variable = true})
-- Normal           	 None by default     Always prompt for a variable name, and insert a debugging line just above the current line which outputs it                       	 require('debugprint').debugprint({ignore_treesitter = true, above = true, variable = true})
-- Visual           	 g?v                 Find the visually select variable name, and insert a debugging line just below the current line which outputs it                  	 require('debugprint').debugprint({variable = true})
-- Visual           	 g?v                 Find the visually select variable name, and insert a debugging line just below the current line which outputs it                  	 require('debugprint').debugprint({variable = true})
-- Operator-pending 	 g?o                 Locate a variable using a motion, and insert a debugging line just above the current line which outputs it                        	 require('debugprint').debugprint({above = true, variable = true})
-- Operator-pending 	 g?O                 Locate a variable using a motion, and insert a debugging line just above the current line which outputs it                        	 require('debugprint').debugprint({above = true, variable = true})
-- Command          	 :DeleteDebugPrints  Delete all debug lines added to this buffer.                                                                                      	 require('debugprint').deleteprints()
