local keymaps = require("configs.debugprint.keymaps")

-- TODO: add capability to do premotions before output of debug line '%'
-- TODO: custom output with function
-- TODO: insert on print message action

local lua = {
  left = 'vim.dbglog("',
  right = '")',
  mid_var = '", ',
  right_var = ")",
  -- left = "print('",
  -- right = "')",
  -- mid_var = "' .. vim.inspect(",
  -- right_var = "))",
}

local setup_highlight_buffer = function(print_tag, bufnr)
  local success, module = pcall(require, "mini.hipatterns")

  if success then
    -- luacheck: ignore 122
    vim.b.minihipatterns_config = vim.tbl_deep_extend("keep", vim.b.minihipatterns_config or {}, {
      highlighters = {
        debugprint = {
          pattern = "%S.*" .. print_tag .. ".*",
          group = "DebugPrintLine",
        },
      },
    })

    module.enable(bufnr)
  end
end

local debughl = require("debugprint.highlight")
debughl.setup_highlight = function(filetypes, print_tag)
  if print_tag then
    vim.api.nvim_set_hl(0, "DebugPrintLine", { link = "Debug", default = true })

    vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
      callback = function(opts)
        if vim.api.nvim_buf_is_valid(opts.buf) then
          local buffer_filetype = vim.bo[opts.buf].filetype
          -- Automatically ignore 'bigfiles' as detected by snacks' bigfile
          -- support: https://github.com/folke/snacks.nvim/blob/main/docs/bigfile.md
          if buffer_filetype ~= "bigfile" and filetypes[buffer_filetype] ~= nil then
            setup_highlight_buffer(print_tag, opts.buf)
          end
        end
      end,
    })
  else
    vim.notify_once(
      "debugprint: highlight_lines is set, but there is no printtag, so nothing will be highlighted.",
      vim.log.levels.WARN
    )
  end
end

-- require('debugprint').add_custom_filetypes({ my_fileformat, ... })
-- marker is 0x1fa9a 🪚
-- stylua: ignore start
require('debugprint').setup({
  print_tag = '🪚' .. ' ',
  move_to_debugline = true,
  -- create_keymaps = false,
  -- create_commands = true,
  display_counter = true,
  display_snippet = false,
  keymaps = {
    normal = {
      plain_below = "",                    --  "g?p",
      plain_above = "",                    --  "g?P",
      variable_below = "",                 --  "g?v",
      variable_above = "",                 --  "g?V",
      variable_below_alwaysprompt = "",    --  "",
      variable_above_alwaysprompt = "",    --  "",
      surround_plain = "",                 --  "g?sp",
      surround_variable = "",              --  "g?sv",
      surround_variable_alwaysprompt = "", --  "",
      textobj_below = "",                  --  "g?o",
      textobj_above = "",                  --  "g?O",
      textobj_surround = "",               --  "g?so",
      toggle_comment_debug_prints = "",    --  "",
      delete_debug_prints = "",            --  "",
    },
    insert = {
      plain = "<C-G>p",
      variable = "<C-G>v",
    },
    visual = {
      variable_below = "", --  "g?v",
      variable_above = "", --  "g?V",
    },
  },
  commands = {
    toggle_comment_debug_prints = "DebugPrintCommentToggle",
    delete_debug_prints = "DebugPrintDelete",
    reset_debug_prints_counter = "DebugPrintCounterReset",
  },
  -- … Other options
})

require('debugprint').add_custom_filetypes({ lua = lua })
vim.api.nvim_create_user_command('DebugPrintDelete', function(opts)
  -- Note: you must set `range=true` and pass through opts for ranges to work
  require('debugprint').deleteprints(opts)
end, { range = true, desc = ' delete all debug statements' })

keymaps.setup_debugprint()
keymaps.setup_printing_press()
