local Config = require('mini.surround.Config')
local H = require('mini.surround.surround')
local state = require('mini.surround.state')

-- Module definition ==========================================================
local MiniSurround = {}

--- Module setup
---
---@param user_config table|nil Module config table. See |MiniSurround.config|.
---
---@usage `require('mini.surround').setup({})` (replace `{}` with your `config` table)
MiniSurround.setup = function(user_config)
  -- Export module
  _G.MiniSurround = MiniSurround

  -- Setup config
  local config = Config.setup_config(user_config)

  -- Apply config
  Config.apply_config(config)

  -- Create default highlighting
  Config.create_default_hl()
end

-- Module functionality =======================================================
--- Add surrounding
---
--- No need to use it directly, everything is setup in |MiniSurround.setup|.
---
---@param mode string Mapping mode (normal by default).
MiniSurround.add = function(mode)
  -- Needed to disable in visual mode
  if Config.is_disabled() then
    return '<Esc>'
  end

  -- Get marks' positions based on current mode
  local marks = H.get_marks_pos(mode)

  -- Get surround info. Try take from cache only in not visual mode (as there
  -- is no intended dot-repeatability).
  local surr_info
  if mode == 'visual' then
    surr_info = H.get_surround_spec('output', false)
  else
    surr_info = H.get_surround_spec('output', true)
  end
  if surr_info == nil then
    return '<Esc>'
  end

  -- Extend parts based on provided `[count]` before operator (if this is not
  -- from dot-repeat and was done already)
  if not surr_info.did_count then
    local count = Config.cache.count or vim.v.count1
    surr_info.left, surr_info.right = surr_info.left:rep(count), surr_info.right:rep(count)
    surr_info.did_count = true
  end

  -- Add surrounding.
  -- Possibly deal with linewise and blockwise addition separately
  local respect_selection_type = Config.get_config().respect_selection_type

  if not respect_selection_type or marks.selection_type == 'charwise' then
    -- Begin insert from right to not break column numbers
    -- Insert after the right mark (`+ 1` is for that)
    H.region_replace(
      { from = { line = marks.second.line, col = marks.second.col + 1 } },
      surr_info.right
    )
    H.region_replace({ from = marks.first }, surr_info.left)

    -- Set cursor to be on the right of left surrounding
    H.set_cursor(marks.first.line, marks.first.col + surr_info.left:len())

    return
  end

  if marks.selection_type == 'linewise' then
    local from_line, to_line = marks.first.line, marks.second.line

    -- Save current range indent and indent surrounded lines
    local init_indent = H.get_range_indent(from_line, to_line)
    H.shift_indent('>', from_line, to_line)

    -- Put cursor on the start of first surrounded line
    H.set_cursor_nonblank(from_line)

    -- Put surroundings on separate lines
    vim.fn.append(to_line, init_indent .. surr_info.right)
    vim.fn.append(from_line - 1, init_indent .. surr_info.left)

    return
  end

  if marks.selection_type == 'blockwise' then
    -- NOTE: this doesn't work with mix of multibyte and normal characters, as
    -- well as outside of text lines.
    local from_col, to_col = marks.first.col, marks.second.col
    -- - Ensure that `to_col` is to the right of `from_col`. Can be not the
    --   case if visual block was selected from "south-west" to "north-east".
    from_col, to_col = math.min(from_col, to_col), math.max(from_col, to_col)

    for i = marks.first.line, marks.second.line do
      H.region_replace({ from = { line = i, col = to_col + 1 } }, surr_info.right)
      H.region_replace({ from = { line = i, col = from_col } }, surr_info.left)
    end

    H.set_cursor(marks.first.line, from_col + surr_info.left:len())

    return
  end
end

--- Delete surrounding
---
--- No need to use it directly, everything is setup in |MiniSurround.setup|.
MiniSurround.delete = function()
  -- Find input surrounding region
  local surr = H.find_surrounding(H.get_surround_spec('input', true))
  if surr == nil then
    return '<Esc>'
  end

  -- Highlight input surrounding region
  local config = Config.get_config()
  state.buf_id = vim.api.nvim_get_current_buf()
  if config.highlight_input then
    H.region_highlight(state.buf_id, surr.left)
    H.region_highlight(state.buf_id, surr.right)
    vim.cmd('redraw')
  end

  -- Delete surrounding region. Begin with right to not break column numbers.
  H.region_replace(surr.right, {})
  H.region_replace(surr.left, {})

  -- Unhighlight input surrounding region
  -- Without it, undo will highlight the region again
  if config.highlight_input then
    H.region_unhighlight(state.buf_id, surr.left)
    H.region_unhighlight(state.buf_id, surr.right)
  end

  -- Set cursor to be on the right of deleted left surrounding
  local from = surr.left.from
  H.set_cursor(from.line, from.col)

  -- Possibly tweak deletion of linewise surrounding, should act as reverse to linewise addition.
  if not Config.get_config().respect_selection_type then
    return
  end

  local from_line, to_line = surr.left.from.line, surr.right.from.line
  local is_linewise_delete = from_line < to_line
    and H.is_line_blank(from_line)
    and H.is_line_blank(to_line)
  if is_linewise_delete then
    -- Dedent surrounded lines
    H.shift_indent('<', from_line, to_line)

    -- Place cursor on first surrounded line
    H.set_cursor_nonblank(from_line + 1)

    -- Delete blank lines left after deleting surroundings
    state.buf_id = vim.api.nvim_get_current_buf()
    vim.fn.deletebufline(state.buf_id, to_line)
    vim.fn.deletebufline(state.buf_id, from_line)
  end
end

--- Replace surrounding
---
--- No need to use it directly, everything is setup in |MiniSurround.setup|.
MiniSurround.replace = function()
  -- Find input surrounding region
  local surr = H.find_surrounding(H.get_surround_spec('input', true))
  if surr == nil then
    return '<Esc>'
  end

  -- Highlight input surrounding region
  local config = Config.get_config()
  state.buf_id = vim.api.nvim_get_current_buf()

  if config.highlight_input then
    H.region_highlight(state.buf_id, surr.left)
    H.region_highlight(state.buf_id, surr.right)
    vim.cmd('redraw')
  end

  -- Get output surround info
  local new_surr_info = H.get_surround_spec('output', true)

  -- Unhighlight input surrounding region
  if config.highlight_input then
    H.region_unhighlight(state.buf_id, surr.left)
    H.region_unhighlight(state.buf_id, surr.right)
  end

  -- Abort if no output surround info
  if new_surr_info == nil then
    return '<Esc>'
  end

  -- Replace by parts starting from right to not break column numbers
  H.region_replace(surr.right, new_surr_info.right)
  H.region_replace(surr.left, new_surr_info.left)

  -- Set cursor to be on the right of left surrounding
  local from = surr.left.from
  H.set_cursor(from.line, from.col + new_surr_info.left:len())
end

--- Find surrounding
---
--- No need to use it directly, everything is setup in |MiniSurround.setup|.
MiniSurround.find = function()
  -- Find surrounding region
  local surr = H.find_surrounding(H.get_surround_spec('input', true))
  if surr == nil then
    return '<Esc>'
  end

  -- Highlight input surrounding region
  local config = Config.get_config()
  local buf_id = vim.api.nvim_get_current_buf()
  if config.highlight_input then
    H.region_highlight(buf_id, surr.left)
    H.region_highlight(buf_id, surr.right)
    vim.defer_fn(function()
      H.region_unhighlight(buf_id, surr.left)
      H.region_unhighlight(buf_id, surr.right)
    end, config.highlight_duration)
  end

  -- Make array of unique positions to cycle through
  local pos_array = H.surr_to_pos_array(surr)

  -- Cycle cursor through positions
  local dir = Config.cache.direction or 'right'
  H.cursor_cycle(pos_array, dir)

  -- Open 'enough folds' to show cursor
  vim.cmd('normal! zv')
end

--- Highlight surrounding
---
--- No need to use it directly, everything is setup in |MiniSurround.setup|.
MiniSurround.highlight = function()
  -- Find surrounding region
  local surr = H.find_surrounding(H.get_surround_spec('input', true))
  if surr == nil then
    return '<Esc>'
  end

  -- Setup config
  local config = Config.get_config()

  -- Highlight surrounding region
  H.region_highlight(state.buf_id, surr.left)
  H.region_highlight(state.buf_id, surr.right)

  vim.defer_fn(function()
    H.region_unhighlight(state.buf_id, surr.left)
    H.region_unhighlight(state.buf_id, surr.right)
  end, config.highlight_duration)
end

--- Generate common surrounding specifications
---
--- This is a table with two sets of generator functions: <input> and <output>
--- (currently empty). Each is a table with values being function generating
--- corresponding surrounding specification.
---
--- Example: >
---   local ts_input = require('mini.surround').gen_spec.input.treesitter
---   require('mini.surround').setup({
---     custom_surroundings = {
---       -- Use tree-sitter to search for function call
---       f = {
---         input = ts_input({ outer = '@call.outer', inner = '@call.inner' })
---       },
---     }
---   })
---
---@seealso |MiniAi.gen_spec|
MiniSurround.gen_spec = { input = {}, output = {} }

--- Treesitter specification for input surrounding
---
--- This is a specification in function form. When called with a pair of
--- treesitter captures, it returns a specification function outputting an
--- array of region pairs derived from <outer> and <inner> captures. It first
--- searches for all matched nodes of outer capture and then completes each one
--- with the biggest match of inner capture inside that node (if any). The result
--- region pair is a difference between regions of outer and inner captures.
---
--- In order for this to work, apart from working treesitter parser for desired
--- language, user should have a reachable language-specific 'textobjects'
--- query (see |vim.treesitter.query.get()| or |get_query()|, depending on your
--- Neovim version).
--- The most straightforward way for this is to have 'textobjects.scm' query
--- file with treesitter captures stored in some recognized path. This is
--- primarily designed to be compatible with plugin
--- 'nvim-treesitter/nvim-treesitter-textobjects', but can be used without it.
---
--- Two most common approaches for having a query file:
--- - Install 'nvim-treesitter/nvim-treesitter-textobjects'. It has curated and
---   well maintained builtin query files for many languages with a standardized
---   capture names, like `call.outer`, `call.inner`, etc.
--- - Manually create file 'after/queries/<language name>/textobjects.scm' in
---   your |$XDG_CONFIG_HOME| directory. It should contain queries with
---   captures (later used to define surrounding parts). See |lua-treesitter-query|.
--- To verify that query file is reachable, run (example for "lua" language)
--- `:lua print(vim.inspect(vim.treesitter.query.get_files('lua', 'textobjects')))`
--- (output should have at least an intended file).
---
--- Example configuration for function definition textobject with
--- 'nvim-treesitter/nvim-treesitter-textobjects' captures:
--- >
---   local ts_input = require('mini.surround').gen_spec.input.treesitter
---   require('mini.surround').setup({
---     custom_textobjects = {
---       f = ts_input({ outer = '@call.outer', inner = '@call.inner' }),
---     }
---   })
--- <
--- Notes:
--- - By default query is done using 'nvim-treesitter' plugin if it is present
---   (falls back to builtin methods otherwise). This allows for a more
---   advanced features (like multiple buffer languages, custom directives, etc.).
---   See `opts.use_nvim_treesitter` for how to disable this.
--- - It uses buffer's |filetype| to determine query language.
--- - On large files it is slower than pattern-based textobjects. Still very
---   fast though (one search should be magnitude of milliseconds or tens of
---   milliseconds on really large file).
---
---@param captures table Captures for outer and inner parts of region pair:
---   table with <outer> and <inner> fields with captures for outer
---   (`[left.form; right.to]`) and inner (`(left.to; right.from)` both edges
---   exclusive, i.e. they won't be a part of surrounding) regions. Each value
---   should be a string capture starting with `'@'`.
---@param opts table|nil Options. Possible values:
---   - <use_nvim_treesitter> - whether to try to use 'nvim-treesitter' plugin
---     (if present) to do the query. It implements more advanced behavior at
---     cost of increased execution time. Provides more coherent experience if
---     'nvim-treesitter-textobjects' queries are used. Default: `true`.
---
---@return function Function which returns array of current buffer region pairs
---   representing differences between outer and inner captures.
---
---@seealso |MiniSurround-surround-specification| for how this type of
---   surrounding specification is processed.
--- |get_query()| for how query is fetched in case of no 'nvim-treesitter'.
--- |Query:iter_captures()| for how all query captures are iterated in case of
---   no 'nvim-treesitter'.
--- |MiniAi.gen_spec.treesitter()| for similar 'mini.ai' generator.
MiniSurround.gen_spec.input.treesitter = function(captures, opts)
  opts = vim.tbl_deep_extend('force', { use_nvim_treesitter = true }, opts or {})
  captures = H.prepare_captures(captures)

  return function()
    -- Get array of matched treesitter nodes
    local has_nvim_treesitter = pcall(require, 'nvim-treesitter')
      and pcall(require, 'nvim-treesitter.query')
    local node_pair_querier = (has_nvim_treesitter and opts.use_nvim_treesitter)
        and H.get_matched_node_pairs_plugin
      or H.get_matched_node_pairs_builtin
    local matched_node_pairs = node_pair_querier(captures)

    -- Return array of region pairs
    return vim.tbl_map(function(node_pair)
      -- `node:range()` returns 0-based numbers for end-exclusive region
      local left_from_line, left_from_col, right_to_line, right_to_col = node_pair.outer:range()
      local left_from = { line = left_from_line + 1, col = left_from_col + 1 }
      local right_to = { line = right_to_line + 1, col = right_to_col }

      local left_to, right_from
      if node_pair.inner == nil then
        left_to = right_to
        right_from = H.pos_to_right(right_to)
        right_to = nil
      else
        local left_to_line, left_to_col, right_from_line, right_from_col = node_pair.inner:range()
        left_to = { line = left_to_line + 1, col = left_to_col + 1 }
        right_from = { line = right_from_line + 1, col = right_from_col }
        -- Take into account that inner capture should be both edges exclusive
        left_to, right_from = H.pos_to_left(left_to), H.pos_to_right(right_from)
      end

      return {
        left = { from = left_from, to = left_to },
        right = { from = right_from, to = right_to },
      }
    end, matched_node_pairs)
  end
end

return MiniSurround
