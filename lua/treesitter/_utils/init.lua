---@alias node unknown
local parsers = require('nvim-treesitter.parsers')

---Wrapper to get treesitter root parser
---@return node|nil
local function get_root()
  local parser = parsers.get_parser()
  if parser == nil then
    return nil
  end

  return parser:parse()[1]:root()
end

---Return node of "parent" that has given "named" as name in nested node
---@param parent node
---@param named string
---@return node|nil
local function get_named_node(parent, named)
  for node, name in parent:iter_children() do
    if name == named then
      return node
    end

    -- some languages have deeply nested structures
    -- in "declarator" parts can exist as well
    if name == 'declarator' then
      local named_node = get_named_node(node, named)
      if named_node ~= nil then
        return named_node
      end

      -- when we are the furthest in the recursion and have an identifier, this can also be a function
      if node:type() == 'identifier' then
        return node
      end

      return nil
    end
  end
end

---Return node of "parent" that has given "typed" as type in nested node
---@param parent node
---@param typed string
---@return node|nil
local function get_typed_node(parent, typed)
  for node, name in parent:iter_children() do
    if node:type() == typed then
      return node
    end

    -- some languages have deeply nested structures
    -- in "declarator" parts can exist as well
    if name == 'declarator' then
      local typed_node = get_typed_node(node, typed)
      if typed_node ~= nil then
        return typed_node
      end

      return nil
    end
  end
end

---Get node information and construct a useable table out of it
---@param node node
---@return NodeInformation|nil
local function get_node_information(node)
  -- can be that some nodes have a not yet supported structure
  -- instead of crashing just ignore the node
  local function_name_node = get_named_node(node, 'name')

  -- for example cpp has som edge cases where a "name" named node won't be found
  if function_name_node == nil then
    -- Operator overloads
    function_name_node = get_typed_node(node, 'operator_name')
  end

  if function_name_node == nil then
    -- Reference return types
    local fd_node = get_typed_node(node, 'function_declarator')
    function_name_node = get_named_node(fd_node, 'identifier')
  end

  if function_name_node == nil then
    return nil
  end

  local function_name = vim.treesitter.get_node_text(function_name_node, 0)
  -- as fallback in case named node does not exist
  local line_content = vim.treesitter.get_node_text(node, 0)

  -- return line content in case we have no name (happens if there is no named node)
  function_name = function_name or line_content

  -- zero indexed
  local row, _, _ = node:start()
  local line_number = row + 1

  ---@class NodeInformation
  ---@field line_number number
  ---@field function_name string
  return { line_number = line_number, function_name = function_name }
end

---Some languages (e.g. cpp) might want more information about the scope of a function
---request them of a node and use this to append the node information
---@param node any
---@return string|nil
local function get_scope_information_of_node(node)
  local class_scope_node = get_named_node(node, 'scope')
  if class_scope_node ~= nil then
    local is_class_name = class_scope_node:type() == 'namespace_identifier'
      or class_scope_node:type() == 'template_type'

    if is_class_name then
      return vim.treesitter.get_node_text(class_scope_node, 0) .. '::'
    end
  end

  return nil
end

---Get all functions of the given "parent" node concatted into a table
---@param parent node
---@return NodeInformation[]
local function get_function_list_of_parent(parent)
  ---@type NodeInformation[]
  local content = {}

  if parent == nil then
    return content
  end

  for tsnode in parent:iter_children() do
    -- standard ways of declaring/defining functions
    local is_simple_function = tsnode:type() == 'function_declaration'
      or tsnode:type() == 'function_definition'
      or tsnode:type() == 'local_function'
      or tsnode:type() == 'method_definition'
      or tsnode:type() == 'method_declaration'
      or tsnode:type() == 'constructor_declaration'
      or tsnode:type() == 'function_item'

    if is_simple_function then
      local info = get_node_information(tsnode)

      -- enhance function name with scope information
      local node_scope = get_scope_information_of_node(tsnode)
      if node_scope ~= nil and info ~= nil then
        info.function_name = node_scope .. info.function_name
      end
      table.insert(content, info)
    end

    -- some functions might have the information in their parent (assigned variables)
    local is_parent_dependend_function = tsnode:type() == 'function_definition'
      or tsnode:type() == 'arrow_function'

    if is_parent_dependend_function then
      -- we want to name of the variable that it was assigned to -> parent
      -- if it has valuable information
      local parent_has_information = tsnode:parent():type() == 'variable_declarator'
        or tsnode:parent():type() == 'variable_declaration'

      if parent_has_information then
        local info = get_node_information(tsnode:parent())
        table.insert(content, info)
      end
    end

    -- these structures might include functions (arrow function, variable as function, classes, etc)
    local is_simple_recursive_structure = tsnode:type() == 'export_statement'
      or tsnode:type() == 'variable_declarator'
      or tsnode:type() == 'variable_declaration'
      or tsnode:type() == 'lexical_declaration'
      or tsnode:type() == 'template_declaration'
      or tsnode:type() == 'preproc_ifdef'
      or tsnode:type() == 'preproc_if'
      or tsnode:type() == 'preproc_else'

    if is_simple_recursive_structure then
      local info = get_function_list_of_parent(tsnode)

      for _, node_information in ipairs(info) do
        table.insert(content, node_information)
      end
    end

    -- structure that most likely have multiple functions internally
    local is_complex_recursive_structure = tsnode:type() == 'class_declaration'
      or tsnode:type() == 'namespace_declaration'
      or tsnode:type() == 'namespace_definition'
      or tsnode:type() == 'impl_item'
      or tsnode:type() == 'mod_item'

    if is_complex_recursive_structure then
      local structure_name_node = get_named_node(tsnode, 'name')
      if structure_name_node == nil then
        structure_name_node = get_typed_node(tsnode, 'type_identifier')
      end

      local structure_name = nil
      if structure_name_node ~= nil then
        structure_name = vim.treesitter.get_node_text(structure_name_node, 0)
      end

      -- body this might contain functions (methods)
      local body = get_named_node(tsnode, 'body')
      local info = get_function_list_of_parent(body)

      local separator = ' > '
      if tsnode:type() == 'namespace_definition' or tsnode:type() == 'impl_item' then
        separator = '::'
      end

      for _, node_information in ipairs(info) do
        -- append structure name infront of methods (or other structures)
        if structure_name ~= nil then
          node_information.function_name = structure_name
            .. separator
            .. node_information.function_name
        end

        table.insert(content, node_information)
      end
    end
  end

  return content
end

---Get biggest line number to align numbers evenly in rows
---@param info NodeInformation[]
---@return number
local function get_max_line_number_length(info)
  local max_line_number_length = 0
  for _, node_information in ipairs(info) do
    -- diagnostic is incorrect - probably version mismatch
    ---@diagnostic disable-next-line: param-type-mismatch
    local current_line_number_length = string.len(node_information.line_number)

    if current_line_number_length >= max_line_number_length then
      max_line_number_length = current_line_number_length
    end
  end

  return max_line_number_length
end

local M = {}

local ts_utils = require('nvim-treesitter.ts_utils')
local node_ns = vim.api.nvim_create_namespace('tree_climber_hlnode')
local node_timer
M.highlight_node = function(node, opts)
  vim.validate({
    node = { node, 'userdata', true },
    opts = { opts, 'table', true },
  })
  if node == nil then
    return
  end

  opts = opts or {}
  local on_macro = opts.on_macro or false
  local higroup = opts.higroup or 'IncSearch'
  local timeout = opts.timeout or 150

  if not on_macro and vim.fn.reg_executing() ~= '' then
    return
  end

  local bufnr = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_clear_namespace(bufnr, node_ns, 0, -1)
  if node_timer then
    node_timer:close()
  end

  ts_utils.highlight_node(node, bufnr, node_ns, higroup)
  node_timer = vim.defer_fn(function()
    node_timer = nil
    if vim.api.nvim_buf_is_valid(bufnr) then
      vim.api.nvim_buf_clear_namespace(bufnr, node_ns, 0, -1)
    end
  end, timeout)
end

---return the `field_name` of passed in *tsnode*
---@param node userdata
---@return string|nil
M.get_field_name_of_node = function(node)
  local parent = node:parent()

  for children, field_name in parent:iter_children() do
    if children == node then
      return field_name
    end
  end
end

---get top most *(below root)* `ts-node` from the current cursor position
---@return ts-node | nil
M.get_top_node_at_cursor = function()
  local node = ts_utils.get_node_at_cursor()
  local root = ts_utils.get_root_for_node(node)

  local parent = node:parent()
  while parent ~= nil and parent ~= root do
    node = parent
    parent = node:parent()
    if parent == root then
      return node
    end
  end

  return nil
end

--@class parent_nodes_at_cursor_opts
---@field include_current_node boolean

---return *nil* | **table of parent nodes** of current node at cursor
---table *includes current node at cursor* if `opts.include_current_node` is `truthy`
---@param opts parent_nodes_at_cursor_opts
---@return table | nil
M.get_parent_nodes_at_cursor = function(opts)
  local return_tbl = {}
  local node = ts_utils.get_node_at_cursor()

  local root = ts_utils.get_root_for_node(node)

  if opts.include_current_node and node then
    table.insert(return_tbl, node)
  end

  local parent = node:parent()
  while parent ~= nil and parent ~= root do
    node = parent
    parent = node:parent()
    table.insert(return_tbl, node)
    if parent == root then
      return return_tbl
    end
  end

  return nil
end
M.print_tree = function(root)
  local function pt(node, level)
    local tab = '|   '
    if not level then
      level = 0
    end
    local shift = string.rep(tab, level)
    local res = shift .. node:type() .. ' : ' .. vim.inspect({ node:range() }) .. '\n'
    local count = 0
    while node:named_child(count) do
      local next = node:named_child(count)
      res = res .. pt(next, level + 1)
      count = count + 1
    end
    return res
  end

  print(pt(root))
  return pt(root)
end

M.find_range_from_2nodes = function(nodeA, nodeB) --{{{
  local start_row_A, start_col_A, end_row_A, end_col_A = nodeA:range()
  local start_row_B, start_col_B, end_row_B, end_col_B = nodeB:range()

  local true_range = {}

  if start_row_A == start_row_B then
    if start_col_A < start_col_B then
      table.insert(true_range, start_row_A)
      table.insert(true_range, start_col_A)
    else
      table.insert(true_range, start_row_B)
      table.insert(true_range, start_col_B)
    end
  end

  if start_row_A < start_row_B then
    table.insert(true_range, start_row_A)
    table.insert(true_range, start_col_A)
  elseif start_row_A > start_row_B then
    table.insert(true_range, start_row_B)
    table.insert(true_range, start_col_B)
  end

  if end_row_A == end_row_B then
    if end_col_A > end_col_B then
      table.insert(true_range, end_row_A)
      table.insert(true_range, end_col_A)
    else
      table.insert(true_range, end_row_B)
      table.insert(true_range, end_col_B)
    end
  end
  if end_row_A > end_row_B then
    table.insert(true_range, end_row_A)
    table.insert(true_range, end_col_A)
  elseif end_row_A < end_row_B then
    table.insert(true_range, end_row_B)
    table.insert(true_range, end_col_B)
  end

  return true_range
end --}}}

M.get_node_at_cursor = function()
  local r, c = unpack(vim.api.nvim_win_get_cursor(0))
  vim.treesitter.get_parser(0):parse({ r - 1, c, r - 1, c })
  return vim.treesitter.get_node()
end

M.get_visual_node = function() --{{{
  local node = M.get_node_at_cursor() -- declare node and bufnr

  if node == nil then -- prevent errors
    return
  end

  local nodeA = node
  vim.cmd('normal! o')
  local nodeB = M.get_node_at_cursor()
  vim.cmd('normal! o')
  local root = ts_utils.get_root_for_node(node)

  if nodeA:id() ~= nodeB:id() then --> get the true node
    local true_range = M.find_range_from_2nodes(nodeA, nodeB)
    local parent = nodeA:parent()

    if not parent then
      return
    end
    if not parent.range then
      return
    end

    local start_row_P, start_col_P, end_row_P, end_col_P = parent:range()

    while
      start_row_P ~= true_range[1]
      or start_col_P ~= true_range[2]
      or end_row_P ~= true_range[3]
      or end_col_P ~= true_range[4]
    do
      if parent:parent() == nil then
        break
      end
      parent = parent:parent()
      start_row_P, start_col_P, end_row_P, end_col_P = parent:range()
    end

    node = parent
  end

  if node == root then -- catch some edge cases
    node = nodeA
  end

  local parent = node:parent() --> if parent only has 1 child, move up the tree
  while parent ~= nil and parent:named_child_count() == 1 do
    node = parent
    parent = node:parent()
  end

  return node
end --}}}
-- get language at location

M.get_pos_lang = function(node)
  local c = vim.api.nvim_win_get_cursor(0)
  local range = { c[1] - 1, c[2], c[1] - 1, c[2] }
  local buf = vim.api.nvim_get_current_buf()
  local ok, parser =
    pcall(vim.treesitter.get_parser, buf, vim.treesitter.language.get_lang(vim.bo[buf].ft))
  if not ok then
    return ''
  end
  local current_tree = parser:language_for_range(range)
  return current_tree:lang()
end

--- Find parent node of given type.
---@param node TSNode
---@param type string
---@return TSNode | nil
M.find_parent_node = function(node, type)
  if node == node:root() then
    return nil
  end
  if node:type() == type then
    return node
  end
  return M.find_parent_node(node:parent(), type)
end

--- Find child node of given type.
---@param node TSNode
---@param type string
---@return TSNode | nil
M.find_child_node = function(node, type)
  local child = node:child(0)
  while child do
    if child:type() == type then
      return child
    end
    child = child:next_sibling()
  end
  return nil
end

--- Set text of given node.
---@param node TSNode
---@param text string | table
---@param bufnr number | nil
M.set_node_text = function(node, text, bufnr)
  local sr, sc, er, ec = node:range()
  local content = { text }
  if type(text) == 'table' then
    content = text
  end
  vim.api.nvim_buf_set_text(bufnr or 0, sr, sc, er, ec, content)
end

--- Get text of given node.
---@param node TSNode
---@param bufnr number | nil
---@return string | string[]
M.get_node_text = function(node, bufnr)
  local sr, sc, er, ec = node:range()
  local text = vim.api.nvim_buf_get_text(bufnr or 0, sr, sc, er, ec, {})
  if #text == 1 then
    return text[1]
  end
  return text
end

---Global endpoint to get all functions of the current buffer
---structured into a table of multiple table informations
---@return NodeInformation[]
M.get_current_functions = function()
  local root = get_root()
  if root == nil then
    print('No Tressitter-parser found in the current buffer')
    return {}
  end

  local ok, content = pcall(get_function_list_of_parent, root)
  if not ok then
    print('Something went wrong in the current buffer')
    print('Current buffer might have unsuported language or syntax')
    return {}
  end

  -- sort content, it could have different order in some edge cases
  table.sort(content, function(a, b)
    return a.line_number < b.line_number
  end)

  return content
end

---Global endpoint to get all functions of the current buffer
---structured into a table of formatted strings for easy usage of a selector
---@alias FormattedInformation string[]
---@return FormattedInformation # example {"line_number:\t function", "123:\t foo", ...}
M.get_current_functions_formatted = function()
  ---@type FormattedInformation
  local res = {}
  local output = M.get_current_functions()

  local max_line_number_length = get_max_line_number_length(output)
  -- add 1 because we will add a ":" at the end of the number
  local line_number_formatting_string = '% ' .. (max_line_number_length + 1) .. 'd'

  -- every entry will be concatted into a string
  -- result: {"line_number:\t function", "123:\t foo", ...}
  for _, node_information in ipairs(output) do
    local space_aligned_line_number =
      string.format(line_number_formatting_string, node_information.line_number)
    local concatted_string = space_aligned_line_number .. ':\t' .. node_information.function_name

    table.insert(res, concatted_string)
  end

  return res
end

return M
