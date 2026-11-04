local cfg = {
  input = {
    win_options = {
      winblend = 15,
    },
    get_config = function(opts)
      if opts.input_options then
        return opts.input_options
      end
    end,
  },
  select = {
    backend = {
      'telescope',
      'nui',
    },
    telescope = require('telescope.themes').get_dropdown(),
    get_config = function(opts)
      if opts.select_options then
        return opts.select_options
      end
      if opts.kind == 'codeaction' then
        return {
          backend = 'nui',
          nui = {
            relative = 'cursor',
            max_width = 40,
          },
        }
      end
    end,
  },
}

require('dressing').setup(cfg)
--
-- vim.ui.input({opts}, {on_confirm})                            *vim.ui.input()*
--     Prompts the user for input, allowing arbitrary (potentially asynchronous)
--     work until `on_confirm`.
--
--     Example: >lua
--         vim.ui.input({ prompt = 'Enter value for shiftwidth: ' }, function(input)
--             vim.o.shiftwidth = tonumber(input)
--         end)
-- <
--
--     Parameters: ~
--       • {opts}        (table) Additional options. See |input()|
--                       • prompt (string|nil) Text of the prompt
--                       • default (string|nil) Default reply to the input
--                       • completion (string|nil) Specifies type of completion
--                         supported for input. Supported types are the same that
--                         can be supplied to a user-defined command using the
--                         "-complete=" argument. See |:command-completion|
--                       • highlight (function) Function that will be used for
--                         highlighting user inputs.
--       • {on_confirm}  (function) ((input|nil) -> ()) Called once the user
--                       confirms or abort the input. `input` is what the user
--                       typed (it might be an empty string if nothing was
--                       entered), or `nil` if the user aborted the dialog.

-- 		The optional `highlight` key allows specifying function which
-- 		will be used for highlighting user input.  This function
-- 		receives user input as its only argument and must return
-- 		a list of 3-tuples [hl_start_col, hl_end_col + 1, hl_group]
-- 		where
-- 			hl_start_col is the first highlighted column,
-- 			hl_end_col is the last highlighted column (+ 1!),
-- 			hl_group is |:hi| group used for highlighting.
-- 					      *E5403* *E5404* *E5405* *E5406*
-- 		Both hl_start_col and hl_end_col + 1 must point to the start
-- 		of the multibyte character (highlighting must not break
-- 		multibyte characters), hl_end_col + 1 may be equal to the
-- 		input length.  Start column must be in range [0, len(input)),
-- 		end column must be in range (hl_start_col, len(input)],
-- 		sections must be ordered so that next hl_start_col is greater
-- 		then or equal to previous hl_end_col.
--
-- 		Example (try some input with parentheses): >vim
-- 			highlight RBP1 guibg=Red ctermbg=red
-- 			highlight RBP2 guibg=Yellow ctermbg=yellow
-- 			highlight RBP3 guibg=Green ctermbg=green
-- 			highlight RBP4 guibg=Blue ctermbg=blue
-- 			let g:rainbow_levels = 4
-- 			function! RainbowParens(cmdline)
-- 			  let ret = []
-- 			  let i = 0
-- 			  let lvl = 0
-- 			  while i < len(a:cmdline)
-- 			    if a:cmdline[i] is# '('
-- 			      call add(ret, [i, i + 1, 'RBP' .. ((lvl % g:rainbow_levels) + 1)])
-- 			      let lvl += 1
-- 			    elseif a:cmdline[i] is# ')'
-- 			      let lvl -= 1
-- 			      call add(ret, [i, i + 1, 'RBP' .. ((lvl % g:rainbow_levels) + 1)])
-- 			    endif
-- 			    let i += 1
-- 			  endwhile
-- 			  return ret
-- 			endfunction
-- 			call input({'prompt':'>','highlight':'RainbowParens'})
-- <
-- 		Highlight function is called at least once for each new
-- 		displayed input string, before command-line is redrawn.  It is
-- 		expected that function is pure for the duration of one input()
-- 		call, i.e. it produces the same output for the same input, so
-- 		output may be memoized.  Function is run like under |:silent|
-- 		modifier. If the function causes any errors, it will be
-- 		skipped for the duration of the current input() call.
--

-- select format override
-- format_item_override = {
--      codeaction = function(action_tuple)
--        local title = action_tuple[2].title:gsub("\r\n", "\\r\\n")
--        local client = vim.lsp.get_client_by_id(action_tuple[1])
--        return string.format("%s\t[%s]", title:gsub("\n", "\\n"), client.name)
--      end,
--    }
--
-- vim.ui.select = function(...)
--   require('lazy').load({ plugins = { 'dressing.nvim' } })
--   return vim.ui.select(...)
-- end
--
-- vim.ui.input = function(...)
--   require('lazy').load({ plugins = { 'dressing.nvim' } })
--   return vim.ui.input(...)
-- end
