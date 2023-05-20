local rust_query = [[
    ;; query
    ((boolean_literal) @cap)
    ((string_literal) @cap)

    ; Identifiers
    ((identifier) @cap)
    ((field_identifier) @cap)
    ((field_expression) @cap)
    ((scoped_identifier) @cap)
    ((unit_expression) @cap)

    ; Types
    ((reference_type) @cap)
    ((primitive_type) @cap)
    ((type_identifier) @cap)
    ((generic_type) @cap)

    ; Calls
    ((call_expression) @cap)
]]

local c_query = [[
    ;; query
    ((string_literal) @cap)
    ((system_lib_string) @cap)

    ; Identifiers
    ((identifier) @cap)
    ((struct_specifier) @cap)
    ((type_identifier) @cap)
    ((field_identifier) @cap)
    ((number_literal) @cap)
    ((unary_expression) @cap)
    ((pointer_declarator) @cap)

    ; Types
    ((primitive_type) @cap)

    ; Expressions
    (assignment_expression
     right: (_) @cap)
]]

local cpp_query = [[
    ;; query

    ; Identifiers
    ((namespace_identifier) @cap)
]] .. c_query

local go_query = [[
    ;; query
    ((selector_expression) @cap) ; Method call
    ((field_identifier) @cap) ; Method names in interface

    ; Identifiers
    ((identifier) @cap)
    ((expression_list) @cap) ; pseudo Identifier
    ((int_literal) @cap)
    ((interpreted_string_literal) @cap)

    ; Types
    ((type_identifier) @cap)
    ((pointer_type) @cap)
    ((slice_type) @cap)

    ; Keywords
    ((true) @cap)
    ((false) @cap)
    ((nil) @cap)
]]

local lua_query = [[
            ;; query
            ((identifier) @cap)
            ("string_content" @cap)
            ((true) @cap)
            ((false) @cap)
        ]]
local python_query = [[
            ;; query
            ((identifier) @cap)
            ((string) @cap)
        ]]

local tsx_query = [[
    ;; query
    ((identifier) @cap)
    ((string_fragment) @cap)
    ((property_identifier) @cap)
]]

return {
  c_query = c_query,
  cpp_query = cpp_query,
  go_query = go_query,
  lua_query = lua_query,
  python_query = python_query,
  rust_query = rust_query,
  tsx_query = tsx_query,
}
