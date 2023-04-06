local symbol_highlights = {
  -- builtin
  Class = "TelescopeResultsClass",
  Constant = "TelescopeResultsConstant",
  Field = "TelescopeResultsField",
  Function = "TelescopeResultsFunction",
  Method = "TelescopeResultsMethod",
  Property = "TelescopeResultsOperator",
  Struct = "TelescopeResultsStruct",
  Variable = "TelescopeResultsVariable",

  -- lua
  String = "String",
  Boolean = "Constant",
  Package = "Keyword",
  Object = "Type",
  Number = "Number",
  Array = "@enum",

  -- Other Kinds
  Module = "PreProc",
  Interface = "@interface",
  Operator = "@operator",
  Enum = "@enum",
}

return symbol_highlights
