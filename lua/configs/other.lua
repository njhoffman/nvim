local transformers = require('other-nvim.builtin.transformers')

local default_cfg = {
  -- by default there are no mappings enabled
  mappings = {},

  -- default transformers
  transformers = {
    camelToKebap = transformers.camelToKebap,
    kebapToCamel = transformers.kebapToCamel,
    pluralize = transformers.pluralize,
    singularize = transformers.singularize,
  },

  -- Should the window show files which do not exist yet based on
  -- pattern matching. Selecting the files will create the file.
  showMissingFiles = true,

  -- When a mapping requires an initial selection of the other file, this setting controls,
  -- wether the selection should be remembered for the current user session.
  -- When this option is set to false reference between the two buffers are never saved.
  -- Existing references can be removed on the buffer with :OtherClear
  rememberBuffers = true,

  keybindings = {
    ['<cr>'] = 'open_file_by_command()',
    ['<esc>'] = 'close_window()',
    t = 'open_file_tabnew()',
    o = 'open_file()',
    q = 'close_window()',
    v = 'open_file_vs()',
    s = 'open_file_sp()',
  },

  hooks = {
    -- This hook which is executed when the file-picker is shown.
    -- It could be used to filter or reorder the files in the filepicker.
    -- The function must return a lua table with the same structure as the input parameter.
    --
    -- The input parameter "files" is a lua table with each entry containing:
    -- @param table (filename (string), context (string), exists (boolean))
    -- @return table | boolean When an empty table or false is returned the filepicker is not openend.
    filePickerBeforeShow = function(files)
      return files
    end,

    -- This hook is called whenever a file is about to be opened.
    -- One example how this can be used: a non existing file needs to be opened by another plugin, which provides a template.
    --
    -- @param filename (string) the full-path of the file
    -- @param exists (boolean) doess the file already exist
    -- @return (boolean) When true (default) the plugin takes care of opening the file, when the function returns false this indicated that opening of the file is done in the hook.
    onOpenFile = function(filename, exists)
      return true
    end,
  },

  style = {
    -- How the plugin paints its window borders
    -- Allowed values are none, single, double, rounded, solid and shadow
    border = 'solid',

    -- Column seperator for the window
    seperator = '|',

    -- Indicator showing that the file does not yet exist
    newFileIndicator = '(* new *)',

    -- width of the window in percent. e.g. 0.5 is 50%, 1 is 100%
    width = 0.7,

    -- min height in rows.
    -- when more columns are needed this value is extended automatically
    minHeight = 2,
  },
}

local ts_mappings = {
  {
    pattern = '(.*).ts',
    target = {
      { target = '%1.spec.ts', context = 'test' },
      { target = '%1.test.ts', context = 'test' },
    },
  },
  {
    pattern = '(.*).spec.ts',
    target = '%1.ts',
    context = 'test',
  },
  {
    pattern = '(.*).test.ts',
    target = '%1.ts',
    context = 'test',
  },
  {
    pattern = '/(.*)/(.*).ts',
    target = {
      { target = '/test/%1/%2.ts', context = 'test' },
    },
  },
  {
    pattern = '/src/(.*)/(.*).ts$',
    target = '/src/%1/%2\\(*.css\\|*.scss\\)',
    context = 'style',
  },
}

local js_mappings = {
  {
    pattern = '/src/app/(.*)/.*.js$',
    target = '/src/app/%1/%1.component.html',
    context = 'component',
  },
  {
    pattern = '/src/app/(.*)/.*.html$',
    target = '/src/app/%1/%1.component.js',
    context = 'view',
  },
  {
    pattern = '/src/app/(.*)/.*.js$',
    target = '/src/app/%1/%1.component.html',
    context = 'component',
  },
  {
    pattern = '/src/app/(.*)/.*.spec.js$',
    target = '/src/app/%1/%1.component.html',
    context = 'test',
  },
  {
    pattern = '/src/(.*)/.*.js$',
    target = '/src/%1/\\(*.css\\|*.scss\\)',
    context = 'style',
  },
}

local angular_mappings = {
  {
    pattern = '/(.*)/(.*)/([a-zA-Z-_]*).*.ts$',
    target = {
      {
        target = '/%1/%2/%3.component.html',
        context = 'html',
      },
      {
        target = '/%1/%2/%3.component.scss',
        context = 'scss',
      },
      {
        target = '/%1/%2/%3.component.spec.ts',
        context = 'test',
      },
    },
  },
  {
    pattern = '/(.*)/(.*)/([a-zA-Z-_]*).*html$',
    target = {
      {
        target = '/%1/%2/%3.component.ts',
        context = 'component',
      },
      {
        target = '/%1/%2/%3.component.scss',
        context = 'scss',
      },
      {
        target = '/%1/%2/%3.component.spec.ts',
        context = 'test',
      },
    },
  },
  {
    pattern = '/(.*)/(.*)/([a-zA-Z-_]*).*scss$',
    target = {
      {
        target = '/%1/%2/%3.component.html',
        context = 'html',
      },
      {
        target = '/%1/%2/%3.component.ts',
        context = 'component',
      },
      {
        target = '/%1/%2/%3.component.spec.ts',
        context = 'test',
      },
    },
  },
  {
    pattern = '/(.*)/(.*)/([a-zA-Z-_]*).*spec.ts$',
    target = {
      {
        target = '/%1/%2/%3.component.html',
        context = 'html',
      },
      {
        target = '/%1/%2/%3.component.scss',
        context = 'scss',
      },
      {
        target = '/%1/%2/%3.component.ts',
        context = 'component',
      },
    },
  },
  {
    pattern = '/(.*)/(.*).service.ts$',
    target = {
      {
        target = '/%1/%2.service.spec.ts',
        context = 'test',
      },
    },
  },
  {
    pattern = '/(.*)/(.*).service.spec.ts$',
    target = {
      {
        target = '/%1/%2.service.ts',
        context = 'service',
      },
    },
  },
}

local php_mappings = {
  {
    pattern = '/app/Http/Controllers/(.*)Controller.php$',
    target = '/resources/views/%1/',
    context = 'controller',
    transformer = 'camelToKebap',
  },
  {
    pattern = '/resources/views/(.*)/.*',
    target = '/app/Http/Controllers/%1Controller.php',
    context = 'view',
    transformer = 'kebapToCamel',
  },
}

local lua_mappings = {
  -- {
  --   context = 'lua main module',
  --   pattern = '.*.lua$',
  --   target = '.*/init.lua',
  -- },
  -- {
  --   context = "file of same name, but in different directory",
  --   pattern = ".*/(.-)$",
  --   target = ".*/%1",
  -- },
  {
    pattern = '(.*)/(.*).spec.lua$',
    target = '%1/%2.lua',
    context = 'implementation',
  },
  {
    pattern = '(.*)/(.*).test.lua$',
    target = '%1/%2.lua',
    context = 'implementation',
  },
  {
    pattern = '(.*)/(.*).lua$',
    target = {
      { target = '%1/%2.spec.lua', context = 'test' },
      { target = '%1/%2.test.lua', context = 'test' },
    },
  },
}

local cfg = {
  -- keybindings = {
  --   ['<cr>'] = 'open_file_by_command()',
  --   ['<esc>'] = 'close_window()',
  --   t = 'open_file_tabnew()',
  --   o = 'open_file()',
  --   q = 'close_window()',
  --   v = 'open_file_vs()',
  --   s = 'open_file_sp()',
  -- },
  style = {
    -- How the plugin paints its window borders
    border = 'rounded',
  },
  mappings = {
    'livewire',
    -- 'angular',
    'laravel',
    'rails',
    'golang',
    {
      pattern = '/path/to/file/src/app/(.*)/.*.ext$',
      target = '/path/to/file/src/view/%1/',
      transformer = 'lowercase',
    },
    unpack(lua_mappings),
    unpack(ts_mappings),
    unpack(js_mappings),
  },
  rememberBuffers = true,
  transformers = {
    lowercase = function(inputString)
      return inputString:lower()
    end,
  },
}

require('other-nvim').setup(cfg)

vim.api.nvim_set_keymap(
  'n',
  '<leader>fa',
  '<cmd>:Other<CR>',
  { noremap = true, silent = true, desc = 'l open other' }
)
-- vim.api.nvim_set_keymap('n', '<leader>ftn', '<cmd>:OtherTabNew<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap(
  'n',
  '<leader>fN',
  '<cmd>:OtherSplit<CR>',
  { noremap = true, silent = true, desc = 'l other split' }
)
vim.api.nvim_set_keymap(
  'n',
  '<leader>fV',
  '<cmd>:OtherVSplit<CR>',
  { noremap = true, silent = true, desc = 'l other vsplit' }
)
vim.api.nvim_set_keymap(
  'n',
  '<leader>fc',
  '<cmd>:OtherClear<CR>',
  { noremap = true, silent = true, desc = 'l other clear' }
)

-- Context specific bindings
vim.api.nvim_set_keymap(
  'n',
  '<leader>ft',
  '<cmd>:Other test<CR>',
  { noremap = true, silent = true, desc = 'l open other test context' }
)

-- vim.api.nvim_set_keymap(
--   'n',
--   '<leader>fS',
--   '<cmd>:Other scss<CR>',
--   { noremap = true, silent = true }
--
