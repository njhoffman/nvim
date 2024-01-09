local default_config = {
  -- Toggle debugging information
  debug = false, -- If true, logs will be saved at ~/.cache/nvim/hurl.nvim.log

  -- Set the display mode for the response: 'split' or 'popup'
  mode = 'split',

  -- Split settings
  split_position = 'right',
  split_size = '50%',

  -- Popup settings
  popup_position = '50%',
  popup_size = {
    width = 80,
    height = 40,
  },

  -- Default environment file name
  env_file = {
    'vars.env',
  },

  -- Specify formatters for different response types
  formatters = {
    json = { 'jq' }, -- Uses jq to format JSON responses
    html = {
      'prettier', -- Uses prettier to format HTML responses
      '--parser',
      'html',
    },
  },
}

local cfg = {
  debug = true, -- Enable to show detailed logs
  mode = 'popup', -- Change to 'popup' to display responses in a popup window
  env_file = { 'vars.env' }, -- Change this to use a different environment file name
  formatters = {
    json = { 'jq' }, -- Customize the JSON formatter command
    html = {
      'prettier', -- Customize the HTML formatter command
      '--parser',
      'html',
    },
  },
}
require('hurl').setup(cfg)

-- https://github.com/rest-nvim/rest.nvim/blob/main/after/queries/http/injections.scm
-- https://github.com/rest-nvim/rest.nvim/blob/main/after/queries/http/highlights.scm
--   -- Run API request
--   { "<leader>A", "<cmd>HurlRunner<CR>", desc = "Run All requests" },
--   { "<leader>a", "<cmd>HurlRunnerAt<CR>", desc = "Run Api request" },
--   { "<leader>te", "<cmd>HurlRunnerToEntry<CR>", desc = "Run Api request to entry" },
--   { "<leader>tm", "<cmd>HurlToggleMode<CR>", desc = "Hurl Toggle Mode" },
--   { "<leader>tv", "<cmd>HurlVerbose<CR>", desc = "Run Api in verbose mode" },
--   -- Run Hurl request in visual mode
--   { "<leader>h", ":HurlRunner<CR>", desc = "Hurl Runner", mode = "v" },

-- if exists("b:current_syntax") | finish | endif
--
-- syn match   httpResultComment "\v^#.*$"
-- syn keyword httpResultTitle GET POST PATCH PUT HEAD DELETE nextgroup=httpResultPath
-- syn match   httpResultPath  /.*$/ contained
--
-- syn match httpResultField /^\(\w\)[^:]\+:/he=e-1
-- syn match httpResultDateField /^[Dd]ate:/he=e-1    nextgroup=httpResultDate
-- syn match httpResultDateField /^[Ee]xpires:/he=e-1 nextgroup=httpResultDate
-- syn match httpResultDate /.*$/ contained
--
-- syn region httpResultHeader start=+^HTTP/+ end=+ + nextgroup=httpResult200,httpResult300,httpResult400,httpResult500
-- syn match  httpResult200 /2\d\d.*$/ contained
-- syn match  httpResult300 /3\d\d.*$/ contained
-- syn match  httpResult400 /4\d\d.*$/ contained
-- syn match  httpResult500 /5\d\d.*$/ contained
--
-- syn region httpResultString start=/\vr?"/ end=/\v"/
-- syn match  httpResultNumber /\v[ =]@1<=[0-9]*.?[0-9]+[ ,;&\n]/he=e-1
--
-- hi link httpResultComment   Comment
-- hi link httpResultTitle     Type
-- hi link httpResultPath      httpTSURI
-- hi link httpResultField     Identifier
-- hi link httpResultDateField Identifier
-- hi link httpResultDate      String
-- hi link httpResultString    String
-- hi link httpResultNumber    Number
-- hi link httpResultHeader    Type
-- hi link httpResult200       String
-- hi link httpResult300       Function
-- hi link httpResult400       Number
-- hi link httpResult500       Number
--
-- let b:current_syntax = "httpResult"
