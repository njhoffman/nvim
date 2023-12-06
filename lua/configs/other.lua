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
    pattern = '/src/app/(.*)/.*.ts$',
    target = '/src/app/%1/%1.component.html',
    context = 'component',
  },
  {
    pattern = '/src/app/(.*)/.*.html$',
    target = '/src/app/%1/%1.component.ts',
    context = 'view',
  },
  {
    pattern = '/src/app/(.*)/.*.ts$',
    target = '/src/app/%1/%1.component.html',
    context = 'component',
  },
  {
    pattern = '/src/app/(.*)/.*.spec.ts$',
    target = '/src/app/%1/%1.component.html',
    context = 'test',
  },
  {
    pattern = '/src/(.*)/.*.ts$',
    target = '/src/%1/\\(*.css\\|*.scss\\)',
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
    'angular',
    'laravel',
    'rails',
    'golang',
    {
      pattern = '/path/to/file/src/app/(.*)/.*.ext$',
      target = '/path/to/file/src/view/%1/',
      transformer = 'lowercase',
    },
    unpack(ts_mappings),
    unpack(js_mappings),
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
  { noremap = true, silent = true, desc = 'l split other' }
)
vim.api.nvim_set_keymap(
  'n',
  '<leader>fV',
  '<cmd>:OtherVSplit<CR>',
  { noremap = true, silent = true, desc = 'l vsplit other' }
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
-- )
--
-- :Other	Tries to open the other/alternative file based on the configured mappings.
--   When there is a perfect match the corresponding file will be opened.
--   If there are multiple candidates, a file picker will be opened.
--   After picking a file, the two files hold an internal reference to each other.
--   In that way you only have to pick the other/alternative file once.
--   This behaviour can be turned off by setting the configuration-option rememberBuffers to false.
-- :OtherTabNew	Same as :Other but the file is opened in a new tab.
-- :OtherSplit	Same as :Other but the file is opened in a horizontal split.
-- :OtherVSplit	Same as :OtherSplit but the split is vertical.
-- :OtherClear	Clears the internal reference to the other/alternative file.
--    Afterwards a file picker will be opened again if there are multiple matches for the current file.
