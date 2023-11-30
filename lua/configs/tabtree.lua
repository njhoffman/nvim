local default_cfg = {
  -- print the capture group name when executing next/previous
  --debug = true,

  -- disable key bindings
  --key_bindings_disabled = true,

  key_bindings = {
    next = '<Tab>',
    previous = '<S-Tab>',
  },

  -- use :InspectTree to discover the (capture group)
  -- @capture_name can be anything
  language_configs = {
    python = {
      target_query = [[
              (string) @string_capture
              (interpolation) @interpolation_capture
              (parameters) @parameters_capture
              (argument_list) @argument_list_capture
            ]],
      -- experimental feature, to move the cursor in certain situations like when handling python f-strings
      offsets = {
        string_start_capture = 1,
      },
    },
  },
  default_config = {
    target_query = [[
              (string) @string_capture
              (interpolation) @interpolation_capture
              (parameters) @parameters_capture
              (argument_list) @argument_list_capture
          ]],
    offsets = {},
  },
}

local default_query = {
  target_query = [[
    (string) @string_capture
    (interpolation) @interpolation_capture
    (parameters) @parameters_capture
    (argument_list) @argument_list_capture
    ]],
  offsets = {},
}

local cfg = {
  debug = false,
  key_bindings_disabled = false,
  key_bindings = {
    next = '<Tab>',
    previous = '<S-Tab>',
  },
  language_configs = {
    python = {
      target_query = [[
              (string) @string_capture
              (interpolation) @interpolation_capture
              (parameters) @parameters_capture
              (argument_list) @argument_list_capture
            ]],
      -- experimental feature, to move the cursor in certain situations like when handling python f-strings
      offsets = {
        string_start_capture = 1,
      },
    },
    lua = {
      target_query = [[
        (string) @string_capture
        (parameters) @parameters_capture
        (arguments) @argument_list_capture
      ]],
      offsets = {},
    },
    sh = default_query,
    javascript = default_query,
  },
  default_config = default_query,
}

require('tabtree').setup(cfg)
