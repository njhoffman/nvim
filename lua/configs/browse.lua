-- require('browse.devdocs').search_with_filetype()
-- require('browse.mdn').search()
require("browse").setup({
  -- search provider you want to use
  provider = "google", -- duckduckgo, bing
  -- either pass it here or just pass the table to the functions
  -- see below for more
  bookmarks = {},
  icons = {
    bookmark_alias = "->", -- if you have nerd fonts, you can set this to ""
    bookmarks_prompt = "", -- if you have nerd fonts, you can set this to "󰂺 "
    grouped_bookmarks = "->", -- if you have nerd fonts, you can set this to 
  },
})

--   function command(name, rhs, opts)
--     opts = opts or {}
--     vim.api.nvim_create_user_command(name, rhs, opts)
--   end

--   command('InputSearch', function()
--     browse.input_search()
--   end, {})

--   command('Bookmarks', function()
--     browse.open_bookmarks({ bookmarks = bookmarks })
--   end)

--   command('DevdocsSearch', function()
--     browse.devdocs.search()
--   end)

--   command('DevdocsFiletypeSearch', function()
--     browse.devdocs.search_with_filetype()
--   end)

--   command('MdnSearch', function()
--     browse.mdn.search()
--   end)
