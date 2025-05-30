local utils = require("telescope.utils")
local parse = require("configs.telescope.which_key.parse")
-- TODO: get function name desc like get_registered_mappings
local get_default_mappings = function()
  -- local default_mappings = conf.mappings
  -- <Up> { [1] = "preview_scrolling_up" }
  -- <M-p> function: 0x7fd1b2a82b10
  -- <M-}> false
  -- for key, name in pairs(default_mappings.i) do
  --   local fname = _get_anon_function_name(vim.json.decode(mapping.desc:sub(12)))
  --   fname = fname:lower() == mapping.lhs:lower() and '<anonymous>' or fname
  --   vim.dbglog(key, name, fname)
  -- end

  -- stylua: ignore
  return {
    i = {
      ['<CR>']        = 'select_default',
      ['<C-Q>']       = 'send_to_qflist + open_qflist',
      ['<C-Down>']    = 'cycle_history_next',
      ['<C-G>']       = 'move_to_top',
      ['<C-Up>']      = 'cycle_history_prev',
      ['<C-^>']       = 'switch_layout',
      ['<C-B>']       = 'results_page_up',
      ['<C-F>']       = 'results_page_down',
      ['<C-D>']       = 'search_reset',
      ['<C-U>']       = 'search_backspace_word',
      ['<Esc>']       = 'close',
      ['<F47>']       = 'cycle_previewers_prev',
      ['<F48>']       = 'cycle_previewers_next',
      ['<M-/>']       = 'toggle_preview',
      ['<M-C-Space>'] = 'resume_picker_prev',
      ['<M-C-_>']     = 'toggle_whichkey',
      ['<M-a>']       = 'toggle_all',
      ['<M-b>']       = 'preview_scrolling_up',
      ['<M-c>']       = 'drop_all',
      ['<M-e>']       = 'launch_live_grep',
      ['<M-f>']       = 'preview_scrolling_down',
      ['<M-g>']       = 'launch_projects',
      ['<M-n>']       = 'results_toggle_down',
      ['<M-p>']       = 'results_toggle_up',
      ['<M-u>']       = 'launch_find_files',
      ['<C-Y>']       = 'yank_selection',
      ['<M-y>']       = 'yank_selection_to_buffer',
      ['<S-Tab>']     = 'move_selection_previous',
      ['<Tab>']       = 'move_selection_next',
      ['<C-P>']       = 'move_selection_previous',
      ['<C-N>']       = 'move_selection_next',
      ['<Down>']      = 'preview_scrolling_down',
      ['<Up>']        = 'preview_scrolling_up',
    },
    n = {
      ['<Esc>'] = 'close',
      --     desc = "toggle_selection + move_selection_worse",
      --     keybind = "<Tab>",
      --     desc = "select_default",
      --     keybind = "<CR>",
      --     desc = "close",
      --     keybind = "<Esc>",
      --     desc = "which_key",
      --     keybind = "?",
      --     desc = "move_to_bottom",
      --     keybind = "G",
      --     desc = "move_to_top",
      --     keybind = "H",
      --     mode = "n"
      --     desc = "move_to_bottom",
      --     keybind = "L",
      --     desc = "move_to_middle",
      --     keybind = "M",
      --     desc = "move_to_top",
      --     keybind = "gg",
      --     desc = "move_selection_next",
      --     keybind = "j",
      --     desc = "move_selection_previous",
      --     keybind = "k",
      --     desc = "select_tab",
      --     keybind = "<C-T>",
      --     desc = "send_to_qflist + open_qflist",
      --     keybind = "<C-Q>",
      --     desc = "send_selected_to_qflist + open_qflist",
      --     keybind = "<M-q>",
      --     desc = "select_horizontal",
      --     keybind = "<C-X>",
      --     desc = "select_vertical",
      --     keybind = "<C-V>",
      --     desc = "preview_scrolling_down",
      --     keybind = "<C-D>",
      --     desc = "results_scrolling_up",
      --     keybind = "<PageUp>",
      --     desc = "results_scrolling_down",
      --     keybind = "<PageDown>",
      --     desc = "move_selection_previous",
      --     keybind = "<Up>",
      --     desc = "move_selection_next",
      --     keybind = "<Down>",
      --     desc = "preview_scrolling_up",
      --     keybind = "<C-U>",
      -- }
    },
  }
end
--- Utility to collect mappings of prompt buffer in array of `{mode, keybind, name}`.
---@param prompt_bufnr number: The prompt bufnr
local function get_registered_mappings(prompt_bufnr)
  -- require('telescope.actions.utils').get_registered_mappings
  local ret = {}
  for _, mode in ipairs({ "n", "i" }) do
    local keymaps = vim.api.nvim_buf_get_keymap(prompt_bufnr, mode)
    for _, mapping in ipairs(keymaps) do
      -- ensure only telescope mappings
      if mapping.desc then
        if mapping.desc:sub(1, 10) == "telescope|" then
          table.insert(ret, { mode = mode, keybind = mapping.lhs, desc = mapping.desc:sub(11) })
        elseif mapping.desc:sub(1, 11) == "telescopej|" then
          local fname = parse._get_anon_function_name(vim.json.decode(mapping.desc:sub(12)))
          fname = fname:lower() == mapping.lhs:lower() and "<anonymous>" or fname
          table.insert(ret, {
            mode = mode,
            keybind = mapping.lhs,
            desc = fname,
          })
        end
      end
    end
  end
  return ret
end

local setup_mappings = function(prompt_bufnr, opts)
  local default_mappings = get_default_mappings()
  local mappings = {}
  local mode = vim.api.nvim_get_mode().mode
  for _, v in pairs(get_registered_mappings(prompt_bufnr)) do
    if v.desc and v.desc ~= "what_key" and v.desc ~= "nop" then
      if not opts.only_show_current_mode or mode == v.mode then
        table.insert(mappings, {
          custom = type(default_mappings[v.mode][v.keybind]) ~= "string",
          mode = v.mode,
          keybind = v.keybind,
          name = v.desc,
        })
        if v.desc == "<anonymous>" then
          utils.notify("actions.what_key", {
            msg = "No name available for anonymous functions.",
            level = "INFO",
            once = true,
          })
        end
      end
    end
  end

  table.sort(mappings, function(x, y)
    if x.name < y.name then
      return true
    elseif x.name == y.name then
      -- show normal mode as the standard mode first
      if x.mode > y.mode then
        return true
      else
        return false
      end
    else
      return false
    end
  end)
  return mappings
end

return { setup_mappings = setup_mappings }
