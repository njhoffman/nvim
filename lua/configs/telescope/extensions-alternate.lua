local config = {
  mappings = {
    code = {
      {
        'app/routes/(.*/?)(.*).([jt]s)$',
        {
          { 'app/controllers/[1][2].[3]', 'Controller' },
        },
      },
      {
        'app/templates/(.*/?)(.*).hbs',
        {
          { 'app/controllers/[1][2].*s', 'Controller', true },
        },
      },
      {
        'app/templates/components/(.*/?)(.*).hbs',
        {
          { 'app/components/[1][2].*s', 'Component', true },
        },
      },
      {
        'tests/helpers/(.*/?)(.*)-test.([jt]s)$',
        {
          { 'app/helpers/[1][2].[3]', 'Helper' },
        },
      },
      {
        'tests/integration/components/(.*/?)(.*)-test.([jt]s)$',
        {
          { 'app/components/[1][2].[3]', 'Component' },
        },
      },
      {
        'tests/unit/controllers/(.*/?)(.*)-test.([jt]s)$',
        {
          { 'app/controllers/[1][2].[3]', 'Controller' },
        },
      },
      {
        'tests/unit/models/(.*/?)(.*)-test.([jt]s)$',
        {
          { 'app/models/[1][2].[3]', 'Model' },
        },
      },
      {
        'tests/unit/routes/(.*/?)(.*)-test.([jt]s)$',
        {
          { 'app/routes/[1][2].[3]', 'Route' },
        },
      },
      {
        'tests/unit/services/(.*/?)(.*)-test.([jt]s)',
        {
          { 'app/services/[1][2].[3]', 'Service' },
        },
      },
      {
        'tests/unit/utils/(.*/?)(.*)-test.([jt]s)$',
        {
          { 'app/utils/[1][2].[3]', 'Util' },
        },
      },
    },
    route = {
      {
        'app/controllers/(.*/?)(.*).([jt]s)$',
        {
          { 'app/routes/[1][2].[3]', 'Route' },
        },
      },
      {
        'app/templates/(.*/?)(.*).hbs',
        {
          { 'app/routes/[1][2].*s', 'Route' },
        },
      },
      {
        'tests/unit/routes/(.*/?)(.*).([jt]s)$',
        {
          { 'app/routes/[1][2].[3]', 'Route' },
        },
      },
    },
    template = {
      {
        'app/controllers/(.*/?)(.*).([jt]s)$',
        {
          { 'app/templates/[1][2].hbs', 'Template' },
        },
      },
      {
        'app/components/(.*/?)(.*).([jt]s)$',
        {
          { 'app/templates/components/[1][2].hbs', 'Template' },
        },
      },
      {
        'app/routes/(.*/?)(.*).([jt]s)$',
        {
          { 'app/templates/[1][2].hbs', 'Template' },
        },
      },
      {
        'tests/unit/controllers/(.*/?)(.*)-test.([jt]s)$',
        {
          { 'app/templates/[1][2].hbs', 'Template' },
        },
      },
      {
        'tests/integration/components/(.*/?)(.*)-test.([jt]s)$',
        {
          { 'app/templates/components/[1][2].hbs', 'Template' },
        },
      },
      {
        'tests/unit/routes/(.*/?)(.*)-test.([jt]s)$',
        {
          { 'app/templates/[1][2].hbs', 'Template' },
        },
      },
    },
    test = {
      {
        'app/components/(.*/?)(.*).([jt]s)$',
        {
          { 'tests/integration/components/[1][2]-test.[3]', 'Test' },
        },
      },
      {
        'app/templates/components/(.*/?)(.*).hbs',
        {
          { 'tests/integration/components/[1][2]-test.*s', 'Test', true },
        },
      },
      {
        'app/helpers/(.*/?)(.*).([jt]s)$',
        {
          { 'tests/helpers/[1][2]-test.[3]', 'Test' },
        },
      },
      {
        'app/controllers/(.*/?)(.*).([jt]s)$',
        {
          { 'tests/unit/controllers/[1][2]-test.[3]', 'Test' },
        },
      },
      {
        'app/models/(.*/?)(.*).([jt]s)$',
        {
          { 'tests/unit/models/[1][2]-test.[3]', 'Test' },
        },
      },
      {
        'app/routes/(.*/?)(.*).([jt]s)$',
        {
          { 'tests/unit/routes/[1][2]-test.[3]', 'Test' },
        },
      },
      {
        'app/services/(.*/?)(.*).([jt]s)$',
        {
          { 'tests/unit/services/[1][2]-test.[3]', 'Test' },
        },
      },
      {
        'app/utils/(.*/?)(.*).([jt]s)$',
        {
          { 'tests/unit/utils/[1][2]-test.[3]', 'Test' },
        },
      },
    },
    all = {
      {
        'app/components/(.*/?)(.*).([jt]s)$',
        {
          { 'app/templates/components/[1][2].hbs', 'Template' },
          { 'tests/integration/components/[1][2]-test.[3]', 'Test' },
        },
      },
      {
        'app/controllers/(.*/?)(.*).([jt]s)$',
        {
          { 'app/routes/[1][2].[3]', 'Route' },
          { 'app/templates/[1][2].hbs', 'Template' },
          { 'tests/unit/controllers/[1]-test.[3]', 'Test' },
        },
      },
      {
        'app/routes/(.*/?)(.*).([jt]s)$',
        {
          { 'app/controllers/[1][2].[3]', 'Controller' },
          { 'app/templates/[1][2].hbs', 'Template' },
          { 'tests/unit/routes/[1][2]-test.[3]', 'Test' },
        },
      },
      {
        'app/templates/(.*/?)(.*).hbs',
        {
          { 'app/controllers/[1][2].*s', 'Controller' },
          { 'app/routes/[1][2].*s', 'Route' },
          { 'tests/unit/controllers/[1][2]-test.[3]', 'Test' },
          { 'tests/unit/routes/[1][2]-test.*s', 'Test' },
        },
      },
      {
        'app/templates/components/(.*/?)(.*).hbs',
        {
          { 'app/components/[1][2].*s', 'Component', true },
          { 'tests/integration/components/[1][2]-test.*s', 'Test', true },
        },
      },
      {
        'app/models/(.*/?)(.*).([jt]s)$',
        {
          { 'tests/unit/models/[1][2]-test.[3]', 'Test' },
        },
      },
      {
        'app/helpers/(.*/?)(.*).([jt]s)$',
        {
          { 'tests/helpers/[1][2]-test.[3]', 'Test' },
        },
      },
      {
        'app/services/(.*/?)(.*).([jt]s)$',
        {
          { 'tests/unit/services/[1][2]-test.[3]', 'Test' },
        },
      },
      {
        'app/utils/(.*/?)(.*).([jt]s)$',
        {
          { 'tests/unit/utils/[1][2]-test.[3]', 'Test' },
        },
      },
      {
        'tests/integration/components/(.*/?)(.*)-test.([jt]s)$',
        {
          { 'app/components/[1][2].[3]', 'Component' },
          { 'app/templates/components/[1][2].hbs', 'Template' },
        },
      },
      {
        'tests/unit/controllers/(.*/?)(.*)-test.([jt]s)$',
        {
          { 'app/controllers/[1][2].[3]', 'Controller' },
          { 'app/templates/[1][2].hbs', 'Template' },
        },
      },
      {
        'tests/unit/routes/(.*/?)(.*)-test.([jt]s)$',
        {
          { 'app/routes/[1][2].[3]', 'Route' },
          { 'app/templates/[1][2].hbs', 'Template' },
        },
      },
      {
        'tests/unit/models/(.*/?)(.*)-test.([jt]s)$',
        {
          { 'app/models/[1][2].[3]', 'Model' },
        },
      },
      {
        'tests/helpers/(.*/?)(.*)-test.([jt]s)$',
        {
          { 'app/helpers/[1][2].[3]', 'Helper' },
        },
      },
      {
        'tests/unit/services/(.*/?)(.*)-test.([jt]s)',
        {
          { 'app/services/[1][2].[3]', 'Service' },
        },
      },
      {
        'tests/unit/utils/(.*/?)(.*)-test.([jt]s)$',
        {
          { 'app/utils/[1][2].[3]', 'Util' },
        },
      },
    },
    presets = {},
  },
}
-- This fork adds support for switching directly to one of multiple alternates by including a focus option when opening this extension.
-- The focus option matches with a nested mappings object in the same format as the standard mappings documented above.
-- The standard mappings have been moved to `mappings.all`, and might be useful for splits/tabs or peeking.
-- Each of the nested focus mapping groups contain a single alternate match target for a source file.
-- `focus=template` will match against `mappings.template.`
-- Here is an example that supports a default Ember 4.28 project with direct access between code, templates, routes, and tests
-- using `<Leader> c`, `h`, `r`, and `t`.

local create_keymaps = function()
  local map = require("mapper").map
  map('n', '<Leader>c', ':Telescope telescope-alternate alternate_file focus=code<cr>')
  map('n', '<Leader>h', ':Telescope telescope-alternate alternate_file focus=template<cr>')
  map('n', '<Leader>r', ':Telescope telescope-alternate alternate_file focus=route<cr>')
  map('n', '<Leader>t', ':Telescope telescope-alternate alternate_file focus=test<cr>')
  map('n', '<Leader>a', ':Telescope telescope-alternate alternate_file<cr>')
end

-- create_keymaps()

return config

-- mappings = {

--   -- Laravel l10
--   {
--     "(.*)/Models/(.*).php",
--     {
--       -- {"[1]/Models/[2].php", "Model", true},
--       { "[1]/Http/Controllers/[2]Controller.php",               "Controller", true },
--       { "[1]/Http/Requests/[2:pluralize]/",                     "Request",    true },
--       { "[1]/../resources/views/[2:pluralize,camel_to_snake]/", "View",       true },
--     },
--   },
--   {
--     "(.*)/Http/Controllers/(.*).php",
--     {
--       { "[1]/Models/[2:strip_controller].php",                  "Model",   true },
--       -- {"[1]/Http/Controllers/[2].php", "Controller", true},
--       { "[1]/Http/Requests/[2:strip_controller,pluralize]/",    "Request", true },
--       { "[1]/../resources/views/[2:pluralize,camel_to_snake]/", "View",    true },
--       { "[1]/../resources/views/[2:pluralize,camel_to_snake]/", "View",    true },
--     },
--   },
--   {
--     "(.*)/Http/Requests/(.*)/(.*).php",
--     {
--       { "[1]/Models/[2:singularize].php",                       "Model",      true },
--       { "[1]/Http/Controllers/[2:singularize]Controller.php",   "Controller", true },
--       { "[1]/Http/Requests/[2]/",                               "Request",    true },
--       { "[1]/../resources/views/[2:pluralize,camel_to_snake]/", "View",       true },
--     },
--   },
--   {
--     -- "(.*)/resources/views/([^/])/(.*)",
--     "(.*)resources/views/(.*)/(.*).blade.php",
--     {
--       {
--         "[1]app/Models/[2:singularize,snake_to_pascal].php",
--         "Model",
--         true,
--       },
--       {
--         "[1]app/Http/Controllers/[2:singularize,snake_to_pascal]Controller.php",
--         "Controller",
--         true,
--       },
--       {
--         "[1]app/Http/Requests/[2:snake_to_pascal]/",
--         "Request",
--         true,
--       },
--       { "[1]resources/views/[2]/", "View", true },
--     },
--   },

--   -- OctoberCMS
--   {
--     "(.*)/models/(.*).php",
--     {
--       { "[1]/controllers/[2:pluralize].php",       "Controller",   true },
--       { "[1]/controllers/[2:pluralize,lower]/*.*", "Controller-F", true },
--       { "[1]/models/[2].php",                      "Model",        true },
--       { "[1]/models/[2:lower]/*.*",                "Model-F",      true },
--     },
--   },
--   {
--     "(.*)/controllers/(.*).php",
--     {
--       { "[1]/controllers/[2:pluralize].php",       "Controller",   true },
--       { "[1]/controllers/[2:pluralize,lower]/*.*", "Controller-F", true },
--       { "[1]/models/[2:singularize].php",          "Model",        true },
--       { "[1]/models/[2:singularize,lower]/*.*",    "Model-F",      true },
--     },
--   },
-- },
-- presets = {}, -- Telescope pre-defined mapping presets
-- transformers = {

--   lower = lower,

--   upper = function(w)
--     return string.upper(w)
--   end,

--   strip_controller = function(w)
--     return string.sub(w, 1, -11)
--   end,

--   camel_to_snake = function(inputString)
--     local pathParts = {}

--     inputString:gsub("%w+[^/]", function(str)
--       table.insert(pathParts, str)
--     end)

--     for i, part in pairs(pathParts) do
--       local camelParts = {}
--       part:gsub("%u%l+", function(str)
--         table.insert(camelParts, str:lower())
--       end)
--       pathParts[i] = table.concat(camelParts, "_")
--     end
--     return table.concat(pathParts, "/")
--   end,

--   snake_to_pascal = function(inputString)

--     inputString = inputString:gsub("^%l", string.upper)

--     local pathParts = {}

--     inputString:gsub("[%w-_]+[^/]", function(str)
--       table.insert(pathParts, str)
--     end)

--     for i, part in pairs(pathParts) do
--       local tmp = ""
--       for key in part:gmatch("[^_]+") do
--         tmp = tmp .. key:sub(1, 1):upper() .. key:sub(2)
--       end
--       pathParts[i] = tmp
--     end

--     return table.concat(pathParts, "/")
--   end,
-- },
-- mappings = {
--   -- cpp/hpp
--   { pattern = "(.*).cpp", targets = {
--       { template = "[1].hpp", label = "C++ Header", enable_new = true }
--   }},
--   { pattern = "(.*).hpp", targets = {
--       { template = "[1].cpp", label = "C++ Source", enable_new = true }
--   }},
-- },
-- open_only_one_with = 'current_pane',
-- mappings = {

--   {
--     'app/services/(.*)_services/(.*).rb',
--     { -- alternate from services to contracts / models
--       { 'app/contracts/[1]_contracts/[2].rb', 'Contract' }, -- Adding label to switch
--       { 'app/models/**/*[1].rb', 'Model', true }, -- Ignore create entry (with true)
--     },
--   },
--   {
--     'app/contracts/(.*)_contracts/(.*).rb',
--     { { 'app/services/[1]_services/[2].rb', 'Service' } },
--   }, -- from contracts to services
--   -- Search anything on helper folder that contains pluralize version of model.
--   --Example: app/models/user.rb -> app/helpers/foo/bar/my_users_helper.rb
--   { 'app/models/(.*).rb', { { 'db/helpers/**/*[1:pluralize]*.rb', 'Helper' } } },

--   -- -- You also can use the verbose way to mapping:
--   -- mappings = {
--   --   { pattern = 'app/services/(.*)_services/(.*).rb', targets = {
--   --       { template =  'app/contracts/[1]_contracts/[2].rb', label = 'Contract', enable_new = true } -- enable_new can be a function too.
--   --     }
--   --   },
--   --   { pattern = 'app/contracts/(.*)_contracts/(.*).rb', targets = {
--   --       { template =  'app/services/[1]_services/[2].rb', label = 'Service', enable_new = true }
--   --     }
--   --   },
--   -- }     { 'app/**/*.rb', { { 'spec/[1].rb', 'Test' } } }, -- Alternate between file and test
--   -- Another example:
--   -- { 'app/models/(.*).rb', {
--   --   { 'db/helpers/**/*[1]*.rb', 'Helper' } },
--   --   { 'app/controllers/**/*[1:pluralize]_controller.rb', 'Controller' } },
--   -- },
-- -- },
-- presets = { 'rails', 'rspec', 'nestjs', 'angular' }, -- Telescope pre-defined mapping presets
-- open_only_one_with = 'current_pane', -- when just have only possible file, open it with.  Can also be horizontal_split and vertical_split
-- transformers = { -- custom transformers
--   change_to_uppercase = function(w)
--     return my_uppercase_method(w)
--   end,
-- },
-- ----
-- telescope_mappings = { -- Change the telescope mappings
--   i = {
--     open_current = '<CR>',
--     open_horizontal = '<C-s>',
--     open_vertical = '<C-v>',
--     open_tab = '<C-t>',
--   },
--   n = {
--     open_current = '<CR>',
--     open_horizontal = '<C-s>',
--     open_vertical = '<C-v>',
--     open_tab = '<C-t>',
--   }
-- }
