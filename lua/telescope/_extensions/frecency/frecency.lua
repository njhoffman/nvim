local finders = require('telescope.finders')
local Path = require('plenary.path')
local pickers = require('telescope.pickers')
local sorters = require('telescope.sorters')

local frecency = function(user_opts)
  local config = require('telescope._extensions.frecency.config')
  local state = require('telescope._extensions.frecency.state')
  local futil = require('telescope._extensions.frecency.util')
  local db_client = require('telescope._extensions.frecency.db_client')

  local os_home = vim.uv.os_homedir()
  local opts = config.setup(user_opts)

  local display = require('telescope._extensions.frecency.display').init(opts)

  -- start the database client
  db_client.init(
    opts.db_root,
    opts.ignore_patterns,
    vim.nonnil(opts.db_safe_mode, true),
    vim.nonnil(opts.auto_validate, true)
  )

  state.previous_buffer = vim.fn.bufnr('%')
  state.cwd = vim.fn.expand(opts.cwd or vim.fn.getcwd())

  futil.fetch_lsp_workspaces(state.previous_buffer)

  if not opts.path_display then
    opts.path_display = function(path_opts, filename)
      local original_filename = filename

      filename = Path:new(filename):make_relative(path_opts.cwd)
      if not state.active_filter then
        if vim.startswith(filename, os_home) then
          filename = '~/' .. Path:new(filename):make_relative(os_home)
        elseif filename ~= original_filename then
          filename = './' .. filename
        end
      end

      return filename
    end
  end

  local update_results = function(filter)
    local filter_updated = false

    -- validate tag
    local ws_dir = filter and state.user_workspaces[filter]
    if filter == 'LSP' and not vim.tbl_isempty(state.lsp_workspaces) then
      ws_dir = state.lsp_workspaces[1]
    end

    if filter == 'CWD' then
      ws_dir = state.cwd
    end

    if ws_dir ~= state.active_filter then
      filter_updated = true
      state.active_filter = ws_dir
      state.active_filter_tag = filter
    end

    if vim.tbl_isempty(state.results) or db_client.has_updated_results() or filter_updated then
      state.results = db_client.get_file_scores(state.show_unindexed, ws_dir)
    end
    return filter_updated
  end

  -- populate initial results
  update_results()

  local entry_maker = function(entry)
    return {
      filename = entry.filename,
      display = display.make_display,
      ordinal = entry.filename,
      name = entry.filename,
      score = entry.score,
    }
  end

  local delim = opts.filter_delimiter or ':'
  local filter_re = '^%s*(' .. delim .. '(%S+)' .. delim .. ')'

  local sorter = opts.sorter or sorters.get_generic_fuzzy_sorter
  -- local sorter = opts.sorter or sorters.get_generic_fuzzy_sorter
  -- local sorter = opts.sorter or sorters.get_substr_matcher
  -- local sorter = opts.sorter or sorters.fuzzy_with_index_bias

  state.picker = pickers.new(opts, {
    prompt_title = 'Frecency',
    on_input_filter_cb = function(query_text)
      -- check for :filter: in query text
      local matched, new_filter = query_text:match(filter_re)
      if matched then
        query_text = query_text:sub(matched:len() + 1)
      end
      new_filter = new_filter or opts.workspace or state.default_workspace

      local new_finder
      local results_updated = update_results(new_filter)
      if results_updated then
        state.last_filter = new_filter
        new_finder = finders.new_table({
          results = state.results,
          entry_maker = entry_maker,
        })
        -- print(vim.inspect(new_finder))
      end

      return { prompt = query_text, updated_finder = new_finder }
    end,
    attach_mappings = function(prompt_bufnr, map)
      require('telescope.actions').select_default:replace_if(function()
        local compinfo = vim.fn.complete_info()
        return compinfo.pum_visible == 1
      end, function()
        local compinfo = vim.fn.complete_info()
        local keys = compinfo.selected == -1 and '<C-e><Bs><Right>' or '<C-y><Right>:'
        local accept_completion = vim.api.nvim_replace_termcodes(keys, true, false, true)
        vim.api.nvim_feedkeys(accept_completion, 'n', true)
      end)

      for mode, tbl in pairs(opts.mappings) do
        for key, action in pairs(tbl) do
          map(mode, key, action)
        end
      end
      return true
    end,
    finder = finders.new_table({
      results = state.results,
      entry_maker = entry_maker,
    }),
    previewer = require('telescope.config').values.file_previewer(opts),
    sorter = sorter(opts),
  })
  state.picker:find()

  vim.api.nvim_set_option_value('filetype', 'TelescopePrompt', { buf = state.picker.prompt_bufnr })
  -- vim.api.nvim_buf_set_option(state.picker.prompt_bufnr, 'completefunc', 'frecency#FrecencyComplete')
  vim.api.nvim_buf_set_keymap(
    state.picker.prompt_bufnr,
    'i',
    '<Tab>',
    "pumvisible() ? '<C-n>'  : '<C-x><C-u>'",
    { expr = true, noremap = true }
  )
  vim.api.nvim_buf_set_keymap(
    state.picker.prompt_bufnr,
    'i',
    '<S-Tab>',
    "pumvisible() ? '<C-p>'  : ''",
    { expr = true, noremap = true }
  )
end

return frecency
