local opts = {
  create_keymaps = true, -- Creates default keymappings - see above
  move_to_debugline = false, -- When adding a debug line, moves the cursor to that line
  display_counter = true, -- Whether to display/include the monotonically increasing counter in each debug message added
  display_snippet = true, -- Whether to include a snippet of the line above/below in plain debug lines
  filetypes = {
    "bash",
    "c",
    "cpp",
    "dart",
    "go",
    "javascript",
    "lua",
    "make",
    "python",
    "ruby",
    "rust",
    "sh",
    "typescript",
    "vim",
    "zsh",
  },
  ignore_treesitter = false, --Never use treesitter to find a variable under the cursor, always prompt for it - overrides the same setting on debugprint() if set to true
  print_tag = "DEBUGPRINT", --	The string inserted into each print statement, which can be used to uniquely identify statements inserted by debugprint.
}

require("debugprint").setup(opts)

-- Mode             	 Default Keymap/Command 	 Purpose                                                                                                                           	 Equivalent Lua Function
-- Normal           	 g?p                    	 Insert a 'plain' debug line appropriate to the filetype just below the current line                                               	 require('debugprint').debugprint()
-- Normal           	 g?P                    	 The same, but above the current line                                                                                              	 require('debugprint').debugprint({above = true})
-- Normal           	 g?v                    	 Insert a variable debugging line below the current line. If the cursor is on a variable name, use that, otherwise prompt for one. 	 require('debugprint').debugprint({variable = true})
-- Normal           	 g?V                    	 The same, but above the current line                                                                                              	 require('debugprint').debugprint({above = true, variable = true})
-- Normal           	 None by default        	 Always prompt for a variable name, and insert a debugging line just below the current line which outputs it                       	 require('debugprint').debugprint({ignore_treesitter = true, variable = true})
-- Normal           	 None by default        	 Always prompt for a variable name, and insert a debugging line just above the current line which outputs it                       	 require('debugprint').debugprint({ignore_treesitter = true, above = true, variable = true})
-- Visual           	 g?v                    	 Find the visually select variable name, and insert a debugging line just below the current line which outputs it                  	 require('debugprint').debugprint({variable = true})
-- Visual           	 g?v                    	 Find the visually select variable name, and insert a debugging line just below the current line which outputs it                  	 require('debugprint').debugprint({variable = true})
-- Operator-pending 	 g?o                    	 Locate a variable using a motion, and insert a debugging line just above the current line which outputs it                        	 require('debugprint').debugprint({above = true, variable = true})
-- Operator-pending 	 g?O                    	 Locate a variable using a motion, and insert a debugging line just above the current line which outputs it                        	 require('debugprint').debugprint({above = true, variable = true})
-- Command          	 :DeleteDebugPrints     	 Delete all debug lines added to this buffer.                                                                                      	 require('debugprint').deleteprints()
